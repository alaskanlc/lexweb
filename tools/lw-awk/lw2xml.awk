
# Variable naming convention: Global variables begin with a Capital letter,
#   local variables with a lowercase letter

# XHTML Document structure
# 
# XML schema choices made to reflect blocking choice in html document:
#
# rt  pd  tag  rtyp                   <-- rtattr
#   set                               <-- sets/set
#   set ...
#   th  tc  gl                        <-- thattr
#     ex eng ; ex eng ; ex eng ...    <-- exengs
#   th ...
#   prds
#     prd
#     exengs
#   gc2  gl ex eng ; ex eng ...       <-- gc2attr   gc2exengs
#     gc3  gl ex eng ;                <-- gc3_attr   gc3_exengs
#
#   doc
#   doc/rt
#   doc/rt/rtattr/{rtword tag pd nav...}
#   doc/rt/sets
#   doc/rt/sets/set
#   doc/rt/th
#   doc/rt/th/thattr/{thword tc cnj gl}
#   doc/rt/th/thexengs/exeng/{ex eng}
#   doc/rt/th/prds
#   doc/rt/th/prds/prd
#   doc/rt/th/prds/prd/prdgl
#   doc/rt/th/prds/prdsexengs
#
# If a block may need to be formatted independently, it needs a unique id
#   e.g., prds_exengs, but if it will always be the same, the id can be
#   reused in different contexts (e.g., exeng)

BEGIN{

  VALIDATE = 1
  DEBUG = 0

  PROCINFO["sorted_in"] = "@ind_str_asc"

  init()


  # Initialize Path and Prevbc (previous band class)
  Prevbc = "0"
  # start the xhtml output
  head("Dictionary")
  Path = ""
  o("doc")
}

# For each non-empty and non-comment line...
($0) && $0 !~ /^[ #]/  {

  # clean before processing
  cleanindexmarks()
  xmlencode()
  
  if (DEBUG) {
    print Path
    print $0
  }

  splitline()

  # ** Validation **
  if (VALIDATE)
    validate()
  
  # ** Conversion to xhtml **
  if (Bc == "rt") {
    c("doc")
    o("rt")
    oc("rttype", substr(Bl,2))
    o("rtattr")
    oc("rtword", Rest1)
  }
  
  else if (Bc == "pd") {
    c("doc/rt/rtattr")
    oc("pd", ("/" Rest1 "/"))
  }
  
  else if (Bc == "tag") {
    c("doc/rt/rtattr")
    oc("tag", Rest1)
  }
  
  else if (Bc == "rtyp") {
    c("doc/rt/rtattr")
    oc("rtyp", Rest1)
  }
  
  else if (Bc == "nav") {
    c("doc/rt/rtattr")
    oc("nav", Rest1)
  }
  
  else if (Bc == "df") {
    c("doc/rt/rtattr")
    oc("df", Rest1)
  }
  
  else if (Bc == "sets") {
    c("doc/rt")
    o("sets")
  }
  
  else if (Bc == "set") {
    c("doc/rt/sets")
    o("set")
    if (!Aspcat[Word2])
      error(Word2 " not a known aspectual category")
    oc("setasp", Word2)
    oc("setwords", Rest2)
    c("doc/rt/sets")
  }
  
  else if (Bc == "th") {
    c("doc/rt")
    o("th")
    o("thattr")
    oc("thword", Rest1)
  }
  
  else if (Bc == "tc") {
    c("doc/rt/th/thattr")
    oc("tc", Rest1)
  }
  
  else if (Bc == "cnj") {
    c("doc/rt/th/thattr")
    oc("cnj", Rest1)
  }
  
  else if ((Bc == "gl") && (Path ~ /\/thattr/)) {
    c("doc/rt/th/thattr")
    oc("thgl", Rest1)
  }

  else if ((Bc == "quo") && (Path ~ /\/thattr/)) {
    c("doc/rt/th/thattr")
    oc("quo", Rest1)
  }

  else if ((Bc == "cit") && (Path ~ /\/thattr/)) {
    c("doc/rt/th/thattr")
    oc("cit", Rest1)
  }
  
  else if ((Bc == "ex") && (Path ~ /\/th/)) {
    # first one
    if (Path !~ /exengs/) {
      c("doc/rt/th")
      o("thexengs")
      o("exeng")
      oc("ex", Rest1)
      oc("excolon", ": ")
    }
    else {
      c("doc/rt/th/thexengs")
      o("exeng")
      oc("ex", Rest1)
      oc("excolon", ": ")
    }
  }
  
  else if ((Bc == "eng") && (Path ~ "doc/rt/th")) {
    c("doc/rt/th/thexengs/exeng")
    oc("eng", Rest1)
    oc("exsemicolon", "; ")
  }

  else if ((Bc == "lit") && (Path ~ /\/thexengs/)) {
    c("doc/rt/th/thexengs/exeng")
    oc("lit", Rest1)
  }
  else if ((Bc == "quo") && (Path ~ /\/thexengs/)) {
    c("doc/rt/th/thexengs/exeng")
    oc("quo", Rest1)
  }
  else if ((Bc == "cit") && (Path ~ /\/thexengs/)) {
    c("doc/rt/th/thexengs/exeng")
    oc("cit", Rest1)
  }

  else if (Bc == "prds") {
    c("doc/rt/th")
    o("prds")
    oc("prdstype", Word2)
    oc("prdsdef", Rest2)
  }

  else if (Bc == "prd") {
    c("doc/rt/th/prds")
    o("prd")
    oc("prdpers", Word2)
    oc("prdwords", Rest2)
  }

  else if (Bc == "prdgl") {
    c("doc/rt/th/prds/prd")
    oc("prdgl", Rest1)
  }
  
  else if (Bc == "gc2") {
    c("doc/rt")
    o("gc2")
    o("gc2attr")
    oc("gc2word", Rest1)
    oc("gc2type", "(" abbrev(Bl) ")")
  }
  
  else if ((Bc == "dial") && (Path !~ /dials/)) {
    # first dial
    c("doc/rt/gc2/gc2attr")
    o("dials")
    oc("dial", Rest1)
  }

  else if ((Bc == "dial") && (Path ~ /dials/)) {
    # not first dial
    c("doc/rt/gc2/gc2attr/dials")
    o("dialx")
    oc("dialcomma", ",")
    oc("dial", Word2)
    oc("dialcolon", ":")
    oc("dialword", Rest2)
    c("doc/rt/gc2/gc2attr/dials")
  }

  else if ((Bc == "gl") && (Path ~ /gc2/)) {
    c("doc/rt/gc2/gc2attr")
    oc("gc2gl", Rest1)
  }
  
  else if ((Bc == "ex") && (Path ~ "doc/rt/gc2")) {
    # first one
    if (Path !~ "exengs") {
      c("doc/rt/gc2")
      o("gc2exengs")
      o("exeng")
      oc("ex", Rest1)
      oc("excolon", ": ")
    }
    else {
      c("doc/rt/gc2/gc2exengs")
      o("exeng")
      oc("ex", Rest1)
      oc("excolon", ": ")
    }
  }
  
  else if ((Bc == "eng") && (Path ~ "doc/rt/gc2")) {
    c("doc/rt/gc2/gc2exengs/exeng")
    oc("eng", Rest1)
    oc("exsemicolon", "; ")
  }

  # Move Bc to Prevbc
  Prevbc = Bc
}


