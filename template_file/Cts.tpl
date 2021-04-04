echo "stage : cts"
date

set_host_options -max_cores <%$CPU_MAX_CORE%>

set boundary_offset_x <%$BOUNDARY_OFFSET_X%>
set boundary_offset_y <%$BOUNDARY_OFFSET_Y%>
set unit_height 0.384
set site_track <%$CELL_HEIGHT%>
set 6t_turbo "yes"


source ./scr/common_setting.tcl

source -e -v ./scr/CTS_NDR.tcl

<% if <%$METAL_SCHEME%> != "2Xa1Xd3Xe2Y2Yy2R":%>
set_clock_routing_rules -clocks [get_clocks *] -rule CLK_Trunk -net_type root -min_routing_layer M[expr <%$MAX_ROUTING_LAYER_NUM%>-1] -max_routing_layer M<%$MAX_ROUTING_LAYER_NUM%>
set_clock_routing_rules -clocks [get_clocks *] -rule CLK_Trunk -net_type internal -min_routing_layer M[expr <%$MAX_ROUTING_LAYER_NUM%>-1] -max_routing_layer M<%$MAX_ROUTING_LAYER_NUM%>
set_clock_routing_rules -clocks [get_clocks *] -rule CLK_Leaf -net_type sink -min_routing_layer M[expr <%$MAX_ROUTING_LAYER_NUM%>-3] -max_routing_layer M[expr $<%$MAX_ROUTING_LAYER_NUM%>
<% endif %>

<% if <%$METAL_SCHEME%> == "2Xa1Xd3Xe2Y2Yy2R":%>
set_clock_routing_rules -clocks [get_clocks *] -rule CLK_Trunk -net_type root -min_routing_layer M[expr <%$MAX_ROUTING_LAYER_NUM%>-3] -max_routing_layer M<%$MAX_ROUTING_LAYER_NUM%>
set_clock_routing_rules -clocks [get_clocks *] -rule CLK_Trunk -net_type internal -min_routing_layer M[expr <%$MAX_ROUTING_LAYER_NUM%>-3] -max_routing_layer M<%$MAX_ROUTING_LAYER_NUM%>
set_clock_routing_rules -clocks [get_clocks *] -rule CLK_Leaf -net_type sink -min_routing_layer M[expr <%$MAX_ROUTING_LAYER_NUM%>-5] -max_routing_layer M[expr <%$MAX_ROUTING_LAYER_NUM%>-2]
<% endif %>

report_clock_routing_rules


set ISF(CLK_BUFFER_EXCLUDE_LIST)  { }
set ISF(CLK_BUFFER_LIST)          {
                                    CKND16BWP6T16P96CPDULVT
                                    CKND12BWP6T16P96CPDULVT
                                    CKND8BWP6T16P96CPDULVT
                                    }

set_lib_cell_purpose -exclude {cts} */*D*

foreach pat $ISF(CLK_BUFFER_LIST) {
        set_attribute */$pat dont_use false
        set_attribute */$pat dont_touch false
        set_lib_cell_purpose -include {cts} */$pat
        puts "CLK_BUF: $pat"
}

foreach pat $ISF(CLK_BUFFER_EXCLUDE_LIST) {
    foreach_in_collection cell [get_lib_cells */$pat] {
        set_lib_cell_purpose -exclude {cts} $cell
        puts "CLK_BUF EXCLUDE: $pat"
    }
}


set_clock_tree_options -target_skew <%$TARGET_SKEW%>
set_max_transition -clock_path <%$CLOCK_MAX_TRANSITION%> [get_clocks *]
set_max_capacitance -clock_path <%$CLOCK_MAX_CAPACITANCE%> [get_clocks *]
set_app_options -name cts.common.max_net_length -value <%$CLOCK_MAX_NET_LENGTH%>

synthesize_clock_trees

mark_clock_trees -synthesized
set_propagated_clock [all_clocks]
clock_opt -from route_clock -to route_clock

set_lib_cell_purpose -include optimization [get_lib_cells {*/*}]
source ./scr/dont_use.tcl
set_app_options -name refine_opt.hold.effort -value none
clock_opt -from final_opto

set_scenario_status [get_scenarios {<%$CTS_SCENATIOS%>}] -hold true -min_capacitance false
update_timing

if {[regexp {FCCC} [get_object_name [current_design]]]} {
set_lib_cell_purpose -include optimization [get_lib_cells {*/*}]
set_lib_cell_purpose -include hold [get_lib_cells {<%$HOLD_CELLS%>}]
set_app_options -name refine_opt.hold.effort -value medium
source ./scr/dont_use.tcl
refine_opt
}

echo "end : cts"
date
