class Process:
    def __init__(self, process_xml):
        self.xml = process_xml

    def pid(self):
        return getattr(self.xml.find('pid'), 'text', '0')
        
    def cpu(self):
        return getattr(self.xml.find('cpu'), 'text', '0')

    def memory(self):
        return getattr(self.xml.find('rss'), 'text', '0')

    def last_request_time(self):
        return getattr(self.xml.find('last_used'), 'text', '0')

