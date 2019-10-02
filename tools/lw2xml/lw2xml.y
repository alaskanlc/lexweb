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
%token     ST_CONC ST_CNS  ST_CONA ST_CONT ST_CUST ST_DIST ST_DUR
%token     ST_MOM  ST_MULT ST_NEU  ST_PER  ST_PROG ST_REP  ST_REV
%token     ST_SEM  ST_TRAN
%token   TH TC
%token     TC_CLASMOT TC_CLASSTAT TC_CONV TC_DESC TC_DIM TC_EXT
%token     TC_MOT TC_NEU TC_ONO TC_OP  TC_OPONO TC_STAT TC_SUCC
%token   CNJ GL QUO EX ENG CIT PRDS PRD PRDGL
%token     PD_1S PD_2S PD_3S PD_1P PD_2P PD_3P PD_1D PD_2D PD_3D 
%token   GC2_ADJ GC2_ADV GC2_AN  GC2_C   GC2_CNJ GC2_DEM GC2_DIR GC2_ENC
%token   GC2_EXC GC2_I   GC2_IC  GC2_N   GC2_NC  GC2_NI  GC2_PAD GC2_PF
%token   GC2_PN  GC2_PSN GC2_PP  GC2_PRT GC2_VEN GC2_VOC
%token   DIAL DIALX
%token   <str> DIALXLANG
%token   LIT CF SC
%token   GC3_ADJ GC3_ADV GC3_AN  GC3_C   GC3_CNJ GC3_DEM GC3_DIR GC3_ENC
%token   GC3_EXC GC3_I   GC3_IC  GC3_N   GC3_NC  GC3_NI  GC3_PAD GC3_PF
%token   GC3_PN  GC3_PSN GC3_PP  GC3_PRT GC3_VEN GC3_VOC

%token AF
%token   AF2_NSF AF2_SF AF2_VPF AF2_VSF AF2_VSF1 AF2_TFS AF2_NDS AF2_ADS
%token   AF2_SDS AF2_NFSF AF2_VFSF AF2_NFPF AF2_VFPF
%token   AF3_IFS AF3_DRT TH3 ASP
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

// ----------  Level 1 structure: rt | af | lw ----------

 //:<root> (1-to-many) =
root.1m: level1.alt
  | root.1m level1.alt
  | root.1m error ;

//:  <rt> | <af> | <lw>
level1.alt: rt | af ; // | lw ;

//:<rt> = \n  ".rt" TEXT : Root word
rt: RT                  { printf("<rt>\n"); }
    WORDS               { printf("<word>%s</word>\n", $3); }
    //:  <pd> (0-to-1)
    pd.01
    //:  <tag> (0-to-1)
    tag.01
    //:  <rtyp> (0-to-1)
    rtyp.01
    //:  <df> (0-to-1)
    df.01
    //:  <sets> (0-to-1)
    sets.01
    //:  <th> (0-to-many)
    th.0m
    //:  <gc2> (0-to-many)
    gc2.0m
                        { printf("</rt>\n"); } ;

// ---------- rt level 1 attributes ----------

//:<pd> =\n  "pd" TEXT : Proto Dene
pd.01: %empty
  | PD WORDS            { printf("<pd>%s</pd>\n", $2); };

//:<tag> =\n  "tag" TEXT : Tag
tag.01:  %empty
  | TAG WORDS           { printf("<tag>%s</tag>\n", $2); };

//:<rtyp> =\n  "rtyp" TEXT : Root word type, incl root class: rtu , rrt,  drt, ra
rtyp.01: %empty
  | RTYP WORDS          { printf("<rtyp>%s</rtyp>\n", $2); };

//:<df> =\n  "df" TEXT : Derived forms
df.01:   %empty
  | DF WORDS            { printf("<df>%s</df>\n", $2); };

//:<sets> =\n  "..sets" : Sets
sets.01: %empty
  |                     { printf("<sets>\n"); }
    SETS
    //:  <set> (1-to-many)
    set.1m
                        { printf("</sets>\n"); } ;

//:<set> =\n  "set" <settype> TEXT : Aspectual category
set.1m: set
  | set.1m set ;
set:                    { printf("<set>\n"); }
  SET settype.alt WORDS { printf("<parts>%s</parts>", $4); }
                        { printf("</set>\n"); } ;

