import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/viewmodels/donation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewDonationPage extends StatefulWidget {
  const NewDonationPage({super.key});

  @override
  State<NewDonationPage> createState() => _NewDonationPageState();
}

class _NewDonationPageState extends State<NewDonationPage> {
  final _descController = TextEditingController();
  final _valorController = TextEditingController();
  final _qntController = TextEditingController();

  String? _selectedType = "D";
  DateTime? _selectedDate;

  void _presentDatepicker() async { 
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context, 
      firstDate: firstDate, 
      lastDate: now,
      );
      if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
  
  Future<void> _submitForm(DonationViewModel viewModel) async {
    final descricao = _descController.text.trim();
    final tipo = _selectedType!;
    final data = _selectedDate;
    final valorText = _valorController.text.trim();
    final qntText = _qntController.text.trim();

    if (descricao.isEmpty || data == null) {
      _showErrorDialog();
      return;
    }

    final Map<String, dynamic> dataToSend = {
      "descricao": descricao,
      "tipo": tipo,
      "data": data.toIso8601String(),
      if (tipo == 'D') "valor": double.tryParse(valorText) ?? 0.0,
      if (tipo == 'R') "quantidade": double.tryParse(qntText) ?? 0,
    };

    await viewModel.createDonation(dataToSend);

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _showErrorDialog() {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: const Text('Valores Inválidos'),
        content: const Text('Por favor, certifique-se de que um título, valor, data e categoria válidos foram inseridos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    _valorController.dispose();
    _qntController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: const Text(
                'Cadastrar doação',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary
                )
              ),
             ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.savings_outlined, size: 18),
                      SizedBox(width: 4),
                      Text('Dinheiro'),
                    ],
                  ),
                  selected: _selectedType == "D",
                  onSelected: (_) {
                    setState(() {
                      _selectedType = "D";
                    });
                  },
                ),
                ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.inventory_2_outlined, size: 18),
                      SizedBox(width: 4),
                      Text('Ração'),
                    ],
                  ),
                  selected: _selectedType == "R",
                  onSelected: (_) {
                    setState(() {
                      _selectedType = "R";
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 50,),
            TextField(
              controller: _descController,
              maxLength: 50,
              decoration: InputDecoration(
                label: Text('Descricao'),
              ),
            ),
            SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                    ? 'Nenhuma data selecionada'
                    : 'Data de doação: ${DateFormat.yMd().format(_selectedDate!)}',
                  ),
                  IconButton(
                    onPressed: _presentDatepicker,
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ),
            SizedBox(height: 20,),
              if (_selectedType == 'D')
                TextField(
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                )
              else if (_selectedType == 'R')
                TextField(
                  controller: _qntController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantidade (kg)'),
                ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      if (!mounted) return;
                      Navigator.pop(context);
                    }, 
                    child: const Text('Cancelar')
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: context.watch<DonationViewModel>().loading
                      ? null
                      : () => _submitForm(context.read<DonationViewModel>()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ) 
          ],
        ),  
      ),
    );
  }
}