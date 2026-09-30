*** Settings ***
Documentation    Testes do endpoint PUT /usuarios/{id}.
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/dados_usuario.robot
Resource         ../../resources/validacoes_usuario.robot
Library          Collections

Suite Setup      Criar Sessao API
Test Setup       Preparar Teste De Usuario
Test Teardown    Excluir Usuario Criado


*** Test Cases ***
CT15 - Atualizar Usuario Com Sucesso
    [Documentation]    Valida a atualização dos dados de um usuário.
    [Tags]    put    positivo    smoke

    ${usuario}=    Gerar Dados Usuario
    ${cadastro}=    Cadastrar Usuario    ${usuario}

    Should Be Equal As Integers    ${cadastro.status_code}    201

    ${usuario_atualizado}=    Gerar Dados Usuario
    Set To Dictionary
    ...    ${usuario_atualizado}
    ...    nome=Usuario Atualizado

    ${response}=    Atualizar Usuario
    ...    ${USUARIO_ID}
    ...    ${usuario_atualizado}

    Should Be Equal As Integers    ${response.status_code}    200

    ${consulta}=    Consultar Usuario Por ID    ${USUARIO_ID}

    Should Be Equal As Integers    ${consulta.status_code}    200

    ${body}=    Evaluate    $consulta.json()

    Should Be Equal    ${body}[nome]            ${usuario_atualizado}[nome]
    Should Be Equal    ${body}[email]           ${usuario_atualizado}[email]
    Should Be Equal    ${body}[_id]             ${USUARIO_ID}
    Should Be Equal    ${body}[password]        ${usuario_atualizado}[password]
    Should Be Equal    ${body}[administrador]   ${usuario_atualizado}[administrador]


CT16 - Nao Permitir Atualizacao Com Email Duplicado
    [Documentation]    Valida que dois usuários não podem ter o mesmo e-mail.
    [Tags]    put    negativo

    ${usuario1}=    Gerar Dados Usuario
    ${cadastro1}=    Cadastrar Usuario    ${usuario1}
    Should Be Equal As Integers    ${cadastro1.status_code}    201
    ${id1}=    Set Variable    ${USUARIO_ID}

    ${usuario2}=    Gerar Dados Usuario
    ${cadastro2}=    Cadastrar Usuario    ${usuario2}
    Should Be Equal As Integers    ${cadastro2.status_code}    201
    ${id2}=    Set Variable    ${USUARIO_ID}

    Set To Dictionary
    ...    ${usuario2}
    ...    email=${usuario1}[email]

    ${response}=    Atualizar Usuario    ${id2}    ${usuario2}

    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Evaluate    $response.json()
    Dictionary Should Contain Key    ${body}    message
    Should Be Equal    ${body}[message]    Este email já está sendo usado


CT17 - Nao Permitir Atualizacao Com Email Duplicado
    [Documentation]    Valida que não é possível atualizar um usuário com o e-mail de outro.
    [Tags]    put    negativo

    ${usuario1}=    Gerar Dados Usuario
    ${cadastro1}=    Cadastrar Usuario    ${usuario1}
    Should Be Equal As Integers    ${cadastro1.status_code}    201

    ${usuario2}=    Gerar Dados Usuario
    ${cadastro2}=    Cadastrar Usuario    ${usuario2}
    Should Be Equal As Integers    ${cadastro2.status_code}    201
    ${id2}=    Set Variable    ${USUARIO_ID}

    Set To Dictionary    ${usuario2}    email=${usuario1}[email]  # forçando o mesmo email do primeiro cadastro

    ${response}=    Atualizar Usuario    ${id2}    ${usuario2}

    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Evaluate    $response.json()
    Dictionary Should Contain Key    ${body}    message
    Should Be Equal    ${body}[message]    Este email já está sendo usado


CT18 - Nao Permitir Atualizacao Sem Nome
    [Documentation]    Valida que o nome é obrigatório na atualização.
    [Tags]    put    negativo    obrigatorio
    Validar Campo Obrigatorio Na Atualizacao    nome    nome é obrigatório


CT19 - Nao Permitir Atualizacao Sem Email
    [Documentation]    Valida que o email é obrigatório na atualização.
    [Tags]    put    negativo    obrigatorio
    Validar Campo Obrigatorio Na Atualizacao    email   email é obrigatório


CT20 - Nao Permitir Atualizacao Sem Password
    [Documentation]    Valida que a senha é obrigatória na atualização.
    [Tags]    put    negativo    obrigatorio
    Validar Campo Obrigatorio Na Atualizacao    password    password é obrigatório


CT21 - Nao Permitir Atualizacao Sem Administrador
    [Documentation]    Valida que o campo administrador é obrigatório.
    [Tags]    put    negativo    obrigatorio
    Validar Campo Obrigatorio Na Atualizacao    administrador   administrador é obrigatório


CT22 - Nao Permitir Atualizacao Com Email Invalido
    [Documentation]    Valida que a API rejeita um e-mail inválido na atualização.
    [Tags]    put    negativo    validacao

    ${usuario}=    Gerar Dados Usuario
    ${cadastro}=    Cadastrar Usuario    ${usuario}

    Should Be Equal As Integers    ${cadastro.status_code}    201

    Set To Dictionary    ${usuario}    email=emailinvalido

    ${response}=    Atualizar Usuario    ${USUARIO_ID}    ${usuario}

    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    email
    Should Be Equal    ${body}[email]    email deve ser um email válido