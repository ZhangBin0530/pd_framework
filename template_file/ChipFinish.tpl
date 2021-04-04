echo "stage : chip_finish"
date

set_host_options -max_cores <%$CPU_MAX_CORE%>

source ./scr/common_setting.tcl

create_via_def VIA12_1cut_HH_pg -cut_layer VIA1 -cut_size {0.024 0.024} -lower_enclosure {0.025 0} -upper_enclosure {0.040 0} -min_cut_spacing 0.087

create_pg_stapling_vias -nets {VDD} -from_layer M2 -to_layer M1 -from_shapes [get_shapes -of_objects VDD -filter "layer_name == M2"] -to_shapes [get_shapes -of_objects VDD -filter "layer_name == M1"] -mask auto -max_array_size 20 -contact_code VIA12_1cut_HH_pg -tag VIA1_VDD

create_pg_stapling_vias -nets {VSS} -from_layer M2 -to_layer M1 -from_shapes [get_shapes -of_objects VSS -filter "layer_name == M2"] -to_shapes [get_shapes -of_objects VSS -filter "layer_name == M1"] -mask auto -max_array_size 20 -contact_code VIA12_1cut_HH_pg -tag VIA1_VSS

remove_cells [get_cells -phy -filter "ref_name=~DCAP* || ref_name=~FILL*" -quiet]

set fillLC [get_lib_cells */FILL* -filter "site_name == unit"]
set sf [sort_collection -descending $fillLC { area}]
set fillLC_dcap [get_lib_cells */DCAP* -filter "site_name == unit"]
set sf_dcap [sort_collection -descending $fillLC_dcap { area}]
set sf_dcap_list $sf_dcap

create_stdcell_fillers_n12 -lib_cells $sf_dcap_list
remove_stdcell_fillers_with_violation

## non-3T normal filler insertion ###
set all_fillers [sort_collection [get_lib_cells */FILL*] area -desc]
create_stdcell_fillers_n12 -lib_cells $all_fillers
connect_pg_net -auto

### 3T filler insertion ####
set exception [get_lib_cell */BOUNDARY_LEFTBWP*]
set exception [append_to_collection exception [get_lib_cell */BOUNDARY_RIGHTBWP*]]
set exception [append_to_collection exception [get_lib_cell */BOUNDARY_NROW*BWP*]]
set exception [append_to_collection exception [get_lib_cell */TAPCELLBWP6T*P96CPD*]]

set constraint [get_lib_cell {*/*DCAP*CPD}]
set non_constraint [get_lib_cell */FILL*BWP*CPD -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP*CPDLVT}]
set non_constraint [get_lib_cell */FILL*BWP*CPDLVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP*CPDULVT}]
set non_constraint [get_lib_cell */FILL*BWP*CPDULVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP64*CPD}]
set non_constraint [get_lib_cell */FILL64*BWP*CPD -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP64*CPDLVT}]
set non_constraint [get_lib_cell */FILL64*BWP*CPDLVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP64*CPDULVT}]
set non_constraint [get_lib_cell */FILL64*BWP*CPDULVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP32*CPD}]
set non_constraint [get_lib_cell */FILL32*BWP*CPD -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP32*CPDLVT}]
set non_constraint [get_lib_cell */FILL32*BWP*CPDLVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP32*CPDULVT}]
set non_constraint [get_lib_cell */FILL32*BWP*CPDULVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP16*CPD}]
set non_constraint [get_lib_cell */FILL16*BWP*CPD -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP16*CPDLVT}]
set non_constraint [get_lib_cell */FILL16*BWP*CPDLVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP16*CPDULVT}]
set non_constraint [get_lib_cell */FILL16*BWP*CPDULVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP8*CPD}]
set non_constraint [get_lib_cell */FILL8*BWP*CPD -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP8*CPDLVT}]
set non_constraint [get_lib_cell */FILL8*BWP*CPDLVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP8*CPDULVT}]
set non_constraint [get_lib_cell */FILL8*BWP*CPDULVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP4*CPD}]
set non_constraint [get_lib_cell */FILL4*BWP*CPD -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP4*CPDLVT}]
set non_constraint [get_lib_cell */FILL4*BWP*CPDLVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set constraint [get_lib_cell {*/*DCAP4*CPDULVT}]
set non_constraint [get_lib_cell */FILL4*BWP*CPDULVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule horizontal_edges_distance \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 30 \
-prefix FIX_MAX_M0PO \
-layer {M0PO}

set exception [get_lib_cell */BOUNDARY_LEFTBWP*]
set exception [append_to_collection exception [get_lib_cell */BOUNDARY_RIGHTBWP*]]
set exception [append_to_collection exception [get_lib_cell */BOUNDARY_*CORNER*]]
set exception [append_to_collection exception [get_lib_cell */BOUNDARY_*TAP*]]
set exception [append_to_collection exception [get_lib_cell */TAPCELLBWP6T*P96CPD*]]

set constraint [get_lib_cell {*/FILL6*CPD */FILL3*CPD */FILL2*CPD */FILL16*CPD */FILL8*CPD */FILL4*CPD */DCAP*CPD}]
set non_constraint [get_lib_cell */FILL1BWP*CPD -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule max_vertical_constraint \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 199 \
-prefix FIX_CPODEL2

set constraint [get_lib_cell {*/FILL6*CPDLVT */FILL3*CPDLVT */FILL2*CPDLVT */FILL16*CPDLVT */FILL8*CPDLVT */FILL4*CPDLVT */DCAP*CPDLVT}]
set non_constraint [get_lib_cell */FILL1BWP*CPDLVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule max_vertical_constraint \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 199 \
-prefix FIX_CPODEL2

set constraint [get_lib_cell {*/FILL6*CPDULVT */FILL3*CPDULVT */FILL2*CPDULVT */FILL16*CPDULVT */FILL8*CPDULVT */FILL4*CPDULVT */DCAP*ULVT}]
set non_constraint [get_lib_cell */FILL1BWP*CPDULVT -filter "site_name == unit"]
replace_fillers_by_rules -replacement_rule max_vertical_constraint \
-constraint_fillers $constraint \
-non_constraint_fillers $non_constraint \
-exception_cell $exception \
-max_constraint_length 199 \
-prefix FIX_CPODEL2


if { [regexp {6T} ${site_track}] } {
       create_marker_layers -horizontal_extension {{M2_P48 0.2} {M3_P48 0.2}} -vertical_extension {{M2_P48 0.2} {M3_P48 0.2}}
}

create_shape -shape_type polygon -layer 108 -boundary [get_attribute [get_designs] boundary]

write_gds -layer_map ${gds_map} -long_names -units 1000 -layer_map_format icc_extended ./output/<%$TOP%>_<%$METAL_SCHEME%>_<%$CELL_HEIGHT%>.APR.gds
write_verilog  -compress gzip -include {pg_netlist} ./output/<%$TOP%>_<%$METAL_SCHEME%>_<%$CELL_HEIGHT%>.pg.v
write_def -version 5.8 -units 2000 -include_tech_via_definitions -no_marker_layer ./output/<%$TOP%>_<%$METAL_SCHEME%>_<%$CELL_HEIGHT%>.def

echo "stage : chip_finish"
date
