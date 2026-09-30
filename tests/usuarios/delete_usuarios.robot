*** Settings ***
Documentation    Testes do endpoint DELETE /usuarios/{id}.
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/dados_usuario.robot
Library          Collections

Suite Setup      Criar Sessao API
Test Setup       Preparar Teste De Usuario
Test Teardown    Excluir Usuario Criado


*** Test Cases ***
CT23 - Excluir Usuario Com Sucesso
    [Documentation]    Valida a exclusão de um usuário existente.
    [Tags]    delete    positivo    smoke

    ${usuario}=    Gerar Dados Usuario
    ${cadastro}=    Cadastrar Usuario    ${usuario}

    Should Be Equal As Integers    ${cadastro.status_code}    201

    ${id}=    Set Variable    ${USUARIO_ID}

    ${response}=    Deletar Usuario    ${id}

    Should Be Equal As Integers    ${response.status_code}    200

    ${consulta}=    Consultar Usuario Por ID    ${id}

    Should Be Equal As Integers    ${consulta.status_code}    400

    ${body}=    Evaluate    $consulta.json()
    Should Be Equal    ${body}[message]    Usuário não encontrado

    Remove From List    ${USUARIOS_CRIADOS}    0  # remove da lista para que não tente apagar novamente em nosso teardown


CT24 - Excluir Usuario Inexistente
    [Documentation]    Valida a exclusão de um usuário que não existe.
    [Tags]    delete    negativo

    ${id_inexistente}=    Set Variable    abcdef1234567890

    ${response}=    Deletar Usuario    ${id_inexistente}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    message
    Should Be Equal    ${body}[message]    Nenhum registro excluído


CT25 - Excluir Usuario Com ID Invalido
    [Documentation]    Valida a resposta do DELETE para um ID inválido.
    [Tags]    delete    negativo    contrato

    ${id_invalido}=    Set Variable    id_invalido_123

    ${response}=    Deletar Usuario    ${id_invalido}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    message
    Should Be Equal    ${body}[message]    Nenhum registro excluído
