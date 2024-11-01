"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Database.DBErrorDetails'
	instanceVariableNames: 'msg nativeErr sqlState'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBErrorDetails guid: (Core.GUID fromString: '{87b4c473-026e-11d3-9fd7-00a0cc3e4a32}')!

Database.DBErrorDetails comment: 'DBErrorDetails instances hold information about a particular ODBC sub-error.

Instance Variables:
	msg		<String>. Error message text.
	nativeErr		<String>. Database''s native error code.
	sqlState		<String>. ODBC error code.
	origin		<String>. Layer from which the error originated.
'!

!Database.DBErrorDetails categoriesForClass!ODBC Interface! !

!Database.DBErrorDetails methodsFor!

messageText
	"Answer a text representation of the error of the form:
		STATE: MSG"

	^(sqlState ifNil: [''] ifNotNil: [sqlState , ': ']) , msg!

msg
	"Answer the msg instance variable."

	^msg!

msg: aString
	"Private - Set the msg instance variable to aString."

	msg := aString!

nativeErr: anInteger
	"Private - Set the nativeErr instance variable to the argument."

	nativeErr := anInteger!

sqlState
	"Answer the sqlState instance variable."

	^sqlState!

sqlState: aString
	"Private - Set the sqlState instance variable to aString."

	sqlState := aString! !

!Database.DBErrorDetails categoriesForMethods!
messageText!accessing!public! !
msg!accessing!public! !
msg:!initializing!private! !
nativeErr:!initializing!private! !
sqlState!accessing!public! !
sqlState:!initializing!private! !
!

!Database.DBErrorDetails class methodsFor!

fromSQLError: errorString
	"Answer a new instance of the receiver built from the information in the 
	<readableString>, errorString."

	^self new msg: errorString yourself! !

!Database.DBErrorDetails class categoriesForMethods!
fromSQLError:!instance creation!public! !
!

