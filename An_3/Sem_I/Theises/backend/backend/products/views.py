from django.http import HttpResponse
from django.template import loader

from .models import Product


def index(request):
    latest_product_list = Product.objects.order_by("-id")[:10]
    template = loader.get_template("products/index.html")
    context = {
        "latest_product_list": latest_product_list,
    }

    return HttpResponse(template.render(context, request))

def detail(request, product_id):
    return HttpResponse(f"You're looking at product with id: {product_id}.")
