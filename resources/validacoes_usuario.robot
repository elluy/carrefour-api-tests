*** Settings ***
Library     Collections
Resource    api_keywords.robot
Resource    dados_usuario.robot

*** Keywords ***
Validar Campo Obrigatorio
    [Documentation]    Valida que a API rejeita o cadastro sem um campo obrigatório.
    [Arguments]    ${campo}    ${mensagem_esperada}

    ${usuario}=    Gerar Dados Usuario
    Remove From Dictionary    ${usuario}    ${campo}

    ${response}=    Cadastrar Usuario    ${usuario}

    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Evaluate    $response.json()

    Dictionary Should Contain Key    ${body}    ${campo}
    Should Be Equal    ${body}[${campo}]    ${mensagem_esperada}


Validar Campo Obrigatorio Na Atualizacao
    [Documentation]    Valida que a API rejeita a atualização sem um campo obrigatório.
    [Arguments]    ${campo}    ${mensagem_esperada}

    ${usuario}=    Gerar Dados Usuario
    ${cadastro}=    Cadastrar Usuario    ${usuario}
    Should Be Equal As Integers    ${cadastro.status_code}    201

    Remove From Dictionary    ${usuario}    ${campo}

    ${response}=    Atualizar Usuario    ${USUARIO_ID}    ${usuario}
    Should Be Equal As Integers    ${response.status_code}    400

    ${body}=    Evaluate    $response.json()
    Dictionary Should Contain Key    ${body}    ${campo}
    Should Be Equal    ${body}[${campo}]    ${mensagem_esperada}