END{
  c("doc")
  # close doc itself
  print "</div>"
  foot()
}

function init(     load, x, y, i, j, k, z, fol) {
  # Initialize
  
  # ** Load the syntax **
  # fol[A][B] are bands allowed to follow band B, in the context of A
  #   A is needed, because whether a band can follow A depends on the context
  #   of B. E.g., nav (as a member of attr1) can be followed by df, sets
  #   th, gc2, or a new root. A is the exit Path of B.

  #   Occurrences:            ?   ?   ?    ?  ?   ?   <+  *  * 
  fol["doc"   ]["0"   ] = "rt                                       lw"
  fol["rtattr"]["rt"  ] = "   pd tag rtyp nav df sets     th gc2 rt lw"
  fol["rtattr"]["pd"  ] = "      tag rtyp nav df sets     th gc2 rt lw"
  fol["rtattr"]["tag" ] = "          rtyp nav df sets     th gc2 rt lw"
  fol["rtattr"]["rtyp"] = "               nav df sets     th gc2 rt lw"
  fol["rtattr"]["nav" ] = "                   df sets     th gc2 rt lw"
  fol["rtattr"]["df"  ] = "                      sets     th gc2 rt lw"
  fol["sets"  ]["sets"] = "                           set             "
  fol["sets"  ]["set" ] = "                           set th gc2 rt lw"

  #                          1  ?  1  ?    ?  *   <1  ?   ?   ?   ?    <1  ?    *   *
  fol["thattr"]["th"   ] = "tc                                                           "
  fol["thattr"]["tc"   ] = "   cnj gl                                                    "
  fol["thattr"]["cnj"  ] = "       gl                                                    "
  fol["thattr"]["gl"   ] = "          quo cit ex                 prds           gc2 rt lw"
  fol["thattr"]["quo"  ] = "              cit ex                 prds           gc2 rt lw"
  fol["thattr"]["cit"  ] = "                  ex                 prds           gc2 rt lw"
  fol["exeng" ]["ex"   ] = "                     eng                                     "
  fol["exeng" ]["eng"  ] = "                  ex     lit quo cit prds           gc2 rt lw"
  fol["exeng" ]["lit"  ] = "                  ex         quo cit prds           gc2 rt lw"
  fol["exeng" ]["quo"  ] = "                  ex             cit prds           gc2 rt lw"
  fol["exeng" ]["cit"  ] = "                  ex                 prds           gc2 rt lw"
  fol["prds"  ]["prds" ] = "                                          prd                "
  fol["prd"   ]["prd"  ] = "                                          prd prdgl          "
  fol["prd"   ]["prdgl"] = "                                     prds prd       gc2 rt lw"

  #                           ?   1   * <1   *
  fol["gc2attr"]["gc2" ] = "dial gl            "
  fol["dials"  ]["dial"] = "dial gl            "
  fol["gc2attr"]["gl"  ] = "        ex     gc2 rt lw"

  # make F array from fol
  for (i in fol)
    for (j in fol[i]) {
      gsub(/^ +/,"",fol[i][j])
      gsub(/ +$/,"",fol[i][i])
      split(fol[i][j], z, / +/)
      for (k in z)
        F[i][j][z[k]] = 1
    }

  # Band labels to band classes
  load = \
    ".rt rt; .af rt; .ra rt; .lw lw; "                              \
    "tag tag; rtyp rtyp; nav nav; df df; "                          \
    "..sets sets; set set; "                                        \
    "..th th; tc tc; cnj cnj; gl gl; quo quo; cit cit;"             \
    "ex ex; eng eng; lit lit;"                                      \
    "...prds prds; prd prd; prdgl prdgl; "                          \
    "dial dial; "                                                   \
                                                                    \
    "..adj  gc2  adj.;   "                                              \
    "..ads  gc2  a.d.s.; "                                              \
    "..adv  gc2  adv.;   "                                              \
    "..an   gc2  a.n.;   "                                              \
    "..c    gc2  c.;     "                                              \
    "..cnj  gc2  cnj.;   "                                              \
    "..coll gc2  coll.;  "                                              \
    "..dem  gc2  dem.;   "                                              \
    "..dir  gc2  dir.;   "                                              \
    "..enc  gc2  enc.;   "                                              \
    "..exc  gc2  exc.;   "                                              \
    "..i    gc2  i.;     "                                              \
    "..ic   gc2  i.c.;   "                                              \
    "..in   gc2  ins.n.; "                                              \
    "..int  gc2  int.;   "                                              \
    "..mpn  gc2  m.p.n.; "                                              \
    "..n    gc2  n.;     "                                              \
    "..nc   gc2  n.c.;   "                                              \
    "..nds  gc2  n.d.s;  "                                              \
    "..nenc gc2  n.enc.; "                                              \
    "..nfaf gc2  n.f.af.;"                                              \
    "..nfsf gc2  n.f.sf.;"                                              \
    "..ni   gc2  n.i.;   "                                              \
    "..nic  gc2  n.i.c.; "                                              \
    "..nsf  gc2  n.sf.;  "                                              \
    "..padj gc2  p.adj.; "                                              \
    "..pf   gc2  pf.;    "                                              \
    "..pn   gc2  p.n.;   "                                              \
    "..pp   gc2  pp.;    "                                              \
    "..pro  gc2  pro.;   "                                              \
    "..psn  gc2  ps.n.;  "                                              \
    "..scnj gc2  s.cnj.; "                                              \
    "..sf   gc2  sf.;    "                                              \
    "..tfs  gc2  t.f.s.; "                                              \
    "..venc gc2  v.enc.; "                                              \
    "..vfaf gc2  v.f.af.;"                                              \
    "..vfsf gc2  v.f.sf.;"                                              \
    "..voc  gc2  voc.;   "                                              \
    "..vpf  gc2  v.pf.;  "                                              \
    "..vsf  gc2  v.sf.;  "                                              \
    "..vsf1 gc2  v.sf.1; "                                              \
                                                                        \
    "...adj  gc3  adj.;   "                                             \
    "...ads  gc3  a.d.s.; "                                             \
    "...adv  gc3  adv.;   "                                             \
    "...an   gc3  a.n.;   "                                             \
    "...c    gc3  c.;     "                                             \
    "...cnj  gc3  cnj.;   "                                             \
    "...coll gc3  coll.;  "                                             \
    "...dem  gc3  dem.;   "                                             \
    "...dir  gc3  dir.;   "                                             \
    "...enc  gc3  enc.;   "                                              \
    "...exc  gc3  exc.;   "                                              \
    "...i    gc3  i.;     "                                              \
    "...ic   gc3  i.c.;   "                                              \
    "...ifs  gc3  i.f.s.; "                                             \
    "...in   gc3  ins.n.; "                                              \
    "...int  gc3  int.;   "                                              \
    "...mpn  gc3  m.p.n.; "                                              \
    "...n    gc3  n.;     "                                              \
    "...nc   gc3  n.c.;   "                                              \
    "...nds  gc3  n.d.s;  "                                              \
    "...nenc gc3  n.enc.; "                                              \
    "...ni   gc3  n.i.;   "                                              \
    "...nic  gc3  n.i.c.; "                                              \
    "...padj gc3  p.adj.; "                                              \
    "...pf   gc3  pf.;    "                                              \
    "...pn   gc3  p.n.;   "                                              \
    "...pp   gc3  pp.;    "                                              \
    "...pro  gc3  pro.;   "                                              \
    "...psn  gc3  ps.n.;  "                                              \
    "...scnj gc3  s.cnj.; "                                              \
    "...sf   gc3  sf.;    "                                              \
    "...venc gc3  v.enc.; "                                              \
    "...voc  gc3  voc."                                                 \
  
  split(load, x, ";")
  for (i in x) {
    gsub(/^ +/,"",x[i])
    split(x[i], y)
    Bl2bc[y[1]] = y[2]
    if (y[3])
      Abbrev[y[1]] = y[3]
  }

  # Allowed aspectual cats
  load = "conc|cns|cona|cont|cust|dist|dur|durØ|durD|mom|mult|neu|per|"\
    "prog|rep|rev|sem|tran"
  split(load, x, "|")
  for (i in x)
    Aspcat[x[i]] = 1
}

