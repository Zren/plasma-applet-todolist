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
			text: i18n("Note Name")
			font.weight: Font.Bold
			font.pointSize: theme.defaultFont.pointSize * 1.25
		}

		ConfigCheckBox {
			configKey: 'useGlobalNote'
			text: i18n("Use Global Note")
		}

		ConfigCheckBox {
			configKey: 'useOwnNameNote'
			text: i18n("Use Own Name for the Note")
		}

		ConfigTextField {
			configKey: 'noteName'
			placeholderText: i18n("Note Name")
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
