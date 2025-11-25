from django.contrib.auth import get_user_model
User = get_user_model()

username = "Marco11"
password = "Markicio12"
email = "conriquezmarco@gmail.com"

if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username=username, email=email, password=password)
    print("Superusuario creado")
else:
    print("Superusuario ya existe")
