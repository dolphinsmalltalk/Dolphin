"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DBTest
	instanceVariableNames: 'connection'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DBTest guid: (GUID fromString: '{B514FD7B-4E03-452F-8178-6EC50E9D670A}')!
DBTest comment: ''!
!DBTest categoriesForClass!Unclassified! !
!DBTest methodsFor!

connectString
"Private - 	^'DSN=NWindSQL'."
	^'DSN=NWind'!

employeeNames
	^#('Davolio' 'Fuller' 'Leverling' 'Peacock' 'Buchanan' 'Suyama' 'King' 'Callahan' 'Dodsworth')!

field: aString fromRow: aDBRow 
	^aDBRow at: aString!

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
!DBTest categoriesFor: #connectString!constants!private! !
!DBTest categoriesFor: #employeeNames!public!unit tests! !
!DBTest categoriesFor: #field:fromRow:!public!unit tests! !
!DBTest categoriesFor: #testCollect!public!unit tests! !
!DBTest categoriesFor: #testIsEmpty!public!unit tests! !

!DBTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!DBTest class categoriesFor: #isAbstract!public!Testing! !

