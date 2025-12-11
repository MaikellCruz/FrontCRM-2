# Flutter CRM App

Sistema de gerenciamento de CRM desenvolvido em Flutter/Dart, integrado com backend FastAPI.

## Características

- ✅ Autenticação JWT
- ✅ Gerenciamento de Usuários
- ✅ Gerenciamento de Clientes
- ✅ Gerenciamento de Orçamentos
- ✅ Gerenciamento de Categorias
- ✅ Upload de imagens em Base64
- ✅ Arquitetura limpa e escalável
- ✅ Gerenciamento de estado com Provider
- ✅ Navegação com GoRouter

## Pré-requisitos

- Flutter SDK 3.0.0 ou superior
- Dart 3.0.0 ou superior
- Backend FastAPI rodando (BackCRM-2)

## Instalação

1. Clone o repositório ou extraia os arquivos
2. Instale as dependências:
```bash
flutter pub get
```

3. Configure a URL da API em `lib/core/constants/api_constants.dart`

4. Execute o aplicativo:
```bash
flutter run
```

## Estrutura do Projeto

```
lib/
├── app/                    # Configuração principal do app
├── core/                   # Recursos compartilhados
│   ├── constants/         # Constantes da aplicação
│   ├── theme/             # Tema e estilos
│   ├── utils/             # Utilitários
│   └── widgets/           # Widgets reutilizáveis
├── data/                   # Camada de dados
│   ├── models/            # Modelos de dados
│   ├── repositories/      # Repositórios
│   └── services/          # Serviços (API, Storage)
├── presentation/           # Camada de apresentação
│   ├── auth/              # Telas de autenticação
│   ├── home/              # Tela inicial
│   ├── users/             # Telas de usuários
│   ├── clients/           # Telas de clientes
│   ├── orcamentos/        # Telas de orçamentos
│   └── categories/        # Telas de categorias
└── providers/              # Gerenciamento de estado
```

## Configuração da API

Edite o arquivo `lib/core/constants/api_constants.dart` e configure a URL base da sua API:

```dart
static const String baseUrl = 'http://seu-servidor:8000';
```

## Funcionalidades

### Autenticação
- Login com email e senha
- Armazenamento seguro de token JWT
- Logout

### Usuários
- Listar todos os usuários
- Criar novo usuário
- Editar usuário existente
- Deletar usuário
- Upload de foto de perfil

### Clientes
- Listar todos os clientes
- Criar novo cliente
- Editar cliente existente
- Deletar cliente
- Upload de foto de perfil
- Associar categoria e orçamento

### Orçamentos
- Listar todos os orçamentos
- Criar novo orçamento
- Editar orçamento existente
- Deletar orçamento
- Associar cliente e categoria

### Categorias
- Listar todas as categorias
- Criar nova categoria
- Editar categoria existente
- Deletar categoria

## Build para Produção

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Tecnologias Utilizadas

- **Flutter**: Framework UI
- **Dart**: Linguagem de programação
- **Dio**: Cliente HTTP
- **Provider**: Gerenciamento de estado
- **GoRouter**: Navegação
- **SharedPreferences**: Armazenamento local
- **FlutterSecureStorage**: Armazenamento seguro

## Licença

Este projeto foi desenvolvido para fins educacionais.
