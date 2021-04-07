# pd_framework
1.  Prepare two files, flow.json and params.json. flow.json is used for the configuration of flow creation. params.json is used for the configuration of template parameters. 
2.  Define the target that needs to be run in flow.json, and the attributes required by each target, such as input and output files, input target, output target, etc. 
3.  In the python environment, instantiate PDFlow with flow.json as a parameter to create a flow. At the same time, prepare the shell script or python script to be run by each target 
4.  Use the run() function to run the target you want to run. After a target runs successfully, it cannot run again. Use the invalid() function to reset it. 
5.  PyGetInputs is used to obtain the required input data, such as netlists, templates, etc. 
6.  PyGenCmds is used to generate the tcl scripts required by each target. 
7.  After these two steps are successfully executed, the subsequent physical design steps can be executed in sequence. 
