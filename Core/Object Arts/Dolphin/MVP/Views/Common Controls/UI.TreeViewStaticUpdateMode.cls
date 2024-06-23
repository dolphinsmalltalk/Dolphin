"Filed out from Dolphin Smalltalk"!

UI.TreeViewUpdateMode
	subclass: #'UI.TreeViewStaticUpdateMode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.TreeViewStaticUpdateMode guid: (Core.GUID fromString: '{23f9a4d8-9bb2-4cb1-8470-5a2f7e84cfe6}')!

UI.TreeViewStaticUpdateMode comment: '`TreeViewStaticUpdateMode` is a `TreeViewUpdateMode` policy that supplies the text, icon, etc, data for nodes when adding them to the `TreeView`. In this mode the control will store the data and not request it via notification callbacks, so it is effectively static. In order to refresh the data, it has to be updated explicitly. This may be an appropriate choice where there is a desire to show a snapshot of a tree model that may be changing rapidly.'!

!UI.TreeViewStaticUpdateMode categoriesForClass!MVP-Views-Support! !

!UI.TreeViewStaticUpdateMode methodsFor!

addItems: aCollection inHandle: parentHandle afterHandle: siblingHandle
	| tvis |
	tvis := TVINSERTSTRUCTW hParent: parentHandle hInsertAfter: siblingHandle.
	"Add items with subclassing removed so don't receive TVM_INSERTITEMs"
	view withOldWndProc: 
			[| tvItem getText getImage model |
			tvItem := tvis item.
			getText := view getTextBlock.
			getImage := view getImageBlock ?? [:item | nil].
			model := view model.
			aCollection do: 
					[:each |
					tvItem
						text: (getText value: each) displayString
						hasChildren: (model hasChildren: each)
						image: (getImage value: each).
					view tvmInsertItem: each tvis: tvis]]!

isVirtual
	^false!

name
	^#static!

updateAllItems
	view updateAllItems!

updateItem: anObject at: anExternalHandle
	"Update the text, image, and children flag of the specified element of the tree."

	| tvItem |
	tvItem := (TVITEMEXW hItem: anExternalHandle)
				text: (view getTextBlock value: anObject);
				children: (view model hasChildren: anObject) asInteger;
				yourself.
	view getImageBlock
		ifNotNil: 
			[:getImage |
			(getImage value: anObject)
				ifNotNil: 
					[:index |
					tvItem
						image: index - 1;
						selectedImage: index - 1]].
	view tvmSetItem: tvItem! !

!UI.TreeViewStaticUpdateMode categoriesForMethods!
addItems:inHandle:afterHandle:!adding!public! !
isVirtual!public!testing! !
name!accessing!public! !
updateAllItems!public!updating! !
updateItem:at:!public!updating! !
!

