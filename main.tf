resource "aws_glue_crawler" "this" {
    for_each = local.raw_glue_crawlers

  database_name = each.value.glue_database
  name          = each.key
  role          = aws_iam_role.glue_crawlers_role.id

#   configuration = local.configuration
#   classifiers   = var.classifiers
  description   = each.value.description
#   recrawl_policy {
#     recrawl_behavior = var.recrawl_behavior
#   }
  s3_target {
    path                = each.value.s3_table_path
  }
#   schedule = var.schedule
#   schema_change_policy {
#     delete_behavior = var.delete_behavior
#     update_behavior = var.update_behavior
#   }
}
