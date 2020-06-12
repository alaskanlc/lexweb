function validate() {
  htmlHeader("Validation results")
  "mktemp -d | tr -d '\n' " | getline DIR;
  close("mktemp -d | tr -d '\n' ")
  print f["lex"] > ( DIR "/in.lw" )
  system("bash -c 'cd ../lw2xml ; ./lw2xml --index " DIR "/in.lw 2> " DIR "/out.error 1> " DIR "/out.html'")
  print "<h1>Validation Results</h1>"
  print "<p>(If the following lines are blank, there were no errors)</p>"
  print "<pre>"
  system("cat " DIR "/out.error")
  print "</pre>"
  htmlFooter()
  system("rm -rf " DIR) # but seems to be autodelete by apache
}

function makehtml() {
  print "Content-type: text/html\n"
  "mktemp -d | tr -d '\n' " | getline DIR;
  close("mktemp -d | tr -d '\n' ")
  print f["lex"] > ( DIR "/in.lw" )
  system("bash -c 'cd ../lw2xml ; ./lw2xml --index " DIR "/in.lw 2> " DIR "/out.error 1> " DIR "/out.html'")
  system("sed -i 's|lw.css|css/lw.css|g' " DIR "/out.html")
  system("cat " DIR "/out.html")
  system("rm -rf " DIR) 
}
