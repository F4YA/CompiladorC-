//Osvaldo Carvalho dos Santos Neto

#include <stdio.h>
#include "lex.yy.h"
#include "parser.tab.h"

int main(int argc, char ** argv)
{

    //char * yytext;

    if (argc > 0)
        return yyparse();

}

/*oeeeeeeeeee*/