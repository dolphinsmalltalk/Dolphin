"Filed out from Dolphin Smalltalk X6"!

SharedLookupTable variableSubclass: #SharedIdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SharedIdentityDictionary guid: (GUID fromString: '{87B4C531-026E-11D3-9FD7-00A0CC3E4A32}')!
SharedIdentityDictionary comment: ''!
!SharedIdentityDictionary categoriesForClass!Collections-Unordered! !
!SharedIdentityDictionary methodsFor!

findKeyOrNil: anObject 
	"Private - This method is a copy of IdentityDictionary>>findKeyOrNil:"

	| capacity index |
	capacity := self basicSize.
	index := self hash: anObject max: capacity.
	
	[| key |
	(key := self basicAt: index) isNil or: [key == anObject]] 
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^anInteger < 8192 
		ifTrue: [anObject identityHash \\ anInteger + 1]
		ifFalse: [anObject identityHash * (anInteger bitShift: -12) \\ anInteger + 1]!

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

