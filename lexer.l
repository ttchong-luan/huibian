%{
#include "parser.tab.h"
#include <stdlib.h>
#include <math.h>
void yyerror(const char *);
%}

%option noyywrap

DIGIT           [0-9]
NONZERO_DIGIT   [1-9]
OCTAL_DIGIT     [0-7]
HEX_DIGIT       [0-9a-fA-F]

%%

"+"             { return ADD; }
"-"             { return SUB; }
"*"             { return MUL; }
"/"             { return DIV; }
"("             { return LP; }
")"             { return RP; }
"\n"            { return EOL; }

{NONZERO_DIGIT}{DIGIT}*  {
    yylval.dval = strtod(yytext, NULL);
    return INTEGER_CONSTANT;
}

0{OCTAL_DIGIT}* {
    yylval.dval = strtol(yytext, NULL, 8);
    return INTEGER_CONSTANT;
}

0[xX]{HEX_DIGIT}+ {
    yylval.dval = strtol(yytext, NULL, 16);
    return INTEGER_CONSTANT;
}

({DIGIT}+\.{DIGIT}*|\.{DIGIT}+)([eE][+-]?{DIGIT}+)?|{DIGIT}+[eE][+-]?{DIGIT}+ {
    yylval.dval = strtod(yytext, NULL);
    return FLOATING_CONSTANT;
}

0[xX]({HEX_DIGIT}*\.?{HEX_DIGIT}+|{HEX_DIGIT}+\.?)[pP][+-]?{DIGIT}+ {
    yylval.dval = strtod(yytext, NULL);
    return FLOATING_CONSTANT;
}

[ \t]           ; /* 忽略空白 */
.               { yyerror("Invalid character"); }

%%
