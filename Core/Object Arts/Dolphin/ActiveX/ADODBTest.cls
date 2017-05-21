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
	"Use the NorthWind sample database as a conveniently available DB"

	connection := ADODB_Connection new connectionString: self connectString.
	connection open! !
!ADODBTest categoriesFor: #field:fromRow:!private!unit tests! !
!ADODBTest categoriesFor: #setUp!public!Running! !