//:<settype> =
settype.alt:
    ST_CONC { printf("<type>conc</type>\n") ; }
    //:    "conc"  : Conclusive
  | ST_CNS  { printf("<type>cns</type>\n")  ; }
    //:  | "cns"   : Consecutive
  | ST_CONA { printf("<type>cona</type>\n") ; }
    //:  | "cona"  : Conative
  | ST_CONT { printf("<type>cont</type>\n") ; }
    //:  | "cont"  : Continuative
  | ST_CUST { printf("<type>cust</type>\n") ; }
    //:  | "cust"  : Customary
  | ST_DIST { printf("<type>dist</type>\n") ; }
    //:  | "dist"  : Distrubutive
  | ST_DUR  { printf("<type>dur</type>\n")  ; }
    //:  | "dur"   : Durative
  | ST_MOM  { printf("<type>mom</type>\n")  ; }
    //:  | "mom"   : Momentaneous
  | ST_MULT { printf("<type>mult</type>\n") ; }
    //:  | "mult"  : Multiple
  | ST_NEU  { printf("<type>neu</type>\n")  ; }
    //:  | "neu"   : Neuter
  | ST_PER  { printf("<type>per</type>\n")  ; }
    //:  | "per"   : Perambulative
  | ST_PROG { printf("<type>prog</type>\n") ; }
    //:  | "prog"  : Progressive
  | ST_REP  { printf("<type>rep</type>\n")  ; }
    //:  | "rep"   : Repetitive
  | ST_REV  { printf("<type>rev</type>\n")  ; }
    //:  | "rev"   : Reversative
  | ST_SEM  { printf("<type>sem</type>\n")  ; }
    //:  | "sem"   : Semelfactive
  | ST_TRAN { printf("<type>tran</type>\n") ; }
    //:  | "tran"   : Transitional
  ;

//:<th> =
th.0m: %empty
  | th.0m th ;
th:                     { printf("<th>\n");    }
  //:  "..th" TEXT : Verb theme
  TH WORDS              { printf("<word>%s</word>\n", $3); }
  //:  <tc> (exactly-1)
  TC tc.alt
  //:  <cnj> (0-to-1>
  cnj.01
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
  //:  <prds> (0-to-many)
  prds.0m                { printf("</th>\n"); } ;

//:<tc> =
//:  "tc" <tctype> : Theme category
//:<tctype> =
tc.alt:
    //:    "clas-mot"  : Classificatory motion
    TC_CLASMOT          { printf("<tc>clas-mot</tc>\n");  }
    //:  | "clas-stat" : Classificatory stative
  | TC_CLASSTAT         { printf("<tc>clas-stat</tc>\n"); }
    //:  | "conv"      : Conversive
  | TC_CONV             { printf("<tc>conv</tc>\n");      }
    //:  | "desc"      : Descriptive
  | TC_DESC             { printf("<tc>desc</tc>\n");      }
    //:  | "dim"       : Dimentional
  | TC_DIM              { printf("<tc>dim</tc>\n");       }
    //:  | "ext"       : Extension
  | TC_EXT              { printf("<tc>ext</tc>\n");       }
    //:  | "mot"       : Motion
  | TC_MOT              { printf("<tc>mot</tc>\n");       }
    //:  | "neu"       : Neuter
  | TC_NEU              { printf("<tc>neu</tc>\n");       }
    //:  | "ono"       : Onomatopoetic
  | TC_ONO              { printf("<tc>ono</tc>\n");       }
    //:  | "op"        : Operative
  | TC_OP               { printf("<tc>op</tc>\n");        }
    //:  | "op-ono"    : Onomatopoetic operative
  | TC_OPONO            { printf("<tc>op-ono</tc>\n");    }
    //:  | "stat"      : Stative
  | TC_STAT             { printf("<tc>stat</tc>\n");      }
    //:  | "succ"      : Successive
  | TC_SUCC             { printf("<tc>succ</tc>\n");      }
  ;

//:<cnj> =\n  "cnj" TEXT : Conjugation prefix
cnj.01: %empty
  | CNJ WORDS { printf("<cnj>%s</cnj>\n", $2); } ;

//:<gl> =
gl:
  //:  "gl" TEXT : Gloss
  GL                    { printf("<gloss>\n"); } 
  WORDS                 { printf("<eng>%s</eng>\n", $3); }
  //:  <quo> (0-to-1)
  quo.01
  //:  <cit> (0-to-1)
  cit.01
                        { printf("</gloss>\n"); }
  ;

