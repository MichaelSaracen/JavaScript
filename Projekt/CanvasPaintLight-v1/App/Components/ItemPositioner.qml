import QtQuick
import QtQuick.Controls 6.8
import QtQuick.Layouts

import App.Constants

Rectangle {
    id: itemPositioner
    visible: shapeToolBar.buttonDisplayPositioner.checked
    width: 189
    height: columnLayout.implicitHeight
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.columnSpan: 4
    color: Theme.background
    border.width: 1
    border.color: Theme.borderColor
    enabled: currentItem
    property var currentItem: null
    z: 2

    ColumnLayout {
        id: columnLayout
        height: 100
        anchors.left: parent.left
        anchors.right: parent.right

        Label {
            text: qsTr("Positionierung")
            Layout.leftMargin: 8
            font.bold: true
            font.pointSize: 9
            Layout.topMargin: 8
            Layout.columnSpan: 4
        }

        GridLayout {
            id: gridLayoutEdit
            width: 100
            height: 100
            rowSpacing: -5
            columnSpacing: -5
            Layout.columnSpan: 4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            rows: 3
            columns: 3


            RoundButton {
                text: qsTr("")
                Layout.maximumHeight: 40
                Layout.minimumHeight: 40
                Layout.preferredHeight: 40
                radius: 8
                onClicked: {
                    currentItem.setPosition(0, 0);
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.preferredHeight: 40
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                onClicked: {
                    currentItem.setPosition( (canvasEngine.width/2) - (currentItem.width / 2), 0);
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.preferredHeight: 40
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                onClicked: {
                    currentItem.setPosition( canvasEngine.width - currentItem.width, 0);
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.preferredHeight: 40
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                onClicked: {
                    currentItem.setPosition(0, (canvasEngine.height/2) - (currentItem.height / 2));
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.preferredHeight: 40
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                onClicked: {
                    currentItem.setPosition((canvasEngine.width/2) - (currentItem.width / 2), (canvasEngine.height/2) - (currentItem.height / 2));
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.preferredHeight: 40
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                onClicked: {
                    currentItem.setPosition( canvasEngine.width - currentItem.width, (canvasEngine.height/2) - (currentItem.height / 2));
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.preferredHeight: 40
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                onClicked: {
                    currentItem.setPosition(0, canvasEngine.height - currentItem.height);
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.preferredHeight: 40
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                onClicked: {
                    currentItem.setPosition((canvasEngine.width/2) - (currentItem.width / 2), canvasEngine.height - currentItem.height);
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.preferredHeight: 40
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                onClicked: {
                    currentItem.setPosition(canvasEngine.width - currentItem.width, canvasEngine.height - currentItem.height);
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("Füllen")
                Layout.topMargin: 4
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                onClicked: {
                    currentItem.setGeometry( 0, 0, canvasEngine.width , canvasEngine.height );
                    canvasEngine.itemFilled(currentItem.isFilled());
                }
                Layout.columnSpan: 3
            }
        }

        GridLayout {
            id: gridLayout
            width: 100
            height: 100
            Layout.topMargin: 8
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            rowSpacing: -8
            columnSpacing: -8
            columns: 3

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.maximumWidth: 45
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.rowSpan: 2

                onClicked: {
                    currentItem.setGeometry( 0, 0, canvasEngine.width / 2 , canvasEngine.height );
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.maximumWidth: 45
                Layout.fillWidth: true
                Layout.rowSpan: 2
                Layout.fillHeight: true
                onClicked: {
                    currentItem.setGeometry( canvasEngine.width / 2, 0, canvasEngine.width / 2 , canvasEngine.height );
                }
            }

            RoundButton {
                radius: 8
                text: qsTr("")
                Layout.maximumWidth: 82
                Layout.minimumHeight: 45
                Layout.preferredHeight: 33


                Layout.fillWidth: true
                Layout.columnSpan: 1
                Layout.rowSpan: 1

                Layout.fillHeight: true
                onClicked: {
                    currentItem.setGeometry( 0, 0, canvasEngine.width  , canvasEngine.height / 2 );
                }
            }

            RoundButton {

                radius: 8
                text: qsTr("")
                Layout.maximumWidth: 82
                Layout.minimumHeight: 45


                Layout.fillWidth: true
                Layout.columnSpan: 1
                Layout.rowSpan: 1

                Layout.fillHeight: true
                onClicked: {
                    currentItem.setGeometry( 0, canvasEngine.height / 2 , canvasEngine.width , canvasEngine.height / 2 );
                }
            }
        }
    }
}