function o (class) {
  # open a div
  print "<div class=\"" class "\">"
  if (Path) 
    Path = Path "/" class
  else Path = class
}

function oc (class, text) {
  # open and close a div 
  print "<div class=\"" class "\">" text "</div>"
}

function c(p,     oldlevel, newlevel, z, i) {
  # "close the hierarchy n levels to the new path indicated in p"
  oldlevel = split(Path, z, "/")
  newlevel = split(p, z, "/")
  for (i = 1; i <= (oldlevel - newlevel); i++)
    print "</div>" # <!-- " i "-->
  Path = p
}

function splitline (     n, z, i) {
  Bl = Bc = Word2 = Rest1 = Rest2
  gsub(/ +$/,"",$0)
  n = split($0, z)
  Bl = z[1]
  Bc = Bl2bc[Bl]
  Word2 = z[2]
  Rest1 = z[2]
  for (i = 3; i <= n; i++) Rest1 = Rest1 " " z[i]
  Rest2 = z[3]
  for (i = 4; i <= n; i++) Rest2 = Rest2 " " z[i]
}

# function word2(text,  x) {
#   x = gensub(/^([^ ]+) +([^ ]+).*$/,"\\2","G",text)
#   if (x == text) error("No second word in '" text "'")
#   else return x
# }

