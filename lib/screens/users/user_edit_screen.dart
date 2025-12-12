import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/user_model.dart';
import '../../data/models/role_model.dart';
import '../../core/constants/api_constants.dart';
import '../../data/services/api_service.dart';
import '../../providers/user_provider.dart';

class UserEditScreen extends StatefulWidget {
  final UserModel user;
  const UserEditScreen({super.key, required this.user});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameCtrl;
  List<RoleModel> _roles = [];
  RoleModel? _selectedRole;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController(text: widget.user.fullName ?? '');
    _fetchRoles();
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchRoles() async {
    try {
      final res = await ApiService().get(ApiConstants.roles);
      if (res.statusCode == 200) {
        final List<dynamic> data = res.data as List<dynamic>;
        setState(() {
          _roles = data.map((j) => RoleModel.fromJson(j)).toList();
          _selectedRole = _roles.firstWhere(
            (r) =>
                r.name == widget.user.role.name || r.id == widget.user.role.id,
            orElse: () => _roles.isNotEmpty ? _roles.first : null,
          );
        });
      }
    } catch (_) {
      // ignore errors: roles remain empty
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Update full name via provider
    final success = await context.read<UserProvider>().updateUser(
          widget.user.id,
          UserUpdateModel(
              fullName: _fullNameCtrl.text.isEmpty
                  ? null
                  : _fullNameCtrl.text.trim()),
        );

    // If role changed, try to update role via API directly (backend may require a different endpoint)
    if (_selectedRole != null && _selectedRole!.id != widget.user.role.id) {
      try {
        await ApiService().put(ApiConstants.userById(widget.user.id),
            data: {'role_id': _selectedRole!.id});
      } catch (_) {
        // ignore role update error
      }
    }

    setState(() => _isLoading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              success ? 'Usuário atualizado' : 'Erro ao atualizar usuário')),
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.user.email,
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: false,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fullNameCtrl,
                decoration: const InputDecoration(labelText: 'Nome completo'),
              ),
              const SizedBox(height: 12),
              _roles.isEmpty
                  ? const SizedBox()
                  : DropdownButtonFormField<RoleModel>(
                      value: _selectedRole,
                      items: _roles
                          .map((r) =>
                              DropdownMenuItem(value: r, child: Text(r.name)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedRole = v),
                      decoration: const InputDecoration(labelText: 'Role'),
                    ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Salvar'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
