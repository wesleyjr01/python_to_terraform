variable "region" {
  description = "The AWS region to deploy to."
  default     = "us-east-1" 
}

variable "raw_s3_path" {
  default = "s3://my_bucket/raw_data"
}

variable "staging_s3_path" {
  default = "s3://my_bucket/staging_data"
}

# Define a complex variable to mimic the Python dictionary structure
variable "glue_databases_and_tables" {
  description = "A map of Glue database names to their tables and configurations"
  type = map(object({
    tables = map(object({
      pk      = string
      workers = number
    }))
  }))
  default = {
    raw_postgres_db = {
      tables = {
        customers = { pk = "id", workers = 2 },
        orders    = { pk = "id", workers = 2 }
      }
    },
    staging_postgres_db = {
      tables = {
        customers = { pk = "id", workers = 2 },
        orders    = { pk = "id", workers = 2 }
      }
    }
  }
}