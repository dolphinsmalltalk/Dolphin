"Filed out from Dolphin Smalltalk 7"!

MethodRefactoring subclass: #MoveMethodRefactoring
	instanceVariableNames: 'selector variable moveToClasses parseTree hasOnlySelfReturns selfVariableName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MoveMethodRefactoring guid: (GUID fromString: '{12a63bdc-2ded-4523-bc81-881a6bc3f085}')!
MoveMethodRefactoring comment: ''!
!MoveMethodRefactoring categoriesForClass!Refactory-Refactorings! !
!MoveMethodRefactoring methodsFor!

abstractVariables
	self performComponentRefactoring: self abstractVariablesRefactoring.
	parseTree := self abstractVariablesRefactoring parseTree!

abstractVariablesRefactoring
	^AbstractVariablesRefactoring 
		model: self model
		abstractVariablesIn: parseTree
		from: class
		toAll: moveToClasses
		ignoring: variable!

addSelfReturn
	self hasOnlySelfReturns ifTrue: [^self].
	parseTree addSelfReturn!

buildParseTree
	parseTree := (class parseTreeFor: selector) copy.
	parseTree isNil ifTrue: [self refactoringError: 'Could not parse method']!

checkAssignmentsToVariable
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: variable , ' := `@object' do: [:aNode :answer | true].
	(searcher executeTree: parseTree initialAnswer: false) 
		ifTrue: 
			[self refactoringError: ('Cannot move the method into <1s> since it is assigned' 
						expandMacrosWith: variable)]!

checkForPrimitiveMethod
	parseTree isPrimitive 
		ifTrue: [self refactoringError: 'Cannot move primitive methods']!

checkForSuperReferences
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: 'super `@message: `@args' do: [:aNode :answer | true].
	(searcher executeTree: parseTree initialAnswer: false) 
		ifTrue: 
			[self refactoringError: 'Cannot move the method since it has a super message send.']!

checkTemporaryVariableNames
	| varNames |
	varNames := parseTree allDefinedVariables.
	selfVariableName notNil ifTrue: [varNames add: selfVariableName].
	varNames do: 
			[:name | 
			moveToClasses do: 
					[:each | 
					(self canReferenceVariable: name in: each) 
						ifTrue: 
							[self refactoringError: ('<1p> already defines a variable called <2s>' 
										expandMacrosWith: each
										with: name)]]]!

compileDelagatorMethod
	| statementNode delegatorNode tree |
	delegatorNode := RBMessageNode
				receiver: (RBVariableNode named: variable)
				selectorParts: parseTree selectorParts
				arguments: (parseTree argumentNames
						collect: [:each | RBVariableNode named: (each = selfVariableName ifTrue: ['self'] ifFalse: [each])]).
	self hasOnlySelfReturns ifFalse: [delegatorNode := RBReturnNode value: delegatorNode].
	statementNode := RBSequenceNode temporaries: #() statements: {delegatorNode}.
	(tree := class parseTreeFor: selector) body: statementNode.
	class compileTree: tree!

compileNewMethods
	moveToClasses 
		do: [:each | each compile: parseTree newSource classified: (class protocolsFor: selector)]!

getAllClassesForGlobalOrClassVariable
	"rbDmm added for MoveMethodRefactoring>>getClassForGlobalOrClassVariable"
	
	| baseClass |
	baseClass := self model classNamed: #Object.
	^baseClass allSubclasses asSortedCollection: [:x :y | x name < y name].
	!

getArgumentNameForSelf
	self needsToReplaceSelfReferences ifFalse: [^self].
	
	[selfVariableName := self requestSelfArgumentName.
	(self checkInstanceVariableName: selfVariableName in: class) 
		ifTrue: 
			[self verifyTemporaryVariableDoesNotOverride 
				ifFalse: 
					[self 
						refactoringWarning: ('The variable <1p> is already defined in one of the classes you''re moving the method to.<n>Try another?' 
								expandMacrosWith: selfVariableName).
					selfVariableName := nil]]
		ifFalse: 
			[self 
				refactoringWarning: ('The variable name <1p> is not a valid Smalltalk temporary variable name<n>Try again?' 
						expandMacrosWith: selfVariableName).
			selfVariableName := nil].
	selfVariableName isNil] 
			whileTrue: []!

