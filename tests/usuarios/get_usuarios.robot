
*** Settings ***
Documentation    Testes do endpoint GET /usuarios.
Resource         ../../resources/api_keywords.robot
Library          Collections

Suite Setup      Criar Sessao API

*** Test Cases ***
CT01 - Listar Usuarios Com Sucesso
    [Documentation]    Valida o status HTTP da listagem.
    [Tags]    get    smoke    positivo

    ${response}=    Consultar Todos Os Usuarios

    Should Be Equal As Integers    ${response.status_code}    200


CT02 - Validar Estrutura Da Listagem
    [Documentation]    Valida a estrutura do JSON retornado.
    [Tags]    get    contrato    positivo

    ${response}=    Consultar Todos Os Usuarios
    ${body}=    Evaluate    $response.json()

    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${body}    quantidade
    Dictionary Should Contain Key    ${body}    usuarios

    ${usuarios}=    Get From Dictionary    ${body}    usuarios

    Should Be True    isinstance($usuarios, list)
    Should Be Equal As Integers    ${body}[quantidade]    ${usuarios.__len__()}


CT03 - Validar Campos Dos Usuarios
    [Documentation]    Valida os campos de cada usuário retornado.
    [Tags]    get    contrato    positivo

    ${response}=    Consultar Todos Os Usuarios
    ${body}=    Evaluate    $response.json()

    Should Be Equal As Integers    ${response.status_code}    200

    FOR    ${usuario}    IN    @{body}[usuarios]  ## percorre cada usuário na lista de usuários
        Dictionary Should Contain Key    ${usuario}    _id
        Dictionary Should Contain Key    ${usuario}    nome
        Dictionary Should Contain Key    ${usuario}    email
        Dictionary Should Contain Key    ${usuario}    password
        Dictionary Should Contain Key    ${usuario}    administrador
    END
