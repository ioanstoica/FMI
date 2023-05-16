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

# Get the IP address of a hostname
def get_ip_address(hostname):
    try:
        # Send a DNS request to 8.8.8.8 and retrieve the IP address
        ip_address = socket.gethostbyname(hostname)
        return ip_address
    except socket.gaierror:
        return None

print("DNS server started at host:", host, "port:", port)
while True:
    # Asteptam o cerere de tip DNS
    request, source_address = socket_udp.recvfrom(65535)
    
    # converitm payload-ul in pachet scapy
    packet = DNS(request)
    dns = packet.getlayer(DNS)

    # Extragem domeniul interogat
    domain_parts =  extract_domain(request) # domain_parts = a list like  ['api', 'github', 'com', '']
    domain_parts = domain_parts[:-1] # domain_parts = ['api', 'github', 'com']
    print("domain_parts: ", domain_parts)
    domain = '.'.join(domain_parts) # domain = 'api.github.com'
    print("domain: ", domain)

    # Obtinem IP-ul pentru domeniul interogat
    response_ip = get_ip_address(domain)
    print("response_ip: ", response_ip)

    # Daca nu am putut obtine IP-ul, trimitem un raspuns cu codul de eroare NXDOMAIN
    errorcode = 0
    if response_ip is None:
        print("Failed to retrieve the IP address of", domain)
        response_ip = '0.0.0.0'
        errorcode = 3 # NXDOMAIN - Non-Existent Domain
  
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
            rcode=errorcode,  # 0, nicio eroare http://www.networksorcery.com/enp/protocol/dns.htm#Rcode,%20Return%20code
            qd=packet.qd,  # request-ul original
            an=dns_answer,
        )  # obiectul de reply

        print("response:")
        print(dns_response.summary())
        socket_udp.sendto(bytes(dns_response), source_address)

socket_udp.close()
