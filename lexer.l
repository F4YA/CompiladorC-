
%{
    #include  <math.h>
    #include "lex.yy.h"
    #include <stdio.h>
    #include <stdlib.h>

    #define IF 1
    #define ELSE 2
    #define INT 3
    #define WHILE 4
    #define VOID 5
    #define RETURN 6

    #define GTE 7
    #define LTE 8
    #define EQ 9
    #define LT 10
    #define GT 11
    #define NEQ 12

    #define ADD 13
    #define SUB 14
    #define MUL 15
    #define DIV 16

    #define IDENTIFIER 17

    #define OPEN_PAR 18
    #define CLOSE_PAR 19
    #define OPEN_KEY 20
    #define CLOSE_KEY 21
    #define OPEN_BRAC 22
    #define CLOSE_BRAC 23

    #define COMMA 24
    #define END_LINE 25

    #define TS 26
    #define NUM 27
    #define ATR 28


    typedef struct error{
        int line;
        char * token;
        char * message;
        struct error *next;
    } ERROR;

    typedef struct listErrors{
        int cont;
        ERROR * errors;
    }ERRORS;

    ERRORS *errors;

    int lastIsEq = 0;
    int line = 0;

    void addError(char * token);
    void printErrors();
%}

%option noyywrap
%x COMMENT

NUMBER [0-9]+
ID [a-z][a-zA-Z]*

%%

"/*"  {BEGIN(COMMENT);}

<COMMENT>{
    "*/"    {BEGIN(INITIAL);}
    \n      {line++;}
    "/*"    {
              addError(yytext);
              return 50;
             }
     .       { }
     <<EOF>> {
               printErrors();
               printf("error at line: %i unfinded: */ \n", line + 1);
               exit(1);
             }
}

if|else|int|return|void|while {
    printf("a keyword: %s\n", yytext);

    if(strcmp(yytext, "if") == 0) return IF;
    if(strcmp(yytext, "else") == 0) return ELSE;
    if(strcmp(yytext, "int") == 0) return INT;
    if(strcmp(yytext, "return") == 0) return RETURN;
    if(strcmp(yytext, "void") == 0) return VOID;
    if(strcmp(yytext, "while") == 0) return WHILE;
}

{ID} {
        printf("An identifier: %s\n", yytext);
        return IDENTIFIER;
}

"<="|">="|"!="|"=="|"<"|">" {

    printf("a relop: %s\n", yytext);

    if(strcmp(yytext, "<=") == 0) return LTE;
    if(strcmp(yytext, ">=") == 0) return GTE;
    if(strcmp(yytext, "!=") == 0) return NEQ;
    if(strcmp(yytext, "==") == 0) return EQ;
    if(strcmp(yytext, "<") == 0) return LT;
    if(strcmp(yytext, ">") == 0) return GT;
}

= { return ATR; }

{NUMBER} {
          return NUM;
}

"+"|"-"|"*"|"/" {
    printf("An operator: %s\n", yytext);

    if(strcmp(yytext, "+") == 0) return ADD;
    if(strcmp(yytext, "-") == 0) return SUB;
    if(strcmp(yytext, "*") == 0) return MUL;
    if(strcmp(yytext, "/") == 0) return DIV;
}

"("|")"|"["|"]"|"{"|"}"|","|";" {
    printf("a delimitator: %s\n", yytext);
    if(strcmp(yytext, "(")) return OPEN_PAR;
    if(strcmp(yytext, ")")) return CLOSE_PAR;
    if(strcmp(yytext, "[")) return OPEN_BRAC;
    if(strcmp(yytext, "]")) return CLOSE_BRAC;
    if(strcmp(yytext, "{")) return OPEN_KEY;
    if(strcmp(yytext, "}")) return CLOSE_KEY;
}

"\n" {
    line++;
    printf("line is: %i\n", line);
    return 50;
}

[ \t]+ {
    // ignora os espaços e tabs
    return 50;
}

. {
    addError(yytext);
    return 50;
}

<<EOF>> {
            printf("fim do arquivo\n");
            printErrors();
            yyterminate();
            return 0;
        }
%%

void addError(char * token){
    ERROR * new = malloc(sizeof(ERROR));
    new->line = line + 1;
    new->token = malloc(sizeof(token));
    strcpy(new->token, token);
    new->next = errors->errors;
    errors->errors = new;
    errors->cont++;
}

void printErrors(){

    if(errors->cont == 0) return;

    ERROR * error = errors->errors;

    while(error){
        printf("error at line: %i unrecognized: %s\n", error->line, error->token);
        error = error->next;
    }

    printf("erros encontrados: %i\n", errors->cont);
}

int initLexer(){

    if(!(yyin = fopen("../prg1.c-", "r"))){
        printf("Erro ao abrir o arquivo");
        return 1;
    }


    errors = malloc(sizeof(ERRORS));
    errors->errors = NULL;

    while (yylex() != 0); //aparentemente o flex para a execução após achar um return nas regras

    fclose(yyin);
    return 0;

}