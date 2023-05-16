import socket
from scapy.all import DNS, DNSQR, DNSRR

host = "127.0.0.1"
port = 53

# Create a socket object and bind it to a port
socket_udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)
socket_udp.bind((host, port))

# Extrage domeniul targetat din request-ul DNS
def extract_domain(data):
    data = data[12:]
    state = 0
    expected_length = 0
    domain_string = ''
    domain_parts = []
    x = 0
    for byte in data:
        if state == 1:
            if byte != 0:
                domain_string += chr(byte)
            x += 1
            if x == expected_length:
                domain_parts.append(domain_string)
                domain_string = ''
                state = 0
                x = 0
            if byte == 0:
                domain_parts.append(domain_string)
                break
        else:
            state = 1
            expected_length = byte
    
    return domain_parts

print("DNS server started at host:", host, "port:", port)
while True:
    # Asteptam o cerere de tip DNS
    request, source_address = socket_udp.recvfrom(65535)
    
    # converitm payload-ul in pachet scapy
    packet = DNS(request)
    dns = packet.getlayer(DNS)

    # Extragem domeniul interogat
    domain_parts =  extract_domain(request) # domain_parts = a list like  ['api', 'github', 'com', '']

    response_ip = '0.0.0.0'
    if 'github' == domain_parts[0]:
        response_ip = '140.82.121.3' # 140.82.121.3 - github.com
    
    if dns is not None and dns.opcode == 0:  # dns QUERY
        print("got: ")
        print(packet.summary())

        dns_answer = DNSRR(  # DNS Reply
            rrname=dns.qd.qname,  # for question
            ttl=330,  # DNS entry Time to Live
            type="A",
            rclass="IN",
            rdata=response_ip,
        ) 

        dns_response = DNS(
            id=packet[DNS].id,  # DNS replies must have the same ID as requests
            qr=1,  # 1 for response, 0 for query
            aa=0,  # Authoritative Answer
            rcode=0,  # 0, nicio eroare http://www.networksorcery.com/enp/protocol/dns.htm#Rcode,%20Return%20code
            qd=packet.qd,  # request-ul original
            an=dns_answer,
        )  # obiectul de reply

        print("response:")
        print(dns_response.summary())
        socket_udp.sendto(bytes(dns_response), source_address)

socket_udp.close()
