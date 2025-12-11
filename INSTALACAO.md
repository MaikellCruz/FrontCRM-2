# Guia de Instalação - Flutter CRM App

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

1. **Flutter SDK** (versão 3.0.0 ou superior)
   - Download: https://flutter.dev/docs/get-started/install
   - Verifique a instalação: `flutter doctor`

2. **Dart SDK** (incluído com Flutter)
   - Versão 3.0.0 ou superior

3. **Editor de código**
   - Visual Studio Code (recomendado) com extensões Flutter e Dart
   - Android Studio
   - IntelliJ IDEA

4. **Backend FastAPI**
   - O backend BackCRM-2 deve estar rodando
   - Anote a URL do backend (ex: http://localhost:8000)

## Passo 1: Configurar o Projeto

### 1.1 Navegue até o diretório do projeto

```bash
cd flutter_crm_app
```

### 1.2 Instale as dependências

```bash
flutter pub get
```

### 1.3 Configure a URL da API

Edite o arquivo `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'http://SEU_IP:8000';
```

**Importante:** 
- Para Android Emulator, use: `http://10.0.2.2:8000`
- Para iOS Simulator, use: `http://localhost:8000`
- Para dispositivo físico, use o IP da sua máquina na rede local (ex: `http://192.168.1.100:8000`)

## Passo 2: Verificar Configuração

Execute o comando para verificar se tudo está configurado corretamente:

```bash
flutter doctor
```

Resolva quaisquer problemas indicados pelo comando acima.

## Passo 3: Executar o Aplicativo

### Para Android

```bash
# Listar dispositivos disponíveis
flutter devices

# Executar no emulador/dispositivo Android
flutter run
```

### Para iOS (apenas macOS)

```bash
# Executar no simulador iOS
flutter run
```

### Para Web

```bash
flutter run -d chrome
```

### Para Desktop (Windows/macOS/Linux)

```bash
flutter run -d windows  # Windows
flutter run -d macos    # macOS
flutter run -d linux    # Linux
```

## Passo 4: Fazer Login

Use as credenciais de um usuário cadastrado no backend para fazer login.

**Exemplo de credenciais (se você criou no backend):**
- Email: `admin@example.com`
- Senha: `password123`

## Comandos Úteis

### Limpar cache e rebuild

```bash
flutter clean
flutter pub get
flutter run
```

### Verificar problemas

```bash
flutter doctor -v
```

### Atualizar dependências

```bash
flutter pub upgrade
```

### Gerar build de produção

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle (para Google Play)
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## Solução de Problemas Comuns

### Erro de conexão com API

**Problema:** Não consegue conectar ao backend

**Solução:**
1. Verifique se o backend está rodando
2. Confirme a URL da API em `api_constants.dart`
3. Para Android Emulator, use `10.0.2.2` ao invés de `localhost`
4. Desative firewall temporariamente para testes

### Erro de certificado SSL

**Problema:** Erro de certificado em desenvolvimento

**Solução:** Configure o Dio para aceitar certificados em desenvolvimento (apenas para testes):

```dart
// Em api_service.dart, adicione ao BaseOptions:
validateStatus: (status) => true,
```

### Erro ao instalar dependências

**Problema:** `flutter pub get` falha

**Solução:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Problemas com imagens

**Problema:** Imagens não aparecem

**Solução:**
1. Verifique se a pasta `assets/images/` existe
2. Confirme que o `pubspec.yaml` inclui os assets
3. Execute `flutter clean` e `flutter run`

## Estrutura de Pastas

```
flutter_crm_app/
├── lib/
│   ├── app/              # Configuração do app
│   ├── core/             # Recursos compartilhados
│   ├── data/             # Modelos, repositórios, serviços
│   ├── presentation/     # Telas e widgets
│   ├── providers/        # Gerenciamento de estado
│   └── main.dart         # Ponto de entrada
├── assets/               # Recursos (imagens, fontes)
├── pubspec.yaml          # Dependências
└── README.md             # Documentação
```

## Próximos Passos

1. Explore as funcionalidades do app
2. Teste CRUD de usuários, clientes, orçamentos e categorias
3. Personalize o tema em `lib/core/theme/`
4. Adicione novas funcionalidades conforme necessário

## Suporte

Para problemas ou dúvidas:
- Verifique a documentação do Flutter: https://flutter.dev/docs
- Consulte a documentação do backend BackCRM-2
- Revise os logs de erro no console

## Licença

Este projeto foi desenvolvido para fins educacionais.
