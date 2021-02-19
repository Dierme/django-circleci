from django.test import TestCase
from django.test import Client


class HelloWorldTestCase(TestCase):
    """Hello world tests"""

    def test_successful_case(self):
        """Successful test case"""
        self.assertTrue(True)

    def test_http_request(self):
        client = Client()
        response = client.get("/")

        self.assertEqual(200, response.status_code)
        self.assertEqual(response.content.decode(), "Hello world from Django! You're at the index. Bingo")
