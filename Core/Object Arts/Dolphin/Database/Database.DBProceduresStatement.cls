"Filed out from Dolphin Smalltalk 7"!

Database.DBSchemaStatement subclass: #'Database.DBProceduresStatement'
	instanceVariableNames: 'procedureName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBProceduresStatement guid: (Core.GUID fromString: '{3dee7e8f-6c0c-403c-923a-7677f5e7c810}')!
Database.DBProceduresStatement comment: 'DBProceduresStatement is a specialized <DBSchemaStatement> for querying about the stored procedures in a database.'!
!Database.DBProceduresStatement categoriesForClass!ODBC Interface! !
!Database.DBProceduresStatement methodsFor!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^OS.ODBCLibrary default 
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
!Database.DBProceduresStatement categoriesFor: #executeStatement!operations!private! !
!Database.DBProceduresStatement categoriesFor: #procedureName!accessing!public! !
!Database.DBProceduresStatement categoriesFor: #procedureName:!accessing!public! !

