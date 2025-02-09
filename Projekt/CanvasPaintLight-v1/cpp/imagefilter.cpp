#include "imagefilter.h"
#include <QDebug>


ImageFilter::ImageFilter(QQuickItem *parent)
    : QObject(parent), m_isActive(false)
{

}

ImageFilter::~ImageFilter()
{
    qDebug() << "ImageFilter - dtor";
}

void ImageFilter::resetFilter()
{
    m_sourceImage = m_originalImage;
}

void ImageFilter::redFilter( int r )
{
    QImage img;
    if ( r == 0) m_sourceImage = QImage(m_originalImage);
    else img = m_sourceImage;

    filterRgbHelper([=](QRgb &rgb) { rgb = qRgba(r, qGreen(rgb), qBlue(rgb), qAlpha(rgb) ); }, m_sourceImage );
}

void ImageFilter::greenFilter( int g )
{
    QImage img;
    if ( g == 0) m_sourceImage = QImage(m_originalImage);
    else img = m_sourceImage;
    filterRgbHelper([=](QRgb &rgb) { rgb = qRgba(qRed(rgb), g, qBlue(rgb), qAlpha(rgb) ); }, m_sourceImage );
}

void ImageFilter::blueFilter(int b)
{

    if ( !m_isActive ) return;

    if ( b == 0 ) {
        qDebug() << b;
        m_sourceImage = m_originalImage.copy();
    }


    for (int y = 0; y < m_sourceImage.height(); ++y) {
        QRgb *line = reinterpret_cast<QRgb*>(m_sourceImage.scanLine(y));

        for (int x = 0; x < m_sourceImage.width(); ++x) {
            QRgb &rgb = line[x];
            rgb = qRgba(qRed(rgb), qGreen(rgb), b, qAlpha(rgb) );
        }
    }

    // filterRgbHelper([&] (QRgb &rgb) {rgb = qRgba(qRed(rgb), qGreen(rgb), b, qAlpha(rgb)); }, m_sourceImage  );
}



void ImageFilter::filterRgbHelper(std::function<void (QRgb &)> cb, QImage &image)
{
    if ( !m_isActive ) return;

    QImage& img = image;
    for (int y = 0; y < img.height(); ++y) {
        QRgb *line = reinterpret_cast<QRgb*>(img.scanLine(y));

        for (int x = 0; x < img.width(); ++x) {
            QRgb &rgb = line[x];
            cb(rgb);
        }
    }
}

QImage ImageFilter::sourceImage() const
{
    return m_sourceImage;
}

void ImageFilter::setSourceImage(const QImage &newSourceImage)
{
    m_sourceImage = newSourceImage;
    emit sourceImageChanged();
}

bool ImageFilter::isActive() const
{
    return m_isActive;
}

void ImageFilter::setIsActive(bool newIsActive)
{
    m_isActive = newIsActive;
    emit isActiveChanged();
}


QImage ImageFilter::originalImage() const
{
    return m_originalImage;
}

void ImageFilter::setOriginalImage(const QImage &newOriginalImage)
{
    m_originalImage = newOriginalImage;
    emit originalImageChanged();
}









// void CanvasEngine::applyBlurFilter(qreal val)
// {
//     if (m_oldImage.isNull()) return;


//     QImage newImage = m_oldImage;
//     int width = m_oldImage.width();
//     int height = m_oldImage.height();

//     double blurFactor = val / 255.0;
//     double kernel[3][3] = {
//         { blurFactor, blurFactor, blurFactor },
//         { blurFactor, 1.0,        blurFactor },
//         { blurFactor, blurFactor, blurFactor }
//     };

//     double sum = 1.0 + 8.0 * blurFactor;

//     for (int y = 1; y < height - 1; ++y) {
//         QRgb *prevLine = reinterpret_cast<QRgb*>(m_oldImage.scanLine(y - 1));
//         QRgb *currLine = reinterpret_cast<QRgb*>(m_oldImage.scanLine(y));
//         QRgb *nextLine = reinterpret_cast<QRgb*>(m_oldImage.scanLine(y + 1));
//         QRgb *newLine  = reinterpret_cast<QRgb*>(newImage.scanLine(y));

//         for (int x = 1; x < width - 1; ++x) {
//             double redSum = 0, greenSum = 0, blueSum = 0;

//             QRgb neighbors[3][3] = {
//                 { prevLine[x - 1], prevLine[x], prevLine[x + 1] },
//                 { currLine[x - 1], currLine[x], currLine[x + 1] },
//                 { nextLine[x - 1], nextLine[x], nextLine[x + 1] }
//             };

//             for (int ky = 0; ky < 3; ++ky) {
//                 for (int kx = 0; kx < 3; ++kx) {
//                     QRgb pixel = neighbors[ky][kx];
//                     redSum   += qRed(pixel)   * kernel[ky][kx];
//                     greenSum += qGreen(pixel) * kernel[ky][kx];
//                     blueSum  += qBlue(pixel)  * kernel[ky][kx];
//                 }
//             }

//             redSum   /= sum;
//             greenSum /= sum;
//             blueSum  /= sum;


//             newLine[x] = qRgb(std::clamp<int>(redSum, 0, 255),
//                               std::clamp<int>(greenSum, 0, 255),
//                               std::clamp<int>(blueSum, 0, 255));
//         }
//     }

//     //m_image = newImage;
//     update();
// }



