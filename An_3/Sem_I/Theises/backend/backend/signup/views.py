from django.contrib.auth.forms import UserCreationForm
from django.urls import reverse_lazy
from django.views import generic


class SignUpView(generic.CreateView):
    form_class = UserCreationForm
    success_url = (
        "/login/"  # Redirecționează către pagina de login după înregistrare cu succes
    )
    template_name = (
        "signup/signup.html"  # Specifică calea către template-ul pentru înregistrare
    )
