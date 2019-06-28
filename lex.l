%{

#include "node.h"
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

#define TYPE_NOTFOUND 0
#define TYPE_NUMBER 1
#define TYPE_TEXT 2

extern void yyerror(const char * msg);



int linenum = 1;
int open_parentheses = 0;
int open_braces = 0;

%}

caracter		[a-zA-z]
digito			[0-9]
texto			{caracter}({caracter}|digito)*
numero			{digito}+
linea			\n

%%
"INICIO"		{return MAIN;}
"FIN"			{return END;}

\"(\\.|[^"\\])*\"				{	char * str = (char*)malloc(strlen(yytext) * sizeof(char));
									strcpy(str, yytext);
									yylval.node = newNode(TYPE_TEXT,str); return TEXT_C;}
%%		

//when the end of input file is read. Return 1 to signal end of input
int yywrap(void){
	return 1;
}



