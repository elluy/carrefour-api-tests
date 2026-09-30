*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../config/variables.robot

*** Keywords ***
Criar Sessao API
    [Documentation]    Cria uma sessão HTTP para comunicação com a API.
    Create Session    api    ${BASE_URL}    timeout=${TIMEOUT}

Consultar Todos Os Usuarios
    [Documentation]    Consulta a listagem completa de usuários.
    ${response}=    GET On Session    api    /usuarios    expected_status=any
    RETURN    ${response}


Cadastrar Usuario
    [Documentation]    Cadastra um usuário e registra seu ID para limpeza posteriormente.
    [Arguments]    ${usuario}

    ${response}=    POST On Session
    ...    api
    ...    /usuarios
    ...    json=${usuario}
    ...    expected_status=any

    IF    ${response.status_code} == 201
        ${body}=    Evaluate    $response.json()
        ${id}=    Get From Dictionary    ${body}    _id
        Set Test Variable    ${USUARIO_ID}    ${id} 
    END

    RETURN    ${response}


Excluir Usuario Criado
    [Documentation]    Remove o usuário criado durante o teste.

    IF    $USUARIO_ID
        ${response}=    DELETE On Session
        ...    api
        ...    /usuarios/${USUARIO_ID}
        ...    expected_status=any

        Should Be Equal As Integers    ${response.status_code}    200
    END


Preparar Teste De Usuario
    [Documentation]    Inicializa o ID utilizado na limpeza.
    Set Test Variable    ${USUARIO_ID}    ${EMPTY}
