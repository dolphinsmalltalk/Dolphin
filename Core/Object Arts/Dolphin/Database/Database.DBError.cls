"Filed out from Dolphin Smalltalk 7"!

Core.Error subclass: #'Database.DBError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ODBCRetCodes} #{OS.ODBCConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBError guid: (Core.GUID fromString: '{87b4c559-026e-11d3-9fd7-00a0cc3e4a32}')!
Database.DBError comment: 'Instances of DBError hold exception information for Database Connection errors.'!
!Database.DBError categoriesForClass!ODBC Interface! !
!Database.DBError methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."
	
	^'%1 %2'!

signal
	"Signal this exception."

	self tag buildErrorInfo.
	super signal! !
!Database.DBError categoriesFor: #_descriptionFormat!displaying!public! !
!Database.DBError categoriesFor: #signal!public!signalling! !

