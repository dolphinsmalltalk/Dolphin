"Filed out from Dolphin Smalltalk X6"!

STBCollectionProxy subclass: #STBIdentityDictionaryProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBIdentityDictionaryProxy guid: (GUID fromString: '{87B4C6F6-026E-11D3-9FD7-00A0CC3E4A32}')!
STBIdentityDictionaryProxy comment: ''!
!STBIdentityDictionaryProxy categoriesForClass!System-Binary storage! !
!STBIdentityDictionaryProxy methodsFor!

value
	"Answer a new IdentityDictionary from the key-value pairs held by the receiver."

	| inst |
	inst := class new: (array size) / 2.
	1 to: array size by: 2 do: [:i |
		inst
			at:  (array at: i)
			put: (array at: i + 1)].
	^inst! !
!STBIdentityDictionaryProxy categoriesFor: #value!converting!public! !

!STBIdentityDictionaryProxy class methodsFor!

forCollection: anIdentityDictionary
	"Answer a new instance of the receiver which contains the key-value object pairs
	of anIdentityDictionary as an Array."

	| tempStream |
	tempStream := Array writeStream: anIdentityDictionary size * 2.
	anIdentityDictionary keysAndValuesDo: [
		:key :value |
		tempStream
			nextPut: key;
			nextPut: value].	
	^self
		class: anIdentityDictionary class
		array: tempStream contents
! !
!STBIdentityDictionaryProxy class categoriesFor: #forCollection:!instance creation!public! !

