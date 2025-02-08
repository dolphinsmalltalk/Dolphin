"Filed out from Dolphin Smalltalk"!

Database.Tests.DBConnectionTestResource
	subclass: #'Database.Tests.MimerSqlNorthwindDB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.MimerSqlNorthwindDB guid: (Core.GUID fromString: '{73e277a5-0b9a-4d94-b85a-5ba8ba6c38fc}')!

Database.Tests.MimerSqlNorthwindDB comment: ''!

!Database.Tests.MimerSqlNorthwindDB methodsFor!

connectString
	^'Driver= {MIMER};Database=Mimer;Uid=sysadm;Pwd=Password12!!'

!

createDatabase
	^self execSqlCmd: 'bsql -u <1s> -p <2s> <3s>' << { self uid. self pwd. 'Mimer' }
		stdin: (FileStream read: ((Kernel.PackageRelativeFileLocator package: self class owningPackage)
						localFileSpecFor: 'NorthwindMimerSql.sql')
				text: true)!

dropDatabase
	self connection
		ifNotNil: 
			[:cnxn |
			#('DROP IDENT Northwind CASCADE' 'DROP DATABANK Northwind CASCADE')
				do: [:each | [cnxn exec: each] on: Smalltalk.DBError do: [:ex | ex toTrace]]].
	super dropDatabase!

getOdbcDriver
	^'MIMER'!

prereqsAvailable
	^super prereqsAvailable and: [OS.AdvApi32 isServiceRunning: 'MIMER-Mimer']!

uid
	^'SYSADM'! !

!Database.Tests.MimerSqlNorthwindDB categoriesForMethods!
connectString!constants!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
getOdbcDriver!constants!private! !
prereqsAvailable!operations!private! !
uid!constants!private! !
!

