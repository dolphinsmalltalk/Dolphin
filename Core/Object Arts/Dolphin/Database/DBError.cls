"Filed out from Dolphin Smalltalk 7"!

Error subclass: #DBError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants ODBCRetCodes'
	classInstanceVariableNames: ''
	classConstants: {}!
DBError guid: (GUID fromString: '{87b4c559-026e-11d3-9fd7-00a0cc3e4a32}')!
DBError comment: 'Instances of DBError hold exception information for Database Connection errors.'!
!DBError categoriesForClass!ODBC Interface! !
!DBError methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."
	
	^'%1 %2'!

signal
	"Signal this exception."

	self tag buildErrorInfo.
	super signal! !
!DBError categoriesFor: #_descriptionFormat!displaying!public! !
!DBError categoriesFor: #signal!public!signalling! !

