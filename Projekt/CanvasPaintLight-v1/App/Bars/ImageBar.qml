import QtQuick
import QtQuick.Controls
import App.Constants
import QtQuick.Layouts

import Generated.Effects.ColorOverlay 1.0

import "../../js/index.js" as Index


Rectangle {
    id: imageBar
    width: columnLayoutImage.implicitWidth
    height: columnLayoutImage.implicitHeight
    border.width: 1
    border.color: Theme.borderColor
    color: Theme.background

    property alias buttonGridMode: buttonGridMode
    property alias buttonCleanMode: buttonCleanMode


    Behavior on y {
        NumberAnimation {
            duration: 200
        }
    }

    
    ColumnLayout {
        id: columnLayoutImage
        anchors.fill: parent
        spacing: 0
        RoundButton {
            id: buttonCleanMode
            enabled: canvasEngine.items.length > 0
            visible: true
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/clean.png"
            flat: true
            
            ToolTip.visible: hovered
            ToolTip.text: "Bild leeren"
            ToolTip.delay: 1000

            onClicked: { canvasEngine.cleared(); }
        }
        RoundButton {
            id: buttonGridMode
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: checked ? "../../assets/icons/grid_on.png" :  "../../assets/icons/grid_off.png"
            flat: true
            checkable: true
            
            ToolTip.visible: hovered
            ToolTip.text: "Grid an / aus"
            ToolTip.delay: 1000
            
            ColorOverlay {
                colorOverlayColor: buttonGridMode.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }

            onClicked: { canvasEngine.drawGrid(); Index.redraw(); }
        }
        
    }
    
}
