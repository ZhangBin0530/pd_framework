from PD_flow import *

pd_flow = PDFlow('flow.json')
PyGetInputs = pd_flow.targets['PyGetInputs']
PyGenCmds = pd_flow.targets['PyGenCmds']
Floorplan = pd_flow.targets['Floorplan']
Placement = pd_flow.targets['Placement']
Cts = pd_flow.targets['Cts']
Route = pd_flow.targets['Route']
ChipFinish = pd_flow.targets['ChipFinish']
run_list = [PyGetInputs,PyGenCmds,Floorplan,Placement,Cts,Route,ChipFinish]
run(run_list)
