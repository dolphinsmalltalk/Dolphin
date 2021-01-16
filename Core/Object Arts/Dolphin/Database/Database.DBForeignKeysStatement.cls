"Filed out from Dolphin Smalltalk 7"!

DBSchemaStatement subclass: #DBForeignKeysStatement
	instanceVariableNames: 'foreignCatalogName foreignSchemaName foreignTableName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DBForeignKeysStatement guid: (GUID fromString: '{b6f9e2f2-9df3-4719-ae44-5f079843683f}')!
DBForeignKeysStatement comment: ''!
!DBForeignKeysStatement categoriesForClass!ODBC Interface! !
!DBForeignKeysStatement methodsFor!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^ODBCLibrary default 
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
		nameLength6: SQL_NTS!

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
!DBForeignKeysStatement categoriesFor: #executeStatement!operations!private! !
!DBForeignKeysStatement categoriesFor: #foreignCatalogName!accessing!public! !
!DBForeignKeysStatement categoriesFor: #foreignCatalogName:!accessing!public! !
!DBForeignKeysStatement categoriesFor: #foreignSchemaName!accessing!public! !
!DBForeignKeysStatement categoriesFor: #foreignSchemaName:!accessing!public! !
!DBForeignKeysStatement categoriesFor: #foreignTableName!accessing!public! !
!DBForeignKeysStatement categoriesFor: #foreignTableName:!accessing!public! !

