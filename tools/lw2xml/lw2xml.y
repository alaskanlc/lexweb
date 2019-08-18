// TODO need to work on error recovery

// Prologue
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lw2xml.tab.h"

void yyerror(const char *str)
{
  extern int yylineno;
  fprintf(stderr, "  L.%d: %s\n", yylineno, str);
}
int yylex();
void main()
{
  printf("<lexware>\n");
  // define a function here to substitute &lt; for >, etc. and use that
  // rather than printf
  yyparse();
  printf("</lexware>\n");
  fflush(stdout); // without this, an EAGAIN error (11) was generated
} 
 
%}

// Declarations
%define parse.lac full
%define parse.error verbose

%union {
     char *str;
}

// Tokens - in same order as appearance in grammar
%token RT 
%token   <str> WORDS
%token   PD TAG RTYP DF SETS SET
%token   <str> SETTYPE
%token   TH TC SRC GL EX ENG PRDS PRD PRDGL 
%token   <str> GC2
%token   DIAL DIALX
%token   <str> DIALXLANG
%token   LIT SC
%token   <str> GC3
%token AF
%token   <str> AF2
%token   IFS
%token   <str> AF2B
%token   ASP
%token   <str> AF2C
%token LW 


// Grammar
%%

// Conventions:
//   x.o   : opening tag
//   x.b   : band data
//   x.01  : 0-or-1 elements (regex: ?)
//   x.0m  : 0-to-many elements (regex: *)
//   x.1m  : 1-to-many elements (regex: +)
//   x.alt : alternative elements
//   x.c   : closing tag

// ----------  Level 1 structure: rt | af | lw ---------- 
root.1m: level1.alt | root.1m level1.alt | root.1m error ;

level1.alt: rt | af ; // | lw ;

rt:  rt.o rt.b pd.01 tag.01 rtyp.01 df.01 sets.01 th.0m gc2.0m rt.c ;
rt.o: %empty { printf("<rt>\n"); } ;
rt.b: RT WORDS { printf("<word>%s</word>\n", $2); };
rt.c: %empty { printf("</rt>\n"); } ;


// ---------- rt level 1 attributes ----------

pd.01:   %empty | pd.b ;
pd.b: PD WORDS { printf("<pd>%s</pd>\n", $2); };

tag.01:  %empty | tag.b ;
tag.b: TAG WORDS { printf("<tag>%s</tag>\n", $2); };

rtyp.01: %empty | rtyp.b ;
rtyp.b: RTYP WORDS { printf("<rtyp>%s</rtyp>\n", $2); };

df.01:   %empty | df.b ;
df.b: DF WORDS { printf("<df>%s</df>\n", $2); };

sets.01: %empty | sets ; 

sets:  sets.o sets.b set.1m sets.c ;
sets.o: %empty { printf("<sets>\n"); } ;
sets.b: SETS {                       } ;
sets.c: %empty { printf("</sets>\n"); } ;

set.1m: set | set.1m set ;

set: set.o set.b set.c ;
set.o: %empty { printf("<set>\n"); } ;
set.b: SET SETTYPE WORDS { printf("<type>%s</type>\n<parts>%s</parts>", \
                                  $2, $3); };
set.c: %empty { printf("</set>\n"); } ;

th.0m: %empty | th.0m th ;

th: th.o th.b tc.b gl.b exeng.0m prds.0m th.c ;
th.o: %empty { printf("<th>\n"); } ;
th.b: TH WORDS { printf("<word>%s</word>\n", $2); };
tc.b: TC WORDS { printf("<tc>%s</tc>\n", $2); };
gl.b: GL WORDS { printf("<gl>%s</gl>\n", $2); };
th.c: %empty { printf("</th>\n"); } ;

exeng.0m: %empty | exeng.0m exeng ;

exeng: exeng.o ex.b dial.01 eng.b exeng.c ;
exeng.o: %empty { printf("<example>\n"); } ;
ex.b: EX WORDS { printf("<ex>%s</ex>\n", $2); };
eng.b: ENG WORDS { printf("<eng>%s</eng>\n", $2); };
exeng.c: %empty { printf("</example>\n"); } ;

prds.0m: %empty | prds.0m prds ;

prds: prds.o prds.b prd.1m prds.c ;
prds.o: %empty { printf("<paradigms>\n"); } ;
prds.b: PRDS { };
prds.c: %empty { printf("</paradigms>\n"); } ;

prd.1m: prd | prd.1m prd ;

