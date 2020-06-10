# Google Apps Script

Using the Javascript build into Google Apps (e.g., GoogleDocs),
Lexware files can be colorized to assist in editing.

Steps:

 1. Paste Lexware into a new GoogleDocs file. To compact the lines a
    bit, go to the `Line spacing` tool on the toolbar and select “Remove
    space after paragraph”.
 2. Go to menu `Tools -> Script editor`.
 3. Delete `function myFunction() { ... }`.
 4. Copy the code from [this file](colorize.js) into the code editor.
 5. Save (name is not important, but maybe use “Colorize lexware”).
 6. Close the script editor tab in your browser.
 7. Close the Lexware file.
 8. Reopen the Lexware file. A dialog will ask you to authorize the
    script you have just created.
 9. Select menu `Lexware -> Colorize` and colors will be applied.
 10. Repeat step 9. whenever new text has been added.
 
The GoogleDoc can be used as a concurrent versioning system with other
contributors. 

To process the text using these Lexweb tools, the text
will need to be Downloaded as **Plain text**, not as a `.docx` file.
