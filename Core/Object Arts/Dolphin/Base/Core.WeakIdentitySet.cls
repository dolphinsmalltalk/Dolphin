"Filed out from Dolphin Smalltalk 7"!

Core.WeakSet variableSubclass: #'Core.WeakIdentitySet'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.WeakIdentitySet guid: (Core.GUID fromString: '{87b4c539-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.WeakIdentitySet comment: ''!
!Core.WeakIdentitySet categoriesForClass!Collections-Unordered!Collections-Weak! !
!Core.WeakIdentitySet methodsFor!

findElementOrNil: anObject
	"Private - This method is a copy of IdentitySet>>findElementOrNil:"

	| capacity index |
	index := anObject identityHash \\ (capacity := self basicSize) + 1.
	
	[| element |
	(element := self basicAt: index) isNil or: [anObject == element]]
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !
!Core.WeakIdentitySet categoriesFor: #findElementOrNil:!private!searching! !
!Core.WeakIdentitySet categoriesFor: #hash:max:!private!searching! !

!Core.WeakIdentitySet class methodsFor!

initialize
	"Initialize the receiver.
	Class initialize methods are ignored by the SourceManager unless directly implemented
	so we must implement to get the bereavement notifications."

	super initialize! !
!Core.WeakIdentitySet class categoriesFor: #initialize!development!initializing!public! !

