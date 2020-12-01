import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
	id: main

	NoteItem {
		id: noteItem
	}

	Plasmoid.icon: plasmoid.configuration.icon

	Plasmoid.compactRepresentation: MouseArea {
		readonly property bool inPanel: (plasmoid.location == PlasmaCore.Types.TopEdge
			|| plasmoid.location == PlasmaCore.Types.RightEdge
			|| plasmoid.location == PlasmaCore.Types.BottomEdge
			|| plasmoid.location == PlasmaCore.Types.LeftEdge)

		Layout.minimumWidth: {
			switch (plasmoid.formFactor) {
			case PlasmaCore.Types.Vertical:
				return 0
			case PlasmaCore.Types.Horizontal:
				return height
			default:
				return units.gridUnit * 3
			}
		}

		Layout.minimumHeight: {
			switch (plasmoid.formFactor) {
			case PlasmaCore.Types.Vertical:
				return width
			case PlasmaCore.Types.Horizontal:
				return 0
			default:
				return units.gridUnit * 3
			}
		}

		Layout.maximumWidth: inPanel ? units.iconSizeHints.panel : -1
		Layout.maximumHeight: inPanel ? units.iconSizeHints.panel : -1

		PlasmaCore.IconItem {
			id: icon
			anchors.fill: parent
			source: plasmoid.icon
		}

		IconCounterOverlay {
			anchors.fill: parent
			text: noteItem.hasIncomplete ? noteItem.incompleteCount : "✓"
			visible: {
				if (plasmoid.configuration.showCounter == 'Never') {
					return false
				} else if (plasmoid.configuration.showCounter == 'Incomplete') {
					return noteItem.hasIncomplete
				} else { // 'Always'
					return true
				}
			}
			heightRatio: plasmoid.configuration.bigCounter ? 1 : 0.5
		}

		onClicked: plasmoid.expanded = !plasmoid.expanded
	}

	Plasmoid.fullRepresentation: FullRepresentation {
		Plasmoid.backgroundHints: isDesktopContainment && !plasmoid.configuration.showBackground ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground
		isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating

		// Connections {
		// 	target: plasmoid
		// 	onExpandedChanged: {
		// 		if (!expanded) {
		// 			updateVisibleItems()
		// 		}
		// 	}
		// }
	}


	PlasmaCore.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: disconnectSource(sourceName)
	}
	function exec(cmd) {
		executable.connectSource(cmd)
	}

	function action_openInTextEditor() {
		exec("xdg-open ~/.local/share/plasma_notes/" + plasmoid.configuration.noteId)
	}

	function action_addSection() {
		noteItem.addSection()
	}

	function action_toggleDeleteOnComplete() {
		plasmoid.configuration.deleteOnComplete = !plasmoid.configuration.deleteOnComplete
	}

	function action_toggleHidden() {
		plasmoid.configuration.hidden = !plasmoid.configuration.hidden
	}


	function updateContextMenuCheckmark(actionName, value) {
		// Use "NOICON" since `"" == false`
		// Because it's false, that means that when we try to unset the icon,
		// it ignores assigning the icon since it thinks we haven't set the function argument.
		// "NOICON" is not a FreeDesktop naming standard, but it probably has no image.
		plasmoid.setAction(actionName, plasmoid.action(actionName).text, value ? "checkmark" : "NOICON")
	}

	function updateContextMenu() {
		updateContextMenuCheckmark("toggleDeleteOnComplete", plasmoid.configuration.deleteOnComplete)
		updateContextMenuCheckmark("toggleHidden", plasmoid.configuration.hidden)
		if (plasmoid.location != PlasmaCore.Types.Floating) {
			// not desktop component
			plasmoid.action("toggleHidden").visible = false
		}
	}

	Connections {
		target: plasmoid.configuration
		onDeleteOnCompleteChanged: updateContextMenu()
		onHiddenChanged: updateContextMenu()
	}

	Component.onCompleted: {
		plasmoid.setAction("openInTextEditor", i18n("Open in Text Editor"), "accessories-text-editor")
		plasmoid.setAction("addSection", i18n("Add List"), "list-add")
		plasmoid.setAction("toggleDeleteOnComplete", i18n("Delete on Complete"), "checkmark")
		plasmoid.setAction("toggleHidden", i18n("Hide"), "checkmark")
		// plasmoid.setAction("deleteCompleted", i18n("Delete All Completed"), "trash-empty")
		updateContextMenu()
	}
}
