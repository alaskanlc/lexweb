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
%token   PD TAG RTYP NAV DF SETS SET
%token     ST_CONC ST_CNS  ST_CONA ST_CONT ST_CUST ST_DIST ST_DUR
%token     ST_MOM  ST_MULT ST_NEU  ST_PER  ST_PROG ST_REP  ST_REV
%token     ST_SEM  ST_TRAN
%token   TH TC
// FIXME
//     XXclas-motXX XXclas-statXX conv desc dim dur ext mot neu
//     add u: for   
%token     TC_CLASMOT TC_CLASSTAT TC_CONV TC_DESC TC_DIM TC_DUR TC_EXT
%token     TC_MOT TC_NEU TC_ONO TC_OP  TC_OPONO TC_OPREP TC_OPREV TC_POS
%token     TC_STAT TC_SUC TC_U
%token   CNJ GL QUO EX ENG CIT PRDS PRD PRDGL
%token     PD_1S PD_2S PD_3S PD_1P PD_2P PD_3P PD_1D PD_2D PD_3D 
%token   GC2_ADJ GC2_ADV GC2_ADS GC2_AN  GC2_C   GC2_CNJ GC2_DEM GC2_DIR GC2_ENC
%token     GC2_EXC GC2_I   GC2_IC GC2_IN GC2_INT GC2_N   GC2_NC  GC2_NI
%token     GC2_NIC GC2_NENC GC2_PADJ GC2_PF GC2_SCNJ
%token     GC2_PN  GC2_PSN GC2_PP  GC2_PRO GC2_VEN GC2_VOC GC2_COLL
%token   DIAL DIALX
%token   <str> DIALXLANG
%token   SMF SC LIT
%token   GC3_ADJ GC3_ADV GC3_ADS GC3_AN  GC3_C   GC3_CNJ GC3_DEM GC3_DIR GC3_ENC
%token     GC3_EXC GC3_I   GC3_IC GC3_IN GC3_INT GC3_N   GC3_NC  GC3_NI GC3_DRT
%token     GC3_NIC GC3_NENC GC3_PADJ GC3_PF GC3_SCNJ
%token     GC3_PN  GC3_PSN GC3_PP  GC3_PRO GC3_VEN GC3_VOC GC3_COLL
%token AF
%token   AF2_NSF AF2_SF AF2_VPF AF2_VSF AF2_VSF1 AF2_TFS AF2_NDS
%token   AF2_SDS AF2_NFSF AF2_VFSF AF2_NFAF AF2_VFAF
%token   AF3_IFS AF3_DRT TH3 ASP
%token RA
%token LW SRC  


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

// ----------  Level 1 structure: rt | af | lw | ra ----------

//:<root> (1-to-many) =
root.1m: level1.alt
  | root.1m level1.alt
  | root.1m error ;

//:    <rt> | <af> | <ra> | <lw>
level1.alt: rt | af | lw ; // ra | lw ;

//:<rt> = \n    ".rt"   TEXT : Root word
rt: RT                  { printf("<rt>\n"); }
    WORDS               { printf("<word>%s</word>\n", $3); }
    //:    <attr1>
    attr1
    //:    <sets>  (0-to-1)
    sets.01
    //:    <th>    (0-to-many)
    th.0m
    // TODO: add ..grp here
    //:    <gc2>  (0-to-many)
    //:  | <gc2b> (0-to-many)
    gc2.0m
                        { printf("</rt>\n"); } ;

// ---------- rt level 1 attributes ----------

//:<attr1> =
attr1:
  //:    <pd>    (0-to-1)
  pd.01
  //:    <tag>   (0-to-1)
  tag.01
  //:    <rtyp>  (0-to-1)
  rtyp.01
  //:    <nav>   (0-to-1)
  nav.01
  //:    <df>    (0-to-1)
  df.01
  ;

//:<pd> =\n    "pd"    TEXT : Proto Dene
pd.01: %empty
  | PD WORDS            { printf("<pd>%s</pd>\n", $2); };

