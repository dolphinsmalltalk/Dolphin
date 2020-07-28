"Filed out from Dolphin Smalltalk 7"!

ChangeMethodNameRefactoring subclass: #AddParameterRefactoring
	instanceVariableNames: 'initializer senders'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AddParameterRefactoring guid: (GUID fromString: '{afeead23-befe-4021-bb3b-1d7b14e487ba}')!
AddParameterRefactoring comment: ''!
!AddParameterRefactoring categoriesForClass!Refactory-Refactorings! !
!AddParameterRefactoring methodsFor!

addParameterToMethod: aSelector in: aClass newSelector: newSel initializer: init 
	self 
		renameMethod: aSelector
		in: aClass
		to: newSel
		permutation: (1 to: newSel argumentCount).
	initializer := init!

checkSendersAccessTo: name
	| violatorClass |
	(#('self' 'super') includes: name) ifTrue: [^self].
	violatorClass := self senders detect: [:each | (self canReferenceVariable: name in: each) not]
				ifNone: [nil].
	violatorClass notNil
		ifTrue: 
			[self refactoringError: ('<1s> doesn''t appear to be defined in <2p>' expandMacrosWith: name
						with: violatorClass)]!

checkVariableReferencesIn: aParseTree 
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`var'
		do: 
			[:aNode :answer | 
			| name |
			name := aNode name.
			(aNode whoDefines: name) isNil ifTrue: [self checkSendersAccessTo: name]].
	searcher executeTree: aParseTree!

modifyImplementorParseTree: parseTree in: aClass
	| name newArg allTempVars |
	allTempVars := parseTree allDefinedVariables.
	name := self safeVariableNameFor: aClass temporaries: allTempVars.
	newArg := RBVariableNode named: name.
	parseTree arguments: parseTree arguments , {newArg}.
	super modifyImplementorParseTree: parseTree in: aClass!

myConditions
	^RBCondition withBlock: 
			[oldSelector argumentCount + 1 = newSelector argumentCount 
				ifFalse: 
					[self refactoringError: newSelector printString 
								, ' doesn''t have the proper number of arguments.'].
			self verifyInitializationExpression.
			true]!

newSelectorString
	| stream keywords |
	stream := WriteStream on: String new.
	keywords := newSelector keywords.
	1 to: keywords size
		do: 
			[:i | 
			stream nextPutAll: (keywords at: i).
			i == keywords size 
				ifTrue: 
					[stream
						nextPut: $(;
						nextPutAll: initializer;
						nextPut: $)]
				ifFalse: 
					[stream
						nextPutAll: ' ``@arg';
						print: i].
			stream nextPut: $ ].
	^stream contents!

parseTreeRewriter
	| rewriteRule oldString newString |
	rewriteRule := ParseTreeRewriter new.
	oldString := self buildSelectorString: oldSelector.
	newString := self newSelectorString.
	rewriteRule replace: '``@object ' , oldString
		with: '``@object ' , newString.
	^rewriteRule!

safeVariableNameFor: aClass temporaries: allTempVars 
	| baseString i newString |
	#rbFix.	"Extract out initial variable name suggestion so can base on the type of the initializer, rather than always using 'anObject'"
	newString := baseString := self suggestedVariableNameIn: aClass.
	i := 0.
	[(allTempVars includes: newString) or: [aClass definesInstanceVariable: newString]] whileTrue: 
			[i := i + 1.
			newString := baseString , i printString].
	^newString!

senders
	senders isNil 
		ifTrue: 
			[senders := Set new.
			self model allReferencesTo: oldSelector
				do: [:each | senders add: each modelClass]].
	^senders!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' addParameterToMethod: #';
		nextPutAll: oldSelector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' newSelector: #';
		nextPutAll: newSelector;
		nextPutAll: ' initializer: ''';
		nextPutAll: initializer;
		nextPutAll: ''')'!

suggestedVariableNameIn: aClass 
	#rbFix.	"Added to generate a type specific parameter name based on the initializer rather than always using 'anObject'"
	^([Compiler evaluate: initializer] on: Error do: [:ex | nil]) 
		ifNil: ['anObject']
		ifNotNil: [:init | Smalltalk developmentSystem nameForArgument: init]!

verifyInitializationExpression
	| tree |
	tree := RBParser parseExpression: initializer
				onError: 
					[:msg :index | 
					self refactoringError: 'Illegal initialization code because:.' , msg].
	tree isValue 
		ifFalse: 
			[self 
				refactoringError: 'The initialization code cannot be a return node or a list of statements'].
	self checkVariableReferencesIn: tree! !
!AddParameterRefactoring categoriesFor: #addParameterToMethod:in:newSelector:initializer:!initialize/release!public! !
!AddParameterRefactoring categoriesFor: #checkSendersAccessTo:!preconditions!public! !
!AddParameterRefactoring categoriesFor: #checkVariableReferencesIn:!preconditions!public! !
!AddParameterRefactoring categoriesFor: #modifyImplementorParseTree:in:!private! !
!AddParameterRefactoring categoriesFor: #myConditions!preconditions!public! !
!AddParameterRefactoring categoriesFor: #newSelectorString!private! !
!AddParameterRefactoring categoriesFor: #parseTreeRewriter!private! !
!AddParameterRefactoring categoriesFor: #safeVariableNameFor:temporaries:!private! !
!AddParameterRefactoring categoriesFor: #senders!private! !
!AddParameterRefactoring categoriesFor: #storeOn:!printing!public! !
!AddParameterRefactoring categoriesFor: #suggestedVariableNameIn:!private! !
!AddParameterRefactoring categoriesFor: #verifyInitializationExpression!preconditions!public! !

!AddParameterRefactoring class methodsFor!

addParameterToMethod: aSelector in: aClass newSelector: newSelector initializer: init 
	^self new addParameterToMethod: aSelector
		in: aClass
		newSelector: newSelector
		initializer: init!

model: aRBNamespace addParameterToMethod: aSelector in: aClass newSelector: newSelector initializer: init 
	^(self new)
		model: aRBNamespace;
		addParameterToMethod: aSelector
			in: aClass
			newSelector: newSelector
			initializer: init;
		yourself! !
!AddParameterRefactoring class categoriesFor: #addParameterToMethod:in:newSelector:initializer:!instance creation!public! !
!AddParameterRefactoring class categoriesFor: #model:addParameterToMethod:in:newSelector:initializer:!instance creation!public! !

