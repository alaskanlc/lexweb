
{
  gsub(/\*/,"",$0)
  gsub(/\]/,"", $0)
  print $0
}
