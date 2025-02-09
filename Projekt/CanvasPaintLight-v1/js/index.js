
/**
 * AbstractItem ist eine ''''' Abstrakte Klasse ''''' (soll eine darstellen), die die ganzen Informatinen für
 * für die Abgeleiteten Klassen bereitstellt.
 *
 * Punkt x, y, Breite, Höhe, ausgwählt usw ...
 */
class AbstractItem  {

    constructor(x, y, width, height) {
        if(new.target === AbstractItem)
        throw new Error('Die Abstrakte Klasse AbstractItem kann nicht instanziiert werden.');

        // Attribute für das AbstractItem
        this.x                  = parseInt(x);
        this.y                  = parseInt(y);
        this.width              = parseInt(width);
        this.height             = parseInt(height);
        this.selected           = false;
        this.name               = '';
        this.mid                = 0;
        this.opacity            = 1;
        this.z                  = 0;
        this.itemType           = ''
        this.compositionMode    = CanvasEngine.SourceOver
        this.compositionName    = 'SourceOver'  // Lesbarer Name
    }

    /**
     * Gibt die Position der unteren Seite der Form zurück
     */
    bottom() { return this.y + this.height; }

    /**
     * Gibt die Position der linken Seite der Form zurück
     */
    left() { return this.x; }

    /**
     * Gibt die Position der rechten Seite der Form zurück
     */
    right() { return this.x + this.width; }

    /**
     * Gibt die Position der oberen Seite der Form zurück
     */
    top() { return this.y; }

    /**
     * Gibt die mittlere Position der Form auf der X - Achse zurück
     */
    centerX() { return this.x + (this.width / 2) }

    /**
     * Gibt die mittlere Position der Form auf der Y - Achse zurück
     */
    centerY() { return this.y + (this.height / 2) }

    /**
     * Abstrakte Methode zum implementieren in den Abgeleiteten Klassen.
     */
    draw() { throw new Error('Die Methode draw muss implementiert werden.'); }

    /**
     * Methode zum bewegen der Items.
     * @param x
     * @param y
     */
    move(x, y) {
        if ( this.x === x && this.y === y ) return;

        this.x += x;
        this.y += y;
        canvasEngine.itemPositionChanged( Qt.point(this.x, this.y) )

        redraw();
    }

    /**
     * Setzt die genaue Position für das Item auf den X und Y Achsen.
     * @param x
     * @param y
     */
    setPosition(x, y) {
        if ( this.x === x && this.y === y ) return;

        this.x = x;
        this.y = y;
        canvasEngine.itemPositionChanged( Qt.point(this.x, this.y) )
        redraw()
    }

    /**
     * Verändert die Position und die Größe des Items.
     * @param x
     * @param y
     * @param width
     * @param height
     */
    setGeometry(x, y, width, height) {
        if ( this.x === x && this.y === y && this.width === width && this.height === height ) return;
        this.x      = x;
        this.y      = y;
        this.width  = width;
        this.height = height;
        canvasEngine.itemGeometryChanged( Qt.rect(this.x, this.y, this.width, this.height ));
        redraw();

    }

    /**
     * Stellt fest, ob das Item geanu im Canvas ausgefüllt ist.
     * @returns {boolean}
     */
    isFilled() {
        let filled = this.x === 0 && this.y === 0 && this.width === canvasEngine.width && this.height === canvasEngine.height;
        return filled
    }

    /**
     * Wählt die aktuelle Auswahl ab.
     */
    unselect() {
        canvasEngine.itemUnselected();
        Index.redraw()
    }

