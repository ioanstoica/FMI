import socket

def get_ip_address(hostname):
    try:
        # Send a DNS request to 8.8.8.8 and retrieve the IP address
        ip_address = socket.gethostbyname(hostname)
        return ip_address
    except socket.gaierror:
        return None

# Example usage
hostname = 'github.com'
ip_address = get_ip_address(hostname)
if ip_address is not None:
    print(f"The IP address of {hostname} is: {ip_address}")
else:
    print(f"Failed to retrieve the IP address of {hostname}")
