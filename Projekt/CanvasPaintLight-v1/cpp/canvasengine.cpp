#include "canvasengine.h"

#include <QBuffer>
#include <QPainter>
// #include <algorithm>
#include <QFileDialog>
#include <QtConcurrent>



CanvasEngine::CanvasEngine(QQuickItem *parent):
    QQuickPaintedItem(parent),
    m_compositionMode(QPainter::CompositionMode_SourceOver),
    m_renderHint(QPainter::Antialiasing),
    m_filterEnabled(false),
    m_toSaveFilter(false)
{

    m_fillStyle = QColor("white");
    m_strokeStyle = QColor("black");
    m_lineWidth = 1;
    m_pictureOpacity = 1;

}

CanvasEngine::~CanvasEngine() {  }


bool CanvasEngine::filterIsActive() const { return m_filterEnabled; }

/*!
 * \brief CanvasEngine::grayscaleFilter
 * Wendet einen Graustufenfilter auf das Bild an.
 * \param val Ein Wert zwischen 0 und 255, der die Intensität des Filters bestimmt.
 *            Ein Wert von 0 setzt den Filter zurück.
 */
void CanvasEngine::grayscaleFilter(qreal val)
{
    if ( !m_filterEnabled ) return;

    if (val <= 0) {
        resetFilter();
        qDebug() << "Wert ist 0, der Filter wird zurückgesetzt";
        return;
    }

    double factor = val / 255.0;

    for (int y = 0; y < m_image.height(); ++y) {
        QRgb *origLine = reinterpret_cast<QRgb*>(m_image.scanLine(y));
        QRgb *line = reinterpret_cast<QRgb*>(m_filterImage.scanLine(y));

        for (int x = 0; x < m_image.width(); ++x) {
            QRgb origPixel = line[x];
            int red   = qRed(origPixel);
            int green = qGreen(origPixel);
            int blue  = qBlue(origPixel);
            int alpha = qAlpha(origPixel);

            int gray = red * 0.3 + green * 0.5 + blue * 0.1;

            int newRed   = (1.0 - factor) * red   + factor * gray;
            int newGreen = (1.0 - factor) * green + factor * gray;
            int newBlue  = (1.0 - factor) * blue  + factor * gray;


            origLine[x] = qRgba(newRed, newGreen, newBlue, alpha);
        }
    }
    update();
}

/*!
 * \brief CanvasEngine::highlightWhite
 * Hebt helle Bereiche des Bildes hervor, indem alle Pixel mit RGB-Werten über einem bestimmten Schwellenwert weiß gefärbt werden.
 * \param enabled Wenn true, wird der Filter angewendet, andernfalls wird er zurückgesetzt.
 */
void CanvasEngine::highlightWhite(bool enabled) {

    if (!enabled) {
        resetFilter();
        qDebug() << "highlightWhite an ? " << (bool)(enabled);
        return;
    }

    for ( int y = 0; y < m_image.height(); ++y ) {
        QRgb *line = reinterpret_cast<QRgb*>(m_image.scanLine(y));
        for ( int x = 0; x < m_image.width(); ++x ) {
            int red = qRed(line[x]);
            int green = qGreen(line[x]);
            int blue = qBlue(line[x]);
            int alpha = qAlpha(line[x]);
            if ( red > 50 && green > 50 && blue > 50 ) {
                line[x] = qRgba(255, 255, 255, alpha);
            } else {
                line[x] = qRgba(red, green , blue, alpha);
            }
        }
    }
    update();
}

/*!
 * \brief CanvasEngine::applySepiaFilder
 * Wendet einen Sepia-Filter auf das Bild an.
 * \param enabled Wenn true, wird der Filter angewendet, andernfalls wird er zurückgesetzt.
 */
