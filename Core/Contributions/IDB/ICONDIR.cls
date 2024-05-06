"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #ICONDIR
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_idCount _OffsetOf_idEntries _OffsetOf_idReserved _OffsetOf_idType'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICONDIR guid: (GUID fromString: '{b5be1f5b-e245-4cdf-b274-b6609ab85b23}')!

ICONDIR addClassConstant: '_OffsetOf_idCount' value: 16r4!
ICONDIR addClassConstant: '_OffsetOf_idEntries' value: 16r6!
ICONDIR addClassConstant: '_OffsetOf_idReserved' value: 16r0!
ICONDIR addClassConstant: '_OffsetOf_idType' value: 16r2!

ICONDIR comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ICONDIR categoriesForClass!IDB Goodies! !

!ICONDIR methodsFor!

idCount
	"Answer the <Integer> value of the receiver's 'idCount' field."

	^bytes wordAtOffset: _OffsetOf_idCount!

idCount: anInteger
	"Set the receiver's 'idCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_idCount put: anInteger!

idEntries
	"Answer the <StructureArray> value of the receiver's 'idEntries' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_idEntries
		length: self idCount
		elementClass: ICONDIRENTRY!

idEntries: aStructureArrayOfICONDIRENTRY
	"Set the receiver's 'idEntries' field to the value of the argument, aStructureArrayOfICONDIRENTRY"

	| size |
	size := aStructureArrayOfICONDIRENTRY byteSize.
	aStructureArrayOfICONDIRENTRY
		replaceBytesOf: bytes
		from: ##(_OffsetOf_idEntries + 1)
		to: _OffsetOf_idEntries + size
		startingAt: 1.
	self idCount: aStructureArrayOfICONDIRENTRY size!

idReserved
	"Answer the <Integer> value of the receiver's 'idReserved' field."

	^bytes wordAtOffset: _OffsetOf_idReserved!

idType
	"Answer the <Integer> value of the receiver's 'idType' field."

	^bytes wordAtOffset: _OffsetOf_idType!

idType: anInteger
	"Set the receiver's 'idType' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_idType put: anInteger! !

!ICONDIR categoriesForMethods!
idCount!**compiled accessors**!public! !
idCount:!**compiled accessors**!public! !
idEntries!**compiled accessors**!public! !
idEntries:!**compiled accessors**!public! !
idReserved!**compiled accessors**!public! !
idType!**compiled accessors**!public! !
idType:!**compiled accessors**!public! !
!

!ICONDIR class methodsFor!

defineFields
	" ICONDIR compileDefinition 
	ALWAY precompile because of var struct!!!! "

	self
		defineField: #idReserved type: WORDField readOnly;
		defineField: #idType type: WORDField new;
		defineField: #idCount type: WORDField new;
		defineField: #idEntries
			type: (StructureArrayField type: ICONDIRENTRY
					arrayLength: (ConformantArrayFieldLength lengthField: #idCount))!

for: anInteger
	"Create an ICONDIR using this method and not new as we need to know
	how many bytes to allocate for the var struct"

	^self new: self byteSize + ((anInteger - 1) * ICONDIRENTRY byteSize)!

getFieldNames
	^#(#idReserved #idType #idCount #idEntries)!

packing
	^1! !

!ICONDIR class categoriesForMethods!
defineFields!initializing!public! !
for:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

