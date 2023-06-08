# run dns_add_blocker_server() from ./dns.py
import dns

import unittest
import socket

class TestDns(unittest.TestCase):
    # Check if the ip have the format x.x.x.x
    def is_ipv4(self, ip):
        parts = ip.split('.')
        if len(parts) != 4:
            return False

        for part in parts:
            if not part.isdigit() or int(part) < 0 or int(part) > 255:
                return False

        return True

    def test_is_ip(self):
        self.assertTrue(self.is_ipv4("127.0.0.1"))
        self.assertFalse(self.is_ipv4("127"))

    def test_get_ip_address(self):
        self.assertEqual(dns.get_ip_address("fmi.unibuc.ro"), "80.96.21.88")
        self.assertTrue(self.is_ipv4(dns.get_ip_address("google.com")))
        self.assertTrue(self.is_ipv4(dns.get_ip_address("fmi.unibuc.ro.")))

if __name__ == '__main__':
   unittest.main()