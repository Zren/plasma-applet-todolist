import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore

FocusScope {
	id: fullRepresentation
	Layout.minimumWidth: PlasmaCore.Units.gridUnit * 10 * noteItem.numSections
	Layout.minimumHeight: PlasmaCore.Units.gridUnit * 10
	Layout.preferredWidth: PlasmaCore.Units.gridUnit * 20 * noteItem.numSections
	Layout.preferredHeight: Math.min(Math.max(PlasmaCore.Units.gridUnit * 20, maxContentHeight), Screen.desktopAvailableHeight) // Binding loop warning (meh).
	property int maxContentHeight: 0
	function updateMaxContentHeight() {
		var maxHeight = 0
		for (var i = 0; i < notesRepeater.count; i++) {
			var item = notesRepeater.itemAt(i)
			if (item) {
				if (!item.ready) {
					return // Not ready yet
				}
				maxHeight = Math.max(maxHeight, item.contentHeight)
			}
		}
		// console.log('maxContentHeight', maxHeight)
		maxContentHeight = maxHeight
	}
	// property int contentHeight: pinButton.height + container.spacing + listView.contentHeight
	// Layout.maximumWidth: plasmoid.screenGeometry.width
	// Layout.maximumHeight: plasmoid.screenGeometry.height

	property bool isDesktopContainment: false

	RowLayout {
		id: notesRow
		anchors.fill: parent

		opacity: plasmoid.configuration.hidden ? 0 : 1
		visible: opacity > 0

		Behavior on opacity {
			NumberAnimation { duration: 400 }
		}

		Repeater {
			id: notesRepeater
			model: noteItem.numSections

			NoteSection {
				id: container

				onContentHeightChanged: {
					// console.log('onContentHeightChanged', index, contentHeight)
					fullRepresentation.updateMaxContentHeight()
				}
			}
		}

	}

	PlasmaComponents.ToolButton {
		id: pinButton
		anchors.top: parent.top
		anchors.right: parent.right
		width: Math.round(PlasmaCore.Units.gridUnit * 1.25)
		height: width
		checkable: true
		icon.name: "window-pin"
		onCheckedChanged: plasmoid.hideOnWindowDeactivate = !checked
		visible: !isDesktopContainment
	}
}
