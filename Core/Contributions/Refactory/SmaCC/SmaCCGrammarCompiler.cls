"Filed out from Dolphin Smalltalk XP"!

Object subclass: #SmaCCGrammarCompiler
	instanceVariableNames: 'shiftTable itemSets startingStateMap actions parserClass parserDefinitionString scannerCompiler grammar model'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCGrammarCompiler guid: (GUID fromString: '{BE83A240-2E9E-45CA-85A6-874BC2F9F5D9}')!
SmaCCGrammarCompiler comment: 'SmaCCGrammarCompiler compiles a SmaCCGrammar.

Instance Variables:
	actions	<Array>	the action table for the parser. It contains the action (shift/reduce/accept/reject) for each possible state/symbol pair
	grammar	<SmaCCGrammar>	our grammar
	itemSets	<SequenceableCollection of: SmaCCItemSet>	the item sets for our grammar
	model	<RBNameSpace>	where we are compiling our changes into
	parserClass	<RBAbstractClass>	the parser class for our changes
	parserDefinitionString	<String>	the definition of our parser
	scannerCompiler	<SmaCCScannerCompiler>	a compiler for the scanner
	shiftTable	<Dictionary key: (Array with: Integer with: SmaCCSymbol) value: Integer>	a table mapping a state/symbol pair to the new state that is aquired by shifting the symbol
	startingStateMap	<Dictionary key: SmaCCSymbol value: Integer>	the state for SmaCCSymbol''s starting item set

'!
!SmaCCGrammarCompiler categoriesForClass!SmaCC Runtime! !
!SmaCCGrammarCompiler methodsFor!

actionForState: anInteger on: aGrammarSymbol 
	| action newStateIndex |
	action := (itemSets at: anInteger) action: aGrammarSymbol
				prefer: (grammar preferredActionFor: aGrammarSymbol).
	action isShift 
		ifTrue: 
			[newStateIndex := shiftTable 
						at: (Array with: anInteger with: aGrammarSymbol).
			^(newStateIndex bitShift: 2) + action id].
	action isReduce 
		ifTrue: 
			[^((grammar reduceTableIndexFor: action symbol rhs: action rhs) 
				bitShift: 2) + action id].
	^action id!

buildScanner: scannerString andParser: parserString 
	| parser |
	scannerCompiler grammar: self grammar.
	scannerCompiler scannerDefinitionString: scannerString.
	parserDefinitionString := parserString.
	scannerCompiler parseTokens.
	parser := SmaCCGrammarParser on: (ReadStream on: parserString).
	parser grammar: grammar.
	parser parse!

changes
	^model changes!

checkForEmptySymbols
	| problemSymbols stream |
	problemSymbols := grammar emptySymbols.
	problemSymbols isEmpty ifTrue: [^self].
	stream := WriteStream on: String new.
	problemSymbols do: [:each | stream nextPutAll: each printString]
		separatedBy: [stream space].
	SmaCCCompilationNotification signal: 'Missing non-terminal productions'
		with: stream contents!

checkForUnusedSymbols
	| problemSymbols stream |
	problemSymbols := grammar unusedSymbols.
	problemSymbols isEmpty ifTrue: [^self].
	stream := WriteStream on: String new.
	problemSymbols do: [:each | stream nextPutAll: each printString]
		separatedBy: [stream space].
	SmaCCCompilationNotification signal: 'Unused non-terminal symbols' with: stream contents!

compileChanges
	RefactoryChangeManager instance performChange: self changes.
	scannerCompiler scannerClass realClass ifNotNil: [:each | each initializeKeywordMap]!

compileDefinitionComments
	scannerCompiler compileScannerDefinitionComment.
	self compileParserDefinitionComment!

compileInto: sClass andParser: pClass 
	self scannerClass: sClass.
	self parserClass: pClass.
	self createChanges.
	self compileChanges!

compileItemSetsComment
	| stream |
	stream := WriteStream on: (String new: 1000).
	stream
		nextPutAll: 'itemSetsComment';
		cr;
		cr;
		tab;
		nextPut: $";
		cr.
	(1 to: itemSets size) with: itemSets
		do: 
			[:index :each | 
			stream
				nextPutAll: index printString;
				nextPutAll: (each printString copyReplaceAll: '"' with: '""');
				cr].
	stream nextPut: $".
	self parserClass metaclass compile: stream contents
		classified: #'generated-comments'!

compileParser
	self compileTransitionTable.
	self compileStartingStateIds.
	self compileReductionTable.
	self compileScannerClassIntoParser!

compileParserDefinitionComment
	| stream |
	stream := WriteStream on: (String new: 1000).
	stream
		nextPutAll: 'parserDefinitionComment';
		cr;
		cr;
		tab;
		nextPut: $";
		nextPutAll: (parserDefinitionString copyReplaceAll: '"'
					with: '""');
		nextPut: $".
	parserClass metaclass compile: stream contents
		classified: #'generated-comments'!

