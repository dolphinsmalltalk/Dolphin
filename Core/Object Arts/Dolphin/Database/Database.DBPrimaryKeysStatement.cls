"Filed out from Dolphin Smalltalk 7"!

DBSchemaStatement subclass: #DBPrimaryKeysStatement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DBPrimaryKeysStatement guid: (GUID fromString: '{7df04e35-7e59-4700-9155-347cc2e61649}')!
DBPrimaryKeysStatement comment: 'DBPrimaryKeysStatement is a specialized <DBSchemaStatement> for querying about the primary keys of tables in a database.'!
!DBPrimaryKeysStatement categoriesForClass!ODBC Interface! !
!DBPrimaryKeysStatement methodsFor!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^ODBCLibrary default 
		sqlPrimaryKeys: self allocatedHandle
		catalogName: catalogName
		nameLength1: SQL_NTS
		schemaName: schemaName
		nameLength2: SQL_NTS
		tableName: tableName
		nameLength3: SQL_NTS! !
!DBPrimaryKeysStatement categoriesFor: #executeStatement!operations!private! !

