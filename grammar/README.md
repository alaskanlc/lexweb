# Lexware grammar for Lower Tanana and Gwichin

## On Lexware

The Lexware file format is line-oriented plain text, structured only
by the first word on a line, the “band label” (BL). A root BL
(primarily `.rt` in the case of Jim Kari) indicates a new, seperate
dictionary term. Other BLs provide a range of attributes for this
term. Some BLs indicate sub-level entries linked to the root term,
which may in turn have their own attributes.  

Lexware contains no additional structure beyond the BLs, which makes
it challenging to parse and validate. Most other data serializations
include symbolic delimiters of data object start/end and hierarchy:
`{"X":"Y",...}` in JSON, `<X><Y/></X>` in XML, `BEGIN X; ... END;` in
Nexus, etc. Instead, each BL in Lexware must indicates two things: i)
the class of the data that follows the BL, and ii) the relationship of
that data to the preceding data structure. An external “grammar” of
the structural relationship of BLs is therefore required to parse
Lexware.

## Symbolic grammar indicating data structure

The following structure encodes the grammar of a Dene Lexware file’s
BLs. On each line is a BL, optionally indented, optionally followed by
`|` symbol, followed by a `*`, `+`, `?`, or `1` symbol. The
indentation denotes hierarchical dependence. The `|` denotes
alternatives. `*` means zero-to-many, `?` means zero-or-one, `+` means
one-to-many and `1` means exactly one; these occurrence specifiers are
the same for all preceding alternatives.

```
.rt +
  pd ?
  tag ?
  rtyp | top ?
  df ?
  ..sets ?
    set +
  ..th *
    tc 1
    gl 1
    ex *
      eng 1
    ..prds *
      prd +
        prdgl 1
  ..n | ..adv | ..dir | ..pp | ..adj | ..prt | ..cnj | ..dem * 
    dial ?
      dial *
    gl 1
    lit ?
    ex *
      eng 1
    ...n | ...adv | ...dir | ...pp | ...adj | ...prt | ...cnj | ...dem * 
      dial ?
        dial *
      gl 1
      lit ?
      ex *
        eng 1
.af *
  pd ?
  tag ?
  ..vpf | ..opf | ..sf | ..vsf | ..nsf *
    gl 1
    ...ifs ?
      gl 1
  ..ads | ..tfs *
    asp ?
      gl 1
      ex *
        eng 1
```

Blank lines have no structureal meaning, though may be added to
increase readability, e.g. to separate `.rt` level entries.

`.file` and `.par` are file-level BLs, indicating file description and
sectional breaks with associated text.

`com` and `rcom` are comments to be inserted at the indentation level
of their surrounding context.

`#` can be used for unparsed comments for programmers

## Band label data content descriptions

### Conventions

 * The “Band Label” (BL) is the string of non-whitespace characters
   starting a line. In this document in `monospaced` font
 * The template for a Lexware line appears here as a bulleted line,
   beginning with the BL, ending before the first semi-colon
 * Other defined keywords also appear in `monospaced` font
 * ENG denotes a single- or multi-word string of English words; DENE
   denotes a single- or multi-word string of Dene words
 * After the semicolon is a note on the position and arity of the BL line
 * After the second semicilon is a description of the information
   associated with the BL

### Comments

Comments only for the reader of the raw Lexware file:

 * `#` ENG ; 0-∞, anywhere; a comment, unparsed

Comments to appear in dictionary:

 * `com` ENG ; 0-∞, anywhere; a comment, parsed
 * `rcom` ENG ; 0-∞, in the root word section; a comment, parsed

### File structure bands

 * `.file` ENG ; 0-∞ per file, anywhere; an event in file, e.g.,
   section heading
 * `..par` ENG|DENE; 0-∞ per file, anywhere; a paragraph divider

### Root band specifier

 * `.rt` DENE ; 1-∞ per file ; root word
 * `.aff` DENE ; 1-∞ per file ; affix, also at root level

