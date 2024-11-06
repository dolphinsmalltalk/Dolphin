"Filed out from Dolphin Smalltalk"!

Database.Tests.DBConnectionTestResource
	subclass: #'Database.Tests.OracleNorthwindDB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.OracleNorthwindDB guid: (Core.GUID fromString: '{0e68749f-554a-45d1-916c-e44eae7b2cb6}')!

Database.Tests.OracleNorthwindDB comment: ''!

!Database.Tests.OracleNorthwindDB methodsFor!

connectString
	^'DSN=Oracle;PWD=<1s>' << self pwd

!

createDatabase
	| sqlFile |
	(OS.AdvApiLibrary default isServiceRunning: 'OracleServiceFREE') ifFalse: [^false].
	sqlFile := (Kernel.PackageRelativeFileLocator package: self class owningPackage)
				localFileSpecFor: 'NorthwindOracle.sql'.
	"N.B. Obviously storing a password in a method and passing it on a command line is insecure, but this is a test database"
	^self execSqlCmd: 'sqlplus <2s>/<3s> @"<1s>"' << { sqlFile. self uid. self pwd } stdin: nil!

dropDatabase
	self connection
		ifNotNil: 
			[:cnxn |
			Notification signal: 'Dropping Oracle Northwind tables'.
			#('OrderDetails' 'Orders' 'CustomerCustomerDemo' 'CustomerDemographics' 'EmployeeTerritories' 'Employees' 'Customers' 'Shippers' 'Products' 'Suppliers' 'Categories' 'Territories' 'Region')
				do: [:each | [cnxn exec: 'DROP TABLE <1s>' << each] on: Smalltalk.DBError do: [:ex | ex toTrace]]].
	super dropDatabase!

uid
	^'system'! !

!Database.Tests.OracleNorthwindDB categoriesForMethods!
connectString!constants!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
uid!constants!public! !
!