//:<quo> =\n  "quo" TEXT : Quotations from consultant (or comment)
quo.01: %empty |
  QUO WORDS { printf("<quo>%s</quo>\n", $2); } ;

//:<cit> =\n  "cit" TEXT : Citation (e.g., Notebook source)
cit.01: %empty |
  CIT WORDS { printf("<cit>%s</cit>\n", $2); } ;

//:<ex> =
exeng.0m: %empty | exeng.0m exeng ;
exeng:
  //:  "ex" TEXT : Example
  EX                          { printf("<example>\n"); } 
  WORDS                       { printf("<ex>%s</ex>\n", $3); }
  //:  <dial> (0-to-1)
  dial.01
  //:  <eng> (exactly-1)
  eng.b
  //:  <quo> (0-to-1)
  quo.01
  //:  <cit> (0-to-1)
  cit.01
                              { printf("</example>\n"); }
  ;

//:<eng> =\n  "eng" TEXT : English translation
eng.b:
  ENG WORDS                   { printf("<eng>%s</eng>\n", $2); }

//:<prds>=
prds.0m: %empty | prds.0m prds ;
prds:
  //:  "...prds" : Usage paradigm
  PRDS                    { printf("<paradigms>\n"); }
  //:  <prd> (1-to-many)
  prd.1m
                              { printf("</paradigms>\n"); }
  ;

//:<prd> =
prd.1m: prd | prd.1m prd ;
  //:  "prd" <prdtype> TEXT : Paradigm example
prd:
  PRD                          { printf("<paradigm>\n"); }
  prdtype.alt
  WORDS                        { printf("<dene>%s</dene>\n", $4); }
  //:  <prdgl> (exactly-1)
  prdgl.b
  { printf("</paradigm>\n"); }
;

//:<prdtype> =
prdtype.alt:
     //:    "1s" : First person singular
     PD_1S       { printf("<type>1s</type>\n");       }
     //:  | "2s" : Second person singular
  |  PD_2S       { printf("<type>2s</type>\n");       }
     //:  | "3s" : Third person singular
  |  PD_3S       { printf("<type>3s</type>\n");       }
     //:  | "1p" : First person plural
  |  PD_1P       { printf("<type>1p</type>\n");       }
     //:  | "2p" : Second person plural
  |  PD_2P       { printf("<type>2p</type>\n");       }
     //:  | "3p" : Third person plural
  |  PD_3P       { printf("<type>3p</type>\n");       }
     //:  | "1d" : First person dual
  |  PD_1D       { printf("<type>1d</type>\n");       }
     //:  | "2d" : Second person dual
  |  PD_2D       { printf("<type>2d</type>\n");       }
     //:  | "3d" : Third person dual
  |  PD_3D       { printf("<type>3d</type>\n");       }
  ;

//:<prdgl> =\n  "prdgl" TEXT : Paradigm gloss
prdgl.b:
  PRDGL WORDS { printf("<gloss>%s</gloss>\n", $2); };


// ---------- .rt second level ----------

