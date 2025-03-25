%{
#include <stdio.h>
#include <math.h>
void yyerror(const char *);
int yylex();
extern int yylineno;
%}

%define parse.error verbose

%union {
    double dval;
}

%token ADD SUB MUL DIV LP RP EOL
%token <dval> INTEGER_CONSTANT FLOATING_CONSTANT

%type <dval> Exp

%left ADD SUB
%left MUL DIV
%left NEG
%left LP RP

%%

Calclist:
    Calclist Exp EOL   { printf("=%.3f\n", $2); }
    | /* ε */
    ;

Exp:
    Exp ADD Exp       { $$ = $1 + $3; }
    | Exp SUB Exp     { $$ = $1 - $3; }
    | Exp MUL Exp     { $$ = $1 * $3; }
    | Exp DIV Exp     { $$ = $1 / $3; }
    | LP Exp RP       { $$ = $2; }
    | SUB Exp %prec NEG { $$ = -$2; }
    | INTEGER_CONSTANT { $$ = $1; }
    | FLOATING_CONSTANT { $$ = $1; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntactical Error.\n");
    exit(1);
}

int main() {
    yyparse();
    return 0;
}
