import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import ".."

TextField {
	id: configTextField

	property string configKey: ''
	text: plasmoid.configuration[configKey]
	onAccepted: plasmoid.configuration[configKey] = text
}
