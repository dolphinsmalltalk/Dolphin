"Filed out from Dolphin Smalltalk"!

SharedSet variableSubclass: #SharedIdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SharedIdentitySet guid: (GUID fromString: '{87b4c537-026e-11d3-9fd7-00a0cc3e4a32}')!

SharedIdentitySet comment: ''!

!SharedIdentitySet categoriesForClass!Collections-Unordered! !

!SharedIdentitySet methodsFor!

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

!SharedIdentitySet categoriesForMethods!
findElementOrNil:!private!searching! !
hash:max:!private!searching! !
!

