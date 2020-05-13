import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2 // MessageDialog
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import QtQuick.Controls.Styles.Plasma 2.0 as PlasmaStyles

import org.kde.draganddrop 2.0 as DragAndDrop

ColumnLayout {
	id: container
	Layout.fillWidth: true
	Layout.fillHeight: true
	spacing: 0

	property int contentHeight: textField.height + container.spacing + noteListView.contentHeight
	
	property var noteSection: noteItem.sectionList[index]

	MouseArea {
		id: labelMouseArea
		Layout.fillWidth: true
		Layout.preferredHeight: labelRow.height
		hoverEnabled: true
		cursorShape: Qt.OpenHandCursor

		DropArea {
			id: noteSectionDropArea
			anchors.fill: parent
			z: -1
			// anchors.margins: 10

			onDropped: {
				// console.log('noteSectionDropArea.onDropped', drag.source.dragSectionIndex, index)
				if (typeof drag.source.dragSectionIndex === "number") {
					// swap drag.source.dragNoteIndex and labelRow.dragNoteIndex
					noteItem.moveSection(drag.source.dragSectionIndex, labelRow.dragSectionIndex)
				}
			}

			Rectangle {
				anchors.fill: parent
				color: parent.containsDrag ? "#88336699" : "transparent"
			}
		}

		RowLayout {
			id: labelRow
			anchors.left: parent.left
			anchors.right: parent.right
			spacing: 0
			
			property int dragSectionIndex: index

			DragAndDrop.DragArea {
				id: dragArea
				Layout.fillHeight: true
				Layout.preferredWidth: 30 * units.devicePixelRatio // Same width as drag area in todoItem

				delegate: labelRow

				PlasmaCore.FrameSvgItem {
					visible: labelMouseArea.containsMouse && !noteSectionDropArea.containsDrag
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					width: parent.width / 2
					imagePath: plasmoid.file("", "images/dragarea.svg")
				}
			}

			PlasmaComponents3.TextField {
				id: textField
				Layout.fillWidth: true
				text: noteSection.label

				// TODO: Use a Loader to re-implement usingPlasmaStyle
				// readonly property bool usingPlasmaStyle: plasmoid.configuration.listTitlePlasmaStyle
				readonly property bool usingPlasmaStyle: false
				// These properties are set for !usingPlasmaStyle.
				background: Item {}
				font.pointSize: -1
				font.pixelSize: pinButton.height
				font.weight: plasmoid.configuration.listTitleBold ? Font.Bold : Font.Normal
				implicitHeight: contentHeight
				padding: 0
				leftPadding: 0
				rightPadding: 0
				topPadding: 0
				bottomPadding: 0
				topInset: 0


				onEditingFinished: {
					noteSection.label = text
					text = Qt.binding(function() { return noteSection.label })
				}

				PlasmaComponents3.Label {
					id: textOutline
					anchors.fill: parent
					visible: !textField.usingPlasmaStyle && plasmoid.configuration.listTitleOutline
					text: parent.text
					font.pointSize: -1
					font.pixelSize: pinButton.height
					font.weight: plasmoid.configuration.listTitleBold ? Font.Bold : Font.Normal
					color: "transparent"
					style: Text.Outline
					styleColor: theme.backgroundColor
					verticalAlignment: Text.AlignVCenter
				}

			}
		}

		PlasmaComponents3.ToolButton {
			anchors.right: labelRow.right
			readonly property bool isRightMostSection: index == notesRepeater.count-1
			anchors.rightMargin: isRightMostSection && pinButton.visible ? pinButton.width : 0
			anchors.verticalCenter: labelRow.verticalCenter
			visible: notesRepeater.count > 1 && labelMouseArea.containsMouse && !noteSectionDropArea.containsDrag
			icon.name: "trash-empty"
			onClicked: promptDeleteLoader.show()

			Loader {
				id: promptDeleteLoader
				active: false

				function show() {
					if (item) {
						item.visible = true
					} else {
						active = true
					}
				}

				sourceComponent: Component {
					MessageDialog {
						// visible: true
						title: i18n("Delete List")
						icon: StandardIcon.Warning
						text: i18n("Are you sure you want to delete the list \"%1\" with %2 items?", noteSection.label || ' ', Math.max(0, noteSection.model.count - 1))
						standardButtons: StandardButton.Yes | StandardButton.Cancel

						onYes: noteItem.removeSection(index)
						Component.onCompleted: visible = true
					}
				}
			}

		}
	}

	PlasmaExtras.ScrollArea {
		Layout.fillWidth: true
		Layout.fillHeight: true

		NoteListView {
			id: noteListView
			model: noteSection.model
		}
	}
}