//:<gc2> =
gc2.0m: %empty | gc2.0m gc2 ;
gc2.alt:
    //:    "..adj" TEXT : Adjective
    GC2_ADJ { printf("<type>adj</type>\n"); }
    //:  | "..adv" TEXT : Adverb
  | GC2_ADV { printf("<type>adv</type>\n"); }
    //:  | "..an" TEXT  : 
  | GC2_AN  { printf("<type>an</type>\n"); }
    //:  | "..c" TEXT   : 
  | GC2_C   { printf("<type>c</type>\n"); }
    //:  | "..cnj" TEXT : 
  | GC2_CNJ { printf("<type>cnj</type>\n"); }
    //:  | "..dem" TEXT : 
  | GC2_DEM { printf("<type>dem</type>\n"); }
    //:  | "..dir" TEXT : 
  | GC2_DIR { printf("<type>dir</type>\n"); }
    //:  | "..enc" TEXT : 
  | GC2_ENC { printf("<type>enc</type>\n"); }
    //:  | "..exc" TEXT : 
  | GC2_EXC { printf("<type>exc</type>\n"); }
    //:  | "..i" TEXT   : 
  | GC2_I   { printf("<type>i</type>\n"); }
    //:  | "..ic" TEXT  : 
  | GC2_IC  { printf("<type>ic</type>\n"); }
    //:  | "..n" TEXT   : Noun
  | GC2_N   { printf("<type>n</type>\n"); }
    //:  | "..nc" TEXT  : 
  | GC2_NC  { printf("<type>nc</type>\n"); }
    //:  | "..ni" TEXT  : 
  | GC2_NI  { printf("<type>ni</type>\n"); }
    //:  | "..pad" TEXT : 
  | GC2_PAD { printf("<type>pad</type>\n"); }
    //:  | "..pf" TEXT  : 
  | GC2_PF  { printf("<type>pf</type>\n"); }
    //:  | "..pn" TEXT  : 
  | GC2_PN  { printf("<type>pn</type>\n"); }
    //:  | "..psn" TEXT : 
  | GC2_PSN { printf("<type>psn</type>\n"); }
    //:  | "..pp" TEXT  : 
  | GC2_PP  { printf("<type>pp</type>\n"); }
    //:  | "..prt" TEXT : 
  | GC2_PRT { printf("<type>prt</type>\n"); }
    //:  | "..ven" TEXT : 
  | GC2_VEN { printf("<type>ven</type>\n"); }
    //:  | "..voc" TEXT : 
  | GC2_VOC { printf("<type>voc</type>\n"); } ;

gc2:
                                  { printf("<gc2>\n"); }
  gc2.alt
  WORDS                           { printf("<word>%s</word>\n", $3); }
  //:  <dial> (0-to-1)
  dial.01
  //:  <gl> (exactly-1)
  gl
  //:  <lit> (0-to-1)
  lit.01
  //:  <cf> (0-to-1)
  cf.01
  //:  <sc> (0-to-1)
  sc.01
  //:  <ex> (0-to-many)
  exeng.0m
  //:  <gc3> (0-to-many)
  gc3.0m
                                  { printf("</gc2>\n"); }
  ;

//:<dial> =
dial.01: %empty | dial ;
// dial is tricky, because it takes two forms:
//  `dial LANG`
dial:
  //:  "dial" <lang> : Dialect
  DIAL                     { printf("<dial>\n"); }
  WORDS                    { printf("<lang>%s</lang>\n", $3); }
  //:  <dial2> (0-to-many)
  dialx.0m
                           { printf("</dial>\n"); }
  ;
//:<lang> =\n  TEXT : Language

//:<dial2> =
dialx.0m: %empty | dialx.0m dialx ;
//  and `dial LANG words`
dialx:
//:  "dial" <lang> TEXT : Additional dialects
  DIALX               { printf("<dialx>\n"); }
  DIALXLANG WORDS     { printf("<word>%s</word>\n<lang>%s</lang>\n", $4, $3); }
                      { printf("</dialx>\n"); }
  ;

//:<lit> =\n  "lit" TEXT : Literal translation
lit.01: %empty | lit.b ;
lit.b: LIT WORDS { printf("<lit>%s</lit>\n", $2); };

//:<cf> =\n  "cf" TEXT : Compare with
cf.01: %empty | cf.b ;
cf.b: CF WORDS { printf("<cf>%s</cf>\n", $2); };

//:<sc> =\n  "sc" TEXT : Scientific name
sc.01: %empty | sc.b ;
sc.b: SC WORDS { printf("<sc>%s</sc>\n", $2); };


// ---------- .rt third level ----------

