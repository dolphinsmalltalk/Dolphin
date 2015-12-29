"Filed out from Dolphin Smalltalk X6"!

DBSchemaStatement subclass: #DBSpecialColumnsStatement
	instanceVariableNames: 'columnType scope nullable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DBSpecialColumnsStatement guid: (GUID fromString: '{11E39B07-10D8-43B0-8A5C-43C2EECF5EB9}')!
DBSpecialColumnsStatement comment: ''!
!DBSpecialColumnsStatement categoriesForClass!ODBC Interface! !
!DBSpecialColumnsStatement methodsFor!

columnType
	^columnType!

columnType: anInteger
	columnType := anInteger!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^ODBCLibrary default 
		sqlSpecialColumns: self allocatedHandle
		identifierType: self columnType
		catalogName: self catalogName
		nameLength1: SQL_NTS
		schemaName: self schemaName
		nameLength2: SQL_NTS
		tableName: self tableName
		nameLength3: SQL_NTS
		scope: self scope
		nullable: (self nullable ifTrue: [SQL_NULLABLE] ifFalse: [SQL_NO_NULLS])!

nullable
	^nullable!

nullable: aBoolean
	nullable := aBoolean!

scope
	^scope!

scope: anInteger
	scope := anInteger! !
!DBSpecialColumnsStatement categoriesFor: #columnType!accessing!public! !
!DBSpecialColumnsStatement categoriesFor: #columnType:!accessing!public! !
!DBSpecialColumnsStatement categoriesFor: #executeStatement!operations!private! !
!DBSpecialColumnsStatement categoriesFor: #nullable!accessing!public! !
!DBSpecialColumnsStatement categoriesFor: #nullable:!accessing!public! !
!DBSpecialColumnsStatement categoriesFor: #scope!accessing!public! !
!DBSpecialColumnsStatement categoriesFor: #scope:!accessing!public! !

