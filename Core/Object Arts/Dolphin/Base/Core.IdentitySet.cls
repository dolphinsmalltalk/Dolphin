"Filed out from Dolphin Smalltalk 7"!

Set variableSubclass: #IdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IdentitySet guid: (GUID fromString: '{87b4c527-026e-11d3-9fd7-00a0cc3e4a32}')!
IdentitySet comment: ''!
!IdentitySet categoriesForClass!Collections-Unordered! !
!IdentitySet methodsFor!

findElementOrNil: anObject
	"Private - Answer the index of the given object in the receiver, or, if not found,
	the index of the first empty slot including and after that to which the object hashes.
	Implementation Note: This is a clone of Set>>findElementOrNil: except for the comparison of the elements
	which use identity (#identityHash and #==) instead of equality (#hash and #=). 
	The entire method is copied for performance reasons."

	| capacity index |
	index := anObject identityHash \\ (capacity := self basicSize) + 1.
	
	[| element |
	(element := self basicAt: index) isNil or: [anObject == element]]
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1!

identityIncludes: anObject
	"Answer whether the <Object> argument is one of the receiver's elements."

	"Implementation Note: Override as a (micro) optimization only. This is the same as
	#includes: for an IdentitySet, and we don't need to check that the found element is
	identical."

	^(self basicAt: (self findElementOrNil: anObject)) notNil! !
!IdentitySet categoriesFor: #findElementOrNil:!private!searching! !
!IdentitySet categoriesFor: #hash:max:!private!searching! !
!IdentitySet categoriesFor: #identityIncludes:!public!searching! !

