BEGIN{

  VALIDATE = 1

  PROCINFO["sorted_in"] = "@ind_str_asc"

  bl2bc()
  abbrevs()
  
  # # # create new contexts, needed for variation in 
  # ncA = "..sets ..th ex ...prds " rA " " gc2A  
  
  # Allowable following bands
  # [parent band class in which the new class exists][prior band class]
  rA  = "rt af ra lw"    # alternatives, as a shortcut
  
  #                       ?   ?   ?    ?  ?    ?  <+  *  *     *
  fol["doc"  ]["0"   ] = "rt                                 "
  fol["attr1"]["rt"  ] = "pd tag rtyp nav df sets     th gc2 " rA
  fol["attr1"]["pd"  ] = "   tag rtyp nav df sets     th gc2 " rA
  fol["attr1"]["tag" ] = "       rtyp nav df sets     th gc2 " rA
  fol["attr1"]["rtyp"] = "            nav df sets     th gc2 " rA
  fol["attr1"]["nav" ] = "                df sets     th gc2 " rA
  fol["attr1"]["df"  ] = "                   sets     th gc2 " rA
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
  fol["prds"]["prd"  ] = "                      prd prdgl gc2 " rA
  fol["prd" ]["prdgl"] = "                      prd       gc2 " rA

  #                        ?   1   *    *
  fol["attr2" ]["gc2"  ] = "dial gl            "
  fol["attr2" ]["dial" ] = "     gl            "
  fol["attr2" ]["gl"   ] = "        ex     gc2 " rA
  fol["ex"    ]["ex"   ] = "           eng gc2 " rA

  # # new contexts
  # split(ncA, z)
  # for (i in z)
  #   nc[z[i]] = 1

  # make array
  for (i in fol)
    for (j in fol[i]) {
      gsub(/^ +/,"",fol[i][j])
      gsub(/ +$/,"",fol[i][i])
      split(fol[i][j], z, / +/)
      for (k in z)
        f[i][j][z[k]] = 1
    }
  # for (i in f)
  #   for (j in f[i])
  #     for (k in f[i][j])
  #       print i, j, k

  
  # for (i in fol)
  #   print i ": " gensub(/ +/," ","G",fol[i])
  # exit

  # Starting Context and Priorbc
  Path = "doc"
  # Context = "doc"
  Priorbc = "0"
  head("Dictionary")
}

($0) && $0 !~ /^[ #]/  {

  # print Path
  # print $0
  Bl = word1($0)
  Bc = Bl2bc[Bl]
  # print Bc
  if (VALIDATE)
    validate()
  
  # convert
  if (Bc == "rt") {
    cdiv("doc")
    divo("rt")
    divo("attr1")
    divoc("rootword", rest1($0))
    # the Path at the end of the operations:
    Path = "doc/rt/attr1"
  }
  else if (Bc == "pd") {
    divoc("pd", ("/" rest1($0) "/"))
    Path = "doc/rt/attr1"
  }
  else if (Bc == "tag") {
    divoc("tag", rest1($0))
    Path = "doc/rt/attr1"
  }
  else if (Bc == "rtyp") {
    divoc("rtyp", rest1($0))
    Path = "doc/rt/attr1"
  }
  else if (Bc == "nav") {
    divoc("nav", rest1($0))
    Path = "doc/rt/attr1"
  }
  else if (Bc == "df") {
    divoc("df", rest1($0))
    Path = "doc/rt/attr1"
  }
  else if (Bc == "sets") {
    cdiv("doc/rt")
    divo("sets")
    Path = "doc/rt/sets"
  }
  else if (Bc == "set") {
    divoc("set", rest1($0))
    Path = "doc/rt/sets"
  }
  else if (Bc == "th") {
    cdiv("doc/rt")
    divo("th")
    divoc("theme", rest1($0))
    Path = "doc/rt/th"
  }
  else if (Bc == "tc") {
    divoc("tc", rest1($0))
    Path = "doc/rt/th"
  }
  else if (Bc == "cnj") {
    divoc("cnj", rest1($0))
    Path = "doc/rt/th"
  }
  else if ((Bc == "gl") && (Path == "doc/rt/th")) {
    divoc("th_gl", rest1($0))
    Path = "doc/rt/th"
  }
  else if (Bc == "gc2") {
    cdiv("doc/rt")
    divo("gc2")
    divo("attr2")
    divoc("gc2word", rest1($0))
    divoc("gc2type", "(" Abbrev[Bl] ")")
    Path = "doc/rt/gc2/attr2"
  }
  else if ((Bc == "gl") && (Path == "doc/rt/gc2")) {
    divoc("gc2_gl", rest1($0))
    Path = "doc/rt/gc2"
  }
  else if (Bc == "ex") {
    cdiv("doc/rt/gc2")
    divo("exeng")
    divoc("ex", rest1($0))
    print ": "
    Path = "doc/rt/gc2/ex"
  }
  else if (Bc == "eng") {
    divoc("eng", rest1($0))
    Path = "doc/rt/gc2/ex"
  }

  
  # could use switch(), but emacs AWK-mode does not indent correctly
  # if (bl == "rt") {
  # }
  # else if (bl == "tag") {
  # }
  
  Priorbc = Bc
}


END{
  cdiv("doc")
  foot()
}


function divo (class) {
  # ckdiv()
  print "<div class=\"" class "\">"
}

function divoc (class, text) {
  # ckdiv()
  print "<div class=\"" class "\">" text "</div>"
}

function cdiv(p,     oldlevel, newlevel, z, i) {
  oldlevel = split(Path, z, "/")
  newlevel = split(p, z, "/")
  for (i = 1; i <= (oldlevel - newlevel); i++)
    print "</div>"
}

# function dive (class, text) {
#   print "</div>"
# }


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


function foot()
{
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
  n = split(Path, z, "/")
  # print "                           " z[n] " <" Priorbc " " Bc

  if (!f[z[n]][Priorbc][Bc])
    printf "%5d: '%s' cannot follow '%s'\n", NR, Bc, Priorbc > "/dev/stderr"
}


# path

function path() {

  structure = "\
    doc
    doc/rt
    doc/rt/tag
    doc/rt/pd
    doc/rt/sets
    doc/rt/sets/set
    doc/rt/th
    doc/rt/th/gl
    doc/rt/th/prds
    doc/rt/th/prds/prd
    


}
