"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #DBTest
	instanceVariableNames: 'connection'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBTest guid: (GUID fromString: '{13e9a82d-7aae-43aa-864a-a15706b23ae3}')!

DBTest isAbstract: true!

DBTest comment: ''!

!DBTest categoriesForClass!Unclassified! !

!DBTest methodsFor!

databaseResource
	^AccessNorthwindDB current !

employeeNames
	^#('Davolio' 'Fuller' 'Leverling' 'Peacock' 'Buchanan' 'Suyama' 'King' 'Callahan' 'Dodsworth')!

field: aString fromRow: aDBRow 
	^aDBRow at: aString!

newConnection
	^self databaseResource newConnection!

setUp
	super setUp.
	connection := self newConnection.
	self skipUnless: [connection notNil]!

tearDown
	connection
		ifNotNil: 
			[:cnxn |
			connection close.
			connection := nil]!

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

!DBTest categoriesForMethods!
databaseResource!helpers!private! !
employeeNames!helpers!private! !
field:fromRow:!helpers!private! !
newConnection!public!running! !
setUp!public!running! !
tearDown!public!running! !
testCollect!public!unit tests! !
testIsEmpty!public!unit tests! !
!

