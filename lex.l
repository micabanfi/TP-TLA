%{

#include <stdio.h>
#include <string.h>
#include "y.tab.h"
void extern yyerror(char*);
void invalidToken();

%}

caracter		[a-zA-z]
digito			[0-9]
texto			{caracter}({caracter}|digito)*
numero			{digito}+
linea			\n

%%
"es"			{return EQUALS;}
"no es"			{return NOT};
"es igual a"		{return EQUALSCMP;}
"es distinto"		{return NTEQUAL; }
"es mayor a"	 	{return GT;}
"es menor a"		{return LT;}
"es mayor o igual a"	{return GET;}
"es menor o igual a"	{return LET;}
"y"			{return AND;}
"o"			{return OR;}
"+"			{return PLUS;}
"-"			{return MINUS;}
"*"			{return MULT;}
"/"			{return DIV;}
"%"			{return MOD;}
"si"			{return IF;}
"sino"			{return ELSE;}
"mientras"		{return WHILE;}
"hacer"			{return DO;}
"falso"			{return FALSE;}
"verdadero"		{return TRUE;}
"texto"			{return STRING_T;}
"numero"		{return INT_T;}
"imprimir"		{return PRINT;}
"."			{return END_LINE;}	
"("			{return L_PAR;}
")"			{return R_PAR;}

{numero} 		{yylval.integer = strtol(yytext, NULL, 10);
					return INT;}

{texto}			{char * texto = malloc(strlen(yytext)+1);
				strcpy(texto, yytext);
				yylval.string = texto;
				return ID;
			}

{linea}			{yylineno++;}

%%		

//when the end of input file is read. Return 1 to signal end of input
int yywrap(void){
	return 1;
}

//invalid token or secual is encounter
void yyerror(char *s){
	fprintf(stderr, "\nERROR ON line %d : \n %s\n",yylineno,s);
	exit(0);
}

//in case the token doesnt envoke yyerror
void invalidToken(){
	printf("\nERROR ON line %d : \n Invalid Token %s\n",yylineno,yytext);
	exit(0);
}


