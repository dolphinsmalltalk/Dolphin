"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring
	subclass: #'Refactory.Browser.ExtractMethodRefactoring'
	instanceVariableNames: 'selector extractionInterval extractedParseTree modifiedParseTree parameters needsReturn'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.ExtractMethodRefactoring guid: (Core.GUID fromString: '{f5ea0d09-686d-47ef-9a7d-72fe3bb4cbcc}')!

Refactory.Browser.ExtractMethodRefactoring comment: ''!

!Refactory.Browser.ExtractMethodRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.ExtractMethodRefactoring methodsFor!

checkAssignments: variableNames
	| node outsideVars removeAssigned readBeforeWritten |
	removeAssigned := variableNames copy.
	node := self placeholderNode.
	outsideVars := variableNames select: [:each | (node whoDefines: each) references: each].
	outsideVars size == 1
		ifTrue: 
			[self checkSingleAssignment: outsideVars asArray first
			"If the tree were not updated in place, we'd have to search for the placeholder node again here
			node := self placeholderNode"].
	outsideVars size > 1
		ifTrue: 
			[self refactoringError: 'Cannot extract assignment without all references: '
						, outsideVars asSortedArray displayString].
	removeAssigned removeAll: outsideVars.
	readBeforeWritten := RBReadBeforeWrittenTester readBeforeWritten: removeAssigned
				in: extractedParseTree.
	readBeforeWritten notEmpty
		ifTrue: 
			[self refactoringError: 'Cannot extract assignment if read before written: '
						, readBeforeWritten asSortedArray displayString].
	removeAssigned do: [:each | (node whoDefines: each) removeTemporaryNamed: each].
	self createTemporariesInExtractedMethodFor: variableNames!

checkReturn
	needsReturn := self placeholderNode isUsed.
	extractedParseTree containsReturn ifFalse: [^self].
	extractedParseTree lastIsReturn ifTrue: [^self].
	(modifiedParseTree isLast: self placeholderNode) 
		ifFalse: 
			[self refactoringError: 'Couldn''t extract code since it contains a return.'].
	self checkSelfReturns!

checkSelfReturns
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher
		matches: '^self' do: [:aNode :answer | answer];
		matches: '^`@anything' do: [:aNode :answer | true].
	(searcher executeTree: extractedParseTree initialAnswer: false)
		ifTrue: [self placeholderNode asReturn]!

checkSingleAssignment: varName
	((RBReadBeforeWrittenTester isVariable: varName readBeforeWrittenIn: extractedParseTree)
		or: [extractedParseTree containsReturn])
			ifTrue: 
				[self
					refactoringError: ('Cannot extract assignments to temporaries without all references (check ''<1s>'')'
							expandMacrosWith: varName)].
	extractedParseTree addNode: (StReturnNode value: (StVariableNode named: varName)).
	modifiedParseTree := ParseTreeRewriter
				replace: self methodDelimiter
				with: varName , ' := ' , self methodDelimiter
				in: modifiedParseTree!

checkSpecialExtractions
	| node |
	node := self placeholderNode parent.
	node isNil ifTrue: [^self].
	(node isAssignment and: [node variable = self placeholderNode]) ifTrue: 
			[self refactoringError: 'Cannot extract left hand side of an assignment'].
	node isCascade ifTrue: 
			[self refactoringError: 'Cannot extract first message of a cascaded message']!

checkTemporaries
	| temps accesses assigned |
	temps := self remainingTemporaries.
	accesses := temps select: [:each | extractedParseTree references: each].
	assigned := accesses select: [:each | extractedParseTree assigns: each].
	assigned notEmpty ifTrue: [self checkAssignments: assigned].
	^parameters := (accesses asOrderedCollection)
				removeAll: assigned;
				yourself!

createTemporariesInExtractedMethodFor: assigned 
	assigned do: [:each | extractedParseTree body addTemporaryNamed: each]!

existingSelector
	"Try to find an existing method instead of creating a new one"

	^class allSelectors detect: [:each | self isMethodEquivalentTo: each] ifNone: nil!

extract: anInterval from: aSelector in: aClass 
	#rbFix. "Ensure the displayString works when the model name is initialized"
	class := aClass.
	selector := aSelector.
	extractionInterval := anInterval.
	class := self classObjectFor: aClass.!

extractMethod
	| parseTree isSequence extractCode subtree newCode |
	extractCode := self getExtractedSource.
	extractedParseTree := Parser parseExpression: extractCode
				onError: [:string :pos | self refactoringError: 'Invalid source to extract'].
	extractedParseTree isNil ifTrue: [self refactoringError: 'Invalid source to extract'].
	(extractedParseTree isSequence and: [extractedParseTree statements isEmpty])
		ifTrue: [self refactoringError: 'Select some code to extract'].
	isSequence := extractedParseTree isSequence or: [extractedParseTree isReturn].
	extractedParseTree := StMethodNode
				selector: #value
				arguments: #()
				body: (extractedParseTree isSequence
						ifTrue: [extractedParseTree]
						ifFalse: [StSequenceNode temporaries: #() statements: (OrderedCollection with: extractedParseTree)]).
	extractedParseTree body temporaries notEmpty ifTrue: [extractedParseTree body temporaries: #()].
	extractedParseTree source: extractCode.
	parseTree := class parseTreeFor: selector.
	parseTree isNil ifTrue: [self refactoringError: 'Could not parse ' , selector printString].
	subtree := isSequence
				ifTrue: [ParseTreeSearcher treeMatchingStatements: extractedParseTree body formattedCode in: parseTree]
				ifFalse: [ParseTreeSearcher treeMatching: extractCode in: parseTree].
	subtree isNil ifTrue: [self refactoringError: 'Could not extract code from method'].
	"If the source method has a namespace annotation, we need to copy that over."
	(parseTree tags detect: [:each | each isAnnotation and: [each selector == #namespace:]] ifNone: [])
		ifNotNil: [:namespaceAnnotation | extractedParseTree tags: (extractedParseTree tags copyWith: namespaceAnnotation copy)].
	newCode := self methodDelimiter.
	isSequence
		ifTrue: 
			[| stmts |
			stmts := extractedParseTree body statements.
			stmts notEmpty
				ifTrue: 
					[stmts last isAssignment
						ifTrue: 
							[| name |
							name := stmts last variable name.
							(self shouldExtractAssignmentTo: name)
								ifFalse: 
									[newCode := '<1s> := <2s>' expandMacrosWith: name with: newCode.
									stmts at: stmts size put: stmts last value]]]].
	modifiedParseTree := isSequence
				ifTrue: 
					[ParseTreeRewriter
						replaceStatements: subtree formattedCode
						with: newCode
						in: parseTree
						onInterval: extractionInterval]
				ifFalse: 
					[ParseTreeRewriter
						replace: subtree formattedCode
						with: newCode
						in: parseTree
						onInterval: extractionInterval]!

getExtractedSource
	| source |
	source := class sourceCodeFor: selector.
	((extractionInterval first between: 1 and: source size) 
		and: [extractionInterval last between: 1 and: source size]) 
			ifFalse: [self refactoringError: 'Invalid interval'].
	^source copyFrom: extractionInterval first to: extractionInterval last!

getNewMethodName
	| methodName newMethodName newSelector |
	methodName := RBMethodName new.
	methodName arguments: parameters.
	
	[newMethodName := self requestNewMethodName: methodName forClasses: {class}.
	newMethodName isNil ifTrue: [^self refactoringAborted: 'Did not extract code'].
	newMethodName isValid ifFalse: [^self refactoringError: 'Invalid method name'].
	newSelector := newMethodName selector.
	(class hierarchyDefinesMethod: newSelector) and: [(self shouldOverride: newSelector in: class) not]]
			whileTrue.
	(class directlyDefinesMethod: newSelector)
		ifTrue: 
			["Adding a method that is already implemented in a superclass or subclass is one thing, replacing the definition of an existing method is quite another"
			^self refactoringError: '<1s> already implements <2p>' << {class unqualifiedName. newSelector}].
	parameters := newMethodName arguments asOrderedCollection.
	^newSelector!

isMethodEquivalentTo: aSelector
	selector == aSelector ifTrue: [^false].
	aSelector argumentCount ~~ parameters size ifTrue: [^false].
	(self isParseTreeEquivalentTo: aSelector) ifFalse: [^false].
	self reorderParametersToMatch: aSelector.
	^true!

isParseTreeEquivalentTo: aSelector
	| tree definingClass |
	definingClass := class whoDefinesMethod: aSelector.
	tree := definingClass parseTreeFor: aSelector.
	tree isNil ifTrue: [^false].
	tree isPrimitive ifTrue: [^false].
	(tree body equalTo: extractedParseTree body
		exceptForVariables: (tree arguments collect: [:each | each name])) ifFalse: [^false].
	(definingClass = class or: 
			[| superclass definingSuper |
			superclass := class superclass.
			definingSuper := definingClass superclass.
			tree superMessages allSatisfy: 
					[:each |
					(superclass whichClassIncludesSelector: aSelector)
						= (definingSuper whichClassIncludesSelector: each)]])
		ifFalse: [^false].
	^self shouldUseExistingMethod: aSelector!

methodDelimiter
	^'#''place.holder.for.method'''!

nameNewMethod: aSymbol
	| args newSend |
	args := parameters collect: [:each | StParameterNode named: each].
	extractedParseTree renameSelector: aSymbol andArguments: args asArray.
	aSymbol argumentCount = 0
		ifTrue: 
			[modifiedParseTree := ParseTreeRewriter
						replace: self methodDelimiter
						with: 'self ' , aSymbol asString
						in: modifiedParseTree.
			^self].
	newSend := WriteStream on: String new.
	aSymbol keywords with: parameters
		do: 
			[:key :arg |
			newSend
				nextPutAll: key asString;
				nextPut: $\x20;
				nextPutAll: arg asString;
				nextPut: $\x20].
	modifiedParseTree := ParseTreeRewriter
				replace: self methodDelimiter
				with: 'self ' , newSend contents
				in: modifiedParseTree!

placeholderNode
	| node |
	node := ParseTreeSearcher treeMatching: self methodDelimiter in: modifiedParseTree.
	node ifNil: [self refactoringError: 'Cannot extract code'].
	^node!

preconditions
	^(RBCondition definesSelector: selector in: class) 
		& (RBCondition withBlock: 
					[self extractMethod.
					self checkSpecialExtractions.
					self checkReturn.
					needsReturn ifTrue: [extractedParseTree addReturn].
					self checkTemporaries.
					true])!

remainingTemporaries
	| temps |
	temps := modifiedParseTree allDefinedVariables asSet.
	extractedParseTree allDefinedVariables do: [:each | temps remove: each ifAbsent: nil].
	^temps!

reorderParametersToMatch: aSelector
	| tree dictionary |
	tree := class parseTreeFor: aSelector.
	dictionary := Dictionary new.
	tree body equalTo: extractedParseTree body withMapping: dictionary.
	parameters := tree arguments collect: 
					[:each |
					dictionary at: each name
						ifAbsent: [self refactoringError: 'An internal error occured, please report this error.']]!

shouldUseExistingMethod: aSymbol
	^(self lookupOption: #useExistingMethod) cull: self cull: aSymbol!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' extract: '.
	extractionInterval storeOn: aStream.
	aStream
		nextPutAll: ' from: ';
		print: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	| existingSelector sourceMethod |
	existingSelector := self existingSelector.
	self nameNewMethod: (existingSelector ifNil: [self getNewMethodName]).
	sourceMethod := class methodFor: selector.
	existingSelector
		ifNil: 
			["Creating a new method, as opposed to an extract where there was an existing match to use. We want the new method to be in the same package and namespace as the source method"
			class
				compile: extractedParseTree newSource
				environment: sourceMethod parseEnvironment
				categories: sourceMethod categories
				package: sourceMethod owningPackageIfLoose].
	model compileTree: modifiedParseTree forMethod: sourceMethod! !

!Refactory.Browser.ExtractMethodRefactoring categoriesForMethods!
checkAssignments:!public!transforming! !
checkReturn!public!transforming! !
checkSelfReturns!public!transforming! !
checkSingleAssignment:!public!transforming! !
checkSpecialExtractions!public!transforming! !
checkTemporaries!public!transforming! !
createTemporariesInExtractedMethodFor:!public!transforming! !
existingSelector!public!transforming! !
extract:from:in:!initialize/release!public! !
extractMethod!public!transforming! !
getExtractedSource!public!transforming! !
getNewMethodName!public!requests! !
isMethodEquivalentTo:!public!transforming! !
isParseTreeEquivalentTo:!public!transforming! !
methodDelimiter!public!transforming! !
nameNewMethod:!public!transforming! !
placeholderNode!public!transforming! !
preconditions!preconditions!public! !
remainingTemporaries!public!transforming! !
reorderParametersToMatch:!public!transforming! !
shouldUseExistingMethod:!public!requests! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.ExtractMethodRefactoring class methodsFor!

extract: anInterval from: aSelector in: aClass 
	^self new
		extract: anInterval
		from: aSelector
		in: aClass!

model: aRBModel extract: anInterval from: aSelector in: aClass
	^self new
		model: aRBModel;
		extract: anInterval
			from: aSelector
			in: aClass;
		yourself! !

!Refactory.Browser.ExtractMethodRefactoring class categoriesForMethods!
extract:from:in:!instance creation!public! !
model:extract:from:in:!instance creation!public! !
!

