import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

import App.Constants
import QtQuick.Controls 6.8


Rectangle {
    id: itemInformation
    width: 271
    height: 256
    color: Theme.background
    border.width: 1
    border.color: Theme.borderColor
    enabled: currentItem
    property var currentItem: null
    
    GridLayout {
        id: gridLayout
        anchors.fill: parent
        anchors.margins: 8
        rowSpacing: 8
        columns: 4
        
        
        Label {
            id: label1
            text: qsTr("Item Information")
            font.bold: true
            font.pointSize: 9
            Layout.columnSpan: 4
        }

        Label {
            text: qsTr("Typ")
            Layout.columnSpan: 2
        }

        Label {
            id: labelType
            text: currentItem ? currentItem.itemType : "-"
            Layout.columnSpan: 2
        }
        
        Label {
            text: qsTr("Name")

            Layout.columnSpan: 2
        }
        
        Label {
            id: labelName
            text: currentItem ? currentItem.name : "-"
            Layout.columnSpan: 2
        }
        
        Label {
            text: qsTr("Geometrie")
            font.bold: true
            font.pointSize: 9
            Layout.topMargin: 8
            Layout.columnSpan: 4
        }
        
        Label {
            text: qsTr("x")
        }
        
        Label {
            id: labelPosX
            text: currentItem ? parseInt(currentItem.x) : "-"
        }
        
        Label {
            text: qsTr("y")
        }
        
        Label {
            id: labelPosY
            text: currentItem ? parseInt(currentItem.y) : "-"
        }
        
        Label {
            text: qsTr("Breite")
        }
        
        Label {
            id: labelWidth
            text: currentItem ? currentItem.width : "-"
        }
        Label {
            text: qsTr("Höhe")
        }
        
        Label {
            id: labelHeight
            text: currentItem ? currentItem.height : "-"
        }
        
        Label {
            text: qsTr("Start")
        }
        

        Label {
            id: labelStartAngle
            text: !currentItem ?  "-" : currentItem.itemType === "PieShape" || currentItem.itemType === "ArcShape"  ? currentItem.from : "-"
        }
        Label {
            text: qsTr("Ende")
        }
        
        Label {
            id: labelEndAngle
            text: !currentItem ?  "-" : currentItem.itemType === "PieShape" || currentItem.itemType === "ArcShape"  ? currentItem.to : "-"
        }
        
        Label {
            text: qsTr("Eigenschaften")
            font.bold: true
            font.pointSize: 9
            Layout.topMargin: 8
            Layout.columnSpan: 4
        }
        
        Label {
            text: qsTr("Linienfarbe")
            Layout.columnSpan: 2
        }
        
        Label {
            id: labelStrokeStyle
            text: !currentItem ?  "None" : currentItem.itemType !== "TextItem" && currentItem.itemType !== "ImageItem"  ? currentItem.strokeStyle : "None"
            Layout.columnSpan: 2
        }
        
        Label {
            text: qsTr("Füllfarbe")
            Layout.columnSpan: 2
        }
        
        Label {
            id: labelFillStyle
            text: !currentItem ?  "None" : currentItem.itemType !== "TextItem" && currentItem.itemType !== "ImageItem"  ? currentItem.fillStyle : "None"
            Layout.columnSpan: 2
        }
        
        Label {
            text: qsTr("Linienbreite")
            Layout.columnSpan: 2
        }
        
        Label {
            id: labelLineWidth
            text: !currentItem ?  "None" : currentItem.itemType !== "TextItem" && currentItem.itemType !== "ImageItem"  ? currentItem.lineWidth : "None"
            Layout.columnSpan: 2
        }
    }
}
