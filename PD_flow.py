from target import *

class PDFlow(object):
    def __init__(self):
        self.floorplan = Target('floorplan')
        self.place = Target('place')
        self.cts = Target('cts')
        self.route = Target('route')
        self.floorplan.output.fileslist.append('data\\floorplan.out')
        self.floorplan.output.connected_targets.append(self.place)
        self.place.input.fileslist.append('data\\floorplan.out')
        self.place.input.connected_targets.append(self.floorplan)
        self.place.output.fileslist.append('data\\place.out')
        self.place.output.connected_targets.append(self.cts)
        self.cts.input.fileslist.append('data\\place.out')
        self.cts.input.connected_targets.append(self.place)
        self.cts.output.fileslist.append('data\\cts.out')
        self.cts.output.connected_targets.append(self.route)
        self.route.input.fileslist.append('data\\cts.out')
        self.route.input.connected_targets.append(self.cts)
        self.route.output.fileslist.append('data\\route.out')

def run(target_list):
    for t in target_list:
        if t.status == 'Valid':
            continue
        if len(t.input.file_not_exist()) == 0:
            t.status = 'Waiting'
            t.run()
        else:
            t.status = 'Waiting'

def invalid(target_list):
        for t in target_list:
            t.status = 'InValid'
