#ifndef CANVASENGINE_H
#define CANVASENGINE_H

#include <QImage>
#include <QQuickPaintedItem>
#include <QPainter>



class CanvasEngine : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor fillStyle READ fillStyle  WRITE setFillStyle  NOTIFY fillStyleChanged FINAL)
    Q_PROPERTY(QColor strokeStyle READ strokeStyle WRITE setStrokeStyle NOTIFY strokeStyleChanged FINAL)
    Q_PROPERTY(int lineWidth READ lineWidth WRITE setLineWidth NOTIFY lineWidthChanged FINAL)
    Q_PROPERTY(QPainter::CompositionMode compositionMode READ compositionMode WRITE setCompositionMode NOTIFY compositionModeChanged FINAL)
    Q_PROPERTY(QPainter::RenderHint renderHint READ renderHint WRITE setRenderHint NOTIFY renderHintChanged FINAL)
    QML_ELEMENT
public:
    CanvasEngine(QQuickItem *parent = nullptr);
    ~CanvasEngine();


    enum CompositionMode {
        SourceOver = QPainter::CompositionMode_SourceOver,
        SourceIn = QPainter::CompositionMode_SourceIn,
        SourceOut = QPainter::CompositionMode_SourceOut,
        SourceAtop = QPainter::CompositionMode_SourceAtop,
        Lighten = QPainter::CompositionMode_Lighten,
        SoftLight = QPainter::CompositionMode_SoftLight,
        ColorBurn = QPainter::CompositionMode_ColorBurn,
        HardLight = QPainter::CompositionMode_HardLight,
        Multiply = QPainter::CompositionMode_Multiply,
        Darken = QPainter::CompositionMode_Darken,
        ColorDodge = QPainter::CompositionMode_ColorDodge,
        Difference = QPainter::CompositionMode_Difference,
        DestinationOver = QPainter::CompositionMode_DestinationOver,
        DestinationIn = QPainter::CompositionMode_DestinationIn,
        DestinationOut = QPainter::CompositionMode_DestinationOut,
        DestinationAtop = QPainter::CompositionMode_DestinationAtop,
        Overlay = QPainter::CompositionMode_Overlay,
        Clear = QPainter::CompositionMode_Clear,
        Xor = QPainter::CompositionMode_Xor,
        Screen = QPainter::CompositionMode_Screen,
        Exclusion = QPainter::CompositionMode_Exclusion
    };
    Q_ENUM(CompositionMode)

    enum RenderHint {
        Antialiasing = QPainter::Antialiasing,
        TextAntialiasing = QPainter::TextAntialiasing,
        SmoothPixmapTransform = QPainter::SmoothPixmapTransform,
        VerticalSubpixelPositioning = QPainter::VerticalSubpixelPositioning,
        LosslessImageRendering = QPainter::LosslessImageRendering,
        NonConstMetaTypeInterface = QPainter::NonCosmeticBrushPatterns
    };
    Q_ENUM(RenderHint)

    Q_INVOKABLE void addImage(const QString &fileName, const QString &imageName);
    Q_INVOKABLE void applyBrightnessFilter(int delta);
    Q_INVOKABLE void applyBlurFilter(bool enabled);
    Q_INVOKABLE void applyContrastFilter(bool enabled);
    Q_INVOKABLE void applyInvertFilter(bool enabled);
    Q_INVOKABLE void applySepiaFilder(bool enabled);
    Q_INVOKABLE void applyWarmFilter(bool enabled);
    Q_INVOKABLE QImage base64ToImage(const QString &base64String);
    Q_INVOKABLE void clearImageData();
    Q_INVOKABLE void clearRect(int x, int y, int w, int h);
    Q_INVOKABLE void createBackground(int width, int height, const QColor &clr);
    Q_INVOKABLE QString createMergedImage(int minX, int minY, int maxWidth, int maxHeight, const QVariantList &itemsData);

    QPainter::CompositionMode compositionMode() const;
    Q_INVOKABLE void setCompositionMode(QPainter::CompositionMode newCompositionMode);

    Q_INVOKABLE void drawArc(int x, int y, int w, int h, int from = 0, int to = 270);
    Q_INVOKABLE void drawEllipse(int x, int y, int w, int h);
    Q_INVOKABLE void drawGrid(bool visible = false, const QColor &clr = Qt::black);
    Q_INVOKABLE void drawImage(int x, int y, int w, int h, const QString &name);
    Q_INVOKABLE void drawMergedImage(int minX, int minY, int maxWidth, int maxHeight, const QImage &img);
    Q_INVOKABLE void drawLine(int x1, int y1, int x2, int y2);
    Q_INVOKABLE void drawOnFilter(const QImage &img);
    Q_INVOKABLE void drawPie(int x, int y, int w, int h, int from = 0, int to = 270);
    Q_INVOKABLE void drawRect(int x, int y, int w, int h, int radius = 0);
    Q_INVOKABLE void enableFilter ( bool enabled );
    Q_INVOKABLE void erase(int x, int y, int w, int h);

    void setFillStyle(const QColor &clr);
    QColor fillStyle() const;

    Q_INVOKABLE bool filterIsActive() const;
    Q_INVOKABLE QString getImageData() const;
    Q_INVOKABLE void grayscaleFilter(qreal val);
    Q_INVOKABLE void highlightWhite(bool enabled);

    int lineWidth() const;
    void setLineWidth(int newLineWidth);

    void paint(QPainter *painter);
    Q_INVOKABLE void renameImage(const QString& oldOld, const QString& newName);
    Q_INVOKABLE void removeImage(const QString& name);

    QPainter::RenderHint renderHint() const;
    Q_INVOKABLE void setRenderHint(QPainter::RenderHint newRenderHinter);

    Q_INVOKABLE void resetFilter();
    Q_INVOKABLE void saveImage(const QString &path);
    Q_INVOKABLE void setLayerOpacity(qreal newPictureOpacity);

    QColor strokeStyle() const;
    void setStrokeStyle(const QColor &newStrokeStyle);

signals:
    void fillStyleChanged();
    void lineWidthChanged();
    void strokeStyleChanged();
    void compositionModeChanged();
    void renderHintChanged();

private:
    void draw(std::function<void(QPainter&)> callBack);

private:
    QImage m_image;
    QColor m_fillStyle;
    QColor m_strokeStyle;

    int m_lineWidth;
    qreal m_pictureOpacity;
    QPainter::CompositionMode m_compositionMode;
    QPainter::RenderHint m_renderHint;

    QList<QImage> m_images;
    QStringList m_imageNames;
    int m_lastVal = 0;
    QImage m_filterImage;
    QImage m_originalImage;
    bool m_filterEnabled;
    bool m_toSaveFilter;

};

#endif // CANVASENGINE_H






























