# Automação de API - Desafio Carrefour

Projeto de automação de testes de API desenvolvido como parte do desafio técnico do Banco Carrefour.

A solução utiliza Robot Framework com Python para automatizar os principais fluxos da API, incluindo operações de usuários, autenticação, validações positivas e negativas e validação de tempo de resposta.

---

## Objetivo

Automatizar os principais cenários funcionais da API, buscando garantir:

- Funcionamento dos endpoints de usuários;
- Validação dos códigos HTTP;
- Validação do conteúdo das respostas;
- Validação de regras de negócio;
- Cobertura de cenários positivos e negativos;
- Autenticação;
- Validação de tempo de resposta;
- Execução automatizada através de CI/CD;
- Geração de relatórios de execução.

---

## Tecnologias utilizadas

- Python
- Robot Framework
- RequestsLibrary
- Git
- GitHub
- GitHub Actions

---

## Estrutura do projeto

```text
.
├── .github/
│   └── workflows/
│       └── testes.yml
│
├── resources/
│   ├── api_keywords.robot
│   ├── dados_usuario.robot
│   └── validacoes_usuario.robot
│
├── tests/
│   ├── usuarios/
│   │   ├── get_usuarios.robot
│   │   ├── get_usuario_id.robot
│   │   ├── post_usuarios.robot
│   │   ├── put_usuarios.robot
│   │   └── delete_usuarios.robot
│   │
│   ├── autenticacao/
│   │   └── login.robot
│   │
│   └── performance/
│       └── tempo_resposta.robot
│
├── results/
├── .gitignore
├── requirements.txt
└── README.md
```

## Estratégia de automação

A automação foi estruturada utilizando separação de responsabilidades.

### Testes

Os arquivos dentro de `tests/` contêm os cenários de teste e suas respectivas validações.

### Resources

Os arquivos dentro de `resources/` concentram keywords reutilizáveis, geração de dados e validações.

Essa abordagem evita duplicação de código e facilita a manutenção da suíte.

---

## Funcionalidades automatizadas

### Usuários

Foram automatizados cenários relacionados às seguintes operações:

- GET `/usuarios`
- POST `/usuarios`
- GET `/usuarios/{id}`
- PUT `/usuarios/{id}`
- DELETE `/usuarios/{id}`

Os testes contemplam cenários positivos e negativos.

### Cadastro

Entre as validações implementadas estão:

- Cadastro com dados válidos;
- Campos obrigatórios;
- E-mail duplicado;
- E-mail inválido.

### Consulta

São validados:

- Usuário existente;
- Usuário inexistente;
- ID inválido;
- Estrutura dos dados retornados.

### Atualização

São validados:

- Atualização com sucesso;
- E-mail duplicado;
- Campos obrigatórios;
- E-mail inválido;
- Persistência dos dados após a atualização.

### Exclusão

São validados:

- Exclusão de usuário existente;
- Confirmação da exclusão através de uma nova consulta;
- Exclusão de usuário inexistente;
- Comportamento para ID inválido.

---

## Autenticação

Foram implementados cenários para o endpoint de login, incluindo:

- Login com credenciais válidas;
- Senha incorreta;
- E-mail inexistente;
- Login sem e-mail;
- Login sem senha.

No cenário de sucesso são validados:

- Código HTTP;
- Mensagem de sucesso;
- Presença do token de autorização;
- Formato `Bearer`.

---

## Validação de tempo de resposta

Foi implementado um teste adicional para validar o tempo de resposta da API.

O critério utilizado pela suíte é:

**Tempo máximo: 2000 ms**

Esse valor representa um critério definido para a automação e não um SLA informado pelo desafio.

O teste registra o tempo de resposta no relatório do Robot Framework e reprova o cenário caso o limite seja ultrapassado.

---

## Dados de teste

Os dados dos usuários são gerados dinamicamente durante a execução.

Os e-mails utilizam identificadores aleatórios para reduzir a possibilidade de conflitos com usuários já existentes.

Os usuários criados durante os testes são armazenados para posterior limpeza através do `Test Teardown`.

A limpeza foi implementada de forma que uma falha na exclusão de um usuário não interrompa a tentativa de limpeza dos demais.

---

## Execução local

### 1. Criar o ambiente virtual

Recomenda-se utilizar um ambiente virtual Python para isolar as dependências do projeto.

No Windows:

```powershell
python -m venv .venv
```

### 2. Ativar o ambiente virtual

No PowerShell:

```powershell
.venv\Scripts\Activate.ps1
```

No Prompt de Comando:

```cmd
.venv\Scripts\activate
```
### 3. Instalar as dependências

```cmd
pip install -r requirements.txt
```

### 4. Executar todos os testes
```cmd
robot -d results tests/
```

## Execução da pipeline

A execução dos testes também pode ser realizada através do GitHub Actions.

### Execução automática

A pipeline é executada automaticamente quando ocorre:

- Push na branch `main`;
- Pull Request direcionado para a branch `main`.

### Execução manual

Também é possível executar a pipeline manualmente através do GitHub:

1. Acesse a aba **Actions** do repositório;
2. Selecione o workflow **Testes Automatizados API Carrefour**;
3. Clique em **Run workflow**;
4. Selecione a branch desejada;
5. Clique novamente em **Run workflow**.

### Resultado da execução

Após a execução, o GitHub Actions apresenta:

- Status da pipeline;
- Quantidade total de testes;
- Quantidade de testes aprovados;
- Quantidade de testes reprovados;
- Resultado geral da execução.

Os relatórios completos do Robot Framework ficam disponíveis como artifacts da execução.

### Relatórios

Os seguintes arquivos são disponibilizados como artifacts:

```text
results/
├── log.html
├── report.html
└── output.xml
```

O `log.html` permite consultar detalhadamente a execução dos testes, enquanto o `report.html` apresenta um resumo dos resultados.

## Considerações sobre a API

O desafio disponibiliza a ServeRest como sugestão de API para implementação dos testes.

Os endpoints descritos no desafio como:

- `/users`
- `/users/{id}`

são disponibilizados pela ServeRest como:

- `/usuarios`
- `/usuarios/{id}`

A automação foi desenvolvida considerando os endpoints efetivamente disponibilizados pela API utilizada.

Durante a implementação, os cenários foram construídos com base no comportamento observado nas respostas da API, incluindo códigos HTTP, mensagens retornadas e estrutura dos dados.

O requisito de limite de 100 requisições por minuto foi identificado no enunciado, porém não faz parte da suíte funcional atual. Testes específicos de rate limiting podem ser adicionados posteriormente por exemplo utilizando o K6.
