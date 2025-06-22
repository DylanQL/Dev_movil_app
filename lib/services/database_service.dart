import 'package:mysql1/mysql1.dart';
import '../models/nota.dart';

class DatabaseService {
  static const String _host = 'localhost';
  static const int _port = 3306;
  static const String _user = 'root';
  static const String _password = '123456';
  static const String _db = 'holamundo';

  MySqlConnection? _connection;

  // Helper method to convert Blob to String
  String _blobToString(dynamic value) {
    if (value == null) return '';
    
    if (value is String) return value;
    
    if (value is List<int>) {
      return String.fromCharCodes(value);
    }
    
    // For mysql1 package Blob objects - they have a toString() method that works
    if (value.runtimeType.toString() == 'Blob') {
      return value.toString();
    }
    
    // Last resort - try to convert as string
    return value.toString();
  }

  Future<MySqlConnection> _getConnection() async {
    if (_connection == null) {
      final settings = ConnectionSettings(
        host: _host,
        port: _port,
        user: _user,
        password: _password,
        db: _db,
      );
      _connection = await MySqlConnection.connect(settings);
    }
    return _connection!;
  }

  Future<void> closeConnection() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }
  }

  // CREATE - Crear una nueva nota
  Future<int> insertNota(Nota nota) async {
    try {
      final conn = await _getConnection();
      final result = await conn.query(
        'INSERT INTO notas_nota (titulo, contenido, fecha_creacion, fecha_actualizacion) VALUES (?, ?, ?, ?)',
        [
          nota.titulo,
          nota.contenido,
          nota.fechaCreacion.toUtc(),
          nota.fechaActualizacion.toUtc(),
        ],
      );
      return result.insertId!;
    } catch (e) {
      throw Exception('Error al insertar nota: $e');
    }
  }

  // READ - Obtener todas las notas
  Future<List<Nota>> getAllNotas() async {
    try {
      final conn = await _getConnection();
      final results = await conn.query('SELECT * FROM notas_nota ORDER BY fecha_creacion DESC');
      
      List<Nota> notas = [];
      for (var row in results) {
        try {
          final nota = Nota.fromMap({
            'id': row['id'],
            'titulo': row['titulo'],
            'contenido': _blobToString(row['contenido']),
            'fecha_creacion': row['fecha_creacion'],
            'fecha_actualizacion': row['fecha_actualizacion'],
          });
          notas.add(nota);
        } catch (e) {
          print('Error procesando nota ID ${row['id']}: $e');
        }
      }
      return notas;
    } catch (e) {
      throw Exception('Error al obtener notas: $e');
    }
  }

  // READ - Obtener una nota por ID
  Future<Nota?> getNotaById(int id) async {
    try {
      final conn = await _getConnection();
      final results = await conn.query('SELECT * FROM notas_nota WHERE id = ?', [id]);
      
      if (results.isNotEmpty) {
        final row = results.first;
        
        return Nota.fromMap({
          'id': row['id'],
          'titulo': row['titulo'],
          'contenido': _blobToString(row['contenido']),
          'fecha_creacion': row['fecha_creacion'],
          'fecha_actualizacion': row['fecha_actualizacion'],
        });
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener nota por ID: $e');
    }
  }

  // UPDATE - Actualizar una nota
  Future<bool> updateNota(Nota nota) async {
    try {
      final conn = await _getConnection();
      final now = DateTime.now().toUtc();
      final result = await conn.query(
        'UPDATE notas_nota SET titulo = ?, contenido = ?, fecha_actualizacion = ? WHERE id = ?',
        [
          nota.titulo,
          nota.contenido,
          now,
          nota.id,
        ],
      );
      return result.affectedRows! > 0;
    } catch (e) {
      throw Exception('Error al actualizar nota: $e');
    }
  }

  // DELETE - Eliminar una nota
  Future<bool> deleteNota(int id) async {
    try {
      final conn = await _getConnection();
      final result = await conn.query('DELETE FROM notas_nota WHERE id = ?', [id]);
      return result.affectedRows! > 0;
    } catch (e) {
      throw Exception('Error al eliminar nota: $e');
    }
  }

  // SEARCH - Buscar notas por título o contenido
  Future<List<Nota>> searchNotas(String query) async {
    try {
      final conn = await _getConnection();
      final results = await conn.query(
        'SELECT * FROM notas_nota WHERE titulo LIKE ? OR contenido LIKE ? ORDER BY fecha_creacion DESC',
        ['%$query%', '%$query%'],
      );
      
      List<Nota> notas = [];
      for (var row in results) {
        notas.add(Nota.fromMap({
          'id': row['id'],
          'titulo': row['titulo'],
          'contenido': _blobToString(row['contenido']),
          'fecha_creacion': row['fecha_creacion'],
          'fecha_actualizacion': row['fecha_actualizacion'],
        }));
      }
      return notas;
    } catch (e) {
      throw Exception('Error al buscar notas: $e');
    }
  }
}
