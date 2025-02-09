pragma Singleton

import QtQuick


QtObject {

    property bool darkMode: true
    property color background: darkMode ? '#1e2227' : 'white'
    property color itemBackground: darkMode ? '#21252b' : '#d0d0d0'
    property color borderColor: darkMode ? '#272b33' : '#bcbcbc'
    property color foreground: darkMode ? '#d0d0d0' : '#272b33'
    property color highlight: darkMode ? '#ff6160' : '#90caf9'


    Behavior on background { ColorAnimation { duration: 400 } }

}
