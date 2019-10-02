%{
  /* Code includes */

#include <stdio.h>
#include "lw2xml.tab.h"

%}

 /* Options */
%option noyywrap yylineno

 /* Start-condition tokens ; note %x is the eXclusive form */
%x WHITE TEXT SETTYPE COMWHITE
%x COMTEXT DIALTEXT
%x TCTEXT TCTYPE PRDTYPE

%%
 /* Regular expressions to match band labels */
 /* Order follows the symbolic grammar      */
 /* Conditional regexes placed at first reference */

 /* .rt */ 
^\.rt\ +         { BEGIN(TEXT);   return RT;    }
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
^\.\.th\ +  { BEGIN(TEXT);    return TH;   }
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
^prd\ +        { BEGIN(PRDTYPE);  return PRD;  }
^prdgl\ +      { BEGIN(TEXT);     return PRDGL;}
<PRDTYPE>{
  1s\ +        { BEGIN(TEXT); return PD_1S ; }
  2s\ +        { BEGIN(TEXT); return PD_2S ; }
  3s\ +        { BEGIN(TEXT); return PD_3S ; }
  1p\ +        { BEGIN(TEXT); return PD_1P ; }
  2p\ +        { BEGIN(TEXT); return PD_2P ; }
  3p\ +        { BEGIN(TEXT); return PD_3P ; }
  1d\ +        { BEGIN(TEXT); return PD_1D ; }
  2d\ +        { BEGIN(TEXT); return PD_2D ; }
  3d\ +        { BEGIN(TEXT); return PD_3D ; }
}

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

^dial\ +/[^ \t\n]+\n                   { BEGIN(TEXT);     return DIAL;  }
^dial\ +/[^ \t\n]+\ +[^ \t\n][^\n]*\n  { BEGIN(DIALTEXT); return DIALX; } 
<DIALTEXT>[^ ]+ {
   yylval.str = strdup(yytext);
   BEGIN(TEXT);
   return DIALXLANG;
}

^lit\ +        { BEGIN(TEXT);    return LIT;  }
^cf\ +         { BEGIN(TEXT);    return CF;   }
^sc\ +         { BEGIN(TEXT);    return SC;   }

 /* Level 3 Sub-entries for .rt */
^\.\.\.adj\ +    { BEGIN(TEXT) ; return GC3_ADJ ;}
^\.\.\.adv\ +    { BEGIN(TEXT) ; return GC3_ADV ;}
^\.\.\.an\ +     { BEGIN(TEXT) ; return GC3_AN  ;}
^\.\.\.c\ +      { BEGIN(TEXT) ; return GC3_C   ;}
^\.\.\.cnj\ +    { BEGIN(TEXT) ; return GC3_CNJ ;}
^\.\.\.dem\ +    { BEGIN(TEXT) ; return GC3_DEM ;}
^\.\.\.dir\ +    { BEGIN(TEXT) ; return GC3_DIR ;}
^\.\.\.enc\ +    { BEGIN(TEXT) ; return GC3_ENC ;}
^\.\.\.exc\ +    { BEGIN(TEXT) ; return GC3_EXC ;}
^\.\.\.i\ +      { BEGIN(TEXT) ; return GC3_I   ;}
^\.\.\.ic\ +     { BEGIN(TEXT) ; return GC3_IC  ;}
^\.\.\.n\ +      { BEGIN(TEXT) ; return GC3_N   ;}
^\.\.\.nc\ +     { BEGIN(TEXT) ; return GC3_NC  ;}
^\.\.\.ni\ +     { BEGIN(TEXT) ; return GC3_NI  ;}
^\.\.\.pad\ +    { BEGIN(TEXT) ; return GC3_PAD ;}
^\.\.\.pf\ +     { BEGIN(TEXT) ; return GC3_PF  ;}
^\.\.\.pn\ +     { BEGIN(TEXT) ; return GC3_PN  ;}
^\.\.\.psn\ +    { BEGIN(TEXT) ; return GC3_PSN ;}
^\.\.\.pp\ +     { BEGIN(TEXT) ; return GC3_PP  ;}
^\.\.\.prt\ +    { BEGIN(TEXT) ; return GC3_PRT ;}
^\.\.\.ven\ +    { BEGIN(TEXT) ; return GC3_VEN ;}
^\.\.\.voc\ +    { BEGIN(TEXT) ; return GC3_VOC ;}

 /* .af */
