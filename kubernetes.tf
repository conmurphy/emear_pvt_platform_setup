
# resource "kubernetes_namespace" "kubernetes_namespace" {
#   for_each =  toset(var.applications)
#   metadata {
#      name = each.key
#   }
# }

# resource "kubernetes_service_account" "kubernetes_service_account" {
#   for_each =  toset(var.applications)

#   metadata {
#     name = each.key
#     namespace = each.key
#   }
  
# }

# resource "kubernetes_role" "kubernetes_role" {
#   for_each =  toset(var.applications)

#   metadata {
#     name = each.key
#     namespace = each.key
#   }

#   rule {
#     api_groups     = ["*"]
#     resources      = ["namespaces","pods","persistentvolumes","persistentvolumeclaims","configmaps","secrets","replicasets","deployments","daemonsets","statefulsets", "services", "ingresses"]
#     verbs          = ["get","list","watch","create","update","patch","delete"]
#   }
  
# }

# resource "kubernetes_role_binding" "role_binding" {
#   for_each =  toset(var.applications)

#   metadata {
#     name      = each.key
#     namespace = each.key
#   }
#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = each.key
#   }
#   subject {
#     kind      = "ServiceAccount"
#     name      = each.key
#     namespace = each.key
#     api_group = ""
#   }
#    depends_on = [kubernetes_role.kubernetes_role]
# }
