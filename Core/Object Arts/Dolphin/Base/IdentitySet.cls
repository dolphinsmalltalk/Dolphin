"Filed out from Dolphin Smalltalk 7"!

Set variableSubclass: #IdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdentitySet guid: (GUID fromString: '{87B4C527-026E-11D3-9FD7-00A0CC3E4A32}')!
IdentitySet comment: ''!
!IdentitySet categoriesForClass!Collections-Unordered! !
!IdentitySet methodsFor!

findElementOrNil: anObject 
	"Private - Answer the index of the given object in the receiver, or, if not found,
	the index of the first empty slot including and after that to which the object hashes.
	Implementation Note: This is a clone of Set>>findElementOrNil: except for the comparison of the elements
	which use identity (#identityHash and #==) instead of equality (#hash and #=). 
	The entire method is copied for performance reasons. 	We scale the hash value 
	for large collections to avoid excessive collisions caused by the small identity hash
	range (0..65535)."

	| capacity index |
	capacity := self basicSize.
	index := self hash: anObject max: capacity.
	
	[| element |
	(element := self basicAt: index) isNil or: [anObject == element]] 
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^anInteger < 8192 
		ifTrue: [anObject identityHash \\ anInteger + 1]
		ifFalse: [anObject identityHash * (anInteger bitShift: -12) \\ anInteger + 1]!

identityIncludes: anObject
	"Answer whether the <Object> argument is one of the receiver's elements."

	"Implementation Note: Override as a (micro) optimization only. This is the same as
	#includes: for an IdentitySet, and we don't need to check that the found element is
	identical."

	^(self basicAt: (self findElementOrNil: anObject)) notNil! !
!IdentitySet categoriesFor: #findElementOrNil:!private!searching! !
!IdentitySet categoriesFor: #hash:max:!private!searching! !
!IdentitySet categoriesFor: #identityIncludes:!public!searching! !

