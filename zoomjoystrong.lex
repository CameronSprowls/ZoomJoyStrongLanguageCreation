%{
	#include <stdio.h>
	#include "zoomjoystrong.tab.h"

%}

%option noyywrap

%%

(end)			{return(END);}

(;)			{return(END_STATEMENT);}

(point)			{return(POINT);}

(line)			{return(LINE);}

(circle)		{return(CIRCLE);}
	
(rectangle)		{return(RECTANGLE);}

(set_color)		{return(SET_COLOR);}
	
[0-9]+			{yylval.iVal = atoi(yytext); return(INT);}

[0-9]+(\.[0-9]+)	{yylval.fVal = atof(yytext); return(FLOAT);}

[\t\n ]			{}

.			{printf("Invalid syntax\n");}

%%