void CanvasEngine::applySepiaFilder(bool enabled)
{
    if (!enabled) {
        resetFilter();
        qDebug() << "Sepia-Filter deaktiviert ";
        return;
    }

    for ( int y = 0; y < m_image.height(); ++y) {
        QRgb* line = reinterpret_cast<QRgb*>(m_image.scanLine(y));
        for ( int x = 0; x < m_image.width(); ++x ) {
            int red = qRed(line[x]);
            int green = qGreen(line[x]);
            int blue = qBlue(line[x]);
            int alpha = qAlpha(line[x]);

            int sepiaRed = qBound(0, int(0.393 * red + 0.769 * green + 0.189 * blue), 255);
            int sepiaGreen = qBound(0, int(0.349 * red + 0.686 * green + 0.168 * blue), 255);
            int sepiaBlue  = qBound(0, int(0.272 * red + 0.534 * green + 0.131 * blue), 255);

            line[x] = qRgba(sepiaRed, sepiaGreen, sepiaBlue, alpha);
        }
    }
    update();
}

/*!
 * \brief CanvasEngine::applyInvertFilter
 * Invertiert die Farben des Bildes.
 * \param enabled Wenn true, wird der Filter angewendet, andernfalls wird er zurückgesetzt.
 */
void CanvasEngine::applyInvertFilter( bool enabled )
{
    if ( !enabled)  {
        resetFilter();
        qDebug() << "Invert-Filter deaktiviert ";
        return;
    }

    for (int y = 0; y < m_image.height(); ++y) {
        QRgb* line = reinterpret_cast<QRgb*>(m_image.scanLine( y ));

        for (int x = 0; x < m_image.width(); ++x) {
            int red = qRed(line[x]);
            int green = qGreen(line[x]);
            int blue = qBlue(line[x]);
            int alpha = qAlpha(line[x]);

            int invertedRed = 255 - red;
            int invertedGreen = 255 - green;
            int invertedBlue = 255 - blue;

            line[x] = qRgba(invertedRed, invertedGreen, invertedBlue, alpha);
        }
    }

    update();
}

/*!
 * \brief CanvasEngine::applyBrightnessFilter
 * Ändert die Helligkeit des Bildes um einen bestimmten Wert.
 * \param delta Der Wert, um den die Helligkeit angepasst wird (positiv für Aufhellen, negativ für Abdunkeln).
 *              Ein Wert von 0 setzt den Filter zurück.
 */
void CanvasEngine::applyBrightnessFilter( int delta )
{
    if ( !m_filterEnabled ) return;

    if (delta == 0) {
        resetFilter();
        qDebug() << "Wert ist 0, der Filter wird zurückgesetzt";
        return;
    }

    for (int y = 0; y < m_image.height(); ++y) {
        QRgb *origLine = reinterpret_cast<QRgb*>(m_image.scanLine(y));
        QRgb *line = reinterpret_cast<QRgb*>(m_filterImage.scanLine(y));

        for (int x = 0; x < m_image.width(); ++x) {
            QRgb origPixel = line[x];
            int red = qRed(origPixel);
            int green = qGreen(origPixel);
            int blue = qBlue(origPixel);
            int alpha = qAlpha(origPixel);

            int newRed = qBound(0, red + delta, 255);
            int newGreen = qBound(0, green + delta, 255);
            int newBlue = qBound(0, blue + delta, 255);

            origLine[x] = qRgba(newRed, newGreen, newBlue, alpha);
        }
    }

    update();
}

/*!
 * \brief CanvasEngine::applyBlurFilter
 * Wendet einen Weichzeichner (Blur-Effekt) auf das Bild an.
 * \param enabled Wenn true, wird der Filter angewendet, andernfalls wird er zurückgesetzt.
 */
