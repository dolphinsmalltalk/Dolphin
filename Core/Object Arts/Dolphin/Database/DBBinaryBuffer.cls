"Filed out from Dolphin Smalltalk"!

DBUnstructuredFieldBuffer subclass: #DBBinaryBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBBinaryBuffer guid: (GUID fromString: '{94de9163-aaee-49c0-9429-66dc4d9b8cbb}')!

DBBinaryBuffer comment: ''!

!DBBinaryBuffer methodsFor!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^SQL_C_BINARY! !

!DBBinaryBuffer categoriesForMethods!
dbInterchangeType!constants!public! !
!

!DBBinaryBuffer class methodsFor!

valueClass
	^ByteArray! !

!DBBinaryBuffer class categoriesForMethods!
valueClass!constants!public! !
!

