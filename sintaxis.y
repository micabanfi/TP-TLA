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
	Node *node;
}


%token<node> NUMBER_T
%token<node> TEXT_T
%token<node> MAIN
%token<node> END
%token PRINT
%token texto
%token<node> TEXT_C
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
program 	: statement {printf("%s",strcatN(4,"#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <ctype.h>\n",
	"int main(void){\n\t",$1->string,"\n}\n"));};
statement 	: MAIN PRINT_F END{ 
						$$ = newNode(TYPE_TEXT, strcatN(5,"printf(\"%s","\\n","\",", $2->string, ");"));
			}
			| MAIN END{
			$$ = newNode(TYPE_TEXT, ";");
			};

PRINT_F 	: PRINT EXPRESSION{
			if($2->type == TYPE_TEXT)
				$$ = newNode(TYPE_TEXT, strcatN(3, "printf(\"%s\"", $2->string , ");\n" ));
			};		

EXPRESSION	: TERM  {$$ = $1;};	

TERM		: TEXT_C {$$ = newNode(TYPE_TEXT, $1->string);};
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