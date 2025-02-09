import QtQuick
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtCore

import "../../js/menuBar/File.js" as File
import "../../js/index.js" as Index

import App.Constants
import App.Bars
import App.Components



MenuBar {
    id: menuBar
    height: 40
    font.pointSize: 9
    Material.background: Theme.background

    property color rasterColor: "black"
    property alias menuEdit: menuEdit
    property alias actionSave: actionSave

    property bool helpOpen: false


    Settings {
        id: menuSettings
    }
    
    Menu {
        verticalPadding: 0
        topPadding: 0
        
        clip: false
        bottomPadding: 0
        
        font.pointSize: 9
        Material.background: Theme.background
        title: qsTr('&Datei')


        Action { text: 'Neu'; onTriggered: File.openNewImageDialog(); shortcut: "Ctrl+N"}
        Action { text: 'Öffnen'; onTriggered: { File.openImageDialog() }
            shortcut: "Ctrl+O"  }
        Action { id: actionSave;
            text: 'Speichern'
            enabled: canvasEngine.items.length > 0;
            shortcut: "Ctrl+S"
            onTriggered: {
                if ( canvasEngine.lastItem ) {
                    //canvasEngine.lastItem.unselect();
                }
                saveImageDialog.open();
            }
        }
        MenuSeparator { }
        Action { text: 'Beenden'; onTriggered: app.close(); shortcut: "Ctrl+B" }
        
    }
    
    Menu {
        font.pointSize: 9
        Material.background: Theme.background
        title: qsTr('&Ansicht')
        Action { text: Theme.darkMode ? "Light - Mode" : "Dark - Mode"; onTriggered: Theme.darkMode = !Theme.darkMode; shortcut: "F2"}
        MenuSeparator { }
        Action { text: "Maximal hineinzoomen"; onTriggered: app.painterAreaItem.scaleFactor = 3; shortcut: "Ctrl++"}
        Action { text: "Zoom Normal"; onTriggered: app.painterAreaItem.scaleFactor = 1; shortcut: "Ctrl+#"}
        Action { text: "Maximal herauszoomen"; onTriggered: app.painterAreaItem.scaleFactor = 0.5; shortcut: "Ctrl+-"}




        MenuSeparator { }
        Action { id: filterAction;  text: filterItem.visible ? "Filter ausblenden" : "Filter einblenden";
            onTriggered: {
                filterItem.visible = !filterItem.visible;
            }

            shortcut: "F3"}


        Action { text: shapeBar.visible ? "Formen ausblenden" : "Formen einblenden"; onTriggered: shapeBar.visible = !shapeBar.visible; shortcut: "F4"}


        Action { text: imageBar.visible ? "Bild Optionen ausblenden" : "Bild Optionen einblenden"; onTriggered: imageBar.visible = !imageBar.visible; shortcut: "F5"}


        Action { text: itemInformation.visible ? "Item Informationen ausblenden" : "Item Informationen einblenden";
            onTriggered: {
                itemInformation.visible = !itemInformation.visible;
            }

            shortcut: "F6"}

        MenuSeparator { }
        Action { text:  "Raster Farbe" ; onTriggered: rasterColorDialog.open(); shortcut: "F7"}
        MenuSeparator { }
        Action { text: "Normal"; enabled:app.visibility !== Window.Windowed; onTriggered: app.visibility = Window.Windowed; shortcut: "F9"}
        Action { text: "Minimieren"; onTriggered: app.visibility = Window.Minimized; shortcut: "F10"}
        Action { text: "Maximieren"; enabled:app.visibility !== Window.Maximized; onTriggered: app.visibility = Window.Maximized; shortcut: "F11"}
        Action { text: "Vollbild"; enabled:app.visibility !== Window.FullScreen;  onTriggered: app.visibility = Window.FullScreen; shortcut: "F12" }
    }
    Menu {
        id: menuEdit
        enabled: canvasEngine.items.length > 0
        font.pointSize: 9
        Material.background: Theme.background
        title: qsTr('&Bearbeiten')
        Menu {
            title: qsTr('&RenderHints')
            font.pointSize: 9
            Material.background: Theme.background
            Action { text: "Antialiasing"; onTriggered: {canvasEngine.setRenderHint(CanvasEngine.Antialiasing); Index.redraw()} }
            Action { text: "TextAntialiasing"; onTriggered: {canvasEngine.setRenderHint(CanvasEngine.TextAntialiasing); Index.redraw()} }
            Action { text: "SmoothPixmapTransform"; onTriggered: {canvasEngine.setRenderHint(CanvasEngine.SmoothPixmapTransform); Index.redraw()} }
            Action { text: "VerticalSubpixelPositioning"; onTriggered: {canvasEngine.setRenderHint(CanvasEngine.VerticalSubpixelPositioning); Index.redraw()} }
            Action { text: "LosslessImageRendering"; onTriggered: {canvasEngine.setRenderHint(CanvasEngine.LosslessImageRendering); Index.redraw()} }
            Action { text: "NonConstMetaTypeInterface"; onTriggered: {canvasEngine.setRenderHint(CanvasEngine.NonConstMetaTypeInterface); Index.redraw()} }
        }
    }
    

    
    Menu {
        id: actiondShortCuts
        font.pointSize: 9
        Material.background: Theme.background
        title: qsTr('&Hilfe')
        Action { text: "Tastenkürzel"; shortcut: "F1"; onTriggered: File.openKeyboardShortCuts(); }
    }


    ColorDialog {
        id: rasterColorDialog
        selectedColor: "black"
        onAccepted: {
            menuBar.rasterColor = selectedColor;
            Index.redraw();
        }
    }

    FileDialog {
        id: saveImageDialog
        fileMode: FileDialog.SaveFile
        nameFilters: ["Bild (*.png)"]
        onAccepted: {
            canvasEngine.saveImage(selectedFile)
        }
    }


}























