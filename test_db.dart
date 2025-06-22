import 'dart:io';
import 'package:mysql1/mysql1.dart';

void main() async {
  print('Iniciando test de conexión a MySQL...');
  
  try {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '123456',
      db: 'holamundo',
    );
    
    print('Intentando conectar con configuración: $settings');
    final conn = await MySqlConnection.connect(settings);
    print('✅ Conexión exitosa a MySQL');
    
    final results = await conn.query('SELECT * FROM notas_nota ORDER BY fecha_creacion DESC');
    print('✅ Query ejecutado exitosamente');
    print('Número de resultados: ${results.length}');
    
    for (var row in results) {
      print('Fila: $row');
      print('ID: ${row['id']}');
      print('Título: ${row['titulo']}');
      print('Contenido: ${row['contenido']}');
      print('Fecha creación: ${row['fecha_creacion']} (${row['fecha_creacion'].runtimeType})');
      print('Fecha actualización: ${row['fecha_actualizacion']} (${row['fecha_actualizacion'].runtimeType})');
      print('---');
    }
    
    await conn.close();
    print('✅ Conexión cerrada correctamente');
    
  } catch (e) {
    print('❌ Error: $e');
    print('Stack trace: ${StackTrace.current}');
  }
  
  exit(0);
}
