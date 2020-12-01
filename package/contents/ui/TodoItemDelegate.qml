import QtQuick 2.0
import QtQuick.Controls 2.3 as QQC2
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.draganddrop 2.0 as DragAndDrop

MouseArea {
	id: todoItemDelegate
	implicitHeight: todoItemRow.implicitHeight
	hoverEnabled: true

	property var todoModel: listView.model
	readonly property bool isCompleted: model.status == 'completed'

	function setComplete(completed) {
		var newStatus = completed ? 'completed' : 'needsAction'
		if (model.status != newStatus) {
			// model.status = newStatus // Not supported in KDE 5.5
			todoModel.setProperty(index, 'status', newStatus)
			// console.log(completed, model.status)
			todoModel.update()
		}
		if (plasmoid.configuration.deleteOnComplete) {
			deleteItem()
		}
	}
	function setTitle(title) {
		if (model.title != title) {
			// console.log('setTitle')
			// model.title = title // Not supported in KDE 5.5
			todoModel.setProperty(index, 'title', title)
			todoModel.update()
		}
	}
	function setIndent(indent) {
		if (model.indent != indent) {
			// model.indent = Math.max(0, indent) // Not supported in KDE 5.5
			todoModel.setProperty(index, 'indent', Math.max(0, indent))
			// indentItem.width = checkbox.height * indent
			// console.log(indent, model.indent, indentItem.width)
			// console.log(model.title)
			todoModel.update()
		}
	}
	function deleteItem() {
		todoModel.removeItem(index)
	}

	DropArea {
		id: dropArea
		anchors.fill: parent
		z: -1
		// anchors.margins: 10

		onEntered: {
			if (drag.source.dragItemModel) {
				if (todoModel == drag.source.dragItemModel) {
					todoModel.move(drag.source.dragItemIndex, index, 1)
				} else {
					// We can't preview it since we can't move it to the
					// new model yet without the ListView destroying the
					// drag area source.
					// So just move on drop.
				}
			}
		}

		onDropped: {
			if (drag.source.dragItemModel) {
				if (todoModel != drag.source.dragItemModel) {
					var todoObj = drag.source.dragItemModel.get(drag.source.dragItemIndex)
					todoModel.insertItem(index, todoObj)
					drag.source.dragItemModel.removeItem(drag.source.dragItemIndex)
				}
			}
		}

		Rectangle {
			anchors.fill: parent
			color: parent.containsDrag ? "#88336699" : "transparent"
		}
	}

	RowLayout {
		id: todoItemRow
		anchors.left: parent.left
		anchors.right: parent.right
		spacing: 0

		Item {
			id: indentItem
			Layout.preferredWidth: checkbox.height * model.indent
			visible: model.indent > 0
		}

		MouseArea {
			hoverEnabled: true
			cursorShape: Qt.OpenHandCursor
			Layout.fillHeight: true
			implicitWidth: checkbox.implicitHeight
			property var dragItemDelegate: todoItemDelegate
			property var dragItemModel: todoModel
			property int dragItemIndex: index
			DragAndDrop.DragArea {
				id: dragArea
				anchors.fill: parent
				delegate: todoItemRow
			}

			PlasmaCore.FrameSvgItem {
				visible: todoItemDelegate.containsMouse && !dropArea.containsDrag
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				width: parent.width / 2
				imagePath: plasmoid.file("", "images/dragarea.svg")
			}
		}

		PlasmaComponents3.CheckBox {
			id: checkbox
			Layout.alignment: Qt.AlignTop
			property int size: 30 * units.devicePixelRatio
			Layout.minimumWidth: size
			Layout.minimumHeight: size
			checked: todoItemDelegate.isCompleted

			onClicked: setComplete(checked)
		}

		PlasmaComponents3.TextArea {
			id: textArea
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignTop

			textMargin: 0

			focus: todoItemDelegate.ListView.isCurrentItem
			onActiveFocusChanged: {
				if (activeFocus) {
					listView.currentIndex = index
				}
			}

			Timer {
				id: delayedSelect
				property int cursorPosition: -1
				interval: 100

				onTriggered: {
					textArea.forceActiveFocus()
					textArea.cursorPosition = delayedSelect.cursorPosition
				}
			}

			onLinkActivated: {
				Qt.openUrlExternally(link)
			}

			property bool isEditing: activeFocus
			textFormat: TextEdit.RichText
			text: renderText(model.title)
			onTextChanged: {
				// console.log('onTextChanged')
				if (isEditing && textFormat == TextEdit.PlainText) {
					setTitle(text)
					// console.log(model.title)
				}
				// height = frameLinesHeight(lineCount)
				// parent.height = height
				// parent.parent.height = height
			}
			onIsEditingChanged: updateText()
			// Component.onCompleted: updateText()

			function updateText() {
				// console.log('updateText')
				if (isEditing) {
					var cursor = cursorPosition
					textFormat = TextEdit.PlainText
					text = model.title
					cursorPosition = cursor
				} else {
					text = renderText(model.title)
					textFormat = TextEdit.RichText
				}
			}

			function renderText(text) {
				// console.log('renderText')
				if (typeof text === 'undefined') {
					return ''
				}
				var out = text

				// Escape HTML
				out = out.replace(/[\u00A0-\u9999<>\&]/gim, function(i) {
					return '&#' + i.charCodeAt(0) + ';'
				})
				
				// Render links
				var rUrl = /(http|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/gi
				out = out.replace(rUrl, function(m) {
					return '<a href="' + m + '">' + m + '</a>' + ' ' // Extra space to prevent styling entire text as a link when ending with a link.
				})
				// Define before anchor tags.
				out = '<style>a { color: ' + theme.highlightColor + '; }</style>' + out

				// Render new lines
				out = out.replace(/\n/g, '<br>')

				return out
			}

			font.strikeout: !isEditing && todoItemDelegate.isCompleted && plasmoid.configuration.strikeoutCompleted

			readonly property bool shouldFade: !isEditing && todoItemDelegate.isCompleted && plasmoid.configuration.fadeCompleted
			opacity: shouldFade ? 0.6 : 1

			Keys.onPressed: {
				if (event.key == Qt.Key_Tab) {
					setIndent(model.indent + 1)
					event.accepted = true
				} else if (event.key == Qt.Key_Backtab) {
					setIndent(model.indent - 1)
					event.accepted = true
				} else if (event.key == Qt.Key_Return && event.modifiers == Qt.NoModifier) {
					// console.log('returnPressed')
					event.accepted = true
					// nextItemInFocusChain().nextItemInFocusChain().focus = true
					listView.currentIndex = index + 1
				} else if ((event.key == Qt.Key_Return && event.modifiers == Qt.ControlModifier)
						|| (event.key == Qt.Key_Return && event.modifiers == Qt.AltModifier)) {
					event.accepted = true
					setComplete(!todoItemDelegate.isCompleted)
				} else if (event.key == Qt.Key_Up && event.modifiers == Qt.ControlModifier) {
					event.accepted = true
					if (index > 0) {
						delayedSelect.cursorPosition = cursorPosition
						todoModel.move(index, index-1, 1)
						delayedSelect.restart()
					}
				} else if (event.key == Qt.Key_Down && event.modifiers == Qt.ControlModifier) {
					event.accepted = true
					if (index < todoModel.count-1) {
						delayedSelect.cursorPosition = cursorPosition
						todoModel.move(index, index+1, 1)
						delayedSelect.restart()
					}
				}
			}
		}

		PlasmaComponents3.ToolButton {
			id: removeButton
			Layout.alignment: Qt.AlignTop
			visible: !plasmoid.configuration.deleteOnComplete
			Layout.preferredWidth: checkbox.implicitHeight
			Layout.preferredHeight: checkbox.implicitHeight
			icon.name: 'trash-empty'
			opacity: textArea.activeFocus || hovered ? 1 : 0

			onClicked: {
				deleteItem()
			}
		}
	}

	// Component.onCompleted: console.log('TodoItemDelegate', Date.now())
}
