"Filed out from Dolphin Smalltalk 7"!

Core.WeakLookupTable variableSubclass: #'Core.WeakIdentityDictionary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.WeakIdentityDictionary guid: (Core.GUID fromString: '{87b4c534-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.WeakIdentityDictionary comment: ''!
!Core.WeakIdentityDictionary categoriesForClass!Collections-Unordered!Collections-Weak! !
!Core.WeakIdentityDictionary methodsFor!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	"Generally when copying part of a weak collection we don't want a weak result."

	^IdentityDictionary!

findKeyOrNil: anObject
	"Private - This method is a copy of IdentityDictionary>>findKeyOrNil:"

	| capacity index |
	index := anObject identityHash \\ (capacity := self basicSize) + 1.
	
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

	^SearchPolicy identity!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types.
	Weak types are generally considered as of the same species as their equivalent strong type."

	^IdentityDictionary! !
!Core.WeakIdentityDictionary categoriesFor: #copyingClass!copying!private! !
!Core.WeakIdentityDictionary categoriesFor: #findKeyOrNil:!private!searching! !
!Core.WeakIdentityDictionary categoriesFor: #hash:max:!private!searching! !
!Core.WeakIdentityDictionary categoriesFor: #keysClass!constants!public! !
!Core.WeakIdentityDictionary categoriesFor: #searchPolicy!constants!public! !
!Core.WeakIdentityDictionary categoriesFor: #species!accessing!public! !

!Core.WeakIdentityDictionary class methodsFor!

initialize
	"Initialize the receiver.
	Class initialize methods are ignored by the SourceManager unless directly implemented
	so we must implement to get the bereavement notifications."

	super initialize!

new: anInteger
	"Answer a new instance of the receiver sufficient capacity for anInteger elements. Both keys and values
	are weakly referenced. By default WeakIdentityDictionaries have both weak key and weak value references."

	^(super new: anInteger)
		haveWeakKeys;
		yourself! !
!Core.WeakIdentityDictionary class categoriesFor: #initialize!development!initializing!public! !
!Core.WeakIdentityDictionary class categoriesFor: #new:!instance creation!public! !

Core.WeakIdentityDictionary class methodProtocol: #'IdentityDictionary factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #withAll:)!

