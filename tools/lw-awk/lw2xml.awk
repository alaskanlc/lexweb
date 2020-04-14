
# Variable naming convention: Global variables begin with a Capital letter,
#   local variables with a lowercase letter

# Document structure (xml schema choices made to reflect blocking choice in
#   html document)
# 
#   doc
#   doc/rt
#   doc/rt/{tag pd nav...}
#   doc/rt/sets
#   doc/rt/sets/set
#   doc/rt/th
#   doc/rt/th/{tc cnj gl}
#   doc/rt/th/ex
#   doc/rt/th/ex/eng
#   doc/rt/th/prds
#   doc/rt/th/prds/prd
#   doc/rt/th/prds/prd/prdgl

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
  #   th, gc2, or a new root.

  #   Occurrences:        ?   ?   ?    ?  ?    ?  <+  *  *     *
  fol["doc"  ]["0"   ] = "rt                                 "
  fol["rt"   ]["rt"  ] = "pd tag rtyp nav df sets     th gc2 " rA
  fol["rt"   ]["pd"  ] = "   tag rtyp nav df sets     th gc2 " rA
  fol["rt"   ]["tag" ] = "       rtyp nav df sets     th gc2 " rA
  fol["rt"   ]["rtyp"] = "            nav df sets     th gc2 " rA
  fol["rt"   ]["nav" ] = "                df sets     th gc2 " rA
  fol["rt"   ]["df"  ] = "                   sets     th gc2 " rA
  fol["sets" ]["sets"] = "                        set      "
  fol["sets" ]["set" ] = "                        set th gc2 " rA

  #                        1  ?  1  *  <1   ?    +   <1   *     *
  fol["th"  ]["th"   ] = "tc                                  "
  fol["th"  ]["tc"   ] = "   cnj gl                           "
  fol["th"  ]["cnj"  ] = "       gl                           "
  fol["th"  ]["gl"   ] = "          ex     prds           gc2 " rA
  fol["ex"  ]["ex"   ] = "             eng                    "
  fol["ex"  ]["eng"  ] = "          ex     prds           gc2 " rA
  fol["prds"]["prds" ] = "                      prd           "
  fol["prd" ]["prd"  ] = "                          prdgl     "
  fol["prd" ]["prdgl"] = "                      prd       gc2 " rA

  #                          ?   1   * <1   *
  fol["gc2"   ]["gc2"  ] = "dial gl            "
  fol["gc2"   ]["dial" ] = "     gl            "
  fol["gc2"   ]["gl"   ] = "        ex     gc2 " rA

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
  Path = "doc"
  Prevbc = "0"
  # start the xhtml output
  head("Dictionary")
  divo("doc")
}

