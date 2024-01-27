"Filed out from Dolphin Smalltalk"!

UI.TreeViewUpdateMode
	subclass: #'UI.TreeViewVirtualUpdateMode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.TreeViewVirtualUpdateMode guid: (Core.GUID fromString: '{e082c0fc-396e-4aee-934b-82d51d2b8917}')!
UI.TreeViewVirtualUpdateMode isNonInstantiable: true!
UI.TreeViewVirtualUpdateMode comment: '`TreeViewVirtualUpdateMode` is the abstract class of policy objects that implement the virtual `TreeView` update modes. In these modes the items are added to the tree without any data, and the view then sends callback notifications to request the text, icons, etc, when required. Whether or not it is asked to store this data once requested depends on the concrete update mode subclass.'!
!UI.TreeViewVirtualUpdateMode categoriesForClass!MVP-Views-Support! !
!UI.TreeViewVirtualUpdateMode methodsFor!

addItems: aCollection inHandle: parentHandle afterHandle: siblingHandle
	| tvis |
	tvis := TVINSERTSTRUCTW hParent: parentHandle hInsertAfter: siblingHandle.
	"Add items with subclassing removed so don't receive TVM_INSERTITEMs"
	view withOldWndProc: [aCollection do: [:each | view tvmInsertItem: each tvis: tvis]]!

isVirtual
	^true!

refreshItem: anObject handle: hItem
	"Update the text, image, and children flag of the specified element of the tree."

	"Instruct the tree to send notification callbacks to fetch the item text, icon, etc"
	view tvmSetItem: (TVITEMEXW callbacksForItem: hItem)! !
!UI.TreeViewVirtualUpdateMode categoriesForMethods!
addItems:inHandle:afterHandle:!adding!public! !
isVirtual!public!testing! !
refreshItem:handle:!public!updating! !
!

