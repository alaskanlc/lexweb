% lw2html

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

    lw2xhtml [ --index --s <start Line> --f <finish Line> --xml ] <lexware file>

Arguments:

 * `--index` if present, make the index
 * `--s X` begin processing the Lexware file at line X
 * `--f Y` stop processing the Lexware file at line Y
 * `--xml` output a (non-HTML) XML file
 
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

### Band to XML element list

The `lw2xhtml` code is written so that the possible XML hierarchies
annotated in comments in the code can be extracted with this command:

    grep -E ' +#>' lw2xhtml | sed -E 's/^ +#>//g' | sort

This give a
[list](https://github.com/alaskanlc/lexweb/blob/master/lw2xhtml/lw_xml_elements)
of band classes and the hierarchy of XML div attributes in which the
information is stored. This is not an XML schema but can help
understand the XHTML structure. Another way to become familiar with
the structure of the XHTML is to view a formatted dictionary file, and
compare it with the XHTML source.

### Simple XML version and XML schema

Using the `--xml` switch, a simpler, non-HTML XML output is created
(without [.file]{.bl}, [..par]{.bl} and [com]{.bl} comments). This
version can be more easily analyzed with XQuery. It can also be
validated against an XML schema. The file
[lw.rnc](https://github.com/alaskanlc/lexweb/blob/master/lw2xhtml/lw.rnc)
contains the current valid XML schema, which should always be kept in
sync with the Lexware [grammar](grammar.html). The simple XML file can
be validate using [trang and jing](https://github.com/relaxng/jing-trang). First
generate the RELAX NG schema:

    $ java -jar /path/to/trang.jar -I rnc -O rng lw.rnc lw.rng

Then validate:

    $ java -jar /path/to/jing.jar lw.rng myLexwareFile.xml 

Alternatively, and easier on the eyes, open the XML file in Emacs. The
[nXML mode](https://www.gnu.org/software/emacs/manual/html_node/nxml-mode/index.html)
should launch automatically. `C-c C-s C-f` can be used to locate the
RELAX NC schema (or navigate via menus, starting with `M-\``). Invalid parts of the XML file are highlighted in red.

## Programming notes

### In-program comments

An attempt has been made make comprehensively comments inside the Awk
script. This should assist with maintenance and modification.

### Implementation choice

After initial attempts to write a parser in Awk (my language of
greatest familiarity), I started working on a `flex` and `bison`
parser and XML converter for Lexware files. This worked well, but with
every change in allowable syntax, it required a lot of work to
rewrite. It also introduced the need for a second XQuery converter
from XML to HTML.

After 5 March, 2020, I started again from scratch with a simpler,
single Awk script. I could develop it (and modify it) much more
rapidly. The validation component is not a true parser, and simply
catches non-allowed band label order, given the band label’s context,
but works fine.  The XHTML output allows data extraction and analysis
via XQuery. And most recently (2020-06-11), an option to output as
simpler XML has introduced the ability to validate the original
Lexware file via a XML schema validation of the XML output (see
above).

### Concerning different root word classes {#h.a1}

There are three band labels Jim uses for different kinds of root word:
root ([.rt]{.bl}), affix ([.af]{.bl}), and root/affix ([.ra]{.bl}).
Initially, Cam had been trying to deduce differing rules for the
syntax of each of these (e.g., an affix may only be a noun or verb
affix, and that would determine the kinds of sub-entries that were
allowed).  However, on analyzing Jim's usage for Lower Tanana, he
found:

 * There are affix word categories in [.rt]{.bl} (e.g. [.nsf]{.bl},
    [..tfs]{.bl})
 * There are lots of [.rt]{.bl} word categories ([..n]{.bl},
    [..adv]{.bl}, etc) in [.af]{.c17 .c0}
 * There are a few cases of both noun affix categories and verb affix
    categories under the same [.af]{.c17 .c0}
 * Likewise for [.ra]{.c0 .c17}

This recognition lead to a new, less specific strategy for validation:
to treat [.rt]{.bl}, [.af]{.bl}, [.ra]{.bl} with the _same_ rule set:
let any double-dot word category be under any single-dot band. The
grammar was rewritten (2020-04-15) to reflect this change.

