import 'package:flutter/material.dart';
import 'package:flutter_cep/models/cep_model.dart';
import 'package:flutter_cep/repositories/cep_repository.dart';
import 'package:flutter_cep/ui/widgets/address_widget.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repository = CepRepository(client: http.Client());
  final cepController = TextEditingController();
  final cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  String? errorMessage;
  CepModel? address;
  bool isLoading = false;

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  Future<void> buscarCep() async {
    FocusScope.of(context).unfocus();
    setState(() {
      errorMessage = null;
      address = null;
      isLoading = true;
    });
    final cep = cepController.text.trim();
    if (cep.isEmpty) {
      setState(() {
        errorMessage = 'Digite um CEP válido!';
        isLoading = false;
      });
      return;
    }

    try {
      final resultAdrress = await repository.consultarCep(cep);
      setState(() {
        errorMessage = null;
        address = resultAdrress;
      });
    } on Exception catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll(RegExp(r'Exception:'), '');
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de CEP'),
        leading: Icon(Icons.location_city),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                spacing: 4,
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  Text(
                    'Busque por qualquer CEP',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Digite o CEP e descubra o endereço completo',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              maxLength: 9,
              inputFormatters: [cepFormatter],
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on_rounded),
                labelText: 'CEP',
                hintText: 'Digite o CEP (ex: 01310-100)',
                counterText: '',
              ),
              onSubmitted: (_) => buscarCep(),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      semanticsLabel: 'Buscando CEP',
                    )
                  : ElevatedButton.icon(
                      onPressed: buscarCep,
                      label: Text('Buscar CEP'),
                      icon: Icon(Icons.search_rounded),
                    ),
            ),
            Visibility(
              visible: errorMessage != null,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 24,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      errorMessage ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: address != null,
              child: AnimatedOpacity(
                opacity: address != null ? 1 : 0,
                duration: Duration(milliseconds: 1000),
                child: AddressWidget(address: address),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
