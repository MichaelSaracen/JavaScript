
// Created with Qt Design Studio (version 4.7.0), Sun Feb 2 18:39:24 2025
// Do not manually edit this file, it will be overwritten if effect is modified in Qt Design Studio.

import QtQuick

Item {
    id: rootItem

    // Use visible property to show and hide the effect.
    visible: true

    // This is an internal property used by tooling to identify effect items. Do not modify.
    property bool _isEffectItem

    // This is an internal property used to manage the effect. Do not modify.
    property Item _oldParent: null

    // This is the main source for the effect. Set internally to the current parent item. Do not modify.
    property Item source: null

    function setupParentLayer()
    {
        if (_oldParent && _oldParent !== parent) {
            _oldParent.layer.enabled = false
            _oldParent.layer.effect = null
            
            source = null
            _oldParent.update()
            _oldParent = null
        }
        if (parent) {
            _oldParent = parent
            if (visible) {
                parent.layer.enabled = true
                parent.layer.effect = effectComponent
                
                source = parent
            } else {
                parent.layer.enabled = false
                parent.layer.effect = null
                
                source = null
            }
            parent.update()
        }

    }

    onParentChanged: setupParentLayer()

    onVisibleChanged: setupParentLayer()

    // This property defines the color value which is used to colorize the source.
    //
    // By default, the property is set to \c "transparent".
    property color colorOverlayColor: "#ff6160"

    Component {
        id: effectComponent
        ShaderEffect {
            property Item source: null
            readonly property Item iSource: rootItem.source
            readonly property color colorOverlayColor: rootItem.colorOverlayColor

            vertexShader: 'coloroverlay.vert.qsb'
            fragmentShader: 'coloroverlay.frag.qsb'

        }
    }
}
