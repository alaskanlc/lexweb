function htmlHeader(title) 
{
  # Use html5
  print "Content-type: text/html\n" ;
  print "<!DOCTYPE html> \
<html lang=\"en\" xmlns=\"http://www.w3.org/1999/xhtml\"> \
<head> \
  <title>" title "</title> \
  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/> \
  <meta name=\"description\" content=\"Lexware lexicography info and tools\"/> \
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"/> \
  <link href=\"//fonts.googleapis.com/css?family=Lato:400,300,600\" rel=\"stylesheet\" type=\"text/css\"/> <!-- originally Raleway --> \
  <link rel=\"stylesheet\" href=\"css/normalize.css\"/> \
  <link rel=\"stylesheet\" href=\"css/skeleton.css\"/> \
  <link rel=\"stylesheet\" href=\"css/override.css\"/> \
  <link rel=\"icon\" type=\"image/png\" href=\"img/icon.png\"/> \
</head> \
<body> \
  <div class=\"container\"> \
    <div class=\"row\"> \
      <div class=\"nine columns\" style=\"margin-top: 5%\">"
}



function blank()
{
  htmlHeader("blank");
  print "<div class=\"gen\"><div id=\"title\"><b>blank</b></div></div>";
  htmlFooter();
}

function htmlFooter()
{
  print "</div> \
      <div class=\"three columns\" style=\"margin-top: 5%\"> \
        <a class=\"button\" style=\"width:100%\" \
           href=\"grammar.html\">Grammar</a><br/> \
        <a class=\"button\" style=\"width:100%\" \
           href=\"tools.html\">Tools</a><br/> \
        <a class=\"button\" style=\"width:100%\" \
           href=\"resources.html\">Resources</a><br/> \
        <a class=\"button\" style=\"width:100%\" \
           href=\"contact.html\">Contact</a><br/> \
        <a class=\"button\" style=\"width:100%\" \
           href=\"index.html\">Home</a> \
        <a href=\"https://www.uaf.edu/anlc/\"><img src=\"img/anlc.png\" alt=\"Alaska Native Language Center\" style=\"width:60%;margin-left: auto; margin-right: auto; display:block; padding-top:5rem;\"/></a> \
      </div> \
    </div> \
  </div> \
</body> \
</html>"
}
  
