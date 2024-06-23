"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.IconicListUpdateMode'
	instanceVariableNames: 'view'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.IconicListUpdateMode guid: (Core.GUID fromString: '{81176ed9-fdb6-4fc4-94f7-373d8ecd059c}')!

UI.IconicListUpdateMode isNonInstantiable: true!

UI.IconicListUpdateMode comment: ''!

!UI.IconicListUpdateMode methodsFor!

isVirtual
	"Answer whether the update mode is 'virtual', where the control does not store the display details, but instead requests them every time they are required for painting."

	^self subclassResponsibility!

name
	"Answer the name of this tree view update mode, one of:
		#dynamic	- display details re-requested by callback on every paint
		#lazy		- display details initially requested by callback on first paint only
		#static		- Items fully populated with display details when first added
	The display details referred to are the label text, icons, (in a tree) whether or not the node has children, and (in a list) the row indent."

	^self subclassResponsibility!

setView: aTreeView
	view := aTreeView.
	^self!

updateAllItems
	"Re-display all items in the view to reflect any changes in the underlying data."

	self subclassResponsibility!

updateItem: anObject at: hItem
	"Update the text, image, and children flag of the specified element of the tree."

	self subclassResponsibility!

view
	^view!

viewStoresItemData
	"Answer whether the view stores text and icon data in this update mode."

	^self isVirtual not! !

!UI.IconicListUpdateMode categoriesForMethods!
isVirtual!public!testing! !
name!accessing!public! !
setView:!initializing!private! !
updateAllItems!public!updating! !
updateItem:at:!public!updating! !
view!accessing!private! !
viewStoresItemData!public!testing! !
!

!UI.IconicListUpdateMode class methodsFor!

forIconicList: anIconicListAbstract
	^self new
		setView: anIconicListAbstract;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^IconicListAbstract icon! !

!UI.IconicListUpdateMode class categoriesForMethods!
forIconicList:!instance creation!public! !
icon!constants!public! !
!

