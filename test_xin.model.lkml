connection: "thelook"

# include all the views
include: "*.view"

datagroup: test_xin_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: test_xin_default_datagroup
