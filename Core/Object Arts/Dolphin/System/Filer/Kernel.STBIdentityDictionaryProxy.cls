﻿"Filed out from Dolphin Smalltalk"!

Kernel.STBCollectionProxy
	subclass: #'Kernel.STBIdentityDictionaryProxy'
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
	"Answer a new LookupTable from the key-value pairs held by the receiver."

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

class: aClass associations: anArray
	"Answer a new instance containing the class and elements of
	the collection that it represents."

	| stream |
	stream := Array writeStream: anArray size * 2.
	anArray do: 
			[:each |
			stream
				nextPut: each key;
				nextPut: each value].
	^self class: aClass array: stream grabContents!

forCollection: aLookupTable
	"Answer a new instance of the receiver which contains the key-value object pairs of the <LookupTable> argument as an Array."

	| tempStream |
	tempStream := Array writeStream: aLookupTable size * 2.
	aLookupTable keysAndValuesDo: 
			[:key :value |
			tempStream
				nextPut: key;
				nextPut: value].
	^self class: aLookupTable class array: tempStream grabContents! !

!Kernel.STBIdentityDictionaryProxy class categoriesForMethods!
class:associations:!instance creation!public! !
forCollection:!instance creation!public! !
!

