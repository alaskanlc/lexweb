%{
  /* Code includes */

#include <stdio.h>
#include "lw2xml.tab.h"

%}

 /* Options */
%option noyywrap yylineno

 /* Start-condition tokens ; note %x is the eXclusive form */
%x WHITE TEXT SETTYPE COMWHITE
%x COMTEXT DIALWHITE DIALWHITE2 DIALTEXT
%x TCWHITE TCTEXT TCTYPE

%%
 /* Regular expressions to match band labels */
 /* Order follows the symbolic grammar      */
 /* Conditional regexes placed at first reference */

 /* .rt */ 
^\.rt         { BEGIN(WHITE);   return RT;    }
<WHITE>[ ]+ { BEGIN(TEXT);                  }
 /* missing */
<WHITE>\ *\n {
  fprintf(stderr, "  L.%d: missing text\n",yylineno);
  BEGIN(INITIAL);
}
<TEXT>.+/\n {
 /* get rest of line  - note, regex does not include \n */
  yylval.str = strdup(yytext);
  BEGIN(INITIAL);  /* this moves over the \n */
  return WORDS;
}

 /* .rt attributes */
^pd\ +         { BEGIN(TEXT);    return PD;   }
^tag\ +        { BEGIN(TEXT);    return TAG;  }
^rtyp\ +       { BEGIN(TEXT);    return RTYP; }
^df\ +         { BEGIN(TEXT);    return DF;   }

 /* sets */
^\.\.sets\ *    {                  return SETS; }
^set\ +         { BEGIN(SETTYPE);  return SET;  }
<SETTYPE>{
  conc\ +  { BEGIN(TEXT); return ST_CONC ; }
  cns\ +   { BEGIN(TEXT); return ST_CNS  ; }
  cona\ +  { BEGIN(TEXT); return ST_CONA ; }
  cont\ +  { BEGIN(TEXT); return ST_CONT ; } 
  cust\ +  { BEGIN(TEXT); return ST_CUST ; }
  dist\ +  { BEGIN(TEXT); return ST_DIST ; }
  dur\ +   { BEGIN(TEXT); return ST_DUR  ; }
  mom\ +   { BEGIN(TEXT); return ST_MOM  ; }
  mult\ +  { BEGIN(TEXT); return ST_MULT ; }
  neu\ +   { BEGIN(TEXT); return ST_NEU  ; }
  per\ +   { BEGIN(TEXT); return ST_PER  ; }
  prog\ +  { BEGIN(TEXT); return ST_PROG ; }
  rep\ +   { BEGIN(TEXT); return ST_REP  ; }
  rev\ +   { BEGIN(TEXT); return ST_REV  ; }
  sem\ +   { BEGIN(TEXT); return ST_SEM  ; }
  tran\ +  { BEGIN(TEXT); return ST_TRAN ; }
}

 /* verb themes */
^\.\.\.?th\ +  { BEGIN(TEXT);    return TH;   }
^tc\ +         { BEGIN(TCTYPE);  return TC;   }
<TCTYPE>{
  clas\-mot/\n   { BEGIN(INITIAL);  return TC_CLASMOT  ; }
  clas\-stat/\n  { BEGIN(INITIAL); return TC_CLASSTAT ; }
  conv/\n        { BEGIN(INITIAL); return TC_CONV     ; }
  desc/\n        { BEGIN(INITIAL); return TC_DESC     ; }
  dim/\n         { BEGIN(INITIAL); return TC_DIM      ; }
  ext/\n         { BEGIN(INITIAL); return TC_EXT      ; }
  mot/\n         { BEGIN(INITIAL); return TC_MOT      ; }
  neu/\n         { BEGIN(INITIAL); return TC_NEU      ; }
  ono/\n         { BEGIN(INITIAL); return TC_ONO      ; }
  op/\n          { BEGIN(INITIAL); return TC_OP       ; }
  op\-ono/\n     { BEGIN(INITIAL); return TC_OPONO    ; }
  stat/\n        { BEGIN(INITIAL); return TC_STAT     ; }
  succ/\n        { BEGIN(INITIAL); return TC_SUCC     ; }
}

^cnj\ +         { BEGIN(TEXT);    return CNJ;   }

 /* gloss */
^gl\ +         { BEGIN(TEXT);    return GL;   }
^quo\ +        { BEGIN(TEXT);    return QUO;  }
^cit\ +        { BEGIN(TEXT);    return CIT;  }

 /* examples */
^ex\ +         { BEGIN(TEXT);    return EX;   }
^eng\ +        { BEGIN(TEXT);    return ENG;  }

  /* Paradigms sub-entry of theme */
^\.\.\.prds/\n {                  return PRDS; }
^prd\ +        { BEGIN(TEXT);    return PRD;  }
^prdgl\ +      { BEGIN(TEXT);    return PRDGL;}

 /* Level 2 Sub-entries for .rt */
