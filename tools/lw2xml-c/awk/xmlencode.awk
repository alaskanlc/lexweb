
{
  gsub(/&/,"\\&amp;",$0)
  gsub(/</,"\\&lt;", $0)
  gsub(/>/,"\\&gt;", $0)
  print $0
}
