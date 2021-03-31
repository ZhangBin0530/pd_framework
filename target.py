import os
import threading
import time

class Target(object):
    def __init__(self, name):
        self.name = name
        self.input = Port('in')
        self.output = Port('out')
        self.status = 'Invalid'
        self.ready = 0
        self.cmd = None

    def check_ready(self):
        fs = self.input.file_not_exist()
        if len(fs) == 0:
            self.ready = 1
        else:
            self.ready = 0
            print("Following files are not exist:")
            for f in fs:
                print(f)

    def check_valid(self):
        fs = self.output.file_not_exist()
        if len(fs) == 0:
            self.status = 'Valid'
        else:
            self.status = 'Error'
            print("Following files are not exist:")
            for f in fs:
                print(f)

    def run(self):
        self.check_ready()
        if self.ready and self.status == 'Waiting':
            thread = threading.Thread(target=self.work, name= 'Thread_' + self.name )
            thread.start()


    def work(self):
        localtime = time.asctime(time.localtime(time.time()))
        print("Start:", localtime)
        print(self.name, "is running")
        os.system(self.cmd)
        localtime = time.asctime(time.localtime(time.time()))
        print("End:", localtime)
        self.status = 'Valid'
        self.run_next_targets()


    def run_next_targets(self):
        targets = self.output.connected_targets
        for target in targets:
            target.run()


class Port(object):
    def __init__(self, direction):
        self.direction = direction
        self.fileslist = []
        self.connected_targets = []

    def file_not_exist(self):
        f = []
        for file in self.fileslist:
            if not os.path.exists(file):
                f.append(file)
        return f