//:<tag> =\n    "tag"   TEXT : Tag
tag.01:  %empty
  | TAG WORDS           { printf("<tag>%s</tag>\n", $2); };

//:<rtyp> =\n    "rtyp"  TEXT : Root word type, incl root class: rtu , rrt,  drt, ra
rtyp.01: %empty
  | RTYP WORDS          { printf("<rtyp>%s</rtyp>\n", $2); };

//:<nav> =\n    "nav"  TEXT : Navajo usage
nav.01: %empty
  | NAV WORDS          { printf("<nav>%s</nav>\n", $2); };

//:<df> =\n    "df"    TEXT : Derived forms
df.01:   %empty
  | DF WORDS            { printf("<df>%s</df>\n", $2); };

//:<sets> =\n    "..sets"     : Sets
sets.01: %empty
  |                     { printf("<sets>\n"); }
    SETS
    //:    <set>   (1-to-many)
    set.1m
                        { printf("</sets>\n"); } ;

//:<set> =\n    "set" <settype> TEXT : Aspectual category
set.1m: set
  | set.1m set ;
set:                    { printf("<set>\n"); }
  SET settype.alt WORDS { printf("<parts>%s</parts>", $4); }
                        { printf("</set>\n"); } ;

//:<settype> =
settype.alt:
    ST_CONC { printf("<type>conc</type>\n") ; }
    //:    "conc"       : Conclusive
  | ST_CNS  { printf("<type>cns</type>\n")  ; }
    //:  | "cns"        : Consecutive
  | ST_CONA { printf("<type>cona</type>\n") ; }
    //:  | "cona"       : Conative
  | ST_CONT { printf("<type>cont</type>\n") ; }
    //:  | "cont"       : Continuative
  | ST_CUST { printf("<type>cust</type>\n") ; }
    //:  | "cust"       : Customary
  | ST_DIST { printf("<type>dist</type>\n") ; }
    //:  | "dist"       : Distrubutive
  | ST_DUR  { printf("<type>dur</type>\n")  ; }
    //:  | "dur"        : Durative
  | ST_MOM  { printf("<type>mom</type>\n")  ; }
    //:  | "mom"        : Momentaneous
  | ST_MULT { printf("<type>mult</type>\n") ; }
    //:  | "mult"       : Multiple
  | ST_NEU  { printf("<type>neu</type>\n")  ; }
    //:  | "neu"        : Neuter
  | ST_PER  { printf("<type>per</type>\n")  ; }
    //:  | "per"        : Perambulative
  | ST_PROG { printf("<type>prog</type>\n") ; }
    //:  | "prog"       : Progressive
  | ST_REP  { printf("<type>rep</type>\n")  ; }
    //:  | "rep"        : Repetitive
  | ST_REV  { printf("<type>rev</type>\n")  ; }
    //:  | "rev"        : Reversative
  | ST_SEM  { printf("<type>sem</type>\n")  ; }
    //:  | "sem"        : Semelfactive
  | ST_TRAN { printf("<type>tran</type>\n") ; }
    //:  | "tran"       : Transitional
  ;

//:<th> =
th.0m: %empty
  | th.0m th ;
th:                     { printf("<th>\n");    }
  //:    "..th"  TEXT : Verb theme
  TH WORDS              { printf("<word>%s</word>\n", $3); }
  //:    <tc>    (exactly-1)
  TC tc.alt
  //:    <cnj>   (0-to-1)
  cnj.01
  //:    <gl>    (exactly-1)
  gl
  //:    <ex>    (0-to-many)
  exeng.0m
  //:    <prds>  (0-to-many)
  prds.0m                { printf("</th>\n"); } ;

