﻿"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring
	subclass: #'Refactory.Browser.MoveVariableDefinitionRefactoring'
	instanceVariableNames: 'selector interval name parseTree blockNodes definingNode method'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.MoveVariableDefinitionRefactoring guid: (Core.GUID fromString: '{fe31ff59-c938-404b-92bb-579e93af7fe9}')!

Refactory.Browser.MoveVariableDefinitionRefactoring comment: ''!

!Refactory.Browser.MoveVariableDefinitionRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.MoveVariableDefinitionRefactoring methodsFor!

checkNodes: sequenceNodes
	(sequenceNodes
		anySatisfy: [:each | RBReadBeforeWrittenTester isVariable: name readBeforeWrittenIn: each])
			ifTrue: [^false].
	sequenceNodes do: 
			[:each |
			(self usesDirectly: each body)
				ifTrue: [blockNodes add: each]
				ifFalse: [(self checkNodes: (self subblocksIn: each body)) ifFalse: [blockNodes add: each]]].
	^true!

checkParseTree
	| node |
	#rbFix.	"If already at innermost possible scope raise this as an abort to avoid an annoying message box, and include the variable name in the messages"
	blockNodes := OrderedCollection new.
	node := self
				whichVariableNode: parseTree
				inInterval: interval
				name: name.
	node isNil ifTrue: [self refactoringError: 'Unable to locate node in parse tree'].
	definingNode := node whoDefines: name.
	definingNode isNil ifTrue: [self refactoringError: 'Cannot locate variable definition'].
	definingNode isSequence
		ifFalse: [self refactoringError: ('''<1s>'' is an argument' expandMacrosWith: name)].
	(self usesDirectly: definingNode)
		ifTrue: 
			[self refactoringAborted: ('''<1s>'' is already bound tightly as possible' expandMacrosWith: name)].
	(self checkNodes: (self subblocksIn: definingNode))
		ifFalse: [self refactoringError: ('''<1s>'' is possibly read before written' expandMacrosWith: name)]!

class: aClass selector: aSelector interval: anInterval 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	interval := anInterval.
	class := aClass.
	selector := aSelector.
	class := self classObjectFor: aClass.
!

preconditions
	^(RBCondition definesSelector: selector in: class)
		& (RBCondition withBlock: 
					[| methodSource |
					interval first <= interval last ifFalse: [self refactoringError: 'Invalid variable name'].
					methodSource := class sourceCodeFor: selector.
					methodSource size >= interval last ifFalse: [self refactoringError: 'Invalid range for variable'].
					#rbFix.	"Allow trailing blanks in the selection"
					name := (methodSource copyFrom: interval first to: interval last) trimBlanks.
					(self checkInstanceVariableName: name)
						ifFalse: [self refactoringError: name , ' does not seem to be a valid variable name.'].
					method := class methodFor: selector.
					parseTree := method parseTreeWithSourceIntervals.
					self checkParseTree.
					true])!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' bindTight: '.
	interval storeOn: aStream.
	aStream nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' selector: ';
		print: selector.
	aStream nextPut: $)!

subblocksIn: aParseTree
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '[:`@blockTemps | | `@temps | `@.Statements]'
		do: 
			[:aNode :answer |
			(aNode references: name) ifTrue: [answer add: aNode].
			answer].
	^searcher executeTree: aParseTree initialAnswer: OrderedCollection new!

transform
	definingNode removeTemporaryNamed: name.
	blockNodes do: [:each | each body addTemporaryNamed: name].
	model compileTree: parseTree forMethod: method!

usesDirectly: aParseTree
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher
		matches: '[:`@args | | `@temps | `@.Statements]' do: [:aNode :answer | answer];
		matches: name do: [:aNode :answer | true].
	^searcher executeTree: aParseTree initialAnswer: false! !

!Refactory.Browser.MoveVariableDefinitionRefactoring categoriesForMethods!
checkNodes:!public!transforming! !
checkParseTree!public!transforming! !
class:selector:interval:!initialize/release!public! !
preconditions!preconditions!public! !
storeOn:!printing!public! !
subblocksIn:!public!transforming! !
transform!public!transforming! !
usesDirectly:!public!transforming! !
!

!Refactory.Browser.MoveVariableDefinitionRefactoring class methodsFor!

bindTight: anInterval in: aClass selector: aSelector 
	^self new
		class: aClass
		selector: aSelector
		interval: anInterval!

model: aRBModel bindTight: anInterval in: aClass selector: aSelector
	^self new
		model: aRBModel;
		class: aClass
			selector: aSelector
			interval: anInterval;
		yourself! !

!Refactory.Browser.MoveVariableDefinitionRefactoring class categoriesForMethods!
bindTight:in:selector:!instance creation!public! !
model:bindTight:in:selector:!instance creation!public! !
!

