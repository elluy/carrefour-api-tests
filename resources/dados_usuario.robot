
*** Settings ***
Documentation    Keywords para geração de dados de usuários.
Library          String   #Library responsavel para gerar dados aleaórios como id, email, etc.
Library          Collections

*** Keywords ***
Gerar Dados Usuario
    [Documentation]    Gera dados para cadastrar um usuário de teste.

    ${id}=    Generate Random String    8    [LOWER][NUMBERS]
    ${email}=    Set Variable    qa_${id}@teste.com

    &{usuario}=    Create Dictionary
    ...    nome=Usuario Teste Automatizado
    ...    email=${email}
    ...    password=SenhaTeste123!
    ...    administrador=false

    RETURN    ${usuario}

