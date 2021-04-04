echo "stage : route"
date

set_host_options -max_cores <%$CPU_MAX_CORE%>


source ./scr/common_setting.tcl

set m2_m3_macro_pins [get_terminals -of_objects [get_flat_pins -of_objects [get_flat_cells -filter "design_type==macro"] -filter "layer_name=~*M2* || layer_name=~*M3*"]]
set_attribute $m2_m3_macro_pins port.is_rectangle_only_rule_waived true

remove_clock_uncertainty [get_clocks *]
source <%$ANT_TF%>
route_auto

check_routes -open_net true
route_detail -incremental true
check_routes -open_net true
route_detail -incremental true

route_opt
check_routes -open_net true
route_detail -incremental true
check_routes -open_net true
route_detail -incremental true
check_routes -open_net true
route_detail -incremental true

<% if <%$FIX_SOFT_VIOLATIONS%>:%>
set_app_options -name route.common.post_detail_route_fix_soft_violations -value true
set_app_options -name route.common.post_eco_route_fix_soft_violations -value true
set_app_options -name route.common.post_group_route_fix_soft_violations -value true
set_app_options -name route.common.post_incremental_detail_route_fix_soft_violations  -value true
set_app_options -name route.common.route_soft_rule_effort_level  -value <%$SOFT_RULE_EFFORT_LEVEL%>
<% endif %>

check_routes -open_net true
route_detail -incremental true
check_routes -open_net true
route_detail -incremental true

puts "add_redundant_vias"
source <%$DFM_SWAP%>

connect_pg_net -automatic

echo "end : route"
date
