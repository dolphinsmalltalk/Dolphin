"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #ICONDIR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICONDIR guid: (GUID fromString: '{b5be1f5b-e245-4cdf-b274-b6609ab85b23}')!
ICONDIR comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ICONDIR categoriesForClass!IDB Goodies! !
!ICONDIR methodsFor!

idCount
	"Answer the receiver's idCount field as a Smalltalk object."

	^bytes wordAtOffset: 4!

idCount: anObject
	"Set the receiver's idCount field to the value of anObject."

	bytes wordAtOffset: 4 put: anObject!

idEntries
	"Answer the receiver's idEntries field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + 6
		length: self idCount
		elementClass: ICONDIRENTRY!

idEntries: anObject
	"Set the receiver's idEntries field to the value of anObject."

	| size |
	size := anObject byteSize min: self idCount * 0.
	anObject 
		replaceBytesOf: bytes
		from: 7
		to: 6 + size
		startingAt: 1!

idReserved
	"Answer the receiver's idReserved field as a Smalltalk object."

	^bytes wordAtOffset: 0!

idType
	"Answer the receiver's idType field as a Smalltalk object."

	^bytes wordAtOffset: 2!

idType: anObject
	"Set the receiver's idType field to the value of anObject."

	bytes wordAtOffset: 2 put: anObject! !
!ICONDIR categoriesFor: #idCount!**compiled accessors**!public! !
!ICONDIR categoriesFor: #idCount:!**compiled accessors**!public! !
!ICONDIR categoriesFor: #idEntries!**compiled accessors**!public! !
!ICONDIR categoriesFor: #idEntries:!**compiled accessors**!public! !
!ICONDIR categoriesFor: #idReserved!**compiled accessors**!public! !
!ICONDIR categoriesFor: #idType!**compiled accessors**!public! !
!ICONDIR categoriesFor: #idType:!**compiled accessors**!public! !

!ICONDIR class methodsFor!

defineFields
	" ICONDIR compileDefinition 
	ALWAY precompile because of var struct!!!! "

	self
		defineField: #idReserved type: WORDField readOnly;
		defineField: #idType type: WORDField new;
		defineField: #idCount type: WORDField new;
		defineField: #idEntries type: (StructureArrayField type: ICONDIRENTRY lengthField: #idCount)!

for: anInteger
	"Create an ICONDIR using this method and not new as we need to know
	how many bytes to allocate for the var struct"

	^self new: self byteSize + ((anInteger - 1) * ICONDIRENTRY byteSize)!

packing
	^1! !
!ICONDIR class categoriesFor: #defineFields!initializing!public! !
!ICONDIR class categoriesFor: #for:!instance creation!public! !
!ICONDIR class categoriesFor: #packing!constants!public! !

