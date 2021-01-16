"Filed out from Dolphin Smalltalk 7"!

Database.DBSchemaStatement subclass: #'Database.DBPrimaryKeysStatement'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBPrimaryKeysStatement guid: (Core.GUID fromString: '{7df04e35-7e59-4700-9155-347cc2e61649}')!
Database.DBPrimaryKeysStatement comment: 'DBPrimaryKeysStatement is a specialized <DBSchemaStatement> for querying about the primary keys of tables in a database.'!
!Database.DBPrimaryKeysStatement categoriesForClass!ODBC Interface! !
!Database.DBPrimaryKeysStatement methodsFor!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^OS.ODBCLibrary default 
		sqlPrimaryKeys: self allocatedHandle
		catalogName: catalogName
		nameLength1: SQL_NTS
		schemaName: schemaName
		nameLength2: SQL_NTS
		tableName: tableName
		nameLength3: SQL_NTS! !
!Database.DBPrimaryKeysStatement categoriesFor: #executeStatement!operations!private! !

