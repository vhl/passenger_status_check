from checks import AgentCheck
from passenger_check.parser import Parser
import shlex, subprocess

# need to add this to the sudoers file:
# dd-agent    ALL=(deploy) NOPASSWD: /bin/bash

# passenger_check directory needs to be located in /opt/datadog-agent/agent/

class PassengerStatusCheck(AgentCheck):
    def check(self, instance):
        args = shlex.split(instance.get('command'))
        xml_data = subprocess.Popen(args, stdout=subprocess.PIPE).communicate()[0]
        parser = Parser(xml_data)
        parser.parse()
        self.gauge('passenger.global_queue.count', parser.requests_in_top_level_queue())
        self.gauge('passenger.application_queue.count', parser.requests_in_app_queue())
        self.gauge('passenger.processes.count', parser.process_count())
        self.gauge('passenger.resisting_deployment.count', parser.resisting_deployment())
        for index, process in enumerate(parser.processes()):
            process_tags = ['process_id:' + str(index)]
            self.gauge('passenger.process.cpu', process.cpu(), tags=process_tags)
            self.gauge('passenger.process.memory', process.memory(), tags=process_tags)
            self.gauge('passenger.process.last_request_time', process.last_request_time(), tags=process_tags)

