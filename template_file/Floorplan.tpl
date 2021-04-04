echo "stage : initial_floorplan"
date

set boundary_offset_x <%$BOUNDARY_OFFSET_X%>
set boundary_offset_y <%$BOUNDARY_OFFSET_Y%>
set unit_height 0.384
set site_track <%$CELL_HEIGHT%>
set 6t_turbo "yes"

set_host_options -max_cores <%$CPU_MAX_CORE%>
set sh_continue_on_error <%$CONTINUE_ON_ERROR%>

read_verilog <%$NETLIST%>
current_design
link_block -f

set_ignored_layers -min_routing_layer <%$MIN_ROUTING_LAYER%> -max_routing_layer <%$MAX_ROUTING_LAYER%>
report_ignored_layers

<%l = 0%>
<%while l <= <%$MAX_ROUTING_LAYER_NUM%>:%>
<% if <%$l%> % 2:%>
set_attribute [get_layers M<%$l%>] routing_direction horizontal
<% else: %>
set_attribute [get_layers M<%$l%>] routing_direction vertical
<% endif %>
<% l += 1 %>
<% endwhile %>

set_attribute [get_layers M0] routing_direction horizontal
set_attribute [get_layers AP] routing_direction horizontal

read_def ""
echo "initial floorplan"
initialize_floorplan \
    -keep_boundary \
    -keep_pg_route \
    -keep_placement {macro io} \
    -flip_first_row true \
    -core_offset [list ${boundary_offset_x} ${boundary_offset_y}] \
    -site_def unit \
    -use_site_row

###Create PG if needed

if { [regexp {6T} ${site_track}] } {
   create_grid -x_offset [expr ${boundary_offset_x}+0.048] -x_step 0.192 via0_grid
   report_grids
}

if { [regexp {yes} ${6t_turbo}] } {
  echo "create ibunit"
  set bb [get_attribute [get_attribute [resize_polygons -objects [get_attribute [get_core_area] boundary] -size {0 -0.192}] poly_rects] point_list]
  create_site_array -name ibrow -site ibunit -transparent true -direction horizontal -aligned false -boundary $bb -flip_first_row false -flip_alternate_row false
}

source ./scr/common_setting.tcl

##Boundary cell creation
set nrow3 "*/BOUNDARY_NROW3BWP6T16P96CPDULVT"
set nrow2 "*/BOUNDARY_NROW2BWP6T16P96CPDULVT"
set prow3 "*/BOUNDARY_PROW3BWP6T16P96CPDULVT"
set prow2 "*/BOUNDARY_PROW2BWP6T16P96CPDULVT"
set left "*/BOUNDARY_LEFTBWP6T16P96CPDULVT"
set right "*/BOUNDARY_RIGHTBWP6T16P96CPDULVT"
set ncorner "*/BOUNDARY_NCORNERBWP6T16P96CPDULVT"
set pcorner "*/BOUNDARY_PCORNERBWP6T16P96CPDULVT"
set ntap "*/BOUNDARY_NTAPBWP6T16P96CPDULVT"
set ptap "*/BOUNDARY_PTAPBWP6T16P96CPDULVT"
set incorner "*/FILL4BWP6T16P96CPDULVT"

create_boundary_cells \
   -bottom_boundary_cells [list $prow3 $prow2] \
   -right_boundary_cell [list $right] \
   -left_boundary_cell [list $left] \
   -top_right_outside_corner_cell [list $ncorner] \
   -bottom_right_outside_corner_cell [list $pcorner] \
   -top_left_outside_corner_cell [list $ncorner] \
   -bottom_left_outside_corner_cell [list $pcorner] \
   -top_left_inside_corner_cells [list $incorner] \
   -top_right_inside_corner_cells [list $incorner] \
   -bottom_left_inside_corner_cells [list $incorner] \
   -bottom_right_inside_corner_cells [list $incorner] \
   -top_tap_cell [list $ntap] \
   -bottom_tap_cell [list $ptap] \
   -tap_distance 21 -min_row_width 0.90 \
   -top_boundary_cells [list $nrow3 $nrow2] \
   -mirror_left_outside_corner_cell

create_tap_cells -lib_cell */<%$TAP_CELL%> -distance <%$TAP_CELL_DISTANCE%> -pattern stagger -skip_fixed_cells -enable_prerouted_net_check
connect_pg_net -automatic

echo "end : initial_floorplan"
date