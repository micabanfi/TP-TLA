%{

#include "node.h"
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

#define TYPE_NOTFOUND 0
#define TYPE_NUMBER 1
#define TYPE_TEXT 2
#define TYPE_BOOL 3

extern void yyerror(const char * msg);

int lines = 1;
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
"fin si"		{return ENDIF;}
"y"				{return AND;}
"y si no"		{return ELSE;}
"o"				{return OR;}
"numero"		{return NUMBER_T;}
"texto"			{return TEXT_T;}
"+"				{return PLUS;}
"-"				{return MINUS;}
"*"				{return MULT;}
"/"				{return DIV;}
"("				{return OP;}
")"				{return CP;}
"es igual a"	{return EQUALS;}
"es mayor o igual a"			{return GET;}
"es menor o igual a"			{return LET;}
"es menor a"				{return LT;}
"es mayor a"				{return GT;}
"es distinto a"			{return DIF;}
"\n" 			{lines++;
				return END_LINE;}




{numero}						{	char * str = (char*)malloc(strlen(yytext) * sizeof(char));
									strcpy(str, yytext);
									yylval.node = newNode(TYPE_NUMBER,str); 
									return NUM_C;}
{espacio}						{;}


\"(\\.|[^"\\])*\"				{	char * str = (char*)malloc(strlen(yytext) * sizeof(char));
									strcpy(str, yytext);
									yylval.node = newNode(TYPE_TEXT,str);
									return TEXT_C;}

{texto}		{	char * str = (char*)malloc(strlen(yytext) * sizeof(char));
									strcpy(str, yytext);
									yylval.node = newNode(TYPE_TEXT,str); 
									return ID;}									
%%		

//when the end of input file is read. Return 1 to signal end of input
int yywrap(void){
	return 1;
}

