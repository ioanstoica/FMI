# codul urmator ruleaza in paralel functia solve, sau nu?

with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
   while True:
      try:
         request, source_address = socket_udp.recvfrom(65535)
         future = executor.submit(solve, request, source_address, socket_udp)
         print(future.result())
      except KeyboardInterrupt:
         break
      except Exception as e:
         print("Exception:", e)
         continue