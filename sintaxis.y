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
%token EQUALS
%token PLUS
%token MINUS
%token MULT
%token DIV

// Finales variables ?
%token<node> NUMBER_T
%token<node> TEXT_T
%token<node> MAIN
%token<node> END
%token<node> TEXT_C
%token<node> NUM_C
%token<node> ID
%token<node> IF
%token<node> END_LINE



//No finales
%type<node> PROGRAM
%type<node> STATEMENT
%type<node> EXPRESSION
%type<node> CODE
%type<node> TERM
%type<node> ASSIGNMENT
%type<node> DEFINITION
%type<node> DECLARATION



%right EQUALS 
%left GT GET LT LET 
%left  EQUALSCMP NTEQUAL
%left PLUS MINUS MUL DIV MOD
%left OR AND NOT 
 

%start PROGRAM

%%
PROGRAM 	: MAIN CODE END {printf("%s",strcatN(4,"#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <ctype.h>\n",
							"int main(void){\n\t",$2->string,"\n}\n"));}
			| MAIN END { printf("%s","int main(void);"); };

CODE		: STATEMENT END_LINE{$$ = newNode(TYPE_TEXT, strcatN(2, $1->string, "\n"));}
			| STATEMENT END_LINE CODE {$$ = newNode(TYPE_TEXT, strcatN(3, $1->string, "\t", $3->string));};
			
STATEMENT 	: print EXPRESSION {
				if($2->type == TYPE_TEXT){
					$$ = newNode(TYPE_TEXT, strcatN(3, "printf(\"%s\",", $2->string , ");\n" ));
				}else if($2->type == TYPE_NUMBER){
					$$ = newNode(TYPE_NUMBER, strcatN(3, "printf(\"%d\",", $2->string , ");\n" ));	
				}
				}
			| {$$ = newNode(TYPE_TEXT, ";");} //Working
			| DECLARATION {$$ = newNode(TYPE_TEXT, $1->string);}
			| ASSIGNMENT {$$ = newNode(TYPE_TEXT, $1->string);}
			| DEFINITION {$$ = newNode(TYPE_TEXT, $1->string);};


EXPRESSION	: TERM  {$$ = $1;}
			|EXPRESSION PLUS EXPRESSION{
									 if($1->type == TYPE_TEXT)
									{
										$$ = newNode(TYPE_TEXT, strcatN(5,"strcatP(",$1->string,",",$3->string,")"));
									}
									else
										$$ = newNode(TYPE_NUMBER, strcatN(5,"(",$1->string,")+(",$3->string,")"));
									}
			| EXPRESSION MINUS EXPRESSION {
									if($1->type == TYPE_TEXT || $3->type == TYPE_TEXT){
										yyerror("Operacion Invalida - se requieren operandos del tipo numero.");
									}
									else{
										$$ = newNode(TYPE_NUMBER,strcatN(5,"(",$1->string,")-(",$3->string,")"));
									}
			}
			|EXPRESSION MUL EXPRESSION {
									if($1->type == TYPE_TEXT || $3->type == TYPE_TEXT){
										yyerror("Operacion Invalida - se requieren operandos del tipo numero.");
									}
									else{
										$$ = newNode(TYPE_NUMBER, strcatN(5,"(",$1->string,")*(",$3->string,")"));
									}
			}
			|EXPRESSION DIV EXPRESSION{
								if($1->type == TYPE_TEXT || $3->type == TYPE_TEXT){
										yyerror("Operacion Invalida - se requieren operandos del tipo numero.");
									}
									else{								
										if($3->string ==0 ){
											yyerror("Recuerde que no puede dividir por cero");
										}
										else{
											$$ = newNode(TYPE_NUMBER, strcatN(5,"(",$1->string,")/(",$3->string,")"));
										}
									}
			}

TERM		: TEXT_C {$$ = newNode(TYPE_TEXT, $1->string);}
			| NUM_C {$$ = newNode(TYPE_NUMBER, $1->string);}
			| ID {$$ = newNode(getType($1->string),$1->string);};

DECLARATION :NUMBER_T ID {$$ = newNode(TYPE_TEXT,strcatN(3,"int ",$2->string,";")); };

ASSIGNMENT	: ID EQUALS EXPRESSION {$$ = newNode($3->type,strcatN(4,$1->string,"=",$3->string,";"));};

DEFINITION	: NUMBER_T ID EQUALS EXPRESSION { $$ = newNode(TYPE_TEXT,strcatN(5,"int ",$2->string,"=",$4->string,";")); }


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

int getType(char * symbol) 
{
	int index;
	for(index = 0; index < symbols; index++) {
		if(strcmp(symbol, symbolsTable[index]) == 0) {
			return symbolsType[index];
		}
	}

	return TYPE_NOTFOUND;
}

void insertSymbol(char * symbol, int symbolType)
{
	int index;
 	for(index = 0; index < symbols; index++) {
		if(strcmp(symbol, symbolsTable[index]) == 0) {
			if(symbolsType[index] == symbolType)
				yyerror("Redeclaration of variable");
			else
				yyerror("Multiple Declaration of Variable");
		}
	}

	symbolsType[symbols] = symbolType;
	strcpy(symbolsTable[symbols], symbol);
	symbols++;
}