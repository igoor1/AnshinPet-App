import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/model/vaccine_model.dart';
import 'package:anshinpet/res/components/appbar_custom.dart';
import 'package:anshinpet/view_model/vaccine_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VaccineEditPage extends StatefulWidget {
  final VaccineModel vaccine;
  
  const VaccineEditPage({super.key, required this.vaccine});

  @override
  State<VaccineEditPage> createState() => _VaccineEditPageState();
}

class _VaccineEditPageState extends State<VaccineEditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _producerController;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _producerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vaccine.name);
    _producerController = TextEditingController(text: widget.vaccine.producer);
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppbarCustom(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome da Vacina',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if( value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _producerController,
                decoration: InputDecoration(
                  labelText: 'Fabricante',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, Insira um fabricante';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (!mounted) return;
                        Navigator.pop(context);
                        }, 
                      child: const Text('Cancelar')
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(124, 84, 217, 1),
                      ),
                      onPressed: _saveChanges,
                      child: Text(
                        'Salvar Alterações',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ), 
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showConfirmationDialog,
        backgroundColor: Colors.red.shade700, 
        foregroundColor: Colors.white,
        tooltip: 'Excluir Doença',
        child: const Icon(Icons.delete_outline),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Deseja realmente excluir esta doença?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              child: const Text('Excluir'),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteVaccine();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteVaccine() async {
    await Provider.of<VaccineViewModel>(context, listen: false).deleteVaccine(widget.vaccine.id);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedVaccine = VaccineModel(
        id: widget.vaccine.id,
        name: _nameController.text,
        producer: _producerController.text,
      );

      Provider.of<VaccineViewModel>(context, listen:false).updateVaccine(updatedVaccine);

      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
