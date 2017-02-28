"Filed out from Dolphin Smalltalk 7"!

LookupTable variableSubclass: #IdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdentityDictionary guid: (GUID fromString: '{87B4C52D-026E-11D3-9FD7-00A0CC3E4A32}')!
IdentityDictionary comment: 'IdentityDictionaries are <LookupTable>s which use identity (#== and #identityHash) for key comparison.

IdentityDictionary conforms to the following ANSI protocols:
	Object
	collection
	abstractDictionary
	IdentityDictionary'!
!IdentityDictionary categoriesForClass!Collections-Unordered! !
!IdentityDictionary methodsFor!

findKeyOrNil: anObject 
	"Private - Answer the index of the given key in the receiver, or, if not found,
	the index of the first empty slot including and after that to which 
	the key hashes."

	| capacity index |
	capacity := self basicSize.
	index := self hash: anObject max: capacity.
	
	[| key |
	(key := self basicAt: index) isNil or: [key == anObject]] 
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1!

keysClass
	"Answer the class of <collection> to be used for collecting the keys of the receiver"
	
	^IdentitySet!

searchPolicy
	"Answer the receiver's <searchPolicy>."

	^SearchPolicy identity! !
!IdentityDictionary categoriesFor: #findKeyOrNil:!private!searching! !
!IdentityDictionary categoriesFor: #hash:max:!private!searching! !
!IdentityDictionary categoriesFor: #keysClass!constants!public! !
!IdentityDictionary categoriesFor: #searchPolicy!constants!public! !

IdentityDictionary class methodProtocol: #'IdentityDictionary factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #withAll:)!

