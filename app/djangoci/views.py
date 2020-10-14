from django.http import HttpResponse


def index(request):
    return HttpResponse(f"Hello world from Django! You're at the index.")
