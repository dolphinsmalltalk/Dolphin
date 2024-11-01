"Filed out from Dolphin Smalltalk"!

Database.DBAbstractStatement
	subclass: #'Database.DBSchemaStatement'
	instanceVariableNames: 'catalogName schemaName tableName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBSchemaStatement guid: (Core.GUID fromString: '{66e78b00-fbb7-4843-90a5-bd3e064e836d}')!

Database.DBSchemaStatement comment: 'DBSchemaStatement is the class of Database Connection statements for querying metadata about the schema of a particular database. DBSchemaStatement itself is abstract, with subclasses implementing the commands for querying tables, columns, indices, procedures, primary and foreign key information, etc.'!

!Database.DBSchemaStatement categoriesForClass!ODBC Interface! !

!Database.DBSchemaStatement methodsFor!

catalogName
	^catalogName!

catalogName: aString
	catalogName := aString!

schemaName
	^schemaName!

schemaName: aStringPattern
	schemaName := aStringPattern!

tableName
	^tableName!

tableName: aStringPattern
	tableName := aStringPattern! !

!Database.DBSchemaStatement categoriesForMethods!
catalogName!accessing!public!searching! !
catalogName:!accessing!public!searching! !
schemaName!accessing!public!searching! !
schemaName:!accessing!public!searching! !
tableName!accessing!public!searching! !
tableName:!accessing!public!searching! !
!