    /**
     * Setzt den Compositions Mode für das Ausgewählte Item. Enumartion in der cpp/canvasengine.h
     * @param mode
     */
    setCompositionMode( mode ) {
        this.compositionMode = mode;

        switch ( mode ) {
            case CanvasEngine.SourceOver:
            this.compositionName = "SourceOver";
            break;
            case CanvasEngine.SourceIn:
            this.compositionName = "SourceIn";
            break;
            case CanvasEngine.SourceOut:
            this.compositionName = "SourceOut";
            break;
            case CanvasEngine.SourceAtop:
            this.compositionName = "SourceAtop";
            break;
            case CanvasEngine.Lighten:
            this.compositionName = "Lighten";
            break;
            case CanvasEngine.SoftLight:
            this.compositionName = "SoftLight";
            break;
            case CanvasEngine.ColorBurn:
            this.compositionName = "ColorBurn";
            break;
            case CanvasEngine.HardLight:
            this.compositionName = "HardLight";
            break;
            case CanvasEngine.Multiply:
            this.compositionName = "Multiply";
            break;
            case CanvasEngine.Darken:
            this.compositionName = "Darken";
            break;
            case CanvasEngine.ColorDodge:
            this.compositionName = "ColorDodge";
            break;
            case CanvasEngine.Difference:
            this.compositionName = "Difference";
            break;
            case CanvasEngine.DestinationOver:
            this.compositionName = "DestinationOver";
            break;
            case CanvasEngine.DestinationIn:
            this.compositionName = "DestinationIn";
            break;
            case CanvasEngine.DestinationOut:
            this.compositionName = "DestinationOut";
            break;
            case CanvasEngine.DestinationAtop:
            this.compositionName = "DestinationAtop";
            break;
            case CanvasEngine.Overlay:
            this.compositionName = "Overlay";
            break;
            case CanvasEngine.Clear:
            this.compositionName = "Clear";
            break;
            case CanvasEngine.Xor:
            this.compositionName = "Xor";
            break;
            case CanvasEngine.Screen:
            this.compositionName = "Screen";
            break;
            case CanvasEngine.Exclusion:
            this.compositionName = "Exclusion";
            break;
        }
        redraw();
    }
}


/**
 * Das ImageItem stellt auf der CanvasEngine ein Bild dar.
 */
class ImageItem extends AbstractItem {

    constructor(x, y, width, height, source, isMerged = false ) {
        super(x, y, width, height);

        this.source     = source ;
        this.itemType   = 'ImageItem'
        this.isMerged   = isMerged
    }

    /**
     * Überschreibung der Methode aus AbstractItem.
     */
    draw() {
        // TODO Image zeichnen
        canvasEngine.setCompositionMode(this.compositionMode);
        canvasEngine.setLayerOpacity(this.opacity);

        if (!this.isMerged) {
            canvasEngine.drawImage(this.x, this.y, this.width, this.height, this.name);

        } else {

            canvasEngine.drawMergedImage(this.x, this.y, this.width, this.height, canvasEngine.base64ToImage(this.source + ""));
        }

    }

    static mergeToImage(minX, minY, completeWidth, completeHeight) {
        let itemsData = [];

        for (const item of canvasEngine.items) {
            let itemData = {
                               x: item.x,
                               y: item.y,
                               width: item.width,
                               height: item.height,
                               type: item.itemType,
                           };
            if ( "source" in item ) {
                itemData.source = item.source;
            }

            if ( "strokeStyle" in item ) {
                itemData.strokeStyle = item.strokeStyle;
            }

            if ( "fillStyle" in item ) {
                itemData.fillStyle = item.fillStyle;
            }

            if ( "lineWidth" in item ) {
                itemData.lineWidth = item.lineWidth;
            }

            if ( "radius" in item ) {
                itemData.radius = item.radius;
            }

            if ( "from" in item ) {
                itemData.from = item.from;
            }
            if ( "to" in item ) {
                itemData.to = item.to;
            }

            itemsData.push(itemData);
        }

        const image = canvasEngine.createMergedImage(minX, minY, completeWidth, completeHeight, itemsData);
        return image;
    }
}


/**
 * Container (ggf Dataclass or whatever) für die Abgeleiteten Klassen.
 */
class AbstractShape extends AbstractItem {

    constructor( x, y, width, height ) {
        super( x, y, width, height );

        if ( new.target === AbstractShape ) throw new Error( 'Diese Klasse kann nicht instanziiert werden.' )

        this.strokeStyle = '#000000'
        this.fillStyle   = '#ffffff'
        this.lineWidth   = 1
    }

    setFillStyle(clr) {
        this.fillStyle = clr;
    }
}


class LineShape extends AbstractShape {
    constructor( x, y, width, height, radius = 0 ) {
        super(x, y, width, height);
        this.itemType = "LineShape";
    }

