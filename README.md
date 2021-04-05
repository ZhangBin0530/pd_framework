# pd_framework
1.  准备好flow.json和params.json两个文件。flow.json用于流程创建的配置。params.json是用于模板参数的配置。
2.  在flow.json中定义好需要运行的target,以及每一个target所需要的的属性，如输入输出的文件，输入target，输出target等。
3.  在python环境中以flow.json为参数实例化PDFlow，创建流程。同时配置好各个target要运行的shell脚本或者python脚本
4.  用run()函数运行想要运行的target，一个target运行成功后就无法再次运行，用invalid()函数将其重置。
5.  PyGetInputs用于获取所需输入数据，如网表、模板等。
6.  PyGenCmds用于生成每个target 所需的设计脚本。
7.  成功执行这两步之后，之后的物理设计步骤便可依次执行。