prd: prd.o prd.b prdgl.b prd.c ;
prd.o: %empty { printf("<paradigm>\n"); } ;
prd.b: PRD WORDS { printf("<dene>%s</dene>\n", $2); };
prdgl.b: PRDGL WORDS { printf("<gloss>%s</gloss>\n", $2); };
prd.c: %empty { printf("</paradigm>\n"); } ;

// ---------- .rt second level ----------

gc2.0m: %empty | gc2.0m gc2 ;

gc2: gc2.o gc2.b dial.01 gl.b lit.01 sc.01 exeng.0m gc3.0m gc2.c ;
gc2.o: %empty { printf("<gc2>\n"); } ;
gc2.b: GC2 WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };
gc2.c: %empty { printf("</gc2>\n"); } ;

dial.01: %empty | dial ;

// dial is tricky, because it takes two forms:
//  `dial LANG`
dial: dial.o dial.b dialx.0m dial.c ;
dial.o: %empty { printf("<dial>\n"); } ;
dial.b: DIAL WORDS { printf("<lang>%s</lang>\n", $2); };
dial.c: %empty { printf("</dial>\n"); } ;

dialx.0m: %empty | dialx.0m dialx ;

//  and `dial LANG words`
dialx: dialx.o dialx.b dialx.c
dialx.o: %empty { printf("<dialx>\n"); } ;
dialx.b: DIALX DIALXLANG WORDS { printf("<word>%s</word>\n<lang>%s</lang>\n", $3, $2); };
dialx.c: %empty { printf("</dialx>\n"); } ;

lit.01: %empty | lit.b ;
lit.b: LIT WORDS { printf("<lit>%s</lit>\n", $2); };

sc.01: %empty | sc.b ;
sc.b: SC WORDS { printf("<sc>%s</sc>\n", $2); };

// ---------- .rt third level ----------

gc3.0m: %empty | gc3.0m gc3 ;

gc3: gc3.o gc3.b dial.01 gl.b lit.01 sc.01 exeng.0m gc3.c ;
gc3.o: %empty { printf("<gc3>\n"); } ;
gc3.b: GC3 WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };
gc3.c: %empty { printf("</gc3>\n"); } ;

// ---------- .af ----------

af:  af.o af.b pd.01 tag.01 rtyp.01 df.01 af2.0m af2b.0m af2c.0m af.c ;
af.o: %empty { printf("<af>\n"); } ;
af.b: AF WORDS { printf("<word>%s</word>\n", $2); };
af.c: %empty { printf("</af>\n"); } ;

af2.0m: %empty | af2.0m af2 ;

af2: af2.o af2.b dial.01 gl.b exeng.0m prds.0m ifs.0m af2.c ;
af2.o: %empty { printf("<af2>\n"); } ;
af2.b: AF2 WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };
af2.c: %empty { printf("</af2>\n"); } ;

ifs.0m: %empty | ifs.0m ifs ;

ifs: ifs.o ifs.b dial.01 gl.b exeng.0m ifs.c ;
ifs.o: %empty { printf("<ifs>\n"); } ;
ifs.b: IFS WORDS { printf("<word>%s</word>\n", $2); };
ifs.c: %empty { printf("</ifs>\n"); } ;

af2b.0m: %empty | af2b.0m af2b ;

af2b: af2b.o af2b.b dial.01 asp.01 gl.b exeng.0m th.0m af2b.c ;
af2b.o: %empty { printf("<af2>\n"); } ;
af2b.b: AF2B WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };
af2b.c: %empty { printf("</af2>\n"); } ;

asp.01: %empty | asp.b ;

asp.b: ASP WORDS { printf("<asp>%s</asp>\n", $2); };

af2c.0m: %empty | af2c.0m af2c ;

af2c: af2c.o af2c.b dial.01 gl.b exeng.0m af2c.c ;
af2c.o: %empty { printf("<af2>\n"); } ;
af2c.b: AF2C WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };
af2c.c: %empty { printf("</af2>\n"); } ;



/*
lw:  lw.o lw.b lc.01 src.b lwl2.0m lw.c ;
lw.o: %empty { printf("<lw>\n"); } ;
lw.b: LW WORDS { printf("<word>%s</word>\n", $2); };
lw.c: %empty { printf("</lw>\n"); } ;
*/

%%

     // rt:  rt.o rt.b tag.b rt.c | rt.o rt.b tag.b n rt.c | rt.o error rt.c ;