void CanvasEngine::applyBlurFilter( bool enabled )
{
    if ( !enabled ) {
        resetFilter();
        return;
    }

    QImage temp = m_image.copy();

    for (int y = 1; y < m_image.height() - 1; ++y) {
        QRgb* prevLine = reinterpret_cast<QRgb*>(temp.scanLine(y - 1));
        QRgb* currLine = reinterpret_cast<QRgb*>(temp.scanLine(y));
        QRgb* nextLine = reinterpret_cast<QRgb*>(temp.scanLine(y + 1));
        QRgb* targetLine = reinterpret_cast<QRgb*>(m_image.scanLine(y));

        for (int x = 1; x < m_image.width() - 1; ++x) {
            int red = (qRed(prevLine[x - 1]) + qRed(prevLine[x]) + qRed(prevLine[x + 1]) +
                       qRed(currLine[x - 1]) + qRed(currLine[x]) + qRed(currLine[x + 1]) +
                       qRed(nextLine[x - 1]) + qRed(nextLine[x]) + qRed(nextLine[x + 1])) / 9;

            int green = (qGreen(prevLine[x - 1]) + qGreen(prevLine[x]) + qGreen(prevLine[x + 1]) +
                         qGreen(currLine[x - 1]) + qGreen(currLine[x]) + qGreen(currLine[x + 1]) +
                         qGreen(nextLine[x - 1]) + qGreen(nextLine[x]) + qGreen(nextLine[x + 1])) / 9;

            int blue = (qBlue(prevLine[x - 1]) + qBlue(prevLine[x]) + qBlue(prevLine[x + 1]) +
                        qBlue(currLine[x - 1]) + qBlue(currLine[x]) + qBlue(currLine[x + 1]) +
                        qBlue(nextLine[x - 1]) + qBlue(nextLine[x]) + qBlue(nextLine[x + 1])) / 9;

            targetLine[x] = qRgba(red, green, blue, qAlpha(currLine[x]));
        }
    }
    update();
}


/*!
 * \brief CanvasEngine::applyContrastFilter
 * Erhöht den Kontrast des Bildes.
 * \param enabled Wenn true, wird der Filter angewendet, andernfalls wird er zurückgesetzt.
 */
void CanvasEngine::applyContrastFilter( bool enabled )
{
    if ( !enabled ) {
        resetFilter();
        return;
    }

    const double factor = 1.2;

    for (int y = 0; y < m_image.height(); ++y) {
        QRgb* line = reinterpret_cast<QRgb*>(m_image.scanLine(y));
        for (int x = 0; x < m_image.width(); ++x) {
            int red = qRed(line[x]);
            int green = qGreen(line[x]);
            int blue = qBlue(line[x]);
            int alpha = qAlpha(line[x]);

            red = qBound(0, int(((red - 128) * factor) + 128), 255);
            green = qBound(0, int(((green - 128) * factor) + 128), 255);
            blue = qBound(0, int(((blue - 128) * factor) + 128), 255);

            line[x] = qRgba(red, green, blue, alpha);
        }
    }
    update();
}

/*!
 * \brief CanvasEngine::applyWarmFilter
 * Wendet einen Warmfilter auf das Bild an, indem die Rottöne verstärkt und die Blautöne abgeschwächt werden.
 * \param enabled Wenn true, wird der Filter angewendet, andernfalls wird er zurückgesetzt.
 */
void CanvasEngine::applyWarmFilter( bool enabled )
{
    if ( !enabled ) {
        resetFilter();
        return;
    }

    for (int y = 0; y < m_image.height(); ++y) {
        QRgb* line = reinterpret_cast<QRgb*>(m_image.scanLine(y));
        for (int x = 0; x < m_image.width(); ++x) {
            int red = qRed(line[x]) + 20;
            int green = qGreen(line[x]) + 10;
            int blue = qBlue(line[x]) - 10;
            int alpha = qAlpha(line[x]);

            line[x] = qRgba(qBound(0, red, 255), qBound(0, green, 255), qBound(0, blue, 255), alpha);
        }
    }
    update();
}

/*!
 * \brief CanvasEngine::enableFilter
 * Aktiviert oder deaktiviert den Filter. Wenn aktiviert, wird eine Kopie des Originalbildes erstellt, die später wiederhergestellt werden kann.
 * \param enabled Wenn true, wird der Filter aktiviert, andernfalls wird er deaktiviert.
 */
void CanvasEngine::enableFilter ( bool enabled )
{
    if ( enabled ) {
        m_originalImage = m_image.copy();
        m_filterImage   = m_image.copy();
    }

    m_filterEnabled = enabled;
    qDebug() << "Filter ist activ: " << (bool)(m_filterEnabled);
    update();
}

/*!
 * \brief CanvasEngine::resetFilter
 * Setzt den angewendeten Filter zurück und stellt das Originalbild wieder her.
 */
void CanvasEngine::resetFilter() {
    m_image         = m_originalImage.copy();
    update();
}

/*!
 * \brief CanvasEngine::paint
 * Zeichnet das Bild und fügt ein Raster hinzu, das als Hintergrund dient.
 * \param painter Ein Zeiger auf den QPainter, der für das Zeichnen auf der Oberfläche verwendet wird.
 */
