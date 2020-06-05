
{
  if ($0 ~ /^\.(af|rt|lw)/) {
    if (++entries > max) exit
    else print $0
  }
  else print $0
}

