"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring
	subclass: #'Refactory.Browser.MoveMethodRefactoring'
	instanceVariableNames: 'selector variable moveToClasses parseTree hasOnlySelfReturns selfVariableName abstractVariables'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.MoveMethodRefactoring guid: (Core.GUID fromString: '{12a63bdc-2ded-4523-bc81-881a6bc3f085}')!
Refactory.Browser.MoveMethodRefactoring comment: ''!
!Refactory.Browser.MoveMethodRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.MoveMethodRefactoring methodsFor!

abstractVariables
	parseTree := (self performComponentRefactoring: self abstractVariablesRefactoring) parseTree!

abstractVariablesRefactoring
	^abstractVariables
		ifNil: 
			[abstractVariables := AbstractVariablesRefactoring
						model: self model
						abstractVariablesIn: parseTree
						from: class
						toAll: moveToClasses
						ignoring: variable]!

addSelfReturn
	self hasOnlySelfReturns ifTrue: [^self].
	parseTree addSelfReturn!

buildParseTree
	parseTree := (class methodFor: selector) boundParseTree copy.
	parseTree isNil ifTrue: [self refactoringError: 'Could not parse method']!

checkAssignmentsToVariable
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: variable , ' := `@object' do: [:aNode :answer | true].
	(searcher executeTree: parseTree initialAnswer: false)
		ifTrue: 
			[self
				refactoringError: ('Cannot move the method into <1s> since it is assigned' expandMacrosWith: variable)]!

checkForPrimitiveMethod
	parseTree isPrimitive 
		ifTrue: [self refactoringError: 'Cannot move primitive methods']!

checkForSuperReferences
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: 'super `@message: `@args' do: [:aNode :answer | true].
	(searcher executeTree: parseTree initialAnswer: false)
		ifTrue: [self refactoringError: 'Cannot move the method since it has a super message send.']!

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
							[self
								refactoringError: ('<1p> already defines a variable called <2s>' expandMacrosWith: each with: name)]]]!

compileDelegatorMethod
	| statementNode delegatorNode method |
	delegatorNode := StMessageNode
				receiver: (StBasicVariableNode named: variable)
				selectorParts: parseTree selectorParts
				arguments: (parseTree argumentNames collect: 
							[:each |
							each = selfVariableName ifTrue: [StVariableNode selfNode] ifFalse: [StBasicVariableNode named: each]]).
	self hasOnlySelfReturns ifFalse: [delegatorNode := StReturnNode value: delegatorNode].
	statementNode := StSequenceNode temporaries: #() statements: { delegatorNode }.
	method := (class whoDefinesMethod: selector) methodFor: selector.
	model compileTree: (method parseTree
				body: statementNode;
				yourself)
		forMethod: method!

compileNewMethods
	| categories rewriter |
	categories := class protocolsFor: selector.
	"Static variable references may need to be rewritten if moving a method to a class in a different namespace"
	rewriter := self buildVariableReferenceRewriter.
	moveToClasses do: 
			[:each |
			parseTree methodNode methodClass: each.
			each
				compile: ((rewriter executeTree: parseTree) ifTrue: [rewriter tree] ifFalse: [parseTree]) newSource
				categories: categories]!

getAllClassesForGlobalOrClassVariable
	"rbDmm added for MoveMethodRefactoring>>getClassForGlobalOrClassVariable"

	| baseClass |
	baseClass := self model instanceClassFor: Object.
	^baseClass allSubclasses asSortedCollection: [:x :y | x name < y name]!

getArgumentNameForSelf
	self needsToReplaceSelfReferences ifFalse: [^self].
	selfVariableName := self requestSelfArgumentName.
	(self checkInstanceVariableName: selfVariableName)
		ifTrue: 
			[self verifyTemporaryVariableDoesNotOverride
				ifFalse: 
					[^self
						refactoringError: 'The variable <1p> is already defined in one of the classes you''re moving the method to.'
								<< selfVariableName]]
		ifFalse: 
			[self refactoringError: 'The variable name <1p> is not a valid Smalltalk temporary variable name.'
						<< selfVariableName]!

getClassesForInstanceVariable
	| definingClass typer types |
	definingClass := class whoDefinesInstanceVariable: variable.
	typer := RefactoryTyper newFor: self model.
	typer runOn: definingClass.
	types := typer typesFor: variable.
	types isEmpty ifTrue: [types := OrderedCollection with: (self model instanceClassFor: Object)].
	moveToClasses := self selectVariableTypesFrom: types selected: (typer guessTypesFor: variable).
	#rbFix.	"Use the abort signal rather than an error to avoid annoying message box"
	moveToClasses isNil ifTrue: [self refactoringAborted: 'Method not moved']!

