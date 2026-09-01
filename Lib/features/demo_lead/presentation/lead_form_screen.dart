import 'package:el_cuaderno_de_mario/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/marca_logo.dart';
import '../data/lead_repository.dart';

/// Pantalla de formulario para capturar leads del modo demo.
/// Fuera del shell (pantalla completa), branding SiReBAi.
class LeadFormScreen extends StatefulWidget {
  const LeadFormScreen({super.key});

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreBodegaController = TextEditingController();
  final _contactoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _notasController = TextEditingController();

  final _repository = LeadRepository();
  bool _isLoading = false;
  bool _enviado = false;
  int _numeroCola = 0;

  static const _telefonoSiReBAi = '584245829375';

  @override
  void dispose() {
    _nombreBodegaController.dispose();
    _contactoController.dispose();
    _telefonoController.dispose();
    _ciudadController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _enviarFormulario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final exito = await _repository.guardarLead(
      nombreBodega: _nombreBodegaController.text,
      contacto: _contactoController.text,
      telefono: _telefonoController.text,
      ciudad: _ciudadController.text,
      notas: _notasController.text,
    );

    if (!mounted) return;

    if (exito) {
      setState(() {
        _enviado = true;
        _numeroCola = _repository.generarNumeroCola();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Error al enviar. Intenta de nuevo o contáctanos por WhatsApp.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _abrirWhatsapp() async {
    final mensaje =
        'Hola SiReBAi, probé El Cuaderno de Mario en modo demo y quiero registrarme. '
        'Mi bodega es "${_nombreBodegaController.text}" en ${_ciudadController.text}. '
        'Contacto: ${_contactoController.text}, Teléfono: ${_telefonoController.text}';

    final uri = Uri.parse(
      'https://wa.me/$_telefonoSiReBAi?text=${Uri.encodeComponent(mensaje)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _llamar() async {
    final uri = Uri.parse('tel:$_telefonoSiReBAi');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _enviado
                  ? _buildPantallaExito(theme)
                  : _buildFormulario(theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormulario(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MarcaLogo(size: 80),
          const SizedBox(height: 16),
          Text(
            '¡Registra tu bodega!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Completa tus datos y te contactaremos para activar tu cuenta.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Nombre de la bodega
          TextFormField(
            controller: _nombreBodegaController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nombre de tu bodega',
              hintText: 'Bodega Don Luis',
              prefixIcon: Icon(Icons.store_outlined),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),

          // Nombre del contacto
          TextFormField(
            controller: _contactoController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Tu nombre',
              hintText: 'Luis Pérez',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),

          // Teléfono
          TextFormField(
            controller: _telefonoController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\-\+\s]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              hintText: '0412-1234567',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Requerido';
              final limpio = v.replaceAll(RegExp(r'[^\d]'), '');
              if (limpio.length < 10) return 'Número muy corto';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Ciudad
          TextFormField(
            controller: _ciudadController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Ciudad',
              hintText: 'Caracas, Maracaibo, Valencia...',
              prefixIcon: Icon(Icons.location_city_outlined),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),

          // Notas (opcional)
          TextFormField(
            controller: _notasController,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Notas (opcional)',
              hintText: '¿Cuántas cajas tienes? ¿Qué plan te interesa?',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
          ),
          const SizedBox(height: 32),

          // Botón enviar
          FilledButton.icon(
            onPressed: _isLoading ? null : _enviarFormulario,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            label: Text(_isLoading ? 'Enviando...' : '¡Listo! Enviar'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),

          const SizedBox(height: 32),

          TextButton(
            onPressed: () => context.go(AppRoutes.activacion),
            child: Text(
              '¿Ya tienes cuenta? Inicia sesión',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 32),
          Text(
            'Soporte: SiReBAi',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPantallaExito(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.check_circle,
          size: 80,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        Text(
          '¡Registro exitoso!',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(
                '🎉 Estás en cola',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '#$_numeroCola',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'En breve nos comunicaremos contigo para activar tu cuenta.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '¿Quieres ser atendido a la brevedad?',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Botón WhatsApp
        FilledButton.icon(
          onPressed: _abrirWhatsapp,
          icon: const Icon(Icons.chat),
          label: const Text('Contactar por WhatsApp'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF25D366),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
        const SizedBox(height: 12),

        // Botón Llamar
        OutlinedButton.icon(
          onPressed: _llamar,
          icon: const Icon(Icons.phone),
          label: const Text('Llamar ahora'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Soporte: SiReBAi',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
