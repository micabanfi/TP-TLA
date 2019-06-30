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
	#define TYPE_BOOL 3
	
	int yydebug=1; 
	extern int yylex();
	extern int lines;
	extern int variableDefinition;
	char symbolsTable[100][100];
	int countSymbols = 0, symbolsType[10000];
	void yyerror(const char * s);
	char* strcatN(int num, ...);
	void newSymbol(char * symbol, int symbolType);
	int getType(char * symbol);
	void repeteadVariable(char * currentSymbol);
	void errorType();
	void sameType(int s1,int s2);
	void posibleDefinition();
	void wrongPlaceDefinition();

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
%token DO
%token WHILE
%token GET
%token LET
%token LT
%token FOR
%token TO
%token ENDFOR
%token STEP
%token GT
%token DIF
%token PLUS
%token MINUS
%token MULT
%token DIV
%token OP
%token CP
%token FROM
%token ERROR
%token WRITE

// Finales variables ?
%token<node> NUMBER_T
%token<node> TEXT_T
%token<node> MAIN
%token<node> END
%token<node> TEXT_C
%token<node> NUM_C
%token<node> ID
%token<node> IF
%token<node> ENDIF
%token<node> OR
%token<node> ELSE
%token<node> AND
%token<node> END_LINE



//No finales
%type<node> PROGRAM
%type<node> STATEMENT
%type<node> EXPRESSION
%type<node> CONDITIONAL
%type<node> ELIF
%type<node> CODE
%type<node> TERM
%type<node> ASSIGNMENT
%type<node> DEFINITION
%type<node> DECLARATION



%right EQUALS DIF
%left GT GET LT LET 
%left  EQUALSCMP NTEQUAL
%left PLUS MINUS MUL DIV MOD
%left OR AND NOT 
 

%start PROGRAM

%%
PROGRAM 	: MAIN CODE END {printf("%s",strcatN(5,"#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <ctype.h>\n",
							"char* concat(const char *s1, const char *s2){char *result = malloc(strlen(s1) + strlen(s2) + 1);strcpy(result, s1);strcat(result, s2);return result;}",
							"\n\nint main(void){\n\t",$2->string,"\n}\n"));}
			| MAIN END { printf("%s","int main(void){}"); };

CODE		: STATEMENT {$$ = newNode(TYPE_TEXT, strcatN(2, $1->string, ""));}
			| STATEMENT CODE {$$ = newNode(TYPE_TEXT, strcatN(3, $1->string, "\t", $2->string));};
			
STATEMENT 	: print EXPRESSION END_LINE {
				if($2->type == TYPE_TEXT){
					$$ = newNode(TYPE_TEXT, strcatN(3, "printf(\"%s\\n\",", $2->string , ");\n" ));
				}else if($2->type == TYPE_NUMBER){
					$$ = newNode(TYPE_NUMBER, strcatN(3, "printf(\"%d\\n\",", $2->string , ");\n" ));	
				}
			}
			| WRITE ID END_LINE {	sameType(TYPE_TEXT,getType($2->string));
									$$ = newNode(TYPE_TEXT, strcatN(
									11,
									"char CONST_VARIABLE_DEFINE=0;\n int COUNTER_VARIABLE_DEFINE=0;\n",
									$2->string,
									"=calloc(100,1);\n while((CONST_VARIABLE_DEFINE=getchar())!='\\n'){\n if(COUNTER_VARIABLE_DEFINE!=0 && COUNTER_VARIABLE_DEFINE%100 == 0)\n ",
									$2->string,
									"= realloc(",$2->string,",(COUNTER_VARIABLE_DEFINE/100+2)*100);\n ",
									$2->string,
									"[COUNTER_VARIABLE_DEFINE++]=CONST_VARIABLE_DEFINE;}\n",
									$2->string,
									"[COUNTER_VARIABLE_DEFINE] = '\\0';\n"))
								;} 
			| END_LINE {$$ = newNode(TYPE_TEXT, "\n");} //Working
			| DECLARATION END_LINE {$$ = newNode(TYPE_TEXT, $1->string);}
			| ASSIGNMENT END_LINE {$$ = newNode(TYPE_TEXT, $1->string);}
			| DEFINITION END_LINE {$$ = newNode(TYPE_TEXT, $1->string);}
			| IF CONDITIONAL END_LINE CODE ELIF{$$ = newNode(TYPE_TEXT, strcatN(6, "if (",$2->string, "){\n", $4->string ,"\n}", $5->string));}
			| IF CONDITIONAL END_LINE CODE ENDIF END_LINE{$$ = newNode(TYPE_TEXT, strcatN(5, "if (",$2->string, "){\n", $4->string ,"\n}\n"));}
			| DO END_LINE CODE WHILE CONDITIONAL END_LINE{$$ = newNode(TYPE_TEXT, strcatN(5, "do {\n",$3->string, "} while (", $5->string ,");\n"));};
			| FOR ID FROM NUM_C TO NUM_C STEP NUM_C END_LINE CODE ENDFOR END_LINE {
				sameType(TYPE_NUMBER,getType($2->string));
				$$ = newNode(TYPE_TEXT, strcatN(15, "for(", $2->string," = ", $4->string,";",$2->string,"<=", $6->string,";",$2->string,"+=", $8->string,"){\n", $10->string, "}\n"));}
			| FOR ID FROM NUM_C TO NUM_C END_LINE CODE ENDFOR END_LINE {
				sameType(TYPE_NUMBER,getType($2->string));
				$$ = newNode(TYPE_TEXT, strcatN(13, "for(", $2->string," = ", $4->string,";",$2->string,"<=", $6->string,";",$2->string,"++){\n", $8->string, "}\n"));}

