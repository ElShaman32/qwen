// Modelo y datos estáticos del onboarding
class OnboardingPage {
  final String iconEmoji;
  final String title;
  final String description;

  const OnboardingPage({
    required this.iconEmoji,
    required this.title,
    required this.description,
  });
}

const List<OnboardingPage> onboardingPages = [
  OnboardingPage(
    iconEmoji: '🏪',
    title: 'Bienvenido a El Cuaderno de Mario',
    description: 'La app que te ayuda a controlar tu bodega sin complicaciones',
  ),
  OnboardingPage(
    iconEmoji: '💰',
    title: 'Controla tus ventas',
    description: 'Registra ventas, métodos de pago, fiados y más en segundos',
  ),
  OnboardingPage(
    iconEmoji: '📦',
    title: 'Gestiona tu inventario',
    description: 'Productos, stock, alertas de vencimiento y más',
  ),
  OnboardingPage(
    iconEmoji: '📊',
    title: 'Reportes y ganancias',
    description: 'Ve cuánto ganas, qué vendes más y toma mejores decisiones',
  ),
];

// URL del video de bienvenida (placeholder - cambiar cuando tengamos el video real)
const String videoBienvenidaUrl = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';

// URL de política de privacidad
const String politicaPrivacidadUrl =
    'https://elshaman32.github.io/cuaderno-de-mario/politicas-privacidad/';

// Texto legal completo para el diálogo
const String textoLegalCompleto = '''
TÉRMINOS Y CONDICIONES DE USO - El Cuaderno de Mario

1. ACEPTACIÓN
Al utilizar esta aplicación, aceptas estos términos en su totalidad.

2. SERVICIO
El Cuaderno de Mario es una aplicación POS para bodegas venezolanas que
funciona offline-first y sincroniza con la nube cuando hay internet.

3. MODO DEMO
El modo de prueba de 24 horas permite probar todas las funcionalidades.
Los datos de prueba se conservan tras la activación de una cuenta real.

4. PRIVACIDAD DE DATOS
- Tus datos de negocio se almacenan en tu propio proyecto Firebase.
- El desarrollador (SiReBAi) NO tiene acceso a tus ventas ni inventario.
- Solo se comparten datos de configuración necesarios para el servicio.

5. SUSCRIPCIÓN
- Plan gratuito: funcionalidades básicas sin personalización.
- Planes pagos: funcionalidades avanzadas + whitelabel.
- El vencimiento baja al plan gratuito automáticamente (no elimina datos).

6. RESPONSABILIDAD
La app se provee "tal cual". No nos hacemos responsables por pérdidas
económicas derivadas del uso o mal uso de la aplicación.

7. MODIFICACIONES
Nos reservamos el derecho de modificar estos términos. Los cambios se
notificarán dentro de la app.

Para consultas: sirebai.ventas@gmail.com
''';
