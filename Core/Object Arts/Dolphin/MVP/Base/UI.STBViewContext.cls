"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.STBViewContext'
	instanceVariableNames: 'parent owner'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.STBViewContext guid: (Core.GUID fromString: '{d97f9064-dc0a-44a5-b1d6-8f0687b53a89}')!

UI.STBViewContext comment: ''!

!UI.STBViewContext categoriesForClass!Kernel-Objects! !

!UI.STBViewContext methodsFor!

dialogOwner
	^owner!

loadViewResource: aResourceArray forEdit: aBoolean
	"Load an instance of the resource held in aResourceArray. Answer the new view."

	^parent
		loadViewResource: aResourceArray
		withContext: self
		forEdit: aBoolean!

owner
	^owner!

owner: anObject
	owner := anObject!

parent
	^parent!

parent: anObject
	parent := anObject!

view
	^parent! !

!UI.STBViewContext categoriesForMethods!
dialogOwner!accessing!public! !
loadViewResource:forEdit:!binary filing!public! !
owner!accessing!public! !
owner:!accessing!public! !
parent!accessing!public! !
parent:!accessing!public! !
view!accessing!public! !
!

!UI.STBViewContext class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^STxFiler icon!

parent: aView
	<primitive: 157>
	^self new
		parent: aView;
		yourself!

parent: parentView owner: ownerView
	<primitive: 157>
	^self new
		parent: parentView;
		owner: ownerView;
		yourself! !

!UI.STBViewContext class categoriesForMethods!
icon!constants!public! !
parent:!instance creation!public! !
parent:owner:!instance creation!public! !
!

