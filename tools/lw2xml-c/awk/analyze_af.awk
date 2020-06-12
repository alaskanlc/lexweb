{
  if ($1 ~ /^\.[^.]/) {
    if ($1 ~ /^\.af/) {
      print ".af"
      af = 1
    }
    else af = 0
  }
  else if (af && ($0 ~ /^\./)) print "  " $1
}
