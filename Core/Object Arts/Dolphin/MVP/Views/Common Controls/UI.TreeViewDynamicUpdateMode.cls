"Filed out from Dolphin Smalltalk"!

UI.TreeViewVirtualUpdateMode
	subclass: #'UI.TreeViewDynamicUpdateMode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.TreeViewDynamicUpdateMode guid: (Core.GUID fromString: '{47f0b62b-55b6-4ab5-8acf-56df3397845e}')!
UI.TreeViewDynamicUpdateMode comment: '`TreeViewDynamicUpdateMode` is a fully-dynamic `TreeViewUpdateMode` policy that asks the `TreeView` to request text, icon, etc, for items every time it needs them. In this mode the control will does not store any of the data, and so it may change every time the tree is redrawn. This is the default mode for `TreeView` and is generally appropriate except where calculating the text, icons, etc, for an item is expensive, or there is a desire to show a snapshot of an item state that may be unstable.'!
!UI.TreeViewDynamicUpdateMode categoriesForClass!MVP-Views-Support! !
!UI.TreeViewDynamicUpdateMode methodsFor!

name
	^#dynamic!

updateAll
	view invalidate!

viewStoresItemData
	"Answer whether the TreeView stores text and icon data in this mode."

	^false! !
!UI.TreeViewDynamicUpdateMode categoriesForMethods!
name!accessing!public! !
updateAll!public!updating! !
viewStoresItemData!public!testing! !
!