//:<gc3> =
gc3.0m: %empty | gc3.0m gc3 ;
gc3.alt:
    //:    "...adj" TEXT : Adjective
    GC3_ADJ { printf("<type>adj</type>\n"); }
    //:  | "...adv" TEXT : Adverb
  | GC3_ADV { printf("<type>adv</type>\n"); }
    //:  | "...an"  TEXT : 
  | GC3_AN  { printf("<type>an</type>\n"); }
    //:  | "...c"   TEXT : 
  | GC3_C   { printf("<type>c</type>\n"); }
    //:  | "...cnj" TEXT : 
  | GC3_CNJ { printf("<type>cnj</type>\n"); }
    //:  | "...dem" TEXT : 
  | GC3_DEM { printf("<type>dem</type>\n"); }
    //:  | "...dir" TEXT : 
  | GC3_DIR { printf("<type>dir</type>\n"); }
    //:  | "...enc" TEXT : 
  | GC3_ENC { printf("<type>enc</type>\n"); }
    //:  | "...exc" TEXT : 
  | GC3_EXC { printf("<type>exc</type>\n"); }
    //:  | "...i"   TEXT : 
  | GC3_I   { printf("<type>i</type>\n"); }
    //:  | "...ic"  TEXT : 
  | GC3_IC  { printf("<type>ic</type>\n"); }
    //:  | "...n"   TEXT : Noun
  | GC3_N   { printf("<type>n</type>\n"); }
    //:  | "...nc"  TEXT : 
  | GC3_NC  { printf("<type>nc</type>\n"); }
    //:  | "...ni"  TEXT : 
  | GC3_NI  { printf("<type>ni</type>\n"); }
    //:  | "...pad" TEXT : 
  | GC3_PAD { printf("<type>pad</type>\n"); }
    //:  | "...pf"  TEXT : 
  | GC3_PF  { printf("<type>pf</type>\n"); }
    //:  | "...pn"  TEXT : 
  | GC3_PN  { printf("<type>pn</type>\n"); }
    //:  | "...psn" TEXT : 
  | GC3_PSN { printf("<type>psn</type>\n"); }
    //:  | "...pp"  TEXT : 
  | GC3_PP  { printf("<type>pp</type>\n"); }
    //:  | "...prt" TEXT : 
  | GC3_PRT { printf("<type>prt</type>\n"); }
    //:  | "...ven" TEXT : 
  | GC3_VEN { printf("<type>ven</type>\n"); }
    //:  | "...voc" TEXT : 
  | GC3_VOC { printf("<type>voc</type>\n"); } ;
gc3:
                                  { printf("<gc3>\n"); }
  gc3.alt
  WORDS                           { printf("<word>%s</word>\n", $3); }
  //:  <dial> (0-to-1)
  dial.01
  //:  <gl> (exactly-1)
  gl
  //:  <lit> (0-to-1)
  lit.01
  //:  <cf> (0-to-1)
  cf.01
  //:  <sc> (0-to-1)
  sc.01
  //:  <ex> (0-to-many)
  exeng.0m
                                  { printf("</gc3>\n"); }
  ;

// ---------- .af ----------

//:<af> =
af:
//:  ".af" TEXT : Affix
  AF                              { printf("<af>\n"); }
  WORDS                           { printf("<word>%s</word>\n", $3); }
  //:  <pd> (0-to-1)
  pd.01
  //:  <tag> (0-to-1)
  tag.01
  //:  <rtyp> (0-to-1)
  rtyp.01
  //:  <af2> (0-to-1)
  af2.0alt
                                  { printf("</af>\n"); }
  ;

//:<af2> =
af2.0alt: %empty
   //:    <af2n> (1-to-many)
 | af2n.1m 
   //:  | <af2s> (1-to-many)
 | af2s.1m
   //:  | <af2v> (1-to-many)
 | af2v.1m 
   //:  | <af2t> (1-to-many)
 | af2t.1m 
   //:  | <af2d> (1-to-many)
 | af2d.1m 
   //:  | <af2a> (1-to-many)
 | af2a.1m ;
   //:  | <af2p> (1-to-many)
 | af2p.1m ;
af2n.1m: af2n | af2n af2n.1m ;
af2s.1m: af2s | af2s af2s.1m ;
af2v.1m: af2v | af2v af2v.1m ;
af2t.1m: af2t | af2t af2t.1m ;
af2d.1m: af2d | af2d af2d.1m ;
af2a.1m: af2a | af2a af2a.1m ;
af2p.1m: af2p | af2p af2p.1m ;

//:<af2n> =
af2n:
  //:  "..nsf" TEXT : Noun suffix
  AF2_NSF                { printf("<af2>\n"); } 
  WORDS                  { printf("<word>%s</word>\n<type>nsf</type>\n", $3); }
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
  //:  <af2n3> (0-to-many)
  af2n3.0m 
                         { printf("</af2>\n"); }
  ;

