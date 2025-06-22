import 'package:flutter/material.dart';
import '../models/nota.dart';
import '../services/database_service.dart';

class NotaFormScreen extends StatefulWidget {
  final Nota? nota;

  const NotaFormScreen({super.key, this.nota});

  @override
  State<NotaFormScreen> createState() => _NotaFormScreenState();
}

class _NotaFormScreenState extends State<NotaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.nota != null) {
      _tituloController.text = widget.nota!.titulo;
      _contenidoController.text = widget.nota!.contenido;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    _databaseService.closeConnection();
    super.dispose();
  }

  bool get _isEditing => widget.nota != null;

  Future<void> _saveNota() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now().toUtc();
      
      if (_isEditing) {
        // Actualizar nota existente
        final updatedNota = widget.nota!.copyWith(
          titulo: _tituloController.text.trim(),
          contenido: _contenidoController.text.trim(),
          fechaActualizacion: now,
        );
        
        final success = await _databaseService.updateNota(updatedNota);
        
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nota actualizada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        } else {
          throw Exception('No se pudo actualizar la nota');
        }
      } else {
        // Crear nueva nota
        final nuevaNota = Nota(
          titulo: _tituloController.text.trim(),
          contenido: _contenidoController.text.trim(),
          fechaCreacion: now,
          fechaActualizacion: now,
        );
        
        final id = await _databaseService.insertNota(nuevaNota);
        
        if (id > 0) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nota creada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        } else {
          throw Exception('No se pudo crear la nota');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al ${_isEditing ? 'actualizar' : 'crear'} nota: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDiscardDialog() {
    final hasChanges = _tituloController.text.trim().isNotEmpty ||
        _contenidoController.text.trim().isNotEmpty;

    if (!hasChanges) {
      Navigator.of(context).pop();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Descartar cambios'),
          content: const Text('¿Estás seguro de que quieres descartar los cambios?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.of(context).pop(); // Cerrar pantalla
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Descartar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Nota' : 'Nueva Nota'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _showDiscardDialog,
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveNota,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es requerido';
                  }
                  if (value.trim().length > 200) {
                    return 'El título no puede tener más de 200 caracteres';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contenidoController,
                  decoration: const InputDecoration(
                    labelText: 'Contenido',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El contenido es requerido';
                    }
                    return null;
                  },
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveNota,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(_isEditing ? Icons.update : Icons.save),
                  label: Text(_isEditing ? 'Actualizar' : 'Guardar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