    draw() {
        canvasEngine.setCompositionMode( this.compositionMode );
        canvasEngine.setLayerOpacity( this.opacity );
        canvasEngine.fillStyle   = this.fillStyle + "";
        canvasEngine.strokeStyle = this.strokeStyle + "";
        canvasEngine.lineWidth   = this.lineWidth +"";
        canvasEngine.drawLine( this.x, this.y, this.width, this.height );
    }
}

/**
 * Stellt auf dem Canvas ein Rechteck dar. Dieses kann auch abgerundete Ecken haben.
 */
class RectangleShape extends AbstractShape {

    constructor( x, y, width, height, radius = 0 ) {
        super(x, y, width, height);

        this.itemType   = 'RectangleShape'
        this.radius     = radius;
    }

    /**
     * Überschreibung der Methode aus AbstractItem.
     */
    draw() {
        // TODO RectangleShape zeichnen
        canvasEngine.setCompositionMode( this.compositionMode );
        canvasEngine.setLayerOpacity( this.opacity );
        canvasEngine.fillStyle   = this.fillStyle + "";
        canvasEngine.strokeStyle = this.strokeStyle + "";
        canvasEngine.lineWidth   = this.lineWidth +"";
        canvasEngine.drawRect( this.x, this.y, this.width, this.height, this.radius );
    }
}


class EllipseShape extends AbstractShape {

    constructor( x, y, width, height ) {
        super( x, y, width, height );

        this.itemType   = 'EllipseShape'
    }

    /**
     * Überschreibung der Methode aus AbstractItem.
     */
    draw () {
        // TODO EllipseShape zeichnen
        canvasEngine.setCompositionMode( this.compositionMode );
        canvasEngine.setLayerOpacity( this.opacity );
        canvasEngine.fillStyle   = this.fillStyle + "";
        canvasEngine.strokeStyle = this.strokeStyle + "";
        canvasEngine.lineWidth   = this.lineWidth +"";
        canvasEngine.drawEllipse( this.x, this.y, this.width, this.height );
    }
}

/**
 * Stellt auf dem Canvas ein Bogen dar.
 */
class ArcShape extends AbstractShape {

    constructor( x, y, width, height, from = 0, to = 270 ) {
        super( x, y, width, height );

        this.itemType   = 'ArcShape'
        this.from       = from;
        this.to         = to;
    }

    /**
     * Überschreibung der Methode aus AbstractItem.
     */
    draw() {
        // TODO ArcShape zeichnen
        canvasEngine.setCompositionMode( this.compositionMode );
        canvasEngine.setLayerOpacity( this.opacity );
        canvasEngine.fillStyle   = this.fillStyle + "";
        canvasEngine.strokeStyle = this.strokeStyle + "";
        canvasEngine.lineWidth   = this.lineWidth +"";
        canvasEngine.drawArc( this.x, this.y, this.width, this.height, this.from, this.to );
    }
}

/**
 * Stellt auf dem Canvas eine 'Torte' dar.
 */
class PieShape extends AbstractShape {

    constructor( x, y, width, height, from = 0, to = 270) {
        super( x, y, width, height);
        this.itemType   = 'PieShape'
        this.from       = from;
        this.to         = to;
    }

    /**
     * Überschreibung der Methode aus AbstractItem.
     */
    draw() {
        // TODO PieShape zeichnen
        canvasEngine.setCompositionMode( this.compositionMode );
        canvasEngine.setLayerOpacity( this.opacity );
        canvasEngine.fillStyle      = this.fillStyle + "";
        canvasEngine.strokeStyle    = this.strokeStyle + "";
        canvasEngine.lineWidth      = this.lineWidth + "";
        canvasEngine.drawPie( this.x, this.y, this.width, this.height, this.from, this.to );
    }
}



// ##############################################################################################
// ----- Methoden zum Verwalten der Formen in der CanvasEngine -----
// ##############################################################################################

/**
 * Setzt die Initialwerte für die Items.
 * @param shape
 * @param id_
 */