### Root band attributes

General attributes:

 * `pd` DENE ; 0-1 per `.rt` ; proto-Dene
 * `tag` ENG ; 0-1 per `.rt` ; root word/idea for root word
 * `rtyp` CODE (where CODE includes `N-bio`, `N-kin`, `N-anat`,
   `N-geo`...) ; 0-1 per `.rt` ; code for root word type. May add
   general `sd` for “semantic domain”. Replaced in Gwichin by `top`
   “topic”
 * `df` DENE ; 0-1 per `.rt` ; derived forms 

Root word structure terms:

 * `..sets` ; 0-1 per `.rt`, precedes `..th` ; variation of the verb stem
 * `set` CODE DENE ; 1-∞ per `..sets` ; aspectual category, when
   known. CODE includes `dur`, `sem`, `neu`, `cont`, `rep`, `prog`,
   `mom`, `peramb`

### Verb themes

 * `..th` DENE ; 0-∞ per `.rt` ; verb theme (if `.rt` a verb)
   (beautify with preceeding `..par`)

Attributes of the verb theme

 * `tc` DENE ; 0-1 per `..th`; theme category
 * `gl` ENG ; 1 per `..th` ; gloss of verb theme
 * `ex` DENE ; 0-∞ per `..th`; example snippet
 * `eng` ENG ; 1 per `ex` ; translation of example

Usage bands for theme:

 * `..prds` ENG ; 0-∞ per `..th` ; a usage paradigm
 * `prd` CODE DENE; 0-∞ per `..prds`; paradigm example. CODE = <person+number>
 * `prdgl` ENG foo ; 0-1 per `prd` ; paradigm gloss




# *Grammatical category* bands (follow sets and themes) keep types of GC together; to be decided: order of GCs

..n   łoo {a noun GC; 0-∞ per .rt}

..adv łoo {an adverb GC; 0-∞ per .rt}

..dir łoo {a directional adverb GC; 0-∞ per .rt}

..pp  łoo {a post position GC; 0-∞ per .rt}

..adj łoo {an adjective or adjectival verb GC; 0-∞ per .rt}

..prt łoo {a particle GC; 0-∞ per .rt}

..cnj łoo {a conjunction GC; 0-∞ per .rt}

..dem łoo {a demonstrative GC; 0-∞ per .rt}

dial xxx '' {the dialect code of the preceding GC; 1 per GC} GZ|VK

dial xxx łoo {the GC word in a different dialect (code); 0-∞ per GC} 

gl    foo {gloss of preceding GC; 1 per GC}

lit   foo {literal translation; 0-1 per GC; - to be followed up on}

sc    foo { scientific name; 0-1 per GC}
 
ex    łoo {example snippet; 0-∞ per GC ; sometimes pn = place name - to be
           followed up on}

eng   foo {trans. of example; 1 per example}



# *Sub-class grammatical category* bands

...n   łoo {a sub-class noun GC; 0-∞ per level2 GC}

(etc)


# Top-level alternate to root type

.af łoo {affix; 0 - many}

pd {protoDene ; 0 or 1}

tag foo { ; 0 or 1 }

..vpf łoo { verb prefix ; 0-1}

gl {0-1}

...ifs łoo {inflectional string; 0-1 per ..vpf}

gl foo {gloss; 1 per ...ifs}

..ads {aspectual derivational string; 0-1}

asp codes {aspect}

gl { ; 1}

ex

eng



----

Test for duplicate entries (wait for definition of duplicate)
----






# *Verb theme* GCs

..sets    {marking the beginning of verb theme for preceding ..th ???) 
set xxx ła łe ło {code xxx for aspect, list of sets ???; 1-∞ per ..sets}

tc ?


# ? GC

..prds Imp:
prd 1s ch'ih'àa
prd 2s ch'in'àa
prdgl subject eats


---

TBD: `top`
