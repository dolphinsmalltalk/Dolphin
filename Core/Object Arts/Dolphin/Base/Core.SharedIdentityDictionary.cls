"Filed out from Dolphin Smalltalk 7"!

SharedLookupTable variableSubclass: #SharedIdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SharedIdentityDictionary guid: (GUID fromString: '{87b4c531-026e-11d3-9fd7-00a0cc3e4a32}')!
SharedIdentityDictionary comment: ''!
!SharedIdentityDictionary categoriesForClass!Collections-Unordered! !
!SharedIdentityDictionary methodsFor!

findKeyOrNil: anObject
	"Private - This method is a copy of IdentityDictionary>>findKeyOrNil:"

	| capacity index |
	capacity := self basicSize.
	index := anObject identityHash \\ capacity + 1.
	
	[| key |
	(key := self basicAt: index) isNil or: [key == anObject]]
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1!

keysClass
	"Answer the class of Collection to be used for collecting the keys of the receiver"
	
	^IdentitySet!

searchPolicy
	"Answer the receiver's <searchPolicy>."

	^SearchPolicy identity! !
!SharedIdentityDictionary categoriesFor: #findKeyOrNil:!private!searching! !
!SharedIdentityDictionary categoriesFor: #hash:max:!private!searching! !
!SharedIdentityDictionary categoriesFor: #keysClass!constants!public! !
!SharedIdentityDictionary categoriesFor: #searchPolicy!constants!public! !

