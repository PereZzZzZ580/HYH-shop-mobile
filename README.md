# HyH Shop Mobile

Aplicación móvil Flutter para HyH Shop Barbería. Incluye catálogo de servicios, carrito de compras y flujo de checkout con integración a la pasarela de pagos Wompi.

## Configuración del entorno

1. Copia el archivo `.env.example` y renómbralo como `.env`.
2. Completa los valores correspondientes a tu proyecto, en especial las credenciales de Wompi:

   ```env
   WOMPI_PUBLIC_KEY=pub_test_xxxxxxxxx
   WOMPI_PRIVATE_KEY=prv_test_xxxxxxxxx
   WOMPI_INTEGRITY_SECRET=prod_integrity_secret_o_sandbox
   WOMPI_REDIRECT_URL=https://tuservidor.com/pagos/wompi
   WOMPI_ENV=sandbox
   ```

   > **Nota:** El `WOMPI_INTEGRITY_SECRET` se obtiene desde el panel de Wompi (Integridad de la firma) y se utiliza para generar la firma SHA-256 requerida por el checkout. El `WOMPI_REDIRECT_URL` es la URL a la que Wompi redirigirá al usuario después de finalizar el pago.

3. Asegúrate de tener configurado el endpoint del backend (`API_URL`) si la aplicación necesita conectarse a tus servicios.

## Flujo de pago con Wompi

Al seleccionar Wompi como método de pago en el checkout, la aplicación genera automáticamente la URL de pago firmada utilizando los datos del cliente y el total del pedido. Luego se abre la pasarela oficial de Wompi en el navegador del dispositivo para completar la transacción.

## Dependencias principales

- Flutter SDK
- provider
- dio
- url_launcher
- flutter_dotenv
- crypto

## Ejecutar el proyecto

1. Instala las dependencias:

   ```bash
   flutter pub get
   ```

2. Ejecuta la aplicación:

   ```bash
   flutter run
   ```

> Si no tienes Flutter instalado localmente, revisa la [documentación oficial](https://docs.flutter.dev/get-started/install) para configurarlo.
