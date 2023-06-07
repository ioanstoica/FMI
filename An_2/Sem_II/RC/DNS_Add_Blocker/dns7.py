import socket
import socketserver
import struct
import concurrent.futures
from scapy.all import DNS, DNSQR, IP, sr1, UDP

GOOGLE_DNS = '8.8.8.8'
DNS_PORT = 53

def handle_dns_request(data):
    # Parseaza cererea DNS folosind Scapy
    dns_request = DNS(data)

    # Creaza un pachet DNS pentru a fi trimis la 8.8.8.8
    query = IP(dst=GOOGLE_DNS)/UDP(dport=DNS_PORT)/DNS(
        rd=1, qd=DNSQR(qname=dns_request[DNSQR].qname))

    # Trimite cererea și primește răspunsul
    response = sr1(query, verbose=0)

    return bytes(response)

class ThreadedDNSServer(socketserver.ThreadingMixIn, socketserver.UDPServer):
    pass

class DNSHandler(socketserver.BaseRequestHandler):
    def handle(self):
        data = self.request[0].strip()
        socket = self.request[1]

        print(f'Client {self.client_address} a facut o cerere.')

        with concurrent.futures.ThreadPoolExecutor() as executor:
            future = executor.submit(handle_dns_request, data)
            response = future.result()

        socket.sendto(response, self.client_address)

if __name__ == "__main__":
    server = ThreadedDNSServer(('0.0.0.0', DNS_PORT), DNSHandler)

    print('Server DNS pornit pe portul 53...')

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print('Serverul DNS a fost oprit.')
        server.shutdown()
