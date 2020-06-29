"Filed out from Dolphin Smalltalk 7"!

DBSchemaStatement subclass: #DBTablesStatement
	instanceVariableNames: 'tableType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DBTablesStatement guid: (GUID fromString: '{404f79f7-4450-4d9d-9c0e-d2e9c8f897c6}')!
DBTablesStatement comment: 'DBTablesStatement is a specialized <DBSchemaStatement> for querying about tables in a database.'!
!DBTablesStatement categoriesForClass!ODBC Interface! !
!DBTablesStatement methodsFor!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^ODBCLibrary default 
		sqlTables: self allocatedHandle
		szTableQualifier: catalogName
		cbTableQualifier: SQL_NTS
		szTableOwner: schemaName
		cbTableOwner: SQL_NTS
		szTableName: tableName
		cbTableName: SQL_NTS
		szTableType: tableType
		cbTableType: SQL_NTS!

initialize: aDBConnection
	"Private - Initialize the receiver as a new statement of the
	<DBConnection>, aDBConnection."

	super initialize: aDBConnection.
	tableType := '''TABLE'''!

tableType
	^tableType!

tableType: aString
	tableType := aString! !
!DBTablesStatement categoriesFor: #executeStatement!operations!private! !
!DBTablesStatement categoriesFor: #initialize:!initializing!private!searching! !
!DBTablesStatement categoriesFor: #tableType!accessing!public!searching! !
!DBTablesStatement categoriesFor: #tableType:!accessing!public!searching! !

