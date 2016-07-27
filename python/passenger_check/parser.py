import xml.etree.ElementTree as ET
from passenger_check.process import Process

class Parser:
    def __init__(self, data):
        self.data = data
        self.root_node = None

    def parse(self):
        self.root_node = ET.fromstring(self.data)

    def process_count(self):
        return len(self.root_node.findall('./supergroups/supergroup/group/processes/process'))
        
    def requests_in_top_level_queue(self):
        xml = self.root_node.find('get_wait_list_size')
        return self.__safe_xml_value(xml)

    def requests_in_app_queue(self):
        xml = self.root_node.find('./supergroups/supergroup/group/get_wait_list_size')
        return self.__safe_xml_value(xml)

    def resisting_deployment(self):
        return len(self.root_node.findall('./supergroups/supergroup/group/resisting_deployment_error'))

    def processes(self):
        return map((lambda process_xml: Process(process_xml)), self.root_node.findall('./supergroups/supergroup/group/processes/process'))

    def __safe_xml_value(self, value):
        return int(getattr(value, 'text', 0))
        
