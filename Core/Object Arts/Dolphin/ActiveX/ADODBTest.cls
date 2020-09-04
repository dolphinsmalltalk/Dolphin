"Filed out from Dolphin Smalltalk 7"!

DBTest subclass: #ADODBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ADODBTest guid: (GUID fromString: '{cbc7f08c-1041-4e55-a86a-5a963bba1649}')!
ADODBTest comment: ''!
!ADODBTest categoriesForClass!Unclassified! !
!ADODBTest methodsFor!

field: aString fromRow: row 
	^(super field: aString fromRow: row) value!

setUp
	"Run the standard setup to skip if DB resource is unavailable"
	super setUp.
	"Then replace the connection"
	connection close.
	connection := ADODB_Connection new connectionString: self databaseResource connectString.
	connection open! !
!ADODBTest categoriesFor: #field:fromRow:!private!unit tests! !
!ADODBTest categoriesFor: #setUp!public!Running! !

!ADODBTest class methodsFor!

resources
	^{SQLServerNorthwindDB}! !
!ADODBTest class categoriesFor: #resources!public! !