compileReductionTable
	| stream |
	stream := WriteStream on: (String new: 1000).
	stream
		nextPutAll: 'reduceTable';
		cr;
		tab;
		nextPutAll: '^#(';
		cr.
	self reduceTable do: 
			[:each | 
			stream nextPutAll: '#('.
			each do: [:e | stream nextPutAll: e storeString]
				separatedBy: [stream space].
			stream
				nextPut: $);
				cr].
	stream nextPut: $).
	parserClass compile: stream contents classified: #'generated-tables'!

compileScannerClassIntoParser
	| stream |
	stream := WriteStream on: (String new: 1000).
	stream
		nextPutAll: 'scannerClass';
		cr;
		tab;
		nextPutAll: '^';
		nextPutAll: scannerCompiler scannerClass name.
	self parserClass metaclass compile: stream contents classified: #'generated-accessing'!

compileStartingStateIds
	startingStateMap keysAndValuesDo: 
			[:symbol :position | 
			| stream |
			stream := WriteStream on: (String new: 1000).
			stream
				nextPutAll: 'startingStateFor';
				nextPutAll: symbol compileName;
				cr;
				tab;
				nextPutAll: '^';
				nextPutAll: position printString.
			parserClass metaclass compile: stream contents
				classified: #'generated-starting states']!

compileSymbolComment
	| stream |
	stream := WriteStream on: (String new: 1000).
	stream
		nextPutAll: 'symbolComment';
		cr;
		cr;
		tab;
		nextPut: $";
		cr.
	(1 to: scannerCompiler symbols size) with: scannerCompiler symbols
		do: 
			[:index :each | 
			stream
				nextPutAll: index printString;
				nextPutAll: '. ';
				nextPutAll: (each printString copyReplaceAll: '"' with: '""');
				cr].
	stream nextPut: $".
	self parserClass metaclass compile: stream contents
		classified: #'generated-comments'!

compileTransitionTable
	| stream |
	stream := WriteStream on: (String new: 1000).
	stream
		nextPutAll: 'transitionTable';
		cr;
		tab;
		nextPutAll: '^#(';
		cr.
	self transitionTable do: 
			[:each | 
			stream nextPutAll: '#['.
			each do: [:byte | stream nextPutAll: byte printString]
				separatedBy: [stream nextPut: $ ].
			stream
				nextPut: $];
				cr].
	stream nextPut: $).
	parserClass compile: stream contents classified: #'generated-tables'!

compressTable: table 
	^table collect: 
			[:row | 
			| stream uniqueItems |
			stream := WriteStream on: ByteArray new.
			uniqueItems := (row asSet)
						remove: 3 ifAbsent: [];
						asArray.
			uniqueItems size = 1 
				ifTrue: 
					[stream nextPut: 0.
					stream
						nextPut: (uniqueItems first bitShift: -8);
						nextPut: (uniqueItems first bitAnd: 16rFF).
					(1 to: row size) with: row
						do: 
							[:index :each | 
							each ~~ 3 
								ifTrue: 
									[stream
										nextPut: (index bitShift: -8);
										nextPut: (index bitAnd: 16rFF)]]]
				ifFalse: 
					[stream nextPut: 1.
					(1 to: row size) with: row
						do: 
							[:index :each | 
							each ~~ 3 
								ifTrue: 
									[stream
										nextPut: (each bitShift: -8);
										nextPut: (each bitAnd: 16rFF);
										nextPut: (index bitShift: -8);
										nextPut: (index bitAnd: 16rFF)]]].
			stream contents]!

createChanges
	self removeOldMethods.
	self checkForEmptySymbols.
	self checkForUnusedSymbols.
	scannerCompiler compileScanner.
	self compileParser!

createItemSets
	| itemSet newState index |
	startingStateMap := Dictionary new.
	grammar calculateFirstSets.
	itemSets := OrderedCollection new.
	grammar allStartingSymbols do: 
			[:each | 
			itemSets add: (grammar initialItemSetFor: each).
			startingStateMap at: each put: itemSets size].
	shiftTable := Dictionary new.
	index := 1.
	[index <= itemSets size] whileTrue: 
			[itemSet := itemSets at: index.
			grammar symbols do: 
					[:each | 
					newState := itemSet moveOn: each.
					newState notEmpty 
						ifTrue: 
							[shiftTable at: (Array with: index with: each)
								put: (self indexOfState: newState)]].
			index := index + 1]!

createTransitionTable
	| table |
	table := OrderedCollection new.
	(1 to: itemSets size) with: itemSets
		do: 
			[:index :each | 
			table add: ((1 to: scannerCompiler symbols size) 
						collect: [:i | self actionForState: index on: (scannerCompiler symbols at: i)])].
	actions := self compressTable: table!

