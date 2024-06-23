"Filed out from Dolphin Smalltalk"!

UI.TreeViewVirtualUpdateMode
	subclass: #'UI.TreeViewLazyUpdateMode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.TreeViewLazyUpdateMode guid: (Core.GUID fromString: '{07c391ba-5f67-4365-8af4-5231af59aebf}')!

UI.TreeViewLazyUpdateMode comment: '`TreeViewLazyUpdateMode` is a partially-dynamic `TreeViewUpdateMode` policy that asks the `TreeView` to request text, icon, etc, for items the first time it needs them. In this mode the control is not given any of the data initially, but will store it progressively as the tree is expanded and displayed. This mode is a compromise between the fully-dynamic `TreeViewDynamicUpdateMode` and fully-static `TreeViewStaticUpdateMode`. It cases where where calculating the text, icons, etc, for items is expensive, this mode may be the best choice as it avoids the upfront cost of populating the entire tree, yet only incurs the cost of calculating the data once until the tree is refreshed.'!

!UI.TreeViewLazyUpdateMode categoriesForClass!MVP-Views-Support! !

!UI.TreeViewLazyUpdateMode methodsFor!

name
	^#lazy!

updateAllItems
	view updateAllItems!

viewStoresItemData
	"Answer whether the view stores text and icon data in this update mode."

	"This mode is initially virtual, but we want to ask the tree to store the data it is given when it first requests it."

	^true! !

!UI.TreeViewLazyUpdateMode categoriesForMethods!
name!accessing!public! !
updateAllItems!public!updating! !
viewStoresItemData!public!testing! !
!

