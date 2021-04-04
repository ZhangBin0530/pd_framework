from target import *
import json

class PDFlow(object):
    def __init__(self, flow_json):
        self.targets = {}
        self.setting = json.load(open(flow_json))
        print(self.setting)
        for target_name in self.setting.keys():
            self.targets[target_name] = Target(self.setting[target_name]['name'])
            self.targets[target_name].input.fileslist = self.setting[target_name]["input_files"]
            self.targets[target_name].output.fileslist = self.setting[target_name]["output_files"]
            self.targets[target_name].tcsh = self.setting[target_name]['tcsh']
            self.targets[target_name].cmd = self.setting[target_name]['cmd']
            self.targets[target_name].tpl = self.setting[target_name]['tpl']
        for target_name in self.setting.keys():
            for connected_target in self.setting[target_name]["input_connected_targets"]:
                self.targets[target_name].input.connected_targets.append(self.targets[connected_target])
            for connected_target in self.setting[target_name]["output_connected_targets"]:
                self.targets[target_name].output.connected_targets.append(self.targets[connected_target])



def run(target_list):
    for t in target_list:
        if t.status == 'Valid':
            continue
        if len(t.input.file_not_exist()) == 0:
            t.status = 'Waiting'
            t.run()
            t.status = 'Running'
        else:
            t.status = 'Waiting'

def invalid(target_list):
        for t in target_list:
            t.status = 'InValid'