//:<tc> =
//:    "tc" <tctype> : Theme category
//:<tctype> =
tc.alt:
    //:    "clas-mot"   : Classificatory motion
    TC_CLASMOT          { printf("<tc>clas-mot</tc>\n");  }
    //:  | "clas-stat"  : Classificatory stative
  | TC_CLASSTAT         { printf("<tc>clas-stat</tc>\n"); }
    //:  | "conv"       : Conversive
  | TC_CONV             { printf("<tc>conv</tc>\n");      }
    //:  | "desc"       : Descriptive
  | TC_DESC             { printf("<tc>desc</tc>\n");      }
    //:  | "dim"        : Dimentional
  | TC_DIM              { printf("<tc>dim</tc>\n");       }
    //:  | "dur"        : ??
  | TC_DUR              { printf("<tc>dur</tc>\n");       }
    //:  | "ext"        : Extension
  | TC_EXT              { printf("<tc>ext</tc>\n");       }
    //:  | "mot"        : Motion
  | TC_MOT              { printf("<tc>mot</tc>\n");       }
    //:  | "neu"        : Neuter
  | TC_NEU              { printf("<tc>neu</tc>\n");       }
    //:  | "ono"        : Onomatopoetic
  | TC_ONO              { printf("<tc>ono</tc>\n");       }
    //:  | "op"         : Operative
  | TC_OP               { printf("<tc>op</tc>\n");        }
    //:  | "op-ono"     : Onomatopoetic operative
  | TC_OPONO            { printf("<tc>op-ono</tc>\n");    }
    //:  | "op-rep"     : ??
  | TC_OPREP            { printf("<tc>op-rep</tc>\n");    }
    //:  | "op-rev"     : ??
  | TC_OPREV            { printf("<tc>op-rev</tc>\n");    }
    //:  | "pos"        : ??
  | TC_POS              { printf("<tc>pos</tc>\n");      }
    //:  | "stat"       : Stative
  | TC_STAT             { printf("<tc>stat</tc>\n");      }
    //:  | "suc"        : Successive
  | TC_SUC              { printf("<tc>succ</tc>\n");      }
    //:  | "u:"         : Uncategorized
  | TC_U                { printf("<tc>uncat</tc>\n");      }
  // TODO read the text after u:...
  ;

//:<cnj> =\n    "cnj"   TEXT : Conjugation prefix
cnj.01: %empty
  | CNJ WORDS { printf("<cnj>%s</cnj>\n", $2); } ;

//:<gl> =
gl:
  //:    "gl"    TEXT : Gloss
  GL                    { printf("<gloss>\n"); } 
  WORDS                 { printf("<eng>%s</eng>\n", $3); }
  //:    <quo>   (0-to-1)
  quo.01
  //:    <cit>   (0-to-1)
  cit.01
                        { printf("</gloss>\n"); }
  ;

//:<quo> =\n    "quo"   TEXT : Quotations from consultant (or comment)
quo.01: %empty |
  QUO WORDS { printf("<quo>%s</quo>\n", $2); } ;

//:<cit> =\n    "cit"   TEXT : Citation (e.g., Notebook source)
cit.01: %empty |
  CIT WORDS { printf("<cit>%s</cit>\n", $2); } ;

//:<ex> =
exeng.0m: %empty | exeng.0m exeng ;
exeng:
  //:    "ex"    TEXT : Example
  EX                          { printf("<example>\n"); } 
  WORDS                       { printf("<ex>%s</ex>\n", $3); }
  //:    <dial>  (0-to-1)
  dial.01
  //:    <eng>   (exactly-1)
  eng.b
  //:    <lit>   (0-to-1)
  lit.01
  //:    <quo>   (0-to-1)
  quo.01
  //:    <cit>   (0-to-1)
  cit.01
                              { printf("</example>\n"); }
  ;

//:<eng> =\n    "eng"   TEXT : English translation
eng.b:
  ENG WORDS                   { printf("<eng>%s</eng>\n", $2); }

//:<prds>=
prds.0m: %empty | prds.0m prds ;
prds:
  //:    "...prds" TEXT  : Usage paradigm, with column definition
  PRDS                        { printf("<paradigms>\n"); }
  WORDS                       { printf("<cols>%s</cols>\n", $3); }
  //:    <prd>   (1-to-many)
  prd.1m
                              { printf("</paradigms>\n"); }
  ;

//:<prd> =
prd.1m: prd | prd.1m prd ;
  //:    "prd" <prdtype> TEXT : Paradigm example
