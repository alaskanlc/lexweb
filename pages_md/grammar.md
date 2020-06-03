% Dene Lexware Grammar

# Dene Lexware Grammar

This document is the normative definition of allowable structure for
Dene Lexware files, based on Jim Kari’s usage (for Lower Tanana), and
with input from Jason Harris (for Gwich’in).

**Conventions** in this document: Band labels are in [this]{.bl}
font. Options after band labels are in [this]{.w2} font.  Text that
must follow a band is indicated [TEXT]{.txt} (it may contain one or
more words, separated by space(s)). Sections in this document define
classes of related bands, with each bullet being a necessary or
optional band, in the order given. An ‘OR’ means that only one of
several options is allowed. Hyperlinks can be followed to the relevant
section.

Brief linguistic background information is included for some of the
elements in order to facilitate the work of those who are not familiar
with Dene Athabascan lexicography.

## Document {#h.doc}

 * Each document may have _(1-to-many)_ [Root elements](#h.re)

### Root element {#h.re}

Each root element can be either a:

 * [Root](#h.root) OR 
 * [Loan word](#h.lw)

## Root {#h.root}

 * [\<r\>]{.bl} [TEXT]{.txt} _(exactly-1)_ where [\<r\>]{.bl} is one
    of [.rt]{.bl} (root word), [.af]{.bl} (affix), [.ra]{.bl}
    (root/affix) (see [note](#h.a1)).
 * [Root word attributes](#h.rwa) _(0-to-1)_
 * [Stem sets](#h.ss) _(0-to-1)_
 * [Themes](#h.th) _(0-to-many)_
 * [Word Categories](#h.wc) _(0-to-many)_

### Root word attributes {#h.rwa}

 * [pd]{.bl} [TEXT]{.txt} _(0-to-1)_ : Proto Dene
 * [tag]{.bl} [TEXT]{.txt} _(0-to-1)_ : Tag
 * [rtyp]{.bl} [TEXT]{.txt} _(0-to-1)_ : Root word type (now includes
    codes for previous root elements: [.rtu]{.bl}, [.rrt]{.bl},
    [.drt]{.bl})
 * [nav]{.bl} [TEXT]{.txt} _(0-to-1)_ : Navajo cognate
 * [df]{.bl} [TEXT]{.txt} _(0-to-1)_ : Derived forms

### Stem sets {#h.ss}

“Athabascan \[verb\] stems undergo transformations to express
different _states_ of time and completion, called mode, and different
_ways_ of completing an action or being in a state, called aspect”
(Urschel 2006). The [..set]{.bl} data construction records that stem
variation in mode and aspect for verb roots. Each [set]{.bl} line
gives mode variation (in standard order: imperfective, perfective,
future, optative), for for a single aspect (e.g., conclusive,
durative). Note that aspect is also indicated by verb prefixes (see
[Themes](#h.th)).

 * [..sets]{.bl} _(exactly-1)_
 * [set]{.bl} [\<asptype\>]{.w2} [TEXT]{.txt} _(1-to-many)_ :
    Aspectual category, where [\<asptype\>]{.w2} is one of:
    [bisec]{.w2} (bisective), [conc]{.w2} (conclusive), [cns]{.w2}
    (consecutive), [cona]{.w2} (conative), [cont]{.w2} (continuative),
    [cust]{.w2} (customary), [dist]{.w2} (distributive), [dur]{.w2}
    (durative), [mom]{.w2} (momentaneous), [mult]{.w2} (multiple),
    [neu]{.w2} (neuter), [per]{.w2} (perambulative), [pers]{.w2}
    (persistive), [prog]{.w2} (progressive), [rep]{.w2} (repetitive),
    [rev]{.w2} (reversative), [sem]{.w2} (semelfactive), [tran]{.w2}
    (transitional).

### Themes {#h.th}

A _verb theme_ denotes an abstract or skeleton verb form which does
not include reference to subject and time (Urschel 2006). It is a
“shorthand grammatical formula that indicates the basic structure for
the verb-word" (Kari 2012). Many different themes can be built from
the same stem (root word) with very different meanings.

In general, a specific theme for a stem will convey a particular _way_
of doing something, indicated in the [tc]{.bl} band; “the verb theme
categories are groups of themes that have similar meaning and
grammatical structure especially in their most basic forms” (Kari
2012). The theme categories are _aspectual_ in nature, relating to the
temporal contour of the theme.

[Examples](#h.ex) present a selection of many possible _derivatives_
of the theme.

The _paradigms_ for the theme record the actual forms that the theme
takes under different _modes_, _subjects_ (I, you, we...), and with
_negation_.

 * [..th]{.bl} [TEXT]{.txt} _(exactly-1)_ : The formula for the theme,
   consisting minimally of stem and classifier (the morpheme preceding
   the stem, sometimes just “remnants of ancient grammar rules
   \[without\] direct meaning”
   ([ref.](http://qenaga.org/verbs_and_sentences/classifiers.html)),
   sometimes indicating voice/transitivity (Rice 2015), and indicate
   whether the verb takes an object (O), postpositional object (P), or
   gender prefix (G). Symbol ‘+’ separates morphemes (meaningful
   component sounds), and ‘\#’ indicates the boundary between disjunct
   and conjunct morphemes. (Note: band label [\...th]{.bl} is used
   under [..tfs]{.bl}.)
 * [Dialects](#h.dial) _(0-to-1)_
 * [tc]{.bl} [\<tctype\>]{.w2} _(exactly-1)_ : Theme category, where
   [\<tctype\>]{.w2} is one of: [clas-mot]{.w2} (classificatory
   motion), [clas-stat]{.w2} (classificatory stative), [conv]{.w2}
   (conversive), [con-rev]{.w2} (conversive-reversative), [desc]{.w2}
   (descriptive), [dim]{.w2} (dimensional), [dur]{.w2} (durative),
   [ext]{.w2} (extension), [mot]{.w2} (motion), [neu]{.w2} (neuter),
   [ono]{.w2} (onomatopoetic), [op]{.w2} (operative), [op-ono]{.w2}
   (onomatopoetic operative), [op-rep]{.w2} (operative repetitive),
   [op-rev]{.w2} (operative reversative), [pos]{.w2} (positional),
   [pot]{.w2} (potentialitive), [stat]{.w2} (stative), [suc]{.w2}
   (successive), [u:xxx]{.w2} (uncategorized xxx), [a-neu]{.w2}
   (a-neuter), [desc-neg]{.w2} (descriptive-negative), [sev]{.w2}
   (several, used occasionally). Also [stat/mot]{.w2}, [ext/mot]{.w2},
   [stat/op]{.w2} for dual [tc]{.bl}.
 * [cnj]{.bl} [TEXT]{.txt} _(0-to-1)_ : Conjugation prefix.  **CHECK**
   Jim and Jason’s decision on which band label to use for
   this. [cnjg1]{.bl} was also a suggestion.
 * [Gloss](#h.gl) _(exactly-1)_
 * [Example](#h.ex) _(0-to-many)_
 * [Paradigms](#h.prd) _(0-to-many)_
 * ( [Word sub-categories](#h.wc2) (0-to-many) : [\...n]{.bl} only,
   nominalized verbs making use of the theme )

### Gloss {#h.gl}

 * [gl]{.bl} [TEXT]{.txt} _(exactly-1)_ : English gloss
 * [quo]{.bl} [TEXT]{.txt} _(0-to-1)_ : Quotations from consultant
   (or comment)
 * [cit]{.bl} [TEXT]{.txt} _(0-to-1)_ : Citation (e.g., Notebook
   source)

### Example {#h.ex}

 * [ex]{.bl} [TEXT]{.txt} _(exactly-1)_ : Example
 * [Dialects](#h.dial) _(0-to-1)_
 * [eng]{.bl} [TEXT]{.txt} _(exactly-1)_ : English translation
 * [lit]{.bl} [TEXT]{.txt} _(0-to-1)_ : Literal translation
 * [quo]{.bl} [TEXT]{.txt} _(0-to-1)_ : Quotations from consultant
   (or comment)
 * [cit]{.bl} [TEXT]{.txt} _(0-to-1)_ : Citation (e.g., Notebook
   source)

### Dialects {#h.dial}

Note the different usage of [dial]{.bl} depending on whether it is the
first, or subsequent

 * [dial]{.bl} [\<lang\>]{.w2} _(exactly-1)_ : Dialect of the
   preceding [ex]{.bl}. [\<lang\>]{.w2} is a controlled vocabulary.
    * [dial]{.bl} [\<lang\>]{.w2} [TEXT]{.txt} _(0-to-many)_ :
      Additional forms of the word in different dialects

### Paradigms {#h.prd}

Verb theme usage paradigms: the specific forms of this theme recording
variation in subject, _mode_, negation. Coded as a table.

 * [...prds]{.bl} [\<def\>]{.w2} _(exactly-1)_ : Column definition
   codes for subsequent [prd]{.bl} bands. [\<def\>]{.w2} is a string
   of single or double characters separated by space(s). The character
   order defines the column order. Allowable characters indicate
   _modes_: [i]{.w2} (imperfective - incomplete action), [p]{.w2}
   (perfective; completed action), [f]{.w2} (future), [o]{.w2}
   (optative; desire/intention), which may be combined with a [+]{.w2}
   (positive, _default_), or [-]{.w2} (negative). Note that _tense_
   (when an action was performed) in Athabascan is not indicated
   independently from _mode_, as it is in English.  Perfective conveys
   past completion, imperfective conveys ongoing in present, and
   future conveys actions in the future
   ([ref](http://qenaga.org/verbs_and_sentences/aspects.html)).
 * [prd]{.bl} [\<person\>]{.w2} [TEXT]{.txt} _(1-to-many)_ : Paradigm
   example, one line for each person, where [\<person\>]{.w2} is one
   of: [1s]{.w2} (first person singular), [2s]{.w2} (second person
   singular), [3s]{.w2} (third person singular), [1p]{.w2} (first
   person plural), [2p]{.w2} (second person plural), [3p]{.w2} (third
   person plural), [1d]{.w2} (first person dual), [2d]{.w2} (second
   person dual), [3d]{.w2} (third person dual), ind
   (indefinite). [TEXT]{.txt} is the row of words, in same order as
   the column definition in [...prds]{.bl}. If an entry (cell) should
   be two words, use an underscore (‘\_’) in place of a space between
   words; in this way, spaces are reserved for column (field)
   delimiters. A missing element in the matrix is indicated with a
   dash (‘-’).
 * [prdgl]{.bl} [TEXT]{.txt} _(0-to-1, following a_ [prd]{.bl}_)_ :
   Paradigm gloss

Word categories {#h.wc}
---------------------------

 * [\<gc2\>]{.bl} [TEXT]{.txt} _(exactly-1)_ : Word category, where
   [\<gc2\>]{.bl} is either: **A stem**: one of: [..adj]{.bl}
   (adjective, _adj._), [..ads]{.bl} (aspectual derivational string,
   _a.d.s._), [..adv]{.bl} (adverb, _adv._), [..an]{.bl} (areal noun,
   _a.n._), [..c]{.bl} (compounding form, _c._), [..cnj]{.bl}
   (conjunction, _cnj._), [..coll]{.bl} (collocation, _coll._),
   [..dem]{.bl} (demonstrative, _dem._), [..dir]{.bl} (directional,
   _dir._), [..enc]{.bl} (enclitic, _enc._), [..exc]{.bl}
   (exclamation, _exc._), [..i]{.bl} (incorporate, _i._), [..ic]{.bl}
   (incorporate compound, _ic._), [..in]{.bl} (instrumental noun,
   _ins.n._), [..int]{.bl} (interrogative, _int._), [..mpn]{.bl}
   (major place name, _m.p.n._), [..n]{.bl} (noun, _n._), [..nc]{.bl}
   (noun, compound, _n.c._), [..ni]{.bl} (noun, incorporate, _n.i._),
   [..nic]{.bl} (noun, incorporate compound, _n.i.c._), [..nenc]{.bl}
   (noun enclitic, _n.enc._), [..padj]{.bl} (predicate adjective,
   _p.adj._), [..pf]{.bl} (prefix, _pf._), [..pn]{.bl} (place name,
   _p.n._), [..psn]{.bl} (personal name, _ps.n._), [..pp]{.bl}
   (postposition, _pp._), [..pro]{.bl} (pronoun, _pro._),
   [..scnj]{.bl} (subordinating conjunction, _s.cnj._), [..venc]{.bl}
   (verb enclitic, _v.enc._), [..voc]{.bl} (vocative, _voc._); a
   **noun affix**: [..nsf]{.bl} (Noun suffix), [..sf]{.bl} (Suffix),
   [..nfaf]{.bl} (Noun formation affix), [..nfsf]{.bl} (Noun formation
   suffix); a **verb affix**: [..vsf1]{.bl} (Verb suffix 1, _v.sf1._),
   [..vsf ]{.bl}(Verb suffix, _v.sf._), [..nds]{.bl} (Non-derivational
   string, _n.d.s._), [..vfaf]{.bl} (Verb formation affix),
   [..vfsf]{.bl} (Verb formation suffix), [..vpf]{.bl} (Verb prefix,
   _v.pf._), [..ads]{.bl} (aspectual derivational string, _a.d.s._);
   or a **theme formation string**: [..tfs]{.bl}.
 * [Word category attributes](#h.wca) _(exactly-1)_
 * [Examples](#h.ex) _(0-to-many)_
 * [Word sub-categories](#h.wc2) _(0-to-many)_
 * ( [Subthemes](#h.th) _(0-to-many)_, only for [..tfs]{.bl} ) 

### Word category attributes {#h.wca}

 * [Dialect](#h.dial) _(0-to-1)_
 * ( [tc]{.bl} [\<tctype\>]{.w2} _(0-to-1)_ : Theme category, see
   [Themes](#h.th), for [..ads]{.bl}, [\...ads]{.bl}, and [..tfs]{.bl}
   only )
 * ( [asp]{.bl} [TEXT]{.txt} _(0-to-1)_ : Aspect, for [..ads]{.bl},
   [\...ads]{.bl}, and [..tfs]{.bl} only )
 * ( [cnj]{.bl} [TEXT]{.txt} _(0-to-1)_ : Conjugation prefix, for
   [..ads]{.bl}, [\...ads]{.bl}, and [..tfs]{.bl} only )
 * [Gloss](#h.gl) _(exactly-1)_ : English gloss
 * [smf]{.bl} [TEXT]{.txt} _(0-to-1)_ : Semantic field
 * [sc]{.bl} [TEXT]{.txt} _(0-to-1)_ : Scientific name
 * [lit]{.bl} [TEXT]{.txt} _(0-to-1)_ : Literal translation

### Word sub-categories {#h.wc2}

 * [\<gc3\>]{.bl} [TEXT]{.txt} _(exactly-1)_ : Word category, where
   [\<gc3\>]{.bl} is one of: [\...adj]{.bl} (adjective, _adj._),
   [\...ads]{.bl} (aspectual derivational string, _a.d.s._),
   [\...adv]{.bl} (adverb, _adv._), [\...an]{.bl} (areal noun,
   _a.n._), [\...c]{.bl} (compounding form, _c._), [\...cnj]{.bl}
   (conjunction, _cnj._), [\...coll]{.bl} (collocation, _coll._),
   [\...dem]{.bl} (demonstrative, _dem._), [\...dir]{.bl}
   (directional, _dir._), [\...drt]{.bl} (derived root, _der.rt._;
   only at sub-entry level), [\...enc]{.bl} (enclitic, _enc._),
   [\...exc]{.bl} (exclamation, _exc._), [\...i]{.bl} (incorporate,
   _i._), [\...ic]{.bl} (incorporate compound, _ic._), [\...in]{.bl}
   (instrumental noun, _ins.n._), [\...int]{.bl} (interrogative,
   _int._), [\...n]{.bl} (noun, _n._), [\...nc]{.bl} (noun, compound,
   _n.c._), [\...ni]{.bl} (noun, incorporate, _n.i._), [\...nic]{.bl}
   (noun, incorporate compound, _n.i.c._), [\...nenc]{.bl} (noun
   enclitic, _n.enc._), [\...mpn]{.bl} (major place name, _m.p.n._),
   [\...padj]{.bl} (predicate adjective, _p.adj._), [\...pf]{.bl}
   (prefix, _pf._), [\...pn]{.bl} (place name, _p.n._), [\...psn]{.bl}
   (personal name, _ps.n._), [\...pp]{.bl} (postposition, _pp._),
   [\...pro]{.bl} (pronoun, _pro._), [\...sf]{.bl} (suffix, _sf._),
   [\...scnj]{.bl} (subordinating conjunction, _s.cnj._),
   [\...venc]{.bl} (verb enclitic, _v.enc._), [\...voc]{.bl}
   (vocative, _voc._). An Inflectional String, [\...ifs]{.bl}, may
   occur under some _verb affix_ word categories.
 * [Word category attributes](#h.wca) _(exactly-1)_

## Loan word {#h.lw}

 * [.lw]{.bl} [TEXT]{.txt} (exactly-1) : Loan word
 * [src]{.bl} [TEXT]{.txt} (exactly-1) : Source language
 * [Word categories](#h.wc) _(0-to-many)_

## References

Kari, J. 2012. Guide to Using the Koyukon Athabaskan Dictionary.
_In_: Koyukon Athabaskan Dictionary, J. Jette. & E. Jones. 

Rice, K.D. 2015. The start of a glossary of Athabaskan vocabulary.
Linguistic Institute.

Urschel, J.M. 2006. Lower Tanana Athabascan Verb Paradigms. MSc.
Thesis, University of Alaska, Fairbanks.

## Appendix 1: A note concerning different rootword classes {#h.a1}

There are three band labels Jim uses for different kinds of rootword:
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

This recognition lead to a new, less specifi strategy for validation: to
treat [.rt]{.bl}, [.af]{.bl}, [.ra]{.bl} with the _same_ rule set:
let any double-dot word category be under any single-dot band. This
document was rewritten (2020-04-15) to reflect this change. 