function setShapeAttributes( shape, id_ ) {
    unselectLast();
    shape.mid               = id_;
    shape.name              = shapeBar.currentText + id_;
    shape.selected          = true;
    shapeBar.currentShape   = ShapeBar.Shape.Selection;

    if ( shape.tpye !== "ImageItem" ) {
        shape.fillStyle     = shapeToolBar.fillStyle + "";
        shape.lineWidth     = shapeToolBar.lineWidth + "";
        shape.strokeStyle   = shapeToolBar.strokeStyle + "";
    }

    if ( shape instanceof ImageItem ) {
        if (!shape.isMerged) {
            canvasEngine.addImage( shape.source, shape.name );
        }
    }

    canvasEngine.items.push(shape);

    // [!] --- Anfangs Z festlegen
    const index = canvasEngine.items.indexOf(shape);
    canvasEngine.items[index].z = index;

    layerItem.createLayer(shape);
    canvasEngine.selectedItem = shape;
    canvasEngine.lastItem = shape;
    itemInformation.currentItem = shape;

    canvasEngine.itemSelected( shape );
    canvasEngine.itemAdded( shape );
}



function createLine(id_, x, y, w, h) {
    const shape     = new LineShape(x,y,w,h);
    setShapeAttributes(shape, id_);
}

/**
 * Erstellung des Rechtecks
 * @param id_
 * @param x
 * @param y
 * @param w
 * @param h
 * @param radius
 */
function createRectangle(id_, x, y, w, h, radius = 0) {
    const shape     = new RectangleShape(x,y,w,h,radius);
    setShapeAttributes(shape, id_);
}

/**
 * Erstellung der Ellipse
 * @param id_
 * @param x
 * @param y
 * @param w
 * @param h
 */
function createEllipse(id_ , x, y, w, h) {
    const shape     = new EllipseShape(x,y,w,h);
    setShapeAttributes(shape, id_);
}

/**
 * Erstellung des Bogens
 * @param id_
 * @param x
 * @param y
 * @param w
 * @param h
 * @param from
 * @param to
 */
function createArc(id_, x, y, w, h, from = 0, to = 270) {
    const shape     = new ArcShape(x,y,w,h,from,to);
    setShapeAttributes(shape, id_);
}

/**
 * Erstellung der 'Torte'
 * @param id_
 * @param x
 * @param y
 * @param w
 * @param h
 * @param from
 * @param to
 */
function createPie(id_, x, y, w, h, from = 0, to = 270) {
    const shape     = new PieShape(x,y,w,h,from,to);
    setShapeAttributes(shape, id_);
}

/**
 * Erstellung des Bildes
 * @param id_
 * @param x
 * @param y
 * @param width
 * @param height
 * @param source
 */
function createImage( id_, x, y, width, height, source, isMerged = false ) {
    const shape         = new ImageItem(x, y, width, height, source);
    shape.isMerged      = isMerged;
    setShapeAttributes(shape, id_);

}

function enabledItems() {
    layerItem.enabled                               = canvasEngine.items.length > 0;
    imageBar.buttonCleanMode.enabled                = canvasEngine.items.length > 0;
    shapeToolBar.spinBoxZStack.to                   = canvasEngine.items.length - 1;
    shapeToolBar.buttonItemFill.enabled             = canvasEngine.items.length > 0;
    shapeToolBar.spinBoxZStack.enabled              = canvasEngine.items.length > 0;
    shapeToolBar.buttonDisplayPositioner.enabled    = canvasEngine.items.length > 0;
    itemInformation.enabled                         = canvasEngine.items.length > 0;
    layerItem.buttonMergeAll.enabled                = canvasEngine.items.length > 1;
    filterItem.enabled                              = canvasEngine.items.length > 0;
    menuBar.menuEdit.enabled                        = canvasEngine.items.length > 0;
    menuBar.actionSave.enabled                      = canvasEngine.items.length > 0;
}

/**
 * Hilfsfunktion für das Entfernen eines einzelnen oder allen Items, die die Einstellungen dementsprechend
 * verwaltet
 */
