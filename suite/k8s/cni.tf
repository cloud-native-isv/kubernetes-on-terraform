
resource "local_file" "flannel_configmap" {
  content  = <<-EOT
apiVersion: v1
data:
  cni-conf.json: "{\n  \"name\": \"cbr0\",\n  \"cniVersion\": \"0.3.1\",\n  \"plugins\"\
    : [\n    {\n      \"type\": \"flannel\",\n      \"delegate\": {\n        \"hairpinMode\"\
    : true,\n        \"isDefaultGateway\": true\n      }\n    },\n    {\n      \"\
    type\": \"portmap\",\n      \"capabilities\": {\n        \"portMappings\": true\n\
    \      }\n    }\n  ]\n}\n"
  net-conf.json: "{\n  \"Network\": \"10.244.0.0/16\",\n  \"Backend\": {\n    \"Type\"\
    : \"vxlan\"\n  }\n}\n"
kind: ConfigMap
metadata:
  labels:
    app: flannel
    k8s-app: flannel
    tier: node
  name: flannel-cfg
  namespace: kube-system
EOT
  filename = "${var.working_dir}/kube/manifest/flannel-configmap.yaml"
}

resource "local_file" "flannel_daemonset" {
  content = <<-EOT
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: flannel
    k8s-app: flannel
    tier: node
  name: flannel-ds
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: flannel
  updateStrategy:
    type: updateStrategy
  template:
    metadata:
      labels:
        app: flannel
        tier: node
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/os
                operator: In
                values:
                - linux
      containers:
      - args:
        - --ip-masq
        - --kube-subnet-mgr
        command:
        - /opt/bin/flanneld
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: EVENT_QUEUE_DEPTH
          value: '5000'
        image: docker.io/flannel/flannel:v0.24.2
        name: kube-system
        resources:
          requests:
            cpu: 100m
            memory: 50Mi
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
            - NET_RAW
          privileged: false
        volumeMounts:
        - mountPath: /run/flannel
          name: run
        - mountPath: /etc/kube-flannel
          name: flannel-cfg
        - mountPath: /run/xtables.lock
          name: xtables-lock
      hostNetwork: true
      initContainers:
      - args:
        - -f
        - /flannel
        - /opt/cni/bin/flannel
        command:
        - cp
        image: docker.io/flannel/flannel-cni-plugin:v1.4.0-flannel1
        name: install-cni-plugin
        volumeMounts:
        - mountPath: /opt/cni/bin
          name: cni-plugin
      - args:
        - -f
        - /etc/kube-flannel/cni-conf.json
        - /etc/cni/net.d/10-flannel.conflist
        command:
        - cp
        image: docker.io/flannel/flannel:v0.24.2
        name: install-cni
        volumeMounts:
        - mountPath: /etc/cni/net.d
          name: cni
        - mountPath: /etc/kube-flannel
          name: flannel-cfg
      priorityClassName: system-node-critical
      serviceAccountName: flannel
      tolerations:
      - effect: NoSchedule
        operator: Exists
      volumes:
      - hostPath:
          path: /run/flannel
        name: run
      - hostPath:
          path: /opt/cni/bin
        name: cni-plugin
      - hostPath:
          path: /etc/cni/net.d
        name: cni
      - configMap:
          name: flannel-cfg
        name: flannel-cfg
      - hostPath:
          path: /run/xtables.lock
          type: FileOrCreate
        name: xtables-lock
EOT

  filename = "${var.working_dir}/kube/manifest/flannel-daemonset.yaml"
}



resource "local_file" "flannel_clusterrole" {
  content  = <<-EOT
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    k8s-app: flannel
  name: flannel
rules:
- apiGroups:
  - ''
  resources:
  - pods
  verbs:
  - get
- apiGroups:
  - ''
  resources:
  - nodes
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ''
  resources:
  - nodes/status
  verbs:
  - patch
- apiGroups:
  - networking.k8s.io
  resources:
  - clustercidrs
  verbs:
  - list
  - watch
EOT
  filename = "${var.working_dir}/kube/manifest/flannel-clusterrole.yaml"
}


resource "local_file" "flannel_clusterrolebinding" {
  content  = <<-EOT
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    k8s-app: flannel
  name: flannel
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: flannel
subjects:
- kind: ServiceAccount
  name: flannel
  namespace: kube-system
EOT
  filename = "${var.working_dir}/kube/manifest/flannel-clusterrolebinding.yaml"
}

resource "local_file" "flannel_serviceaccount" {
  content  = <<-EOT
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: flannel
  name: flannel
  namespace: kube-system
EOT
  filename = "${var.working_dir}/kube/manifest/flannel-serviceaccount.yaml"
}

