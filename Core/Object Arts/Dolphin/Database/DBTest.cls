"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #DBTest
	instanceVariableNames: 'connection'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
DBTest guid: (Core.GUID fromString: '{13e9a82d-7aae-43aa-864a-a15706b23ae3}')!
DBTest isNonInstantiable: true!
DBTest comment: ''!
!DBTest categoriesForClass!Unclassified! !
!DBTest methodsFor!

databaseResource
	^AccessNorthwindDB current !

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
!DBTest categoriesFor: #databaseResource!helpers!private! !
!DBTest categoriesFor: #employeeNames!helpers!private! !
!DBTest categoriesFor: #field:fromRow:!helpers!private! !
!DBTest categoriesFor: #setUp!public!running! !
!DBTest categoriesFor: #tearDown!public!running! !
!DBTest categoriesFor: #testCollect!public!unit tests! !
!DBTest categoriesFor: #testIsEmpty!public!unit tests! !

