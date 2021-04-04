from template import *
import json

target_setting = json.load(open('flow.json'))
params_setting = json.load(open('params.json'))
for t in target_setting.keys():
    tpl = target_setting[t]['tpl']
    cmd_file = target_setting[t]['cmd']
    print(cmd_file)
    if tpl != "":
        template = Template(filename=tpl)
        open(cmd_file, 'w').write(template.render(params_setting))