prd:
  PRD                          { printf("<paradigm>\n"); }
  prdtype.alt  
  WORDS                        { printf("<dene>%s</dene>\n", $4); }
  //:    <prdgl> (0-to-1)
  prdgl.01
  { printf("</paradigm>\n"); }
;

//:<prdtype> =
prdtype.alt:
     //:    "1s"         : First person singular
     PD_1S       { printf("<type>1s</type>\n");       }
     //:  | "2s"         : Second person singular
  |  PD_2S       { printf("<type>2s</type>\n");       }
     //:  | "3s"         : Third person singular
  |  PD_3S       { printf("<type>3s</type>\n");       }
     //:  | "1p"         : First person plural
  |  PD_1P       { printf("<type>1p</type>\n");       }
     //:  | "2p"         : Second person plural
  |  PD_2P       { printf("<type>2p</type>\n");       }
     //:  | "3p"         : Third person plural
  |  PD_3P       { printf("<type>3p</type>\n");       }
     //:  | "1d"         : First person dual
  |  PD_1D       { printf("<type>1d</type>\n");       }
     //:  | "2d"         : Second person dual
  |  PD_2D       { printf("<type>2d</type>\n");       }
     //:  | "3d"         : Third person dual
  |  PD_3D       { printf("<type>3d</type>\n");       }
  ;

//:<prdgl> =\n    "prdgl" TEXT : Paradigm gloss
prdgl.01: %empty |
  PRDGL WORDS { printf("<gloss>%s</gloss>\n", $2); };


// ---------- .rt second level ----------

//:<gc2> =
// Have to add a fork here to accomodate ..ads
gc2.0m: %empty | gc2.0m gc2 | gc2.0m gc2b ;
gc2.alt:
    //:    "..adj" TEXT : Adjective
    GC2_ADJ { printf("<type>adj</type>\n"); }
    //:  | "..adv" TEXT : Adverb
  | GC2_ADV { printf("<type>adv</type>\n"); }
    //:  | "..an"  TEXT : Areal Noun 
  | GC2_AN  { printf("<type>an</type>\n"); }
    //:  | "..c"   TEXT : Compounding form
  | GC2_C   { printf("<type>c</type>\n"); }
    //:  | "..cnj" TEXT : Conjunction
  | GC2_CNJ { printf("<type>cnj</type>\n"); }
    //:  | "..coll" TEXT : Collocation
  | GC2_COLL { printf("<type>coll</type>\n"); }
    //:  | "..dem" TEXT : demonstrative
  | GC2_DEM { printf("<type>dem</type>\n"); }
    //:  | "..dir" TEXT : directional
  | GC2_DIR { printf("<type>dir</type>\n"); }
    //:  | "..enc" TEXT : enclitic
  | GC2_ENC { printf("<type>enc</type>\n"); }
    //:  | "..exc" TEXT : exclamation
  | GC2_EXC { printf("<type>exc</type>\n"); }
    //:  | "..i"   TEXT : incorporate
  | GC2_I   { printf("<type>i</type>\n"); }
    //:  | "..ic"  TEXT : incorporate compound
  | GC2_IC  { printf("<type>ic</type>\n"); }
    //:  | "..in"  TEXT : instrumental noun
  | GC2_IN  { printf("<type>in</type>\n"); }
    //:  | "..int"  TEXT : interrogative
  | GC2_INT { printf("<type>int</type>\n"); }
    //:  | "..n"   TEXT : Noun
  | GC2_N   { printf("<type>n</type>\n"); }
    //:  | "..nc"  TEXT : noun, compound
  | GC2_NC  { printf("<type>nc</type>\n"); }
    //:  | "..ni"  TEXT : noun, incorporate
  | GC2_NI  { printf("<type>ni</type>\n"); }
    //:  | "..nic"  TEXT : noun, incorporate compund
  | GC2_NIC  { printf("<type>nic</type>\n"); }
    //:  | "..nenc"  TEXT : noun enclitic
  | GC2_NENC  { printf("<type>nenc</type>\n"); }
    //:  | "..padj" TEXT : predicate adjective
  | GC2_PADJ { printf("<type>padj</type>\n"); }
    //:  | "..pf"  TEXT : prefix
  | GC2_PF  { printf("<type>pf</type>\n"); }
    //:  | "..pn"  TEXT : place name
  | GC2_PN  { printf("<type>pn</type>\n"); }
    //:  | "..psn" TEXT : personal name
  | GC2_PSN { printf("<type>psn</type>\n"); }
    //:  | "..pp"  TEXT : postposition
  | GC2_PP  { printf("<type>pp</type>\n"); }
    //:  | "..pro" TEXT : Pronoun
  | GC2_PRO { printf("<type>pro</type>\n"); }
    //:  | "..scnj" TEXT : subordinating conjunction
  | GC2_SCNJ { printf("<type>scnj</type>\n"); }
    //:  | "..ven" TEXT : verb enclytic
  | GC2_VEN { printf("<type>ven</type>\n"); }
    //:  | "..voc" TEXT : vocative
  | GC2_VOC { printf("<type>voc</type>\n"); } ;

