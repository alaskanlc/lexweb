/*
 * @OnlyCurrentDoc
 */

function onOpen() {
  DocumentApp.getUi().createMenu('Lexware')
  .addItem('Colorize', 'colorize')
  .addToUi();
}

function colorize() {

  var para = DocumentApp.getActiveDocument().getParagraphs();
  var bl =  [ { re: "^\\.rt",            col: "#FF0000", sty: "b" },
              { re: "^\\.\\.\\.?[^. ]+", col: "#FF9900", sty: "i" },
              { re: "^[^. ]+",           col: "#6686B9", sty: ""  },
              { re: "^#",                col: "#B7B7B7", sty: "c" } ];
  var i, j ;
  var textLocation = {} ;

  for (i=0; i< para.length; ++i) {
    for (j=0; j< bl.length; j++) {
 
      textLocation = para[i].findText(bl[j].re);
      if (textLocation != null && textLocation.getStartOffset() != -1) {
        // bold/italic the whole band
        if (bl[j].sty == 'b') {
          para[i].editAsText().setBold(true);
        }
        else if (bl[j].sty == 'i') {
          para[i].editAsText().setItalic(true); 
        }
        else if (bl[j].sty == 'c') {
          para[i].editAsText().setForegroundColor(bl[j].col); 
        }
        
        // color and bolden band labels
        textLocation.getElement().setForegroundColor(textLocation.getStartOffset(),textLocation.getEndOffsetInclusive(), bl[j].col);
        textLocation.getElement().setBold(textLocation.getStartOffset(),textLocation.getEndOffsetInclusive(), true);        
      }
    }
  }
}

