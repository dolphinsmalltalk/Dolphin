"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #DBTest
	instanceVariableNames: 'connection dbResources'
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

dbName: aString 
	^aString!

employeeNames
	^#('Davolio' 'Fuller' 'Leverling' 'Peacock' 'Buchanan' 'Suyama' 'King' 'Callahan' 'Dodsworth')!

field: aString fromRow: aDBRow 
	^aDBRow at: aString!

freeDbResources
	dbResources do: [:each | [each free] on: Error do: [:ex | ex toTrace]].
	dbResources := OrderedCollection new!

newConnection
	^self databaseResource newConnection!

query: aString
	| resultSet |
	resultSet := connection query: aString.
	dbResources add: resultSet.
	^resultSet!

setUp
	super setUp.
	dbResources := OrderedCollection new.
	connection := self newConnection.
	self skipUnless: [connection notNil]!

tearDown
	connection
		ifNotNil: 
			[:cnxn |
			self freeDbResources.
			[cnxn close] on: Error do: [:ex | ex toTrace].
			connection := nil]!

testCollect
	| names rs |
	rs := self query: 'select <1s> from <2s>' << { self dbName: 'LastName'. self dbName: 'Employees' }.
	2 timesRepeat: 
			[names := rs collect: [:each | self field: 'LastName' fromRow: each].
			self assert: (names noDifference: self employeeNames)].
	rs := self query: 'select <1s> from <2s> where <1s>= ''Bower'''
						<< { self dbName: 'LastName'. self dbName: 'Employees' }.
	2 timesRepeat: 
			[names := rs collect: [:each | (each at: 1) value].
			self assert: names isEmpty]!

testIsEmpty
	| results identifiers |
	identifiers := #('Categories' 'CategoryID' 'CategoryName') collect: [:n | self dbName: n].
	results := connection query: 'select count(*) from <1s>' << identifiers.
	self deny: results isEmpty.
	results := connection query: 'select <2s>, <3s> from <1s> where <2s> is Null' << identifiers.
	self assert: results isEmpty.
	results := connection query: 'select <2s>, <3s> from <1s> where <2s> = 1' << identifiers.
	self deny: results isEmpty! !

!DBTest categoriesForMethods!
databaseResource!helpers!private! !
dbName:!helpers!private! !
employeeNames!helpers!private! !
field:fromRow:!helpers!private! !
freeDbResources!helpers!private! !
newConnection!public!running! !
query:!helpers!private! !
setUp!public!running! !
tearDown!public!running! !
testCollect!public!unit tests! !
testIsEmpty!public!unit tests! !
!

