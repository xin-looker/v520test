view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      day_of_week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [created_month, count]
  }

  measure: count_user {
    type: number
    drill_fields: [created_month, count]
    sql: count(${user_id}) ;;
  }

  measure: count_distinct_users {
    type: number
    sql: count(distinct ${user_id});;
  }

  measure: average_times {
    type: number
    sql: ${count_user}/${count_distinct_users}*1.0 ;;
  }

}
