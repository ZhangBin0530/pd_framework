from PD_flow import *

def main():
    pd_flow = PDFlow('flow.json')
    PyGetInputs = pd_flow.targets['PyGetInputs']
    PyGenCmds = pd_flow.targets['PyGenCmds']
    run_list = [PyGetInputs,PyGenCmds]
    run(run_list)


if __name__ == '__main__':
    main()