"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #GenericDBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GenericDBTest guid: (GUID fromString: '{a77dad68-c606-49b9-8719-f34488d8989a}')!

GenericDBTest comment: ''!

!GenericDBTest categoriesForClass!Unclassified! !

!GenericDBTest methodsFor!

testConnectionString
	"#1284"

	| db |
	db := DBConnection new.
	db
		connectString: ';DSN=PostgreSQL30;DATABASE=money;SERVER=192.168.168.2;PORT=5432;UID=akira;PWD=;A6=;A7=100;A8=4096;B0=254;B1=8190;BI=0;C2=dd_;;CX=1a503ab;EMPTY='.
	self assert: db dsn = 'PostgreSQL30'.
	self assert: db pwd isEmpty.
	self assert: db uid = 'akira'

	"Attributes must be either empty, or contain a key=value pair"
	"self should: [db connectString: ';DSN;'] raise: Error"!

testConnectStringDo
	| pairs block |
	pairs := OrderedCollection new.
	block := 
			[:paramName :paramValue |
			pairs
				add: paramName;
				add: paramValue].
	DBConnection
		connectString: 'DRIVER={Microsoft Access Driver (*.mdb)};DBQ=c:\program files\microsoft office\office\samples\Northwind.mdb'
		do: block.
	self assert: pairs asArray
				= #('DRIVER' 'Microsoft Access Driver (*.mdb)' 'DBQ' 'c:\program files\microsoft office\office\samples\Northwind.mdb').
	pairs := OrderedCollection new.
	DBConnection
		connectString: ';;DRIVER={Microsoft Text Driver (*.txt; *.csv)};;DefaultDir=.;Dummy=;'
		do: block.
	self assert: pairs asArray
				= #('DRIVER' 'Microsoft Text Driver (*.txt; *.csv)' 'DefaultDir' '.' 'Dummy' '').
	pairs := OrderedCollection new.
	DBConnection
		connectString: ';DSN=PostgreSQL30;DATABASE=money;SERVER=192.168.168.2;PORT=5432;UID=akira;PWD=;A6=;A7=100;A8=4096;B0=254;B1=8190;BI=0;C2=dd_;;CX=1a503ab;EMPTY='
		do: block.
	self assert: pairs asArray
				= #('DSN' 'PostgreSQL30' 'DATABASE' 'money' 'SERVER' '192.168.168.2' 'PORT' '5432' 'UID' 'akira' 'PWD' '' 'A6' '' 'A7' '100' 'A8' '4096' 'B0' '254' 'B1' '8190' 'BI' '0' 'C2' 'dd_' 'CX' '1a503ab' 'EMPTY' '')!

testPackagesCorrectlySetUp
	"The base package should not be dependent upon the development system."

	self
		assert: ((Package manager packageNamed: 'Database Connection Base') prerequisites
				collect: [:each | each name]) asArray sort
		equals: #('Dolphin' 'Dolphin Legacy Date & Time' 'Dolphin Registry Access')! !

!GenericDBTest categoriesForMethods!
testConnectionString!public!unit tests! !
testConnectStringDo!public!unit tests! !
testPackagesCorrectlySetUp!public!unit tests! !
!

