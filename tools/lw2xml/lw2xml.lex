%{
  /* Code includes */

#include <stdio.h>
#include "lw2xml.tab.h"

%}

 /* Options */
%option noyywrap yylineno

 /* Start-condition tokens */
%x WHITE TEXT SETWHITE SETTEXT SETWHITE2 COMWHITE
%x COMTEXT DIALWHITE DIALWHITE2 DIALTEXT

%%
 /* Regular expressions to match band labels */
 /* Order follows the symbolic grammar      */
 /* Conditional regexes placed at first reference */

 /* .rt */ 
^\.rt       { BEGIN(WHITE);    return RT;   }
<WHITE>[ \t]+ { BEGIN(TEXT);                }
<TEXT>.+ {
 /* get rest of line */
  yylval.str = strdup(yytext);
  return WORDS;
}
 /* reset */ 
<TEXT>\n    { BEGIN(INITIAL);               }

 /* .rt attributes */
^pd         { BEGIN(WHITE);    return PD;   }
^tag        { BEGIN(WHITE);    return TAG;  }
^rtyp       { BEGIN(WHITE);    return RTYP; }
^df         { BEGIN(WHITE);    return DF;   }

 /* sets */
^\.\.sets   {                  return SETS; }
^set        { BEGIN(SETWHITE); return SET;  }
<SETWHITE>[ \t]+ { BEGIN(SETTEXT);          }
<SETTEXT>(conc|cns|cona|cont|cust|dist|dur|mom|mult|neu|per|prog|rep|rev|sem|tran)/\ + {
  /* grab the set type */
  yylval.str = strdup(yytext);
  BEGIN(SETWHITE2);
  return SETTYPE;
}
 /* type not listed */
<SETTEXT>[^ ]+ {
   fprintf(stderr, "  L.%d: unknown set type '%s'\n",yylineno,yytext);
   yylval.str = strdup(yytext);
   BEGIN(SETWHITE2);
   return SETTYPE;
}
<SETTEXT>\n { BEGIN(INITIAL); }
<SETWHITE2>[ \t]+  { BEGIN(TEXT);           }

 /* verb themes */
^\.\.\.?th  { BEGIN(WHITE);    return TH;   }
^tc         { BEGIN(WHITE);    return TC;   }

 /* gloss */
^gl         { BEGIN(WHITE);    return GL;   }

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
