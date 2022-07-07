﻿"Filed out from Dolphin Smalltalk"!

Kernel.STBCollectionProxy subclass: #'Kernel.STBIdentityDictionaryProxy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBIdentityDictionaryProxy guid: (Core.GUID fromString: '{87b4c6f6-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBIdentityDictionaryProxy comment: ''!
!Kernel.STBIdentityDictionaryProxy categoriesForClass!System-Binary storage! !
!Kernel.STBIdentityDictionaryProxy methodsFor!

value
	"Answer a new IdentityDictionary from the key-value pairs held by the receiver."

	| inst count |
	count := array size.
	inst := class new: (count bitShift: -1).
	1 to: count
		by: 2
		do: [:i | inst at: (array at: i) put: (array at: i + 1)].
	^inst! !
!Kernel.STBIdentityDictionaryProxy categoriesForMethods!
value!converting!public! !
!

!Kernel.STBIdentityDictionaryProxy class methodsFor!

forCollection: anIdentityDictionary
	"Answer a new instance of the receiver which contains the key-value object pairs
	of anIdentityDictionary as an Array."

	| tempStream |
	tempStream := Array writeStream: anIdentityDictionary size * 2.
	anIdentityDictionary keysAndValuesDo: 
			[:key :value |
			tempStream
				nextPut: key;
				nextPut: value].
	^self class: anIdentityDictionary class array: tempStream grabContents! !
!Kernel.STBIdentityDictionaryProxy class categoriesForMethods!
forCollection:!instance creation!public! !
!
