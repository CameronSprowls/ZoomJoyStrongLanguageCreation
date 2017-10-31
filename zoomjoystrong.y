%{
	#include <stdio.h>
	#include "zoomjoystrong.h"

	int yylex();
	int yylineno;
	void yyerror(const char*);
	int checkPoint(int, int);
	void changeColor(int, int, int);
	void plotPoint(int, int);
	void plotLine(int, int, int, int);
	void plotCircle(int, int, int);
	void plotRectangle(int, int, int, int);

%}

%union {
	int iVal;
	float fVal;
	char* sVal;
}

%start program
%token <iVal> INT
%token <fVal> FLOAT
%token END
%token END_STATEMENT
%token <sVal> POINT
%token <sVal> LINE
%token <sVal> CIRCLE
%token <sVal> RECTANGLE
%token <sVal> SET_COLOR

%%

program:		statement_list end_program
		;
statement_list:		statement
		|	statement statement_list
		;
statement:		statement_point
		|	statement_line
		|	statement_circle
		|	statement_rectangle
		|	statement_set_color
		;
statement_point:	POINT INT INT END_STATEMENT {plotPoint($2, $3);}
		;
statement_line:		LINE INT INT INT INT END_STATEMENT {plotLine($2, $3, $4, $5);}
		;
statement_circle:	CIRCLE INT INT INT END_STATEMENT {plotCircle($2, $3, $4);}
		;
statement_rectangle:	RECTANGLE INT INT INT INT END_STATEMENT {plotRectangle($2, $3, $4, $5);}
		;
statement_set_color:	SET_COLOR INT INT INT END_STATEMENT {changeColor($2, $3, $4);}
		;
end_program:		END END_STATEMENT
		;

%%

int main(int argc, char** argv){
	setup();
	yyparse();
	finish();
	return 0;
}

/********************************************
 * Checks to make sure the point that is try-
 * ing to be plotted is in a valid range.
 * Won't plot if invalid, will if it is.
 * 
 * @param point1 x coord of point.
 * @param point2 y coord of point.
 * @return int 1(true) if point is legal
 *	       0(false) if it isn't.
 *******************************************/
int checkPoint(int point1, int point2){
	if(point1 < 0 || point1 > WIDTH ||
	   point2 < 0 || point2 > HEIGHT){
		return 0;
	} else {
		return 1;
	}
}

/***********************************************
 * Throws proper error messages when something
 * goes wrong.
 * 
 * @param message error provided by the thing
	 	  that had the error.
 **********************************************/
void yyerror(const char* message){
	fprintf(stderr, "%s on %d\n", message, yylineno);
}

/***********************************************
 * Verifies if a point can be plotted, will
 * if it can be, won't if it can't.
 * 
 * @param x x coord of point.
 * @param y y coord of point.
 **********************************************/
void plotPoint(int x, int y){
	if(checkPoint(x, y) == 0){
		printf("Invalid point on point\n");
	} else {
		point(x,y);
	}
}

/*****************************************
 * Verifies if a line can be plotted, will
 * if it can be, won't if it can't.
 * 
 * @param x1 x coord of first point.
 * @param y1 y coord of first point.
 * @param x2 x coord of second point.
 * @param y2 y coord of second point.
 ****************************************/
void plotLine(int x1, int y1, int x2, int y2){
	if(checkPoint(x1, y1) == 0){
		printf("invalid point on line start\n");
	} else {
		line(x1, y1, x2, y2);
	}
}

/**********************************************
 * Verifies if a circle can be plotted, will
 * if it can be, won't if it can't.
 * 
 * @param x x coord of the circle.
 * @param y y coord of the circle.
 * @param radius radius of the circle.
 *********************************************/
void plotCircle(int x, int y, int radius){
	if(checkPoint(x, y) == 0){
		printf("Invalid point on circle start\n");
	} else {
		circle(x, y, radius);
	}
}

/********************************************
 * Verifies if a rectangel can be plotted,
 * will if it can be, won't if it can't.
 * 
 * @param x x coord of the rectangle.
 * @param y y corrd of the rectangle.
 * @param width width of the rectangle.
 * @param height height of the rectangle.
 *******************************************/
void plotRectangle(int x, int y, int width, int height){
	if(checkPoint(x, y) == 0){
		printf("Invalid point on rectangle start\n");
	} else {
		rectangle(x, y, width, height);
	}
}

/********************************************
 * Verofoes to see if a valid color is provided
 * and changes it if it is.
 * 
 * @param red red value of the RGB.
 * @param blue blue value of the RGB.
 * @param green green value of the RGB.
 *******************************************/
void changeColor(int red, int blue, int green){
	if((red >= 0 && red <= 255) && 
	(blue >= 0 && blue <= 255) && 
	(green >= 0 && green <= 255)) {
		set_color(red, green, blue);
	} else {
		printf("Invalid RGB provided\n");
	}

}