gc2:
                                  { printf("<gc2>\n"); }
  gc2.alt
  WORDS                           { printf("<word>%s</word>\n", $3); }
  //:    <attr2>
  attr2
  //:    <gc3>   (0-to-many)
  //:  | <gc3b> (0-to-many)
  gc3.0m
                                  { printf("</gc2>\n"); }
  ;

//:<attr2> =
// level 2 and 3 attributes
attr2:
  //:    <dial>  (0-to-1)
  dial.01
  //:    <gl>    (exactly-1)
  gl
  //:    <smf>   (0-to-1)
  smf.01
  //:    <sc>    (0-to-1)
  sc.01
  //:    <lit>   (0-to-1)
  lit.01
  //:    <ex>    (0-to-many)
  exeng.0m
  ;

//:<dial> =
dial.01: %empty | dial ;
// dial is tricky, because it takes two forms:
//  `dial LANG`
dial:
  //:    "dial" <lang> : Dialect
  DIAL                     { printf("<dial>\n"); }
  WORDS                    { printf("<lang>%s</lang>\n", $3); }
  //:    <dial2> (0-to-many)
  dialx.0m
                           { printf("</dial>\n"); }
  ;
//:<lang> =\n            TEXT : Language

//:<dial2> =
dialx.0m: %empty | dialx.0m dialx ;
//  and `dial LANG words`
dialx:
//:    "dial" <lang> TEXT : Additional dialects
  DIALX               { printf("<dialx>\n"); }
  DIALXLANG WORDS     { printf("<word>%s</word>\n<lang>%s</lang>\n", $4, $3); }
                      { printf("</dialx>\n"); }
  ;

//:<smf> =\n    "smf"    TEXT : Semantic field
// Semantic field band data: 1-to-many tags, space delimited
smf.01: %empty | smf.b ;
smf.b: SMF WORDS { printf("<smf>%s</smf>\n", $2); };

//:<sc> =\n    "sc"    TEXT : Scientific name
sc.01: %empty | sc.b ;
sc.b: SC WORDS { printf("<sc>%s</sc>\n", $2); };

//:<lit> =\n    "lit"   TEXT : Literal translation
lit.01: %empty | lit.b ;
lit.b: LIT WORDS { printf("<lit>%s</lit>\n", $2); };

//:<gc2b> =
// Just ..ads
gc2b:
                                  { printf("<gc2>\n"); }
  //:    "..ads" TEXT : aspectual derivational string
  GC2_ADS                         { printf("<type>ads</type>\n"); }
  WORDS                           { printf("<word>%s</word>\n", $4); }
  //:    <attr2b>
  attr2b
  //:    <gc3>   (0-to-many)
  //:  | <gc3b> (0-to-many)
  gc3.0m
                                  { printf("</gc2>\n"); }
  ;

