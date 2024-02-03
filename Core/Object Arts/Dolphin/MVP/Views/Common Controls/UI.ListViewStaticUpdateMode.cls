"Filed out from Dolphin Smalltalk"!

UI.ListViewUpdateMode
	subclass: #'UI.ListViewStaticUpdateMode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ListViewStaticUpdateMode guid: (Core.GUID fromString: '{6a4a8dcc-afe3-4152-9c61-98ef3e933149}')!
UI.ListViewStaticUpdateMode comment: ''!
!UI.ListViewStaticUpdateMode methodsFor!

addOrUpdate: msgInteger items: aSequenceableCollection afterIndex: indexInteger
	"Private - Add/update row and column items for specified sequence of objects to the ListView,
	starting at the specified row index."

	| lvItem primaryImageSupplier primaryTextSupplier isMultiColumn colImageBlock handle |
	primaryImageSupplier := primaryTextSupplier := view.
	colImageBlock := [:eachRow :eachCol | nil].
	(isMultiColumn := view isReportMode)
		ifTrue: 
			[primaryTextSupplier := (view allColumns lookup: 1) ?? view.
			view hasColumnImages
				ifTrue: 
					[colImageBlock := [:eachRow :eachCol | eachCol imageFromRow: eachRow].
					primaryImageSupplier := primaryTextSupplier]].
	lvItem := LVITEMW newBuffer.
	handle := view handle.
	aSequenceableCollection keysAndValuesDo: 
			[:i :each |
			"Note that row:text:imageIndex:indent: sets the mask, so would clear the LVIF_STATE flag if previously set"
			lvItem
				row: i + indexInteger
				text: (primaryTextSupplier textFromRow: each)
				imageIndex: (primaryImageSupplier imageFromRow: each)
				indent: (view indentFromRow: each).
			(view stateImageFromRow: each) ifNotNil: [:state | lvItem stateImageIndex: state].
			User32
				sendMessage: handle
				msg: msgInteger
				wParam: 0
				lpParam: lvItem].
	isMultiColumn ifFalse: [^self].
	view allColumns from: 2
		keysAndValuesDo: 
			[:j :eachCol |
			lvItem column: j.
			aSequenceableCollection keysAndValuesDo: 
					[:i :eachRow |
					lvItem
						row: i + indexInteger
						text: (eachCol textFromRow: eachRow)
						imageIndex: (colImageBlock value: eachRow value: eachCol)
						indent: 0.
					User32
						sendMessage: handle
						msg: LVM_SETITEMW
						wParam: 0
						lpParam: lvItem]]!

applyCallbackMask
	"We want the control to store all data"

	!

insertItems: aSequenceableCollection at: anInteger
	self
		addOrUpdate: LVM_INSERTITEMW
		items: aSequenceableCollection
		afterIndex: anInteger - 1!

isVirtual
	^false!

name
	^#static!

refreshAllItems
	view withOldWndProc: 
			[view noRedrawDo: 
					[view lvmDeleteAllItems.
					self insertItems: view list at: 1]]!

updateAllItems
	self
		addOrUpdate: LVM_SETITEMW
		items: view list
		afterIndex: 0!

updateIndentOf: anObject at: anInteger
	view lvmSetItem: (LVITEMW newBuffer
				iItem: anInteger - 1;
				indent: (view indentFromRow: anObject);
				yourself)!

updateItem: anObject at: anInteger
	"Re-render the specified item, which is at the specified <integer> index in the list."

	self
		addOrUpdate: LVM_SETITEMW
		items: { anObject }
		afterIndex: anInteger - 1!

updateStateImageOf: anObject at: anInteger
	view lvmSetItem: anInteger - 1
		state: (LVITEMW newBuffer
				iItem: anInteger - 1;
				stateImageIndex: (view stateImageFromRow: anObject);
				yourself)!

updateStateImages
	"Update the 'state' images for all items in the list."

	| lvItem |
	lvItem := LVITEMW newBuffer
				mask: LVIF_STATE;
				yourself.
	view list keysAndValuesDo: 
			[:index :each |
			lvItem
				iItem: index - 1;
				iStateImage: (view stateImageFromRow: each).
			view lvmSetItem: index - 1 state: lvItem]! !
!UI.ListViewStaticUpdateMode categoriesForMethods!
addOrUpdate:items:afterIndex:!private!updating! !
applyCallbackMask!operations!public! !
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

