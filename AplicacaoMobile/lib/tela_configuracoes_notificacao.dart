import 'package:flutter/material.dart';

class TelaConfiguracoesNotificacao extends StatefulWidget {
  const TelaConfiguracoesNotificacao({super.key});

  @override
  State<TelaConfiguracoesNotificacao> createState() =>
      _TelaConfiguracoesNotificacaoState();
}

class _TelaConfiguracoesNotificacaoState
    extends State<TelaConfiguracoesNotificacao> {
  bool _notificacoesGeral = true;
  bool _notificacoesEmail = true;
  bool _notificacoesPush = true;
  bool _alertasAnimaisProximos = true;
  bool _notificacoesNovidades = false;

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações de Notificação'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Preferências de Notificação",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Gerencie como você deseja receber notificações do ReconectaPet",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // Notificações Gerais
                      _itemConfiguracao(
                        "Notificações Gerais",
                        "Ativar todas as notificações",
                        _notificacoesGeral,
                        (value) {
                          setState(() {
                            _notificacoesGeral = value;
                            if (!value) {
                              _notificacoesEmail = false;
                              _notificacoesPush = false;
                              _alertasAnimaisProximos = false;
                              _notificacoesNovidades = false;
                            }
                          });
                        },
                      ),

                      const Divider(),

                      // Tipos de notificação (só aparecem se notificações gerais estiverem ativas)
                      if (_notificacoesGeral) ...[
                        _itemConfiguracao(
                          "Notificações por Email",
                          "Receber notificações por email",
                          _notificacoesEmail,
                          (value) => setState(() => _notificacoesEmail = value),
                        ),

                        _itemConfiguracao(
                          "Notificações Push",
                          "Receber notificações no app",
                          _notificacoesPush,
                          (value) => setState(() => _notificacoesPush = value),
                        ),

                        _itemConfiguracao(
                          "Alertas de Animais Próximos",
                          "Notificar sobre animais perdidos na sua região",
                          _alertasAnimaisProximos,
                          (value) =>
                              setState(() => _alertasAnimaisProximos = value),
                        ),

                        _itemConfiguracao(
                          "Novidades e Atualizações",
                          "Receber novidades sobre o app",
                          _notificacoesNovidades,
                          (value) =>
                              setState(() => _notificacoesNovidades = value),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Frequência de Notificações",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _itemFrequencia("Imediato", "Notificações instantâneas"),
                      _itemFrequencia("Diário", "Resumo diário"),
                      _itemFrequencia("Semanal", "Resumo semanal"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _mostrarMensagem('Configurações salvas com sucesso!');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Salvar Configurações",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _notificacoesGeral = true;
                    _notificacoesEmail = true;
                    _notificacoesPush = true;
                    _alertasAnimaisProximos = true;
                    _notificacoesNovidades = false;
                  });
                  _mostrarMensagem('Configurações restauradas para padrão');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Restaurar Padrões",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemConfiguracao(
    String titulo,
    String subtitulo,
    bool valor,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(value: valor, onChanged: onChanged, activeColor: Colors.cyan),
        ],
      ),
    );
  }

  Widget _itemFrequencia(String titulo, String subtitulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitulo,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Radio(
            value: titulo,
            groupValue: "Imediato", // Valor fixo para exemplo
            onChanged: (value) {
              _mostrarMensagem('Frequência alterada para: $value');
            },
            activeColor: Colors.cyan,
          ),
        ],
      ),
    );
  }
}
