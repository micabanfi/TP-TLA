%{
	#include "node.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h> 
	#include <stdarg.h>
	#include <string.h>
	
	#define TYPE_NOTFOUND 0
	#define TYPE_NUMBER 1
	#define TYPE_TEXT 2
	
	int yydebug=1; 
	extern int yylex();
	extern int lines;
	
	char symbolsTable[100][100];
	int countSymbols = 0, symbolsType[10000];
	void yyerror(const char * s);
	char* strcatN(int num, ...);
	void newSymbol(char * symbol, int symbolType);
	int getType(char * symbol);
	void checkType(int t1, int t2);
	void repeteadVariable(char * currentSymbol);
	void errorType();
	void sameType(int s1,int s2);
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
			| MAIN END { printf("%s","int main(void){}"); };

CODE		: STATEMENT END_LINE{$$ = newNode(TYPE_TEXT, strcatN(2, $1->string, "\n"));}
			| STATEMENT END_LINE CODE {$$ = newNode(TYPE_TEXT, strcatN(3, $1->string, "\t", $3->string));};
			
STATEMENT 	: print EXPRESSION {
				if($2->type == TYPE_TEXT){
					$$ = newNode(TYPE_TEXT, strcatN(3, "printf(\"%s\",", $2->string , ");\n" ));
				}else if($2->type == TYPE_NUMBER){
					$$ = newNode(TYPE_NUMBER, strcatN(3, "printf(\"%d\",", $2->string , ");\n" ));	
				}
				}
			| {$$ = newNode(TYPE_TEXT, "");} //Working
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

DECLARATION : NUMBER_T ID {	
				newSymbol($2->string,TYPE_NUMBER);
				$$ = newNode(TYPE_TEXT,strcatN(3,"int ",$2->string,";")); }
			| TEXT_T ID {	
				newSymbol($2->string,TYPE_TEXT);
				$$ = newNode(TYPE_TEXT,strcatN(3,"char * ",$2->string,";")); };

ASSIGNMENT	: ID EQUALS EXPRESSION {
				sameType(getType($1->string),$3->type);
				$$ = newNode($3->type,strcatN(4,$1->string,"=",$3->string,";"));};

DEFINITION	: NUMBER_T ID EQUALS EXPRESSION { 
				newSymbol($2->string,TYPE_NUMBER);
				sameType(TYPE_NUMBER,$4->type);
				$$ = newNode(TYPE_TEXT,strcatN(5,"int ",$2->string,"=",$4->string,";")); }
			| TEXT_T ID EQUALS EXPRESSION { 
				newSymbol($2->string,TYPE_TEXT);
				sameType(TYPE_TEXT,$4->type);
				$$ = newNode(TYPE_TEXT,strcatN(5,"char * ",$2->string,"=",$4->string,";")); };


%%

int main(){

  yyparse();
  // printf("No Errors!!\n");
  // return 0;
}		

char* strcatN(int count, ...){
	if(count<=1){
		return NULL;
	}
	char* next;
	char* ret;
	int length = 0;
	
	va_list strings;
	va_start(strings, count);
	next = va_arg(strings, char*);
	length = strlen(next)+ 1;
	ret = (char*)malloc(length);
	strcpy(ret, next);
	for(int i = 1; i < count ; i++){
		next = va_arg(strings, char*);
		length += strlen(next);
		ret = (char*)realloc((void*)ret, length);
		strcat(ret, next);
	}
	va_end(strings);
	return ret;
}

int getType(char * currentSymbol) {
	for(int i = 0; i < countSymbols; i++) {
		if(strcmp(currentSymbol, symbolsTable[i]) == 0) {
			return symbolsType[i];
		}
	}

	return TYPE_NOTFOUND;
}

void sameType(int s1,int s2){
	if(s1!=s2)
		errorType();
}

void newSymbol(char * currentSymbol, int currentSymbolType){

	if(getType(currentSymbol)!=TYPE_NOTFOUND){
		repeteadVariable(currentSymbol);
		return;
	}
		
	//new symbol
	symbolsType[countSymbols] = currentSymbolType;
	strcpy(symbolsTable[countSymbols], currentSymbol);
	countSymbols++;
}

void repeteadVariable(char * currentSymbol){
	char line[10];
	sprintf(line, "%d", lines-1);
	char* ret = strcatN(4,"Redefincion de variable ",currentSymbol," en la linea ", line);
	yyerror(ret);
}

void errorType(){
	char line[10];
	sprintf(line, "%d", lines-1);
	char* ret = strcatN(2,"Tipos no coinciden en la linea ", line);
	yyerror(ret);
}