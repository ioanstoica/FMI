# DNS server that server response from 8.8.8.8
import socket

port = 53
ip = '127.0.0.1'

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((ip, port))

while 1:
    data, addr = sock.recvfrom(512)
    r = buildresponse(data)
    sock.sendto(r, addr)