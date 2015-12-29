"Filed out from Dolphin Smalltalk XP"!

Object subclass: #SmaCCGrammar
	instanceVariableNames: 'type shiftReduceTable symbols tokens otherStartingSymbols'
	classVariableNames: 'IgnoreCase MaximumCharacterValue'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCGrammar guid: (GUID fromString: '{673008FD-D28C-4EA1-AB7B-F1CDCBC5E855}')!
SmaCCGrammar comment: 'SmaCCGrammar represents a LR(1) or a LALR(1) grammar.

Instance Variables:
	otherStartingSymbols	<Collection of: SmaCCSymbol>	other starting productions. The first production in the grammar is the defaulting starting position, but this can list other starting positions.
	shiftReduceTable	<Dictionary key: SmaCCSymbol value: SmaCCAction class>	when we have a shift/reduce conflict how should we handle it. This table contains the left/right associative rules. Left is a reduce action and right is a shift action.
	symbols	<OrderedCollection of: SmaCCSymbol>	all symbols in our grammar -- includes both terminal and non-terminal
	tokens	<Dictionary key: String value: SmaCCRegularExpressionNode>	the tokens for our scanner
	type	<Symbol>	the type of grammar (LALR1 or LR1)

'!
!SmaCCGrammar categoriesForClass!SmaCC Runtime! !
!SmaCCGrammar methodsFor!

addEmptySymbol
	self addSymbol: SmaCCSymbol empty.
	self addSymbol: SmaCCSymbol error!

addStartingSymbol: aSymbol 
	(otherStartingSymbols includes: aSymbol) 
		ifFalse: [otherStartingSymbols add: aSymbol]!

addSymbol: aGrammarSymbol 
	^symbols add: aGrammarSymbol!

allStartingSymbols
	"Return all starting symbols with the default starting symbol listed first."

	| startingSymbols default |
	default := self startSymbol.
	startingSymbols := otherStartingSymbols copy.
	startingSymbols remove: default ifAbsent: [].
	startingSymbols := startingSymbols collect: 
					[:each | 
					(SmaCCStartingSymbol name: 'B e g i n' , each name)
						addProduction: ((SmaCCRHS new)
									add: each;
									yourself);
						yourself].
	startingSymbols addFirst: default.
	^startingSymbols!

calculateFirstSets
	| changed |
	changed := true.
	[changed] whileTrue: 
			[changed := false.
			self symbols 
				do: [:each | changed := changed | each calculateFirstTerminals]]!

emptySymbols
	^self symbols select: [:each | each isTerminal not and: [each isEmpty]]!

initialItemSetFor: aSymbol 
	^(aSymbol asLRItemSet)
		type: type;
		yourself!

initialize
	type := #LALR1.
	symbols := OrderedCollection new.
	shiftReduceTable := Dictionary new.
	otherStartingSymbols := OrderedCollection new!

keywordTerminalNamed: aString 
	^symbols detect: [:each | each name = aString]
		ifNone: 
			[symbols addFirst: ((SmaCCTerminalSymbol name: aString)
						regularExpression: (((aString copyFrom: 2 to: aString size - 1) 
									copyReplaceAll: '""'
									with: '"') inject: nil
										into: 
											[:sum :each | 
											sum isNil 
												ifTrue: [SmaCCCharacterRENode characters: (String with: each)]
												ifFalse: [sum , (SmaCCCharacterRENode characters: (String with: each))]]);
						yourself)]!

leftPrecedenceFor: aGrammarSymbol 
	shiftReduceTable at: aGrammarSymbol put: SmaCCReduceAction!

makeGroupFor: aRHSCollection 
	| symbol name |
	name := aRHSCollection inject: ''
				into: [:sum :each | sum , ' | ' , each printString].
	symbol := self nonTerminalSymbolNamed: 'Group: ' , name.
	symbol isEmpty 
		ifTrue: 
			[(aRHSCollection allSatisfy: [:each | each size = 1]) 
				ifTrue: [aRHSCollection do: [:each | each reduceAction: '''1''']].
			aRHSCollection do: [:each | symbol addProduction: each]].
	^symbol!

