locals {
  raw_s3_path     = "s3://raw_bucket"
  staging_s3_path = "s3://staging_bucket"

  raw_glue_databases_and_tables = {
    "raw_postgres_db" = {
      "customers" = {
        pk                       = "id"
        workers                  = 2
        worker_type              = "G.1X"
        duplicate_ranking_column = "created_at"
        data_source              = "postgres"
        write_partition_fields   = "updated_at"
      }
      "orders" = {
        pk                       = "id"
        workers                  = 2
        worker_type              = "G.1X"
        duplicate_ranking_column = "sale_date"
        data_source              = "postgres"
      }
    }
    "raw_salesforce_db" = {
      "sf_customers" = {
        pk                       = "id"
        workers                  = 2
        worker_type              = "G.1X"
        duplicate_ranking_column = "created_at"
        data_source              = "salesforce"
      }
      "sf_orders" = {
        pk                       = "id"
        workers                  = 2
        worker_type              = "G.1X"
        duplicate_ranking_column = "created_at"
        data_source              = "salesforce"
      }
    }
  }

  raw_glue_databases = keys(local.raw_glue_databases_and_tables)

  raw_glue_tables = flatten([
    for db, tables in local.raw_glue_databases_and_tables : [
      for table, config in tables : {
        glue_database            = db
        table                    = table
        pk                       = config.pk
        workers                  = try(config.workers, 2)
        worker_type              = try(config.worker_type, "G.1X")
        duplicate_ranking_column = config.duplicate_ranking_column
        s3_table_path            = "${local.raw_s3_path}/${config.data_source}/${db}/${table}"
        write_partition_fields   = try(config.write_partition_fields, "NONE")
      }
    ]
  ])

  raw_glue_crawlers = {
    for map_ in local.raw_glue_tables : "${map_.glue_database}_${map_.table}" => {
      glue_database = "${map_.glue_database}"
      table         = map_.glue_database
      s3_table_path = map_.s3_table_path
      description   = "Crawler that reads data from table ${map_.table} and populates it's metadata on database ${map_.glue_database}"
    }
  }

}