^\.af\ +       { BEGIN(TEXT);    return AF;   }

^\.\.nsf\ +    { BEGIN(TEXT);    return AF2_NSF;   }
^\.\.sf\ +     { BEGIN(TEXT);    return AF2_SF;    }
^\.\.vpf\ +    { BEGIN(TEXT);    return AF2_VPF;   }
^\.\.vsf\ +    { BEGIN(TEXT);    return AF2_VSF;   }
^\.\.vsf1\ +    { BEGIN(TEXT);    return AF2_VSF1;   }

^\.\.\.ifs\ +    { BEGIN(TEXT) ; return AF3_IFS ;}
^\.\.\.drt\ +    { BEGIN(TEXT) ; return AF3_DRT ;}

^\.\.tfs\ +    { BEGIN(TEXT);    return AF2_TFS;   }
^asp\ +        { BEGIN(TEXT); return ASP;     }
^\.\.\.th\ +   { BEGIN(TEXT);    return TH3;   }

^\.\.nds\ +    { BEGIN(TEXT);    return AF2_NDS;   }
^\.\.ads\ +    { BEGIN(TEXT);    return AF2_ADS;   }
^\.\.sds\ +    { BEGIN(TEXT);    return AF2_SDS;   }

^\.\.nfsf\ +    { BEGIN(TEXT);    return AF2_NFSF;   }
^\.\.vfsf\ +    { BEGIN(TEXT);    return AF2_VFSF;   }
^\.\.nfpf\ +    { BEGIN(TEXT);    return AF2_NFPF;   }
^\.\.vfpf\ +    { BEGIN(TEXT);    return AF2_VFPF;   }


 /*   /\* Sub-entries for .af, type A *\/ */
 /* ^\.\.(nsf|sf|vpf|vsf|vsf1) { */
 /*   BEGIN(WHITE); */
 /*   yylval.str = strdup(yytext); */
 /*   return AF2; } */

 /*  /\* attributes for AF2A *\/  */
 /* ^\.\.\.ifs { BEGIN(WHITE);       return IFS; } */

 /*   /\* Sub-entries for .af, type B *\/ */
 /* ^\.\.(ads|tfs|sds) { */
 /*   BEGIN(WHITE); */
 /*   yylval.str = strdup(yytext); */
 /*   return AF2B; } */


 /*   /\* Sub-entries for .af, type C *\/ */
 /* ^\.\.nds { */
 /*   BEGIN(WHITE); */
 /*   yylval.str = strdup(yytext); */
 /*   return AF2C; } */

 /*   /\* Loan words *\/ */
 /* ^\.lw { BEGIN(WHITE); return LW; } */
 /* ^src  { BEGIN(WHITE); return SRC; } */
 /*  /\* Note overloading of GC2 terms *\/ */

  /* Comments - can be anywhere */
^(com|rcom)\ + { BEGIN(COMTEXT); }
<COMTEXT>.+/\n {
  /* print out the comment - it can be anywhere in the xml */
  printf("<com>%s</com>\n",yytext);
  BEGIN(INITIAL);} 




 /* ---------- Traps for other line types ---------- */

^(\.file|\.\.+par|\.dir) { /* ignore for now */ BEGIN(INITIAL); }

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

 /* Finally, get the rest of each line */


<COMTEXT>.+ { /* print out the comment - it can be anywhere in the xml */
  printf("<com>%s</com>\n",yytext); } 
<COMTEXT>\n { BEGIN(INITIAL); }





%%

// other options: debug nodefault reentrant

