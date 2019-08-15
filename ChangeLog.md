## v12 - August 15 2019
* Add a possibility to change counter appearance: whether it is a big counter, a round counter, whether it appears if no items are left.

## v11 - March 31 2019

* Strikeout completed items (optional) when not deleting on complete (Issue #9). Also optionally fade completed items.
* Hide "Desktop Widget: Show Background" toggle when widget is in the panel.
* Updated Dutch translations by @Vistaus (Pull Request #15)

## v10 - February 8 2019

* Add Dutch translations by @Vistaus (Pull Request #8 and #12)
* Add toggle show showing the text field background for the list title (Issue #11)

## v9 - December 3 2018

* Add toggle for the desktop widget background to add it back.
* The list title is now bold with an outline using the background color. There is a toggle for the outline and boldness in the config.
* Add ability to temporily hide the list in case the user does not it visible but doesn't want to go through the hassle of removing and adding it back.
* Remove the list title right margin when used as a desktop widget which is only needed for leaving room for the pin button in a panel widget's popup.

## v8 - August 30 2018

* Make sure there's enough room for each section. Fixes a infinite loop when trying to resize the desktop widget with 2+ lists.
* Add Ctrl+Return and Alt+Return shortcut to toggle item as complete (by @mcorteel).
* Fix sectionData is undefined warning when loading, which broke the issue count in the panel (Issue #4).
* Don't align list items to bottom of popup when in a top panel (Issue #6).
* Fix textbox overlapping checkbox when using 1x DPI and 20px font size (instead of 10px).

## v7 - August 3 2017

* Support multiple lists side by side. Each list is seperated by a heading in the file.
* Can drag and drop the lists to reorder them. Can drag items between lists.
* Can add a new list via the context menu. The delete button will prompt before deleting.
* Lines have the excess whitespace at the end of the line stripped.

## v6 - June 28 2017

* Fix height calculation (we ignored the height taken by the pin button).
* Use Plasma's panel icon size (which can be set in System Settings > Icons > Advanced).

## v5 - May 7 2017

* Remove ability to hide completed items.
* Added ability to remove items when completed instead, which will hide the "delete item" button (this is the new default).
* Added ability to reorder items.
* Focus on "new item" when popup is opened.
* Add scrollbar.
* Disable copy/cut/paste context menu so it's easier to open the widget context menu.

## v4 - December 14 2016

* Fix bug overwriting the wrong index when hiding completed items.

## v3 - December 14 2016

* Show the number of incomplete icons in the panel icon using the same badge as the taskmanager (file transfer / downloads).
* Fix adjusting the height according to the number of items displayed (shouldn't show a scrollbar until it's taller than the screen).

## v2 - August 31 2016

* Support KDE 5.5 / Qt 5.5
* Support tabs when editing the file itself. Also automatically indent when the file is saved.
* Remove a ton of excess logging.
