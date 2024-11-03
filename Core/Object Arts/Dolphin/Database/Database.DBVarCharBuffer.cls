"Filed out from Dolphin Smalltalk"!

Database.DBVarFieldBuffer
	subclass: #'Database.DBVarCharBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBVarCharBuffer guid: (Core.GUID fromString: '{a0016f97-328c-4a8b-ac48-949d50b51c30}')!

Database.DBVarCharBuffer comment: ''!

!Database.DBVarCharBuffer categoriesForClass!Kernel-Objects! !

!Database.DBVarCharBuffer methodsFor!

blockTransferOctetSize
	"Private - Answer the size of indexable byte object to be allocated as the buffer used for transferring blocks of data when reading column values via SQLGetData."

	"Recall that Dolphin strings have an implicit null terminator character allocated automatically that is not included in the requested/reported size."

	^BlockTransferOctetLength - 1!

dbConvert: anObject for: aDBField
	"Convert the argument to an <AnsiString> for marshalling to SQL_C_CHAR representation in the <DBField> 2nd argument. Throw an error if this is not possible."

	^anObject asAnsiString!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^SQL_C_CHAR!

dbMarshal: anObject into: aDBField
	"Populate the receiver, as buffer of the <DBField> 2nd argument, with the SQL_C_CHAR  (i.e. ANSI string) representation of the first argument."

	"This conversion may be lossy - any non-ANSI characters will be substituted with the replacement character, $?."

	| ansi size |
	ansi := self dbConvert: anObject for: aDBField.
	size := ansi size.
	bytes
		replaceFrom: 1
		to: size
		with: ansi
		startingAt: 1.
	aDBField length: size!

dbUnmarshal: aDBField
	"Answer an <AnsiString> read from the receiver, assumed to be the buffer of the <DBField> argument containing a SQL_C_CHAR value."

	^bytes copyFrom: 1 to: aDBField length!

valueClass
	^AnsiString! !

!Database.DBVarCharBuffer categoriesForMethods!
blockTransferOctetSize!constants!private! !
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
dbUnmarshal:!operations!public! !
valueClass!constants!public! !
!