//:<attr2b> =
// level 2 and 3 attributes for ..ads and ..tfs and ...ads
attr2b:
  //:    <dial>  (0-to-1)
  dial.01
  //:    <tc>    (0-to-1)
  tc.01
  //:    <asp>   (0-to-1)
  asp.01
  //:    <cnj>   (0-to-1)
  cnj.01
  //:    <gl>    (exactly-1)
  gl
  //:    <smf>   (0-to-1)
  smf.01
  //:    <sc>    (0-to-1)
  sc.01
  //:    <lit>   (0-to-1)
  lit.01
  //:    <ex>    (0-to-many)
  exeng.0m
  ;

tc.01: %empty | TC tc.alt ;

//:<asp> =\n  "asp" TEXT : Aspect
asp.01: %empty | asp ;
asp: ASP WORDS { printf("<asp>%s</asp>\n", $2); } ;

// ---------- .rt third level ----------

//:<gc3> =
// Have to add a fork here to accomodate ..ads
gc3.0m: %empty | gc3.0m gc3 | gc3.0m gc3b ;

gc3.alt:
    //:    "...adj" TEXT : Adjective
    GC3_ADJ { printf("<type>adj</type>\n"); }
    //:  | "...adv" TEXT : Adverb
  | GC3_ADV { printf("<type>adv</type>\n"); }
    //:  | "...an"  TEXT : Areal Noun 
  | GC3_AN  { printf("<type>an</type>\n"); }
    //:  | "...c"   TEXT : Compounding form
  | GC3_C   { printf("<type>c</type>\n"); }
    //:  | "...cnj" TEXT : Conjunction
  | GC3_CNJ { printf("<type>cnj</type>\n"); }
    //:  | "...coll" TEXT : Collocation
  | GC3_COLL { printf("<type>coll</type>\n"); }
    //:  | "...dem" TEXT : demonstrative
  | GC3_DEM { printf("<type>dem</type>\n"); }
    //:  | "...dir" TEXT : directional
  | GC3_DIR { printf("<type>dir</type>\n"); }
    //:  | "...drt" TEXT : derived root
  | GC3_DRT { printf("<type>drt</type>\n"); }
    //:  | "...enc" TEXT : enclitic
  | GC3_ENC { printf("<type>enc</type>\n"); }
    //:  | "...exc" TEXT : exclamation
  | GC3_EXC { printf("<type>exc</type>\n"); }
    //:  | "...i"   TEXT : incorporate
  | GC3_I   { printf("<type>i</type>\n"); }
    //:  | "...ic"  TEXT : incorporate compound
  | GC3_IC  { printf("<type>ic</type>\n"); }
    //:  | "...in"  TEXT : instrumental noun
  | GC3_IN  { printf("<type>in</type>\n"); }
    //:  | "...int"  TEXT : interrogative
  | GC3_INT { printf("<type>int</type>\n"); }
    //:  | "...n"   TEXT : Noun
  | GC3_N   { printf("<type>n</type>\n"); }
    //:  | "...nc"  TEXT : noun, compound
  | GC3_NC  { printf("<type>nc</type>\n"); }
    //:  | "...ni"  TEXT : noun, incorporate
  | GC3_NI  { printf("<type>ni</type>\n"); }
    //:  | "...nic"  TEXT : noun, incorporate compund
  | GC3_NIC  { printf("<type>nic</type>\n"); }
    //:  | "...nenc"  TEXT : noun enclitic
  | GC3_NENC  { printf("<type>nenc</type>\n"); }
    //:  | "...padj" TEXT : predicate adjective
  | GC3_PADJ { printf("<type>padj</type>\n"); }
    //:  | "...pf"  TEXT : prefix
  | GC3_PF  { printf("<type>pf</type>\n"); }
    //:  | "...pn"  TEXT : place name
  | GC3_PN  { printf("<type>pn</type>\n"); }
    //:  | "...psn" TEXT : personal name
  | GC3_PSN { printf("<type>psn</type>\n"); }
    //:  | "...pp"  TEXT : postposition
  | GC3_PP  { printf("<type>pp</type>\n"); }
    //:  | "...pro" TEXT : Pronoun
  | GC3_PRO { printf("<type>pro</type>\n"); }
    //:  | "...scnj" TEXT : subordinating conjunction
  | GC3_SCNJ { printf("<type>scnj</type>\n"); }
    //:  | "...ven" TEXT : verb enclytic
  | GC3_VEN { printf("<type>ven</type>\n"); }
    //:  | "...voc" TEXT : vocative
  | GC3_VOC { printf("<type>voc</type>\n"); } ;
