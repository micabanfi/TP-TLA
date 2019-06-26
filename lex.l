%{

#include <stdio.h>
#include "y.tab.h"

%}

caracter		[a-zA-z]
digito			[0-9]
texto			{caracter}({caracter}|digito)*
numero			{digito}+

%%
"es"			{return EQUALS;}
"es igual a"		{return EQUALSCMP;}
"es distinto"		{return DIFFCMP; }
"es mayor a"		{return GT;}
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
"texto"			{return STRING;}
"numero"		{return INT;}
"imprimir"		{return PRINT;}


%%		

