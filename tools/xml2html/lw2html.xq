(: declare namespace html = "http://www.w3.org/1999/xhtml"; :)
<html>
  <head>
    <link rel="stylesheet" href="lexware.css"/>
  </head>
  <body>
    {
      for $i in /lexware/(rt|af)
      return
      <div class="root">
        <div class="attributes">
          <span class="rootword"> { data($i/word) } </span> 
          { if (exists($i/pd)) then 
          <span class="pd">(PD: { data($i/pd) }) </span> else () }
          { if (exists($i/tag)) then 
          <span class="tag">/ <i>{ data($i/tag) }</i> / </span> else () }
          { if (exists($i/rtyp)) then 
          <span class="rtyp">(type: { data($i/rtyp) }) </span> else () }
        </div>
        {
          (: comments after .rt attributes :)
          if (exists($i/com)) then
          <div class = "coms1">
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
            <span>
            { data($j/type) }, <b>{ data($j/word) }</b><br/>
            </span>
            }
          </div>
          else ()
        }  
      </div>
    }
  </body>
</html>
