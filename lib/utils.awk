function error(msg) {
  print "<pre>" ;
  print msg ;
  print "Exiting. Please return to previous page.";
  print "</pre>" ;
  htmlFooter() ;
  exit;
}

## Note - errors if two columns have same name since field is used as key
function queryDB( query            , row, i, cmd ) {
  gsub(/`/,"\\`",query);  # if writing directly, need: \\\`
  gsub(/\n/," ",query);
  gsub(/\ \ */," ",query);
  cmd = "/bin/echo -e \"" query "\" | mysql -u " USER " -p" PASSWORD " -h " HOST " -B --column-names --default-character-set=utf8 " DBNAME ;
  # print cmd;
  row = -1;
  FS = "\t";
  while ((cmd | getline ) > 0)
	{
	  row++;
	  if (row == 0) 
		{
		  DBQc = NF;
		  for (i = 1; i <= NF; i++)
			{
			  DBQf[i] = $i;
			}
		}
	  for (i = 1; i <= NF; i++)
		{
		  DBQ[row, DBQf[i]] = $i;
          # print row, i,  $i;
		}
	}
  close(cmd);
  DBQr = row;
}

function clearDBQ() {

  delete DBQ;
  delete DBQf;
  DBQr = 0;
  DBQc = 0;
}

function printTable(width,    widthstr,   i, j) 
{
  if (width) widthstr = "width=\"" width "\"";
  print "<table border=\"1\" " widthstr ">";
  print "<tr>";
  for (i = 1; i <= DBQc; i++) print "<th>" DBQf[i] "</th>";
  print "</tr>";
  for (i = 1; i <= DBQr; i++)
	{
	  print "<tr>";
	  for (j = 1; j <= DBQc; j++)
		{
          if (DBQ[i,DBQf[j]] == "NULL") DBQ[i,DBQf[j]] = "&#160;" ;
		  print "<td>" DBQ[i,DBQf[j]] "</td>";
		}
	   print "</tr>";
	}
  print "</table>";
}

function printTableLinks( links,       link, tmp1, tmp2, i, j) 
{
  # parse links
  split(links, tmp1, "|");
  for (i in tmp1) {
    split(tmp1[i], tmp2, "~");
    link[tmp2[1]] = tmp2[2];
  }
  
  print "<table border=\"1\">";
  print "<tr>";
  for (i = 1; i <= DBQc; i++) print "<th>" DBQf[i] "</th>";
  print "</tr>";
  for (i = 1; i <= DBQr; i++)
	{
	  print "<tr>";
	  for (j = 1; j <= DBQc; j++)
		{
          # empty?
          if (DBQ[i,DBQf[j]] == "NULL") DBQ[i,DBQf[j]] = "&#160;"
          # linked?
          else if (link[DBQf[j]])
            DBQ[i,DBQf[j]] = gensub("!", DBQ[i,DBQf[j]], "G", link[DBQf[j]]);
		  print "<td>" DBQ[i,DBQf[j]] "</td>";
		}
	   print "</tr>";
	}
  print "</table>";
}


# decode urlencoded string
function urldecode(text,   hex, i, hextab, decoded, len, c, c1, c2, code) {
	
  split("0 1 2 3 4 5 6 7 8 9 a b c d e f", hex, " ")
  for (i=0; i<16; i++) hextab[hex[i+1]] = i
  
  # urldecode function from Heiner Steven
  # http://www.shelldorado.com/scripts/cmds/urldecode

  # decode %xx to ASCII char 
  decoded = ""
  i = 1
  len = length(text)
  
  while ( i <= len ) {
    c = substr (text, i, 1)
    if ( c == "%" ) {
      if ( i+2 <= len ) {
	c1 = tolower(substr(text, i+1, 1))
	c2 = tolower(substr(text, i+2, 1))
	if ( hextab [c1] != "" || hextab [c2] != "" ) {
	  # print "Read: %" c1 c2;
	  # Allow: 
	  # 20 begins main chars, but dissallow 7F (wrong in orig code!)
	       # tab, newline, formfeed, carriage return
	  if ( ( (c1 >= 2) && ((c1 c2) != "7f") )  \
	       || (c1 == 0 && c2 ~ "[9acd]") )
	  {
	    code = 0 + hextab [c1] * 16 + hextab [c2] + 0
	    # print "Code: " code
	    c = sprintf ("%c", code)
	  } else {
	    # for dissallowed chars
	    c = " "
	  }
	  i = i + 2
	}
      }
    } else if ( c == "+" ) {	# special handling: "+" means " "
      c = " "
    }
    decoded = decoded c
    ++i
  }
  
  # change linebreaks to \n
  gsub(/\r\n/, "\n", decoded);
  
  # remove last linebreak
  sub(/[\n\r]*$/,"",decoded);
  
  return decoded
}

function iNatProject(cmd, json, i, j, data, nresults, user, date, taxon, id, thumb, ancs, anc, nanc, fam, pages, p, srt, thumbn) {

  RS="\x04";
  gsub(/,/,"%2C",f["users"]);
  inat_fams();

  # first page (also getting total number of results)
  cmd = "curl -s -X GET --header 'Accept: application/json' 'https://api.inaturalist.org/v1/observations?project_id=plants-and-fungi-of-alaska&page=1&user_id=" f["users"] "'";
  cmd | getline json ;
  close(cmd);

  if (! json_fromJSON(json, data)) {
    print "JSON import failed!" > "/dev/stderr"
    exit 1
  }

  nresults = data["total_results"] ;
  x = 0;

  for (i = 1 ; (i <= nresults) && (i <= 30) ; i++ ) {
    user[++x] = data["results"][i]["user"]["login_exact"];
    date[x] =   data["results"][i]["observed_on_details"]["date"];
    taxon[x] =  data["results"][i]["taxon"]["name"];
    id[x] =     data["results"][i]["id"];
    thumb[x] =  data["results"][i]["photos"][1]["url"];

    for (j in data["results"][i]["photos"]) thumbn[x]++;

    ancs = data["results"][i]["taxon"]["ancestry"];
    nanc = split(ancs, anc, "/");
    for (j = 0; j < nanc; j++) {
      if (famcode[anc[nanc-j]]) {
        fam[x] = famcode[anc[nanc-j]];
        break;
      }
    }
  }
  
  # get the rest of the pages
  pages = int(nresults / 30) + int(((nresults % 30) + 29) / 30);
  for (p = 2 ; p <= pages ; p++) {
    delete data; json = "";
    cmd = "curl -s -X GET --header 'Accept: application/json' 'https://api.inaturalist.org/v1/observations?project_id=plants-and-fungi-of-alaska&page=" p "&user_id=" f["users"] "'";
    cmd | getline json ;
    close(cmd);

    if (! json_fromJSON(json, data)) {
      print "JSON import failed!" > "/dev/stderr"
      exit 1
    }
    
    for (i = 1 ; i <= (nresults - ((p-1)*30)) && i <= 30 ; i++ ) {
      user[++x] = data["results"][i]["user"]["login_exact"];
      date[x] =   data["results"][i]["observed_on_details"]["date"];
      taxon[x] =  data["results"][i]["taxon"]["name"];
      id[x] =     data["results"][i]["id"];
      thumb[x] =  data["results"][i]["photos"][1]["url"];

      for (j in data["results"][i]["photos"]) thumbn[x]++;

      ancs = data["results"][i]["taxon"]["ancestry"];
      nanc = split(ancs, anc, "/");
      for (j = 0; j < nanc; j++) {
        if (famcode[anc[nanc-j]]) {
          fam[x] = famcode[anc[nanc-j]];
          break;
        }
      }
    }
  }

  # sort field
  PROCINFO["sorted_in"] = "@val_str_asc";
  for (i = 1; i <= nresults; i++) srt[i] = user[i] date[i];

  # make output page
  htmlHeader("Plants and Fungi of Alaska, by users");
  print "<h1>User contributions to iNat Plants and Fungi of Alaska project</h1>";
  print "<p><b>Total obs: " nresults "</b></p>";
  print "<table cellpadding=\"10\">";
  print "<tr><th>User</th><th>N./user</th><th>Obs. date</th><th>Taxon</th><th>Family</th><th>Obs. ID</th><th>Photo</th><th>N photos</th></tr>";

  for (i in srt) {
    print "<tr></td><td align=\"center\">" user[i]              \
      "</td><td align=\"center\">" ++peruser[user[i]]   \
      "</td><td>" date[i]                               \
      "</td><td>" taxon[i]                                              \
      "</td><td>" fam[i]                                              \
      "</td><td><a href=\"https://www.inaturalist.org/observations/" id[i] \
      "\">" id[i]                                                       \
      "</a></td><td><img src=\"" thumb[i]                               \
      "\"/></td><td>" thumbn[i] "</td></tr>" ;
  }
  print "</table>";
  print "<p style=\"font-size:80%;\"><i>Search via: 'http://alaskaflora.org/do?method=inatproj&users=XXX' where XXX is a comma-separated list of iNat usernames.</i></p>";

  htmlFooter();
}

function walk_array(arr, name,      i)
{
  PROCINFO["sorted_in"] = "@ind_str_asc";
    for (i in arr) {
        if (isarray(arr[i]))
            walk_array(arr[i], (name "[" i "]"))
        else
            printf("%s[%s] = %s\n", name, i, arr[i])
    }
}

function inat_fams() {

  famcode[71429] = "Acoraceae";
  famcode[55793] = "Adoxaceae";
  famcode[48072] = "Alismataceae";
  famcode[52327] = "Amaranthaceae";
  famcode[55849] = "Amaryllidaceae";
  famcode[48699] = "Apiaceae";
  famcode[47362] = "Apocynaceae";
  famcode[48536] = "Araceae";
  famcode[52849] = "Araliaceae";
  famcode[47599] = "Asparagaceae";
  famcode[64662] = "Aspleniaceae";
  famcode[332930] = "Athyriaceae";
  famcode[47890] = "Balsaminaceae";
  famcode[49155] = "Betulaceae";
  famcode[48150] = "Boraginaceae";
  famcode[47204] = "Brassicaceae";
  famcode[48040] = "Campanulaceae";
  famcode[48527] = "Caprifoliaceae";
  famcode[48567] = "Caryophyllaceae";
  famcode[47539] = "Celastraceae";
  famcode[47604] = "Asteraceae";
  famcode[47194] = "Cornaceae";
  famcode[47374] = "Cupressaceae";
  famcode[47161] = "Cyperaceae";
  famcode[332916] = "Cystopteridaceae";
  famcode[53930] = "Diapensiaceae";
  famcode[47753] = "Dryopteridaceae";
  famcode[51937] = "Droseraceae";
  famcode[64695] = "Elaeagnaceae";
  famcode[47747] = "Equisetaceae";
  famcode[133387] = "Ericaceae";
  famcode[56235] = "Gentianaceae";
  famcode[47689] = "Geraniaceae";
  famcode[47131] = "Grossulariaceae";
  famcode[60205] = "Haloragaceae";
  famcode[60444] = "Hymenophyllaceae";
  famcode[47781] = "Iridaceae";
  famcode[60114] = "Isoëtaceae";
  famcode[52642] = "Juncaceae";
  famcode[60266] = "Juncaginaceae";
  famcode[48623] = "Lamiaceae";
  famcode[47122] = "Fabaceae";
  famcode[57860] = "Lentibulariaceae";
  famcode[47328] = "Liliaceae";
  famcode[51308] = "Linaceae";
  famcode[47621] = "Lycopodiaceae";
  famcode[49464] = "Melanthiaceae";
  famcode[62369] = "Menyanthaceae";
  famcode[71417] = "Montiaceae";
  famcode[51121] = "Nymphaeaceae";
  famcode[47790] = "Onagraceae";
  famcode[64686] = "Onocleaceae";
  famcode[55329] = "Ophioglossaceae";
  famcode[47217] = "Orchidaceae";
  famcode[47322] = "Orobanchaceae";
  famcode[47332] = "Papaveraceae";
  famcode[64552] = "Phrymaceae";
  famcode[47562] = "Pinaceae";
  famcode[50638] = "Plantaginaceae";
  famcode[47434] = "Poaceae";
  famcode[48932] = "Polemoniaceae";
  famcode[48382] = "Polygonaceae";
  famcode[52679] = "Polypodiaceae";
  famcode[59109] = "Potamogetonaceae";
  famcode[48064] = "Primulaceae";
  famcode[48437] = "Pteridaceae";
  famcode[48231] = "Ranunculaceae";
  famcode[47148] = "Rosaceae";
  famcode[47693] = "Rubiaceae";
  famcode[61091] = "Ruppiaceae";
  famcode[47567] = "Salicaceae";
  famcode[59992] = "Santalaceae";
  famcode[58321] = "Sapindaceae";
  famcode[48386] = "Saxifragaceae";
  famcode[71422] = "Scheuchzeriaceae";
  famcode[47151] = "Scrophulariaceae";
  famcode[58770] = "Selaginellaceae";
  famcode[48516] = "Solanaceae";
  famcode[47556] = "Taxaceae";
  famcode[56184] = "Thelypteridaceae";
  famcode[71426] = "Tofieldiaceae";
  famcode[48694] = "Typhaceae";
  famcode[51885] = "Urticaceae";
  famcode[50828] = "Violaceae";
  famcode[64663] = "Woodsiaceae";
  famcode[52615] = "Zosteraceae";

}
