resource "null_resource" "kubeconfig" {
  depends_on = [aws_eks_node_group.main]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.env}"
  }
}


resource "null_resource" "metrics-server" {
  depends_on = [null_resource.kubeconfig]

  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
  }
}

resource "helm_release" "kube-prometheus-stack" {
  depends_on = [null_resource.kubeconfig, helm_release.ingress, helm_release.cert-manager]
  name       = "kube-prom-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"


  values = [
    file("${path.module}/helm-config/prom-stack-${var.env}.yaml")
  ]
}




resource "helm_release" "ingress" {
  depends_on = [null_resource.kubeconfig]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  values = [
    file("${path.module}/helm-config/ingress.yaml")
  ]
}


resource "helm_release" "cert-manager" {
  depends_on = [null_resource.kubeconfig]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace = "cert-manager"
  create_namespace = true

  set {
      name = "crds.enabled"
      value = "true"
    }
}

resource "null_resource" "cert-manager-cluster-issuer" {
  depends_on = [null_resource.kubeconfig, helm_release.cert-manager]

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/helm-config/cluster-issuer.yaml"
  }
}

resource "helm_release" "external-dns" {
  depends_on = [null_resource.kubeconfig]
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
}


resource "helm_release" "argocd" {
  depends_on = [null_resource.kubeconfig, helm_release.external-dns, helm_release.ingress, helm_release.cert-manager]

  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  wait             = false

  set {
    name  = "global.domain"
    value = "argocd-${var.env}.salman06.shop"
  }

  values = [
    file("${path.module}/helm-config/argocd.yaml")
  ]
}

## Filebeat Helm Chart
resource "helm_release" "filebeat" {

  depends_on = [null_resource.kubeconfig]
  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  namespace  = "kube-system"
  wait       = "false"

  values = [
    file("${path.module}/helm-config/filebeat.yml")
  ]
}

#$ helm repo add autoscaler https://kubernetes.github.io/autoscaler
#helm install my-release autoscaler/cluster-autoscaler \
#    --set 'autoDiscovery.clusterName'=<CLUSTER NAME>

# Cluster Autoscaler

resource "helm_release" "cluster-autoscaler" {

  depends_on = [null_resource.kubeconfig]
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  wait       = "false"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.env
  }
  set {
    name  = "awsRegion"
    value = "us-east-1"
  }
}


# External Secrets

resource "helm_release" "external-secrets" {

  depends_on = [null_resource.kubeconfig]
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "kube-system"
  wait       = "false"

  set {
    name  = "installCRDs"
    value = true
  }
}

resource "null_resource" "external-secret-store" {
  depends_on = [null_resource.kubeconfig, helm_release.external-secrets]
  provisioner "local-exec" {
    command = <<EOF
until kubectl get crd clustersecretstores.external-secrets.io >/dev/null 2>&1; do
  echo "Waiting for CRD clustersecretstores.external-secrets.io..."
  sleep 5
done
kubectl apply -f - <<EOK
apiVersion: v1
kind: Secret
metadata:
  name: vault-token
data:
  token: aHZzLlZWYkcwdWp5eUR4WFh5Yjc5bVNqTTh1YQ==

---
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "http://vault-internal.salman06.shop:8200"
      path: "roboshop-${var.env}"
      version: "v2"
      auth:
        tokenSecretRef:
          name: "vault-token"
          key: "token"
EOK
EOF
}
}


# Config Reloader

resource "helm_release" "wave-config-reloader" {

  depends_on = [null_resource.kubeconfig, helm_release.cert-manager]
  name       = "wave"
  repository = "https://wave-k8s.github.io/wave/"
  chart      = "wave"
  namespace  = "kube-system"
  wait       = "false"

  set {
    name  = "webhooks.enabled"
    value = true
  }
}