*** Settings ***
Documentation    Testes de tempo de resposta da API.
Resource         ../../resources/api_keywords.robot
Resource         ../../resources/validacoes_usuario.robot

Suite Setup      Criar Sessao API

*** Variables ***
${TEMPO_MAXIMO_MS}    5000

*** Test Cases ***
CT31 - Validar Tempo De Resposta Da Listagem De Usuarios
    [Documentation]    Valida se a listagem de usuários responde dentro do limite definido.
    [Tags]    performance    tempo-resposta

    ${response}=    GET On Session
    ...    api
    ...    /usuarios
    ...    expected_status=200

    Validar Tempo De Resposta
    ...    ${response}
    ...    ${TEMPO_MAXIMO_MS}