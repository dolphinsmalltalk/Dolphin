"Filed out from Dolphin Smalltalk"!

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

newConnection
	| adoConnection |
	self databaseResource isAvailable ifFalse: [^nil].
	adoConnection := ADODB_Connection new connectionString: self databaseResource connectString.
	adoConnection open.
	^adoConnection! !

!ADODBTest categoriesForMethods!
field:fromRow:!private!unit tests! !
newConnection!public!running! !
!

!ADODBTest class methodsFor!

resources
	^{SQLServerNorthwindDB}! !

!ADODBTest class categoriesForMethods!
resources!public! !
!

