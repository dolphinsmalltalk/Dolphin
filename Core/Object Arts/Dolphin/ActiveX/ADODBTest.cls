"Filed out from Dolphin Smalltalk 7"!

DBTest subclass: #ADODBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ADODBTest guid: (GUID fromString: '{CBC7F08C-1041-4E55-A86A-5A963BBA1649}')!
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

