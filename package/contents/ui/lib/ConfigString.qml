// Version 2

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.plasma.plasmoid

TextField {
	id: configString
	Layout.fillWidth: true

	property string configKey: ''
	property alias value: configString.text
	readonly property string configValue: configKey ? Plasmoid.configuration[configKey] : ""
	onConfigValueChanged: {
		if (!configString.focus && value != configValue) {
			value = configValue
		}
	}
	property string defaultValue: ""

	text: configString.configValue
	onTextChanged: serializeTimer.restart()

	ToolButton {
		iconName: "edit-clear"
		onClicked: configString.value = defaultValue

		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom

		width: height
	}

	Timer { // throttle
		id: serializeTimer
		interval: 300
		onTriggered: {
			if (configKey) {
				Plasmoid.configuration[configKey] = value
			}
		}
	}
}