function enabledOnDelete() {
    enabledItems();

    // [!] --- Wählt das vorherige Item aus.
    if ( canvasEngine.items.length > 0 ) {
        canvasEngine.itemSelected( canvasEngine.items[ canvasEngine.items.length - 1 ]);
        selectionRect.focus                     = true
    } else {
        canvasEngine.selectedItem               = null;
        canvasEngine.lastItem                   = null;
        itemInformation.currentItem             = null;
        itemPositioner.currentItem              = null;
        shapeToolBar.buttonDisplayPositioner.checked    = false
    }
    canvasEngine.focus = true;
}


/**
 * Zeichnet alles auf der CanvasEngine neu.
 */
function redraw() {
    // [!] --- Rect resetten
    canvasEngine.clearRect(0, 0, canvasEngine.width, canvasEngine.height);
    // [!] ...
    canvasEngine.setLayerOpacity(1);
    canvasEngine.fillStyle = canvasEngine.background + "";
    canvasEngine.strokeStyle = "transparent";
    canvasEngine.lineWidth = 0;
    canvasEngine.drawRect(0,0, canvasEngine.width, canvasEngine.height);
    canvasEngine.drawGrid(imageBar.buttonGridMode.checked, menuBar.rasterColor);

    // [!] --- Items aus der Liste (items) der canvasEngine zeichnen.
    for ( const item of canvasEngine.items ) {
        item.draw();
    }
}

/**
 * Sucht nach einem Item auf den X und Y Koordinaten im Canvas und löst dabei das itemSelected - Signal aus,
 * wenn ein Item gefunden wurde. Ansonsten wird itemUnselected ausgelöst ( Für das Verhalten zum abwählen )
 * @param x
 * @param y
 */
function findItem( x, y ) {
    if ( canvasEngine.items.length === 0 ) return;
    const item = canvasEngine.items.find((element) => x > element.left() && x < element.right() && y > element.top() && y < element.bottom() && element.mid === layerItem.currentID);

    if( item ) {
        canvasEngine.itemSelected( item ); // SIGNAL
    }
    else {
        canvasEngine.itemUnselected(); // SIGNAL
    }
}

/**
 * Ordnet die ausgewählte Ebene neue an. Dabei werden die Items in der Liste ( items ) und im ListView ( LayerItem.qml )
 * getauscht.
 * @param oldIndex
 * @param newIndex
 */
function changeZIndex(oldIndex, newIndex) {
    if (oldIndex === newIndex) return;

    [canvasEngine.items[newIndex], canvasEngine.items[oldIndex]] =
                                                                 [canvasEngine.items[oldIndex], canvasEngine.items[newIndex]];

    layerItem.layerListModel.move(oldIndex, newIndex, 1);

    Index.redraw();

}



/**
 * Wählt das letzte ausgewählte Item - falls vorhanden - ab.
 */
function unselectLast() {
    if ( canvasEngine.selectedItem ) {
        canvasEngine.itemUnselected();
    }
}

/**
 * Entfernt ein ausgewähltes Item und löst dabei das Signal itemRemoved aus.
 * @param idx
 */
function removeItem ( idx = - 1 ) {
    if ( canvasEngine.lastItem && canvasEngine.lastItem.selected ) {
        let index = idx === -1 ? canvasEngine.items.findIndex( (item ) => item.name === canvasEngine.lastItem.name ) : idx;

        const obj = layerItem.layerListModel.get(index);
        if ( obj.itemType === "ImageItem" && idx === -1 && !obj.isMerged ) {
            canvasEngine.removeImage(obj.name);
        }
        canvasEngine.items.splice(index, 1);
        layerItem.layerListModel.remove(index, 1);

        if ( layerItem.layerListModel.count > 0 ) {
            index = index - 1 < 0 ? index : index - 1
            const newObj = canvasEngine.items[index];
            newObj.selected = true;
            layerItem.layerListModel.setProperty(index, 'selected', true);
            canvasEngine.lastItem = newObj;
        } else {
            canvasEngine.lastItem = null;
        }
        canvasEngine.itemRemoved();
    }
}


/**
 * Beim drücken der ENTF Taste wird ein ausgewwähltes Item entfernt.
 */
function onDeletePressed() {
    removeItem();
    shapeToolBar.buttonItemFill.enabled     = canvasEngine.items.length > 0;
    canvasEngine.focus = true;
}
/**
 * Klick operationen auf der CanvasEngine
 * @param ev
 */
