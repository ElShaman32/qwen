import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

/// Frase motivacional del día (descargada del Maestro).
class Frase {
  final String texto;
  final String? autor;
  final String categoria;

  const Frase({required this.texto, this.autor, required this.categoria});

  factory Frase.fromMap(Map<String, dynamic> map) => Frase(
        texto: map['texto'] as String? ?? '',
        autor: map['autor'] as String?,
        categoria: map['categoria'] as String? ?? 'motivacional',
      );
}

/// Repositorio de frases: lee del Maestro (default app) con fallback local.
/// NOTA: La app hace sign out del Maestro tras activación, por eso la lectura
/// debe ser pública (reglas: allow read: if true).
class FraseRepository {
  static final Logger _log = Logger();

  /// Frases de respaldo si no hay internet o el Maestro no responde.
  static const List<Frase> _fallback = [
    Frase(
      texto: 'El que madruga, Dios le ayuda... y el que cobra, más.',
      autor: 'Dicho criollo',
      categoria: 'humor',
    ),
    Frase(
      texto:
          'Tu bodega no crece con el cliente más grande, sino con el que vuelve.',
      autor: 'SiReBAi',
      categoria: 'ventas',
    ),
    Frase(
      texto: 'Échale pichón, que la bodega no se maneja sola.',
      autor: 'Dicho venezolano',
      categoria: 'motivacional',
    ),
  ];

  /// Descarga una frase aleatoria del Maestro (solo activas).
  /// Si falla, retorna una del fallback local (offline-first).
  Future<Frase> obtenerFraseDelDia() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('frases')
          .where('activo', isEqualTo: true)
          .get();

      if (snapshot.docs.isEmpty) {
        _log.w('No hay frases activas en el Maestro, usando fallback');
        return _fraseAleatoria(_fallback);
      }

      final docs = snapshot.docs;
      final random = DateTime.now().millisecondsSinceEpoch % docs.length;
      return Frase.fromMap(docs[random].data());
    } catch (e) {
      _log.e('Error descargando frases del Maestro, usando fallback: $e');
      return _fraseAleatoria(_fallback);
    }
  }

  Frase _fraseAleatoria(List<Frase> lista) {
    final random = DateTime.now().millisecondsSinceEpoch % lista.length;
    return lista[random];
  }
}
