"Filed out from Dolphin Smalltalk"!

UI.IconicListUpdateMode
	subclass: #'UI.TreeViewUpdateMode'
	instanceVariableNames: ''
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
	! !

!UI.TreeViewUpdateMode categoriesForMethods!
addItems:inHandle:afterHandle:!adding!public! !
!

!UI.TreeViewUpdateMode class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^TreeView icon! !

!UI.TreeViewUpdateMode class categoriesForMethods!
icon!constants!public! !
!

