"Filed out from Dolphin Smalltalk"!

Core.Set
	variableSubclass: #'Core.IdentitySet'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.IdentitySet guid: (Core.GUID fromString: '{87b4c527-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.IdentitySet comment: ''!

!Core.IdentitySet categoriesForClass!Collections-Unordered! !

!Core.IdentitySet methodsFor!

findElementOrNil: anObject
	"Private - Answer the index of the given object in the receiver, or, if not found, the index of the first empty slot including and after that to which the object hashes."

	"Implementation Note: This is a clone of Set>>findElementOrNil:, except for the comparison of the elements which use identity (#identityHash and #==) instead of equality (#hash and #=). 
	The entire method is copied for performance reasons."

	| index element capacity start |
	start := index := anObject identityHash \\ (capacity := self basicSize) + 1.
	
	[((element := self basicAt: index) isNil or: [anObject == element]) ifTrue: [^index].
	(index := index + 1) > capacity]
			whileFalse.
	"Wraparound"
	index := 0.
	[(index := index + 1) == start]
		whileFalse: [((element := self basicAt: index) isNil or: [anObject == element]) ifTrue: [^index]].

	"Not found and no spare capacity slots - this should not happen"
	^0!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1!

identityIncludes: anObject
	"Answer whether the <Object> argument is one of the receiver's elements."

	"Implementation Note: Override as a (micro) optimization only. This is the same as
	#includes: for an IdentitySet, and we don't need to check that the found element is
	identical."

	^(self basicAt: (self findElementOrNil: anObject)) notNil! !

!Core.IdentitySet categoriesForMethods!
findElementOrNil:!private!searching! !
hash:max:!private!searching! !
identityIncludes:!public!searching! !
!

