BEGIN{
  PROCINFO["sorted_in"] = "@ind_str_asc"

  # sym| Rsis| ldtr | oc| bl
  tree =                                    "\
  doc  |     | rt   | 1 |                   ;\
  rt   | af  | pd   | * | .rt               ;\
  pd   | tag |      | ? | pd                ;\
  tag  | rtyp|      | ? | tag               ;\
  rtyp | wc  |      | ? | rtyp              ;\
  wc   |     | gl   | * | ..n, ..adj, ..adv ;\
  gl   |     |      | 1 | gl                ;\
  af   |     | asp  | * | gl                "

  # Hmmm. maybe the grammar cannot be modelled as a tree - what about
  # alternatives rt, lt, af...? Diff meaning from rt*,lt*,af*

  # Load the schema
  gsub(/ /,"",tree)
  split(tree,tr,";")
  for (i in tr) {
    split(tr[i], tc, "|")
    Rsis[tc[1]] = tc[2] 
    Ldgt[tc[1]] = tc[3]
     Occ[tc[1]] = tc[4]
     Bls[tc[1]] = tc[5]
  }

  # for (i in Rsis)
  #   print i, Rsis[i], Ldgt[i], Occ[i], Bls[i]

  follow("root")
  for (i = 1; i < I; i++)
    print i, Chain[i], Occ[Chain[i]]
  
  
  exit
  
  # find depths
  for (i in schema_up) {
    d = 1
    z = schema_up[i]
    while (z != "root") {
      z = schema_up[z]
      d++
    }
    schema_dp[i] = d
  }
  last_schema_up = "root"
}

{

  # translate the band level into node
  # 






  
  # read band label and determine if it is allowable for each allowed
  # node. Before moving to the next band, create a list of allowable
  # next nodes e.g., if ex, only eng is allowed. If .rt, long list
  node = bl2label[word1($0)]
  # logic: 1. is node a descendent of the previous ancestral node
  # (attributes) or a new descendent of that (if allowed) 2. is the
  # previous structure complete?...
  
  print node, schema_up[node], last_schema_up
  if (schema_up[node] != last_schema_up)
    error("schema fail")
  last_schema_up = schema_up[node]
}



function word1(text) {
  return gensub(/^([^ ]+).*$/,"\\1","G",text)
}

function word2(text,  x) {
  x = gensub(/^([^ ]+) +([^ ]+).*$/,"\\2","G",text)
  if (x == text) error("No second word in '" text "'")
  else return x
}

function rest1(text,  x) {
  x = gensub(/^[^ ]+ +(.*)$/,"\\1","G",text)
  if (x == text) error("No rest of line in '" text "'")
  else return x
}

function rest2(text,  x) {
  x = gensub(/^[^ ]+ +[^ ]+ +(.*)$/,"\\1","G",text)
  if (x == text) error("No rest of line (2) in '" text "'")
  else return x
}

function error(text) {
  print "  ERROR: " text > "/dev/stderr"
}

function follow(start) {
  print "(at '" start "')" # , checking for '" checkfor "')"
  Chain[++I] = start
  Visited[start] = 1
  
  # Go down as far as possible first
  # is there a Ldgt?
  if (Ldgt[start] && !Visited[Ldgt[start]]) {
    # Always allow the Ldgt, at one down depth
    print "... moving down "
    Parent[Ldgt[start]] = start
    follow(Ldgt[start])
  }
  # is the sister?
  else if (Rsis[start]) {
    print "... moving right "
    Parent[Rsis[start]] = Parent[start]
    follow(Rsis[start])
  }
  else if (Parent[start]) {
    print "... moving up "
    follow(Parent[start])
  }
  else {
    print "... back to root"
  }
  
    
}