function onCanvasEngineClicked ( ev ) {
    switch (shapeBar.currentShape) {
    case 0:
        findItem(ev.x, ev.y);
        break;

    case 2:
        createRectangle( canvasEngine.mid, ev.x, ev.y, shapeToolBar.shapeWidth, shapeToolBar.shapeHeight, shapeToolBar.borderRadius );
        canvasEngine.mid++;
        break;

    case ShapeBar.Shape.Ellipse:
        createEllipse( canvasEngine.mid, ev.x, ev.y, shapeToolBar.shapeWidth, shapeToolBar.shapeHeight );
        canvasEngine.mid++;
        break;

    case ShapeBar.Shape.Arc:
        createArc( canvasEngine.mid, ev.x, ev.y, shapeToolBar.shapeWidth, shapeToolBar.shapeHeight, shapeToolBar.arcFrom, shapeToolBar.arcTo );
        canvasEngine.mid++;
        break;

    case ShapeBar.Shape.Pie:
        createPie( canvasEngine.mid, ev.x, ev.y, shapeToolBar.shapeWidth, shapeToolBar.shapeHeight, shapeToolBar.arcFrom, shapeToolBar.arcTo );
        canvasEngine.mid++;
        break;

    // case ShapeBar.Shape.Image:
    //     createImage( canvasEngine.mid, ev.x, ev.y, shapeToolBar.shapeWidth, shapeToolBar.shapeHeight, ":/assets/icons/test.png" );
    //     canvasEngine.mid++;
    //     break;
    }
}

// -> Randinfo
// -> die Methoden hier fangen mit 'on' an. Das sind hier eigentlich Namen für Signale, aber hier werden sie so gennant
// -> um diese leichter zu identifizieren.
// -> Alle Signale sind in der App.qml -> CanvasEngine ( Komponente ) festgelegt und heißen auch so.




/**
 * Verhalten beim hinzufügen eines neuen Items.
 * @param item
 */
function onItemAdded( item ) {
    layerItem.enabled                       = canvasEngine.items.length > 0;
    canvasEngine.selectedItem.selected      = true;
    itemInformation.currentItem             = item;
    itemPositioner.currentItem              = item;
    shapeToolBar.currentItem                = item;
    shapeToolBar.buttonDisplayPositioner.enabled = true;
    shapeToolBar.spinBoxZStack.to           = canvasEngine.items.length - 1;
    shapeToolBar.spinBoxZStack.value        = item.z
    imageBar.buttonCleanMode.enabled        = true;
    canvasEngine.focus = true;
    enabledItems();
}

/**
 * Wenn die Auswahl der Items wechselt, wird das Signal onItemChanged
 * @param item
 */
function onItemChanged( item ) {
    item.selected                       = true;
    canvasEngine.selectedItem           = item;
    canvasEngine.lastItem               = item;
    itemInformation.currentItem         = item;
    shapeToolBar.spinBoxZStack.enabled  = true;

    layerItem.comboBoxComposition.displayText = item.compositionName;
    layerItem.spinBoxOpacity.value = item.opacity * 100;

    const idx = canvasEngine.items.findIndex( (itm) => itm.name === item.name );
    canvasEngine.lastItemIndex          = idx;
    shapeToolBar.spinBoxZStack.value    = idx;

    selectionRect.x         = canvasEngine.lastItem.x + canvasEngine.x;
    selectionRect.y         = canvasEngine.lastItem.y + canvasEngine.y;
    selectionRect.width     = canvasEngine.lastItem.width;
    selectionRect.height    = canvasEngine.lastItem.height;
    canvasEngine.focus      = true;

    redraw();
}

/**
 * Beim verändern der Position und Größe des Items, wird das SelectionRect angepasst
 * @param rect
 */
function onItemGeometryChanged( rect ) {
    selectionRect.x         = rect.x + canvasEngine.x;
    selectionRect.y         = rect.y + canvasEngine.y;
    selectionRect.width     = rect.width ;
    selectionRect.height    = rect.height;
    canvasEngine.focus      = true;
    //console.log("GeometryChanged")
}