void CanvasEngine::paint(QPainter *painter)
{
    const int cellSize = 10;
    const int  mod = 20;

    painter->setPen(Qt::NoPen);
    for (int y = 0; y < height(); y+= cellSize) {
        for (int x = 0; x < width(); x+= cellSize ) {

            QColor color = (static_cast<int>(std::floor(y / cellSize)) % 2 == 0)
            ? (x % mod == 0 ? Qt::white : QColor(0xd0, 0xd0, 0xd0))
            : (x % mod == 0 ? QColor(0xd0, 0xd0, 0xd0) : Qt::white);

            QBrush brush(color);

            painter->setBrush(brush);
            painter->drawRect(x, y, cellSize, cellSize);
        }
    }

    painter->drawImage(0, 0, m_image);
}


/*!
 * \brief CanvasEngine::addImage
 * Fügt ein Bild zur Sammlung hinzu und speichert das Originalbild.
 * \param fileName Der Pfad zum Bild.
 * \param imageName Der Name des Bildes, der hinzugefügt wird.
 */
void CanvasEngine::addImage(const QString &fileName, const QString &imageName)
{

    QUrl url(fileName);
    QString filePath = url.isLocalFile() ? url.toLocalFile() : fileName;

    m_imageNames.append(imageName);
    QImage img(filePath);
    m_images.append(img);

    m_originalImage = img;

    update();
}

/*!
 * \brief CanvasEngine::createBackground
 * Erstellt ein Hintergrundbild in der angegebenen Größe und mit der angegebenen Farbe.
 * \param width Die Breite des Hintergrunds.
 * \param height Die Höhe des Hintergrunds.
 * \param clr Die Farbe, mit der der Hintergrund gefüllt wird.
 */
void CanvasEngine::createBackground(int width, int height, const QColor &clr)
{
    m_image = QImage(width, height, QImage::Format_ARGB32);
    m_image.fill(clr);
    QPainter painter(&m_image);
    painter.drawImage(0,0, m_image);

    update();
}

/*!
 * \brief CanvasEngine::clearRect
 * Löscht einen rechteckigen Bereich des Bildes und setzt ihn auf transparent.
 * \param x Die x-Position des oberen linken Punktes des Rechtecks.
 * \param y Die y-Position des oberen linken Punktes des Rechtecks.
 * \param w Die Breite des zu löschenden Rechtecks.
 * \param h Die Höhe des zu löschenden Rechtecks.
 */
void CanvasEngine::clearRect(int x, int y, int w, int h)
{

    if (m_image.isNull()) {
        qDebug() << "Fehler: m_image ist leer!";
        return;
    }

    QPainter painter(&m_image);
    painter.setCompositionMode(QPainter::CompositionMode_Source);
    painter.fillRect(x, y, w, h, Qt::transparent);  // Lösche den Bereich mit Transparenz!
    painter.end();  // Wichtig!

    update();
}


/*!
 * \brief CanvasEngine::drawGrid
 * Zeichnet ein Gitternetz auf das Bild, wenn es aktiviert ist.
 * \param visible Wenn true, wird das Gitternetz angezeigt, andernfalls wird es nicht angezeigt.
 * \param clr Die Farbe des Gitternetzes.
 */
void CanvasEngine::drawGrid(bool visible, const QColor &clr)
{
    if ( visible ) {
        draw([=] (QPainter &painter) {
            painter.setOpacity(0.2);
            painter.setPen(QPen(clr, 1));
            for ( int y = 10; y < height(); y += 10 ) {
                painter.drawLine(0, y, width(), y);
            }
            for ( int x = 10; x < width(); x += 10 ) {
                painter.drawLine(x, 0, x, height());
            }
        });
    } else {
        update();
    }
}



/*!
 * \brief CanvasEngine::draw
 * Eine private Hilfsfunktion zum Zeichnen von Formen mit verschiedenen Einstellungen für den Pinsel, die Linie, die Opazität und die Zusammensetzungsmodus.
 * \param callBack Eine Callback-Funktion, die den QPainter für das Zeichnen verwendet.
 */
