import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import App.Constants


Window {
    width: 900
    height: 793
    color: Theme.background
    minimumWidth: 100
    minimumHeight: 100
    maximumWidth: 500
    maximumHeight: 600


    ScrollView {
        id: scrollView
        anchors.fill: parent

        GridLayout {
            id: gridLayout
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            columnSpacing: 48
            columns: 2

            Label {
                id: label
                text: qsTr("Tastenkürzel")
                Layout.columnSpan: 2
                font.pointSize: 14
            }

            Label {
                id: label1
                text: qsTr("Beschreibung")
                Layout.topMargin: 6
                Layout.fillWidth: true
                font.bold: true
                font.pointSize: 10
            }

            Label {
                id: label2
                text: qsTr("Kürzel")
                font.pointSize: 10
                font.bold: true
            }

            Label {
                id: label3
                text: qsTr("Ausgewähltes Item nach oben bewegen")
                Layout.topMargin: 7
                Layout.fillWidth: true
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label4
                text: qsTr("W")
                Layout.fillWidth: true
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label5
                text: qsTr("Ausgewähltes Item nach unten bewegen")
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label6
                text: qsTr("S")
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label7
                text: qsTr("Ausgewähltes Item nach links bewegen")
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label8
                text: qsTr("A")
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label9
                text: qsTr("Ausgewähltes Item nach rechts bewegen")
                font.pointSize: 10
                font.bold: false
            }


            Label {
                id: label10
                text: qsTr("D")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label45
                text: qsTr("Ausgewähltes Item entfernen")
                font.pointSize: 10
                font.bold: false
            }


            Label {
                id: label46
                text: qsTr("ENTF")
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label11
                text: qsTr("Neue Bild erstellen")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label12
                text: qsTr("Strg+N")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label13
                text: qsTr("Bild öffnen und hinzufügen")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label14
                text: qsTr("Strg+O")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label15
                text: qsTr("Bild speichern")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label16
                text: qsTr("Strg+S")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label17
                text: qsTr("Programm schließen")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label18
                text: qsTr("Strg+B")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label19
                text: qsTr("Dunkler / Heller Modus")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label20
                text: qsTr("F2")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label21
                text: qsTr("Maximal hineinzoomen")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label22
                text: qsTr("Strg++")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label23
                text: qsTr("Zoom Normal")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label24
                text: qsTr("Strg+#")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label25
                text: qsTr("Maximal herauszoomen")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label26
                text: qsTr("Strg+-")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label27
                text: qsTr("Filter einblenden / ausblenden")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label28
                text: qsTr("F3")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label29
                text: qsTr("Formen einblenden / ausblenden")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label30
                text: qsTr("F4")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label31
                text: qsTr("Bild Optionen einblenden / ausblenden")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label32
                text: qsTr("F5")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label33
                text: qsTr("Item einblenden / ausblenden")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label34
                text: qsTr("F6")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label35
                text: qsTr("Raster Farbe auswählen")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label36
                text: qsTr("F7")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label37
                text: qsTr("Ansicht Normal")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label38
                text: qsTr("F9")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label39
                text: qsTr("Fenster minimieren")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label40
                text: qsTr("F10")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label41
                text: qsTr("Fensterm maximieren")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label42
                text: qsTr("F11")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label43
                text: qsTr("Vollbild")
                font.pointSize: 10
                font.bold: false
            }



            Label {
                id: label44
                text: qsTr("F12")
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label47
                text: qsTr("Hineinzoomen")
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label48
                text: qsTr("Shift + Wheel up")
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label49
                text: qsTr("Herauszoomen")
                font.pointSize: 10
                font.bold: false
            }

            Label {
                id: label50
                text: qsTr("Shift + Wheel down")
                font.pointSize: 10
                font.bold: false
            }


        }
    }


    Component.onDestruction: {
        console.log("destroy")
    }

}
