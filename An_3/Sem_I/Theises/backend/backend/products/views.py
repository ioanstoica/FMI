from django.shortcuts import render
from django.http import HttpResponse
from django.shortcuts import get_object_or_404, render
from django.contrib.auth.decorators import login_required
from .scrap.olx import Olx

from .models import Product

def index(request):
    # If request type is post
    if request.method == "POST":
        # Get the form data
        product_name = request.POST.get("product_name")
        search_count = request.POST.get("search_count")

        url = "https://www.olx.ro/oferte/q-" + product_name + "/?search[filter_float_price%3Ato]=1000"

        # Scrap new products
        products = Olx.get_oferte(url, int(search_count))

        print(products)

        # Save the products
        for product in products:
            p = Product(
                name=product.titlu,
                description="",
                price=product.pret,
                url=product.url,
                view_count=0,
            )
            p.save()

    latest_product_list = Product.objects.order_by("-id")[:10]
    context = {
        "latest_product_list": latest_product_list,
    }

    return render(request, "products/index.html", context)

@login_required
def detail(request, product_id):
    product = get_object_or_404(Product, pk=product_id)
    return render(request, "products/detail.html", {"product": product})