void CanvasEngine::draw(std::function<void (QPainter &)> callBack)
{
    QPainter painter(&m_image);
    painter.setRenderHint(m_renderHint);
    painter.setCompositionMode(m_compositionMode);
    painter.setOpacity(m_pictureOpacity);
    painter.setBrush(QBrush(m_fillStyle));
    painter.setPen(QPen(m_strokeStyle, m_lineWidth));

    callBack(painter);

}

/*!
 * \brief CanvasEngine::clearImageData
 * Löscht alle gespeicherten Bilder und Bildnamen.
 */
void CanvasEngine::clearImageData()
{
    m_images.clear();
    m_imageNames.clear();
}

/*!
 * \brief CanvasEngine::drawArc
 * Zeichnet einen Bogen (Arc) auf das Bild.
 * \param x Die x-Position des Bogens.
 * \param y Die y-Position des Bogens.
 * \param w Die Breite des Bogens.
 * \param h Die Höhe des Bogens.
 * \param from Der Startwinkel des Bogens (in Grad).
 * \param to Der Endwinkel des Bogens (in Grad).
 */
void CanvasEngine::drawArc(int x, int y, int w, int h, int from, int to)
{
    draw([=](QPainter &painter) { painter.drawArc(x,y,w,h, from * 16, to * 16); });
}

/*!
 * \brief CanvasEngine::drawEllipse
 * Zeichnet eine Ellipse auf das Bild.
 * \param x Die x-Position des Rahmens der Ellipse.
 * \param y Die y-Position des Rahmens der Ellipse.
 * \param w Die Breite der Ellipse.
 * \param h Die Höhe der Ellipse.
 */
void CanvasEngine::drawEllipse(int x, int y, int w, int h)
{
    draw([=](QPainter &painter) { painter.drawEllipse(x,y,w,h); });
}

/*!
 * \brief CanvasEngine::drawImage
 * Zeichnet ein Bild auf das Canvas an der angegebenen Position.
 * \param x Die x-Position des Bildes.
 * \param y Die y-Position des Bildes.
 * \param w Die Breite des Bildes.
 * \param h Die Höhe des Bildes.
 * \param name Der Name des Bildes, das gezeichnet werden soll.
 */
void CanvasEngine::drawImage(int x, int y, int w, int h, const QString &name)
{
    QImage &img = m_images[m_imageNames.indexOf(name)];

    QPainter painter(&m_image);
    painter.setRenderHint(m_renderHint);
    painter.setOpacity(m_pictureOpacity);
    painter.setCompositionMode(m_compositionMode);
    painter.drawImage(QRectF(x,y,w,h), img);

}

/*!
 * \brief CanvasEngine::createMergedImage
 * Erstellt ein neues Bild durch Zusammenfügen mehrerer Elemente, die in einer Liste übergeben werden.
 * \param minX Der minimale X-Wert für die Position der Elemente.
 * \param minY Der minimale Y-Wert für die Position der Elemente.
 * \param maxWidth Die maximale Breite des neuen Bildes.
 * \param maxHeight Die maximale Höhe des neuen Bildes.
 * \param itemsData Eine Liste von Daten, die die zu zeichnenden Elemente beschreiben.
 * \return Ein Base64-kodiertes PNG-Bild, das das zusammengefügte Bild darstellt.
 */
