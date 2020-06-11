BEGIN{
  # RS = "\r\n"
  PROCINFO["sorted_in"] = "@ind_str_asc"
  priorpath = "0"
}

# Note a few single dot lines in LT
/^\.+[^.]/ && $1 !~ /^\.+(file|par|xr|mpn|grp)$/ {

  path = ""
  
  # how many dots?
  x = y = $1
  gsub(/[^.]/,"",x)
  dots = length(x)

  # term without dots
  gsub(/\./,"",y)

  
  # how many levels previously?
  n = split(priorpath,z,"/")

  # logic
  if (dots == 1) {
    path = y

    # store old afclass track of n/v for af
    if ((y == "af") && (afclass)) {
      afclasses[afclass]++
      afclass = ""
    }
  }
  else if (dots == 2) {
    path = z[1] "/" y

    # class the af as n or v via the doubledot
    if (z[1] == "af") {
      if (y ~ /^(nsf|sf|nfaf|nfsf)$/)
        afclass = afclass "n"
      if (y ~ /^(vsf1|vsf|nds|vfaf|vfsf|vpf|ads|tfs)$/)
        afclass = "v" afclass
    }
  }
  else if (dots == 3) {
    if (n == 1)
      path = z[1] "//" y
    else
      path = z[1] "/" z[2] "/" y
  }
  else 
    print "error, too many dots (" $1 ")" > "/dev/stderr"

  if (path ~ /^\//)
    print NR " ** " priorpath " ** " $1


  paths[path]++
      
  priorpath = path
}

END {
  
  print "** band hierarchy summary, sorted alphabetically ** "
  for (i in paths)
    printf "%-15s%d\n", i, paths[i]

  print ""
  print "** band hierarchy summary, sorted by freq ** "
  PROCINFO["sorted_in"] = "@val_num_desc"
  for (i in paths)
    printf "%-15s%d\n", i, paths[i]

  print ""
  for (i in afclasses) {
    if (i ~ /^n+$/) afn++
    if (i ~ /^v+$/) afv++
    if (i ~ /^v+n+$/) afvn++
  }
  
  print "** .af n/v summary ** \n  n = " afn ", v = " afv ", v & n = " afvn

}
