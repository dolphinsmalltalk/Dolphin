"Filed out from Dolphin Smalltalk X6"!

DBSchemaStatement subclass: #DBProceduresStatement
	instanceVariableNames: 'procedureName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DBProceduresStatement guid: (GUID fromString: '{3DEE7E8F-6C0C-403C-923A-7677F5E7C810}')!
DBProceduresStatement comment: 'DBProceduresStatement is a specialized <DBSchemaStatement> for querying about the stored procedures in a database.'!
!DBProceduresStatement categoriesForClass!ODBC Interface! !
!DBProceduresStatement methodsFor!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^ODBCLibrary default 
		sqlProcedures: self allocatedHandle
		catalogName: self catalogName
		nameLength1: SQL_NTS
		schemaName: self schemaName
		nameLength1: SQL_NTS
		procName: self procedureName
		nameLength3: SQL_NTS!

procedureName
	^procedureName!

procedureName: aString
	procedureName := aString! !
!DBProceduresStatement categoriesFor: #executeStatement!operations!private! !
!DBProceduresStatement categoriesFor: #procedureName!accessing!public! !
!DBProceduresStatement categoriesFor: #procedureName:!accessing!public! !

