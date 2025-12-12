import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../providers/client_provider.dart';
import '../../data/models/client_model.dart';

class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({super.key});

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientProvider>().getAllClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ClientProvider>().getAllClients();
            },
          ),
        ],
      ),
      body: Consumer<ClientProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.clients.isEmpty) {
            return const LoadingWidget(message: 'Carregando clientes...');
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.getAllClients();
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (provider.clients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum cliente encontrado',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.getAllClients(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.clients.length,
              itemBuilder: (context, index) {
                final client = provider.clients[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.secondary,
                      child: Text(
                        client.fullName?.substring(0, 1).toUpperCase() ??
                            client.email.substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(client.fullName ?? 'Sem nome'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(client.email),
                        if (client.enterpriseName != null)
                          Text(
                            'Empresa: ${client.enterpriseName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        if (client.celNumber != null)
                          Text(
                            'Tel: ${client.celNumber}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility,
                              color: AppColors.info),
                          onPressed: () {
                            _showClientDetails(context, client);
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: AppColors.error),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: const Text(
                                  'Deseja realmente excluir este cliente?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Excluir'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && context.mounted) {
                              final success =
                                  await provider.deleteClient(client.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? 'Cliente excluído com sucesso'
                                          : 'Erro ao excluir cliente',
                                    ),
                                    backgroundColor: success
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateClientDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateClientDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final enterpriseCtrl = TextEditingController();
    final celCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final roleIdCtrl = TextEditingController(text: '1');
    final orcamentoIdCtrl = TextEditingController(text: '1');
    final categoryIdCtrl = TextEditingController(text: '1');
    bool isSubmitting = false;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Criar cliente'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Informe o email' : null,
                  ),
                  TextFormField(
                    controller: passCtrl,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Informe a senha' : null,
                  ),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Nome completo (opcional)'),
                  ),
                  TextFormField(
                    controller: enterpriseCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Empresa (opcional)'),
                  ),
                  TextFormField(
                    controller: celCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Telefone (opcional)'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextFormField(
                    controller: addressCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Endereço (opcional)'),
                  ),
                  TextFormField(
                    controller: roleIdCtrl,
                    decoration: const InputDecoration(labelText: 'Role ID'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe o role id';
                      if (int.tryParse(v) == null) return 'Role id inválido';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: orcamentoIdCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Orçamento ID'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Informe o orçamento id';
                      if (int.tryParse(v) == null) return 'Id inválido';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: categoryIdCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Categoria ID'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Informe a categoria id';
                      if (int.tryParse(v) == null) return 'Id inválido';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar')),
            TextButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) return;
                      setState(() => isSubmitting = true);

                      final client = ClientCreateModel(
                        email: emailCtrl.text.trim().toLowerCase(),
                        password: passCtrl.text,
                        fullName:
                            nameCtrl.text.isEmpty ? null : nameCtrl.text.trim(),
                        enterpriseName: enterpriseCtrl.text.isEmpty
                            ? null
                            : enterpriseCtrl.text.trim(),
                        celNumber:
                            celCtrl.text.isEmpty ? null : celCtrl.text.trim(),
                        adress: addressCtrl.text.isEmpty
                            ? null
                            : addressCtrl.text.trim(),
                        profileImageUrl: null,
                        profileImageBase64: null,
                        roleId: int.parse(roleIdCtrl.text),
                        orcamentoId: int.parse(orcamentoIdCtrl.text),
                        categoryId: int.parse(categoryIdCtrl.text),
                      );

                      final success = await context
                          .read<ClientProvider>()
                          .createClient(client);

                      setState(() => isSubmitting = false);
                      if (!mounted) return;
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? 'Cliente criado'
                              : 'Erro ao criar cliente'),
                        ),
                      );
                    },
              child: isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Criar'),
            ),
          ],
        ),
      ),
    );

    emailCtrl.dispose();
    passCtrl.dispose();
    nameCtrl.dispose();
    enterpriseCtrl.dispose();
    celCtrl.dispose();
    addressCtrl.dispose();
    roleIdCtrl.dispose();
    orcamentoIdCtrl.dispose();
    categoryIdCtrl.dispose();
  }

  void _showClientDetails(BuildContext context, client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(client.fullName ?? 'Cliente'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Email', client.email),
              if (client.enterpriseName != null)
                _buildDetailRow('Empresa', client.enterpriseName!),
              if (client.celNumber != null)
                _buildDetailRow('Telefone', client.celNumber!),
              if (client.address != null)
                _buildDetailRow('Endereço', client.address!),
              _buildDetailRow('Role', client.role.name),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
