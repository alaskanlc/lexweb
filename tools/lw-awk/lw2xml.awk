
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

  # Load the band label to band class array
  bl2bc()
  # Load the abbreviation codes for grammatical categories
  abbrevs()
  
  # # # create new contexts, needed for variation in 
  # ncA = "..sets ..th ex ...prds " rA " " gc2A  
  
  rA  = "rt af ra lw"    # root alternatives

  # ** Load the syntax **
  # fol[A][B] are bands allowed to follow band B, in the context of A
  #   A is needed, because whether a band can follow A depends on the context
  #   of B. E.g., nav (as a member of attr1) can be followed by df, sets
  #   th, gc2, or a new root. A is the exit Path of B.

  #   Occurrences:          ?   ?   ?    ?  ?    ?  <+  *  *     *
  fol["doc"   ]["0"   ] = "rt                                      "
  fol["rtattr"]["rt"  ] = "     pd tag rtyp nav df sets     th gc2 " rA
  fol["rtattr"]["pd"  ] = "        tag rtyp nav df sets     th gc2 " rA
  fol["rtattr"]["tag" ] = "            rtyp nav df sets     th gc2 " rA
  fol["rtattr"]["rtyp"] = "                 nav df sets     th gc2 " rA
  fol["rtattr"]["nav" ] = "                     df sets     th gc2 " rA
  fol["rtattr"]["df"  ] = "                        sets     th gc2 " rA
  fol["sets"  ]["sets"] = "                             set        "
  fol["sets"  ]["set" ] = "                             set th gc2 " rA

  #                          1  ?  1  *  <1   ?    +   <1   *     *
  fol["thattr"]["th"   ] = "tc                                  "
  fol["thattr"]["tc"   ] = "   cnj gl                           "
  fol["thattr"]["cnj"  ] = "       gl                           "
  fol["thattr"]["gl"   ] = "          ex     prds           gc2 " rA
  fol["exeng" ]["ex"   ] = "             eng                    "
  fol["exeng" ]["eng"  ] = "          ex     prds           gc2 " rA
  fol["prds"  ]["prds" ] = "                      prd           "
  fol["prd"   ]["prd"  ] = "                      prd prdgl     "
  fol["prd"   ]["prdgl"] = "                 prds prd       gc2 " rA

  #                           ?   1   * <1   *
  fol["gc2attr"]["gc2" ] = "dial gl            "
  fol["gc2attr"]["dial"] = "     gl            "
  fol["gc2attr"]["gl"  ] = "        ex     gc2 " rA

  # make f array from fol
  for (i in fol)
    for (j in fol[i]) {
      gsub(/^ +/,"",fol[i][j])
      gsub(/ +$/,"",fol[i][i])
      split(fol[i][j], z, / +/)
      for (k in z)
        f[i][j][z[k]] = 1
    }

  if (DEBUG) {
    for (i in f)
      for (j in f[i])
        for (k in f[i][j])
          print i, j, k
  
    for (i in fol)
      print i ": " gensub(/ +/," ","G",fol[i])
  }

  # Initialize Path and Prevbc (previous band class)
  Prevbc = "0"
  # start the xhtml output
  head("Dictionary")
  Path = ""
  divo("doc")
}

