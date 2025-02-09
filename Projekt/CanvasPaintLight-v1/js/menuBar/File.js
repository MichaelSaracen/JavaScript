/* Alle Handles für die Menübar -> Datei
*
* */


/** Mit dieser Methode wird der Dialog zum Erstellen eines neuen Bildes geöffnet.
 * Für die Erstellung eines Bildes werden diese Eingaben entgegengenommen:
 * - Breite
 * - Höhe
 * - Farbmodus
 * - Hintergrund
 *
 * Das Erstellen erfolgt über die OK Schaltfläche.
 */
function openNewImageDialog() {
    if ( canvasEngine.lastItem ) {
        canvasEngine.lastItem.unselect();
    }
    const component = Qt.createComponent("../../App/Dialogs/NewImageDialog.qml");
    if(component.status === Component.Ready) {
        const obj = component.createObject(app);
        // Signal aus der NewImageDialog.qml -> submit(...)
        obj.onSubmit.connect( (w, h, clr) => {

                                 canvasEngine.width = w;
                                 canvasEngine.height = h;
                                 canvasEngine.createBackground(w,h, clr + "");
                                 canvasEngine.background = clr + "";
                                 Index.onCleared();


                             });
    }
}


/**
  *
  */
function openImageDialog() {
    const dialog = Qt.createQmlObject(`
                                      import QtQuick.Dialogs
                                      import App.Components
                                      import App.Bars
                                      import "../../js/index.js" as Index

                                      FileDialog {
                                      id: openImageDialog
                                      nameFilters: ["Bilder (*.png, *.jpg)"]
                                      onAccepted: {
                                      Index.createImage(canvasEngine.mid++, 0, 0, shapeToolBar.shapeWidth, shapeToolBar.shapeHeight, selectedFile);
                                      canvasEngine.mid++;
                                      }
                                      }
                                      `, canvasEngine);
    dialog.open();

}

/**
  * Öffnet das Fenster für die Tastenkürzel
  */
function openKeyboardShortCuts () {
    if ( !helpOpen ) {
        const component = Qt.createComponent("../../App/Dialogs/HelpDialog.qml");
        if(component.status === Component.Ready) {
            helpOpen = true;
            actiondShortCuts.enabled = false;
            const obj = component.createObject(app);
            obj.visible = true;
            obj.onClosing.connect( () =>  {actiondShortCuts.enabled = true; helpOpen = false; obj.destroy(); }  )

        }
    }

}





