QString CanvasEngine::createMergedImage(int minX, int minY, int maxWidth, int maxHeight, const QVariantList &itemsData)
{
    if (itemsData.isEmpty()) {
        return QString();
    }

    QImage merged(maxWidth, maxHeight, QImage::Format_ARGB32);

    QPainter painterMerged(&merged);
    painterMerged.setRenderHint(QPainter::Antialiasing);

    for (const QVariant &itemVar : itemsData) {
        QVariantMap item = itemVar.toMap();
        int x = item["x"].toInt() - minX;
        int y = item["y"].toInt() - minY;
        int w = item["width"].toInt();
        int h = item["height"].toInt();
        int radius = item["radius"].toInt();
        int from = item["item"].toInt();
        int to = item["item"].toInt();

        QString type = item["type"].toString();
        QString strokeStyle = item["strokeStyle"].toString();
        QString fillStyle = item["fillStyle"].toString();
        int lineWidth = item["lineWidth"].toInt();

        if ( type == "RectangleShape") {
            painterMerged.setBrush(QBrush(QColor(fillStyle)));
            painterMerged.setPen(QPen(QColor(strokeStyle), lineWidth));
            painterMerged.drawRoundedRect(x,y,w,h, radius, radius);
        }
        else if ( type == "EllipseShape") {
            painterMerged.setBrush(QBrush(QColor(fillStyle)));
            painterMerged.setPen(QPen(QColor(strokeStyle), lineWidth));
            painterMerged.drawEllipse(x,y,w,h);
        }

        else if ( type == "ArcShape") {
            painterMerged.setBrush(QBrush(QColor(fillStyle)));
            painterMerged.setPen(QPen(QColor(strokeStyle), lineWidth));
            //painterMerged.drawEllipse(x,y,w,h);
            painterMerged.drawPie(x,y,w,h,from * 16, to * 16);
        }

        else if ( type == "PieShape") {
            painterMerged.setBrush(QBrush(QColor(fillStyle)));
            painterMerged.setPen(QPen(QColor(strokeStyle), lineWidth));
            painterMerged.drawPie(x,y,w,h,from * 16, to * 16);
        }

        else if ( type == "LineShape") {
            painterMerged.setBrush(QBrush(QColor(fillStyle)));
            painterMerged.setPen(QPen(QColor(strokeStyle), lineWidth));
            painterMerged.drawLine(x,y,w,h);
        }
        else if (type == "ImageItem") {
            QVariant sourceVar = item["source"];
            QImage img;
            if (sourceVar.canConvert<QUrl>()) {
                QUrl sourceUrl = sourceVar.toUrl();
                QString sourceStr = sourceUrl.toLocalFile();

                if (sourceStr.length() > 0) {
                    img.load(sourceStr);
                } else {
                    img = base64ToImage(sourceVar.toString());
                }
            }
            else {
                img = base64ToImage(sourceVar.toString());
            }
            painterMerged.drawImage(QRect(x,y,w,h), img);

            if (!img.isNull()) {
                painterMerged.drawImage(QRect(x, y, w, h), img);
            }
        }
        qDebug() << type;
    }
    QByteArray byteArray;
    QBuffer buffer(&byteArray);
    buffer.open(QIODevice::WriteOnly);
    merged.save(&buffer, "PNG");

    QString base64Image = byteArray.toBase64();
    return base64Image;

}

/*!
 * \brief CanvasEngine::getImageData
 * Gibt das aktuelle Bild als Base64-kodiertes PNG-Bild zurück.
 * \return Ein Base64-kodiertes PNG-Bild.
 */
QString CanvasEngine::getImageData() const
{
    QImage image = m_image;
    QByteArray byteArray;
    QBuffer buffer( &byteArray );
    buffer.open( QIODevice::WriteOnly );
    image.save( &buffer, "PNG" );

    QString base64Image = byteArray.toBase64();
    return base64Image;
}

/*!
 * \brief CanvasEngine::drawMergedImage
 * Zeichnet ein zusammengeführtes Bild auf das Canvas an der angegebenen Position.
 * \param minX Die minimale x-Position des Bildes.
 * \param minY Die minimale y-Position des Bildes.
 * \param maxWidth Die maximale Breite des Bildes.
 * \param maxHeight Die maximale Höhe des Bildes.
 * \param img Das Bild, das gezeichnet werden soll.
 */
void CanvasEngine::drawMergedImage(int minX, int minY, int maxWidth, int maxHeight, const QImage &img)
{
    QPainter painter(&m_image);
    painter.setRenderHint(QPainter::Antialiasing);
    painter.setOpacity(m_pictureOpacity);
    painter.setCompositionMode(m_compositionMode);
    painter.drawImage(QRectF(minX,minY,maxWidth,maxHeight), img);
}

/*!
 * \brief CanvasEngine::base64ToImage
 * Konvertiert einen Base64-kodierten String in ein QImage.
 * \param base64String Der Base64-kodierte String, der das Bild darstellt.
 * \return Das konvertierte QImage.
 */
QImage CanvasEngine::base64ToImage(const QString &base64String)
{
    QByteArray byteArray = QByteArray::fromBase64(base64String.toUtf8());
    QImage image;
    image.loadFromData(byteArray, "PNG");  // Lade das QImage aus den Bytes
    return image;
}

