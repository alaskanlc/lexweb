# might be done with sed!
# sed -r '$!N;s/^(\s*<given-name>.*)\n(\s*<surname>.*)/\2\n\1/;P;D' file
# but clearer with awk:

{
  if ($0 ~ /^sc /) {       # if sc
    sc = $0                # store, and don't print
    scl = NR
  }
  else if (NR == scl+1) {  # if the next line
    if ($0 ~ /^smf /) {    # if smf follows sc
      print $0             # print them swapped
      print sc
    }
    else {
      print sc             # else print previous sc and current line
      print $0
    }
  }
  else print $0            # else print a normal line
}
