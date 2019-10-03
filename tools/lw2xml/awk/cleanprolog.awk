
{
  if (($0 ~ /^(\.\.sets|set)/) && (!firstrt)) print "# " $0
  else {
    if ($0 ~ /^\.(rt|af|lw)/) firstrt = 1
    print $0
  }
}
