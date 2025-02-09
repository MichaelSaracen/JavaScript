# Projekt Canvas Paint Light
### Dokumentation

D
as Projekt wurde in Qml geschrieben und die Schnittstelle zum Zeichnen mit C++ Qt geschrieben.
Um gleich Missverständnisse auszuräumen betone Ich, dass QML ( Qt Modelling Language ) auf JavaScript basiert:

Qt 5.x verwendete V8 als JavaScript-Engine.
Qt 6 hat die V8-Engine durch QuickJS ersetzt

Die Anwendung enthält eine breite Palette von inline Ausdrücken wie zB:

```js
colorOverlayColor: btnHighligtWhite.checked ? Theme.highlight : "transparent"
```
oder 
```js
property bool darkMode: true
property color background: darkMode ? '#1e2227' : 'white'
property color itemBackground: darkMode ? '#21252b' : '#d0d0d0'
property color borderColor: darkMode ? '#272b33' : '#bcbcbc'
property color foreground: darkMode ? '#d0d0d0' : '#272b33'
property color highlight: darkMode ? '#ff6160' : '#90caf9'
```


[w]

### Mein persönliches Ziel dieses Projektes war es, so viele Funktionalitäten wie möglich einzubinden. So ergeben sich:

#### - 9 Klassen in JavaScript ( eine in C++ -> CanvasEngine )
#### - ca 110 Methoden und Funktionen.
#### - 15 Qml Komponenten ( HelpDialog.qml, Theme.qml, Constants.qml und NewImageDialog.qml sind [unten](#qml---komponenten) nicht abgebildet )
#### - ca 5300 Zeilen ( mit Schnittstelle und Komponenten )


### Info zu den benutzten Icons

####  - Alle benutzten Icons sind von Google. Die Quelle ist im Code für jedes Icon so

![img_3.png](assets/images/code_snip.png)


---


## Klassen

![abstract_item.png](uml/abstract_item.png)

Die abstrakte Klasse dienen als Datencontainer und können wegen :

```js
class AbstractItem {

    constructor(x, y, width, height) {
        if (new.target === AbstractItem)
            throw new Error('Die Abstrakte Klasse AbstractItem kann nicht instanziiert werden.');
        
        ...
    }
}
```
nicht instanziiert werden, was der Klasse einen *abstrakten* Stil gibt.




---

## Funktionalitäten

> Die Anwendung enthält round about 110 Methoden und Funktionen. Von Zeichenoperationen bis hin zur Darstellung
> auf dem Screen. Hier ist eine Vorschau im gif - Format, die Selbst sprechend sein soll.


Hier wird gezeigt, wie man ein Neues Fenster erstellt. 

![newWindow.gif](assets/newWindow.gif)


Öffnen eines Bildes und hinzufügen ober die Menübar

![openImage.gif](assets/openImage.gif)


Speichern eines Bildes als PNG

![saveImage.gif](assets/saveImage.gif)

Formen hinzufügen

![createItems.gif](assets/createItems.gif)

Z - Stack, bzw die Reihenfolge der Items ändern.

![zStack.gif](assets/zStack.gif)

Zoomen

![zoom.gif](assets/zoom.gif)

Hier wird gezeigt wie man ein Item umbenennt

![rename.gif](assets/rename.gif)

Ansichten im Überblick.

![preview.gif](assets/preview.gif)

Positionieren mit dem Tool.

![positioner.gif](assets/positioner.gif)

Element entfernen.

![deleteItem.gif](assets/deleteItem.gif)

Alles löschen.

![delAll.gif](assets/delAll.gif)


Helligkeit - Filter

![brightnessFilter.gif](assets/brightnessFilter.gif)

Der Graustufenfilter

![greyscaleFilter.gif](assets/greyscaleFilter.gif)

Alle anderen Filter angezeigt.

![otherFilter.gif](assets/otherFilter.gif)

Ebenen Transparenz

![opacity.gif](assets/opacity.gif)

Ebenen zu einer zusammenfassen

![mergeItems.gif](assets/mergeItems.gif)

Shortcut Übersicht

![helpShortcuts.gif](assets/helpShortcuts.gif)

Kompositionen

![compositions.gif](assets/compositions.gif)


WASD Movement, wenn das Selection - Rect ausgewählt ist.

![moveSelection.gif](assets/moveSelection.gif)

---

![moveOutSide.gif](assets/images/moveOutSide.gif)

--- 

## QML - Komponenten

Alle implementierten Komponenten kurz gezeigt und beschrieben.

![components.png](assets/images/components.png)

---

### Die CanvasEngine - Komponente
Die Schnittstelle zum Zeichnen, die aus Qt implementiert wurde.

![img_2.png](assets/images/img_2.png)

---

### Das SelectionRect - Komponente

Umrandet alle Items und bewegt diese in bestimmte Richtungen. Kann die Größen verändern und mit WASD bei
Selektion bewegt werden.

![img_3.png](assets/images/img_3.png)

---

### Die ImageBar - Komponente
Kann alle Items auf der CanvasEngine entfernen und ein Raster ein und ausblenden.

![img_4.png](assets/images/img_4.png)

---

### Die ShapeBar - Komponente
Enthält alle implementierten Formen zum Zeichnen und ein Auswahl - Tool.

![img_5.png](assets/images/img_5.png)

---

### Die ShapeToolBar - Komponente

Hält für die Formen verschiedene Einstellungen bereit, wie Höhe, Breite, Füllfarbe und einiges mehr.

![img_7.png](assets/images/img_7.png)

--- 

### Die MyMenuBar - Komponente

Die Menübar verwaltet die Komponenten und hat noch zusätzliche Optionen, wie das Speichern von Bildern
und die Einstellung des RenderHints ( Antialiasing, SmoothPixmapTransformation ... )

![img_6.png](assets/images/img_6.png)

---

### Die ItemInformation - Komponente

Zeigt Informationen wie beispielsweise die Geometrie der aktuellen Form an.

![img_8.png](assets/images/img_8.png)

---

### Die LayerItem - Komponente

Hier finden sich verschiedene Ebenen. Diese werden nach Erstellen einer Form hinzugefügt. Diese erlaubt
noch zusätzliche Bearbeitung, wie zB Komposition oder die Deckkraft einer Form.

![img_9.png](assets/images/img_9.png)

---

### Die FilterItem - Komponente

Enthält Filter - Einstellungen für das komplette Bild und kann auch gespeichert werden 

![img_10.png](assets/images/img_10.png)

### Hier sind einige Beispiele:

## $$ Ohne Filter $$

![filter_wo.png](assets/images/filter_wo.png)

## $$ Kontrast $$

![filter_wktr.png](assets/images/filter_wktr.png)

## $$ Invertiert $$

![filter_wi.png](assets/images/filter_wi.png)

## $$ Sepia Filter $$


![filter_ws.png](assets/images/filter_ws.png)