//:<af2n3> =
af2n3.0m: %empty | af2n3.0m af2n3 ;
af2n3.alt:
    //:    "...an" TEXT  : 
    GC3_AN  { printf("<type>an</type>\n"); }
    //:  | "...exc" TEXT   : 
  | GC3_EXC { printf("<type>exc</type>\n"); }
    //:  | "...n" TEXT   : 
  | GC3_N   { printf("<type>n</type>\n"); }
    //:  | "...pp" TEXT  : 
  | GC3_PP  { printf("<type>pp</type>\n"); }
    //:  | "...voc" TEXT : 
  | GC3_VOC { printf("<type>voc</type>\n"); } ;
af2n3:
                                  { printf("<af3>\n"); }
  af2n3.alt WORDS                 { printf("<word>%s</word>\n", $3); }
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
                                  { printf("</af3>\n"); }
  ;

//:<af2s> =
af2s:
  //:  "..sf" TEXT : Suffix
  AF2_SF                { printf("<af2>\n"); } 
  WORDS                  { printf("<word>%s</word>\n<type>sf</type>\n", $3); }
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
  //:  <af2s3> (0-to-many)
  af2s3.0m 
                         { printf("</af2>\n"); }
  ;

//:<af2s3> =
af2s3.0m: %empty | af2s3.0m af2s3 ;
af2s3.alt:
    //:    "...exc" TEXT   : 
    GC3_EXC { printf("<type>exc</type>\n"); } ;
af2s3:
                                  { printf("<af3>\n"); }
  af2s3.alt WORDS                 { printf("<word>%s</word>\n", $3); }
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
                                  { printf("</af3>\n"); }
  ;

//:<af2v> =
af2v.alt:
    //:    "..vpf" TEXT : Verb prefix
    AF2_VPF   { printf("<type>vpf</type>\n"); }
    //:  | "..vsf" TEXT : Verb suffix
  | AF2_VSF   { printf("<type>vsf</type>\n"); }
    //:  | "..vsf1" TEXT : Verb suffix one
  | AF2_VSF1  { printf("<type>vsf1</type>\n"); }
  ;
af2v:
  af2v.alt                { printf("<af2>\n"); } 
  WORDS                   { printf("<word>%s</word>\n", $3); }
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
  //:  <af2v3> (0-to-many)
  af2v3.0m 
                         { printf("</af2>\n"); }
  ;

//:<af2v3> =
af2v3.0m: %empty | af2v3.0m af2v3 ;
af2v3.alt:
    //:    "...adv" TEXT  : Adverb 
    GC3_ADV  { printf("<type>adv</type>\n"); }
    //:  | "...ifs" TEXT  : Inflectional string 
  | AF3_IFS { printf("<type>ifs</type>\n"); }
    //:  | "...drt" TEXT   : 
  | AF3_DRT   { printf("<type>drt</type>\n"); } ;
af2v3:
                                  { printf("<af3>\n"); }
  af2v3.alt WORDS                 { printf("<word>%s</word>\n", $3); }
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
                                  { printf("</af3>\n"); }
  ;

//:<af2t> =
af2t:
  //:  "..tfs" TEXT : Theme formation string
  AF2_TFS                { printf("<af2>\n"); } 
  WORDS                  { printf("<word>%s</word>\n<type>tfs</type>\n", $3); }
  //:  <asp> (0-to-1)
  asp.01
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
  //:  <th3> (0-to-many)
  th3.0m
                         { printf("</af2>\n"); }
  ;

//:<asp> =\n  "asp" TEXT : Aspect
asp.01: %empty | asp ;
asp: ASP WORDS { printf("<asp>%s</asp>\n", $2); } ;

//:<th2> =
th3.0m: %empty
  | th3.0m th3 ;
th3:                     { printf("<th3>\n");    }
  //:  "...th" TEXT : Verb theme
  TH3 WORDS              { printf("<word>%s</word>\n", $3); }
  //:  <tc> (exactly-1)
  TC tc.alt
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
                          { printf("</th3>\n"); } ;

//:<af2d> =
af2d:
  //:  "..nds" TEXT : Non-aspectual derivational string
  AF2_NDS                { printf("<af2>\n"); } 
  WORDS                  { printf("<word>%s</word>\n<type>nds</type>\n", $3); }
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
                         { printf("</af2>\n"); }
  ;

//:<af2a> =
af2a.alt:
    //:    "..ads" TEXT  : 
    AF2_ADS                   { printf("<type>ads</type>\n"); }
    //:  | "..sds" TEXT   : 
  | AF2_SDS                   { printf("<type>sds</type>\n"); } ;