getClassesForInstanceVariable
	| definingClass typer types |
	definingClass := class whoDefinesInstanceVariable: variable.
	typer := RefactoryTyper newFor: self model.
	typer runOn: definingClass.
	types := typer typesFor: variable.
	types isEmpty ifTrue: [types := OrderedCollection with: (self model classNamed: #Object)].
	moveToClasses := self selectVariableTypesFrom: types
				selected: (typer guessTypesFor: variable).
	#rbFix.	"Use the abort signal rather than an error to avoid annoying message box"
	moveToClasses isNil ifTrue: [self refactoringAborted: 'Method not moved']!

getClassesForTemporaryVariable
	| types |
	types := RefactoryTyper 
				typesFor: variable
				in: parseTree
				model: self model.
	types isEmpty 
		ifTrue: [types := OrderedCollection with: (self model classNamed: #Object)].
	moveToClasses := self selectVariableTypesFrom: types selected: types.
	#rbFix. "Use the abort signal rather than an error to avoid annoying message box"
	moveToClasses isNil ifTrue: [self refactoringAborted: 'Method not moved']!

getClassesToMoveTo
	
	self isMovingToArgument 
		ifTrue: [self getClassesForTemporaryVariable]
		ifFalse: 
			[self isMovingToInstVar 
				ifTrue: [self getClassesForInstanceVariable]
				ifFalse: [self getClassForGlobalOrClassVariable]].
	moveToClasses isEmpty 
		ifTrue: [self refactoringError: 'No classes selected, method not moved.']!

getClassForGlobalOrClassVariable
	"rbDmm - changed to getAllClassesForGlobalOrClassVariable"

	| definingClass type |
	definingClass := class whoDefinesClassVariable: variable.
	definingClass isNil
		ifTrue: 
			[type := self model classNamed: variable asSymbol.
			type isNil ifTrue: [type := self model classNamed: #Object]]
		ifFalse: [type := definingClass typeOfClassVariable: variable].
	moveToClasses := self selectVariableTypesFrom: self getAllClassesForGlobalOrClassVariable
				selected: {type}.
	#rbFix.	"Use the abort signal rather than an error to avoid annoying message box"
	moveToClasses isNil ifTrue: [self refactoringAborted: 'Method not moved']!

getNewMethodName
	| newSelector parameters alreadyDefined methodName newMethodName |
	parameters := OrderedCollection withAll: parseTree argumentNames.
	parameters remove: variable ifAbsent: [].
	self needsToReplaceSelfReferences ifTrue: [parameters add: selfVariableName].
	methodName := RBMethodName selector: selector arguments: parameters.
	
	[newMethodName := self requestMethodNameFor: methodName.
	newMethodName isNil ifTrue: [self refactoringAborted: 'Did not move method'].
	newMethodName isValid 
		ifTrue: [newSelector := newMethodName selector]
		ifFalse: [self refactoringWarning: 'Invalid method name'].
	parameters := newMethodName arguments.
	(self checkMethodName: newSelector in: class) 
		ifFalse: 
			[self refactoringWarning: newSelector , ' is not a valid selector name.'.
			newSelector := nil].
	alreadyDefined := moveToClasses 
				detect: [:each | each hierarchyDefinesMethod: newSelector]
				ifNone: [nil].
	alreadyDefined notNil 
		ifTrue: 
			[self 
				refactoringWarning: ('<1p> is already defined by <2p> or a super/subclass<n>Try another?' 
						expandMacrosWith: newSelector
						with: alreadyDefined).
			newSelector := nil].
	newSelector isNil] 
			whileTrue: [].
	parseTree renameSelector: newSelector
		andArguments: (parameters collect: [:each | RBVariableNode named: each]) asArray!

hasOnlySelfReturns
	^hasOnlySelfReturns isNil 
		ifTrue: 
			[| searcher |
			searcher := ParseTreeSearcher new.
			searcher
				matches: '^self' do: [:aNode :answer | answer];
				matches: '^`@object' do: [:aNode :answer | false].
			hasOnlySelfReturns := searcher executeTree: parseTree initialAnswer: true]
		ifFalse: [hasOnlySelfReturns]!

hasSelfReferences
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: 'self' do: [:aNode :answer | true].
	self hasOnlySelfReturns 
		ifTrue: [searcher matches: '^self' do: [:aNode :answer | answer]].
	^searcher executeTree: parseTree initialAnswer: false!

isMovingToArgument
	^(parseTree arguments collect: [:each | each name]) includes: variable!

isMovingToInstVar
	^self isMovingToArgument not 
		and: [(class whoDefinesInstanceVariable: variable) notNil]!

needsToReplaceSelfReferences
	^self hasSelfReferences 
		or: [self abstractVariablesRefactoring hasVariablesToAbstract]!

preconditions
	^(RBCondition definesSelector: selector in: class) 
		& (RBCondition withBlock: 
					[self buildParseTree.
					self checkForPrimitiveMethod.
					self checkForSuperReferences.
					self checkAssignmentsToVariable.
					self getClassesToMoveTo.
					self getArgumentNameForSelf.
					self checkTemporaryVariableNames.
					true])!

replaceSelfReferences
	| replacer |
	#rbFix.	"If there are no self references, then the selfVariableName is nil causing a DNU if we proceed"
	selfVariableName isNil 
		ifTrue: 
			[self assert: [self needsToReplaceSelfReferences not].
			^self].
	replacer := ParseTreeRewriter new.
	replacer replace: 'self' with: selfVariableName.
	self hasOnlySelfReturns ifTrue: [replacer replace: '^self' with: '^self'].
	replacer executeTree: parseTree.
	parseTree := replacer tree!

replaceVariableReferences
	| replacer |
	replacer := ParseTreeRewriter new.
	replacer replace: variable with: 'self'.
	replacer executeTree: parseTree.
	parseTree := replacer tree!

selector: aSymbol class: aClass variable: aVariableName 
	#rbFix.	"Ensure displayString is valid before lazily instantiating model."
	class := aClass.
	selector := aSymbol.
	variable := aVariableName.
	class := self classObjectFor: aClass!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' selector: #';
		nextPutAll: selector;
		nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' variable: ''';
		nextPutAll: variable;
		nextPutAll: ''')'!

transform
	self
		abstractVariables;
		getNewMethodName;
		addSelfReturn;
		replaceSelfReferences;
		replaceVariableReferences;
		compileNewMethods;
		compileDelagatorMethod!

verifyTemporaryVariableDoesNotOverride
	(parseTree allDefinedVariables includes: selfVariableName) ifTrue: [^false].
	^(moveToClasses anySatisfy: [:each | each definesVariable: selfVariableName]) not! !
!MoveMethodRefactoring categoriesFor: #abstractVariables!public!transforming! !
!MoveMethodRefactoring categoriesFor: #abstractVariablesRefactoring!public!transforming! !
!MoveMethodRefactoring categoriesFor: #addSelfReturn!public!transforming! !
!MoveMethodRefactoring categoriesFor: #buildParseTree!private! !
!MoveMethodRefactoring categoriesFor: #checkAssignmentsToVariable!preconditions!public! !
!MoveMethodRefactoring categoriesFor: #checkForPrimitiveMethod!preconditions!public! !
!MoveMethodRefactoring categoriesFor: #checkForSuperReferences!preconditions!public! !
!MoveMethodRefactoring categoriesFor: #checkTemporaryVariableNames!preconditions!public! !
!MoveMethodRefactoring categoriesFor: #compileDelagatorMethod!public!transforming! !
!MoveMethodRefactoring categoriesFor: #compileNewMethods!public!transforming! !
!MoveMethodRefactoring categoriesFor: #getAllClassesForGlobalOrClassVariable!accessing!private! !
!MoveMethodRefactoring categoriesFor: #getArgumentNameForSelf!public!transforming! !
!MoveMethodRefactoring categoriesFor: #getClassesForInstanceVariable!accessing!private! !
!MoveMethodRefactoring categoriesFor: #getClassesForTemporaryVariable!accessing!private! !
!MoveMethodRefactoring categoriesFor: #getClassesToMoveTo!accessing!private! !
!MoveMethodRefactoring categoriesFor: #getClassForGlobalOrClassVariable!accessing!private! !
!MoveMethodRefactoring categoriesFor: #getNewMethodName!public!transforming! !
!MoveMethodRefactoring categoriesFor: #hasOnlySelfReturns!public!transforming! !
!MoveMethodRefactoring categoriesFor: #hasSelfReferences!public!testing! !
!MoveMethodRefactoring categoriesFor: #isMovingToArgument!public!testing! !
!MoveMethodRefactoring categoriesFor: #isMovingToInstVar!public!testing! !
!MoveMethodRefactoring categoriesFor: #needsToReplaceSelfReferences!public!testing! !
!MoveMethodRefactoring categoriesFor: #preconditions!preconditions!public! !
!MoveMethodRefactoring categoriesFor: #replaceSelfReferences!public!transforming! !
!MoveMethodRefactoring categoriesFor: #replaceVariableReferences!public!transforming! !
!MoveMethodRefactoring categoriesFor: #selector:class:variable:!initialize/release!public! !
!MoveMethodRefactoring categoriesFor: #storeOn:!printing!public! !
!MoveMethodRefactoring categoriesFor: #transform!public!transforming! !
!MoveMethodRefactoring categoriesFor: #verifyTemporaryVariableDoesNotOverride!public!transforming! !

!MoveMethodRefactoring class methodsFor!

model: aRBNamespace selector: aSymbol class: aClass variable: aVariableName 
	^(self new)
		model: aRBNamespace;
		selector: aSymbol
			class: aClass
			variable: aVariableName;
		yourself!

selector: aSymbol class: aClass variable: aVariableName 
	^(self new)
		selector: aSymbol
			class: aClass
			variable: aVariableName;
		yourself! !
!MoveMethodRefactoring class categoriesFor: #model:selector:class:variable:!instance creation!public! !
!MoveMethodRefactoring class categoriesFor: #selector:class:variable:!instance creation!public! !

