% Tools

<div style="float: right; width: 300px; padding-left: 30px; font-size: smaller;">
  <img src="img/flow.jpg" width="100%"/><br/>
  <b>Fig 1.</b> Elements of generating a dictionary from a Lexware file
</div>

# Tools

**Go to: [ONLINE LEXWARE PROCESSING TOOLS](onlinetools.html)**

<!-- **Go to section: [Text editing](#te) | [Concurrent editing](#ce) | [Lexware file grammar](#g) | [Validation](#v) | [Conversion to formatted dictionary](#c) | [Indexing](#i) | [Analytical tools](#a)** -->


## Text editing {#te}

A generic [Text Editor](https://en.wikipedia.org/wiki/Text_editor) is
used to create and modify a Lexware file.
[Jim Kari](https://www.uaf.edu/anlc/emeritus.php#kari) and
[Tim Montler](http://www.montler.net/) use
[EditPad Pro](https://www.editpadpro.com/), for Windows. For the
current project we wanted to develop and promote a solution that was
free and open source, and which could be used for Windows, Mac, and
Linux. We recommend [Atom](https://atom.io/).

We have developed a
[Lexware language](https://github.com/alaskanlc/language-lexware)
package for Atom that provides i) syntax coloring, and ii) keyboard
shortcuts for common Dene non-Latin characters.  The package can be
easily installed from within Atom: just open Preferences, click the
Install tab, and search for “Lexware”. Click the Install button on
`language-lexware`.  Tim Montler has developed a syntax coloring mode
for EditPad Pro, and a Dene package for the key mapping software
[Keyman](https://keyman.com/); please contact Tim for these packages.

## Concurrent editing {#ce}

### Github

If at any point there might be more than one person working on a
Lexware file, including an assistant who may help with validation and
formatting, it may be expedient to use a concurrent versioning
system. Most academics are now familiar with the concurrent editing in
Google Docs, but this resources was preceded by decades of tools
available for software code writers to collaborate on projects. The
most popular code sharing site today is [Github](https://github.com),
which uses the [Git](https://git-scm.com/) versioning system.  Because
a Lexware file is ‘line-oriented’, it is very similar to software
code, using Github to manage Lexware editing is a good choice. Github
“repos” can be either public or private, and you may choose to keep
your working copy of a lexware file private. There are many guides to
using Github, and the Atom editor has built-in Github capabilities.

### Google Docs

However, if collaborators would prefer to use Google Docs, it is
possible to adapt a Google Doc to facilitate Lexware editing. Please
see
[here](https://github.com/alaskanlc/lexweb/blob/master/tools/GAS/README.md)
for a guide to adding syntax coloration to your Lexware file. At this
time it is not possible to customize keystokes in Google Docs, so some
other approach must be found for adding Dene diacritics (they can
always be added laboriously using menu ‘Insert -> Special
characters’).  The GoogleDoc file will need to be downloaded as
**Plain text** for use with the [Lexware scripts](lw2xhtml.html),
although the GoogleDoc text can be copied and pasted _directly_ into
the [online](onlinetools.html) converter.

Note that line numbering (needed for working with the validator) is
not a standard function in Google Docs. However, an
[extension](https://linenumbers.app/) for the Chrome browser can be
installed.

## Lexware file grammar {#g}

No Lexware syntax validation is available in the text editor itself,
and the writer must carefully avoid band label typos, and adhere to
the band order defined in the the [grammar](grammar.html). Elements of
a Lexware file that are out of order are not ‘wrong’ per se, but will
not generate standardized dictionary entries and will not be available
for analysis.
 
## Validation {#v}

To detect typos and band order that does not conform to the Lexware
Dene grammar, an additional layer of software is needed. In the
current implementation, both validation and conversion to a structured
data object are performed by the [lw2xhtml](lw2xhtml.html) program.
The program contains a set of rules about which band may follow which
other bands in which context. This rule set must be updated on every
change to the grammar.

Running the validator returns a brief description of any errors, with
their line number.  The user can then either fix the error, or
“[comment out](grammar.html#h.markup)” the section.

The validator may be run [online](onlinetools.html) or on a user’s
computer. More details [here](lw2xhtml.html).

Validation can can also be performed by output the (non-HTML) XML
version, and using an [XML validator](lw2xhtml.html#v).

## Conversion to formatted dictionary {#c}

Conversion to a formatted dictionary is also done by the
[lw2xhtml](lw2xhtml.html) program, which contains the logic to markup
each data element with its position within a hierarchical dictionary
entry. The output is HTML which can be viewed in any web browser. The
precise formatting (text styles, indentation, etc.) is not stored in he
HTML file, but is determined by an accompanying CSS file.  Changes to
this styling can be made easily by editing the CSS file, and without
the need to generate a new HTML version of the dictionary.

To obtain a final PDF file, the HTML can be directly ‘printed to file’
from the browser, or can be saved as HTML and opened with a Word
Processor where final edits can be made.

## Indexing {#i}

Markup with the Lexware file indicates index terms to be
collected. The `lw2xhtml` program collects these and creates and index
after the dictionary entries. The index is hyperlinked back to the
entries.

## Analytical tools and XML output {#a}

A lexware file is essentially a database. However, much of the
information is stored implicitly and is dependent on the context of
the bands preceding it. This implicit information is hard to extract
without first validating and restructuring the document. The HTML
output of `lw2xhtml` is the valid XML dialect of HTML, with meaningful
hierarchy and standardized terms for each class.  It can thus be
queried using XQuery to extract any choice of elements for further
analysis. See
[here](https://github.com/alaskanlc/lexweb/tree/master/analysis) for
an example.

Using the `--xml` switch, `lw2xhtml` will output a non-XHTML XML
version, with structure using element names not div class
attribites. This XML version can analysed via XQuery.

