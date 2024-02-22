module "alicloud_log_project" {
  source = "../../modules/alicloud_sls/alicloud_log_project"

  region            = var.region
  project_name      = local.log_project_name
  resource_group_id = var.resource_group_id
}


module "alicloud_log_store" {
  source = "../../modules/alicloud_sls/alicloud_log_store"

  region      = var.region
  log_project = module.alicloud_log_project.id
}

module "alicloud_log_store_index" {
  source = "../../modules/alicloud_sls/alicloud_log_store_index"

  region      = var.region
  log_project = module.alicloud_log_project.id
  log_store   = module.alicloud_log_store.log_store_name
}

module "alicloud_log_machine_group" {
  source = "../../modules/alicloud_sls/alicloud_log_machine_group"

  region        = var.region
  log_project = module.alicloud_log_project.id
  name          = "k8s-machine-group"
  identify_list = local.identify_list
}


module "alicloud_logtail_config" {
  source = "../../modules/alicloud_sls/alicloud_logtail_config"

  region      = var.region
  log_project = module.alicloud_log_project.id
  log_store_map = {
    log    = module.alicloud_log_store.log_store_name
    metric = module.alicloud_log_store.metric_store_name
  }
}

module "alicloud_logtail_attachment" {
  source = "../../modules/alicloud_sls/alicloud_logtail_attachment"

  region              = var.region
  log_project = module.alicloud_log_project.id
  machine_group       = module.alicloud_log_machine_group.machine_group_name
  logtail_config_list = module.alicloud_logtail_config.logtail_config_list
}

resource "local_file" "logtail_configmap" {
  content  = <<-EOT
apiVersion: v1
data:
  access-key-id: no use
  access-key-secret: no use
  cpu-core-limit: '1'
  log-ali-uid: '${local.my_account}'
  log-config-path: '/etc/ilogtail/conf/${var.region}/ilogtail_config.json'
  log-endpoint: '${var.region}-intranet.log.aliyuncs.com'
  log-machine-group: '${join(",", local.identify_list)}'
  log-project: '${local.log_project_name}'
  max-bytes-per-sec: '20971520'
  mem-limit: '256'
  send-requests-concurrency: '20'
kind: ConfigMap
metadata:
  name: logtail-cfg
  namespace: kube-system
EOT
  filename = "${var.working_dir}/kube/manifest/logtail-configmap.yaml"
}

