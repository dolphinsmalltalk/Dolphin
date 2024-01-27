"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.TreeViewUpdateMode'
	instanceVariableNames: 'view'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.TreeViewUpdateMode guid: (Core.GUID fromString: '{42d1a3f6-a5b6-4641-b8aa-75d922c38fc2}')!
UI.TreeViewUpdateMode isNonInstantiable: true!
UI.TreeViewUpdateMode comment: '`TreeViewUpdateMode` is the abstract class of policy objects that implement the various `TreeView` update modes. These what item data (text, icons, etc) that the tree views stores, and what it requests when required. 

## Instance Variables:
  `view`		`TreeView` for which the update mode is providing item update policy.
'!
!UI.TreeViewUpdateMode categoriesForClass!MVP-Views-Support! !
!UI.TreeViewUpdateMode methodsFor!

addItems: aCollection inHandle: parentHandle afterHandle: siblingHandle
	self subclassResponsibility
	!

isVirtual
	^self subclassResponsibility!

name
	"Answer the name of this tree view update mode, one of:
		#dynamic	- display details re-requested by callback on every paint
		#lazy		- display details initially requested by callback on first paint only
		#static	- tree nodes fully populated with display details when first added
	The display details referred to are the label text, icon, and whether or not the node has children."

	^self subclassResponsibility!

refreshItem: anObject handle: hItem
	"Update the text, image, and children flag of the specified element of the tree."

	self subclassResponsibility!

setView: aTreeView
	view := aTreeView.
	^self!

updateAll
	^self subclassResponsibility!

view
	^view!

viewStoresItemData
	"Answer whether the TreeView stores text and icon data in this update mode."

	^true! !
!UI.TreeViewUpdateMode categoriesForMethods!
addItems:inHandle:afterHandle:!adding!public! !
isVirtual!public!testing! !
name!accessing!public! !
refreshItem:handle:!public!updating! !
setView:!initializing!private! !
updateAll!public!updating! !
view!accessing!private! !
viewStoresItemData!public!testing! !
!

!UI.TreeViewUpdateMode class methodsFor!

forTreeView: aTreeView
	^self new
		setView: aTreeView;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^TreeView icon! !
!UI.TreeViewUpdateMode class categoriesForMethods!
forTreeView:!public! !
icon!constants!public! !
!

