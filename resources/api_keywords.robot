*** Settings ***
Library     RequestsLibrary
Resource    ../config/variables.robot

*** Keywords ***
Criar Sessao API
    [Documentation]    Cria uma sessão HTTP para comunicação com a API.
    Create Session    api    ${BASE_URL}    timeout=${TIMEOUT}

Consultar Todos Os Usuarios
    [Documentation]    Consulta a listagem completa de usuários.
    ${response}=    GET On Session    api    /usuarios    expected_status=any
    RETURN    ${response}