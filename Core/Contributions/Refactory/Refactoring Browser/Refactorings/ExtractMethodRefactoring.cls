"Filed out from Dolphin Smalltalk"!

MethodRefactoring subclass: #ExtractMethodRefactoring
	instanceVariableNames: 'selector extractionInterval extractedParseTree modifiedParseTree parameters needsReturn'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExtractMethodRefactoring guid: (GUID fromString: '{f5ea0d09-686d-47ef-9a7d-72fe3bb4cbcc}')!

ExtractMethodRefactoring comment: ''!

!ExtractMethodRefactoring categoriesForClass!Refactory-Refactorings! !

!ExtractMethodRefactoring methodsFor!

checkAssignments: variableNames 
	| node outsideVars removeAssigned readBeforeWritten |
	removeAssigned := variableNames copy.
	node := self placeholderNode.
	outsideVars := variableNames select: [:each | (node whoDefines: each) references: each].
	outsideVars size == 1 ifTrue: [self checkSingleAssignment: outsideVars asArray first].
	outsideVars size > 1 
		ifTrue: 
			[self refactoringError: 'Cannot extract assignment without all references: ' 
						, outsideVars asSortedCollection asArray displayString].
	removeAssigned removeAll: outsideVars.
	readBeforeWritten := RBReadBeforeWrittenTester readBeforeWritten: removeAssigned
				in: extractedParseTree.
	readBeforeWritten notEmpty 
		ifTrue: 
			[self refactoringError: 'Cannot extract assignment if read before written: ' 
						, readBeforeWritten asSortedCollection asArray displayString].
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
	extractedParseTree addNode: (RBReturnNode value: (RBVariableNode named: varName)).
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

	^class allSelectors detect: [:each | self isMethodEquivalentTo: each]
		ifNone: [nil]!

extract: anInterval from: aSelector in: aClass 
	#rbFix. "Ensure the displayString works when the model name is initialized"
	class := aClass.
	selector := aSelector.
	extractionInterval := anInterval.
	class := self classObjectFor: aClass.!

extractMethod
	| parseTree isSequence extractCode subtree newCode |
	extractCode := self getExtractedSource.
	extractedParseTree := RBParser parseExpression: extractCode
				onError: [:string :pos | self refactoringError: 'Invalid source to extract'].
	extractedParseTree isNil ifTrue: [self refactoringError: 'Invalid source to extract'].
	(extractedParseTree isSequence and: [extractedParseTree statements isEmpty]) 
		ifTrue: [self refactoringError: 'Select some code to extract'].
	isSequence := extractedParseTree isSequence or: [extractedParseTree isReturn].
	extractedParseTree := RBMethodNode 
				selector: #value
				arguments: #()
				body: (extractedParseTree isSequence 
						ifTrue: [extractedParseTree]
						ifFalse: 
							[RBSequenceNode temporaries: #() statements: (OrderedCollection with: extractedParseTree)]).
	extractedParseTree body temporaries notEmpty 
		ifTrue: [extractedParseTree body temporaries: #()].
	extractedParseTree source: extractCode.
	parseTree := class parseTreeFor: selector.
	parseTree isNil 
		ifTrue: [self refactoringError: 'Could not parse ' , selector printString].
	subtree := isSequence 
				ifTrue: 
					[ParseTreeSearcher treeMatchingStatements: extractedParseTree body formattedCode
						in: parseTree]
				ifFalse: [ParseTreeSearcher treeMatching: extractCode in: parseTree].
	subtree isNil ifTrue: [self refactoringError: 'Could not extract code from method'].
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
	| newSelector methodName newMethodName |
	methodName := RBMethodName new.
	methodName arguments: parameters.
	
	[newMethodName := self requestMethodNameFor: methodName.
	newMethodName isNil 
		ifTrue: [^self refactoringAborted: 'Did not extract code'].
	newSelector := newMethodName selector.
	(self checkMethodName: newSelector in: class) 
		ifFalse: 
			[self refactoringWarning: newSelector , ' is not a valid selector name.'.
			newSelector := nil].
	(class hierarchyDefinesMethod: newSelector asSymbol) 
		ifTrue: 
			[(self shouldOverride: newSelector in: class) ifFalse: [newSelector := nil]].
	newSelector isNil] 
			whileTrue: [].
	parameters := newMethodName arguments asOrderedCollection.
	^newSelector asSymbol!

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
			[tree superMessages allSatisfy: 
					[:each | 
					(class superclass whichClassIncludesSelector: aSelector) 
						= (definingClass superclass whichClassIncludesSelector: each)]]) 
		ifFalse: [^false].
	^self shouldUseExistingMethod: aSelector!

methodDelimiter
	^'#''place.holder.for.method'''!

nameNewMethod: aSymbol 
	| args newSend |
	args := parameters collect: [:each | RBVariableNode named: each].
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
				nextPut: $ ;
				nextPutAll: arg asString;
				nextPut: $ ].
	modifiedParseTree := ParseTreeRewriter 
				replace: self methodDelimiter
				with: 'self ' , newSend contents
				in: modifiedParseTree!

placeholderNode
	| node |
	node := ParseTreeSearcher treeMatching: self methodDelimiter
				in: modifiedParseTree.
	node isNil ifTrue: [self refactoringError: 'Cannot extract code'].
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
	extractedParseTree allDefinedVariables 
		do: [:each | temps remove: each ifAbsent: []].
	^temps!

reorderParametersToMatch: aSelector 
	| tree dictionary |
	tree := class parseTreeFor: aSelector.
	dictionary := Dictionary new.
	tree body equalTo: extractedParseTree body withMapping: dictionary.
	parameters := tree arguments collect: 
					[:each | 
					dictionary at: each name
						ifAbsent: 
							[self 
								refactoringError: 'An internal error occured, please report this error.']]!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' extract: '.
	extractionInterval storeOn: aStream.
	aStream
		nextPutAll: ' from: #';
		nextPutAll: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	| existingSelector |
	existingSelector := self existingSelector.
	self nameNewMethod: (existingSelector isNil 
				ifTrue: [self getNewMethodName]
				ifFalse: [existingSelector]).
	existingSelector isNil 
		ifTrue: 
			[| change |
			#rbFix.	"Bodge the change object to ensure the new method is in the same package as the source method"
			change := class compile: extractedParseTree newSource
						classified: (class protocolsFor: selector).
			class realClass ifNotNil: 
					[:c | 
					(c compiledMethodAt: selector ifAbsent: []) 
						ifNotNil: [:m | change package: m owningPackage]]].
	class compileTree: modifiedParseTree! !

!ExtractMethodRefactoring categoriesForMethods!
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
getNewMethodName!public!transforming! !
isMethodEquivalentTo:!public!transforming! !
isParseTreeEquivalentTo:!public!transforming! !
methodDelimiter!public!transforming! !
nameNewMethod:!public!transforming! !
placeholderNode!public!transforming! !
preconditions!preconditions!public! !
remainingTemporaries!public!transforming! !
reorderParametersToMatch:!public!transforming! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!ExtractMethodRefactoring class methodsFor!

extract: anInterval from: aSelector in: aClass 
	^self new
		extract: anInterval
		from: aSelector
		in: aClass!

model: aRBNamespace extract: anInterval from: aSelector in: aClass 
	^(self new)
		model: aRBNamespace;
		extract: anInterval
			from: aSelector
			in: aClass;
		yourself! !

!ExtractMethodRefactoring class categoriesForMethods!
extract:from:in:!instance creation!public! !
model:extract:from:in:!instance creation!public! !
!

