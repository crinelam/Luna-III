/**

    Copyright 2024 Cristina Ibañez <crinelam@tutamail.com>
      Updated the Luna QML plasmod from Plasma 5 to Plasma 6.
    Copyright 2016,2017 Bill Binder <dxtwjb@gmail.com>
    Copyright (C) 2011, 2012, 2013 Glad Deschrijver <glad.deschrijver@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.

*/

import QtQuick
import QtQuick.Layouts as QtLayouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import QtQuick.Controls as QtControls
import org.kde.plasma.components as PlasmaComponents

import "../code/phases.js" as Phases
import "../code/lunacalc.js" as LunaCalc

PlasmoidItem {
    id: main
    property int minimumWidth
    property int minimumHeight
    property int maximumWidth
    property int maximumHeight
    property int preferredWidth
    property int preferredHeight
    property var currentPhase: LunaCalc.getCurrentPhase(true);

    property bool showBackground: Plasmoid.configuration.showBackground
    property bool transparentShadow: Plasmoid.configuration.transparentShadow
    property int latitude: Plasmoid.configuration.latitude
    property int dateFormat: Plasmoid.configuration.dateFormat
    property string dateFormatString: Plasmoid.configuration.dateFormatString
    property double shadowOpacity: Plasmoid.configuration.shadowOpacity

    property int lunarIndex: Plasmoid.configuration.lunarIndex
    property string diskColour: Plasmoid.configuration.diskColour
    property string lunarImage: ''
    property int lunarImageTweak: 0

    //backgroundHints: showBackground ? "DefaultBackground" : "NoBackground"
    preferredRepresentation: compactRepresentation

    //icon: ""
    toolTipMainText: currentPhase.text
    toolTipSubText: currentPhase.subText

    compactRepresentation: Item {
        id: compact

        property int latitude: main.latitude
        property bool showBackground: main.showBackground
        property int lunarIndex: main.lunarIndex

        Component.onCompleted: updateDetails()

        onLatitudeChanged: updateDetails()

        onLunarIndexChanged: updateDetails()

        function updateDetails() {
            // set the correct image for the moon
            currentPhase = LunaCalc.getCurrentPhase(true);
            lunaIcon.phaseNumber = 13; //currentPhase.number;
            lunaIcon.theta = currentPhase.terminator;
            lunaIcon.latitude = latitude;

            main.lunarImage = imageChoices.get(main.lunarIndex).filename
            main.lunarImageTweak = imageChoices.get(main.lunarIndex).tweak
        }

        ImageChoices {
          id: imageChoices
        }

        Timer {
            id: hourlyTimer
            interval: 60 * 60 * 1000 // 60 minutes
            repeat: true
            running: true
            onTriggered: updateDetails()
        }

        LunaIcon {
            id: lunaIcon
            latitude: main.latitude
            lunarImage: main.lunarImage
            lunarImageTweak: main.lunarImageTweak
            transparentShadow: main.transparentShadow
            shadowOpacity: main.shadowOpacity
            diskColour: main.diskColour

            anchors.fill: parent

            MouseArea {
                anchors.fill: parent
                onClicked: plasmoid.expanded = !plasmoid.expanded
            }
        }

    }

    fullRepresentation: Item {
        id: full

        QtLayouts.Layout.preferredWidth: lunaWidget.QtLayouts.Layout.minimumWidth
        QtLayouts.Layout.preferredHeight: lunaWidget.QtLayouts.Layout.minimumHeight

        property int dateFormat: main.dateFormat
        property string dateFormatString: main.dateFormatString

        onDateFormatChanged: {
            lunaWidget.dateFormat = dateFormat;
        }

        onDateFormatStringChanged: {
            lunaWidget.dateFormatString = dateFormatString;
        }

        LunaWidget {
            id: lunaWidget
            dateFormat: dateFormat
            dateFormatString: dateFormatString
        }
    }
}
