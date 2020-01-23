(: declare namespace html = "http://www.w3.org/1999/xhtml"; :)
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="css/lexware.css"/>
  </head>
  <body>
  <div class="container">
    {
      for $i in /lexware/(rt|af|lw)
      return
      <div class="entry">
        <div class="attr1">
          <span class="rootword">
            {
              (: root word; ugly...! no regex in fn:; 
                 elevate the $ codes to superscrips :)
              if (contains( data($i/word), '$'))
                then (substring-before( data($i/word), '$') ,
                  element sup { substring-before( substring-after(
                    data($i/word), '$'), ',') } ,
                  if (string-length( substring-after( data($i/word), ',')) > 0)
                    then (concat(',', substring-after( data($i/word), ',')))
                  else ()) else (data($i/word))
            }
          </span>
          { (: tag :)
            if (exists($i/tag)) then 
          <span class="tag">/ <i>{ data($i/tag) }</i> / </span> else () }
          { (: proto-Dene :)
            if (exists($i/pd)) then 
          <span class="pd">PD: { data($i/pd) };</span> else () }
          { (: root type :)
            if (exists($i/rtyp)) then 
          <span class="rtyp">type: { data($i/rtyp) };</span> else () }
          { (: derived forms :)
            if (exists($i/df)) then 
          <span class="df">derived form: { data($i/df) };</span> else () }
        </div>
        {
          (: comments after .rt attributes :)
          if (exists($i/com)) then
          <div class = "com1s">
            {
              for $c in $i/com
              return
              <div class="com"> ({ data($c) }) </div>
            }
          </div> else ()
        }
        {
          if (exists($i/th)) then 
          <div class="ths">
            {
              for $t in $i/th
              return
              <div class="th">theme: <i>{ data($t/word) }</i>
              </div>
            }
            </div> else ()
        }
        {
          if (exists($i/gc2)) then 
          <div class="gc2">
            {
              for $j in $i/gc2
              return
              <div>
                <span>
                  <b>
                    {
                      data($j/word)
                    }
                  </b>
                </span>
                <span>
                  {
                    concat('(',replace(data($j/type),'\.',''),'.)')
                  }
                </span>
                {
                  if (exists($j/gloss/eng)) then 
                  <span class="gl">
                    {
                      data($j/gloss/eng)
                    }
                  </span>
                else ()
                }
                {
                  if (exists($j/example)) then 
                  <div class="exengs">
                    {
                      for $k in $j/example
                      return
                      <div class="exeng">
                        {
                          concat('Example: ', data($k/ex), ' - ', data($k/eng))
                        }
                      </div>
                    }
                  </div>
                  else()
                }
              </div>
            }
          </div>
        else ()
        }  
      </div>
    }
  </div>
  </body>
</html>
