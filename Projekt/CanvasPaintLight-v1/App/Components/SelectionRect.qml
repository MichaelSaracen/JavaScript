import QtQuick
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts

import App.Constants
import "../../js/index.js" as Index
import "../../js/shapes/SelectionRect.js" as JSSelectionRect


RectangleItem {
    id: selectionRect
    width: 200
    height: 200
    strokeStyle: 3
    strokeWidth: 2
    visible: canvasEngine.selectedItem
    //focus: canvasEngine.focus
    radius: 0
    fillColor: "transparent"
    property point dragPos: Qt.point(0, 0);
    
    MouseArea {
        anchors.fill: parent
        
        onPressed: {
            var globalPos = mapToItem(painterAreaItem, mouseX, mouseY);
            selectionRect.dragPos = Qt.point(globalPos.x - selectionRect.x, globalPos.y - selectionRect.y);
            Index.findItem( globalPos.x - canvasEngine.x, globalPos.y - canvasEngine.y )
        }
        
        onPositionChanged: ( ev ) =>  { JSSelectionRect.onPositionChanged( ev ) }
    }

    Keys.onPressed: ( ev )  => { JSSelectionRect.moveRect( ev ) }
    

    
    Rectangle {
        id: topLeft
        width: 12
        height: 12
        color: "black"
        border.width: 1
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: -6
        anchors.topMargin: -6
        border.color: "white"
        
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            cursorShape: Qt.SizeFDiagCursor
            onPositionChanged: {
                var globalPos = mapToItem(painterAreaItem, mouseX, mouseY);
                JSSelectionRect.updateSelectionRect(0, globalPos);
            }
        }
    }
    Rectangle {
        id: topCenter
        width: 12
        height: 12
        color: "black"
        border.width: 1
        anchors.top: parent.top
        anchors.topMargin: -6
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: "white"
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            cursorShape: Qt.SizeVerCursor
            onPositionChanged: {
                var globalPos = mapToItem(painterAreaItem, mouseX, mouseY);
                JSSelectionRect.updateSelectionRect(1, globalPos);
            }
        }
    }
    Rectangle {
        id: topRight
        width: 12
        height: 12
        color: "black"
        border.width: 1
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: -6
        anchors.topMargin: -6
        border.color: "white"
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            cursorShape: Qt.SizeBDiagCursor
            onPositionChanged: {
                var globalPos = mapToItem(painterAreaItem, mouseX, mouseY);
                JSSelectionRect.updateSelectionRect(2, globalPos);
            }
        }
    }
    Rectangle {
        id: centerLeft
        width: 12
        height: 12
        color: "black"
        border.width: 1
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: -6
        anchors.verticalCenterOffset: 0
        border.color: "white"
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            cursorShape: Qt.SizeHorCursor
            onPositionChanged: {
                var globalPos = mapToItem(painterAreaItem, mouseX, mouseY);
                JSSelectionRect.updateSelectionRect(3, globalPos);
            }
        }
    }
    Rectangle {
        id: centerRight
        width: 12
        height: 12
        color: "black"
        border.width: 1
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: -6
        anchors.verticalCenterOffset: 0
        border.color: "white"
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            cursorShape: Qt.SizeHorCursor
            onPositionChanged: {
                var globalPos = mapToItem(painterAreaItem, mouseX, mouseY);
                JSSelectionRect.updateSelectionRect(4, globalPos);
            }
        }
    }
    Rectangle {
        id: bottomLeft
        width: 12
        height: 12
        color: "black"
        border.width: 1
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: -6
        anchors.bottomMargin: -6
        border.color: "white"
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            cursorShape: Qt.SizeBDiagCursor
            onPositionChanged: {
                var globalPos = mapToItem(painterAreaItem, mouseX, mouseY);
                JSSelectionRect.updateSelectionRect(5, globalPos);
            }
        }
    }
    Rectangle {
        id: bottomCenter
        width: 12
        height: 12
        color: "black"
        border.width: 1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -6
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: "white"
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            cursorShape: Qt.SizeVerCursor
            onPositionChanged: {
                var globalPos = mapToItem(painterAreaItem, mouseX, mouseY);
                JSSelectionRect.updateSelectionRect(6, globalPos);
            }
        }
    }
    Rectangle {
        id: bottomRight
        width: 12
        height: 12
        color: "black"
        border.width: 1
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: -6
        anchors.bottomMargin: -6
        border.color: "white"
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            cursorShape: Qt.SizeFDiagCursor
            onPositionChanged: {
                var globalPos = mapToItem(painterAreaItem, mouseX, mouseY);
                JSSelectionRect.updateSelectionRect(7, globalPos);
            }
        }
    }
}