gc3:
                                  { printf("<gc3>\n"); }
  gc3.alt
  WORDS                           { printf("<word>%s</word>\n", $3); }
  //:    <attr2>
  attr2
                                  { printf("</gc3>\n"); }
  ;

//:<gc3b> =
// Just ...ads
gc3b:
                                  { printf("<gc3>\n"); }
  //:    "...ads" TEXT : aspectual derivational string
  GC3_ADS                         { printf("<type>ads</type>\n"); }
  WORDS                           { printf("<word>%s</word>\n", $4); }
  //:    <attr2b>
  attr2b
                                  { printf("</gc3>\n"); }
  ;

// ---------- .af ----------
// Grammar as of early Jan 2010, meeting with Jim Kari and Jason Harris

//:\n<af> = 
//:  ".af" TEXT : Affix
af:
  AF                              { printf("<af>\n"); }
  WORDS                           { printf("<word>%s</word>\n", $3); }
  //:  <attr1>
  attr1
  //:  <afnv> (0-to-1)
  afnv.0m
                                  { printf("</af>\n"); }
  ;

//:<afnv> =
afnv.0m:
    %empty
    //:    <afn2> (1-to-many)
  | { printf("<aftype>noun</aftype>\n"); }   afn2.1m                       
    //:  | <afv2> (1-to-many)
  | { printf("<aftype>verb</aftype>\n"); }   afv2.1m                       
  ;

//:<afn2> =
afn2.1m: afn2 | afn2.1m afn2 ;
afn2.alt:
    //:    "..nsf"  TEXT : Noun suffix
    AF2_NSF                { printf("<type>nsf</type>\n"); } 
    //:    "..sf"   TEXT : Suffix
  | AF2_SF                { printf("<type>sf</type>\n"); }
    //:    "..nfaf" TEXT : Noun formation affix 
  | AF2_NFAF                   { printf("<type>nfaf</type>\n"); }
    //:  | "..nfsf" TEXT : Noun formation suffix
  | AF2_NFSF                   { printf("<type>nfsf</type>\n"); }
    ;
afn2:
                         { printf("<af2>\n"); } 
  afn2.alt  WORDS        { printf("<word>%s</word>\n", $3); }
  //:    <attr2>
  attr2
  //:    <gc3> (0-to-many)
  gc3.0m
                         { printf("</af2>\n"); }
  ;

//:<afv2> =
afv2.1m: afv2x | afv2.1m afv2x ;
afv2x:
//:    <afv2a>
    afv2a
//:  | <afv2b>
  | afv2b
//:  | <afv2c>
  | afv2c
  ;

//:<afv2a> =
afv2a.alt:
    //:    "..vsf1" TEXT : Verb suffix 1
    AF2_VSF1                  { printf("<type>vsf1</type>\n"); } 
    //:  | "..vsf"  TEXT : Verb suffix
  | AF2_VSF                   { printf("<type>vsf</type>\n"); }
    //:  | "..nds"  TEXT : Non-derivational suffix
  | AF2_NDS                   { printf("<type>nds</type>\n"); }
    //:  | "..vfaf" TEXT : Verb formation affix
  | AF2_VFAF                   { printf("<type>vfaf</type>\n"); }
    //:  | "..vfsf" TEXT : Verb formation suffix
  | AF2_VFSF                   { printf("<type>vfsf</type>\n"); }
    //:  | "..vpf" TEXT :  Verb prefix
  | AF2_VPF                   { printf("<type>vpf</type>\n"); }
    //: |  "..sds"  TEXT : Suffix derivational string
  | AF2_SDS                   { printf("<type>sds</type>\n"); }
    ;
