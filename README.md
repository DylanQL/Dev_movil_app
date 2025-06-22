# CRUD de Notas - Flutter App

Una aplicación Flutter que implementa un CRUD completo para gestionar notas conectada a una base de datos MySQL.

## Características

- ✅ **Crear** nuevas notas con título y contenido
- ✅ **Leer** y visualizar todas las notas
- ✅ **Actualizar** notas existentes
- ✅ **Eliminar** notas con confirmación
- ✅ **Buscar** notas por título o contenido
- ✅ Interfaz moderna y responsive
- ✅ Validación de formularios
- ✅ Manejo de errores
- ✅ Indicadores de carga
- ✅ Fechas de creación y actualización

## Requisitos

### Base de Datos MySQL
- MySQL Server
- Base de datos: `holamundo`
- Usuario: `root`
- Contraseña: `123456`

### Flutter
- Flutter SDK
- Dart SDK

## Configuración

### 1. Base de Datos

1. Asegúrate de tener MySQL instalado y ejecutándose
2. Crea la base de datos `holamundo`:
   ```sql
   CREATE DATABASE holamundo;
   ```
3. Ejecuta el script SQL proporcionado en `database/create_table.sql`:
   ```bash
   mysql -u root -p holamundo < database/create_table.sql
   ```

### 2. Configuración de la Aplicación

1. Clona o descarga el proyecto
2. Instala las dependencias:
   ```bash
   flutter pub get
   ```
3. Si necesitas cambiar la configuración de la base de datos, edita el archivo `lib/services/database_service.dart`:
   ```dart
   static const String _host = 'localhost';  // Cambia si es necesario
   static const int _port = 3306;
   static const String _user = 'root';       // Tu usuario de MySQL
   static const String _password = '123456'; // Tu contraseña de MySQL
   static const String _db = 'holamundo';    // Nombre de tu base de datos
   ```

## Ejecución

### Desarrollo
```bash
flutter run
```

### Construcción para producción
```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## Estructura del Proyecto

```
lib/
├── main.dart                     # Punto de entrada de la aplicación
├── models/
│   └── nota.dart                 # Modelo de datos para las notas
├── services/
│   └── database_service.dart     # Servicio para operaciones de base de datos
└── screens/
    ├── notas_list_screen.dart    # Pantalla principal con lista de notas
    └── nota_form_screen.dart     # Pantalla para crear/editar notas
```

## Funcionalidades Detalladas

### Pantalla Principal (Lista de Notas)
- Muestra todas las notas ordenadas por fecha de creación
- Barra de búsqueda en tiempo real
- Menú contextual para cada nota (editar/eliminar)
- Pull-to-refresh para actualizar la lista
- Botón flotante para agregar nuevas notas

### Pantalla de Formulario
- Campos validados para título y contenido
- Modo crear/editar automático
- Guardado automático de fechas
- Confirmación antes de descartar cambios

### Base de Datos
- Conexión persistente a MySQL
- Operaciones CRUD completas
- Manejo de errores de conexión
- Búsqueda por texto en título y contenido

## Dependencias

- `mysql1: ^0.20.0` - Conector MySQL para Dart
- `intl: ^0.19.0` - Internacionalización y formateo de fechas
- `http: ^1.1.0` - Cliente HTTP (para futuras extensiones)

## Personalización

### Cambiar el tema
Edita el `main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), // Cambia el color
  useMaterial3: true,
),
```

### Agregar nuevos campos
1. Actualiza el modelo `Nota` en `lib/models/nota.dart`
2. Modifica la tabla en MySQL
3. Actualiza las consultas en `database_service.dart`
4. Agrega los campos al formulario en `nota_form_screen.dart`

## Solución de Problemas

### Error de conexión a MySQL
- Verifica que MySQL esté ejecutándose
- Confirma las credenciales en `database_service.dart`
- Asegúrate de que la base de datos `holamundo` exista

### Error de dependencias
```bash
flutter clean
flutter pub get
```

### Problemas de permisos de red (Android)
Agrega en `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## Próximas Mejoras

- [ ] Sincronización offline
- [ ] Categorías para las notas
- [ ] Adjuntar imágenes
- [ ] Exportar notas
- [ ] Backup automático
- [ ] Modo oscuro
- [ ] Filtros por fecha

## Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.
