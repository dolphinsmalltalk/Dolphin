"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RefactoryTyper
	instanceVariableNames: 'model class variableTypes bestGuesses variableMessages backpointers methodName selectorLookup'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RefactoryTyper guid: (GUID fromString: '{df340d5b-5ca0-48cb-8e8c-5153a7bc6a4c}')!
RefactoryTyper comment: ''!
!RefactoryTyper categoriesForClass!Refactory-Support! !
!RefactoryTyper methodsFor!

collectionNameFor: aString 
	^'-<1s>-' expandMacrosWith: aString!

computeEquivalenceClassesForMethodsAndVars
	| searcher |
	backpointers := Dictionary new.
	class instanceVariableNames do: [:each | backpointers at: each put: (Set with: each)].
	class withAllSubclasses 
		do: [:sub | sub selectors do: [:each | backpointers at: each put: (Set with: each)]].
	searcher := ParseTreeSearcher new.
	searcher matches: '^``@object' do: [:aNode :answer | self processNode: aNode value].
	self executeSearch: searcher!

computeMessagesSentToVariables
	| searcher |
	variableMessages := Dictionary new.
	class instanceVariableNames 
		do: [:each | variableMessages at: each put: Set new].
	searcher := ParseTreeSearcher new.
	class instanceVariableNames do: 
			[:each | 
			| block |
			block := 
					[:aNode :answer | 
					(variableMessages at: each ifAbsentPut: [Set new]) add: aNode selector.
					self processCollectionMessagesFor: each in: aNode].
			searcher matches: each , ' `@messageName: ``@args' do: block.
			(backpointers at: each) do: 
					[:sel | 
					sel isSymbol 
						ifTrue: 
							[searcher 
								matches: ('(self <1s>) `@messageName: ``@args' 
										expandMacrosWith: (ParseTreeSearcher buildSelectorString: sel)) asString
								do: block]]].
	searcher answer: variableMessages.
	self executeSearch: searcher!

computeTypes
	variableMessages
		keysAndValuesDo: [:key :value | variableTypes at: key put: (self findTypeFor: value)]!

executeSearch: searcher 
	class withAllSubclasses do: 
			[:each | 
			each selectors do: 
					[:sel | 
					| parseTree |
					methodName := sel.
					parseTree := each parseTreeFor: sel.
					parseTree notNil ifTrue: [searcher executeTree: parseTree]]]!

findTypeFor: selectorCollection 
	^selectorCollection inject: model rootClasses
		into: 
			[:classes :each | 
			self refineTypes: classes
				with: (selectorLookup at: each ifAbsentPut: [self implementorsOf: each])]!

