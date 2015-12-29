"Filed out from Dolphin Smalltalk X6"!

DBSchemaStatement subclass: #DBTablesStatement
	instanceVariableNames: 'tableType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DBTablesStatement guid: (GUID fromString: '{404F79F7-4450-4D9D-9C0E-D2E9C8F897C6}')!
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