function head(title) {
  
  # Use html5
  print "<!DOCTYPE html>"
  print "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
  print "<head><title>" title "</title>"
  print "<meta http-equiv=\"Content-Type\" content=\"text/html; " \
           "charset=utf-8\" />"
  print "<link rel=\"stylesheet\" href=\"lw.css\"/>"
  # print "<link href=\"https://fonts.googleapis.com/css?family=Montserrat\" " \
  #         "rel=\"stylesheet\"/>"
  # print "<link href=\"../img/akflora.ico\" rel=\"shortcut icon\"  \
  #         type=\"image/x-icon\"/>"
  print "</head>\n<body>"
}


function foot() {
  print "</body>\n</html>";
}


function abbrev(bl) {
  if (!Abbrev[bl]) {
    printf "%5d: '%s' has no abbreviation\n", NR, bl > "/dev/stderr"
    return bl
  }
  else
    return Abbrev[bl]
}

function validate(   z, n) {

  # find the context from the tail element of Path
  n = split(Path, z, "/")
  # if the current band class cannot follow the previous band class in the
  #   current context, write an error
  if (!F[z[n]][Prevbc][Bc])
    error("'" Bc "' cannot follow '" Prevbc"'")
}

function error(msg) {
  printf "%5d: %s\n", NR, msg > "/dev/stderr"
}

function xmlencode() {
  gsub(/&/,"\\&amp;",$0)
  gsub(/</,"\\&lt;", $0)
  gsub(/>/,"\\&gt;", $0)
}

function   cleanindexmarks() {
  gsub(/\*/,"",$0)
  gsub(/\]/,"", $0)
}
