BEGIN{

  VALIDATE = 1

  PROCINFO["sorted_in"] = "@ind_str_asc"
  # alternatives
  rA  = ".rt .af .ra .lw"
  gc2A = "..n ..adj ..adv"

  # # create new contexts, needed for variation in 
  ncA = "..sets ..th ex ...prds " rA " " gc2A  
  
  # # Obligatory division starts = previous division must end
  # ds[".rt"] = 1
  # ds["..sets"] = 1
  # ds["..th"] = 1
  # ds["+gc2"] = 1
  # ds["ex"] = 1  #? no

  # Allowable following bands
  # [band]
  #                 ?   ?   ?    ?  ?    ?    <+   *     *       *
  fol["0"     ] = "                                   "          rA
  fol[".rt"   ] = "pd tag rtyp nav df ..sets     ..th " gc2A " " rA
  fol["pd"    ] = "   tag rtyp nav df ..sets     ..th " gc2A " " rA
  fol["tag"   ] = "       rtyp nav df ..sets     ..th " gc2A " " rA
  fol["rtyp"  ] = "            nav df ..sets     ..th " gc2A " " rA
  fol["nav"   ] = "                df ..sets     ..th " gc2A " " rA
  fol["df"    ] = "                   ..sets     ..th " gc2A " " rA
  fol["..sets"] = "                          set      "
  fol["set"   ] = "                          set ..th " gc2A " " rA

  #                 1   ?  1  *  <1    ?     +   <1
  fol["..th"  ] = "tc                                 "
  fol["tc"    ] = "   cnj gl                          "
  fol["cnj"   ] = "       gl                          "
  fol["gl^..th"]= "          ex     ...prds           " gc2A " " rA
  fol["ex"    ] = "             eng                   "
  fol["eng"   ] = "          ex     ...prds           " gc2A " " rA
  fol["...prds"]= "                         prd       "
  fol["prd"   ] = "                         prd prdgl " gc2A " " rA
  fol["prdgl" ] = "                         prd       " gc2A " " rA

  #                           ?    1
  fol["+gc2"  ] = " dial gl                           "
  fol["dial"  ] = "      gl                           "
  fol["gl^gc2"] = "                                   " gc2A " " rA

  # expand alternatives
  split(rA, r) ; split(gc2A, gc2)
  for (i in fol)
    if (i ~ /\+gc2/)
      for (k in gc2)
        fol[gc2[k]] = fol[i]

  # new contexts
  split(ncA, z)
  for (i in z)
    nc[z[i]] = 1

  # make array
  for (i in fol) {
    gsub(/^ +/,"",fol[i])
    gsub(/ +$/,"",fol[i])
    split(fol[i], z, / +/)
    for (k in z)
      f[i][z[k]] = 1
  }

  for (i in fol)
    print i ": " gensub(/ +/," ","G",fol[i])
  exit

  # Starting context and prior
  context = "doc"
  prior = "0"
  head("Dictionary")
}

($0) && $0 !~ /^[ #]/  {

  print $0
  bl = word1($0)
  # new context?
  if (nc[bl])
    context = bl    
  
  # validate
  if (VALIDATE) {
    # print "                           " context " <" prior " " bl
    if (!f[prior][bl])
      printf "%5d: '%s' cannot follow '%s'\n", NR, bl, prior > "/dev/stderr"
  }
  
  # convert

  if (bl == ".rt") {
    divo("rt")
    divo("attr1")
    divoc("rootword", rest1($0))
    # the Path at the end of the operations:
    Path = "doc/.rt/attr1"
  }
  else if (bl == "pd") {
    divoc("pd", ("/" rest1($0) "/"))
    Path = "doc/.rt/attr1"
  }
  else if (bl == "tag") {
    divoc("tag", rest1($0))
    Path = "doc/.rt/attr1"
  }
  else if (bl == "rtyp") {
    divoc("rtyp", rest1($0))
    Path = "doc/.rt/attr1"
  }
  else if (bl == "nav") {
    divoc("nav", rest1($0))
    Path = "doc/.rt/attr1"
  }
  else if (bl == "df") {
    divoc("df", rest1($0))
    Path = "doc/.rt/attr1"
  }
  else if (bl == "..sets") {
    closediv("doc/.rt")
    divo("sets")
    Path = "doc/.rt/sets"
  }
  else if (bl == "set") {
    divoc("set", rest1($0))
    Path = "doc/.rt/sets"
  }
  else if (bl == "..n") {
    closediv("doc/.rt")
    divo("gc2")
    divoc("gc2word", rest1($0))
    divoc("gc2type", "(n.)")
    Path = "doc/.rt/gc2"
  }

  
  # could use switch(), but emacs AWK-mode does not indent correctly
  # if (bl == ".rt") {
  # }
  # else if (bl == "tag") {
  # }
  
  prior = bl
}


END{
  closediv("doc")
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

function closediv(p,     oldlevel, newlevel, z, i) {
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
