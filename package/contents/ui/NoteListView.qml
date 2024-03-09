import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.plasma.plasmoid
// import org.kde.plasma.core as PlasmaCore

ListView {
	id: listView
	Layout.fillWidth: true
	Layout.fillHeight: true

	cacheBuffer: 10000000
	// interactive: false
	spacing: 4

	// BottomToTop feels weird, so disable this for now.
	// verticalLayoutDirection: plasmoid.location == PlasmaCore.Types.BottomEdge ? ListView.BottomToTop : ListView.TopToBottom

	delegate: TodoItemDelegate {
		width: ListView.view.width
	}
	
	remove: Transition {
		NumberAnimation { property: "opacity"; to: 0; duration: 400 }
	}
	add: Transition {
		NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
	}
	displaced: Transition {
		NumberAnimation { properties: "x,y"; duration: 200; }
	}

	Timer {
		id: deboucedPositionViewAtEnd
		interval: 1000
		onTriggered: listView.positionViewAtEnd()
	}

	onCountChanged: {
		// console.log('onCountChanged', count)
		deboucedPositionViewAtEnd.restart()
	}

	onCurrentItemChanged: {
		// console.log('listView.onCurrentItemChanged', currentIndex)
	}

	Connections {
		target: Plasmoid
		ignoreUnknownSignals: true
		function onExpandedChanged() {
			if (expanded) {
				listView.focus = true
				listView.currentIndex = listView.count - 1
				listView.positionViewAtEnd()
			}
		}
	}
}
