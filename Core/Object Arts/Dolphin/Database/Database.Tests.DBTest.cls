"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Database.Tests.DBTest'
	instanceVariableNames: 'connection'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.Tests.DBTest guid: (Core.GUID fromString: '{13e9a82d-7aae-43aa-864a-a15706b23ae3}')!
Database.Tests.DBTest isNonInstantiable: true!
Database.Tests.DBTest comment: ''!
!Database.Tests.DBTest categoriesForClass!Unclassified! !
!Database.Tests.DBTest methodsFor!

databaseResource
	^AccessNorthwindDB current!

employeeNames
	^#('Davolio' 'Fuller' 'Leverling' 'Peacock' 'Buchanan' 'Suyama' 'King' 'Callahan' 'Dodsworth')!

field: aString fromRow: aDBRow 
	^aDBRow at: aString!

setUp
	connection := self databaseResource newConnection.
	self skipUnless: [connection notNil]!

tearDown
	connection ifNotNil: [:cnxn | cnxn close]!

testCollect
	| names rs |
	rs := connection query: 'select LastName from employees'.
	2 timesRepeat: 
			[names := rs collect: [:each | self field: 'LastName' fromRow: each].
			self assert: (names noDifference: self employeeNames)].
	rs := connection query: 'select LastName from employees where LastName = ''Bower'''.
	2 timesRepeat: 
			[names := rs collect: [:each | (each at: 1) value].
			self assert: names isEmpty]!

testIsEmpty
	| results |
	results := connection query: 'select count(*) from categories'.
	self deny: results isEmpty.
	results := connection 
				query: 'select CategoryID, CategoryName from categories where CategoryID is Null'.
	self assert: results isEmpty.
	results := connection query: 'select CategoryID, CategoryName from categories where CategoryID = 1'.
	self deny: results isEmpty! !
!Database.Tests.DBTest categoriesFor: #databaseResource!helpers!private! !
!Database.Tests.DBTest categoriesFor: #employeeNames!helpers!private! !
!Database.Tests.DBTest categoriesFor: #field:fromRow:!helpers!private! !
!Database.Tests.DBTest categoriesFor: #setUp!public!running! !
!Database.Tests.DBTest categoriesFor: #tearDown!public!running! !
!Database.Tests.DBTest categoriesFor: #testCollect!public!unit tests! !
!Database.Tests.DBTest categoriesFor: #testIsEmpty!public!unit tests! !

