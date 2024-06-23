"Filed out from Dolphin Smalltalk"!

UI.ListViewUpdateMode
	subclass: #'UI.ListViewVirtualUpdateMode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ListViewVirtualUpdateMode guid: (Core.GUID fromString: '{b5226276-4f05-4707-a7bb-344514cabdfb}')!

UI.ListViewVirtualUpdateMode comment: ''!

!UI.ListViewVirtualUpdateMode methodsFor!

applyCallbackMask
	| existingMask newMask |
	existingMask := view lvmGetCallbackMask.
	newMask := existingMask mask: LVIS_STATEIMAGEMASK set: view stateImageManager notNil.
	newMask = existingMask ifFalse: [view lvmSetCallbackMask: newMask]!

insertItem: anObject atIndex: anInteger
	view lvmInsertItem: (LVITEMW callbacksForIndex: anInteger - 1)!

insertItems: aSequenceableCollection at: anInteger
	| count |
	count := aSequenceableCollection size.
	"In a virtual list, if more than a few items are being added, we may as well just update the virtual size. This will cause the list to be redrawn completely, but unless inserting at the end that is likely anyway, and this is many times faster than sending multiple LVM_INSERTITEM messages."
	count > 3
		ifTrue: [view lvmSetItemCount: view lvmGetItemCount + count]
		ifFalse: 
			[| lvItem |
			lvItem := LVITEMW callbacksForIndex: 0.
			anInteger - 1 to: anInteger + count - 2
				do: 
					[:index |
					lvItem iItem: index.
					view lvmInsertItem: lvItem]]!

isVirtual
	^true!

name
	^#dynamic!

refreshAllItems
	| count |
	count := view size.
	view
		basicResetSelection;
		lvmSetItemCount: count.
	count > 0 ifTrue: [view autoResizeColumns]!

updateAllItems
	view invalidate!

updateIndentOf: anObject at: anInteger
	view invalidateItemAt: anInteger!

updateItem: anObject at: anInteger
	"Re-render the specified item, which is at the specified <integer> index in the list."

	"In virtual mode we can simply request that the item be redrawn, and let the ListView re-request the details."

	view invalidateItemAt: anInteger!

updateStateImageOf: anObject at: anInteger
	view invalidateItemAt: anInteger!

updateStateImages
	view invalidate! !

!UI.ListViewVirtualUpdateMode categoriesForMethods!
applyCallbackMask!operations!public! !
insertItem:atIndex:!event handling!public! !
insertItems:at:!event handling!public! !
isVirtual!public!testing! !
name!accessing!public! !
refreshAllItems!public!updating! !
updateAllItems!public!updating! !
updateIndentOf:at:!public!updating! !
updateItem:at:!public!updating! !
updateStateImageOf:at:!public!updating! !
updateStateImages!public!updating! !
!

