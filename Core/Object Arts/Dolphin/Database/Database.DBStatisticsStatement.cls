﻿"Filed out from Dolphin Smalltalk"!

Database.DBSchemaStatement
	subclass: #'Database.DBStatisticsStatement'
	instanceVariableNames: 'type accurate'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBStatisticsStatement guid: (Core.GUID fromString: '{f9a75139-7d9a-4fba-8c1a-249cc03ff080}')!

Database.DBStatisticsStatement comment: 'DBTablesStatement is a specialized <DBSchemaStatement> for querying about the indices of tables in a database.'!

!Database.DBStatisticsStatement categoriesForClass!ODBC Interface! !

!Database.DBStatisticsStatement methodsFor!

accurate
	^accurate!

accurate: aBoolean
	accurate := aBoolean!

executeStatement
	"Private - Execute the database command that the receiver represents.
	Answer the <integer> return code."

	^self dbCheckException: (OS.Odbc32
				sqlStatistics: self allocatedHandle
				catalogName: self catalogName
				nameLength1: SQL_NTS
				schemaName: self schemaName
				nameLength2: SQL_NTS
				tableName: self tableName
				nameLength3: SQL_NTS
				unique: self type
				reserved: (accurate ifTrue: [SQL_ENSURE] ifFalse: [SQL_QUICK]))
		function: 'SQLStatistics'!

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

!Database.DBStatisticsStatement categoriesForMethods!
accurate!accessing!public! !
accurate:!accessing!public! !
executeStatement!operations!private! !
initialize:!initializing!private!searching! !
type!accessing!public! !
type:!accessing!public! !
unique:!accessing!public! !
!

