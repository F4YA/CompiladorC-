%{
#include <stdio.h>

extern int yylex();
void yyerror(char* err, ...);
%}

%union{
    int intval;
    char* strval;
    int type;
}

%token IF ELSE
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE // associa o else ao if mais próximo para remover ambiguidade
%token INT WHILE VOID RETURN
%token GTE LTE EQ LT GT NEQ
%token ADD SUB MUL DIV
%token ID
%token OPEN_PAR CLOSE_PAR OPEN_KEY CLOSE_KEY OPEN_BRAC CLOSE_BRAC
%token COMMA END_LINE
%token TS NUM ATR

%%
    programa :
        declaracao_lista
    ;
    declaracao_lista:
        declaracao_lista declaracao
        | declaracao
    ;
    declaracao:
        var_declaracao
        | fun_declaracao
    ;
    var_declaracao:
        tipo_especificador ID END_LINE
        | tipo_especificador ID OPEN_BRAC NUM CLOSE_BRAC
    ;
    fun_declaracao:
        tipo_especificador ID OPEN_PAR params CLOSE_PAR composto_decl
    ;
    tipo_especificador:
        INT
        | VOID
    ;
    params:
        param_lista
        | VOID
    ;
    param_lista:
        param_lista COMMA param
        | param
    ;
    param:
        INT ID
        | INT ID OPEN_BRAC CLOSE_BRAC
    ;
    composto_decl:
        OPEN_KEY local_declaracoes statement_lista CLOSE_KEY
    ;
    local_declaracoes:
        local_declaracoes var_declaracao
        | {}
    ;
    statement_lista:
        statement_lista statement
        | {}
    ;
    statement:
        expressao_decl
        | composto_decl
        | selecao_decl
        | iteracao_decl
        | retorno_decl
    ;
    expressao_decl:
        expressao END_LINE
        | END_LINE
    ;
    selecao_decl:
        IF OPEN_PAR expressao CLOSE_PAR statement %prec LOWER_THAN_ELSE
        | IF OPEN_PAR expressao CLOSE_PAR statement ELSE statement
    ;
    iteracao_decl:
        WHILE OPEN_PAR expressao CLOSE_PAR statement
    ;
    retorno_decl:
        RETURN END_LINE
        | RETURN expressao END_LINE
    ;
    expressao:
        var ATR expressao
        | simples_expressao
    ;
    var:
        ID
        | ID OPEN_BRAC expressao CLOSE_BRAC
    ;
    simples_expressao:
        soma_expressao relacional soma_expressao
        | soma_expressao
    ;
    relacional:
        GTE
        | GT
        | LT
        | LTE
        | EQ
        | NEQ
    ;
    soma_expressao:
        soma_expressao soma termo
        | termo
    ;
    soma:
        ADD
        | SUB
    ;
    termo:
        termo mult fator
        | fator
    ;
    mult:
        MUL
        | DIV
    ;
    fator:
        OPEN_PAR expressao CLOSE_PAR
        | var
        | ativacao
        | NUM
    ;
    ativacao:
        ID OPEN_PAR args CLOSE_PAR
    ;
    args:
        arg_lista
        | {}
    ;
    arg_lista:
        arg_lista COMMA expressao | expressao
    ;

%%

void yyerror (char* err, ...){
    fprintf(stderr, "%s\n", err);
}
