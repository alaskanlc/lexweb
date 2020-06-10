/*
 * @OnlyCurrentDoc
 */

function onOpen() {
  DocumentApp.getUi().createMenu('Lexware')
  .addItem('Insert Ł', 'insertŁ')
  .addToUi();
}

// really too cumbersome to use menus, and GAS currently does not support keyboard shortcuts
function insertŁ(){
  var doc=DocumentApp.getActiveDocument();
  doc.getCursor().insertText('Ł');
  doc.setCursor(doc.newPosition(doc.getCursor().getElement(), doc.getCursor().getOffset() +1));
}
