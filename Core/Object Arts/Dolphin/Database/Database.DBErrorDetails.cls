"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Database.DBErrorDetails'
	instanceVariableNames: 'msg nativeErr sqlState origin'
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

	^(sqlState isNil 
		ifTrue: ['']
		ifFalse: [sqlState, ': ']), msg!

msg
	"Answer the msg instance variable."

	^msg!

msg: aString
	"Private - Set the msg instance variable to aString."

	msg := aString!

nativeErr: aString
	"Private - Set the nativeErr instance variable to aString."

	nativeErr := aString!

origin: aString
	"Private - Set the origin instance variable to aString."

	origin := aString.!

sqlState
	"Answer the sqlState instance variable."

	^sqlState!

sqlState: aString
	"Private - Set the sqlState instance variable to aString."

	sqlState := aString! !
!Database.DBErrorDetails categoriesFor: #messageText!accessing!public! !
!Database.DBErrorDetails categoriesFor: #msg!accessing!public! !
!Database.DBErrorDetails categoriesFor: #msg:!accessing!private! !
!Database.DBErrorDetails categoriesFor: #nativeErr:!accessing!private! !
!Database.DBErrorDetails categoriesFor: #origin:!accessing!private! !
!Database.DBErrorDetails categoriesFor: #sqlState!accessing!public! !
!Database.DBErrorDetails categoriesFor: #sqlState:!accessing!private! !

!Database.DBErrorDetails class methodsFor!

fromSQLError: errorString
	"Answer a new instance of the receiver built from the information in the 
	<readableString>, errorString."

	| lastBrkt |
	lastBrkt := errorString lastIndexOf: $].
	^self new
		msg: errorString;
		origin: (errorString copyFrom: 1 to: lastBrkt);
		yourself! !
!Database.DBErrorDetails class categoriesFor: #fromSQLError:!instance creation!public! !

