all: lw2xml

lw2xml.tab.c lw2xml.tab.h:  lw2xml.y
	bison -v -d lw2xml.y

lex.yy.c: lw2xml.lex
	flex lw2xml.lex

lw2xml: lex.yy.c lw2xml.tab.c lw2xml.tab.h
	gcc  -g -o lw2xml lw2xml.tab.c lex.yy.c

clean:
	rm lw2xml lw2xml.tab.c lex.yy.c lw2xml.tab.h lw2xml.output

test:
	cat test.lw | gawk -f awk/xmlencode.awk | lw2xml

tidytest:
	cat test.lw | gawk -f awk/cleanindexmarks.awk | gawk -f awk/xmlencode.awk | lw2xml | tidy -xml -indent -m -q | tee test.xml

rnc: test.xml
	java -jar ~/usr/jing-trang-20151127/build/trang.jar test.xml test.rnc

ltprep:
	cat ~/desk/collab/jimK/github/gwichin/lexware/lt.lex | \
      gawk -f awk/cleanprolog.awk | gawk -f awk/cleanindexmarks.awk | \
      gawk -f awk/xmlencode.awk | gawk -f awk/no_af.awk > lt.ori.lw
	cp lt.ori.lw lt.fix.lw

lt:
	# awk '/^\.(af|rt|lw)/,EOF'
	# cat ../../lw/lt.lex | cleanprolog | xmlencode | ./lw2xml > out 2>&1
	#	cat lt.lw | ./cleanprolog | ./cleanindexmarks | ./xmlencode | lw2xml 2> lt.error 1> lt.xml
	# cat ~/desk/collab/jimK/github/gwichin/lexware/lt.lex | ./cleanprolog | ./cleanindexmarks | ./xmlencode | lw2xml 2> lt.error 1> lt.xml
	cat lt.fix.lw | lw2xml 2> lt.error 1> lt.xml

ltdiff:
	diff lt.ori.lw lt.fix.lw

# lterr:
#	cat lt.lex | ./lw2xml 2>&1 > /dev/null 

grammar:
	grep "//:" lw2xml.y | sed 's|^.*//:||g' | gawk '{gsub(/\\n/,"\n",$$0); print $$0}' > ../../grammar/dene.grammar

# gcc  -o lw2xml -DYYDEBUG lw2xml.tab.c lex.yy.c

gw:
	head -n 4000 gw.d17ba19.fix.lw | lw2xml 2> gw.error 1> gw.xml