# For each non-empty and non-comment line...
($0) && $0 !~ /^[ #]/  {

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
    # 1 reset hierarcy before new info
    divc("doc")
    # 2. down one, if needed
    divo("rt")
    divo("rtattr")
    # 3. down-up, make data
    divoc("rtword", Rest1)
    # 4. exit Path
    Path = "doc/rt/rtattr"
  }
  
  else if (Bc == "pd") {
    # 1 reset hierarcy before new info
    divc("doc/rt/rtattr")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("pd", ("/" Rest1 "/"))
    # 4. exit Path
    Path = "doc/rt/rtattr"
  }
  
  else if (Bc == "tag") {
    # 1 reset hierarcy before new info
    divc("doc/rt/rtattr")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("tag", Rest1)
    # 4. exit Path
    Path = "doc/rt/rtattr"
  }
  
  else if (Bc == "rtyp") {
    # 1 reset hierarcy before new info
    divc("doc/rt/rtattr")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("rtyp", Rest1)
    # 4. exit Path
    Path = "doc/rt/rtattr"
  }
  
  else if (Bc == "nav") {
    # 1 reset hierarcy before new info
    divc("doc/rt/rtattr")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("nav", Rest1)
    # 4. exit Path
    Path = "doc/rt/rtattr"
  }
  
  else if (Bc == "df") {
    # 1 reset hierarcy before new info
    divc("doc/rt/rtattr")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("df", Rest1)
    # 4. exit Path
    Path = "doc/rt/rtattr"
  }
  
  else if (Bc == "sets") {
    # 1 reset hierarcy before new info
    divc("doc/rt")
    # 2. down one, if needed
    divo("sets")
    # 3. down-up, make data
    # 4. exit Path
    # divc("doc/rt")
    Path = "doc/rt/sets"
  }
  
  else if (Bc == "set") {
    # 1 reset hierarcy before new info
    divc("doc/rt/sets")
    # 2. down one, if needed
    divo("set")
    # 3. down-up, make data
    if (Word2 !~ /^(conc|cns|cona|cont|cust|dist|dur|mom|mult|neu|per|prog|rep|rev|sem|tran)$/)
      error(Word2 " not a known aspectual category")
    divoc("setasp", Word2)
    divoc("setwords", Rest2)
    divc("doc/rt/sets")
    # 4. exit Path
    Path = "doc/rt/sets"
  }
  
  else if (Bc == "th") {
    # 1 reset hierarcy before new info
    divc("doc/rt")
    # 2. down one, if needed
    divo("th")
    divo("thattr")
    # 3. down-up, make data
    divoc("thword", Rest1)
    # 4. exit Path
    Path = "doc/rt/th/thattr"
  }
  
  else if (Bc == "tc") {
    # 1 reset hierarcy before new info
    divc("doc/rt/th/thattr")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("tc", Rest1)
    # 4. exit Path
    Path = "doc/rt/th/thattr"
  }
  
  else if (Bc == "cnj") {
    # 1 reset hierarcy before new info
    divc("doc/rt/th/thattr")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("cnj", Rest1)
    # 4. exit Path
    Path = "doc/rt/th/thattr"
  }
  
  else if ((Bc == "gl") && (Path == "doc/rt/th/thattr")) {
    # 1 reset hierarcy before new info
    divc("doc/rt/th/thattr")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("thgl", Rest1)
    # 4. exit Path
    Path = "doc/rt/th/thattr"
  }

  else if ((Bc == "ex") && (Path ~ "doc/rt/th")) {
    # first one
    if (Path !~ "exengs") {
      # 1 reset hierarcy before new info
      divc("doc/rt/th")
      # 2. down one, if needed
      divo("thexengs")
      divo("exeng")
      # 3. down-up, make data
      divoc("ex", Rest1)
      divoc("excolon", ": ")
      # 4. exit Path
      Path = "doc/rt/th/thexengs/exeng"
    }
    else {
      # 1 reset hierarcy before new info
      divc("doc/rt/th/thexengs")
      # 2. down one, if needed
      divo("exeng")
      # 3. down-up, make data
      divoc("ex", Rest1)
      divoc("excolon", ": ")
      # 4. exit Path
      Path = "doc/rt/th/thexengs/exeng"
    }
  }
  
  else if ((Bc == "eng") && (Path ~ "doc/rt/th")) {
    # 1 reset hierarcy before new info
    divc("doc/rt/th/thexengs/exeng")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("eng", Rest1)
    divoc("exsemicolon", "; ")
    # 4. exit Path
    Path = "doc/rt/th/thexengs/exeng"
  }
  
  else if (Bc == "prds") {
    # 1 reset hierarcy before new info
    divc("doc/rt/th")
    # 2. down one, if needed
    divo("prds")
    # 3. down-up, make data
    divoc("prdstype", Word2)
    divoc("prdsdef", Rest2)
    # 4. exit Path
    Path = "doc/rt/th/prds"
  }

  else if (Bc == "prd") {
    # 1 reset hierarcy before new info
    divc("doc/rt/th/prds")
    # 2. down one, if needed
    divo("prd")
    # 3. down-up, make data
    divoc("prdpers", Word2)
    divoc("prdwords", Rest2)
    # 4. exit Path
    Path = "doc/rt/th/prds/prd"
  }

  else if (Bc == "prdgl") {
    # 1 reset hierarcy before new info
    divc("doc/rt/th/prds/prd")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("prdgl", Rest1)
    # 4. exit Path
    Path = "doc/rt/th/prds/prd"
  }
  
  else if (Bc == "gc2") {
    # 1 reset hierarcy before new info
    divc("doc/rt")
    # 2. down one, if needed
    divo("gc2")
    divo("gc2attr")
    # 3. down-up, make data
    divoc("gc2word", Rest1)
    divoc("gc2type", "(" abbrev(Bl) ")")
    # 4. exit Path
    Path = "doc/rt/gc2/gc2attr"
  }
  
  else if ((Bc == "gl") && (Path == "doc/rt/gc2/gc2attr")) {
    # 1 reset hierarcy before new info
    divc("doc/rt/gc2/gc2attr")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("gc2gl", Rest1)
    # 4. exit Path
    Path = "doc/rt/gc2/gc2attr"
  }
  
  else if ((Bc == "ex") && (Path ~ "doc/rt/gc2")) {
    # first one
    if (Path !~ "exengs") {
      # 1 reset hierarcy before new info
      divc("doc/rt/gc2")
      # 2. down one, if needed
      divo("gc2exengs")
      divo("exeng")
      # 3. down-up, make data
      divoc("ex", Rest1)
      divoc("excolon", ": ")
      # 4. exit Path
      Path = "doc/rt/gc2/gc2exengs/exeng"
    }
    else {
      # 1 reset hierarcy before new info
      divc("doc/rt/gc2/gc2exengs")
      # 2. down one, if needed
      divo("exeng")
      # 3. down-up, make data
      divoc("ex", Rest1)
      divoc("excolon", ": ")
      # 4. exit Path
      Path = "doc/rt/gc2/gc2exengs/exeng"
    }
  }
  
  else if ((Bc == "eng") && (Path ~ "doc/rt/gc2")) {
    # 1 reset hierarcy before new info
    divc("doc/rt/gc2/gc2exengs/exeng")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("eng", Rest1)
    divoc("exsemicolon", "; ")
    # 4. exit Path
    Path = "doc/rt/gc2/gc2exengs/exeng"
  }

  # Move Bc to Prevbc
  Prevbc = Bc
}


