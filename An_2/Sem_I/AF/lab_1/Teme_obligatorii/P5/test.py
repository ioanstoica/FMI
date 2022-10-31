import unittest

class TestStringMethods(unittest.TestCase):
    def test_file(self):
        # assert files graf.out == expeted.out
        self.assertEqual(open('graf.out').read(), open('expected.out').read())

if __name__ == '__main__':
    unittest.main()