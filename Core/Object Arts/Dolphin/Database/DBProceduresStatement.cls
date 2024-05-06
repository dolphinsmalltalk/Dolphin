"Filed out from Dolphin Smalltalk"!

DBSchemaStatement subclass: #DBProceduresStatement
	instanceVariableNames: 'procedureName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBProceduresStatement guid: (GUID fromString: '{3dee7e8f-6c0c-403c-923a-7677f5e7c810}')!

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

!DBProceduresStatement categoriesForMethods!
executeStatement!operations!private! !
procedureName!accessing!public! !
procedureName:!accessing!public! !
!

