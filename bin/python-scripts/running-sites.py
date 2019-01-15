#!/Users/bernd/.pyenv/versions/running_sites/bin/python
from functools import lru_cache
from http.server import BaseHTTPRequestHandler
from http.server import HTTPServer
from requests.exceptions import ReadTimeout
from requests_html import HTMLSession
from subprocess import check_output
from urllib.request import urlparse


class LocalRunningSitesHandler(BaseHTTPRequestHandler):
    session = HTMLSession()

    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=UTF-8')
        self.end_headers()

        self.wfile.write(bytes(self.local_running_sites_html(), 'utf-8'))
        return

    def domain(self):
        parsed = urlparse(self.headers.get('HOST', ''))
        domain = parsed.netloc or parsed.scheme or parsed.path

        if ':' in domain:
            domain = domain.split(':')[0]

        if not domain or domain == '127.0.0.1':
            domain = 'localhost'
        return domain

    def local_running_sites_html(self):
        ports = self.local_running_ports()
        result_html = ''
        domain = self.domain()
        for port in ports:
            service, path = self.custom_service(port)
            link = f'http://{domain}:{port}{path}'

            if service == 'solr' and domain != 'localhost':  # not allowed from outside localhost
                title = self.get_title(f'http://localhost:{port}{path}')
                title += ' <small>Does not accept requests from clients other than host</small>'
            else:
                title = self.get_title(link)

            text = f'{domain}:{port}'
            text = f'{title} ({text})' if title else text

            result_html += f'<a href="{link}" target="_blank">{text}</a></br>'
        return result_html

    def custom_service(self, port):
        path = ('', '')
        if port == '8983':  # solr
            path = ('solr', '/solr')
        if port == '3000':  # Bumblebee Foreman
            path = ('Bumblebee', '/admin')
        return path

    def get_title(self, url, timeout=1):
        try:
            response = self.session.get(url, timeout=timeout)
        except ReadTimeout:
            return

        title_node = response.html.xpath('.//title', first=True)
        return title_node.text if title_node else None

    def local_running_ports(self):
        # Ports running on .*
        netstat_ports = check_output('netstat -vanp tcp | grep -E "\*\.[138]\d{3,5}.*LISTEN" | cut -d. -f2 | cut -d* -f1', shell=True)
        # Ports running on IP Address
        netstat_ports += check_output('netstat -vanp tcp | grep -E "\.8983.*LISTEN" | cut -d. -f5 | cut -d* -f1', shell=True)

        ports = list(filter(None, map(str.strip, netstat_ports.decode('ascii').split('\n'))))
        ports = filter(lambda i: i != str(self.server.server_port), ports)
        return sorted(ports)


try:
    import sys
    port = [sys.argv[index + 1] for index, item in enumerate(sys.argv) if item in ['--port', '-p']]
    port = int(port[0]) if port else 80

    server_address = ('', port)
    server = HTTPServer(server_address, LocalRunningSitesHandler)
    server.serve_forever()
except KeyboardInterrupt:
    print('Shutting down the web server')
    server.socket.close()
