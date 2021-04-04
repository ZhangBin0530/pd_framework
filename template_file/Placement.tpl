echo "stage : place_opt"
date

set_host_options -max_cores <%$CPU_MAX_CORE%>
set sh_continue_on_error <%$CONTINUE_ON_ERROR%>


source ./scr/common_setting.tcl

source ./scr/dont_use.tcl
source ./scr/create_mcmm.tcl

echo "Start reading placement constraint"
source <%$PLACE_CONSTRAINT%>
echo "End reading placement constraint"
report_ignored_layers

set_scenario_status [get_scenarios <%$PLACE_SCENARIO%>] -hold false -min_capacitance false
set_app_option -name opt.common.user_instance_name_prefix -value "PLACE_OPT_"
remove_clock_uncertainty [get_clocks *]

set_app_option -name place.coarse.max_pins_per_square_micron -value [estimate_target_pin_density -pre_place]

proc set_multi_row_penalty { {mult 1.0} } {
    set tmp [get_attribute [get_cells -filter "design_type == lib_cell" -quiet] -name width -quiet]
    set val [expr ($mult * [lindex [lsort -real $tmp] [expr [llength $tmp] / 2]]) / 2.0]
    puts "Setting multi-row penalty to $val."
    set_app_option -name place.utilization.multi_row_penalty -value $val
}
set_multi_row_penalty <%$MULTI_ROW_PENALTY%>

set_app_options -name place.legalize.enable_variant_aware -value <%$ENABLE_VARIANT_AWARE%>
set_app_options -name place.legalize.enable_full_variant_check -value <%$ENABLE_FULL_VARIANT%>
create_placement -timing_driven -effort <%$TIMING_DRIVEN_EFFORT%> -congestion -congestion_effort <%$CONGESTION_EFFORT%>
place_opt -from initial_drc

echo "end : place_opt"
date
