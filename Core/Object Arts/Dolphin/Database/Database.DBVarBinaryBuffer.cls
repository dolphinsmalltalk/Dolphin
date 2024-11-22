"Filed out from Dolphin Smalltalk"!

Database.DBVarFieldBuffer
	subclass: #'Database.DBVarBinaryBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBVarBinaryBuffer guid: (Core.GUID fromString: '{aa5c57bd-c184-4c3a-9f8a-faa9b8c952b6}')!

Database.DBVarBinaryBuffer comment: ''!

!Database.DBVarBinaryBuffer categoriesForClass!Kernel-Objects! !

!Database.DBVarBinaryBuffer methodsFor!

blockTransferOctetSize
	"Private - Answer the size of indexable byte object to be allocated as the buffer used for transferring blocks of data when reading column values via SQLGetData."

	^BlockTransferOctetLength!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^SQL_C_BINARY!

dbMarshal: anObject into: aDBField
	"Populate the receiver, as buffer of the <DBField> 2nd argument, with the SQL_C_BINARY (e.g. ByteArray) representation of the 1st argument."

	| byteArray byteCount |
	byteArray := self dbConvert: anObject for: aDBField.
	byteCount := byteArray size.
	bytes
		replaceFrom: 1
		to: byteCount
		with: byteArray
		startingAt: 1.
	aDBField length: byteCount!

dbUnmarshal: aDBField
	"Answer a <ByteArray> read from the receiver, assumed to be the buffer of the <DBField> argument containing a SQL_C_BINARY value."

	^bytes copyFrom: 1 to: aDBField length! !

!Database.DBVarBinaryBuffer categoriesForMethods!
blockTransferOctetSize!constants!private! !
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
dbUnmarshal:!operations!public! !
!

!Database.DBVarBinaryBuffer class methodsFor!

valueClass
	^ByteArray! !

!Database.DBVarBinaryBuffer class categoriesForMethods!
valueClass!constants!public! !
!