/*!
 * \brief CanvasEngine::drawLine
 * Zeichnet eine Linie von der Punkt (x1, y1) zu (x2, y2).
 * \param x1 Die x-Position des Startpunkts.
 * \param y1 Die y-Position des Startpunkts.
 * \param x2 Die x-Position des Endpunkts.
 * \param y2 Die y-Position des Endpunkts.
 */
void CanvasEngine::drawLine(int x1, int y1, int x2, int y2)
{
    draw([=] (QPainter &painter) { painter.drawLine( x1, y1, x2, y2 ); });
    update();
}

/*!
 * \brief CanvasEngine::drawPie
 * Zeichnet ein Pie (Kreisstück) auf das Canvas.
 * \param x Die x-Position des Rahmens des Pies.
 * \param y Die y-Position des Rahmens des Pies.
 * \param w Die Breite des Rahmens des Pies.
 * \param h Die Höhe des Rahmens des Pies.
 * \param from Der Startwinkel des Pie (in Grad).
 * \param to Der Endwinkel des Pie (in Grad).
 */
void CanvasEngine::drawPie(int x, int y, int w, int h, int from, int to)
{
    draw([=](QPainter &painter) { painter.drawPie(x,y,w,h, from * 16, to * 16); });
}

/*!
 * \brief CanvasEngine::drawRect
 * Zeichnet ein Rechteck mit abgerundeten Ecken auf das Canvas.
 * \param x Die x-Position des Rahmens des Rechtecks.
 * \param y Die y-Position des Rahmens des Rechtecks.
 * \param w Die Breite des Rechtecks.
 * \param h Die Höhe des Rechtecks.
 * \param radius Der Radius der abgerundeten Ecken.
 */
void CanvasEngine::drawRect(int x, int y, int w, int h, int radius)
{
    draw([=](QPainter &painter){ painter.drawRoundedRect(x,y,w,h, radius, radius); });
}

/*!
 * \brief CanvasEngine::drawOnFilter
 * Setzt das aktuelle Bild auf das übergebene Bild und zeichnet es darauf.
 * \param img Das Bild, das auf das Canvas angewendet werden soll.
 */
void CanvasEngine::drawOnFilter(const QImage &img)
{
    m_image = img;
    QPainter painter(&m_image);
    painter.drawImage(0,0, m_image);
    update();
}

/*!
 * \brief CanvasEngine::erase
 * Löscht einen Bereich auf dem Canvas, indem er mit Transparenz gefüllt wird.
 * \param x Die x-Position des zu löschenden Bereichs.
 * \param y Die y-Position des zu löschenden Bereichs.
 * \param w Die Breite des zu löschenden Bereichs.
 * \param h Die Höhe des zu löschenden Bereichs.
 */
void CanvasEngine::erase(int x, int y, int w, int h)
{
    QPainter painter(&m_image);
    painter.setCompositionMode(QPainter::CompositionMode_Clear); // Löscht Pixel durch Transparenz
    painter.fillRect(x, y, w, h, Qt::transparent);
    painter.end();
    update();
}


/*!
 * \brief CanvasEngine::removeImage
 * Entfernt ein Bild aus der Liste der gespeicherten Bilder.
 * \param name Der Name des Bildes, das entfernt werden soll.
 */
void CanvasEngine::removeImage(const QString &name)
{

    int index = m_imageNames.indexOf(name);
    qDebug() << name << "entfernen";
    qDebug() << m_imageNames;
    m_images.removeAt(index);
    m_imageNames.removeAt(index);
    qDebug() << m_imageNames;
}

/*!
 * \brief CanvasEngine::renameImage
 * Benennt ein Bild in der Liste um.
 * \param oldOld Der alte Name des Bildes.
 * \param newName Der neue Name des Bildes.
 */
void CanvasEngine::renameImage(const QString &oldOld, const QString &newName)
{
    if ( oldOld.length() == 0) return;
    qDebug() << "Bild umbenennen von: " << oldOld << "zu" << newName;
    qDebug() << "vorher" <<  m_imageNames;
    int index           = m_imageNames.indexOf(oldOld);
    m_imageNames[index] = newName;
    qDebug() <<  "nachher" <<  m_imageNames;
}

