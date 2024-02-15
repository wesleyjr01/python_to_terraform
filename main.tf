# Using locals to simplify the creation of Glue tables
locals {
  glue_tables = flatten([
    for db_name, db_details in var.glue_databases_and_tables : [
      for table_name, table_details in db_details.tables : {
        db_name    = db_name
        table_name = table_name
        pk         = table_details.pk
        workers    = table_details.workers
      }
    ]
  ])
}

# Create Glue Databases
resource "aws_glue_catalog_database" "glue_database" {
  for_each = var.glue_databases_and_tables

  name = each.key
}

# Create Glue Tables
resource "aws_glue_catalog_table" "glue_table" {
  for_each = { for table in local.glue_tables : "${table.db_name}_${table.table_name}" => table }

  database_name = each.value.db_name
  name          = each.value.table_name
  # Additional table configuration goes here, potentially using each.value.pk and each.value.workers as needed
}
