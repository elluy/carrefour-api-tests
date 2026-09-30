
*** Settings ***
Documentation    Testes de autenticação da API.
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/dados_usuario.robot
Library          Collections
Library          String

Suite Setup      Criar Sessao API
Test Setup       Preparar Teste De Usuario
Test Teardown    Excluir Usuario Criado


*** Test Cases ***
CT26 - Realizar Login Com Sucesso
    [Documentation]    Valida o login com credenciais válidas.
    [Tags]    login    positivo    smoke

    ${usuario}=    Gerar Dados Usuario
    ${cadastro}=    Cadastrar Usuario    ${usuario}

    Should Be Equal As Integers    ${cadastro.status_code}    201

    ${response}=    Realizar Login
    ...    ${usuario}[email]
    ...    ${usuario}[password]

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    authorization
    Should Not Be Empty    ${body}[authorization]
    Should Start With    ${body}[authorization]    Bearer${SPACE}
    Dictionary Should Contain Key    ${body}    message
    Should Be Equal    ${body}[message]    Login realizado com sucesso


CT27 - Nao Permitir Login Com Senha Incorreta
    [Documentation]    Valida que a API rejeita uma senha incorreta.
    [Tags]    login    negativo

    ${usuario}=    Gerar Dados Usuario
    ${cadastro}=    Cadastrar Usuario    ${usuario}

    Should Be Equal As Integers    ${cadastro.status_code}    201

    ${response}=    Realizar Login
    ...    ${usuario}[email]
    ...    SenhaIncorreta123!

    Should Be Equal As Integers    ${response.status_code}    401

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    message
    Should Be Equal    ${body}[message]    Email e/ou senha inválidos


CT28 - Nao Permitir Login Com Email Inexistente
    [Documentation]    Valida que a API rejeita o login de um usuário inexistente. Não é chamado o cadastrar o usuário (portanto usuário inexistente)
    [Tags]    login    negativo

    ${usuario}=    Gerar Dados Usuario

    ${response}=    Realizar Login
    ...    ${usuario}[email]
    ...    ${usuario}[password]

    Should Be Equal As Integers    ${response.status_code}    401

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    message
    Should Be Equal    ${body}[message]    Email e/ou senha inválidos
    Log    Email utilizado: ${usuario}[email]



CT29 - Nao Permitir Login Sem Email
    [Documentation]    Valida que o email é obrigatório no login.
    [Tags]    login    negativo    obrigatorio

    &{credenciais}=    Create Dictionary
    ...    password=SenhaTeste123!

    ${response}=    POST On Session
    ...    api
    ...    /login
    ...    json=${credenciais}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    email
    Should Be Equal    ${body}[email]    email é obrigatório



CT30 - Nao Permitir Login Sem Senha
    [Documentation]    Valida que a senha é obrigatória no login.
    [Tags]    login    negativo    obrigatorio

    &{credenciais}=    Create Dictionary
    ...    email=qa_teste@teste.com

    ${response}=    POST On Session
    ...    api
    ...    /login
    ...    json=${credenciais}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    password
    Should Be Equal    ${body}[password]    password é obrigatório

