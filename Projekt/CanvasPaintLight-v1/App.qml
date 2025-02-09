/**
    Alle Icon dieser Anwendung sind von Google : Material - Icons
    -> https://fonts.google.com/icons

*/


import QtQuick
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts
import QtCore

import "js/menuBar/File.js" as File
import "js/index.js" as Index
import Generated.Effects.DropShadow 1.0
import Generated.Effects.ColorOverlay 1.0

import App.Constants
import App.Components
import App.Bars



Window {
    id: app
    width: Properties.width
    height: Properties.height
    minimumWidth: 700
    minimumHeight: 600


    visible: true
    title: "CanvasPaintLight"

    color: Theme.background

    property Item canvasItem: null

    property alias painterAreaItem: painterAreaItem
    property alias mainContent: mainContent
    property alias menuBar: menuBar


    Settings {
        id: settings
        property alias canvasWidth: canvasEngine.width
        property alias canvasHeight: canvasEngine.height
        property alias shapeWidth: shapeToolBar.textFieldWidthValue
        property alias shapeHeight: shapeToolBar.textFieldHeightValue
        property alias shapeLineWidth: shapeToolBar.lineWidth
        property alias shapeRadius: shapeToolBar.borderRadius
        property alias shapeArcFrom: shapeToolBar.arcFrom
        property alias shapeArcTo: shapeToolBar.arcTo
        property alias fillStyle: shapeToolBar.fillStyle
        property alias strokeStyle: shapeToolBar.strokeStyle
        property alias filterItemVisible: filterItem.visible
        property alias itemInformationVisible: itemInformation.visible
        property alias shapeToolBarVisible: shapeToolBar.visible
        property alias shapeBarVisible: shapeBar.visible
    }

    Item {
        id: mainItem
        anchors.fill: parent


        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: menuBar.bottom
            height: 1
            color: Theme.borderColor
        }

        MyMenuBar {
            id: menuBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            contentHeight: 32
        }

        Item {
            id: mainContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: menuBar.bottom
            anchors.bottom: parent.bottom
            clip: true



            Item {
                id: painterAreaItem
                anchors.left: shapeBar.right
                anchors.right: layerItem.left
                anchors.top: shapeToolBar.bottom
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                //contentHeight: canvasEngine.height
                //contentWidth: canvasEngine.width

                property real scaleFactor: 1.0  // Initialer Skalierungsfaktor

                transform: Scale {
                    id: scaleTransform
                    origin.x: painterAreaItem.width / 2
                    origin.y: painterAreaItem.height / 2
                    xScale: painterAreaItem.scaleFactor
                    yScale: painterAreaItem.scaleFactor
                }

                WheelHandler {
                    id: wheelHandler
                    onWheel: (event) => {
                                 if (event.modifiers & Qt.ShiftModifier) {  // Prüft, ob Shift gedrückt ist
                                     let step = 0.1;
                                     if (event.angleDelta.y > 0) {
                                         painterAreaItem.scaleFactor = Math.min(3.0, painterAreaItem.scaleFactor + step);  // Maximal 3x
                                     } else {
                                         painterAreaItem.scaleFactor = Math.max(0.1, painterAreaItem.scaleFactor - step);  // Minimal 0.5x
                                     }
                                     console.log("Scale:", painterAreaItem.scaleFactor);
                                 }
                             }
                }



                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if ( canvasEngine.selectedItem ) {
                            canvasEngine.selectedItem.unselect();
                        }
                    }
                }
                Rectangle {
                    anchors.centerIn: parent

                    width: canvasEngine.width
                    height: canvasEngine.height

                    DropShadow { dropShadowBlurAmount: 1 }

                    Component.onCompleted: {
                        color = canvasEngine.fillStyle
                    }
                }

                CanvasEngine {
                    id: canvasEngine
                    width: 1000
                    height: 700
                    anchors.centerIn: parent
                    fillStyle: "transparent"

                    focus: true
                    property var items: []
                    property var selectedItem: null
                    property var lastItem: null
                    property int mid: 1
                    property bool itemWasSelected: false
                    property point dragPosition: Qt.point(0,0);
                    property color background
                    property int lastItemIndex
                    property bool containsPress: false
                    property point drawPos: Qt.point(0,0)

                    signal cleared()
                    signal itemAdded( item: var)
                    signal itemRemoved()
                    signal itemSelected(item: var)
                    signal itemUnselected()
                    signal itemFilled(filled: bool)
                    signal itemZStack(z: int)
                    signal itemPositionChanged(pt: point)
                    signal itemGeometryChanged(r: rect)
                    signal itemChanged(item: var)

                    MouseArea {
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true

                        onPressed: ( ev )           => { focus = true; canvasEngine.dragPosition = Qt.point( ev.x, ev.y ) }

                        onClicked: ( ev )           => { focus = true; Index.onCanvasEngineClicked( ev );  }

                        onPositionChanged: (ev) => {

                                               if ( ShapeBar.Shape.Eraser === shapeBar.currentShape && containsPress ) {
                                                   canvasEngine.erase ( mouseX, mouseY, 20, 20 );
                                                   //Index.redraw()
                                               }

                                               if ( ShapeBar.Shape.Pen === shapeBar.currentShape && containsPress ) {
                                                   Index.redraw()
                                                   canvasEngine.drawPos = Qt.point(ev.x, ev.y)
                                                   canvasEngine.containsPress = true;
                                                   canvasEngine.strokeStyle = shapeToolBar.strokeStyle;
                                                   canvasEngine.lineWidth = shapeToolBar.lineWidth;
                                                   //canvasEngine.fillStyle = "black"
                                                   canvasEngine.drawLine ( canvasEngine.dragPosition.x, canvasEngine.dragPosition.y,  canvasEngine.drawPos.x, canvasEngine.drawPos.y );
                                               }
                                           }

                        onReleased: (ev) =>  {
                                        focus = true;
                                        if ( ShapeBar.Shape.Pen === shapeBar.currentShape ) {
                                            Index.createLine( canvasEngine.mid, canvasEngine.dragPosition.x, canvasEngine.dragPosition.y,  canvasEngine.drawPos.x, canvasEngine.drawPos.y  );
                                            canvasEngine.mid ++;
                                        }
                                    }
                    }
                    Component.onCompleted: {
                        createBackground(width,height, fillStyle + "");
                        background = fillStyle + "";
                    }


                    Keys.onDeletePressed:              { Index.onDeletePressed();}
                    onCleared:                         { Index.onCleared(); }
                    onItemChanged: ( item )         => { Index.onItemChanged(item); }
                    onItemSelected: ( item )        => { Index.onItemSelected( item ); }
                    onItemUnselected:                  { Index.onItemUnselected();  }
                    onItemPositionChanged: ( pt )   => { Index.onitemPositionChanged(pt); }
                    onItemGeometryChanged: ( rect ) => { Index.onItemGeometryChanged( rect ); }
                    onItemFilled: ( filled )        => { Index.onItemFilled(filled); }
                    onItemZStack: ( z )             => { Index.onItemZStack(z); }
                    onItemAdded: ( item )           => { Index.onItemAdded( item ) }
                    onItemRemoved:                     { Index.onItemRemoved();  }

                    onXChanged: { Index.onXYChanged(); }
                    onYChanged: { Index.onXYChanged(); }
                }

                SelectionRect {
                    id: selectionRect
                }
            }
            ShapeBar {
                id: shapeBar
                anchors.left: parent.left
                anchors.leftMargin: -1
                anchors.top: parent.top
                anchors.topMargin: -1
            }


            ImageBar {
                id: imageBar
                anchors.left: parent.left
                anchors.leftMargin: -1
                y: shapeBar.visible ? shapeBar.height-2 :  -1
            }

            ItemInformation {
                id: itemInformation
                x: 315
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: -1
                anchors.topMargin: -1
            }

            LayerItem {
                id: layerItem
                anchors.bottom: filterItem.visible ? filterItem.top : parent.bottom
                anchors.bottomMargin: -1
                anchors.right: parent.right
                anchors.rightMargin: -1
                anchors.top: itemInformation.visible ? itemInformation.bottom : parent.top
                anchors.topMargin: -1
            }

            ItemPositioner {
                id: itemPositioner
                anchors.right: layerItem.left
                anchors.top: shapeToolBar.bottom
                anchors.rightMargin: -1
                anchors.topMargin: -1
            }

            ShapeToolBar {
                id: shapeToolBar
                anchors.top: parent.top
                anchors.leftMargin: -1
                anchors.rightMargin: -1
                anchors.topMargin: -1
                anchors.left: shapeBar.right
                anchors.right: layerItem.left
                //x:SelectionRect { NumberAnimationSelectionRect { duration: 300 } }
            }

            FilterItem {
                id: filterItem

                anchors.bottom: parent.bottom
                anchors.bottomMargin: -1
                anchors.right: parent.right
                anchors.rightMargin: -1
                x: 1130
                y: 616
            }

        }
    }
}




