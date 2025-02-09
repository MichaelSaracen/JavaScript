import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import App.Constants


import QtQuick.Layouts
import Generated.Effects.DropShadow 1.0


Frame {
    id: newImageDialog
    anchors.fill: parent
    bottomPadding: 0
    topPadding: 0
    padding: 0
    
    signal submit(w: int, h: int, bgColor: color)
    
    
    PropertyAnimation {
        target: newImageDialog
        property: "opacity"
        duration: 500
        from: 0
        to: 1
        running: true
    }
    
    Rectangle {
        opacity: 0.795
        anchors.fill: parent
        color: Theme.background
    }
    
    
    Rectangle {
        id: rectangleDialog
        width: 460
        height: columLayout.implicitHeight
        color: Theme.itemBackground
        radius: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        
        
        
        DropShadow {
            id: dropShadow
        }
        
        ColumnLayout {
            id: columLayout
            width: 409
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 24
            
            Label {
                id: label
                text: qsTr("Neues Bild erstellen")
                bottomPadding: 24
                Layout.topMargin: 24
                font.pointSize: 14
            }
            
            GridLayout {
                id: gridLayout
                rowSpacing: 6
                columnSpacing: 16
                Layout.bottomMargin: 24
                rows: 4
                Label {
                    text: qsTr("Breite:")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
                
                TextField {
                    id: textFieldWidth
                    width: 168
                    height: 38
                    text: "500"
                    validator: RegularExpressionValidator {
                        regularExpression: /^[0-9]+$/
                    }
                    placeholderText: qsTr("")
                    maximumLength: 4
                    Layout.preferredHeight: 45
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                }
                
                Label {
                    text: qsTr("Höhe:")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
                
                TextField {
                    id: textFieldHeight
                    width: 168
                    height: 38
                    text: "500"
                    validator: RegularExpressionValidator {
                        regularExpression: /^[0-9]+$/
                    }
                    placeholderText: qsTr("")
                    maximumLength: 4
                    Layout.preferredHeight: 45
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                }
                                
                Label {
                    text: qsTr("Hintergrund:")
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
                
                ComboBox {
                    id: comboBoxBackground
                    width: 168
                    height: 37
                    model: ['Transparent', 'Farbe']
                    Layout.preferredHeight: 45
                    Layout.fillWidth: true
                    Layout.columnSpan: rectangleColorSelectd.visible ? 1 : 2
                }
                
                Rectangle {
                    id: rectangleColorSelectd
                    width: 39
                    height: 37
                    visible: comboBoxBackground.currentText === 'Farbe'
                    color: colorDialog.selectedColor ? colorDialog.selectedColor : 'red'
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            colorDialog.open();
                        }
                    }
                    
                    ColorDialog {
                        id: colorDialog
                        //onAccepted: { console.log(selectedColor) }
                    }
                    Layout.preferredWidth: 45
                    Layout.preferredHeight: 45
                }
                columns: 3
                
            }
            
            RowLayout {
                id: rowLayout
                width: 100
                height: 100
                spacing: 16
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.bottomMargin: 24
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.columnSpan: 3
                
                RoundButton {
                    id: roundButtonCancel
                    enabled: textFieldHeight.text.length > 0 && textFieldWidth.text.length > 0
                    width: 142
                    height: 52
                    radius: 8
                    text: "OK"
                    Layout.preferredWidth: 150
                    topInset: 0
                    leftInset: 0
                    rightInset: 0
                    bottomInset: 0
                    Layout.preferredHeight: 45
                    
                    onClicked: {
                        settings.setValue('newPictureWidth', textFieldWidth.text);
                        settings.setValue('newPictureHeight', textFieldHeight.text);
                        newImageDialog.submit(
                                    parseInt(textFieldWidth.text),
                                    parseInt(textFieldHeight.text),
                                    comboBoxBackground.currentText === "Transparent" ? "transparent" : colorDialog.selectedColor
                                    );
                        newImageDialog.destroy();
                    }
                    
                }
                
                RoundButton {
                    id: roundButtonSubmit
                    width: 142
                    height: 52
                    radius: 8
                    text: "Abbrechen"
                    Layout.preferredWidth: 150
                    leftInset: 0
                    rightInset: 0
                    bottomInset: 0
                    topInset: 0
                    Layout.fillHeight: true
                    Layout.preferredHeight: 45
                    onClicked: newImageDialog.destroy()
                }
            }
        }
    }

    Component.onCompleted: {
        textFieldWidth.text = settings.value('newPictureWidth', 1000);
        textFieldHeight.text = settings.value('newPictureHeight', 1000);
    }
}
