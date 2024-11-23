﻿"Filed out from Dolphin Smalltalk"!

Database.DBUnstructuredFieldBuffer
	subclass: #'Database.DBWCharBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBWCharBuffer guid: (Core.GUID fromString: '{2d5ec228-0f92-4205-9f40-09f0a186dacd}')!

Database.DBWCharBuffer comment: ''!

!Database.DBWCharBuffer methodsFor!

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
	aDBField length: octetSize! !

!Database.DBWCharBuffer categoriesForMethods!
bufferSizeForColumn:!initializing!private! !
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
!

!Database.DBWCharBuffer class methodsFor!

dbTransferOctetLengthForColumn: aDBColAttr
	"Return the transfer octet length (size in bytes of the buffer necessary to receive data for this column) for the configured precision of the WCHAR (fixed-width) column.
		The transfer octet length of a column is the maximum number of bytes returned to the application when data is transferred to its default C data type. For character data, the transfer octet length does not include space for the null-termination character. The transfer octet length of a column may be different than the number of bytes required to store the data on the data source.
	From https://docs.microsoft.com/en-us/sql/odbc/reference/appendixes/transfer-octet-length"

	^aDBColAttr precision ?? 0 bitShift: 1!

valueClass
	^Utf16String! !

!Database.DBWCharBuffer class categoriesForMethods!
dbTransferOctetLengthForColumn:!enquiries!public! !
valueClass!constants!public! !
!
