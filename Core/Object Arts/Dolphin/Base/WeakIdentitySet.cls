"Filed out from Dolphin Smalltalk"!

WeakSet variableSubclass: #WeakIdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WeakIdentitySet guid: (GUID fromString: '{87b4c539-026e-11d3-9fd7-00a0cc3e4a32}')!

WeakIdentitySet comment: ''!

!WeakIdentitySet categoriesForClass!Collections-Unordered!Collections-Weak! !

!WeakIdentitySet methodsFor!

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

!WeakIdentitySet categoriesForMethods!
findElementOrNil:!private!searching! !
hash:max:!private!searching! !
!

!WeakIdentitySet class methodsFor!

initialize
	"Initialize the receiver.
	Class initialize methods are ignored by the SourceManager unless directly implemented
	so we must implement to get the bereavement notifications."

	super initialize! !

!WeakIdentitySet class categoriesForMethods!
initialize!development!initializing!public! !
!