END{
  divc("doc")
  # close doc itself
  print "</div>"
  foot()
}

function divo (class) {
  print "<div class=\"" class "\">"
  if (Path) 
    Path = Path "/" class
  else Path = class
}

function divoc (class, text) {
  print "<div class=\"" class "\">" text "</div>"
}

function divc(p,     oldlevel, newlevel, z, i) {
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

# function word1(text) {
#   return gensub(/^([^ ]+).*$/,"\\1","G",text)
# }

# function word2(text,  x) {
#   x = gensub(/^([^ ]+) +([^ ]+).*$/,"\\2","G",text)
#   if (x == text) error("No second word in '" text "'")
#   else return x
# }

# function rest1(text,  x) {
#   x = gensub(/^[^ ]+ +(.*)$/,"\\1","G",text)
#   if (x == text) error("No rest of line in '" text "'")
#   else return x
# }

# function rest2(text,  x) {
#   x = gensub(/^[^ ]+ +[^ ]+ +(.*)$/,"\\1","G",text)
#   if (x == text) error("No rest of line (2) in '" text "'")
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
  # print "<link href=\"../img/akflora.ico\" rel=\"shortcut icon\" \
  #         type=\"image/x-icon\"/>"

  print "</head>\n<body>"
  
}


function foot() {
  print "</body>\n</html>";
}

function bl2bc(     load, x, y, i) {
  load = ".rt rt; .af af; .ra ra; .lw lw; tag tag; rtyp rtyp; nav nav; " \
    "df df; ..sets sets; set set; ..th th; tc tc; cnj cnj; gl gl; "\
    "ex ex; eng eng; ...prds prds; prd prd; prdgl prdgl; "         \
    "..n gc2; ..adj gc2; ..adv gc2"
  split(load, x, ";")
  for (i in x) {
    gsub(/^ +/,"",x[i])
    split(x[i], y)
    Bl2bc[y[1]] = y[2]
  }
}

function abbrevs(     load, x, y, i) {
  load = "..n n.; ..adj adj.; ..adv adv."
  split(load, x, ";")
  for (i in x) {
    gsub(/^ +/,"",x[i])
    split(x[i], y)
    Abbrev[y[1]] = y[2]
  }
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
  if (!f[z[n]][Prevbc][Bc])
    error("'" Bc "' cannot follow '" Prevbc"'")
}

function error(msg) {
  printf "%5d: %s\n", NR, msg > "/dev/stderr"
}


