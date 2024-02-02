from django.urls import path

from . import views

urlpatterns = [
    # ex: /products/
    path("", views.index, name="index"),
    # ex: /products/5/
    path("<int:product_id>/", views.detail, name="detail"),
]
