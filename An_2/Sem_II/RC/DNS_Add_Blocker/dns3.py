import socket
from scapy.all import DNS, DNSQR, DNSRR

simple_udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, proto=socket.IPPROTO_UDP)
simple_udp.bind(("127.0.0.1", 53))


def getquestiondomain(data):

    state = 0
    expectedlength = 0
    domainstring = ''
    domainparts = []
    x = 0
    y = 0
    for byte in data:
        if state == 1:
            if byte != 0:
                domainstring += chr(byte)
            x += 1
            if x == expectedlength:
                domainparts.append(domainstring)
                domainstring = ''
                state = 0
                x = 0
            if byte == 0:
                domainparts.append(domainstring)
                break
        else:
            state = 1
            expectedlength = byte
        y += 1

    questiontype = data[y:y+2]

    return (domainparts, questiontype)

def getrecs(data):
    domain, questiontype = getquestiondomain(data)
    return domain

def adresa_cautata(data):
    return getrecs(data[12:])

print("DNS server started!")
while True:
    request, adresa_sursa = simple_udp.recvfrom(65535)
    # converitm payload-ul in pachet scapy
    packet = DNS(request)
    dns = packet.getlayer(DNS)
    print("dns: ", adresa_cautata(request))

    # 140.82.121.3 - github.com
    if dns is not None and dns.opcode == 0:  # dns QUERY
        print("got: ")
        print(packet.summary())
        print("address: ", packet)
        dns_answer = DNSRR(  # DNS Reply
            rrname=dns.qd.qname,  # for question
            ttl=330,  # DNS entry Time to Live
            type="A",
            rclass="IN",
            rdata="",
        )  # found at IP: 1.1.1.1 :)
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
        simple_udp.sendto(bytes(dns_response), adresa_sursa)
simple_udp.close()
