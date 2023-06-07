import socketserver
import concurrent.futures

class ThreadedTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    pass

class EchoHandler(socketserver.BaseRequestHandler):
    def handle(self):
        data = self.request.recv(1024).strip()
        print(f'Adresa: {self.client_address[0]} a trimis: {data.decode()}')

        with concurrent.futures.ThreadPoolExecutor() as executor:
            executor.submit(self.request.sendall, data)

if __name__ == "__main__":
    with ThreadedTCPServer(("localhost", 12345), EchoHandler) as server:
        print('Server TCP pornit pe portul 12345...')
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print('Serverul a fost oprit.')
            server.shutdown()

# Puteți rula serverul și apoi conectați-vă la acesta de pe același computer cu telnet localhost 12345 sau puteți scrie un script client care să se conecteze la acesta.