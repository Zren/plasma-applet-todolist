import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

import "../lib"

ConfigPage {
	id: page
	showAppletVersion: true

	ConfigSection {
		visible: plasmoid.location != PlasmaCore.Types.Floating

		ConfigIcon {
			configKey: 'icon'
		}
	}

	ConfigSection {
		visible: plasmoid.location == PlasmaCore.Types.Floating

		ConfigCheckBox {
			configKey: 'hidden'
			text: i18n("Desktop Widget: Hide")
		}

		ConfigCheckBox {
			configKey: "showBackground"
			text: i18n("Desktop Widget: Show background")
		}
	}

	ConfigSection {
		Label {
			text: i18n("Note Filename")
			font.weight: Font.Bold
			font.pointSize: theme.defaultFont.pointSize * 1.25
		}

		ConfigCheckBox {
			id: useGlobalNote
			configKey: 'useGlobalNote'
			text: i18n("Use Global Note")
		}

		RowLayout {
			Label {
				text: i18n("Filename:")
			}
			ConfigString {
				configKey: 'noteFilename'
				enabled: !useGlobalNote.checked

				// Keep in sync with NoteItem.qml
				placeholderText: {
					if (plasmoid.configuration.useGlobalNote) {
						return 'todolist'
					} else { // instanceNoteId
						return 'todolist_' + plasmoid.id
					}
				}
			}
		}
	}

	ConfigSection {
		Label {
			text: i18n("Completed Items")
			font.weight: Font.Bold
			font.pointSize: theme.defaultFont.pointSize * 1.25
		}

		ConfigCheckBox {
			configKey: 'deleteOnComplete'
			text: i18n("Delete On Complete")
		}

		ConfigCheckBox {
			configKey: 'strikeoutCompleted'
			text: i18n("Strikeout")
		}

		ConfigCheckBox {
			configKey: 'fadeCompleted'
			text: i18n("Faded")
		}
	}

	ConfigSection {
		Label {
			text: i18n("List Title Style")
			font.weight: Font.Bold
			font.pointSize: theme.defaultFont.pointSize * 1.25
		}

		// ConfigCheckBox {
		// 	id: listTitlePlasmaStyle
		// 	configKey: "listTitlePlasmaStyle"
		// 	text: i18n("Show text field background")
		// }

		ConfigCheckBox {
			configKey: "listTitleBold"
			text: i18n("Bold")
		}

		ConfigCheckBox {
			// enabled: !listTitlePlasmaStyle.checked
			configKey: "listTitleOutline"
			text: i18n("Show outline")
		}
	}

	ConfigSection {
		visible: plasmoid.location != PlasmaCore.Types.Floating

		Label {
			text: i18n("Counter style")
			font.weight: Font.Bold
			font.pointSize: theme.defaultFont.pointSize * 1.25
		}


		ConfigComboBox {
			configKey: 'showCounter'
			before: i18n("Show counter:")
			model: [
				{ value: "Never", text: i18n("Never") },
				{ value: "Incomplete", text: i18n("Incomplete items are left") },
				{ value: "Always", text: i18n("Always") },
			]
		}

		ConfigCheckBox {
			configKey: 'bigCounter'
			text: i18n("Use big counter")
		}

		ConfigCheckBox {
			configKey: 'roundCounter'
			text: i18n("Use round counter")
		}
	}
}
