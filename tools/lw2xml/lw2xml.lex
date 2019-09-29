%{
  /* Code includes */

#include <stdio.h>
#include "lw2xml.tab.h"

%}

 /* Options */
%option noyywrap yylineno

 /* Start-condition tokens ; note %x is the eXclusive form */
%x WHITE TEXT SETWHITE SETTYPE SETWHITE2 COMWHITE
%x COMTEXT DIALWHITE DIALWHITE2 DIALTEXT
%x TCWHITE TCTEXT

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
^pd/\ +         { BEGIN(WHITE);    return PD;   }
^tag/\ +        { BEGIN(WHITE);    return TAG;  }
^rtyp/\ +       { BEGIN(WHITE);    return RTYP; }
^df/\ +         { BEGIN(WHITE);    return DF;   }

 /* sets */
^\.\.sets[ ]*   {                  return SETS; }
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



 /*  /\* type not listed *\/ */
 /* <SETTEXT>[^ ]+ { */
 /*    fprintf(stderr, "  L.%d: unknown set type '%s'\n",yylineno,yytext); */
 /*    yylval.str = strdup(yytext); */
 /*    BEGIN(SETWHITE2); */
 /*    return SETTYPE; */
 /* } */
 /* <SETTEXT>\n { BEGIN(INITIAL); } */
 /* <SETWHITE2>[ \t]+  { BEGIN(TEXT);           } */

 /* verb themes */
^\.\.\.?th  { BEGIN(WHITE);    return TH;   }
^tc         { BEGIN(TCWHITE);  return TC;   }
<TCWHITE>[ \t]+ { BEGIN(TCTEXT);            }
 /* missing */ 
<TCWHITE>\ *\n {
  fprintf(stderr, "  L.%d: missing set type\n",yylineno);
  BEGIN(INITIAL);
}
<TCTEXT>(clas\-mot|clas\-stat|conv|desc|dim|ext|mot|neu|ono|op|op\-ono|stat|succ)/\n {
  /* grab the set type */
  yylval.str = strdup(yytext);
  BEGIN(INITIAL);
  return TCTYPE;
}
 /* type not listed */
<TCTEXT>[^ ]+/\n {
    fprintf(stderr, "  L.%d: unknown tc type '%s'\n",yylineno,yytext);
    yylval.str = strdup(yytext);
    BEGIN(INITIAL);
    return TCTYPE;
}
 /* missing */ 
<TCTEXT>\n {
  fprintf(stderr, "  L.%d: missing set type\n",yylineno);
  BEGIN(INITIAL);
}

 /* conj */
^cnj         { BEGIN(WHITE);    return CNJ;   }


 /* gloss */
^gl         { BEGIN(WHITE);    return GL;   }
^quo        { BEGIN(WHITE);    return QUO;  }
^cit        { BEGIN(WHITE);    return CIT;  }

 /* examples */
^ex         { BEGIN(WHITE);    return EX;   }
^eng        { BEGIN(WHITE);    return ENG;  }

  /* Paradigms sub-entry of theme */
^\.\.\.prds {                  return PRDS; }
^prd        { BEGIN(WHITE);    return PRD;  }
^prdgl      { BEGIN(WHITE);    return PRDGL;}

 /* Level 2 Sub-entries for .rt */
^\.\.(adj|adv|an|c|cnj|dem|dir|enc|exc|i|ic|n|nc|ni|pad|pf|pn|psn|pp|prt|ven|voc)  { BEGIN(WHITE); yylval.str = strdup(yytext); return GC2; }

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

