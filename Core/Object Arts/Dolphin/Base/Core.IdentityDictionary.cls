"Filed out from Dolphin Smalltalk 7"!

Core.LookupTable variableSubclass: #'Core.IdentityDictionary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.IdentityDictionary guid: (Core.GUID fromString: '{87b4c52d-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.IdentityDictionary comment: 'IdentityDictionaries are <LookupTable>s which use identity (#== and #identityHash) for key comparison.

IdentityDictionary conforms to the following ANSI protocols:
	Object
	collection
	abstractDictionary
	IdentityDictionary'!
!Core.IdentityDictionary categoriesForClass!Collections-Unordered! !
!Core.IdentityDictionary methodsFor!

findKeyOrNil: anObject
	"Private - Answer the index of the given key in the receiver, or, if not found, the index of the first empty slot including and after that to which the key hashes."

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
	"Answer the class of <collection> to be used for collecting the keys of the receiver"

	^IdentitySet!

searchPolicy
	"Answer the receiver's <searchPolicy>."

	^SearchPolicy identity!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types."

	^IdentityDictionary! !
!Core.IdentityDictionary categoriesFor: #findKeyOrNil:!private!searching! !
!Core.IdentityDictionary categoriesFor: #hash:max:!private!searching! !
!Core.IdentityDictionary categoriesFor: #keysClass!constants!public! !
!Core.IdentityDictionary categoriesFor: #searchPolicy!constants!public! !
!Core.IdentityDictionary categoriesFor: #species!accessing!public! !

Core.IdentityDictionary class methodProtocol: #'IdentityDictionary factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #withAll:)!

