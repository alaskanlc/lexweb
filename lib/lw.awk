function validate() {
  htmlHeader("Validate")
  "mktemp -d | tr -d '\n' " | getline DIR;
  # print DIR
  print f["lex"] > ( DIR "/in.lw" )
  system("bash -c 'cd ../tools/lw2xml ; cat " DIR "/in.lw | ./cleanprolog | ./cleanindexmarks | ./xmlencode | ./lw2xml 2> " DIR "/out.error 1> " DIR "/out.xml'")
  print "<pre>"
  system("cat " DIR "/out.error")
  print "</pre>"
  htmlFooter()
  system("rm -rf " DIR) 
}

function makexml() {
  print "Content-type: text/xml\n"
  "mktemp -d | tr -d '\n' " | getline DIR;
  # print DIR
  print f["lex"] > ( DIR "/in.lw" )
  system("bash -c 'cd ../tools/lw2xml ; cat " DIR "/in.lw | ./cleanprolog | ./cleanindexmarks | ./xmlencode | ./lw2xml 2> " DIR "/out.error 1> " DIR "/out.xml'")
  system("cat " DIR "/out.xml")
  system("rm -rf " DIR) 
}
