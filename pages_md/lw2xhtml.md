% Lw2html

# The lw2xhtml program

The core of the Lexware processing pipeline is a single program called
`lw2xhtml`. This is a command-line program that can be run on Mac,
Linux or Windows, and is also available as an online CGI program
[here](onlinetools.html).

`lw2xhtml` is a single [Gawk](https://www.gnu.org/software/gawk/)
script with no dependencies other that Gawk, which is installed on all
Linux machines, and can easily be installed on Mac and Windows.

## Installation

### Linux

Either clone the Lexweb repo:

    $ git clone https://github.com/alaskanlc/lexweb.git

or just copy the
[lw2xhtml file](https://raw.githubusercontent.com/alaskanlc/lexweb/master/lw2xhtml/lw2xhtml). (If
the browser saves it as `lw2xhtml.txt` rename it to `lw2xhtml`). Make
sure the file is executable:

    $ chmod u+x lw2xhtml
    
Now, typing `lw2xhtml` (or `./lw2xhtml` if $PATH is not set) should
execute the program. If you do not have a `gawk` at `/usr/bin/gawk`,
you can also run it with:

    $ gawk -f lw2xhtml

### Mac

Because the code in `lw2xhtml` uses some non-POSIX Awk features it
will not run on the `awk` that comes pre-installed with Macs.  You
will need `gawk`. The easiest way to get `gawk` is via the Homebrew
project. Just go to the [Homebrew](https://brew.sh/) page, and follow
the one-line install instructions. For this, and for running
`lw2xhtml` you will need to open `Terminal`, an app in Utilities. (Type
`cd Desktop` when you start Terminal, so that you are working with
files on the Desktop.)

Once Homebrew is installed, just type:

    $ brew install gawk

Then, either clone the Lexweb repo:

    $ git clone https://github.com/alaskanlc/lexweb.git

Or just copy the
[lw2xhtml file](https://raw.githubusercontent.com/alaskanlc/lexweb/master/lw2xhtml/lw2xhtml) to your Desktop. (If
the browser saves it as `lw2xhtml.txt` rename it to `lw2xhtml`.)

Execute the program with:

    $ gawk -f lw2xhtml

    
### Windows

`lw2xhtml` can be easily run using Gawk cross-compiled for Windows,
and the `CMD.EXE` command prompt:

 * Download Gawk from
   [Ezwinports](https://sourceforge.net/projects/ezwinports/files/) and unzip
   on the Desktop.
 * Copy the [lw2xhtml file](https://raw.githubusercontent.com/alaskanlc/lexweb/master/lw2xhtml/lw2xhtml)
   to your Desktop. (If the browser saves it as `lw2xhtml.txt` rename it
   to `lw2xhtml`.)
 * In the menubar search box, type `CMD.EXE` and open it. This is the old
   DOS commandline. (You can also use Windows Powershell)
 * Type these commands (altering the version numbers if different. The
   latest `CMD.EXE` has command line TAB-completion which speeds
   things up. Basic commands: `dir` = view directory files, `cd` =
   change directory, `copy`, `more` = see file contents. (Substitute
   your Lexware file for `MyLexwareFile.lw`.)

    cd Desktop
    dir
    gawk-5.1.0-w32-bin\bin\gawk.exe -f lw2xhtml
    gawk-5.1.0-w32-bin\bin\gawk.exe -f lw2xhtml MyLexwareFile.lw
    gawk-5.1.0-w32-bin\bin\gawk.exe -f lw2xhtml MyLexwareFile.lw > out.html
    dir

### Usage    
    
With no arguments, the program prints its usage and exits. General usage:

    lw2xhtml [ --index --s <start Line> --f <finish Line> ] <lexware file>

Arguments:

 * `--index` if present, make the index
 * `--s X` begin processing the Lexware file at line X
 * `--f Y` stop processing the Lexware file at line Y
 
The program outputs the validation results to `/dev/stderr` and the
processed output to `/dev/stdout`.  To capture the output in a file:

    lw2xhtml in.lw > out.html

To capture the validation results (in the Bash shell):

    lw2xhtml in.lw 2> validation.txt 1> out.html

(On Windows the validation results must be copied from the CMD.EXE window.)


## XHTML output structure

In designing an XML schema, there is no single correct structure:
information may be coded in element names, or in attributes, data can
be ‘flattened’ (minimal hierarchy, or ‘normalized’ (modeling with
additional hierarchical levels). For the Lexware output as XHTML, all
the structure information had to be stored as `<div class="...">`
attributes. Choices about hierarchical structure were made to facilitate
the display of the data in a traditional dictionary format. For
example, the root word is nested within a block of root attributes
(`rtattr`), rather than immediately below the `rt` div.

The `lw2xhtml` code is written so that the possible XML hierarchies
can be extracted with this command:

    grep -E ' +#>' lw2xhtml | sed -E 's/^ +#>/    /g' | sort

This give a list of band classes and the hierarchy of XML div
attributes in which the information is stored. This is not an XML
schema but should help understand the XHTML structure. (To create an
XML schema in XSD or RNC would be possible, but a great deal of work.)
The best way to become familiar with the structure of the XHTML is to
view a formatted dictionary file, and compare it with the XHTML
source.  

The current output is:

     asp:  doc/rt/gc2/gc2attr/asp
     asp:  doc/rt/gc2/gc3/gc3attr/asp
     asp:  doc/rt/th/gc3/gc3attr/asp
     cit:  doc/rt/gc2/gc2exengs/exeng/cit
     cit:  doc/rt/gc2/gc3/gc3exengs/exeng/cit
     cit:  doc/rt/gc2/th3/th3attr/cit
     cit:  doc/rt/gc2/th3/th3exengs/exeng/cit
     cit:  doc/rt/th/gc3/gc3exengs/exeng/cit
     cit:  doc/rt/th/thattr/cit
     cit:  doc/rt/th/thexengs/exeng/cit
     cnj:  doc/rt/gc2/gc2attr/cnj
     cnj:  doc/rt/gc2/th3/th3attr/cnj
     cnj:  doc/rt/th/thattr/cnj
     com:  .../com
     df:   doc/rt/rtattr/df
     dial: doc/rt/gc2/gc2attr/dials/dial
     dial: doc/rt/gc2/gc2attr/dials/dialx/dial
     dial: doc/rt/gc2/gc2attr/dials/dialx/dialword
     dial: doc/rt/gc2/gc3/gc3attr/dials/dial
     dial: doc/rt/gc2/gc3/gc3attr/dials/dialx/dial
     dial: doc/rt/gc2/gc3/gc3attr/dials/dialx/dialword
     dial: doc/rt/th/gc3/gc3attr/dials/dial
     dial: doc/rt/th/gc3/gc3attr/dials/dialx/dial
     dial: doc/rt/th/gc3/gc3attr/dials/dialx/dialword
     dial: ... exeng/dials/dial
     dial: ... exeng/dials/dialx/dial
     dial: ... exeng/dials/dialx/dialword
     eng:  doc/rt/gc2/exengs/exeng/eng
     eng:  doc/rt/gc2/gc3/exengs/exeng/eng
     eng:  doc/rt/gc2/th3/exengs/exeng/eng
     eng:  doc/rt/th/exengs/exeng/eng
     eng:  doc/rt/th/gc3/exengs/exeng/eng
     ex:   doc/rt/gc2/exengs/exeng/ex
     ex:   doc/rt/gc2/gc3/gc3exengs/exeng/ex
     ex:   doc/rt/gc2/th3/exengs/exeng/ex
     ex:   doc/rt/th/exengs/exeng/ex
     ex:   doc/rt/th/gc3/gc3exengs/exeng/ex
     file: doc/file
     gc2:  doc/rt/gc2/gc2attr/gc2type
     gc2:  doc/rt/gc2/gc2attr/gc2word
     gc3:  doc/rt/gc2/gc3/gc3attr/gc3type
     gc3:  doc/rt/gc2/gc3/gc3attr/gc3word
     gc3:  doc/rt/th/gc3/gc3attr/gc3type
     gc3:  doc/rt/th/gc3/gc3attr/gc3word
     gl:   doc/rt/gc2/gc2attr/gl
     gl:   doc/rt/gc2/gc3/gc3attr/gl
     gl:   doc/rt/gc2/th3/th3attr/gl
     gl:   doc/rt/th/gc3/gc3attr/gl
     gl:   doc/rt/th/thattr/gl
     lit:  doc/rt/gc2/exengs/exeng/lit
     lit:  doc/rt/gc2/gc2attr/lit
     lit:  doc/rt/gc2/gc3/exengs/exeng/lit
     lit:  doc/rt/gc2/gc3/gc3attr/lit
     lit:  doc/rt/gc2/th3/exengs/exeng/lit
     lit:  doc/rt/th/exengs/exeng/lit
     lit:  doc/rt/th/gc3/exengs/exeng/lit
     lit:  doc/rt/th/gc3/gc3attr/lit
     lw:   doc/lw/lwattr/lwword
     nav:  doc/rt/rtattr/nav
     par3:  .../par3
     par:  .../par
     pd:   doc/rt/rtattr/pd
     prd:  doc/rt/th/prds/prd/prdpers
     prd:  doc/rt/th/prds/prd/prdwords
     prdgl:doc/rt/th/prds/prd/prdgl
     prds: doc/rt/th/prds/prdsdef
     prds: doc/rt/th/prds/prdstype
     quo:  doc/rt/gc2/gc2exengs/exeng/quo
     quo:  doc/rt/gc2/gc3/gc3exengs/exeng/quo
     quo:  doc/rt/gc2/th3/th3attr/quo
     quo:  doc/rt/gc2/th3/th3exengs/exeng/quo
     quo:  doc/rt/th/gc3/gc3exengs/exeng/quo
     quo:  doc/rt/th/thattr/quo
     quo:  doc/rt/th/thexengs/exeng/quo
     rt:   doc/rt
     rt:   doc/rt/rtattr
     rt:   doc/rt/rtattr/rttype
     rt:   doc/rt/rtattr/rtword
     rtyp: doc/rt/rtattr/rtyp
     set:  doc/rt/sets/set
     set:  doc/rt/sets/set/setasp
     set:  doc/rt/sets/set/setwords
     sets: doc/rt/sets
     src:  doc/lw/lwattr/src
     tag:  doc/rt/rtattr/tag
     tc:   doc/rt/gc2/gc2attr/tc
     tc:   doc/rt/gc2/th3/th3attr/tc
     tc:   doc/rt/th/thattr/tc
     th3:  doc/rt/gc2/th3/th3attr/thword
     th:   doc/rt/th
     th:   doc/rt/th/thattr
     th:   doc/rt/th/thattr/thword

    

## Programming notes

### 
