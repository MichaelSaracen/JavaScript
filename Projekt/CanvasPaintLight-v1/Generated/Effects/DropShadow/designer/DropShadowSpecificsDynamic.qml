
// Created with Qt Design Studio (version 4.7.0), Sun Feb 2 15:06:06 2025
// Do not manually edit this file, it will be overwritten if effect is modified in Qt Design Studio.

import QtQuick
import QtQuick.Layouts
import HelperWidgets
import StudioTheme as StudioTheme

Column {

    Section {
        caption: "General"
        width: parent.width

        SectionLayout {
            PropertyLabel {
                text: "Extra Margin"
                tooltip: "This property specifies how much of extra space is reserved for the effect outside the parent geometry."
            }

            SecondColumnLayout {
                SpinBox {
                    minimumValue: 0
                    maximumValue: 1000
                    decimals: 0
                    stepSize: 1
                    sliderIndicatorVisible: true
                    backendValue: backendValues.extraMargin
                    implicitWidth: StudioTheme.Values.singleControlColumnWidth
                                   + StudioTheme.Values.actionIndicatorWidth
                }
                ExpandingSpacer {}
            }
        }
    }

    Section {
        caption: "Blur Helper"
        width: parent.width

        SectionLayout {

            PropertyLabel {
                text: "Multiplier"
                tooltip: "This property defines a multiplier for extending the blur radius.\n\nBy default, the property is set to 0.0 (not multiplied). Incresing the multiplier extends the blur radius, but decreases the blur quality. This is more performant option for a bigger blur radius than Max Blur Level as it doesn't increase the amount of texture lookups.\n\nNote: This affects to both blur and shadow effects."
            }

            SecondColumnLayout {

                SpinBox {
                    minimumValue: 0
                    maximumValue: 2
                    decimals: 2
                    stepSize: .01
                    sliderIndicatorVisible: true
                    backendValue: backendValues.blurMultiplier
                    implicitWidth: StudioTheme.Values.singleControlColumnWidth
                                   + StudioTheme.Values.actionIndicatorWidth
                }

                ExpandingSpacer {}
            }
        }
    }

    Section {
        caption: "Drop Shadow"
        width: parent.width

        SectionLayout {

            PropertyLabel {
                text: "Blur Amount"
                tooltip: "Sets the amount of blur (radius) applied to the shadow.\n\nThe value ranges from 0.0 (no blur) to 1.0 (full blur).\n\nThe amount of blur is also affected by the Blur Helper Multiplier property."
            }

            SecondColumnLayout {

                SpinBox {
                    minimumValue: 0
                    maximumValue: 1
                    decimals: 2
                    stepSize: .01
                    sliderIndicatorVisible: true
                    backendValue: backendValues.dropShadowBlurAmount
                    implicitWidth: StudioTheme.Values.singleControlColumnWidth
                                   + StudioTheme.Values.actionIndicatorWidth
                }

                ExpandingSpacer {}
            }

            PropertyLabel {
                text: "Color"
                tooltip: "Sets the color of the shadow."
            }

            SecondColumnLayout {

                ColorEditor {
                    backendValue: backendValues.dropShadowColor
                    supportGradient: false
                }

                ExpandingSpacer {}
            }

            PropertyLabel {
                text: "Scale"
                tooltip: "Sets the size of the shadow."
            }

            SecondColumnLayout {

                SpinBox {
                    minimumValue: 0.8
                    maximumValue: 1.2
                    decimals: 2
                    stepSize: .01
                    sliderIndicatorVisible: true
                    backendValue: backendValues.dropShadowScale
                    implicitWidth: StudioTheme.Values.singleControlColumnWidth
                                   + StudioTheme.Values.actionIndicatorWidth
                }

                ExpandingSpacer {}
            }

            PropertyLabel {
                text: "Horizontal Offset"
                tooltip: "Sets the horizontal position of the shadow."
            }

            SecondColumnLayout {

                SpinBox {
                    minimumValue: -30
                    maximumValue: 30
                    decimals: 2
                    stepSize: .01
                    sliderIndicatorVisible: true
                    backendValue: backendValues.dropShadowHorizontalOffset
                    implicitWidth: StudioTheme.Values.singleControlColumnWidth
                                   + StudioTheme.Values.actionIndicatorWidth
                }

                ExpandingSpacer {}
            }

            PropertyLabel {
                text: "Vertical Offset"
                tooltip: "Sets the vertical position of the shadow."
            }

            SecondColumnLayout {

                SpinBox {
                    minimumValue: -30
                    maximumValue: 30
                    decimals: 2
                    stepSize: .01
                    sliderIndicatorVisible: true
                    backendValue: backendValues.dropShadowVerticalOffset
                    implicitWidth: StudioTheme.Values.singleControlColumnWidth
                                   + StudioTheme.Values.actionIndicatorWidth
                }

                ExpandingSpacer {}
            }
        }
    }
}
