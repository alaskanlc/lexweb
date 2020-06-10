/*
 * @OnlyCurrentDoc
 */

function onOpen() {
  DocumentApp.getUi().createMenu('Lexware')
  .addItem('Colorize', 'colorize')
  .addToUi();
}

function colorize() {

  var paras = DocumentApp.getActiveDocument().getParagraphs();
  let bl =  ['^\\.rt'  , '^\\.\\.\\.?[^. ]+', '^[^. ]+', '^#'      ];
  let blc = ['#FF0000' , '#FF9900'          , '#6686b9', '#b7b7b7' ];
  let blb = ['b'       , 'i'                , ''       , 'c'       ];
  var textLocation = {};
  var i, j ;

  for (i=0; i< paras.length; ++i) {
    for (j=0; j< bl.length; j++) {
 
      textLocation = paras[i].findText(bl[j]);
      if (textLocation != null && textLocation.getStartOffset() != -1) {
        // bold/italic the whole band
        if (blb[j] == 'b') {
          paras[i].editAsText().setBold(true);
        }
        else if (blb[j] == 'i') {
          paras[i].editAsText().setItalic(true); 
        }
        else if (blb[j] == 'c') {
          paras[i].editAsText().setForegroundColor('#b7b7b7'); 
        }
        
        // color band labels
        textLocation.getElement().setForegroundColor(textLocation.getStartOffset(),textLocation.getEndOffsetInclusive(), blc[j]);
        textLocation.getElement().setBold(textLocation.getStartOffset(),textLocation.getEndOffsetInclusive(), true);        
      }
    }
  }
}
