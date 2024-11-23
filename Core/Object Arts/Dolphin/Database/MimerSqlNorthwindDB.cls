"Filed out from Dolphin Smalltalk"!

DBConnectionTestResource subclass: #MimerSqlNorthwindDB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MimerSqlNorthwindDB guid: (GUID fromString: '{73e277a5-0b9a-4d94-b85a-5ba8ba6c38fc}')!

MimerSqlNorthwindDB comment: ''!

!MimerSqlNorthwindDB categoriesForClass!Unclassified! !

!MimerSqlNorthwindDB methodsFor!

connectString
	^'Driver= {MIMER};Database=Mimer;Uid=sysadm;Pwd=Password12!!'

!

createDatabase
	^self execSqlCmd: 'bsql -u <1s> -p <2s> <3s>' << { self uid. self pwd. 'Mimer' }
		stdin: (FileStream read: ((PackageRelativeFileLocator package: self class owningPackage)
						localFileSpecFor: 'NorthwindMimerSql.sql')
				text: true)!

dropDatabase
	self connection
		ifNotNil: 
			[:cnxn |
			#('DROP IDENT Northwind CASCADE' 'DROP DATABANK Northwind CASCADE')
				do: [:each | [cnxn exec: each] on: DBError do: [:ex | ex toTrace]]].
	super dropDatabase!

getOdbcDriver
	^'MIMER'!

prereqsAvailable
	^super prereqsAvailable and: [AdvApiLibrary default isServiceRunning: 'MIMER-Mimer']!

uid
	^'SYSADM'! !

!MimerSqlNorthwindDB categoriesForMethods!
connectString!constants!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
getOdbcDriver!constants!private! !
prereqsAvailable!operations!private! !
uid!constants!private! !
!

