"Filed out from Dolphin Smalltalk"!

Core.SharedSet
	variableSubclass: #'Core.SharedIdentitySet'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SharedIdentitySet guid: (Core.GUID fromString: '{87b4c537-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.SharedIdentitySet comment: ''!
!Core.SharedIdentitySet categoriesForClass!Collections-Unordered! !
!Core.SharedIdentitySet methodsFor!

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
!Core.SharedIdentitySet categoriesForMethods!
findElementOrNil:!private!searching! !
hash:max:!private!searching! !
!

