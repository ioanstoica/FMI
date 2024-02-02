from django.shortcuts import render
from django.http import HttpResponse
from django.shortcuts import get_object_or_404, render


from .models import Product


def index(request):
    latest_product_list = Product.objects.order_by("-id")[:10]
    context = {
        "latest_product_list": latest_product_list,
    }

    return render(request, "products/index.html", context)


def detail(request, product_id):
    product = get_object_or_404(Product, pk=product_id)
    return render(request, "products/detail.html", {"product": product})