function onItemFilled( filled ) {
    selectionRect.x         = canvasEngine.lastItem.x + canvasEngine.x;
    selectionRect.y         = canvasEngine.lastItem.y + canvasEngine.y;
    selectionRect.width     = canvasEngine.lastItem.width;
    selectionRect.height    = canvasEngine.lastItem.height;
    canvasEngine.focus = true;
}

/**
 * Beim verändern der Position des Items, wird das SelectionRect angepasst
 * @param pt
 */
function onitemPositionChanged ( pt ) {
    selectionRect.x = pt.x + canvasEngine.x;
    selectionRect.y = pt.y + canvasEngine.y;
    canvasEngine.focus = true;
    //console.log("PositionChanged")
}


/**
 * Entfernt alles auf der CanvasEngine, und setzt die Items zurück.
 */
function onCleared() {
    canvasEngine.items.length               = 0;
    canvasEngine.mid                        = 1;
    enabledOnDelete();
    canvasEngine.clearImageData();
    layerItem.layerListModel.clear();
    redraw();
}

/**
 * Verhalten festlegen, beim entfernen eines Items
 */
function onItemRemoved() {
    enabledOnDelete();
    redraw();
}

/**
 * Bestimmen des Verhaltens bei der Auswahl eines Items
 * @param item
 */
function onItemSelected( item ) {

    canvasEngine.selectedItem           = item;
    canvasEngine.selectedItem.selected  = true;
    canvasEngine.lastItem               = item
    canvasEngine.lastItem.selected      = true;
    itemInformation.currentItem         = item;
    itemPositioner.currentItem          = item;
    shapeToolBar.currentItem            = item;

    const globalPos                     = canvasEngine.mapToItem(painterAreaItem, item.x, item.y);
    selectionRect.x                     = globalPos.x
    selectionRect.y                     = globalPos.y
    if ( item.itemType === "LineShape" ) {
        let dx = selectionRect.x - canvasEngine.selectedItem.x;
        let dy = selectionRect.y - canvasEngine.selectedItem.y;

        canvasEngine.selectedItem.width = canvasEngine.selectedItem.x + dx;
        canvasEngine.selectedItem.height = canvasEngine.selectedItem.y + dy;
        selectionRect.width                 = canvasEngine.selectedItem.width
        selectionRect.height                = canvasEngine.selectedItem.height
    } else {
        selectionRect.width                 = item.width
        selectionRect.height                = item.height;
    }


    const index                         = canvasEngine.items.findIndex( (itm) => itm.name === canvasEngine.lastItem.name );
    canvasEngine.lastItemIndex          = index;
    shapeToolBar.spinBoxZStack.value    = index;

    if ( selectionRect.focus ) {
        canvasEngine.focus                  = true;
    } else {

        selectionRect.focus                 = true;
    }

    redraw();
}

/**
 * Bestimmen des Verhaltens bei der Abwahl eines Items
 */
function onItemUnselected () {
    //canvasEngine.selectedItem.selected              = false;
    canvasEngine.selectedItem                       = null;
    if( canvasEngine.lastItem )
        canvasEngine.lastItem.selected              = false;

    itemInformation.currentItem                     = null;
    shapeToolBar.currentItem                        = null;
    shapeToolBar.buttonDisplayPositioner.checked    = false;
    if ( canvasEngine.items.length <= 0 ) {
        canvasEngine.lastItem                       = null;
        canvasEngine.selectedItem                   = null;
        layerItem.enabled                           = canvasEngine.lastItem;
    }
    redraw();
}

/**
 * Vertauschen der Items in den Listen.
 * @param z
 */
function onItemZStack( z ) {
    Index.changeZIndex( canvasEngine.lastItemIndex, z );
    canvasEngine.lastItemIndex  = z;
    canvasEngine.focus          = true;
}

/**
 * Beim verändern der Position des Items, wird das SelectionRect angepasst
 */
function onXYChanged() {
    if ( canvasEngine.selectedItem ) {
        const globalPos     = canvasEngine.mapToItem(painterAreaItem, canvasEngine.selectedItem.x, canvasEngine.selectedItem.y);
        selectionRect.x     = globalPos.x
        selectionRect.y     = globalPos.y
        canvasEngine.focus  = true;
    }
}


