defineClass: aString asSubclassOf: aBehavior
	model defineClass: aBehavior name , ' subclass: #' , aString 
				, ' instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' '.
	^model classNamed: aString asSymbol!

grammar
	^grammar isNil ifTrue: [grammar := SmaCCGrammar new] ifFalse: [grammar]!

indexOfState: newState 
	| newStateIndex |
	newStateIndex := itemSets indexOf: newState.
	newStateIndex == 0 
		ifTrue: 
			[itemSets add: newState.
			newStateIndex := itemSets size]
		ifFalse: [(itemSets at: newStateIndex) mergeWith: newState].
	^newStateIndex!

initialize
	scannerCompiler := SmaCCScannerCompiler new.
	model := (RBNamespace new)
				name: 'Compile Scanner/Parser';
				yourself.
	startingStateMap := Dictionary new!

parserClass
	^parserClass!

parserClass: aClassOrString
	(aClassOrString isKindOf: Behavior) 
		ifTrue: [parserClass := model classFor: aClassOrString]
		ifFalse: 
			[parserClass := model classNamed: aClassOrString.
			parserClass isNil 
				ifTrue: [parserClass := self defineClass: aClassOrString asSubclassOf: SmaCCParser]]!

reduceTable
	| table |
	table := OrderedCollection new.
	scannerCompiler symbols do: 
			[:each | 
			each isTerminal 
				ifFalse: 
					[each productionsDo: 
							[:rhs | 
							table add: (Array 
										with: (scannerCompiler symbols indexOf: each)
										with: rhs size
										with: (rhs compileSourceFor: each in: parserClass))]]].
	^table!

removeOldMethods
	self
		removeOldMethodsFrom: scannerCompiler scannerClass;
		removeOldMethodsFrom: scannerCompiler scannerClass metaclass;
		removeOldMethodsFrom: parserClass;
		removeOldMethodsFrom: parserClass metaclass!

removeOldMethodsFrom: aRBClass 
	(aRBClass selectors select: 
			[:each | 
			(aRBClass protocolsFor: each) 
				allSatisfy: [:protocol | protocol notNil and: ['generated*' match: protocol]]]) 
		do: [:each | aRBClass removeMethod: each]!

scannerClass: aClassOrString
	(aClassOrString isKindOf: Behavior) 
		ifTrue: [scannerCompiler scannerClass: (model classFor: aClassOrString)]
		ifFalse: 
			[scannerCompiler scannerClass: (model classNamed: aClassOrString).
			scannerCompiler scannerClass isNil 
				ifTrue: 
					[scannerCompiler 
						scannerClass: (self defineClass: aClassOrString asSubclassOf: SmaCCScanner)]]!

transitionTable
	actions isNil 
		ifTrue: 
			[self createItemSets.
			self createTransitionTable].
	^actions! !
!SmaCCGrammarCompiler categoriesFor: #actionForState:on:!action table!public! !
!SmaCCGrammarCompiler categoriesFor: #buildScanner:andParser:!initialize-release!public! !
!SmaCCGrammarCompiler categoriesFor: #changes!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #checkForEmptySymbols!private! !
!SmaCCGrammarCompiler categoriesFor: #checkForUnusedSymbols!private! !
!SmaCCGrammarCompiler categoriesFor: #compileChanges!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compileDefinitionComments!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compileInto:andParser:!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compileItemSetsComment!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compileParser!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compileParserDefinitionComment!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compileReductionTable!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compileScannerClassIntoParser!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compileStartingStateIds!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compileSymbolComment!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compileTransitionTable!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #compressTable:!action table!public! !
!SmaCCGrammarCompiler categoriesFor: #createChanges!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #createItemSets!action table!public! !
!SmaCCGrammarCompiler categoriesFor: #createTransitionTable!action table!public! !
!SmaCCGrammarCompiler categoriesFor: #defineClass:asSubclassOf:!compiling!public! !
!SmaCCGrammarCompiler categoriesFor: #grammar!accessing!public! !
!SmaCCGrammarCompiler categoriesFor: #indexOfState:!action table!public! !
!SmaCCGrammarCompiler categoriesFor: #initialize!initialize-release!public! !
!SmaCCGrammarCompiler categoriesFor: #parserClass!accessing!public! !
!SmaCCGrammarCompiler categoriesFor: #parserClass:!accessing!public! !
!SmaCCGrammarCompiler categoriesFor: #reduceTable!public!reduction table! !
!SmaCCGrammarCompiler categoriesFor: #removeOldMethods!private! !
!SmaCCGrammarCompiler categoriesFor: #removeOldMethodsFrom:!private! !
!SmaCCGrammarCompiler categoriesFor: #scannerClass:!accessing!public! !
!SmaCCGrammarCompiler categoriesFor: #transitionTable!action table!public! !

!SmaCCGrammarCompiler class methodsFor!

new
	^self basicNew initialize! !
!SmaCCGrammarCompiler class categoriesFor: #new!instance creation!public! !

