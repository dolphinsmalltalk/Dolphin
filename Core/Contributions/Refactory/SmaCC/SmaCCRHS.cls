"Filed out from Dolphin Smalltalk X6"!

Object subclass: #SmaCCRHS
	instanceVariableNames: 'collection reduceAction variableNames'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCRHS guid: (GUID fromString: '{1FD2FD6F-4FCB-485F-BBC2-CD6A5222E1AB}')!
SmaCCRHS comment: 'SmaCCRHS represents the right hand side of the production.

Instance variables:
	collection	<OrderedCollection of: SmaCCSymbol> the collection of symbols that represent the rhs
	grammar <SmaCCGrammar> the grammar that the production is in
	variableNames	<Dictionary key: String value: Integer>	the name of each symbol in the rhs. These names can be used in the {} code blocks.'!
!SmaCCRHS categoriesForClass!SmaCC Runtime! !
!SmaCCRHS methodsFor!

= aRHS 
	^self class = aRHS class and: [collection = aRHS collection]!

add: aGrammarSymbol 
	collection add: aGrammarSymbol!

at: anInteger 
	^collection at: anInteger!

collection
	^collection!

compileSourceFor: aGrammarSymbol in: aClass
	| action rewriter parseTree methodName |
	action := self reduceAction.
	action isNil ifTrue: [^self defaultReduceAction].
	parseTree := RBParser parseExpression: action
				onError: 
					[:s :p | 
					SmaCCCompilationNotification signal: 'Invalid Smalltalk code in reduction rule'
						with: aGrammarSymbol name , ' : ' , self printString , '\\' withCRs , action.
					^self defaultReduceAction].
	(parseTree isLiteralNode and: 
			[parseTree value isSymbol 
				and: [parseTree value argumentCount <= 1 and: [aClass definesMethod: parseTree value]]]) 
		ifTrue: [^parseTree value].
	rewriter := self parseTreeRewriter.
	rewriter executeTree: parseTree.
	parseTree := rewriter tree.
	methodName := ('reduceActionFor' , (self safeMethodNameFor: aGrammarSymbol) 
				, (aGrammarSymbol positionOf: self) printString , ':') 
				asSymbol.
	parseTree isSequence 
		ifFalse: [parseTree := RBSequenceNode statements: (Array with: parseTree)].
	parseTree := RBMethodNode 
				selector: methodName
				arguments: (Array with: (RBVariableNode named: 'nodes'))
				body: parseTree.
	parseTree addReturn.
	aClass compile: parseTree formattedCode classified: 'generated-reduction actions'.
	^methodName!

defaultReduceAction
	^#reduceFor:!

do: aBlock
	collection do: aBlock!

firstTerminals
	| items |
	collection isEmpty ifTrue: [^Set with: SmaCCSymbol empty].
	items := Set new.
	1 to: collection size
		do: 
			[:index | 
			items addAll: (collection at: index) firstTerminals.
			(items includes: SmaCCSymbol empty) 
				ifTrue: [index < collection size ifTrue: [items remove: SmaCCSymbol empty]]
				ifFalse: [^items]].
	^items!

hash
	^self class hash bitXor: (collection hash bitShift: 14)!

initialize
	collection := OrderedCollection new.
	reduceAction := nil.
	variableNames := Dictionary new!

nameLastItem: aString 
	variableNames at: aString put: collection size!

parseTreeRewriter
	| rewriter |
	rewriter := ParseTreeRewriter new.
	1 to: self size
		do: 
			[:i | 
			rewriter replace: i printString storeString
				with: '(nodes at: ' , i printString , ')'].
	variableNames keysAndValuesDo: 
			[:key :value | 
			rewriter replace: key with: '(nodes at: ' , value printString , ')'].
	^rewriter!

printOn: aStream 
	^collection do: [:each | each printOn: aStream]
		separatedBy: [aStream space]!

reduceAction
	^reduceAction!

reduceAction: anObject
	reduceAction := anObject!

safeMethodNameFor: aGrammarSymbol 
	^aGrammarSymbol printString 
		collect: [:each | each isAlphaNumeric ifTrue: [each] ifFalse: [$_]]!

size
	^collection size! !
!SmaCCRHS categoriesFor: #=!comparing!public! !
!SmaCCRHS categoriesFor: #add:!accessing!public! !
!SmaCCRHS categoriesFor: #at:!accessing!public! !
!SmaCCRHS categoriesFor: #collection!private! !
!SmaCCRHS categoriesFor: #compileSourceFor:in:!public!reduction table! !
!SmaCCRHS categoriesFor: #defaultReduceAction!private! !
!SmaCCRHS categoriesFor: #do:!accessing!public! !
!SmaCCRHS categoriesFor: #firstTerminals!accessing!public! !
!SmaCCRHS categoriesFor: #hash!comparing!public! !
!SmaCCRHS categoriesFor: #initialize!initialize-release!public! !
!SmaCCRHS categoriesFor: #nameLastItem:!accessing!public! !
!SmaCCRHS categoriesFor: #parseTreeRewriter!public!reduction table! !
!SmaCCRHS categoriesFor: #printOn:!printing!public! !
!SmaCCRHS categoriesFor: #reduceAction!accessing!public! !
!SmaCCRHS categoriesFor: #reduceAction:!accessing!public! !
!SmaCCRHS categoriesFor: #safeMethodNameFor:!public!reduction table! !
!SmaCCRHS categoriesFor: #size!accessing!public! !

!SmaCCRHS class methodsFor!

new
	^(super new)
		initialize;
		yourself! !
!SmaCCRHS class categoriesFor: #new!instance creation!public! !

