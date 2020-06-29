"Filed out from Dolphin Smalltalk 7"!

DBSchemaStatement subclass: #DBColumnsStatement
	instanceVariableNames: 'columnName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DBColumnsStatement guid: (GUID fromString: '{b6faef99-50db-490f-aa8c-b4483998fb14}')!
DBColumnsStatement comment: 'DBPrimaryKeysStatement is a specialized <DBSchemaStatement> for querying metadata about the columns of tables in a database.'!
!DBColumnsStatement categoriesForClass!ODBC Interface! !
!DBColumnsStatement methodsFor!

columnName
	^columnName!

columnName: aString
	columnName := aString!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^ODBCLibrary default 
		sqlColumns: self allocatedHandle
		catalogName: self catalogName
		nameLength1: SQL_NTS
		schemaName: self schemaName
		nameLength2: SQL_NTS
		tableName: self tableName
		nameLength3: SQL_NTS
		columnName: self columnName
		nameLength4: SQL_NTS! !
!DBColumnsStatement categoriesFor: #columnName!accessing!public! !
!DBColumnsStatement categoriesFor: #columnName:!accessing!public! !
!DBColumnsStatement categoriesFor: #executeStatement!operations!private! !