# For each non-empty and non-comment line...
($0) && $0 !~ /^[ #]/  {

  if (DEBUG) {
    print Path
    print $0
  }

  # load the band label
  Bl = word1($0)
  # Convert to band class
  Bc = Bl2bc[Bl]

  # ** Validation **
  if (VALIDATE)
    validate()
  
  # ** Conversion to xhtml **
  if (Bc == "rt") {
    # 1 reset hierarcy
    divc("doc")
    # 2. down one, if needed
    divo("rt")
    # 3. down-up, make data
    divoc("rootword", rest1($0))
    # 4. exit Path
    Path = "doc/rt"
  }
  else if (Bc == "pd") {
    # 1 reset hierarcy
    divc("doc/rt")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("pd", ("/" rest1($0) "/"))
    # 4. exit Path
    Path = "doc/rt"
  }
  else if (Bc == "tag") {
    # 1 reset hierarcy
    divc("doc/rt")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("tag", rest1($0))
    # 4. exit Path
    Path = "doc/rt"
  }
  else if (Bc == "rtyp") {
    # 1 reset hierarcy
    divc("doc/rt")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("rtyp", rest1($0))
    # 4. exit Path
    Path = "doc/rt"
  }
  else if (Bc == "nav") {
    # 1 reset hierarcy
    divc("doc/rt")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("nav", rest1($0))
    # 4. exit Path
    Path = "doc/rt"
  }
  else if (Bc == "df") {
    # 1 reset hierarcy
    divc("doc/rt")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("df", rest1($0))
    # 4. exit Path
    Path = "doc/rt"
  }
  else if (Bc == "sets") {
    # 1 reset hierarcy
    divc("doc/rt")
    # 2. down one, if needed
    divo("sets")
    # 3. down-up, make data
    # 4. exit Path
    # divc("doc/rt")
    Path = "doc/rt/sets"
  }
  else if (Bc == "set") {
    # 1 reset hierarcy
    divc("doc/rt/sets")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("set", rest1($0))
    # 4. exit Path
    Path = "doc/rt/sets"
  }
  else if (Bc == "th") {
    # 1 reset hierarcy
    divc("doc/rt")
    # 2. down one, if needed
    divo("th")
    # 3. down-up, make data
    divoc("theme", rest1($0))
    # 4. exit Path
    Path = "doc/rt/th"
  }
  else if (Bc == "tc") {
    # 1 reset hierarcy
    divc("doc/rt/th")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("tc", rest1($0))
    # 4. exit Path
    Path = "doc/rt/th"
  }
  else if (Bc == "cnj") {
    # 1 reset hierarcy
    divc("doc/rt/th")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("cnj", rest1($0))
    # 4. exit Path
    Path = "doc/rt/th"
  }
  else if ((Bc == "gl") && (Path == "doc/rt/th")) {
    # 1 reset hierarcy
    divc("doc/rt/th")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("th_gl", rest1($0))
    # 4. exit Path
    Path = "doc/rt/th"
  }
  else if (Bc == "gc2") {
    # 1 reset hierarcy
    divc("doc/rt")
    # 2. down one, if needed
    divo("gc2")
    # 3. down-up, make data
    divoc("gc2word", rest1($0))
    divoc("gc2type", "(" Abbrev[Bl] ")")
    # 4. exit Path
    Path = "doc/rt/gc2"
  }
  else if ((Bc == "gl") && (Path == "doc/rt/gc2")) {
    # 1 reset hierarcy
    divc("doc/rt/gc2")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("gc2_gl", rest1($0))
    # 4. exit Path
    Path = "doc/rt/gc2"
  }
  else if (Bc == "ex") {
    # 1 reset hierarcy
    divc("doc/rt/gc2")
    # 2. down one, if needed
    divo("ex")
    # 3. down-up, make data
    divoc("exex", rest1($0))
    divoc("excolon", ": ")
    # 4. exit Path
    Path = "doc/rt/gc2/ex"
  }
  else if (Bc == "eng") {
    # 1 reset hierarcy
    divc("doc/rt/gc2/ex")
    # 2. down one, if needed
    # 3. down-up, make data
    divoc("eng", rest1($0))
    # 4. exit Path
    Path = "doc/rt/gc2/ex"
  }

  # Move Bc to Prevbc
  Prevbc = Bc
}


END{
  # close up to doc
  divc("doc")
  # close one more to above doc
  print "</div>"
  foot()
}

function divo (class) {
  print "<div class=\"" class "\">"
}

function divoc (class, text) {
  print "<div class=\"" class "\">" text "</div>"
}

function divc(p,     oldlevel, newlevel, z, i) {
  # "close the hierarchy n levels to the new path indicated in p"
  oldlevel = split(Path, z, "/")
  newlevel = split(p, z, "/")
  for (i = 1; i <= (oldlevel - newlevel); i++)
    print "</div>"
}


function word1(text) {
  return gensub(/^([^ ]+).*$/,"\\1","G",text)
}

function word2(text,  x) {
  x = gensub(/^([^ ]+) +([^ ]+).*$/,"\\2","G",text)
  if (x == text) error("No second word in '" text "'")
  else return x
}

function rest1(text,  x) {
  x = gensub(/^[^ ]+ +(.*)$/,"\\1","G",text)
  if (x == text) error("No rest of line in '" text "'")
  else return x
}

function rest2(text,  x) {
  x = gensub(/^[^ ]+ +[^ ]+ +(.*)$/,"\\1","G",text)
  if (x == text) error("No rest of line (2) in '" text "'")
  else return x
}

function error(text) {
  print "  ERROR: " text > "/dev/stderr"
}

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

  print "</head>\n<body>\n<div class=\"main\">"
  
}


function foot() {
  print "</div>\n</body>\n</html>";
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

function validate(   z, n) {

  # find the context from the tail element of Path
  n = split(Path, z, "/")
  # if the current band class cannot follow the previous band class in the
  #   current context, write an error
  if (!f[z[n]][Prevbc][Bc])
    printf "%5d: '%s' cannot follow '%s'\n", NR, Bc, Prevbc > "/dev/stderr"
}


