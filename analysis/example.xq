declare namespace html = "http://www.w3.org/1999/xhtml";

for $i in //html:div[@class='doc']/html:div[@class='rt']
return
  concat(
    data($i//html:div[@class='rtword']),
    ' (', data($i//html:div[@class='rttype']), ')',
    string-join(
      for $j in $i//html:div[@class='gc2']
      return
        concat(
          '&#10;   ', 
          data($j//html:div[@class='gc2word']),
          ' ',
          data($j//html:div[@class='gc2type']),
          ', &amp; ',
          count($j//html:div[@class='gc3']),
          ' level-3 words'
        )
        ,''
    )
  )
    
  

