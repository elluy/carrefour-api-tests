*** Settings ***
Documentation    Testes do endpoint GET /usuarios/{id}.
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/dados_usuario.robot
Library          Collections

Suite Setup      Criar Sessao API
Test Setup       Preparar Teste De Usuario
Test Teardown    Excluir Usuario Criado

*** Test Cases ***
CT11 - Consultar Usuario Existente
    [Documentation]    Valida a consulta de um usuário pelo ID. Teste cria o usuário e em seguida realiza a consulta do mesmo.
    [Tags]    get    positivo    smoke

    ${usuario}=     Gerar Dados Usuario
    ${cadastro}=    Cadastrar Usuario    ${usuario}

    Should Be Equal As Integers    ${cadastro.status_code}    201

    ${response}=    Consultar Usuario Por ID    ${USUARIO_ID}

    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Evaluate    $response.json()

    Should Be Equal    ${body}[nome]     ${usuario}[nome]
    Should Be Equal    ${body}[email]    ${usuario}[email]
    Should Be Equal    ${body}[_id]      ${USUARIO_ID}
    Log    ID do usuário cadastrado: ${USUARIO_ID}  # Usando o log pra verificar se o ID está sendo armazenado corretamente


CT12 - Consultar Usuario Inexistente
    [Documentation]    Valida a consulta de um usuário com ID inexistente.
    [Tags]    get    negativo

    ${id_inexistente}=    Set Variable    abcdef1234567890

    ${response}=    Consultar Usuario Por ID    ${id_inexistente}

    Log To Console    ${response.text}

    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    message
    Should Be Equal    ${body}[message]    Usuário não encontrado

CT13 - Consultar Usuario Com ID Invalido
    [Documentation]    Valida a consulta com um ID fora do formato exigido.
    [Tags]    get    negativo    contrato

    ${id_invalido}=    Set Variable    id_inexistente_123456

    ${response}=    Consultar Usuario Por ID    ${id_invalido}

    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    id
    Should Be Equal
    ...    ${body}[id]
    ...    id deve ter exatamente 16 caracteres alfanuméricos


CT14 - Validar Estrutura Do Usuario Consultado
    [Documentation]    Valida os campos retornados na consulta por ID.
    [Tags]    get    positivo    contrato

    ${usuario}=     Gerar Dados Usuario
    ${cadastro}=    Cadastrar Usuario    ${usuario}

    Should Be Equal As Integers    ${cadastro.status_code}    201

    ${response}=    Consultar Usuario Por ID    ${USUARIO_ID}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    _id
    Dictionary Should Contain Key    ${body}    nome
    Dictionary Should Contain Key    ${body}    email
    Dictionary Should Contain Key    ${body}    password
    Dictionary Should Contain Key    ${body}    administrador

    Should Be Equal    ${body}[_id]              ${USUARIO_ID}
    Should Be Equal    ${body}[nome]             ${usuario}[nome]
    Should Be Equal    ${body}[email]            ${usuario}[email]
    Should Be Equal    ${body}[password]         ${usuario}[password]
    Should Be Equal    ${body}[administrador]    ${usuario}[administrador]