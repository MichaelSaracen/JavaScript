import QtQuick
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts

import App.Constants

import Generated.Effects.ColorOverlay 1.0

import "../../js/index.js" as Index
import "../../js/menuBar/File.js" as File


Rectangle {
    id: shapeToolBar
    width: 685
    height: 50
    color: Theme.background
    border.width: 1
    border.color: Theme.borderColor


    property alias strokeStyle: rectangleLineColor.color
    property alias fillStyle: rectangleFillColor.color
    property alias lineWidth: spinBoxLineWidth.value
    property alias shapeWidth: textFieldWidth.text
    property alias shapeHeight: textFieldHeight.text
    property alias arcTo: spinBoxArcTo.value
    property alias arcFrom: spinBoxArcFrom.value

    //property alias text: textFieldText.text
    property alias borderRadius: spinBoxRadius.value
    property font font: Qt.font( {family: "Roboto", pixelSize: 9} );
    property alias buttonItemFill: buttonItemFill
    property alias buttonDisplayPositioner: buttonDisplayPositioner
    property alias textFieldWidthValue: textFieldWidth.text
    property alias textFieldHeightValue: textFieldHeight.text
    property alias spinBoxZStack: spinBoxZStack

    property var currentItem: null

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        RoundButton {
            id: buttonItemFill
            visible: shapeBar.currentShape === ShapeBar.Shape.Selection
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/resize.png"
            flat: true
            enabled: shapeToolBar.currentItem

            ToolTip.visible: hovered
            ToolTip.text: "Item Ausfüllen"
            ToolTip.delay: 1000

            ColorOverlay {
                colorOverlayColor: buttonItemFill.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }

            onClicked: {
                if ( currentItem ) {
                    currentItem.setGeometry( 0, 0, canvasEngine.width , canvasEngine.height );
                    canvasEngine.itemFilled(currentItem.isFilled())
                }


            }
        }

        RowLayout {
            visible: currentItem && currentItem.selected && shapeBar.currentShape === ShapeBar.Shape.Selection
            Label {
                text: qsTr("Z-Stack")
                font.pixelSize: 9
            }

            SpinBox {
                id: spinBoxZStack
                value: 0
                from: 0
                wheelEnabled: true
                topPadding: 0
                font.pointSize: 8
                bottomPadding: 0
                Layout.preferredWidth: 80
                Layout.preferredHeight: 30
                to: canvasEngine.items.length - 1
                onValueModified: {
                    if( currentItem ) {
                        canvasEngine.itemZStack(value)
                    }
                }

            }
        }


        RowLayout {
            visible: shapeBar.currentShape !== ShapeBar.Shape.Selection && shapeBar.currentShape !== ShapeBar.Shape.Pen
            Label {
                text: qsTr("Breite")
                font.pixelSize: 9
            }
            TextField {
                id: textFieldWidth
                text: "100"
                rightPadding: 4
                leftPadding: 4
                bottomPadding: 0
                topPadding: 0
                Layout.preferredHeight: 30
                Layout.preferredWidth: 40
                font.pixelSize: 9
                maximumLength: 4
                validator: RegularExpressionValidator {
                    regularExpression: /^[0-9]+$/
                }
            }
        }
        RowLayout {
            visible: shapeBar.currentShape !== ShapeBar.Shape.Selection && shapeBar.currentShape !== ShapeBar.Shape.Pen
            Label {
                text: qsTr("Höhe")
                font.pixelSize: 9
            }
            TextField {
                id: textFieldHeight
                text: "100"
                rightPadding: 4
                leftPadding: 4
                bottomPadding: 0
                topPadding: 0
                Layout.preferredHeight: 30
                Layout.preferredWidth: 40
                font.pixelSize: 9
                maximumLength: 4
                validator: RegularExpressionValidator {
                    regularExpression: /^[0-9]+$/
                }
            }
        }
        
        RowLayout {
            visible: shapeBar.currentShape !== ShapeBar.Shape.Image && shapeBar.currentShape !== ShapeBar.Shape.Eraser && shapeBar.currentShape !== ShapeBar.Shape.Selection
            Label {
                text: qsTr("Linien-Breite")
                font.pixelSize: 9
            }
            SpinBox {
                id: spinBoxLineWidth
                value: 1
                wheelEnabled: true
                topPadding: 0
                font.pointSize: 8
                bottomPadding: 0
                Layout.preferredWidth: 80
                Layout.preferredHeight: 30
                to: 100
            }
        }
        
        RowLayout {
            visible: shapeBar.currentShape === ShapeBar.Shape.Rect
            Label {
                text: qsTr("Radius")
                font.pixelSize: 9
            }
            SpinBox {
                id: spinBoxRadius
                value: 0
                wheelEnabled: true
                topPadding: 0
                font.pointSize: 8
                bottomPadding: 0
                Layout.preferredWidth: 80
                Layout.preferredHeight: 30
                to: 100
            }
        }
        
        RowLayout {
            visible: shapeBar.currentShape === ShapeBar.Shape.Arc || shapeBar.currentShape === ShapeBar.Shape.Pie
            Label {
                text: qsTr("von")
                font.pixelSize: 9
            }
            SpinBox {
                id: spinBoxArcFrom
                value: 0
                wheelEnabled: true
                topPadding: 0
                font.pointSize: 8
                bottomPadding: 0
                Layout.preferredWidth: 80
                Layout.preferredHeight: 30
                to: 360
            }
        }
        
        RowLayout {
            visible: shapeBar.currentShape === ShapeBar.Shape.Arc || shapeBar.currentShape === ShapeBar.Shape.Pie
            Label {
                text: qsTr("bis")
                font.pixelSize: 9
            }
            SpinBox {
                id: spinBoxArcTo
                value: 270
                wheelEnabled: true
                topPadding: 0
                font.pointSize: 8
                bottomPadding: 0
                Layout.preferredWidth: 80
                Layout.preferredHeight: 30
                to: 360
            }
        }
        
        
        RowLayout {
            visible: shapeBar.currentShape !== ShapeBar.Shape.Image && shapeBar.currentShape !== ShapeBar.Shape.Eraser && shapeBar.currentShape !== ShapeBar.Shape.Selection
            Label {
                text: qsTr("Linie")
                font.pixelSize: 9
            }
            Rectangle {
                id: rectangleLineColor
                border.width: 2
                border.color: Theme.foreground
                Layout.preferredHeight: 30
                Layout.preferredWidth: 30
                color: "black"
                MouseArea {
                    anchors.fill: parent
                    onClicked: lineColorDialog.open()
                }
            }
            ColorDialog {
                id: lineColorDialog
                onAccepted: {
                    rectangleLineColor.color = selectedColor
                }
            }
        }
        
        RowLayout {
            visible: shapeBar.currentShape !== ShapeBar.Shape.Image && shapeBar.currentShape !== ShapeBar.Shape.Eraser && shapeBar.currentShape !== ShapeBar.Shape.Pen && shapeBar.currentShape !== ShapeBar.Shape.Selection
            Label {
                text: qsTr("Füllung")
                font.pixelSize: 9
            }
            Rectangle {
                id: rectangleFillColor
                border.width: 2
                border.color: Theme.foreground
                Layout.preferredHeight: 30
                Layout.preferredWidth: 30
                MouseArea {
                    anchors.fill: parent
                    onClicked: fillColorDialog.open()
                }
            }
            ColorDialog {
                id: fillColorDialog
                onAccepted: {
                    rectangleFillColor.color = selectedColor
                }
            }
        }
        

        RoundButton {
            id: buttonLoadImage
            visible: shapeBar.currentShape === ShapeBar.Shape.Image
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/add_image.png"
            flat: true
            //enabled: shapeToolBar.currentItem

            ToolTip.visible: hovered
            ToolTip.text: "Item Ausfüllen"
            ToolTip.delay: 1000

            ColorOverlay {
                colorOverlayColor: buttonLoadImage.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }

            onClicked: {
                File.openImageDialog();

            }

        }
        
        Item {
            Layout.fillWidth: true
        }
        RoundButton {
            id: buttonDisplayPositioner
            visible: shapeBar.currentShape === ShapeBar.Shape.Selection
            radius: 8
            // Icon -> Google Material Icons -> https://fonts.google.com/icons
            icon.source: "../../assets/icons/positioner.png"
            flat: true
            enabled: shapeToolBar.currentItem
            checkable: true

            ToolTip.visible: hovered
            ToolTip.text: "Positionierer ein / ausblenden"
            ToolTip.delay: 1000

            ColorOverlay {
                colorOverlayColor: buttonDisplayPositioner.checked ? Theme.highlight : "transparent"
                Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
            }


        }
    }
}