resource "local_file" "logtail_daemonset" {
  content  = <<-EOT
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    k8s-app: logtail-ds
  name: logtail-ds
  namespace: kube-system
spec:
  selector:
    matchLabels:
      k8s-app: logtail-ds
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        k8s-app: logtail-ds
    spec:
      containers:
      - env:
        - name: HTTP_PROBE_PORT
          value: '7953'
        - name: ALIYUN_LOGTAIL_CONFIG
          valueFrom:
            configMapKeyRef:
              key: log-config-path
              name: logtail-cfg
        - name: ALIYUN_LOGTAIL_USER_ID
          valueFrom:
            configMapKeyRef:
              key: log-ali-uid
              name: logtail-cfg
        - name: ALICLOUD_LOG_ACCESS_KEY_ID
          valueFrom:
            configMapKeyRef:
              key: access-key-id
              name: logtail-cfg
        - name: ALICLOUD_LOG_ACCESS_KEY_SECRET
          valueFrom:
            configMapKeyRef:
              key: access-key-secret
              name: logtail-cfg
        - name: ALICLOUD_LOG_DOCKER_ENV_CONFIG
          value: 'true'
        - name: ALICLOUD_LOG_ECS_FLAG
          value: 'false'
        - name: ALICLOUD_LOG_DEFAULT_PROJECT
          valueFrom:
            configMapKeyRef:
              key: log-project
              name: logtail-cfg
        - name: ALICLOUD_LOG_ENDPOINT
          valueFrom:
            configMapKeyRef:
              key: log-endpoint
              name: logtail-cfg
        - name: ALICLOUD_LOG_DEFAULT_MACHINE_GROUP
          valueFrom:
            configMapKeyRef:
              key: log-machine-group
              name: logtail-cfg
        - name: ALIYUN_LOGTAIL_USER_DEFINED_ID
          value: $(ALICLOUD_LOG_DEFAULT_MACHINE_GROUP)
          valueFrom: null
        - name: ALIYUN_LOG_ENV_TAGS
          value: _node_name_|_node_ip_
        - name: _node_name_
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        - name: _node_ip_
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: cpu_usage_limit
          valueFrom:
            configMapKeyRef:
              key: cpu-core-limit
              name: logtail-cfg
        - name: mem_usage_limit
          valueFrom:
            configMapKeyRef:
              key: mem-limit
              name: logtail-cfg
        - name: max_bytes_per_sec
          valueFrom:
            configMapKeyRef:
              key: max-bytes-per-sec
              name: logtail-cfg
        - name: send_request_concurrency
          valueFrom:
            configMapKeyRef:
              key: send-requests-concurrency
              name: logtail-cfg
        - name: user_config_file_path
          value: /etc/ilogtail/checkpoint/user_log_config.json
        - name: docker_file_cache_path
          value: /etc/ilogtail/checkpoint/docker_path_config.json
        - name: check_point_filename
          value: /etc/ilogtail/checkpoint/logtail_check_point
        - name: check_point_dump_interval
          value: '60'
        - name: buffer_file_path
          value: /etc/ilogtail/checkpoint
        - name: ALIYUN_LOGTAIL_OBSERVER
          value: 'true'
        - name: HOST_PROC
          value: /logtail_host/proc
        - name: HOST_SYS
          value: /logtail_host/sys
        - name: HOST_ETC
          value: /logtail_host/etc
        - name: HOST_VAR
          value: /logtail_host/var
        - name: HOST_RUN
          value: /logtail_host/run
        - name: HOST_DEV
          value: /logtail_host/dev
        image: registry.${var.region}.aliyuncs.com/log-service/logtail:v1.6.0-without-deps.0-aliyun
        imagePullPolicy: Always
        livenessProbe:
          httpGet:
            path: /liveness
            port: 7953
            scheme: HTTP
          initialDelaySeconds: 30
          periodSeconds: 60
        name: logtail
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /liveness
            port: 7953
            scheme: HTTP
          initialDelaySeconds: 35
          periodSeconds: 60
          successThreshold: 1
          timeoutSeconds: 1
        resources:
          limits:
            cpu: 2000m
            memory: 3Gi
          requests:
            cpu: 10m
            memory: 200Mi
        securityContext:
          allowPrivilegeEscalation: true
          privileged: true
          procMount: Default
        volumeMounts:
        - mountPath: /var/run/
          name: run
        - mountPath: /logtail_host
          mountPropagation: HostToContainer
          name: root
          readOnly: true
        - mountPath: /etc/ilogtail/checkpoint
          name: checkpoint
        - mountPath: /etc/ilogtail/ebpf/
          name: ebpf
        - mountPath: /sys
          name: sys
          readOnly: true
        - mountPath: /etc/ilogtail/agent-install
          name: dependencies
      dnsPolicy: ClusterFirstWithHostNet
      hostNetwork: true
      hostPID: true
      initContainers:
      - command:
        - /bin/sh
        - -c
        - cp -r /etc/ilogtail/agent-install/* /share
        image: registry.${var.region}.aliyuncs.com/log-service/logtail:v1.6.0-libs-aliyun
        imagePullPolicy: Always
        name: deps
        volumeMounts:
        - mountPath: /share
          name: dependencies
      priorityClassName: system-cluster-critical
      serviceAccountName: default
      terminationGracePeriodSeconds: 30
      tolerations:
      - operator: Exists
      volumes:
      - hostPath:
          path: /var/run/
        name: run
      - hostPath:
          path: /
        name: root
      - hostPath:
          path: /var/lib/kube-system-logtail-ds/checkpoint
          type: DirectoryOrCreate
        name: checkpoint
      - hostPath:
          path: /sys
          type: Directory
        name: sys
      - hostPath:
          path: /var/lib/kube-system-logtail-ds/ebpf
          type: DirectoryOrCreate
        name: ebpf
      - emptyDir: {}
        name: dependencies
EOT
  filename = "${var.working_dir}/kube/manifest/logtail-daemonset.yaml"
}
