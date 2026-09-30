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
        Append To List    ${USUARIOS_CRIADOS}    ${id}
    END

    RETURN    ${response}


Excluir Usuario Criado
    [Documentation]    Tenta excluir todos os usuários criados sem reprovar o teste. Se falhar não impede que o teste passe.

    FOR    ${id}    IN    @{USUARIOS_CRIADOS}
        ${sucesso}=    Run Keyword And Return Status
        ...    Excluir Usuario Por ID
        ...    ${id}

        IF    not ${sucesso}
            Log    Falha ao excluir o usuário ${id}    WARN
        END
    END

Preparar Teste De Usuario
    [Documentation]    Inicializa a lista de usuários criados no teste.
    ${ids}=    Create List
    Set Test Variable    ${USUARIOS_CRIADOS}    ${ids}
    Set Test Variable    ${USUARIO_ID}    ${EMPTY}


Consultar Usuario Por ID
    [Documentation]    Consulta um usuário pelo seu identificador.
    [Arguments]    ${id}
    ${response}=    GET On Session
    ...    api
    ...    /usuarios/${id}
    ...    expected_status=any
    RETURN    ${response}


Atualizar Usuario
    [Documentation]    Atualiza os dados de um usuário pelo ID.
    [Arguments]    ${id}    ${usuario}

    ${response}=    PUT On Session
    ...    api
    ...    /usuarios/${id}
    ...    json=${usuario}
    ...    expected_status=any

    RETURN    ${response}


Excluir Usuario Por ID
    [Documentation]    Exclui um usuário e valida o retorno da API.
    [Arguments]    ${id}

    ${response}=    DELETE On Session
    ...    api
    ...    /usuarios/${id}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    200


Deletar Usuario
    [Documentation]    Executa a exclusão de um usuário pelo ID.
    [Arguments]    ${id}

    ${response}=    DELETE On Session
    ...    api
    ...    /usuarios/${id}
    ...    expected_status=any

    RETURN    ${response}