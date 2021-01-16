"Filed out from Dolphin Smalltalk 7"!

DBAbstractStatement subclass: #DBSchemaStatement
	instanceVariableNames: 'catalogName schemaName tableName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DBSchemaStatement guid: (GUID fromString: '{66e78b00-fbb7-4843-90a5-bd3e064e836d}')!
DBSchemaStatement comment: 'DBSchemaStatement is the class of Database Connection statements for querying metadata about the schema of a particular database. DBSchemaStatement itself is abstract, with subclasses implementing the commands for querying tables, columns, indices, procedures, primary and foreign key information, etc.'!
!DBSchemaStatement categoriesForClass!ODBC Interface! !
!DBSchemaStatement methodsFor!

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
!DBSchemaStatement categoriesFor: #catalogName!accessing!public!searching! !
!DBSchemaStatement categoriesFor: #catalogName:!accessing!public!searching! !
!DBSchemaStatement categoriesFor: #defaultCursorType!constants!public! !
!DBSchemaStatement categoriesFor: #schemaName!accessing!public!searching! !
!DBSchemaStatement categoriesFor: #schemaName:!accessing!public!searching! !
!DBSchemaStatement categoriesFor: #tableName!accessing!public!searching! !
!DBSchemaStatement categoriesFor: #tableName:!accessing!public!searching! !

