"Filed out from Dolphin Smalltalk"!

Database.DBVarFieldBuffer
	subclass: #'Database.DBVarWCharBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBVarWCharBuffer guid: (Core.GUID fromString: '{f532232b-ffaa-4386-a728-c3e491a5452b}')!

Database.DBVarWCharBuffer comment: ''!

!Database.DBVarWCharBuffer categoriesForClass!Kernel-Objects! !

!Database.DBVarWCharBuffer methodsFor!

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

!Database.DBVarWCharBuffer categoriesForMethods!
blockTransferOctetSize!constants!private! !
bufferSizeForColumn:!initializing!private! !
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
dbUnmarshal:!operations!public! !
valueClass!constants!public! !
!

!Database.DBVarWCharBuffer class methodsFor!

dbTransferOctetLengthForColumn: aDBColAttr
	"Return the transfer octet length (size in bytes of the buffer necessary to receive data for this column) based on the column type, if fixed, else 0 for variable width columns.
		The transfer octet length of a column is the maximum number of bytes returned to the application when data is transferred to its default C data type. For character data, the transfer octet length does not include space for the null-termination character. The transfer octet length of a column may be different than the number of bytes required to store the data on the data source.
	From https://docs.microsoft.com/en-us/sql/odbc/reference/appendixes/transfer-octet-length"

	^(aDBColAttr precision ?? 0) bitShift: 1! !

!Database.DBVarWCharBuffer class categoriesForMethods!
dbTransferOctetLengthForColumn:!enquiries!public! !
!