makeOptionalSymbolFor: aSymbol 
	| symbol |
	symbol := self nonTerminalSymbolNamed: 'Optional: ' , aSymbol printString.
	symbol isEmpty 
		ifTrue: 
			[symbol
				addProduction: ((SmaCCRHS new)
							reduceAction: 'nil';
							yourself);
				addProduction: ((SmaCCRHS new)
							add: aSymbol;
							reduceAction: '''1''';
							yourself)].
	^symbol!

makeRepeatMultipleSymbolFor: aSymbol 
	| symbol |
	symbol := self 
				nonTerminalSymbolNamed: 'Repeat Multiple: ' , aSymbol printString.
	symbol isEmpty 
		ifTrue: 
			[symbol
				addProduction: ((SmaCCRHS new)
							add: aSymbol;
							reduceAction: 'OrderedCollection with: ''1''';
							yourself);
				addProduction: ((SmaCCRHS new)
							add: symbol;
							add: aSymbol;
							reduceAction: '''1'' add: ''2''; yourself';
							yourself)].
	^symbol!

makeRepeatSymbolFor: aSymbol 
	| symbol |
	symbol := self nonTerminalSymbolNamed: 'Repeat: ' , aSymbol printString.
	symbol isEmpty 
		ifTrue: 
			[symbol
				addProduction: ((SmaCCRHS new)
							reduceAction: 'OrderedCollection new';
							yourself);
				addProduction: ((SmaCCRHS new)
							add: symbol;
							add: aSymbol;
							reduceAction: '''1'' add: ''2''; yourself';
							yourself)].
	^symbol!

makeTokenIdMethodFor: aString 
	| token |
	token := (tokens includesKey: aString) 
				ifTrue: [self terminalSymbolNamed: aString]
				ifFalse: 
					[symbols detect: [:each | each name = aString]
						ifNone: [symbols add: (SmaCCTerminalSymbol name: aString)]].
	token createIdMethod: true!

nonAssociativePrecedenceFor: aGrammarSymbol 
	shiftReduceTable at: aGrammarSymbol put: SmaCCRejectAction!

nonTerminalSymbolNamed: aString 
	^symbols detect: [:each | each name = aString]
		ifNone: [self addSymbol: (SmaCCNonTerminalSymbol name: aString)]!

preferredActionFor: aGrammarSymbol 
	^shiftReduceTable at: aGrammarSymbol ifAbsent: [nil]!

reduceTableIndexFor: aGrammarSymbol rhs: aRHS 
	| index |
	index := 0.
	self symbols do: 
			[:each | 
			each = aGrammarSymbol ifTrue: [^index + (each positionOf: aRHS)].
			index := index + each size].
	^0!

rightPrecedenceFor: aGrammarSymbol 
	shiftReduceTable at: aGrammarSymbol put: SmaCCShiftAction!

setOperatorPrecedenceFor: aGrammarSymbol to: anInteger
	aGrammarSymbol precedence: anInteger!

setStartSymbolIfNone: aGrammarSymbol 
	| startSymbol |
	self startSymbol notNil ifTrue: [^self].
	startSymbol := SmaCCStartingSymbol name: 'B e g i n'.
	self addSymbol: startSymbol.
	startSymbol addProduction: ((SmaCCRHS new)
				add: aGrammarSymbol;
				yourself)!

startSymbol
	^symbols detect: [:each | each isStartingSymbol] ifNone: [nil]!

symbols
	^symbols!

symbols: aCollection
	symbols := aCollection!

terminalSymbolNamed: aString 
	^symbols detect: [:each | each name = aString]
		ifNone: 
			[symbols add: ((SmaCCTerminalSymbol name: aString)
						regularExpression: (tokens at: aString);
						yourself)]!

terminalSymbolNamed: aString ifAbsent: aBlock 
	^symbols detect: [:each | each name = aString]
		ifNone: 
			[symbols add: ((SmaCCTerminalSymbol name: aString)
						regularExpression: (tokens at: aString ifAbsent: [^aBlock value]);
						yourself)]!

tokens
	^tokens!

tokens: aCollection
	tokens := aCollection!

type: aSymbol
	type := aSymbol!