/*!
 * \brief CanvasEngine::saveImage
 * Speichert das aktuelle Bild als PNG-Datei an einem angegebenen Pfad.
 * \param path Der Pfad, an dem das Bild gespeichert werden soll.
 */
void CanvasEngine::saveImage(const QString &path)
{
    QUrl url(path);

    QString filePath = url.isLocalFile() ? url.toLocalFile() : path;

    qDebug() << "Speichere Bild nach:" << filePath;
    bool success = m_image.save(filePath, "PNG");
    if (success) {
        qDebug() << "Bild erfolgreich gespeichert.";
    } else {
        qDebug() << "Fehler beim Speichern des Bildes!";
    }
}

/*!
 * \brief CanvasEngine::setLayerOpacity
 * Setzt die Opazität des Bildes (durchsichtigkeit).
 * \param newPictureOpacity Die neue Opazität des Bildes.
 */
void CanvasEngine::setLayerOpacity(qreal newPictureOpacity)
{
    m_pictureOpacity = newPictureOpacity;
    update();
}

/*!
 * \brief CanvasEngine::compositionMode
 * Gibt den aktuellen Zusammensetzungsmodus des QPainter zurück.
 * \return Der aktuelle Zusammensetzungsmodus.
 */
QPainter::CompositionMode CanvasEngine::compositionMode() const { return m_compositionMode; }

/*!
 * \brief CanvasEngine::setCompositionMode
 * Setzt den Zusammensetzungsmodus des QPainter.
 * \param newCompositionMode Der neue Zusammensetzungsmodus.
 */
void CanvasEngine::setCompositionMode(QPainter::CompositionMode newCompositionMode)
{
    m_compositionMode = newCompositionMode;
    emit compositionModeChanged();
    update();
}

/*!
 * \brief CanvasEngine::fillStyle
 * Gibt den aktuellen Füllstil des QPainter zurück.
 * \return Der aktuelle Füllstil.
 */
QColor CanvasEngine::fillStyle() const { return m_fillStyle; }

/*!
 * \brief CanvasEngine::setFillStyle
 * Setzt den Füllstil des QPainter.
 * \param clr Der neue Füllstil.
 */
void CanvasEngine::setFillStyle(const QColor &clr) { m_fillStyle = clr; emit fillStyleChanged(); }

/*!
 * \brief CanvasEngine::lineWidth
 * Gibt die aktuelle Linienbreite des QPainter zurück.
 * \return Die aktuelle Linienbreite.
 */
int CanvasEngine::lineWidth() const { return m_lineWidth; }

/*!
 * \brief CanvasEngine::setLineWidth
 * Setzt die Linienbreite des QPainter.
 * \param newLineWidth Die neue Linienbreite.
 */
void CanvasEngine::setLineWidth(int newLineWidth) { m_lineWidth = newLineWidth; emit lineWidthChanged(); }

/*!
 * \brief CanvasEngine::renderHint
 * Gibt den aktuellen Rendering-Hinweis des QPainter zurück.
 * \return Der aktuelle Rendering-Hinweis.
 */
QPainter::RenderHint CanvasEngine::renderHint() const { return m_renderHint; }

/*!
 * \brief CanvasEngine::setRenderHint
 * Setzt den Rendering-Hinweis des QPainter.
 * \param newRenderHinter Der neue Rendering-Hinweis.
 */
void CanvasEngine::setRenderHint(QPainter::RenderHint newRenderHinter)
{
    m_renderHint = newRenderHinter;
    emit renderHintChanged();
    update();
}

/*!
 * \brief CanvasEngine::strokeStyle
 * Gibt den aktuellen Strichstil des QPainter zurück.
 * \return Der aktuelle Strichstil.
 */
QColor CanvasEngine::strokeStyle() const { return m_strokeStyle; }

/*!
 * \brief CanvasEngine::setStrokeStyle
 * Setzt den Strichstil des QPainter.
 * \param newStrokeStyle Der neue Strichstil.
 */
void CanvasEngine::setStrokeStyle(const QColor &newStrokeStyle) { m_strokeStyle = newStrokeStyle; emit strokeStyleChanged(); }
