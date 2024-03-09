import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs // MessageDialog
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents
import org.kde.draganddrop as DragAndDrop
import org.kde.ksvg as KSvg
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

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
				Layout.preferredWidth: 30 // Same width as drag area in todoItem

				delegate: labelRow

				KSvg.FrameSvgItem {
					visible: labelMouseArea.containsMouse && !noteSectionDropArea.containsDrag
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					width: parent.width / 2
					imagePath: PlasmoidItem.file("", "images/dragarea.svg")
				}
			}

			PlasmaComponents.TextField {
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
				font.weight: Plasmoid.configuration.listTitleBold ? Font.Bold : Font.Normal
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

				PlasmaComponents.Label {
					id: textOutline
					anchors.fill: parent
					visible: !textField.usingPlasmaStyle && Plasmoid.configuration.listTitleOutline
					text: parent.text
					font.pointSize: -1
					font.pixelSize: pinButton.height
					font.weight: Plasmoid.configuration.listTitleBold ? Font.Bold : Font.Normal
					color: "transparent"
					style: Text.Outline
					styleColor: Kirigami.Theme.backgroundColor
					verticalAlignment: Text.AlignVCenter
				}

			}
		}

		PlasmaComponents.ToolButton {
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
						text: i18n("Are you sure you want to delete the list \"%1\" with %2 items?", noteSection.label || ' ', Math.max(0, noteSection.model.count - 1))

						onAccepted: noteItem.removeSection(index)
						Component.onCompleted: visible = true
					}
				}
			}

		}
	}

	ScrollView {
		Layout.fillWidth: true
		Layout.fillHeight: true

		NoteListView {
			id: noteListView
			model: noteSection.model
		}
	}
}