afv2a:
                          { printf("<af2>\n"); } 
  afv2a.alt  WORDS        { printf("<word>%s</word>\n", $3); }
  //:    <attr2>
  attr2
  //:    <prds> (0-to-many)
  prds.0m
  //:    <gc3> (0-to-many)
  gc3.0m
  //:    <ifs> (0-to-many)
  ifs.0m 
                         { printf("</af2>\n"); }
  ;

//:<ifs> =
ifs.0m: %empty | ifs.0m ifs ;
ifs:
                                  { printf("<gc3>\n"); }
  //:  "...ifs" TEXT : Inflectional string 
  AF3_IFS                         { printf("<type>ifs</type>\n");    }
  WORDS                           { printf("<word>%s</word>\n", $4); }
  //:    <attr2>
  attr2
                                  { printf("</gc3>\n"); }
  ;

// Type 'b': ADS
//:<afv2b> =
afv2b:
                         { printf("<af2>\n"); }
  //:    "..ads"  TEXT : Aspectual derivational string
                         { printf("<type>ads</type>\n"); } 
  GC2_ADS  WORDS         { printf("<word>%s</word>\n", $4); }
  //:    <attr2c>
  attr2b
  //:    <prds> (0-to-many)
  prds.0m
  //:    <gc3> (0-to-many)
  gc3.0m
                         { printf("</af2>\n"); }
  ;

// Type 'c': TFS - has a ...th
//:<afv2c> =
afv2c:
                         { printf("<af2>\n"); }
  //:    "..tfs"  TEXT : Theme formation string
                         { printf("<type>tfs</type>\n"); } 
  AF2_TFS  WORDS         { printf("<word>%s</word>\n", $4); }
  //:    <attr2c>
  attr2b
  //:    <th2> (0-to-many)
  th3.0m
  //:    <gc3> (0-to-many)
  gc3.0m
                         { printf("</af2>\n"); }
  ;

//:<th2> =
th3.0m: %empty
  | th3.0m th3
  ;
th3:                     { printf("<th3>\n");    }
  //:  "...th" TEXT : Verb theme
  TH3 WORDS              { printf("<word>%s</word>\n", $3); }
  //:  <tc> (exactly-1)
  TC tc.alt
  //:    <cnj>   (0-to-1)
  cnj.01
  //:    <gl>    (exactly-1)
  gl
  //:    <ex>    (0-to-many)
  exeng.0m
  //:    <prds>  (0-to-many)
                          { printf("</th3>\n"); }
  ;

// --------------------- .lw --------------------------

//:<lw> = \n    ".lw"   TEXT : Loan word
lw: LW                  { printf("<lw>\n"); }
    WORDS               { printf("<word>%s</word>\n", $3); }
    //:    <src>   (exactly-1)
    src                 
    //:    <gc2>   (0-to-many)
    gc2.0m
                        { printf("</lw>\n"); } ;

//:<src> =\n    "src"   TEXT : Source language
src: SRC WORDS            { printf("<source>%s</source>\n", $2); }


/*
// --------------------- .ra --------------------------


//:<ra> = \n    ".ra"   TEXT : Root word and affix
rt: RA                  { printf("<ra>\n"); }
    WORDS               { printf("<word>%s</word>\n", $3); }
    //:    <attr1> (exactly-1)
    attr1
    //:    <sets>  (0-to-1)
    sets.01
    //:    <th>    (0-to-many)
    th.0m
    //:    <ra2>   (0-to-1)
    ra2.01
                        { printf("</ra>\n"); }
    ;

// Tricky: if it contains an af, all the af types must be the same
//:<ra2> =
ra2.01: %empty | ra2.alt ;
ra2.alt: ra2an.1m | ra2av.1m ;

ra2an.1m: ra2an | ra2an.1m ra2an ;
ra2an: gc2 | afn2 ;
ra2av.1m: ra2av | ra2av.1m ra2av ;
ra2av: gc2 | afv2x ;
*/


%%