unusedSymbols
	| nonTerminals problemSymbols todo symbol |
	nonTerminals := self symbols reject: [:each | each isTerminal].
	problemSymbols := nonTerminals asSet.
	problemSymbols remove: self startSymbol.
	todo := OrderedCollection with: self startSymbol.
	[todo isEmpty] whileFalse: 
			[symbol := todo removeFirst.
			symbol productionsDo: 
					[:rhs | 
					rhs do: 
							[:each | 
							each isTerminal 
								ifFalse: 
									[(problemSymbols includes: each) 
										ifTrue: 
											[todo add: each.
											problemSymbols remove: each]]]]].
	^problemSymbols! !
!SmaCCGrammar categoriesFor: #addEmptySymbol!accessing!public! !
!SmaCCGrammar categoriesFor: #addStartingSymbol:!accessing!public! !
!SmaCCGrammar categoriesFor: #addSymbol:!private! !
!SmaCCGrammar categoriesFor: #allStartingSymbols!accessing!public! !
!SmaCCGrammar categoriesFor: #calculateFirstSets!private! !
!SmaCCGrammar categoriesFor: #emptySymbols!accessing!public! !
!SmaCCGrammar categoriesFor: #initialItemSetFor:!accessing!public! !
!SmaCCGrammar categoriesFor: #initialize!initialize-release!public! !
!SmaCCGrammar categoriesFor: #keywordTerminalNamed:!private! !
!SmaCCGrammar categoriesFor: #leftPrecedenceFor:!precedence!public! !
!SmaCCGrammar categoriesFor: #makeGroupFor:!accessing!public! !
!SmaCCGrammar categoriesFor: #makeOptionalSymbolFor:!accessing!public! !
!SmaCCGrammar categoriesFor: #makeRepeatMultipleSymbolFor:!accessing!public! !
!SmaCCGrammar categoriesFor: #makeRepeatSymbolFor:!accessing!public! !
!SmaCCGrammar categoriesFor: #makeTokenIdMethodFor:!accessing!public! !
!SmaCCGrammar categoriesFor: #nonAssociativePrecedenceFor:!precedence!public! !
!SmaCCGrammar categoriesFor: #nonTerminalSymbolNamed:!private! !
!SmaCCGrammar categoriesFor: #preferredActionFor:!accessing!public! !
!SmaCCGrammar categoriesFor: #reduceTableIndexFor:rhs:!private! !
!SmaCCGrammar categoriesFor: #rightPrecedenceFor:!precedence!public! !
!SmaCCGrammar categoriesFor: #setOperatorPrecedenceFor:to:!precedence!public! !
!SmaCCGrammar categoriesFor: #setStartSymbolIfNone:!accessing!public! !
!SmaCCGrammar categoriesFor: #startSymbol!accessing!public! !
!SmaCCGrammar categoriesFor: #symbols!private! !
!SmaCCGrammar categoriesFor: #symbols:!private! !
!SmaCCGrammar categoriesFor: #terminalSymbolNamed:!private! !
!SmaCCGrammar categoriesFor: #terminalSymbolNamed:ifAbsent:!private! !
!SmaCCGrammar categoriesFor: #tokens!accessing!public! !
!SmaCCGrammar categoriesFor: #tokens:!initialize-release!public! !
!SmaCCGrammar categoriesFor: #type:!initialize-release!public! !
!SmaCCGrammar categoriesFor: #unusedSymbols!accessing!public! !

!SmaCCGrammar class methodsFor!

ignoreCase
	^IgnoreCase!

ignoreCase: aBoolean 
	IgnoreCase := aBoolean!

initialize
	IgnoreCase := false.
	self maximumCharacterValue: 255!

maximumCharacterValue
	^MaximumCharacterValue!

maximumCharacterValue: anInteger 
	MaximumCharacterValue := anInteger.
	SmaCCEdge initializeIsExpressions!

new
	^(super new)
		initialize;
		yourself! !
!SmaCCGrammar class categoriesFor: #ignoreCase!accessing!public! !
!SmaCCGrammar class categoriesFor: #ignoreCase:!accessing!public! !
!SmaCCGrammar class categoriesFor: #initialize!class initialization!public! !
!SmaCCGrammar class categoriesFor: #maximumCharacterValue!accessing!public! !
!SmaCCGrammar class categoriesFor: #maximumCharacterValue:!accessing!public! !
!SmaCCGrammar class categoriesFor: #new!instance creation!public! !

