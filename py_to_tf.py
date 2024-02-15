raw_s3_path = "s3://raw_bucket"
staging_s3_path = "s3://staging_bucket"

raw_glue_databases_and_tables = {
    "raw_postgres_db": {
        "customers": {
            "pk": "id",
            "workers": 2,
            "worker_type": "G.1X",
            "duplicate_ranking_column": "created_at",
            "data_source": "postgres",
        },
        "orders": {
            "pk": "id",
            "workers": 2,
            "worker_type": "G.1X",
            "duplicate_ranking_column": "created_at",
            "data_source": "postgres",
        },
    },
    "raw_salesforce_db": {
        "sf_customers": {
            "pk": "id",
            "workers": 2,
            "worker_type": "G.1X",
            "duplicate_ranking_column": "created_at",
            "data_source": "salesforce",
        },
        "sf_orders": {
            "pk": "id",
            "workers": 2,
            "worker_type": "G.1X",
            "duplicate_ranking_column": "created_at",
            "data_source": "salesforce",
        },
    },
}

# result -> glue_databases = ['raw_postgres_db', 'staging_postgres_db']
raw_glue_databases = list(raw_glue_databases_and_tables.keys())

# Glue Tables
raw_glue_tables = []
for db in raw_glue_databases_and_tables:
    for table in raw_glue_databases_and_tables[db]:
        raw_glue_tables.append(
            {
                "glue_database": db,
                "table": table,
                "pk": raw_glue_databases_and_tables[db][table]["pk"],
                "workers": raw_glue_databases_and_tables[db][table]["workers"],
                "worker_type": raw_glue_databases_and_tables[db][table]["worker_type"],
                "duplicate_ranking_column": raw_glue_databases_and_tables[db][table][
                    "duplicate_ranking_column"
                ],
                "s3_table_path": f"{raw_s3_path}/{raw_glue_databases_and_tables[db][table]['data_source']}/{db}/{table}",
            }
        )

# print
for table in raw_glue_tables:
    print(table)


# create terraform code that returns the same glue_databases as shows above
