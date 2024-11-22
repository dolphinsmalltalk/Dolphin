"Filed out from Dolphin Smalltalk"!

Database.DBUnstructuredFieldBuffer
	subclass: #'Database.DBCharBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBCharBuffer guid: (Core.GUID fromString: '{a53123d6-3370-4505-a70a-c8b2c0d7b43b}')!

Database.DBCharBuffer comment: ''!

!Database.DBCharBuffer methodsFor!

dbConvert: anObject for: aDBField
	"Convert the argument to an <AnsiString> for marshalling to SQL_C_CHAR representation in the <DBField> 2nd argument. Throw an error if this is not possible."

	^anObject asAnsiString!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^SQL_C_CHAR! !

!Database.DBCharBuffer categoriesForMethods!
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
!

!Database.DBCharBuffer class methodsFor!

valueClass
	^AnsiString! !

!Database.DBCharBuffer class categoriesForMethods!
valueClass!constants!public! !
!

