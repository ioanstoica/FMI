from django.http import HttpResponse
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login


def index(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect("/products/")
        else:
            # Mesaj de eroare în caz că autentificarea eșuează
            return HttpResponse("Autentificare eșuată")

    return render(request, "login/index.html", {})
