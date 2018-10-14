import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

import "../lib"

ConfigPage {
    id: page
    showAppletVersion: true

    ConfigSection {

        ConfigCheckBox {
            configKey: 'deleteOnComplete'
            text: i18n("Delete On Complete")
        }

        ConfigCheckBox {
            visible: plasmoid.location == PlasmaCore.Types.Floating
            configKey: 'hidden'
            text: i18n("Desktop Widget: Hide")
        }

    }
}
