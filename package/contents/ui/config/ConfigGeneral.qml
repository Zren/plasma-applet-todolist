import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

import "../lib"

ConfigPage {
	id: page
	showAppletVersion: true

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

		ConfigCheckBox {
			id: listTitlePlasmaStyle
			configKey: "listTitlePlasmaStyle"
			text: i18n("Show text field background")
		}

		ConfigCheckBox {
			configKey: "listTitleBold"
			text: i18n("Bold")
		}

		ConfigCheckBox {
			enabled: !listTitlePlasmaStyle.checked
			configKey: "listTitleOutline"
			text: i18n("Show outline")
		}

	}
}
