locals {
  cross_account_event_bridge_role_name = coalesce(var.cross_account_event_bridge_role_name,"${var.service_name}EventBridgeRole-${var.application_id}")
  cross_account_event_bridge_policy_name = coalesce(var.cross_account_event_bridge_policy_name,"${var.service_name}EventBridgePolicy-${var.application_id}")
  
  cross_account_role_name = coalesce(var.cross_account_role_name,"${var.service_name}RemoteRole-${var.application_id}")
  cross_account_policy_name = coalesce(var.cross_account_policy_name,"${var.service_name}RemotePolicy-${var.application_id}")
  
  create_cross_account_role = var.pre_existing_cross_account_role_name == null
  create_event_bridge_role = var.pre_existing_event_bridge_role_name == null
}

