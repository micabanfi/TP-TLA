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

%x comment

caracter		[a-zA-z]
digito			[0-9]
texto			{caracter}({caracter}|digito)*
numero			{digito}+
linea			\n
espacio      	[ \t\r\v\f]

%%
"inicio"		{return MAIN;}
"fin"			{return END;}
"imprimir"		{return print;}
"es"			{return EQUALS;}
"si"			{return IF;}
"numero"		{return NUMBER_T;}
"+"				{return PLUS;}
"-"				{return MINUS;}
"*"				{return MULT;}
"/"				{return DIV;}




{numero}						{	char * str = (char*)malloc(strlen(yytext) * sizeof(char));
									strcpy(str, yytext);
									yylval.node = newNode(TYPE_NUMBER,str); return NUM_C;}
{espacio}						{;}


\"(\\.|[^"\\])*\"				{	char * str = (char*)malloc(strlen(yytext) * sizeof(char));
									strcpy(str, yytext);
									yylval.node = newNode(TYPE_TEXT,str); return TEXT_C;}

{texto}		{	char * str = (char*)malloc(strlen(yytext) * sizeof(char));
									strcpy(str, yytext);
									yylval.node = newNode(TYPE_TEXT,str); return ID;}									
%%		

//when the end of input file is read. Return 1 to signal end of input
int yywrap(void){
	return 1;
}

