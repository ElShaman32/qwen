import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/formato.dart';
import '../../../clientes/data/cliente_dao.dart';

/// Diálogo de búsqueda y selección de cliente (para ventas fiadas).
class DialogoSeleccionCliente extends ConsumerStatefulWidget {
  const DialogoSeleccionCliente({super.key});

  @override
  ConsumerState<DialogoSeleccionCliente> createState() =>
      _DialogoSeleccionClienteState();
}

class _DialogoSeleccionClienteState
    extends ConsumerState<DialogoSeleccionCliente> {
  final _controller = TextEditingController();
  List<ClienteData> _clientes = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _buscar('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _buscar(String query) async {
    final lista = await ref.read(clienteDaoProvider).buscar(query);
    if (!mounted) return;
    setState(() {
      _clientes = lista;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: s.primary.withValues(alpha: 0.12),
                    ),
                    child: Icon(LucideIcons.userSearch,
                        color: s.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seleccionar cliente',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Para registrar el fiado',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: s.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Barra de búsqueda
              Container(
                decoration: BoxDecoration(
                  color: s.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: s.outlineVariant.withValues(alpha: 0.5)),
                ),
                padding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
                child: Row(
                  children: [
                    Icon(LucideIcons.search,
                        color: s.onSurfaceVariant, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Buscar por nombre o cédula...',
                          border: InputBorder.none,
                          filled: false,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: _buscar,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Lista de clientes
              Flexible(
                child: _cargando
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _clientes.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.users,
                                      size: 48, color: s.outline),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Sin clientes registrados',
                                    style: theme.textTheme.titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Agrega clientes desde el módulo Clientes',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(color: s.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _clientes.length,
                            itemBuilder: (context, index) {
                              final cliente = _clientes[index];
                              final debe = cliente.saldoPendienteUsd > 0;

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => Navigator.pop(context, cliente),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: s.surfaceContainerLowest,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: s.outlineVariant
                                            .withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Avatar
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: s.primary
                                                .withValues(alpha: 0.12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              cliente.nombre.isNotEmpty
                                                  ? cliente.nombre[0]
                                                      .toUpperCase()
                                                  : '?',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: s.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Info del cliente
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cliente.nombre,
                                                style: theme
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              if ((cliente.cedula ?? '')
                                                  .isNotEmpty)
                                                Text(
                                                  cliente.cedula ?? '',
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: s.onSurfaceVariant,
                                                  ),
                                                ),
                                              const SizedBox(height: 2),
                                              debe
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          LucideIcons
                                                              .alertCircle,
                                                          size: 12,
                                                          color: s.error,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          'Debe: ${Formato.usd(cliente.saldoPendienteUsd)}',
                                                          style: theme.textTheme
                                                              .labelSmall
                                                              ?.copyWith(
                                                            color: s.error,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        const Icon(
                                                          LucideIcons.check,
                                                          size: 12,
                                                          color:
                                                              Color(0xFF2E7D32),
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          'Al día',
                                                          style: theme.textTheme
                                                              .labelSmall
                                                              ?.copyWith(
                                                            color: const Color(
                                                                0xFF2E7D32),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),

                                        // Flecha
                                        Icon(LucideIcons.chevronRight,
                                            size: 20,
                                            color: s.onSurfaceVariant),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
