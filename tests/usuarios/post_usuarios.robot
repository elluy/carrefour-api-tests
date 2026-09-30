
*** Settings ***
Documentation    Testes do endpoint POST /usuarios.

Resource         ../../resources/api_keywords.robot
Resource         ../../resources/dados_usuario.robot
Resource         ../../resources/validacoes_usuario.robot
Library          Collections

Suite Setup      Criar Sessao API
Test Setup       Preparar Teste De Usuario
Test Teardown    Excluir Usuario Criado


*** Test Cases ***
CT04 - Cadastrar Usuario Com Sucesso
    [Documentation]    Valida o cadastro de um usuário com dados válidos.
    [Tags]    post    smoke    positivo

    ${usuario}=    Gerar Dados Usuario
    ${response}=    Cadastrar Usuario    ${usuario}

    Should Be Equal As Integers    ${response.status_code}    201  # valida o status HTTP da resposta

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    _id
    Should Not Be Empty    ${body}[_id]

    
CT05 - Nao Permitir Cadastro Sem Nome
    [Documentation]    Valida que o nome é obrigatório.
    [Tags]    post    negativo    obrigatorio
    [Template]  Validar Campo Obrigatorio

    nome    nome é obrigatório


CT06 - Nao Permitir Cadastro Sem Email
    [Documentation]    Valida que o e-mail é obrigatório.
    [Tags]    post    negativo    obrigatorio
    [Template]    Validar Campo Obrigatorio

    email    email é obrigatório


CT07 - Nao Permitir Cadastro Sem Senha
    [Documentation]    Valida que a senha é obrigatória.
    [Tags]    post    negativo    obrigatorio
    [Template]    Validar Campo Obrigatorio

    password    password é obrigatório


CT08 - Nao Permitir Cadastro Sem Administrador
    [Documentation]    Valida que o administrador é obrigatório.
    [Tags]    post    negativo    obrigatorio
    [Template]    Validar Campo Obrigatorio

    administrador    administrador é obrigatório


CT09 - Nao Permitir Email Duplicado
    [Documentation]    Valida que não é possível cadastrar dois usuários com o mesmo e-mail.
    [Tags]    post    negativo    duplicidade

    ${usuario}=    Gerar Dados Usuario

    ${primeira_resposta}=    Cadastrar Usuario    ${usuario}
    Should Be Equal As Integers    ${primeira_resposta.status_code}    201

    ${segunda_resposta}=    Cadastrar Usuario    ${usuario}
    Should Be Equal As Integers    ${segunda_resposta.status_code}    400

    ${body}=    Evaluate    $segunda_resposta.json()
    Dictionary Should Contain Key    ${body}    message
    Should Be Equal    ${body}[message]    Este email já está sendo usado


CT10 - Nao Permitir Cadastro Com Email Invalido
    [Documentation]    Valida a rejeição de um e-mail inválido.
    [Tags]    post    negativo    validacao

    ${usuario}=    Gerar Dados Usuario
    Set To Dictionary    ${usuario}    email=emailinvalido  # email fora do padrão correto sem @ por exemplo

    ${response}=    Cadastrar Usuario    ${usuario}

    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    email
    Should Be Equal    ${body}[email]    email deve ser um email válido
