class Process:
    def __init__(self, process_xml):
        self.xml = process_xml

    def pid(self):
        return self.xml.find('pid').text
        
    def cpu(self):
        return self.xml.find('cpu').text

    def memory(self):
        return self.xml.find('rss').text

    def last_request_time(self):
        return self.xml.find('last_used').text

