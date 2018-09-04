connection: "thelook"

include: "*.view.lkml"                       # include all views in this project
# view: order_items {
#   sql_table_name: demo_db.order_items ;;
#
#   dimension: id {
#     primary_key: yes
#     type: number
#     sql: ${TABLE}.id ;;
#   }
#
#   dimension: inventory_item_id {
#     type: number
#     # hidden: yes
#     sql: ${TABLE}.inventory_item_id ;;
#   }
#
#   dimension: order_id {
#     type: number
#     # hidden: yes
#     sql: ${TABLE}.order_id ;;
#     html:  {% if inventory_item_id._is_selected %}A{% else if inventory_item_id._is_filtered %}B{% endif %} ;;
#   }
#
#   dimension_group: returned {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: ${TABLE}.returned_at ;;
#   }
#
#   dimension: sale_price {
#     type: number
#     sql: ${TABLE}.sale_price ;;
#   }
#
#   measure: count {
#     type: count
#     drill_fields: [id, inventory_items.id, orders.id]
#     value_format: "£#,##0"
#   }
# }


view: derivedtable_test_aa {
  ##
  derived_table: {
    sql: SELECT
        users.id  AS `users.id`,
        users.first_name  AS `users.first_name`,
        users.last_name  AS `users.last_name`,
        users.email  AS `users.email`,
        COUNT(DISTINCT orders.id ) AS `orders.count`,
        COUNT(order_items.id) AS `order_items.count`
      FROM demo_db.order_items  AS order_items
      LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
      LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id

      GROUP BY 1,2,3,4
      ORDER BY users.id
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_id {
    type: number
    sql: ${TABLE}.`users.id` ;;
    primary_key: yes
  }

  dimension: users_first_name {
    type: string
    sql: ${TABLE}.`users.first_name` ;;
  }

  dimension: users_last_name {
    type: string
    sql: ${TABLE}.`users.last_name` ;;
  }

  dimension: users_email {
    type: string
    sql: ${TABLE}.`users.email` ;;
  }

  dimension: orders_count {
    type: number
    sql: ${TABLE}.`orders.count` ;;
  }

  dimension: order_items_count {
    type: number
    sql: ${TABLE}.`order_items.count` ;;
  }

  measure: evg_items {
    type: average
    sql: ${order_items_count} ;;
  }

  measure: tot_items {
    type: sum
    sql: ${order_items_count};;
  }

  set: detail {
    fields: [
      users_id,
      users_first_name,
      users_last_name,
      users_email,
      orders_count,
      order_items_count
    ]
  }
}


explore: order_items {
  # join: mysql_inventory_items {
  #   type: left_outer
  #   sql_on: ${mysql_order_items.inventory_item_id} = ${mysql_inventory_items.id} ;;
  #   relationship: many_to_one
  #
  # }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  # join: mysql_products {
  #   type: left_outer
  #   sql_on: ${mysql_inventory_items.product_id} = ${mysql_products.id} ;;
  #   relationship: many_to_one
  # }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: derivedtable_test_aa {
    type: left_outer
    sql_on: ${orders.user_id}=${derivedtable_test_aa.users_id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {}
