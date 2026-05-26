import 'package:flutter/material.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/viewmodel/create_activity_view_model.dart';
import 'package:frontend/widgets/rounded_button.dart';
import 'package:frontend/widgets/rounded_text_field.dart';
import 'package:provider/provider.dart';

class CreateActivityPage extends StatefulWidget {
  final User user;

  const CreateActivityPage({super.key, required this.user});

  @override
  State<CreateActivityPage> createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  // Controllers for text fields
  final _titleController = TextEditingController();
  final _departmentController = TextEditingController();
  final _beneficiariesController = TextEditingController();
  final _dayController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _departmentController.dispose();
    _beneficiariesController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 14),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF555555),
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _styledDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(label),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              items: items
                  .map(
                    (e) => DropdownMenuItem<T>(
                      value: e,
                      child: Text(e.toString()),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _toggleChip({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return FilterChip(
      label: Text(label),
      selected: value,
      onSelected: onChanged,
      selectedColor: const Color.fromARGB(255, 181, 245, 184),
      checkmarkColor: Colors.green.shade800,
      labelStyle: TextStyle(
        color: value ? Colors.green.shade800 : Colors.grey.shade700,
        fontWeight: value ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: value ? Colors.green.shade300 : Colors.grey.shade300,
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context) async {
    final vm = context.read<CreateActivityViewModel>();

    // Sync text-field values into the ViewModel before submitting
    vm.setTitle(_titleController.text);
    vm.setDepartment(_departmentController.text);
    vm.setBeneficiaries(_beneficiariesController.text);
    vm.setDay(_dayController.text);
    vm.setYear(_yearController.text);

    await vm.submitActivity(widget.user.uid as String? ?? '');

    if (!mounted) return;

    final status = vm.uiStatus;

    if (status == CreateActivityStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.message),
          backgroundColor: Colors.green.shade600,
        ),
      );
      _clearControllers();
      vm.resetStatus();
    } else if (status == CreateActivityStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.message),
          backgroundColor: Colors.red.shade600,
        ),
      );
      vm.resetStatus();
    }
  }

  void _clearControllers() {
    _titleController.clear();
    _departmentController.clear();
    _beneficiariesController.clear();
    _dayController.clear();
    _yearController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateActivityViewModel>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create CES Activity',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Fill in the details to create a new Community Extension Service activity.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionLabel('ACTIVITY TITLE *'),
                              RoundedTextField(
                                hintText: 'e.g. Tree Planting Drive',
                                labelText: 'Title',
                                height: 55,
                                width: double.infinity,
                                textController: _titleController,
                                obscure: false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: _styledDropdown<String>(
                            label: 'STATUS *',
                            value: vm.status,
                            items: CreateActivityViewModel.statuses,
                            onChanged: (v) {
                              if (v != null) vm.setStatus(v);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionLabel('DEPARTMENT *'),
                              RoundedTextField(
                                hintText: 'e.g. College of Engineering',
                                labelText: 'Department',
                                height: 55,
                                width: double.infinity,
                                textController: _departmentController,
                                obscure: false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _styledDropdown<String>(
                            label: 'ACTIVITY TYPE *',
                            value: vm.type,
                            items: CreateActivityViewModel.types,
                            onChanged: (v) {
                              if (v != null) vm.setType(v);
                            },
                          ),
                        ),
                      ],
                    ),

                    _sectionLabel('BENEFICIARIES *'),
                    RoundedTextField(
                      hintText: 'e.g. Indigenous peoples of Barangay X',
                      labelText: 'Beneficiaries',
                      height: 55,
                      width: double.infinity,
                      textController: _beneficiariesController,
                      obscure: false,
                    ),

                    _sectionLabel('DATE *'),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(1),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: vm.month,
                                items: CreateActivityViewModel.months
                                    .map(
                                      (m) => DropdownMenuItem(
                                        value: m,
                                        child: Text(m),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) vm.setMonth(v);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Day
                        Expanded(
                          flex: 1,
                          child: RoundedTextField(
                            hintText: 'DD',
                            labelText: 'Day',
                            height: 55,
                            width: double.infinity,
                            textController: _dayController,
                            obscure: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Year
                        Expanded(
                          flex: 2,
                          child: RoundedTextField(
                            hintText: 'YYYY',
                            labelText: 'Year',
                            height: 55,
                            width: double.infinity,
                            textController: _yearController,
                            obscure: false,
                          ),
                        ),
                      ],
                    ),

                    _sectionLabel('ACTIVITY FLAGS'),
                    Wrap(
                      spacing: 10,
                      children: [
                        _toggleChip(
                          label: 'Strenuous',
                          value: vm.isStrenuous,
                          onChanged: vm.setStrenuous,
                        ),
                        _toggleChip(
                          label: 'Off-Campus',
                          value: vm.isOffCampus,
                          onChanged: vm.setOffCampus,
                        ),
                        _toggleChip(
                          label: 'Private',
                          value: vm.isPrivate,
                          onChanged: vm.setPrivate,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: RoundedButton(
                        onPressed: vm.isLoading
                            ? () {}
                            : () => _handleSubmit(context),
                        height: 50,
                        width: double.infinity,
                        borderVal: 6,
                        backGroundColor: vm.isLoading
                            ? Colors.grey.shade300
                            : const Color.fromARGB(255, 41, 37, 37),
                        colors: Colors.white,
                        child: vm.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Create Activity',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
