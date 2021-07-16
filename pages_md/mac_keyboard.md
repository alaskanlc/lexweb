% Mac keyboard layout for Gwich’in

# Mac keyboard layout for Gwich’in

This page offers a keyboard layout file to assist with Gwich’in
diacritics, plus installation and usage instructions.

## Background

Current convention for Gwich’in transcription uses several unusual
diacritics added Latin characters (graphemes) to represent low and
nasal vowel tones.  While single Unicode characters exist for low
tones (grave accented vowels) and nasals (vowels with ogneks), no
single Unicode characters exist for the combination of both (e.g., ą̀),
and Unicode combining characters must be used. See the table below for
the characters codes used.  These combining Unicode characters should
display correctly in most situations, but please not that some fonts
and applications may displace the combining character to the left or
right.

## Installation

### 1. Download keyboard file

First download this ZIP file called
[Gwichin_keylayout.zip](../files/Gwichin_keylayout.zip) (Hold down the
Control key, and then click on the link and ‘Save
As...’). Double-click on the downloaded file to unzip it.

### 2. Copy to Library

Next you need to get the `Gwichin.keylayout` file to the `Keyboard
Layouts` folder in the `Library` folder.

**Method 1: Using the Finder**

Mac hides the `Library` folder from you usually, but you can see it
this way: In the Finder:

 1. Find the `Gwichin.keylayout` file you just downloaded. It may not
    be called `Gwichin.keylayout`, but just `Gwichin` because Mac may
    hide the suffix from you. Copy the file (Command-C).
 2. Hold down the Option (aka Alt) key, and click on the Go menu item;
    you should see ‘Library’ listed - click on it.
 3. Find the `Keyboard Layouts` folder and paste the file inside that
    folder (Command-V).

**Method 2: Using Ukelele**

Ukelele is a SIL program for editing keyboard layouts. It was used to
create this Gwich’in layout file. It is not needed for the
installation of the file, but provides an alternative method if the
above method does not work.

 1. Download the
    [latest version](https://software.sil.org/ukelele/#downloads) of
    Ukelele and install as directed.
 2. Open the `Gwichin.keylayout` file, with ‘Open’ in the File menu. A
    keyboard should appear, with ‘Gwich’in’ in its window’s title
    bar. You can click on the Modifier keys (see below) to see how the
    main keys are affected.
 3. In the file menu, select ‘Install...’ -> ‘Show organizer’
 4. Drag ‘Gwichin’ from the first pane to the third pane.

### 3. Activate the keyboard layout

Finally, restart your Mac. This is not necessarily needed, but should
ensure that the new keylayout file is found.

Then go the System Preferences, and click on Keyboard.  Make sure the
‘Show Input menu in menu bar’ box is checked. In the ‘Input Sources’
tab, click on ‘+’ to add a new source. Scroll down and click on
‘Others’. You should see ‘Gwich’in’ listed. Click on it.  It will now
appear in the Keyboard Layout menu (the flag) in the top menubar.

## Usage

When you want to input Gwich’in diacritic characters, click on the
flag in the top-right of the menu bar, and select ‘Gwich’in’. Go to
the document you are editing. All normal (small) characters, and Shift
(capital) characters are still available as usual, and the usual
Command characters (e.g. Command-Tab for switch window) still
work. But certain combinations of Control and Option will give
Gwich’in diacritics to certain keys:

```
 OPT       + a -> ą   U+0105
       CTL + a -> à   U+00E0
 OPT + CTL + a -> ą̀   U+0105 U+0300 (combining grave)

 OPT       + e -> ę   U+0119
       CTL + e -> è   U+00E8
 OPT + CTL + e -> ę̀   U+0119 U+0300 (combining grave)

 OPT       + i -> į   U+012F
       CTL + i -> ì   U+00EC
 OPT + CTL + i -> į̀   U+00EC U+0328 (combining ognek)

 OPT       + o -> ǫ   U+01EB
       CTL + o -> ò   U+00F2
 OPT + CTL + o -> ̀ǫ   U+01EB U+0300 (combining grave)

 OPT       + u -> ų   U+0173
       CTL + u -> ù   U+00F9
 OPT + CTL + u -> ų̀   U+0173 U+0300 (combining grave)

 OPT        + l -> ł  U+0142
 OPT + SHFT + l -> Ł  U+0141 
```

## Use with Microsoft Word

Some of the current default key bindings in Microsoft Word duplicate
standard Command key usages (e.g. CMD + i = italicize) with the
Control key (CTL + i = italicize), probably because Windows users have
learned the Control key bindings.  This use of the Control key clashes
with the above key bindings for CTL + a, i, and u. To use the
Gwich’in bindings in Word you must deactivate the CTL combinations:

1. Select the ‘Tool’ drop down menu. Select ‘Customize
   Keyboard’. Select ‘All Commands’ in the menu on the left in the
   pop-up window.  
2. In search, type in ‘italicize’. In the list of
   commands select ‘Control + i’ and hit the 'remove’ button.
3. In search type in ‘underline’. In the list of commands select 
   ‘Control + u’ and hit ‘remove’ button.
4. In search type in ‘selectall’. In the list of commands select 
   ‘Control + a’ and hit ‘remove’ button.
5. Hit ‘OK’ in the pop-up window to accept all the changes that were made.

(Thanks to Evon Peter for discovering and finding the fix for this.) 
