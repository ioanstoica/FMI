from scapy.all import IP, UDP,sr1, DNS, DNSQR, DNSRR

# Get the IP address of a hostname
def get_ip_address(hostname):
    try:
        # DNS request către google DNS
        ip = IP(dst = '8.8.8.8')
        transport = UDP(dport = 53)

        # rd = 1 cod de request
        dns = DNS(rd = 1)

        # query pentru a afla entry de tipul 
        # dns_query = DNSQR(qname=b'fmi.unibuc.ro.', qtype=1, qclass=1) -> use hostname
        byte_hostname= hostname.encode()
        # !!!  print("Byte hostname: ", byte_hostname)
        dns_query = DNSQR(qname=byte_hostname, qtype=1, qclass=1)
        dns.qd = dns_query

        answer = sr1(ip / transport / dns)

        return answer[DNS].an.rdata
    except Exception as e:
        #   !!!print("Failed to retrieve the IP address of", hostname, "with socket.gaierror", e)
        return None
    
print(get_ip_address('domain.com'))
print(get_ip_address('infoarena.com'))
print(get_ip_address('google.com'))