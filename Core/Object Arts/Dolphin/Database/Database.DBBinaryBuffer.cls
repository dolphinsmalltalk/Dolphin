"Filed out from Dolphin Smalltalk"!

Database.DBUnstructuredFieldBuffer
	subclass: #'Database.DBBinaryBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBBinaryBuffer guid: (Core.GUID fromString: '{94de9163-aaee-49c0-9429-66dc4d9b8cbb}')!

Database.DBBinaryBuffer comment: ''!

!Database.DBBinaryBuffer methodsFor!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^SQL_C_BINARY! !

!Database.DBBinaryBuffer categoriesForMethods!
dbInterchangeType!constants!public! !
!

!Database.DBBinaryBuffer class methodsFor!

valueClass
	^ByteArray! !

!Database.DBBinaryBuffer class categoriesForMethods!
valueClass!constants!public! !
!

