"Filed out from Dolphin Smalltalk"!

Database.Tests.DBTest
	subclass: #'ADODB.Tests.ADODBTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Tests.ADODBTest guid: (Core.GUID fromString: '{cbc7f08c-1041-4e55-a86a-5a963bba1649}')!
ADODB.Tests.ADODBTest comment: ''!
!ADODB.Tests.ADODBTest methodsFor!

field: aString fromRow: row 
	^(super field: aString fromRow: row) value!

setUp
	"Run the standard setup to skip if DB resource is unavailable"
	super setUp.
	"Then replace the connection"
	connection close.
	connection := _Connection new connectionString: self databaseResource connectString.
	connection open! !
!ADODB.Tests.ADODBTest categoriesForMethods!
field:fromRow:!private!unit tests! !
setUp!public!Running! !
!

!ADODB.Tests.ADODBTest class methodsFor!

resources
	^{Database.Tests.SQLServerNorthwindDB}! !
!ADODB.Tests.ADODBTest class categoriesForMethods!
resources!public! !
!

