class Nota {
  final int? id;
  final String titulo;
  final String contenido;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  Nota({
    this.id,
    required this.titulo,
    required this.contenido,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      contenido: map['contenido'] as String,
      fechaCreacion: _parseDateTime(map['fecha_creacion']),
      fechaActualizacion: _parseDateTime(map['fecha_actualizacion']),
    );
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) {
      return DateTime.now();
    }
    
    if (dateValue is DateTime) {
      return dateValue;
    }
    
    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        print('Error parsing date string: $dateValue, error: $e');
        return DateTime.now();
      }
    }
    
    // Si es un objeto del tipo que devuelve MySQL
    try {
      return DateTime.parse(dateValue.toString());
    } catch (e) {
      print('Error parsing date object: $dateValue, error: $e');
      return DateTime.now();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'contenido': contenido,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion.toIso8601String(),
    };
  }

  Nota copyWith({
    int? id,
    String? titulo,
    String? contenido,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return Nota(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      contenido: contenido ?? this.contenido,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}