af2a:
                                  { printf("<af2>\n"); }
  af2a.alt WORDS                  { printf("<word>%s</word>\n", $3); }
  //:  <asp> (exactly-1)
  asp
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
                                  { printf("</af2>\n"); }
  ;

//:<af2p> =
af2p.alt:
    //:    "..nfsf" TEXT  : 
    AF2_NFSF                   { printf("<type>nfsf</type>\n"); }
    //:  | "..vfsf" TEXT   : 
  | AF2_VFSF                    { printf("<type>vfsf</type>\n"); } 
    //:  | "..nfsf" TEXT  : 
  | AF2_NFPF                   { printf("<type>nfpf</type>\n"); }
    //:  | "..vfsf" TEXT   : 
  | AF2_VFPF                    { printf("<type>vfpf</type>\n"); } ;
af2p:
                                  { printf("<af2>\n"); }
  af2p.alt WORDS                  { printf("<word>%s</word>\n", $3); }
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
  //:  <af2p3> (0-to-many)
  af2p3.0m
                                  { printf("</af2>\n"); }
  ;

//:<af2p3> =
af2p3.0m: %empty | af2p3.0m af2p3 ;
af2p3:
                                  { printf("<af3>\n"); }
  //:  "...drt" TEXT   : 
  AF3_DRT WORDS       { printf("<word>%s</word>\n<type>drt</type>\n", $3); }
  //:  <gl> (exactly-1)
  gl
  //:  <ex> (0-to-many)
  exeng.0m
                                  { printf("</af3>\n"); }
  ;


/*
af2n3.0m: %empty | af2n3.0m af2n3 ;

af2n3: af3.o af2n3.b gl.01 exeng.0m af3.c ;
af3.o: %empty { printf("<af3>\n"); } ;
af2n3.b: AF2N3 WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };
af3.c: %empty { printf("</af3>\n"); } ;

// ---------- .af level 2 s ----------

af2s: af2.o af2s.b gl.01 exeng.0m af2s3.0m af2.c ;
af2s.b: AF2S WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };

af2s3.0m: %empty | af2s3.0m af2s3 ;

af2s3: af3.o af2s3.b gl.01 exeng.0m af3.c ;
af2s3.b: AF2S3 WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };

// ---------- .af level 2 n ----------

af2v: af2.o af2v.b gl.01 exeng.0m af2v3.0m af2.c ;
af2v.b: AF2V WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };

af2v3.0m: %empty | af2v3.0m af2v3 ;

af2v3: af3.o af2v3.b gl.01 exeng.0m af3.c ;
af2v3.b: AF2V3 WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };

*/

/* ifs.0m: %empty | ifs.0m ifs ;

ifs: ifs.o ifs.b dial.01 gl exeng.0m ifs.c ;
ifs.o: %empty { printf("<ifs>\n"); } ;
ifs.b: IFS WORDS { printf("<word>%s</word>\n", $2); };
ifs.c: %empty { printf("</ifs>\n"); } ;

af2b.0m: %empty | af2b.0m af2b ;

af2b: af2b.o af2b.b dial.01 asp.01 gl exeng.0m th.0m af2b.c ;
af2b.o: %empty { printf("<af2>\n"); } ;
af2b.b: AF2B WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };
af2b.c: %empty { printf("</af2>\n"); } ;

asp.01: %empty | asp.b ;

asp.b: ASP WORDS { printf("<asp>%s</asp>\n", $2); };

af2c.0m: %empty | af2c.0m af2c ;

af2c: af2c.o af2c.b dial.01 gl exeng.0m af2c.c ;
af2c.o: %empty { printf("<af2>\n"); } ;
af2c.b: AF2C WORDS { printf("<word>%s</word>\n<type>%s</type>\n", $2, $1); };
af2c.c: %empty { printf("</af2>\n"); } ;
*/


/*
lw:  lw.o lw.b lc.01 src.b lwl2.0m lw.c ;
lw.o: %empty { printf("<lw>\n"); } ;
lw.b: LW WORDS { printf("<word>%s</word>\n", $2); };
lw.c: %empty { printf("</lw>\n"); } ;
*/

%%

     // rt:  rt.o rt.b tag.b rt.c | rt.o rt.b tag.b n rt.c | rt.o error rt.c ;