guessTypeFromAssignment: aNode 
	| type set newType |
	type := nil.
	aNode value isAssignment 
		ifTrue: 
			[^self guessTypeFromAssignment: (RBAssignmentNode variable: aNode variable
						value: aNode value value)].
	aNode value isBlock ifTrue: [type := model classFor: [] class].
	aNode value isLiteralNode
		ifTrue: 
			[aNode value value isNil ifTrue: [^self].
			type := model classFor: (self typeFor: aNode value value)].
	aNode value isMessage 
		ifTrue: 
			[aNode value receiver isVariable 
				ifTrue: [type := model classNamed: aNode value receiver name asSymbol].
			aNode value selector == #asValue 
				ifTrue: [type := model classNamed: #ValueHolder].
			(#(#and: #or: #= #== #~= #~~ #<= #< #~~ #> #>=) 
				includes: aNode value selector) ifTrue: [type := model classFor: Boolean]].
	type isNil ifTrue: [^self].
	set := variableTypes at: aNode variable name.
	newType := set detect: [:each | type includesClass: each] ifNone: [nil].
	newType isNil ifTrue: [^self].
	newType = (model classFor: Object) ifTrue: [newType := type].
	(bestGuesses at: aNode variable name ifAbsentPut: [Set new]) add: newType!

guessTypesFor: anInstVarName 
	^bestGuesses at: anInstVarName ifAbsent: [self typesFor: anInstVarName]!

guessTypesFor: anInstVarName in: aClass 
	class = aClass ifFalse: [self runOn: aClass].
	^bestGuesses at: anInstVarName
		ifAbsent: [self typesFor: anInstVarName in: aClass]!

implementorsOf: aSelector 
	| classes |
	classes := OrderedCollection new.
	model rootClasses do: 
			[:each | 
			self 
				implementorsOf: aSelector
				in: each
				storeIn: classes].
	^classes!

implementorsOf: aSelector in: aClass storeIn: classes 
	(aClass directlyDefinesMethod: aSelector) 
		ifTrue: 
			[classes add: aClass.
			^self].
	aClass subclasses do: 
			[:each | 
			self 
				implementorsOf: aSelector
				in: each
				storeIn: classes]!

initialize
	model := RBNamespace new.
	class := model classFor: Object.
	variableTypes := Dictionary new.
	variableMessages := Dictionary new.
	selectorLookup := IdentityDictionary new.
	bestGuesses := Dictionary new!

merge: aName 
	| set1 set2 |
	set1 := backpointers at: methodName ifAbsent: [nil].
	set2 := backpointers at: aName ifAbsent: [nil].
	(set1 isNil or: [set2 isNil or: [set1 == set2]]) ifTrue: [^self].
	set1 addAll: set2.
	set2 do: [:each | backpointers at: each put: set1]!

model
	^model!

model: aRBNamespace 
	model := aRBNamespace!

printOn: aStream 
	aStream
		nextPutAll: class name;
		cr.
	class instanceVariableNames do: 
			[:each | 
			aStream
				tab;
				nextPutAll: each;
				tab;
				nextPut: $<.
			self printTypeFor: each on: aStream.
			aStream
				nextPut: $>;
				cr]!

printType: aClass for: aString on: aStream 
	| name colTypes |
	colTypes := #().
	name := self collectionNameFor: aString.
	(aClass includesClass: (model classFor: Collection)) 
		ifTrue: [colTypes := self guessTypesFor: name].
	colTypes notEmpty ifTrue: [aStream nextPut: $(].
	aClass printOn: aStream.
	colTypes notEmpty 
		ifTrue: 
			[aStream nextPutAll: ' of: '.
			colTypes size > 1 ifTrue: [aStream nextPut: $(].
			self printTypeFor: name on: aStream.
			colTypes size > 1 ifTrue: [aStream nextPut: $)]].
	colTypes notEmpty ifTrue: [aStream nextPut: $)]!

printTypeFor: aString on: aStream 
	| types |
	types := (self guessTypesFor: aString) 
				asSortedCollection: [:a :b | a name < b name].
	1 to: types size
		do: 
			[:i | 
			i == 1 ifFalse: [aStream nextPutAll: ' | '].
			self 
				printType: (types at: i)
				for: aString
				on: aStream]!

processCollectionFor: key messagesTo: aName in: aBlock 
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: aName , ' `@message: ``@args'
		do: 
			[:aNode :answer | 
			self processCollectionMessagesFor: key in: aNode.
			answer
				add: aNode selector;
				yourself].
	searcher executeTree: aBlock
		initialAnswer: (variableMessages at: (self collectionNameFor: key)
				ifAbsentPut: [Set new])!

processCollectionMessagesFor: variableName in: aParseTree 
	aParseTree isMessage ifFalse: [^self].
	(#(#first #at: #last) includes: aParseTree selector) 
		ifTrue: 
			[| parent |
			parent := aParseTree parent.
			(parent notNil and: [parent isMessage]) ifFalse: [^self].
			aParseTree == parent receiver ifFalse: [^self].
			(variableMessages at: (self collectionNameFor: variableName) ifAbsentPut: [Set new]) 
				add: parent selector.
			self processCollectionMessagesFor: (self collectionNameFor: variableName) in: parent].
	(#(#do: #do:separatedBy: #collect: #reject: #select: #detect: #detect:ifNone:) 
		includes: aParseTree selector) 
			ifTrue: 
				[| block |
				block := aParseTree arguments first.
				block isBlock ifFalse: [^self].
				self 
					processCollectionFor: variableName
					messagesTo: block arguments first name
					in: block].
	#inject:into: == aParseTree selector 
		ifTrue: 
			[| block |
			block := aParseTree arguments last.
			block isBlock ifFalse: [^self].
			self 
				processCollectionFor: variableName
				messagesTo: block arguments last name
				in: block]!

processNode: aNode
	(aNode isVariable and: [class instanceVariableNames includes: aNode name])
		ifTrue: [^self merge: aNode name].
	(aNode isMessage and: [aNode receiver isSelfVariable]) ifTrue: [^self merge: aNode selector].
	aNode isAssignment
		ifTrue: 
			[self
				processNode: aNode value;
				processNode: aNode variable].
	(aNode isMessage
		and: [#(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue:) includes: aNode selector])
			ifTrue: 
				[aNode arguments do: 
						[:each |
						each isBlock
							ifTrue: [each body statements notEmpty ifTrue: [self processNode: each body statements last]]]]!

refineTypes: aClassCollection with: anotherClassCollection 
	| classSet |
	classSet := Set new.
	aClassCollection do: 
			[:each | 
			anotherClassCollection do: 
					[:cls | 
					(cls includesClass: each) 
						ifTrue: [classSet add: cls]
						ifFalse: [(each includesClass: cls) ifTrue: [classSet add: each]]]].
	^classSet!

refineTypesByLookingAtAssignments
	| searcher needsSearch |
	needsSearch := false.
	searcher := ParseTreeSearcher new.
	variableTypes keysAndValuesDo: 
			[:key :value | 
			(key first == $-) 
				ifFalse: 
					[needsSearch := true.
					searcher matches: key , ' := ``@object'
						do: [:aNode :answer | self guessTypeFromAssignment: aNode]]].
	needsSearch ifTrue: [self executeSearch: searcher]!

rootClasses
	^Class rootsOfTheWorld!

runOn: aClass 
	variableTypes := Dictionary new.
	variableMessages := Dictionary new.
	bestGuesses := Dictionary new.
	class := model classFor: aClass.
	class instanceVariableNames isEmpty ifTrue: [^self].
	self
		selectedClass: aClass;
		computeEquivalenceClassesForMethodsAndVars;
		computeMessagesSentToVariables;
		computeTypes;
		refineTypesByLookingAtAssignments!

selectedClass: aClass 
	class := model classFor: aClass!

typeFor: anObject 
	'' class == anObject class ifTrue: [^String].
	^(#(true false) includes: anObject)
		ifTrue: [Boolean]
		ifFalse: [anObject class]!

typesFor: anInstVarName 
	^variableTypes at: anInstVarName ifAbsent: [Set new]!

typesFor: anInstVarName in: aClass 
	class = aClass ifFalse: [self runOn: aClass].
	^variableTypes at: anInstVarName ifAbsent: [Set new]! !
!RefactoryTyper categoriesFor: #collectionNameFor:!printing!public! !
!RefactoryTyper categoriesFor: #computeEquivalenceClassesForMethodsAndVars!equivalence classes!public! !
!RefactoryTyper categoriesFor: #computeMessagesSentToVariables!public!selectors! !
!RefactoryTyper categoriesFor: #computeTypes!computing types!public! !
!RefactoryTyper categoriesFor: #executeSearch:!operations!private! !
!RefactoryTyper categoriesFor: #findTypeFor:!computing types!public! !
!RefactoryTyper categoriesFor: #guessTypeFromAssignment:!assignments!public! !
!RefactoryTyper categoriesFor: #guessTypesFor:!accessing!public! !
!RefactoryTyper categoriesFor: #guessTypesFor:in:!accessing!public! !
!RefactoryTyper categoriesFor: #implementorsOf:!computing types!public! !
!RefactoryTyper categoriesFor: #implementorsOf:in:storeIn:!computing types!public! !
!RefactoryTyper categoriesFor: #initialize!initialize/release!public! !
!RefactoryTyper categoriesFor: #merge:!equivalence classes!public! !
!RefactoryTyper categoriesFor: #model!accessing!private! !
!RefactoryTyper categoriesFor: #model:!accessing!private! !
!RefactoryTyper categoriesFor: #printOn:!printing!public! !
!RefactoryTyper categoriesFor: #printType:for:on:!printing!public! !
!RefactoryTyper categoriesFor: #printTypeFor:on:!printing!public! !
!RefactoryTyper categoriesFor: #processCollectionFor:messagesTo:in:!public!selectors/collections! !
!RefactoryTyper categoriesFor: #processCollectionMessagesFor:in:!public!selectors/collections! !
!RefactoryTyper categoriesFor: #processNode:!equivalence classes!public! !
!RefactoryTyper categoriesFor: #refineTypes:with:!computing types!public! !
!RefactoryTyper categoriesFor: #refineTypesByLookingAtAssignments!assignments!public! !
!RefactoryTyper categoriesFor: #rootClasses!constants!private! !
!RefactoryTyper categoriesFor: #runOn:!accessing!public! !
!RefactoryTyper categoriesFor: #selectedClass:!accessing!public! !
!RefactoryTyper categoriesFor: #typeFor:!assignments!public! !
!RefactoryTyper categoriesFor: #typesFor:!accessing!public! !
!RefactoryTyper categoriesFor: #typesFor:in:!accessing!public! !

!RefactoryTyper class methodsFor!

new
	^(super new)
		initialize;
		yourself!

newFor: aRBNamespace 
	^(self new)
		model: aRBNamespace;
		yourself!

typesFor: variableName in: aParseTree model: aRBNamespace 
	| searcher messages |
	searcher := ParseTreeSearcher new.
	searcher matches: variableName , ' `@message: ``@args'
		do: 
			[:aNode :answer | 
			answer
				add: aNode selector;
				yourself].
	messages := searcher executeTree: aParseTree initialAnswer: Set new.
	^(self new)
		model: aRBNamespace;
		findTypeFor: messages! !
!RefactoryTyper class categoriesFor: #new!instance creation!public! !
!RefactoryTyper class categoriesFor: #newFor:!instance creation!public! !
!RefactoryTyper class categoriesFor: #typesFor:in:model:!accessing!public! !

