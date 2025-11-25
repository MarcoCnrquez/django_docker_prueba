from django.db import models

# Create your models here.
class Producto(models.Model):
    # Campo de texto para el nombre del producto
    nombre = models.CharField(max_length=100)
    
    # Campo numérico para la cantidad en inventario
    cantidad = models.IntegerField(default=0)
    
    # Campo para el precio (decimal con 6 dígitos en total, 2 decimales)
    precio = models.DecimalField(max_digits=6, decimal_places=2)

    # Método que define cómo se representa el objeto en el Admin
    def __str__(self):
        return self.nombre