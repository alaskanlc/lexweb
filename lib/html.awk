function htmlHeader(title) 
{
  # Use html5
  print "Content-type: text/html\n" ;
  print "<!DOCTYPE html>";
  print "<html xmlns=\"http://www.w3.org/1999/xhtml\"> \
         <head><title>" title "</title>                         \
         <link href=\"https://fonts.googleapis.com/css?family=Montserrat\" \
           rel=\"stylesheet\">   \
         <meta http-equiv=\"Content-Type\" content=\"text/html; \
           charset=utf-8\" /><link rel=\"stylesheet\" \
           href=\"css/default.css\" type=\"text/css\" />        \
           <link href=\"img/akflora.ico\" rel=\"shortcut icon\" \
           type=\"image/x-icon\"/> </head><body>";
}

function defaultpage()
{
  htmlHeader("Flora of Alaska");
  
  print "<div style=\"padding:50px;\"><img src=\"img/whitemntns_sm.jpg\"><h1>A New Flora of Alaska</h1><p style=\"max-width:800px;\">A dynamic biodiversity informatics integration of <a href=\"http://arctos.database.museum/uam_herb_all\">specimens</a>, <a href=\"http://www.inaturalist.org/projects/plants-and-fungi-of-alaska\">observations</a>, images, <a href=\"http://www.theplantlist.org/\">names</a>, taxon concepts, <a href=\"http://www.biodiversitylibrary.org/\">literature</a>, and characters, building on a digital version of <a href=\"http://www.sup.org/books/title/?id=2767\">Hultén's flora</a>.</p><p>A project of <a href=\"https://www.uaf.edu/museum/collections/herb/\">ALA</a> (Herbarium of the University of Alaska's Museum of the North in Fairbanks). <a href=\"mailto:info@alaskaflora.org\">Contact us</a>.</p><!-- <p>(Made with <a href=\"https://www.gnu.org/software/gawk/manual/gawk.html\"><tt>gawk</tt></a> and <a href=\"https://www.dreamhost.com/r.cgi?108617\">Dreamhost</a>)</p> -->";

  print "<p>Data available so far:</p><ul><li><a href=\"pages/ALA_checklist.html\">ALA Checklist of Accepted Names for Alaskan Vascular Plants</a></li></ul>";
  
  htmlFooter()
}


function blank()
{
  htmlHeader("blank");
  print "<div class=\"gen\"><div id=\"title\"><b>blank</b></div></div>";
  htmlFooter();
}

function htmlFooter()
{
  print "</body></html>\n";
}
  
