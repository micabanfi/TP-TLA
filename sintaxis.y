%{
#include <stdio.h>
#include <string.h>
#include "node.h"
#include "sintaxis.tab.h"

extern void yyerror();
extern int yylex();
extern char* yytext;
extern int yylineno;
static Node * root;
char* strcatN(int num, ...);
#define TYPE_NUMBER 1
#define TYPE_TEXT 2

%}

// %define parse.lac full
// %define parse.error verbose

%union{
	Node *node;
}


%token<node> NUMBER_T
%token<node> TEXT_T
%token MAIN
%token END
%token PRINT
%token texto
%token TEXT_C
%type<node> program
%type<node> statement
%type<node> PRINT_F
%type<node> EXPRESSION
%type<node> TERM


%right EQUALS GT GET LT LET 
%left  EQUALSCMP NTEQUAL
%left PLUS MINUS MUL DIV MOD
%left OR AND NOT 
 

%start program

%%
program 	: statement{
			printf("%s", strcat("#include <stdio.h>\n int main(void)",$1->string);
			};
statement 	: MAIN PRINT_F END{ 
			$$ = newNode(TYPE_TEXT, strcatN(3, "{\n",$2->string,"}"));
			}
			| MAIN END{
			$$ = newNode(TYPE_TEXT, ";");
			};

PRINT_F 	: PRINT EXPRESSION{
			$$ = newNode(TYPE_TEXT, strcatN(3, "printf(\"%s\"", $2->string , ");\n" );
			};		

EXPRESSION	: TERM  {$$ = $1;};	

TERM		: TEXT_C {$$ = newNode(TYPE_TEXT, $1->string);};
%%

int main(){

  yyparse();
  printf("No Errors!!\n");
  return 0;
}		

char* strcatN(int num, ...)
{
	int i, length;
	char* toAdd;
	char* ret;

	va_list strings;
	va_start(strings, num);
	toAdd = va_arg(strings, char*);

	length = 0;
	length = strlen(toAdd)+ 1;

	ret = (char*)malloc(sizeof(char) * length);
	strcpy(ret, toAdd);
	for(i = 1; i < num ; i++)
	{
		toAdd = va_arg(strings, char*);
		length += strlen(toAdd);
		ret = (char*)realloc((void*)ret, length * sizeof(char));
		strcat(ret, toAdd);
	}
	va_end(strings);
	return ret;
}