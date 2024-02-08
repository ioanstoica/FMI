from django.db import models

# Create your models here.


class Product(models.Model):
    name = models.CharField(max_length=255, null = True)
    description = models.TextField(null = True)
    price = models.DecimalField(max_digits=12, decimal_places=2, null = True)
    url = models.URLField(max_length=255, null = True)
    view_count = models.IntegerField(default=0)

    similar_products = models.ManyToManyField('self', blank=True)

    def __str__(self):
        return self.name
