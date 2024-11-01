"Filed out from Dolphin Smalltalk"!

Database.DBSchemaStatement
	subclass: #'Database.DBForeignKeysStatement'
	instanceVariableNames: 'foreignCatalogName foreignSchemaName foreignTableName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBForeignKeysStatement guid: (Core.GUID fromString: '{b6f9e2f2-9df3-4719-ae44-5f079843683f}')!

Database.DBForeignKeysStatement comment: ''!

!Database.DBForeignKeysStatement categoriesForClass!ODBC Interface! !

!Database.DBForeignKeysStatement methodsFor!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^self dbCheckException: (OS.Odbc32
				sqlForeignKeys: self allocatedHandle
				pkCatalogName: self catalogName
				nameLength1: SQL_NTS
				pkSchemaName: self schemaName
				nameLength2: SQL_NTS
				pkTableName: self tableName
				nameLength3: SQL_NTS
				fkCatalogName: self foreignCatalogName
				nameLength4: SQL_NTS
				fkSchemaName: self foreignSchemaName
				nameLength5: SQL_NTS
				fkTableName: self foreignTableName
				nameLength6: SQL_NTS)
		function: 'SQLForeignKeys'!

foreignCatalogName
	^foreignCatalogName!

foreignCatalogName: patternString
	foreignCatalogName := patternString!

foreignSchemaName
	^foreignSchemaName!

foreignSchemaName: patternString
	foreignSchemaName := patternString!

foreignTableName
	^foreignTableName!

foreignTableName: aString
	foreignTableName := aString! !

!Database.DBForeignKeysStatement categoriesForMethods!
executeStatement!operations!private! !
foreignCatalogName!accessing!public! !
foreignCatalogName:!accessing!public! !
foreignSchemaName!accessing!public! !
foreignSchemaName:!accessing!public! !
foreignTableName!accessing!public! !
foreignTableName:!accessing!public! !
!

