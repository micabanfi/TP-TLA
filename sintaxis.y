%{
	#include "node.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h> 
	#include <stdarg.h>
	#include <string.h>
	
	#define MAX_SYMBOLS 100
	#define MAX_SYMBOL_LENGTH 100
	#define TYPE_NOTFOUND 0
	#define TYPE_NUMBER 1
	#define TYPE_TEXT 2
	int yydebug=1; 
	extern int yylex();
	extern int linenum;
	char symbolsTable[MAX_SYMBOL_LENGTH][MAX_SYMBOLS];
	int symbols = 0, symbolsType[MAX_SYMBOLS];
	void yyerror(const char * s);
	char* strcatN(int num, ...);
	void insertSymbol(char * symbol, int symbolType);
	int getType(char * symbol);
	void checkType(int t1, int t2);

%}

// %define parse.lac full
// %define parse.error verbose

%union{
	struct Node * node;

}

// Finales
%token print
%token texto

// Finales variables ?
%token<node> NUMBER_T
%token<node> TEXT_T
%token<node> MAIN
%token<node> END
%token<node> TEXT_C

//No finales
%type<node> PROGRAM
%type<node> STATEMENT
%type<node> EXPRESSION
%type<node> CODE
%type<node> TERM


%right EQUALS GT GET LT LET 
%left  EQUALSCMP NTEQUAL
%left PLUS MINUS MUL DIV MOD
%left OR AND NOT 
 

%start PROGRAM

%%
PROGRAM 	: MAIN CODE END {printf("%s",strcatN(4,"#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <ctype.h>\n",
	"int main(void){\n\t",$2->string,"\n}\n"));};
CODE		: STATEMENT {$$ = $1;};
STATEMENT 	: print TERM {
				if($2->type == TYPE_TEXT){
					$$ = newNode(TYPE_TEXT, strcatN(3, "printf(\"%s\",", $2->string , ");\n" ));
				}else if($2->type == TYPE_NUMBER){
					$$ = newNode(TYPE_NUMBER, strcatN(3, "printf(\"%d\",", $2->string , ");\n" ));	
				};
			};
			| {$$ = newNode(TYPE_TEXT, ";");}; //Working

EXPRESSION	: TERM  {$$ = $1;};	

TERM		: TEXT_C {$$ = $1;}; | NUMBER_T {$$ = $1;};
%%

int main(){

  yyparse();
  // printf("No Errors!!\n");
  // return 0;
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