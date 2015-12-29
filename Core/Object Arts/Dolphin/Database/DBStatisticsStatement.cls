"Filed out from Dolphin Smalltalk X6"!

DBSchemaStatement subclass: #DBStatisticsStatement
	instanceVariableNames: 'type accurate'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DBStatisticsStatement guid: (GUID fromString: '{F9A75139-7D9A-4FBA-8C1A-249CC03FF080}')!
DBStatisticsStatement comment: 'DBTablesStatement is a specialized <DBSchemaStatement> for querying about the indices of tables in a database.'!
!DBStatisticsStatement categoriesForClass!ODBC Interface! !
!DBStatisticsStatement methodsFor!

accurate
	^accurate!

accurate: aBoolean
	accurate := aBoolean!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^ODBCLibrary default 
		sqlStatistics: self allocatedHandle
		catalogName: self catalogName
		nameLength1: SQL_NTS
		schemaName: self schemaName
		nameLength2: SQL_NTS
		tableName: self tableName
		nameLength3: SQL_NTS
		unique: self type
		reserved: (accurate ifTrue: [SQL_ENSURE] ifFalse: [SQL_QUICK])!

initialize: aDBConnection 
	"Private - Initialize the receiver as a new statement of the
	<DBConnection>, aDBConnection."

	super initialize: aDBConnection.
	type := SQL_INDEX_ALL.
	accurate := false!

type
	^type!

type: statisticsTypeInteger
	type := statisticsTypeInteger!

unique: aBoolean 
	self type: (aBoolean ifTrue: [SQL_INDEX_UNIQUE] ifFalse: [SQL_INDEX_ALL])! !
!DBStatisticsStatement categoriesFor: #accurate!accessing!public! !
!DBStatisticsStatement categoriesFor: #accurate:!accessing!public! !
!DBStatisticsStatement categoriesFor: #executeStatement!operations!private! !
!DBStatisticsStatement categoriesFor: #initialize:!initializing!private!searching! !
!DBStatisticsStatement categoriesFor: #type!accessing!public! !
!DBStatisticsStatement categoriesFor: #type:!accessing!public! !
!DBStatisticsStatement categoriesFor: #unique:!accessing!public! !

