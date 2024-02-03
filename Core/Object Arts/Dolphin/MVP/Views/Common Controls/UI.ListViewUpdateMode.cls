"Filed out from Dolphin Smalltalk"!

UI.IconicListUpdateMode
	subclass: #'UI.ListViewUpdateMode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ListViewConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ListViewUpdateMode guid: (Core.GUID fromString: '{d20ce47f-827a-479f-82bf-d2501d66aa71}')!
UI.ListViewUpdateMode isNonInstantiable: true!
UI.ListViewUpdateMode comment: ''!
!UI.ListViewUpdateMode methodsFor!

applyCallbackMask
	self subclassResponsibility!

insertItem: anObject atIndex: anInteger
	self insertItems: { anObject } at: anInteger!

insertItems: aSequenceableCollection at: anInteger
	self subclassResponsibility!

refreshAllItems
	self subclassResponsibility!

updateIndentOf: anObject at: anInteger
	self subclassResponsibility!

updateStateImageOf: anObject at: anInteger
	self subclassResponsibility!

updateStateImages
	self subclassResponsibility! !
!UI.ListViewUpdateMode categoriesForMethods!
applyCallbackMask!operations!public! !
insertItem:atIndex:!event handling!public! !
insertItems:at:!event handling!public! !
refreshAllItems!public!updating! !
updateIndentOf:at:!public!updating! !
updateStateImageOf:at:!public!updating! !
updateStateImages!public!updating! !
!

!UI.ListViewUpdateMode class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^ListView icon! !
!UI.ListViewUpdateMode class categoriesForMethods!
icon!constants!public! !
!

