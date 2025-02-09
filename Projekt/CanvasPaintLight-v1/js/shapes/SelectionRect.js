
// Bewegt über die Tasten WASD das SelectionRect in eine Richtung
function moveRect ( ev ) {
    if ( canvasEngine.selectedItem ) {
        let item = canvasEngine.selectedItem;

        let newX = item.x;
        let newY = item.y;

        // Nach oben
        if (ev.key === Qt.Key_W) {
            newY -= 10;
            if (newY < 0) newY = 0;
        }

        // Nach unten
        if (ev.key === Qt.Key_S) {
            newY += 10;
            if (newY + item.height > canvasEngine.height) {
                newY = canvasEngine.height - item.height;
            }
        }

        // Nach Links
        if (ev.key === Qt.Key_A) {
            newX -= 10;
            if (newX < 0) newX = 0;
        }

        // Nach rechts
        if (ev.key === Qt.Key_D) {
            newX += 10;
            if (newX + item.width > canvasEngine.width) {
                newX = canvasEngine.width - item.width;
            }
        }

        item.setPosition(newX, newY);

        selectionRect.focus = true;
        Index.redraw();
    }
}

// Aktualisiert beim verschieben der Ecken des SelectionRects das ausgewählte Item
function updateSelectionRect(handle, globalPos) {
    var rect = selectionRect;
     var minSize = 20;
    switch (handle) {
    case 0:
        if (globalPos.x > rect.x + rect.width - minSize || globalPos.y > rect.y + rect.height - minSize) return;
        rect.width += rect.x - globalPos.x;
        rect.height += rect.y - globalPos.y;
        rect.x = globalPos.x;
        rect.y = globalPos.y;
        break;
    case 1: // topCenter
        if (globalPos.y > rect.y + rect.height - minSize) return;
        rect.height += rect.y - globalPos.y;
        rect.y = globalPos.y;
        break;
    case 2: // topRight
        if (globalPos.x < rect.x + minSize || globalPos.y > rect.y + rect.height - minSize) return;
        rect.width = globalPos.x - rect.x;
        rect.height += rect.y - globalPos.y;
        rect.y = globalPos.y;
        break;
    case 3: //"centerLeft"
        if (globalPos.x > rect.x + rect.width - minSize) return;
        rect.width += rect.x - globalPos.x;
        rect.x = globalPos.x;
        break;
    case 4: // centerRight
        if (globalPos.x < rect.x + minSize) return;
        rect.width = globalPos.x - rect.x;
        break;
    case 5: // bottomLeft
        if (globalPos.x > rect.x + rect.width - minSize || globalPos.y < rect.y + minSize) return;
        rect.width += rect.x - globalPos.x;
        rect.height = globalPos.y - rect.y;
        rect.x = globalPos.x;
        break;
    case 6: // bottomCenter
        if (globalPos.y < rect.y + minSize) return;
        rect.height = globalPos.y - rect.y;
        break;
    case 7: // bottomCRight
        if (globalPos.x < rect.x + minSize || globalPos.y < rect.y + minSize) return;
        rect.width = globalPos.x - rect.x;
        rect.height = globalPos.y - rect.y;
        break;
    }

    var globalP = mapToItem(painterAreaItem, selectionRect.x, selectionRect.y);
    canvasEngine.selectedItem.setGeometry(rect.x - canvasEngine.x, rect.y - canvasEngine.y, rect.width, rect.height)

    Index.redraw();
}

// Das Globale verschieben des Selection Rects
function onPositionChanged( ev ) {
    var globalPos = mapToItem( painterAreaItem, ev.x, ev.y );
    selectionRect.x = globalPos.x - selectionRect.dragPos.x;
    selectionRect.y = globalPos.y - selectionRect.dragPos.y;
    if ( canvasEngine.selectedItem ) {
        canvasEngine.selectedItem.x = selectionRect.x - canvasEngine.x;
        canvasEngine.selectedItem.y = selectionRect.y - canvasEngine.y;
        if ( canvasEngine.selectedItem.itemType === "LineShape" ) {
            let dx = selectionRect.x - canvasEngine.selectedItem.x;
            let dy = selectionRect.y - canvasEngine.selectedItem.y;

            canvasEngine.selectedItem.width = canvasEngine.selectedItem.x + dx;
            canvasEngine.selectedItem.height = canvasEngine.selectedItem.y + dy;
        }

        //console.log(canvasEngine.selectedItem.itemType)
        Index.redraw();
    }
}






















