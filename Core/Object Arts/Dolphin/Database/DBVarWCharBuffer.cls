"Filed out from Dolphin Smalltalk"!

DBVarFieldBuffer subclass: #DBVarWCharBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBVarWCharBuffer guid: (GUID fromString: '{f532232b-ffaa-4386-a728-c3e491a5452b}')!

DBVarWCharBuffer comment: ''!

!DBVarWCharBuffer categoriesForClass!Kernel-Objects! !

!DBVarWCharBuffer methodsFor!

blockTransferOctetSize
	"Private - Answer the size of indexable byte object to be allocated as the buffer used for transferring blocks of data when reading column values via SQLGetData."

	"Recall that Dolphin strings have an implicit null terminator character allocated automatically that is not included in the requested/reported size, and of course Utf16Strings have double-byte elements."

	^(BlockTransferOctetLength bitShift: -1) - 1!

bufferSizeForColumn: aDBColAttr
	^(aDBColAttr length bitShift: -1)!

dbConvert: anObject for: aDBField
	"Convert the argument to an <Utf16String> for marshalling to SQL_C_WCHAR representation in the <DBField> 2nd argument. Throw an error if this is not possible."

	^anObject asUtf16String!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^SQL_C_WCHAR!

dbMarshal: anObject into: aDBField
	"Populate the receiver, as buffer of the <DBField> 2nd argument, with the SQL_C_WCHAR (UTF-16) representation of the first argument."

	| utf16 octetSize |
	utf16 := self dbConvert: anObject for: aDBField.
	octetSize := utf16 size * 2.
	"Note that we are using the replaceBytes primitive here, so need to pass it the byte length to copy over"
	utf16
		replaceBytesOf: bytes
		from: 1
		to: octetSize
		startingAt: 1.
	aDBField length: octetSize!

dbUnmarshal: aDBField
	"Answer a <Utf16String> read from the receiver, assumed to be the buffer of the <DBField> argument containing a SQL_C_WCHAR value."

	^bytes copyFrom: 1 to: (aDBField length bitShift: -1)!

valueClass
	^Utf16String! !

!DBVarWCharBuffer categoriesForMethods!
blockTransferOctetSize!constants!private! !
bufferSizeForColumn:!initializing!private! !
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
dbUnmarshal:!operations!public! !
valueClass!constants!public! !
!

