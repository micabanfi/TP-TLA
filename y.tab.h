/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    NUMBER_T = 258,
    TEXT_T = 259,
    MAIN = 260,
    END = 261,
    PRINT = 262,
    texto = 263,
    TEXT_C = 264,
    EQUALS = 265,
    GT = 266,
    GET = 267,
    LT = 268,
    LET = 269,
    EQUALSCMP = 270,
    NTEQUAL = 271,
    PLUS = 272,
    MINUS = 273,
    MUL = 274,
    DIV = 275,
    MOD = 276,
    OR = 277,
    AND = 278,
    NOT = 279
  };
#endif
/* Tokens.  */
#define NUMBER_T 258
#define TEXT_T 259
#define MAIN 260
#define END 261
#define PRINT 262
#define texto 263
#define TEXT_C 264
#define EQUALS 265
#define GT 266
#define GET 267
#define LT 268
#define LET 269
#define EQUALSCMP 270
#define NTEQUAL 271
#define PLUS 272
#define MINUS 273
#define MUL 274
#define DIV 275
#define MOD 276
#define OR 277
#define AND 278
#define NOT 279

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 28 "sintaxis.y" /* yacc.c:1909  */

	Node *node;

#line 106 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */