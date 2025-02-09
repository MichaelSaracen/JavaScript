import QtQuick
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts
import QtCore

import "../../js/index.js" as Index
import Generated.Effects.ColorOverlay 1.0

import App.Constants
import App.Components
import App.Bars
import QtQuick.Controls 6.8


Rectangle {
    id: filterItem
    width: 271
    height: 345
    color: Theme.background
    border.width: 1
    border.color: Theme.borderColor
    enabled: canvasEngine.items.length > 0
    objectName: "filterItem"

    //property alias buttonFilterActive: buttonFilterActive
    
    ButtonGroup {
        buttons: gridLayoutFilterButtons.children.filter ( item => item instanceof RoundButton );
    }
    
    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        
        RowLayout {
            id: rowLayout
            width: 100
            height: 57
            
            Label {
                id: label
                text: qsTr("Filter")
                font.bold: true
                font.pointSize: 10
            }
            
            RoundButton {
                id: buttonFilterActive
                visible: true
                radius: 8
                // Icon -> Google Material Icons -> https://fonts.google.com/icons
                icon.source: checked ?  "../../assets/icons/filter_off.png" :  "../../assets/icons/filter_on.png"
                flat: true
                checkable: true
                
                
                
                ToolTip.visible: hovered
                ToolTip.text: "Filter an / aus"
                ToolTip.delay: 1000
                
                ColorOverlay {
                    colorOverlayColor: buttonFilterActive.checked ? Theme.highlight : "transparent"
                    Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
                }
                onClicked: {

                    console.log("Checked")

                    const canditates = app.mainContent.children.filter ( item => !(item instanceof FilterItem ) );
                    for ( const canditate of canditates ) {
                        canditate.enabled = !checked;
                    }
                    canvasEngine.enableFilter ( checked );

                    if ( canvasEngine.selectedItem && canvasEngine.filterIsActive() ) {
                        canvasEngine.selectedItem = null;

                    } else if ( canvasEngine.lastItem && !canvasEngine.filterIsActive() ) {
                        canvasEngine.itemSelected(canvasEngine.lastItem);
                    }
                }
            }
            
            RoundButton {
                id: buttoSaveFilter
                visible: true
                radius: 8
                checkable: false
                icon.source: "../../assets/icons/remove.png"   // Icon -> Google Material Icons -> https://fonts.google.com/icons
                flat: true
                ColorOverlay {
                    Behavior {
                        ColorAnimation {
                            duration: 300
                        }
                    }
                    colorOverlayColor: buttoSaveFilter.checked ? Theme.highlight : "transparent"
                }
                
                ToolTip.text: "Filter zurücksetzen"
                ToolTip.delay: 1000

                onClicked: {
                    canvasEngine.resetFilter();
                }
                
            }
            
        }
        
        GridLayout {
            id: gridLayout
            objectName: "gridLayoutFilter"
            enabled: buttonFilterActive.checked
            width: 100
            height: 100
            columns: 2
            Layout.preferredHeight: 30
            
            Label {
                id: label5
                text: qsTr("Graustufe")
                Layout.topMargin: 8
                font.pointSize: 9
                Layout.columnSpan: 2
            }
            Label {
                id: label6
                text: qsTr("Wert")
            }

            Slider {
                id: slider3
                width: 200
                height: 33
                value: 0
                topPadding: 0
                bottomPadding: 0
                Layout.preferredHeight: 20
                Layout.fillWidth: true
                to: 255
                from: 0
                onMoved: {
                    if ( canvasEngine.filterIsActive ) {
                        canvasEngine.grayscaleFilter ( value );
                    }
                }
            }


            Label {
                id: label7
                text: qsTr("Helligkeit")
                font.pointSize: 9
                Layout.topMargin: 8
                Layout.columnSpan: 2
            }


            Label {
                id: label8
                text: qsTr("Wert")
            }

            Slider {
                id: slider4
                width: 200
                height: 33
                value: 0
                topPadding: 0
                bottomPadding: 0
                Layout.preferredHeight: 20
                Layout.fillWidth: true
                to: 255
                from: -255
                onMoved: {
                    if ( canvasEngine.filterIsActive ) {
                        canvasEngine.applyBrightnessFilter ( value );
                    }
                }
            }

            Label {
                text: qsTr("Hervorheben")
                Layout.topMargin: 8
                font.pointSize: 9
                Layout.columnSpan: 2
            }




            GridLayout {
                id: gridLayoutFilterButtons
                columns: 3
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.columnSpan: 2
                RoundButton {
                    id: btnHighligtWhite
                    radius: 8
                    text: "Weiß"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    //icon.source: "../../assets/icons/resize.png"
                    flat: true
                    checkable: true

                    ToolTip.visible: hovered
                    ToolTip.text: "Weiß zeichnen"
                    ToolTip.delay: 1000

                    ColorOverlay {
                        colorOverlayColor: btnHighligtWhite.checked ? Theme.highlight : "transparent"
                        Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
                    }

                    onClicked: {
                        if ( canvasEngine.filterIsActive ) {
                            canvasEngine.highlightWhite ( btnHighligtWhite.checked );
                        }

                    }
                }

                RoundButton {
                    id: btnSepiaFilter
                    radius: 8
                    text: "Sepia"
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    //icon.source: "../../assets/icons/resize.png"
                    flat: true
                    checkable: true

                    ToolTip.visible: hovered
                    ToolTip.text: "Sepia Filter"
                    ToolTip.delay: 1000

                    ColorOverlay {
                        colorOverlayColor: btnSepiaFilter.checked ? Theme.highlight : "transparent"
                        Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
                    }

                    onClicked: {
                        if ( canvasEngine.filterIsActive ) {
                            canvasEngine.applySepiaFilder ( btnSepiaFilter.checked );
                        }

                    }
                }

                RoundButton {
                    id: btnInertFilter
                    radius: 8
                    text: "Invertieren"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    //icon.source: "../../assets/icons/resize.png"
                    flat: true
                    checkable: true

                    ToolTip.visible: hovered
                    ToolTip.text: "Farben umdrehen"
                    ToolTip.delay: 1000

                    ColorOverlay {
                        colorOverlayColor: btnInertFilter.checked ? Theme.highlight : "transparent"
                        Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
                    }

                    onClicked: {
                        if ( canvasEngine.filterIsActive ) {
                            canvasEngine.applyInvertFilter ( btnInertFilter.checked );
                        }

                    }
                }

                RoundButton {
                    id: btnInertBlur
                    radius: 8
                    text: "Blur"
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    //icon.source: "../../assets/icons/resize.png"
                    flat: true
                    checkable: true

                    ToolTip.visible: hovered
                    ToolTip.text: "Bild verunschärfen"
                    ToolTip.delay: 1000

                    ColorOverlay {
                        colorOverlayColor: btnInertBlur.checked ? Theme.highlight : "transparent"
                        Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
                    }

                    onClicked: {
                        if ( canvasEngine.filterIsActive ) {
                            canvasEngine.applyBlurFilter ( btnInertBlur.checked );
                        }

                    }
                }

                RoundButton {
                    id: btnInerContrast
                    radius: 8
                    text: "Kontrast"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    //icon.source: "../../assets/icons/resize.png"
                    flat: true
                    checkable: true

                    ToolTip.visible: hovered
                    ToolTip.text: "Kontrast verändern"
                    ToolTip.delay: 1000

                    ColorOverlay {
                        colorOverlayColor: btnInerContrast.checked ? Theme.highlight : "transparent"
                        Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
                    }

                    onClicked: {
                        if ( canvasEngine.filterIsActive ) {
                            canvasEngine.applyContrastFilter ( btnInerContrast.checked );
                        }

                    }
                }

                RoundButton {
                    id: btnWarmFilter
                    radius: 8
                    text: "Warmzeichnen"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    //icon.source: "../../assets/icons/resize.png"
                    flat: true
                    checkable: true

                    ToolTip.visible: hovered
                    ToolTip.text: "Warmzeichnen - Filter"
                    ToolTip.delay: 1000

                    ColorOverlay {
                        colorOverlayColor: btnWarmFilter.checked ? Theme.highlight : "transparent"
                        Behavior on colorOverlayColor { ColorAnimation { duration: 300 } }
                    }

                    onClicked: {
                        if ( canvasEngine.filterIsActive ) {
                            canvasEngine.applyWarmFilter ( btnWarmFilter.checked );
                        }

                    }
                }

            }

        }
    }
}
