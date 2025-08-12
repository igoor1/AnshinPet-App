import 'package:anshinpet/configs/theme/app_colors.dart';
import 'package:anshinpet/model/donate_model.dart';
import 'package:anshinpet/view_model/donation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDonationPage extends StatefulWidget {
  final DonateModel donation;
  
  const EditDonationPage({
    super.key, 
    required this.donation
  });

  @override
  State<EditDonationPage> createState() => _EditDonationPageState();
}

class _EditDonationPageState extends State<EditDonationPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  late TextEditingController _quantidadeController;
  late TextEditingController _dataController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: widget.donation.descricao ?? '');
    _valorController = TextEditingController(text: widget.donation.valor?.toString() ?? '');
    _quantidadeController = TextEditingController(text: widget.donation.quantidade?.toString() ?? '');
    _selectedDate = widget.donation.data != null ? DateTime.tryParse(widget.donation.data!) : null;
    _dataController = TextEditingController(text: _selectedDate != null ? _formatDate(_selectedDate!) : '');
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _quantidadeController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }

  void _saveDonation() async {
    if (_formKey.currentState!.validate()) {
      final donationVM = Provider.of<DonationViewModel>(context, listen: false);

      widget.donation.descricao = _descricaoController.text;
      widget.donation.valor = double.tryParse(_valorController.text) ?? 0.0;
      widget.donation.quantidade = int.tryParse(_quantidadeController.text) ?? 0;
      widget.donation.data = _selectedDate?.toIso8601String();

      await donationVM.updateDonation(widget.donation);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final donationVM = Provider.of<DonationViewModel>(context);

    return Scaffold(
      body: donationVM.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40), 
                    Center(
                      child: const Text(
                        'Cadastrar doação',
                        style: TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary
                        )
                      ),
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child: ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.donation.tipo == 'D' ? Icons.savings_outlined : Icons.inventory_2_outlined,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(widget.donation.tipo == 'D' ? 'Dinheiro' : 'Ração'),
                          ],
                        ),
                        selected: true,
                        onSelected: null,
                        disabledColor: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(height: 16),                     
                    TextFormField(
                      controller: _descricaoController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Informe a descrição' : null,
                    ),
                    const SizedBox(height: 16),
                    if (widget.donation.tipo == 'D') ...[
                      TextFormField(
                        controller: _valorController,
                        decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Informe o valor' : null,
                      ),
                      const SizedBox(height: 16),
                    ] else if (widget.donation.tipo == 'R') ...[
                      TextFormField(
                        controller: _quantidadeController,
                        decoration: const InputDecoration(labelText: 'Quantidade'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Informe a quantidade' : null,
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _dataController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Data da Doação'),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                            _dataController.text = _formatDate(pickedDate);
                          });
                        }
                      },
                      validator: (value) => value == null || value.isEmpty ? 'Selecione a data' : null,
                    ),
                    const SizedBox(height: 30),
                    Row(
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
                          onPressed: _saveDonation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