ELIF        : OR IF CONDITIONAL END_LINE CODE ENDIF END_LINE {$$ = newNode(TYPE_TEXT, strcatN(5, " else if ", $3->string, "{\n", $5->string ,"\n}\n"));}
			| OR IF CONDITIONAL END_LINE CODE ELIF {$$ = newNode(TYPE_TEXT, strcatN(6, " else if ", $3->string, "{\n", $5->string ,"\n}", $6->string));}
			| ELSE END_LINE CODE ENDIF END_LINE{$$ = newNode(TYPE_TEXT, strcatN(3, " else {\n", $3->string, "}\n"));};
			
CONDITIONAL : EXPRESSION EQUALS EXPRESSION 	{sameType($1->type,$3->type);
											if($1->type==TYPE_TEXT)
												$$ = newNode(TYPE_TEXT, strcatN(5, "(strcmp(", $1->string, ",", $3->string, ")==0)"));
											else	
												$$ = newNode(TYPE_TEXT, strcatN(5, "(", $1->string, " == ", $3->string, ")"));
											}

			| EXPRESSION DIF EXPRESSION 	{sameType($1->type,$3->type);
											if($1->type==TYPE_TEXT)
												$$ = newNode(TYPE_TEXT, strcatN(5, "(strcmp(", $1->string, ",", $3->string, ")!=0)"));
											else	
												$$ = newNode(TYPE_TEXT, strcatN(5, "(", $1->string, " != ", $3->string, ")"));
											}
			| EXPRESSION GT EXPRESSION 		{sameType($1->type,$3->type);
											if($1->type==TYPE_TEXT)
												$$ = newNode(TYPE_TEXT, strcatN(5, "(strcmp(", $1->string, ",", $3->string, ")>0)"));
											else	
												$$ = newNode(TYPE_TEXT, strcatN(5, "(", $1->string, " > ", $3->string, ")"));
											}	
			| EXPRESSION GET EXPRESSION 	{sameType($1->type,$3->type);
											if($1->type==TYPE_TEXT)
												$$ = newNode(TYPE_TEXT, strcatN(5, "(strcmp(", $1->string, ",", $3->string, ")>=0)"));
											else	
												$$ = newNode(TYPE_TEXT, strcatN(5, "(", $1->string, " >= ", $3->string, ")"));
											}
			| EXPRESSION LT EXPRESSION 		{sameType($1->type,$3->type);
											if($1->type==TYPE_TEXT)
												$$ = newNode(TYPE_TEXT, strcatN(5, "(strcmp(", $1->string, ",", $3->string, ")<0)"));
											else	
												$$ = newNode(TYPE_TEXT, strcatN(5, "(", $1->string, "<", $3->string, ")"));
											}	
			| EXPRESSION LET EXPRESSION 	{sameType($1->type,$3->type);
											if($1->type==TYPE_TEXT)
												$$ = newNode(TYPE_TEXT, strcatN(5, "(strcmp(", $1->string, ",", $3->string, ")<=0)"));
											else	
												$$ = newNode(TYPE_TEXT, strcatN(5, "(", $1->string, " <= ", $3->string, ")"));
											}
			| OP CONDITIONAL OR CONDITIONAL CP {$$ = newNode(TYPE_TEXT, strcatN(5, "(", $2->string, " || ", $4->string, ")"));}
			| OP CONDITIONAL AND CONDITIONAL CP {$$ = newNode(TYPE_TEXT, strcatN(5, "(", $2->string, " && ", $4->string, ")"));};

