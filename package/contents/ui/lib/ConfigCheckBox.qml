import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import ".."

CheckBox {
	id: configCheckBox

	property string configKey: ''
	checked: Plasmoid.configuration[configKey]
	onClicked: Plasmoid.configuration[configKey] = !Plasmoid.configuration[configKey]
}
