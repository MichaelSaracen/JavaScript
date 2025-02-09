import QtQuick
import QtQuick.Controls
import App.Constants
import QtQuick.Layouts

import Generated.Effects.ColorOverlay 1.0

import "../../js/index.js" as Index

Rectangle {
    id: shapeBar
    width: columnLayoutShapes.implicitWidth
    height: columnLayoutShapes.implicitHeight

    color: Theme.background
    border.width: 1
    border.color: Theme.borderColor

    enum Shape {
        Selection,
        Pen,
        Rect,
        Ellipse,
        Arc,
        Pie,
        Image,
        Eraser
    }

    property int currentShape: ShapeBar.Shape.Selection
    property string currentText: "Auswahl"

    ButtonGroup {
        buttons: columnLayoutShapes.children.filter((child) => child instanceof RoundButton )
        onClicked: (button) => {
                       shapeBar.currentShape = buttons.indexOf(button);

                       switch (shapeBar.currentShape) {
                           case ShapeBar.Shape.Selection:
                           shapeBar.currentText = "Auswahl";
                           break;
                           case ShapeBar.Shape.Pen:
                           shapeBar.currentText = "Stift";
                           break;
                           case ShapeBar.Shape.Rect:
                           shapeBar.currentText = "Rechteck";
                           break;
                           case ShapeBar.Shape.Ellipse:
                           shapeBar.currentText = "Ellipse";
                           break;
                           case ShapeBar.Shape.Arc:
                           shapeBar.currentText = "Bogen";
                           break;
                           case ShapeBar.Shape.Pie:
                           shapeBar.currentText = "Pie";
                           break;
                           case ShapeBar.Shape.Image:
                           shapeBar.currentText = "Bild";
                           break;
                           case ShapeBar.Shape.Eraser:
                           shapeBar.currentText = "Radiergummi - Werkzeug";
                           break;
                       }
                       Index.unselectLast();
                   }
    }
    
    

    
    ColumnLayout {
        id: columnLayoutShapes
        anchors.fill: parent
        spacing: 0

        RoundButton {
            id: buttonCursorMode
            visible: true
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/cursor.png"
            flat: true
            checkable: true
            checked: currentShape === ShapeBar.Shape.Selection;

            ToolTip.visible: hovered
            ToolTip.text: "Auswahl"
            ToolTip.delay: 1000

            ColorOverlay {
                colorOverlayColor: buttonCursorMode.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }
        }

        RoundButton {
            id: buttonPenMode
            visible: true
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/pen.png"
            flat: true
            checkable: true
            
            ToolTip.visible: hovered
            ToolTip.text: "Frei zeichnen"
            ToolTip.delay: 1000
            
            ColorOverlay {
                colorOverlayColor: buttonPenMode.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }
        }
        RoundButton {
            id: buttonRectMode
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/rect.png"
            flat: true
            checkable: true
            
            ToolTip.visible: hovered
            ToolTip.text: "Rechteck zeichnen"
            ToolTip.delay: 1000
            
            ColorOverlay {
                colorOverlayColor: buttonRectMode.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }
        }
        RoundButton {
            id: buttonEllipseMode
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/circle.png"
            flat: true
            checkable: true
            
            ToolTip.visible: hovered
            ToolTip.text: "Ellipse zeichnen"
            ToolTip.delay: 1000
            
            ColorOverlay {
                colorOverlayColor: buttonEllipseMode.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }
        }
        RoundButton {
            id: buttonArcMode
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/arc.png"
            flat: true
            checkable: true
            
            ToolTip.visible: hovered
            ToolTip.text: "Bogen zeichnen"
            ToolTip.delay: 1000
            
            ColorOverlay {
                colorOverlayColor: buttonArcMode.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }
        }
        RoundButton {
            id: buttonPieMode
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/pie.png"
            flat: true
            checkable: true
            
            ToolTip.visible: hovered
            ToolTip.text: "Pie zeichnen"
            ToolTip.delay: 1000
            
            ColorOverlay {
                colorOverlayColor: buttonPieMode.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }
        }
        
        RoundButton {
            id: buttonImageMode
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/image.png"
            flat: true
            checkable: true
            
            ToolTip.visible: hovered
            ToolTip.text: "Bild hinzufügen"
            ToolTip.delay: 1000
            
            ColorOverlay {
                colorOverlayColor: buttonImageMode.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }
        }
        
        RoundButton {
            id: buttonEraseMode
            visible: false
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/eraser.png"
            flat: true
            checkable: true
            ToolTip.visible: hovered
            ToolTip.text: "Radierer"
            ToolTip.delay: 1000
            
            ColorOverlay {
                colorOverlayColor: buttonEraseMode.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }
        }
    }
    
}
