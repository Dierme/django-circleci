from django.http import HttpResponse, JsonResponse


def index(request):
    return HttpResponse(f"Hello world from Django! You're at the index.")


def healthcheck(request):
    return JsonResponse({"success": True})
