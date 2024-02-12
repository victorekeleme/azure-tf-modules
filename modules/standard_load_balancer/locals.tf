# product-env-appname

locals {
  resource_prefix = "${var.product_name}-${var.environment}"
  lb_name         = "${local.resource_prefix}-${var.lb_name}-lb"


  virtual_machine_nic_ids = null# data.terraform_remote_state.vm_remote_state.outputs.virtual_machine_nic_ids

  common_tags = {
    product_name = var.product_name
    environment  = var.environment
    location     = var.resource_group_location
    owner        = var.owner
    team         = var.team
  }
}
