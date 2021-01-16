"Filed out from Dolphin Smalltalk 7"!

Database.DBSchemaStatement subclass: #'Database.DBTablesStatement'
	instanceVariableNames: 'tableType'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBTablesStatement guid: (Core.GUID fromString: '{404f79f7-4450-4d9d-9c0e-d2e9c8f897c6}')!
Database.DBTablesStatement comment: 'DBTablesStatement is a specialized <DBSchemaStatement> for querying about tables in a database.'!
!Database.DBTablesStatement categoriesForClass!ODBC Interface! !
!Database.DBTablesStatement methodsFor!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^OS.ODBCLibrary default 
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
!Database.DBTablesStatement categoriesFor: #executeStatement!operations!private! !
!Database.DBTablesStatement categoriesFor: #initialize:!initializing!private!searching! !
!Database.DBTablesStatement categoriesFor: #tableType!accessing!public!searching! !
!Database.DBTablesStatement categoriesFor: #tableType:!accessing!public!searching! !

