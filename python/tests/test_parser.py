import unittest
from passenger_check.parser import Parser
from passenger_check.process import Process

class TestParser(unittest.TestCase):
    def setup_parser(self):
        test_data = open('tests/fixtures/pass-status.xml', 'r').read()
        parser = Parser(test_data)
        parser.parse()
        return parser

    # loads the XML file.
    def test_parse_loads_the_xml(self):
        parser = self.setup_parser()
        self.assertEqual('3', parser.root_node.attrib['version'])

    # returns the number of active processes.
    def test_process_count(self):
        parser = self.setup_parser()
        self.assertEqual(2, parser.process_count())

    # returns the number of requests in the global queue.
    def test_requests_in_top_level_queue(self):
        parser = self.setup_parser()
        self.assertEqual(0, parser.requests_in_top_level_queue())

    # returns the number of requests backed up in the app queue.
    def test_requests_in_app_queue(self):
        parser = self.setup_parser()
        self.assertEqual(8, parser.requests_in_app_queue())

    # returns the number of resisting-deployment elements.
    def test_resisting_deployment(self):
        parser = self.setup_parser()
        self.assertEqual(0, parser.resisting_deployment())
    
    # contains the correct number of processes.
    def test_processes_count(self):
        parser = self.setup_parser()
        self.assertEqual(2, len(parser.processes()))

# Where no processes have spawned.
class TestParserNoProcesses(unittest.TestCase):
    def setup_parser(self):
        test_data = open('tests/fixtures/pass-status-no-processes.xml', 'r').read()
        parser = Parser(test_data)
        parser.parse()
        return parser

    # returns the number of active processes.
    def test_process_count(self):
        parser = self.setup_parser()
        self.assertEqual(0, parser.process_count())

    # returns the number of requests in the global queue.
    def test_requests_in_top_level_queue(self):
        parser = self.setup_parser()
        self.assertEqual(0, parser.requests_in_top_level_queue())

    # returns the number of requests backed up in the app queue.
    def test_requests_in_app_queue(self):
        parser = self.setup_parser()
        self.assertEqual(0, parser.requests_in_app_queue())

    # returns the number of resisting-deployment elements.
    def test_resisting_deployment(self):
        parser = self.setup_parser()
        self.assertEqual(0, parser.resisting_deployment())
    
    # contains the correct number of processes.
    def test_processes_count(self):
        parser = self.setup_parser()
        self.assertEqual(0, len(parser.processes()))


class TestProcess(unittest.TestCase):
    def setup_process(self):
        test_data = open('tests/fixtures/pass-status.xml', 'r').read()
        parser = Parser(test_data)
        parser.parse()
        return Process(parser.root_node.find('./supergroups/supergroup/group/processes/process'))

    # reports the pid.
    def test_pid(self):
        process = self.setup_process()
        self.assertEqual('8439', process.pid())

    # reports the cpu usage.
    def test_cpu(self):
        process = self.setup_process()
        self.assertEqual('0', process.cpu())

    # reports the memory used.
    def test_memory(self):
        process = self.setup_process()
        self.assertEqual('264508', process.memory())

    # reports the last request time.
    def test_last_request_time(self):
        process = self.setup_process()
        self.assertEqual('1440404826866466', process.last_request_time())