EXPRESSION	: TERM  {$$ = $1;}
	
			|EXPRESSION PLUS EXPRESSION{
									sameType($1->type, $3->type);
									 if($1->type == TYPE_TEXT)
									{
										$$ = newNode(TYPE_TEXT, strcatN(5,"concat(",$1->string,",",$3->string,")"));
									}
									else
										$$ = newNode(TYPE_NUMBER, strcatN(5,"(",$1->string,")+(",$3->string,")"));
									}
			| EXPRESSION MINUS EXPRESSION {
									if($1->type == TYPE_TEXT || $3->type == TYPE_TEXT){
										yyerror("Operacion Invalida - se requieren operandos del tipo numero.");
										exit(1);
									}
									else{
										$$ = newNode(TYPE_NUMBER,strcatN(5,"(",$1->string,")-(",$3->string,")"));
									}
			}
			|EXPRESSION MUL EXPRESSION {
									if($1->type == TYPE_TEXT || $3->type == TYPE_TEXT){
										yyerror("Operacion Invalida - se requieren operandos del tipo numero.");
										exit(1);
									}
									else{
										$$ = newNode(TYPE_NUMBER, strcatN(5,"(",$1->string,")*(",$3->string,")"));
									}
			}
			|EXPRESSION DIV EXPRESSION{
								if($1->type == TYPE_TEXT || $3->type == TYPE_TEXT){
										yyerror("Operacion Invalida - se requieren operandos del tipo numero.");
										exit(1);
									}
									else{								
										if($3->string ==0 ){
											yyerror("Recuerde que no puede dividir por cero");
											exit(1);
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
				posibleDefinition();
				newSymbol($2->string,TYPE_NUMBER);
				$$ = newNode(TYPE_NUMBER,strcatN(3,"int ",$2->string,";\n")); }
			| TEXT_T ID {	
				posibleDefinition();
				newSymbol($2->string,TYPE_TEXT);
				$$ = newNode(TYPE_TEXT,strcatN(3,"char * ",$2->string,";\n")); };

ASSIGNMENT	: ID EQUALS EXPRESSION {
				sameType(getType($1->string),$3->type);
				$$ = newNode($3->type,strcatN(4,$1->string,"=",$3->string,";\n"));};

DEFINITION	: NUMBER_T ID EQUALS EXPRESSION { 
				posibleDefinition();
				newSymbol($2->string,TYPE_NUMBER);
				sameType(TYPE_NUMBER,$4->type);
				$$ = newNode(TYPE_TEXT,strcatN(5,"int ",$2->string,"=",$4->string,";\n")); }
			| TEXT_T ID EQUALS EXPRESSION { 
				posibleDefinition();
				newSymbol($2->string,TYPE_TEXT);
				sameType(TYPE_TEXT,$4->type);
				$$ = newNode(TYPE_TEXT,strcatN(5,"char * ",$2->string,"=",$4->string,";\n")); };


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

void posibleDefinition(){
	if(variableDefinition!=0){
		wrongPlaceDefinition();
	}
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
	char* ret = strcatN(4,"Redefinicion de variable ",currentSymbol," en la linea ", line);
	yyerror(ret);
	exit(1);
}

void errorType(){
	char line[10];
	sprintf(line, "%d", lines);
	char* ret = strcatN(2,"Los tipos no coinciden en la linea ", line);
	yyerror(ret);
	exit(1);
}

void wrongPlaceDefinition(){
	char line[10];
	sprintf(line, "%d", lines-1);
	char* ret = strcatN(2,"Las variables deben ser definidas al inicio. Definicion erronea en la linea ", line);
	yyerror(ret);
	exit(1);
}
