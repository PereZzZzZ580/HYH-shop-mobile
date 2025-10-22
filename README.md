# HyH Shop Mobile

Aplicacion Flutter para la version movil de HyH Shop Barberia. Incluye catalogo de productos, carrito de compras y flujo de checkout con la pasarela de pagos Wompi.

## Estructura rapida

- `lib/app` contiene la inicializacion de providers, el `MaterialApp` y la navegacion principal.
- `lib/core` mantiene configuraciones compartidas como el tema visual y utilidades.
- `lib/screens`, `lib/widgets`, `lib/models`, `lib/providers` y `lib/services` agrupan la logica de la tienda.

## Configuracion del entorno

1. Copia el archivo `.env.example` y renombralo como `.env`.
2. Define las variables de entorno segun tu despliegue:

   ```env
   API_URL=https://api.hyh-shop.com
   ASSET_BASE_URL=https://hyh-shop.com
   WOMPI_PUBLIC_KEY=pub_test_xxxxxxxxx
   WOMPI_PRIVATE_KEY=prv_test_xxxxxxxxx
   WOMPI_INTEGRITY_SECRET=tu_firma_wompi
   WOMPI_REDIRECT_URL=https://hyhshop.com/pagos/wompi
   WOMPI_ENV=sandbox
   APP_NAME=HyH Shop Barberia
   ```

3. Ajusta `API_URL` y claves segun el entorno (sandbox o produccion). El archivo `.env` se carga durante el arranque de la app.

## Flujo de pago con Wompi

Al elegir Wompi en el checkout se genera una URL firmada con la integridad requerida y se abre el flujo oficial en el navegador del dispositivo. La verificacion de la transaccion se realiza a traves del servicio `WompiService`.

## Dependencias principales

- Flutter SDK
- provider
- dio
- url_launcher
- flutter_dotenv
- crypto

## Comandos utiles

```bash
flutter pub get        # Instalar dependencias
flutter run            # Ejecutar la app
flutter test           # Correr pruebas unitarias o de widget
```

## Notas de desarrollo

- Las imagenes locales se referencian desde `assets/images/` o desde el CDN configurado en `ASSET_BASE_URL`.
- Mantener sincronizado el repositorio web `hyh-shop` ayuda a compartir estilos, descripciones y fotografias.