getClassesForTemporaryVariable
	| types |
	types := RefactoryTyper
				typesFor: variable
				in: parseTree
				model: self model.
	types isEmpty ifTrue: [types := OrderedCollection with: (self model instanceClassFor: Object)].
	moveToClasses := self selectVariableTypesFrom: types selected: types.
	#rbFix.	"Use the abort signal rather than an error to avoid annoying message box"
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
			[type := self model classNamed: variable.
			type isNil ifTrue: [type := self model instanceClassFor: Object]]
		ifFalse: [type := definingClass typeOfClassVariable: variable].
	moveToClasses := self selectVariableTypesFrom: self getAllClassesForGlobalOrClassVariable
				selected: {type}.
	#rbFix.	"Use the abort signal rather than an error to avoid annoying message box"
	moveToClasses isNil ifTrue: [self refactoringAborted: 'Method not moved']!

getNewMethodName
	| parameters methodName newMethodName newSelector |
	parameters := OrderedCollection withAll: parseTree argumentNames.
	parameters remove: variable ifAbsent: nil.
	self needsToReplaceSelfReferences ifTrue: [parameters add: selfVariableName].
	methodName := RBMethodName selector: selector arguments: parameters.
	
	[| alreadyDefined |
	newMethodName := self requestNewMethodName: methodName forClasses: moveToClasses.
	newMethodName ifNil: [^self refactoringAborted].
	newMethodName isValid ifFalse: [^self refactoringError: 'Invalid method name'].
	newSelector := newMethodName selectorSymbol.
	alreadyDefined := moveToClasses detect: [:each | each hierarchyDefinesMethod: newSelector]
				ifNone: nil.
	alreadyDefined notNil and: [(self shouldOverride: newSelector in: class) not]]
			whileTrue.
	parseTree renameSelector: newSelector
		andArguments: (newMethodName arguments collect: [:each | StParameterNode named: each]) asArray!

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
	self hasOnlySelfReturns ifTrue: [searcher matches: '^self' do: [:aNode :answer | answer]].
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
		nextPutAll: ' selector: ';
		print: selector;
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
		compileDelegatorMethod!

verifyTemporaryVariableDoesNotOverride
	(parseTree allDefinedVariables includes: selfVariableName) ifTrue: [^false].
	^(moveToClasses anySatisfy: [:each | each definesVariable: selfVariableName]) not! !
!Refactory.Browser.MoveMethodRefactoring categoriesForMethods!
abstractVariables!public!transforming! !
abstractVariablesRefactoring!private!transforming! !
addSelfReturn!public!transforming! !
buildParseTree!private! !
checkAssignmentsToVariable!preconditions!public! !
checkForPrimitiveMethod!preconditions!public! !
checkForSuperReferences!preconditions!public! !
checkTemporaryVariableNames!preconditions!public! !
compileDelegatorMethod!public!transforming! !
compileNewMethods!public!transforming! !
getAllClassesForGlobalOrClassVariable!accessing!private! !
getArgumentNameForSelf!public!requests! !
getClassesForInstanceVariable!accessing!private! !
getClassesForTemporaryVariable!accessing!private! !
getClassesToMoveTo!accessing!private! !
getClassForGlobalOrClassVariable!accessing!private! !
getNewMethodName!public!requests! !
hasOnlySelfReturns!public!transforming! !
hasSelfReferences!public!testing! !
isMovingToArgument!public!testing! !
isMovingToInstVar!public!testing! !
needsToReplaceSelfReferences!public!testing! !
preconditions!preconditions!public! !
replaceSelfReferences!public!transforming! !
replaceVariableReferences!public!transforming! !
selector:class:variable:!initialize/release!public! !
storeOn:!printing!public! !
transform!public!transforming! !
verifyTemporaryVariableDoesNotOverride!public!transforming! !
!

!Refactory.Browser.MoveMethodRefactoring class methodsFor!

model: aRBModel selector: aSymbol class: aClass variable: aVariableName
	^self new
		model: aRBModel;
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
!Refactory.Browser.MoveMethodRefactoring class categoriesForMethods!
model:selector:class:variable:!instance creation!public! !
selector:class:variable:!instance creation!public! !
!

