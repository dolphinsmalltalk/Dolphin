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

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	"Generally when copying part of a weak collection we don't want a weak result."

	^IdentitySet!

findElementOrNil: anObject
	"Private - This method is a copy of IdentitySet>>findElementOrNil:"

	| capacity index |
	index := anObject identityHash \\ (capacity := self basicSize) + 1.
	
	[| element |
	(element := self basicAt: index) isNil or: [anObject == element]]
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types.
	Weak types are generally considered as of the same species as their equivalent strong type."

	^IdentitySet! !
!Core.WeakIdentitySet categoriesFor: #copyingClass!copying!private! !
!Core.WeakIdentitySet categoriesFor: #findElementOrNil:!private!searching! !
!Core.WeakIdentitySet categoriesFor: #hash:max:!private!searching! !
!Core.WeakIdentitySet categoriesFor: #species!accessing!public! !

!Core.WeakIdentitySet class methodsFor!

initialize
	"Initialize the receiver.
	Class initialize methods are ignored by the SourceManager unless directly implemented
	so we must implement to get the bereavement notifications."

	super initialize! !
!Core.WeakIdentitySet class categoriesFor: #initialize!development!initializing!public! !

