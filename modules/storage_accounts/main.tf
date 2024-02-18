# resource "random_string" "this" {
#   length  = 4
#   upper   = false
#   special = false
#   numeric = false
# }

resource "azurerm_storage_account" "this" {
  name                     = "${local.sa_short_name}sac"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = var.account_tier != null ? var.account_tier : "Standard"
  account_kind             = var.account_kind != null ? var.account_kind : "StorageV2"
  account_replication_type = var.account_replication_type != null ? var.account_replication_type : "LRS"

  dynamic "network_rules" {
    for_each = var.storage_network_rules != null ? var.storage_network_rules : {}
    content {
      default_action             = title("${each.key}")
      virtual_network_subnet_ids = ["${each.value}"]
      # ip_rules                   = ["100.0.0.1"] # used for controlling access over the public internet
    }
  }

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  tags = local.common_tags
}

resource "azurerm_storage_container" "this" {
  for_each = var.storage_container != null ? var.storage_container : {}
  name                  = "${each.key}"
  storage_account_name = azurerm_storage_account.this.name
  container_access_type = "${each.value}" != null ? "${each.value}" : "private"
}


resource "azurerm_storage_blob" "this" {
  for_each = var.storage_blobs != null ? var.storage_blobs : {}
  name                   = "${each.value.name}"
  storage_account_name  = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.this[each.value.storage_container].name
  type                   = title("${each.value.type}")
  source                 = "${each.value.source}"
}


