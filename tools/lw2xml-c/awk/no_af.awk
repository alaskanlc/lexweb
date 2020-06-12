
/^\.af +/ { af = 1 }
/^\.rt +/ { af = 0 }

{
  if (af) print "# " $0
  else print $0
}
