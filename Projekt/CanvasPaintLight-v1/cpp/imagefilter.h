#ifndef IMAGEFILTER_H
#define IMAGEFILTER_H

#include <QImage>
#include <QObject>
#include <QQuickPaintedItem>

class ImageFilter : public QObject
{
    Q_OBJECT
public:
    ImageFilter(QQuickItem *parent = nullptr);
    ~ImageFilter();
    Q_INVOKABLE void resetFilter();
    Q_INVOKABLE void redFilter(int r = 255 );
    Q_INVOKABLE void greenFilter( int g = 255);
    Q_INVOKABLE void blueFilter( int b = 255);


    QImage originalImage() const;
    void setOriginalImage(const QImage &newOriginalImage);



    bool isActive() const;
    void setIsActive(bool newIsActive);

    QImage sourceImage() const;
    void setSourceImage(const QImage &newSourceImage);

signals:
    void originalImageChanged();



    void isActiveChanged();

    void sourceImageChanged();

private:
    void filterRgbHelper(std::function<void(QRgb &)> cb, QImage &image);

private:
    QImage m_originalImage;
    QImage m_sourceImage;
    bool m_isActive;

    Q_PROPERTY(QImage originalImage READ originalImage WRITE setOriginalImage NOTIFY originalImageChanged FINAL)

    Q_PROPERTY(bool isActive READ isActive WRITE setIsActive NOTIFY isActiveChanged FINAL)
    Q_PROPERTY(QImage sourceImage READ sourceImage WRITE setSourceImage NOTIFY sourceImageChanged FINAL)
};

#endif // IMAGEFILTER_H
