import QtQuick
import QtQuick.Controls.Material

import QtQuick.Layouts

import App.Constants
import App.Components
import App.Bars

import "../../js/index.js" as Index
import QtQuick.Controls 6.8

Rectangle {
    id: layerItem
    color: Theme.background
    border.width: 1
    border.color: Theme.borderColor
    width: 271
    height: 400

    enabled: canvasEngine.items.length > 0
    clip: true

    property int currentID: 0

    property alias layerListModel: layerListModel
    property alias listView: listView
    property alias comboBoxComposition:  comboBoxComposition
    property alias spinBoxOpacity: spinBoxOpacity
    property alias buttonMergeAll: buttonMergeAll


    function createLayer(obj) {
        layerListModel.append(obj );
        unselectOthers(layerListModel.count - 1);
        currentID = obj.mid;
    }

    function unselectOthers(idx) {
        const obj = layerListModel.get(idx);
        obj.selected = true;

        for (let i = 0; i < layerListModel.count; i++) {
            if(idx !== i) {
                layerListModel.setProperty(i, 'selected', false);
            }
        }

        for (const item of canvasEngine.items ) {
            if ( item.selected && obj.mid !== item.id ) {
                item.selected = false;
            }
        }
        Index.redraw();
    }


    
    ColumnLayout {
        id: rowLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 8
        z: 2
        clip: true
        ComboBox {
            id: comboBoxComposition
            Layout.fillWidth: true
            model: [
                "SourceOver",
                "SourceIn",
                "SourceOut",
                "SourceAtop",
                "Lighten",
                "SoftLight",
                "ColorBurn",
                "HardLight",
                "Multiply" ,
                "Darken",
                "ColorDodge",
                "Difference",
                "DestinationOver" ,
                "DestinationIn",
                "DestinationOut",
                "DestinationAtop",
                "Overlay",
                "Clear",
                "Xor",
                "Screen",
                "Exclusion",
            ]
            font.pointSize: 8
            flat: false
            enabled: true
            Layout.preferredWidth: 123
            Layout.preferredHeight: 31
            onActivated: (index) => {
                             if( canvasEngine.items.length > 0 && canvasEngine.lastItem ) {
                                 canvasEngine.lastItem.setCompositionMode(CanvasEngine[currentText])
                                 displayText = currentText;
                             }
                         }
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                id: label
                text: qsTr("Deckkraft:")
                Layout.leftMargin: 5
                font.pointSize: 8
            }

            Slider {
                id: spinBoxOpacity
                value: 100
                Layout.fillWidth: true
                wheelEnabled: true
                topPadding: 0
                font.pointSize: 8
                bottomPadding: 0
                Layout.preferredWidth: 78
                Layout.preferredHeight: 31
                to: 100

                onValueChanged: {
                    if( canvasEngine.items.length > 0 ) {
                        canvasEngine.lastItem.opacity = Number(value / 100.00);
                        canvasEngine.itemChanged(canvasEngine.lastItem);
                        //Index.redraw();
                    }
                }
            }

            Label {
                text: parseInt(spinBoxOpacity.value) + "%"
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 30
                Layout.leftMargin: 5
                font.pointSize: 8
            }
        }
    }

    ListView {
        id: listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rowLayout.bottom
        anchors.bottom: buttonMergeAll.top
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 8
        anchors.bottomMargin: 2
        clip: true
        spacing: 2
        z: 2
        
        remove: Transition {
            NumberAnimation {
                property: "scale"; from: 1; to: 0; duration: 300
            }
        }
        
        removeDisplaced: Transition {
            NumberAnimation { properties: "y"; duration: 300 }
        }
        
        
        model: ListModel {
            id: layerListModel

        }

        
        delegate:

            Rectangle {
            required property int index
            required property string name
            required property int mid
            required property bool selected

            id: rectangle
            width: listView.width
            height: 30
            color: selected ? Theme.highlight : Theme.background
            
            Behavior on color {
                ColorAnimation {
                    duration: 300
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    unselectOthers(index)
                    textFieldEdit.focus                 = true;
                    layerItem.currentID                 = mid;
                    listView.currentIndex               = index;
                    shapeBar.currentShape               = ShapeBar.Shape.Selection;

                    const obj = canvasEngine.items.find((item) => item.name === name);


                    canvasEngine.itemChanged(obj);
                }

                onDoubleClicked: {
                    textFieldEdit.visible               = true;
                    textFieldEdit.focus                 = true;
                }
            }
            
            Label {
                text: name
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
                font.pointSize: 8
                visible: !textFieldEdit.visible
            }
            
            TextField {
                id: textFieldEdit
                height: 30
                visible: false
                font.pointSize: 9
                onEditingFinished: {
                    if ( canvasEngine.lastItem ) {
                        let obj = canvasEngine.items.find((item) => item.name === name);
                        obj.name = text.length > 0 ? text : name;
                        if ( obj.itemType === "ImageItem") {
                            canvasEngine.renameImage(name, obj.name);
                        }

                        layerListModel.setProperty(index, "name", obj.name);
                        clear();
                        visible = false;
                        Index.redraw();
                    }


                }
                onActiveFocusChanged: visible = false;
                onFocusChanged: visible = false;
            }
            
            RoundButton {
                width: 30
                height: 30
                radius: 4
                anchors.right: parent.right
                anchors.rightMargin: 8
                enabled: selected
                flat: true
                padding: 0
                icon.source: "../../assets/icons/remove.png"
                rightInset: 0
                bottomInset: 0
                leftInset: 0
                topInset: 0
                onClicked: {

                    Index.removeItem(index)

                }
            }
        }
    }
    

    RoundButton {
        id: buttonMergeAll
        radius: 8
        text: "Sichtbar auf eine Ebene reduzieren"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 2
        anchors.rightMargin: 2
        anchors.bottomMargin: 2
        clip: true

        onClicked: {
            // Minimum x und y finden
            let minX = Number.MAX_VALUE;
            let minY = Number.MAX_VALUE;

            // Maximum Breite und Höhe
            let maxWidth = Number.MIN_VALUE;
            let maxHeight = Number.MIN_VALUE

            for ( const item of canvasEngine.items ) {
                minX        = Math.min( minX, item.x );
                minY        = Math.min( minY, item.y );
                maxWidth    = Math.max( maxWidth, item.right() );
                maxHeight   = Math.max( maxHeight, item.bottom());
            }

            let completeWidth = maxWidth - minX;
            let completeHeight = maxHeight - minY;

            const image = Index.ImageItem.mergeToImage(minX, minY, completeWidth, completeHeight);
            Index.onCleared();
            Index.createImage(canvasEngine.mid, minX, minY, completeWidth, completeHeight, image, true);
            canvasEngine.mid++;

        }
    }    
}



























