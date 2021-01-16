"Filed out from Dolphin Smalltalk 7"!

Database.DBAbstractStatement subclass: #'Database.DBSchemaStatement'
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

defaultCursorType
	"Answer the <Symbol>ic name of the default cursor type to be used for statements
	(one of #dynamic, #forwardOnly, #keysetDriven, #static)."

	^#forwardOnly
!

schemaName
	^schemaName!

schemaName: aStringPattern
	schemaName := aStringPattern!

tableName
	^tableName!

tableName: aStringPattern
	tableName := aStringPattern! !
!Database.DBSchemaStatement categoriesFor: #catalogName!accessing!public!searching! !
!Database.DBSchemaStatement categoriesFor: #catalogName:!accessing!public!searching! !
!Database.DBSchemaStatement categoriesFor: #defaultCursorType!constants!public! !
!Database.DBSchemaStatement categoriesFor: #schemaName!accessing!public!searching! !
!Database.DBSchemaStatement categoriesFor: #schemaName:!accessing!public!searching! !
!Database.DBSchemaStatement categoriesFor: #tableName!accessing!public!searching! !
!Database.DBSchemaStatement categoriesFor: #tableName:!accessing!public!searching! !