^\.\.adj\ +    { BEGIN(TEXT) ; return GC2_ADJ ;}
^\.\.adv\ +    { BEGIN(TEXT) ; return GC2_ADV ;}
^\.\.an\ +     { BEGIN(TEXT) ; return GC2_AN  ;}
^\.\.c\ +      { BEGIN(TEXT) ; return GC2_C   ;}
^\.\.cnj\ +    { BEGIN(TEXT) ; return GC2_CNJ ;}
^\.\.dem\ +    { BEGIN(TEXT) ; return GC2_DEM ;}
^\.\.dir\ +    { BEGIN(TEXT) ; return GC2_DIR ;}
^\.\.enc\ +    { BEGIN(TEXT) ; return GC2_ENC ;}
^\.\.exc\ +    { BEGIN(TEXT) ; return GC2_EXC ;}
^\.\.i\ +      { BEGIN(TEXT) ; return GC2_I   ;}
^\.\.ic\ +     { BEGIN(TEXT) ; return GC2_IC  ;}
^\.\.n\ +      { BEGIN(TEXT) ; return GC2_N   ;}
^\.\.nc\ +     { BEGIN(TEXT) ; return GC2_NC  ;}
^\.\.ni\ +     { BEGIN(TEXT) ; return GC2_NI  ;}
^\.\.pad\ +    { BEGIN(TEXT) ; return GC2_PAD ;}
^\.\.pf\ +     { BEGIN(TEXT) ; return GC2_PF  ;}
^\.\.pn\ +     { BEGIN(TEXT) ; return GC2_PN  ;}
^\.\.psn\ +    { BEGIN(TEXT) ; return GC2_PSN ;}
^\.\.pp\ +     { BEGIN(TEXT) ; return GC2_PP  ;}
^\.\.prt\ +    { BEGIN(TEXT) ; return GC2_PRT ;}
^\.\.ven\ +    { BEGIN(TEXT) ; return GC2_VEN ;}
^\.\.voc\ +    { BEGIN(TEXT) ; return GC2_VOC ;}

 /* attributes for Level 2 Sub-entries for .rt */
^dial/\ +[^ \t\n]+\n          { BEGIN(WHITE);    return DIAL; }
^dial/\ +[^ \t\n]+\ +[^ \t\n][^\n]*\n  { BEGIN(DIALWHITE);return DIALX; } 
^lit        { BEGIN(WHITE);    return LIT;  }
^cf         { BEGIN(WHITE);    return CF;   }
^sc         { BEGIN(WHITE);    return SC;   }

 /* Level 3 Sub-entries for .rt */
^\.\.\.(adj|adv|an|c|cnj|dem|dir|enc|exc|i|ic|n|nc|ni|pad|pf|pn|psn|pp|prt|ven|voc) { BEGIN(WHITE); yylval.str = strdup(yytext); return GC3; }

 /* .af */
^\.af       { BEGIN(WHITE);    return AF;   }

  /* Sub-entries for .af, type A */
^\.\.(nsf|sf|vpf|vsf|vsf1) {
  BEGIN(WHITE);
  yylval.str = strdup(yytext);
  return AF2; }

 /* attributes for AF2A */ 
^\.\.\.ifs { BEGIN(WHITE);       return IFS; }

  /* Sub-entries for .af, type B */
^\.\.(ads|tfs|sds) {
  BEGIN(WHITE);
  yylval.str = strdup(yytext);
  return AF2B; }

^asp  { BEGIN(WHITE); return ASP; }

  /* Sub-entries for .af, type C */
^\.\.nds {
  BEGIN(WHITE);
  yylval.str = strdup(yytext);
  return AF2C; }

  /* Loan words */
^\.lw { BEGIN(WHITE); return LW; }
^src  { BEGIN(WHITE); return SRC; }
 /* Note overloading of GC2 terms */

  /* Comments - can be anywhere */
^(com|rcom) { BEGIN(COMWHITE); }

 /* ---------- Traps for other line types ---------- */

^(\.file|\.\.+par|\.dir|cf) { /* ignore for now */ BEGIN(INITIAL); }

^#.* { /* ignore comments */ BEGIN(INITIAL); }

^[^ \t\n]+ {
   fprintf(stderr, "  L.%d: unknown band label '%s'\n",yylineno,yytext);
   BEGIN(INITIAL); 
}

^[ \t]+[^ \t]+ {
   fprintf(stderr, "  L.%d: Leading spaces '%s'\n",yylineno,yytext);
   BEGIN(INITIAL); 
}

. { /* final alarm printf("  bad input character '%s'\n",yytext); */ }

\n                 { BEGIN(INITIAL);  }




 /* Now... get the post-band label delimiters */
<COMWHITE>[ \t]+   { BEGIN(COMTEXT); }
<DIALWHITE>[ \t]+  { BEGIN(DIALTEXT); }
<DIALWHITE2>[ \t]+ { BEGIN(TEXT); }

 /* Finally, get the rest of each line */


<COMTEXT>.+ { /* print out the comment - it can be anywhere in the xml */
  printf("<com>%s</com>\n",yytext); } 
<COMTEXT>\n { BEGIN(INITIAL); }


<DIALTEXT>[^ ]+ {
   yylval.str = strdup(yytext);
   BEGIN(DIALWHITE2);
   return DIALXLANG;
}



%%

// other options: debug nodefault reentrant

