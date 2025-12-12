import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../providers/orcamento_provider.dart';
import '../../data/models/orcamento_model.dart';

class OrcamentosListScreen extends StatefulWidget {
  const OrcamentosListScreen({super.key});

  @override
  State<OrcamentosListScreen> createState() => _OrcamentosListScreenState();
}

class _OrcamentosListScreenState extends State<OrcamentosListScreen> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrcamentoProvider>().getAllOrcamentos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<OrcamentoProvider>().getAllOrcamentos();
            },
          ),
        ],
      ),
      body: Consumer<OrcamentoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.orcamentos.isEmpty) {
            return const LoadingWidget(message: 'Carregando orçamentos...');
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
                      provider.getAllOrcamentos();
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (provider.orcamentos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum orçamento encontrado',
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
            onRefresh: () => provider.getAllOrcamentos(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.orcamentos.length,
              itemBuilder: (context, index) {
                final orcamento = provider.orcamentos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.warning,
                      child: const Icon(
                        Icons.attach_money,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      orcamento.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          currencyFormatter.format(orcamento.value),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          orcamento.descr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                            _showOrcamentoDetails(context, orcamento);
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
                                  'Deseja realmente excluir este orçamento?',
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
                                  await provider.deleteOrcamento(orcamento.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? 'Orçamento excluído com sucesso'
                                          : 'Erro ao excluir orçamento',
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
        onPressed: () => _showCreateOrcamentoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateOrcamentoDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final valueCtrl = TextEditingController();
    final dateCtrl = TextEditingController(
        text: DateTime.now().millisecondsSinceEpoch.toString());
    final descrCtrl = TextEditingController();
    final clientIdCtrl = TextEditingController(text: '1');
    final categoryIdCtrl = TextEditingController(text: '1');
    bool isSubmitting = false;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Criar orçamento'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Informe o nome' : null,
                  ),
                  TextFormField(
                    controller: valueCtrl,
                    decoration: const InputDecoration(labelText: 'Valor'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe o valor';
                      if (double.tryParse(v.replaceAll(',', '.')) == null)
                        return 'Valor inválido';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: dateCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Data (ms desde epoch)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: descrCtrl,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: clientIdCtrl,
                    decoration: const InputDecoration(labelText: 'Cliente ID'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe o cliente id';
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

                      final orcamento = OrcamentoCreateModel(
                        name: nameCtrl.text.trim(),
                        value:
                            double.parse(valueCtrl.text.replaceAll(',', '.')),
                        date: int.tryParse(dateCtrl.text) ??
                            DateTime.now().millisecondsSinceEpoch,
                        descr: descrCtrl.text.trim(),
                        clientId: int.parse(clientIdCtrl.text),
                        categoryId: int.parse(categoryIdCtrl.text),
                      );

                      final success = await context
                          .read<OrcamentoProvider>()
                          .createOrcamento(orcamento);

                      setState(() => isSubmitting = false);
                      if (!mounted) return;
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? 'Orçamento criado'
                              : 'Erro ao criar orçamento'),
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

    nameCtrl.dispose();
    valueCtrl.dispose();
    dateCtrl.dispose();
    descrCtrl.dispose();
    clientIdCtrl.dispose();
    categoryIdCtrl.dispose();
  }

  void _showOrcamentoDetails(BuildContext context, orcamento) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(orcamento.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(
                  'Valor', currencyFormatter.format(orcamento.value)),
              _buildDetailRow('Descrição', orcamento.descr),
              _buildDetailRow('Cliente ID', orcamento.clientId.toString()),
              _buildDetailRow('Categoria ID', orcamento.categoryId.toString()),
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
