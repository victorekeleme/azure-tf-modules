# product-env-appname

locals {
  resource_prefix      = var.product_name
  storage_account_name = var.environment != null ? "${local.resource_prefix} ${var.environment} ${var.storage_account_name}" : "${local.resource_prefix} ${var.storage_account_name}"
  sa_short_name = join("",[for word in split(" ", local.storage_account_name) : substr(word, 0 , 5)])

  # Function to calculate the square of a number
  # square = {
  #   for key, value in var.numbers :
  #   key => value * value
  # }



  
  common_tags = {
    product_name = var.product_name
    location     = var.resource_group_location
    owner        = var.owner
    team         = var.team
  }

}

