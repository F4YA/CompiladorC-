#include <stdio.h>
#include "lex.yy.h"

int main(int argc, char ** argv)
{

    char * yytext;

    if (argc > 0)
        return initLexer(argv[1]);

    /*todo: resolver os problemas com os comentários
     *todo: tabela de simbolos
     *todo: erros de sintaxe
     * */

}

/*oeeeeeeeeee*/