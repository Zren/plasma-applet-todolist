import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
	id: main

	NoteItem {
		id: noteItem
	}

	compactRepresentation: MouseArea {
		readonly property bool inPanel: (Plasmoid.location == PlasmaCore.Types.TopEdge
			|| Plasmoid.location == PlasmaCore.Types.RightEdge
			|| Plasmoid.location == PlasmaCore.Types.BottomEdge
			|| Plasmoid.location == PlasmaCore.Types.LeftEdge)

		Layout.minimumWidth: {
			switch (Plasmoid.formFactor) {
			case PlasmaCore.Types.Vertical:
				return 0
			case PlasmaCore.Types.Horizontal:
				return height
			default:
				return units.gridUnit * 3
			}
		}

		Layout.minimumHeight: {
			switch (Plasmoid.formFactor) {
			case PlasmaCore.Types.Vertical:
				return width
			case PlasmaCore.Types.Horizontal:
				return 0
			default:
				return units.gridUnit * 3
			}
		}

		Layout.maximumWidth: inPanel ? Kirigami.Units.iconSizeHints.panel : -1
		Layout.maximumHeight: inPanel ? Kirigami.Units.iconSizeHints.panel : -1

		Kirigami.Icon {
			id: icon
			anchors.fill: parent
			source: Plasmoid.icon
		}

		IconCounterOverlay {
			anchors.fill: parent
			text: noteItem.hasIncomplete ? noteItem.incompleteCount : "✓"
			visible: {
				if (Plasmoid.configuration.showCounter == 'Never') {
					return false
				} else if (Plasmoid.configuration.showCounter == 'Incomplete') {
					return noteItem.hasIncomplete
				} else { // 'Always'
					return true
				}
			}
			heightRatio: Plasmoid.configuration.bigCounter ? 1 : 0.5
		}

		onClicked: Plasmoid.expanded = !Plasmoid.expanded
	}

	fullRepresentation: FullRepresentation {
		Plasmoid.backgroundHints: isDesktopContainment && !Plasmoid.configuration.showBackground ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground
		isDesktopContainment: Plasmoid.location == PlasmaCore.Types.Floating

		// Connections {
		// 	target: plasmoid
		// 	onExpandedChanged: {
		// 		if (!expanded) {
		// 			updateVisibleItems()
		// 		}
		// 	}
		// }
	}


	Plasma5Support.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: disconnectSource(sourceName)
	}
	function exec(cmd) {
		executable.connectSource(cmd)
	}

	function action_openInTextEditor() {
		exec("xdg-open ~/.local/share/plasma_notes/" + Plasmoid.configuration.noteId)
	}

	function action_addSection() {
		noteItem.addSection()
	}

	function action_toggleDeleteOnComplete() {
		plasmoid.configuration.deleteOnComplete = !Plasmoid.configuration.deleteOnComplete
	}

	function action_toggleHidden() {
		plasmoid.configuration.hidden = !Plasmoid.configuration.hidden
	}


	function updateContextMenuCheckmark(actionName, value) {
		// Use "NOICON" since `"" == false`
		// Because it's false, that means that when we try to unset the icon,
		// it ignores assigning the icon since it thinks we haven't set the function argument.
		// "NOICON" is not a FreeDesktop naming standard, but it probably has no image.
		plasmoid.setAction(actionName, Plasmoid.action(actionName).text, value ? "checkmark" : "NOICON")
	}

	function updateContextMenu() {
		updateContextMenuCheckmark("toggleDeleteOnComplete", Plasmoid.configuration.deleteOnComplete)
		updateContextMenuCheckmark("toggleHidden", Plasmoid.configuration.hidden)
		if (Plasmoid.location != PlasmaCore.Types.Floating) {
			// not desktop component
			Plasmoid.action("toggleHidden").visible = false
		}
	}

	Connections {
		target: Plasmoid.configuration
		onDeleteOnCompleteChanged: updateContextMenu()
		onHiddenChanged: updateContextMenu()
	}

	Component.onCompleted: {
		Plasmoid.setAction("openInTextEditor", i18n("Open in Text Editor"), "accessories-text-editor")
		Plasmoid.setAction("addSection", i18n("Add List"), "list-add")
		Plasmoid.setAction("toggleDeleteOnComplete", i18n("Delete on Complete"), "checkmark")
		Plasmoid.setAction("toggleHidden", i18n("Hide"), "checkmark")
		// plasmoid.setAction("deleteCompleted", i18n("Delete All Completed"), "trash-empty")
		updateContextMenu()
	}
}
