from django.shortcuts import render
from django.http import HttpResponse
from django.shortcuts import get_object_or_404, render
from django.contrib.auth.decorators import login_required
from .scrap.olx import Olx
from .scrap.main import from_olx_get_aliexpress

from .models import Product

def products(request):
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
            p1 = Product(
                name=product.titlu,
                description="",
                price=product.pret,
                url=product.url,
                view_count=0,
            )
            p1.save()

            # try:
            p_ali = from_olx_get_aliexpress(url)
            p2 = Product(
                name=p_ali.titlu,
                description="",
                price=p_ali.pret,
                url=p_ali.url,
                view_count=0,
            )
            p2.save()

            p1.similar_products.add(p2)
            
            # except:
            #     print("Cautarea de produse similare pe Aliexpress, a dat eroare.")


    latest_product_list = Product.objects.order_by("-id")[:10]
    similars = []
    for product in latest_product_list:
        if product.similar_products.all().count() > 0:
            similars.append(product.similar_products.all()[0])
        else:
            similars.append(None)
    context = {
        "latest_product_list": latest_product_list,
        "similars": similars,
    }

    return render(request, "products/index.html", context)

@login_required
def detail(request, product_id):
    product = get_object_or_404(Product, pk=product_id)
    return render(request, "products/detail.html", {"product": product})
