"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring subclass: #'Refactory.Browser.InlineMethodRefactoring'
	instanceVariableNames: 'sourceInterval inlineParseTree sourceParseTree sourceSelector sourceMessage inlineClass method'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.InlineMethodRefactoring guid: (Core.GUID fromString: '{a2564755-9eb0-4805-9bf7-edbb2fcf1995}')!
Refactory.Browser.InlineMethodRefactoring comment: ''!
!Refactory.Browser.InlineMethodRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.InlineMethodRefactoring methodsFor!

addSelfReturn
	inlineParseTree addSelfReturn!

addTemporary: sourceNode assignedTo: replacementNode 
	| newName |
	newName := self renameConflictingTemporary: sourceNode name.
	(inlineParseTree body)
		addTemporaryNamed: newName;
		addNodeFirst: (StAssignmentNode variable: (StVariableNode named: newName)
					value: replacementNode)!

checkSuperMessages
	| inlineSuper superclass |
	self inlineClass = class ifTrue: [^self].
	inlineSuper := self inlineClass superclass.
	inlineSuper isNil ifTrue: [^self].
	superclass := class superclass.
	inlineParseTree superMessages do: 
			[:each |
			(inlineSuper whoDefinesMethod: each) = (superclass whoDefinesMethod: each)
				ifFalse: 
					[self
						refactoringError: ('Cannot inline method since it sends a super message <1s> that is overridden'
								expandMacrosWith: each)]]!

chosenInlineClass
	^class!

compileMethod
	model compileTree: sourceParseTree forMethod: method!

findSelectedMessage
	self findSelectedMessageCommon.
	(sourceMessage receiver isSelfVariable or: [sourceMessage receiver isSuperVariable])
		ifFalse: [self refactoringError: 'Cannot inline non-self messages']!

findSelectedMessageCommon
	"Private - "

	method := class methodFor: sourceSelector.
	sourceParseTree := method parseTreeWithSourceIntervals.
	sourceParseTree ifNil: [^self refactoringError: 'Could not parse sources'].
	"Because we may be inlining a method into itself, we have to work with a copy of the source parse tree"
	sourceParseTree := sourceParseTree copy.
	sourceMessage := sourceParseTree whichNodeIsContainedBy: sourceInterval.
	(sourceMessage isNil or: 
			[sourceMessage isCascade ifTrue: [sourceMessage := sourceMessage messages last].
			sourceMessage isMessage not])
		ifTrue: [self refactoringError: 'The selection doesn''t appear to be a message send']!

hasMultipleReturns
	"Do we have multiple returns? If the last statement isn't a return, then we have an implicit return of self."

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '^``@object'
		do: 
			[:aNode :hasAReturn |
			hasAReturn ifTrue: [^true].
			true].
	searcher executeTree: inlineParseTree initialAnswer: inlineParseTree lastIsReturn not.
	^false!

inline: anInterval inMethod: aSelector forClass: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	sourceSelector := aSelector.
	sourceInterval := anInterval.
	class := self classObjectFor: aClass.
!

inlineClass
	^inlineClass isNil 
		ifTrue: 
			[inlineClass := (sourceMessage receiver name = 'super' 
						ifTrue: [class superclass]
						ifFalse: [class]) whoDefinesMethod: self inlineSelector]
		ifFalse: [inlineClass]!

inlineSelector
	sourceMessage isNil ifTrue: [self findSelectedMessage].
	^sourceMessage selector!

inlineSourceReplacing: aParseTree
	| statements nodeUnderSequence |
	statements := inlineParseTree body statements.
	(statements size > 1 and: [aParseTree isEvaluatedFirst not])
		ifTrue: 
			[(self shouldInlineReordered: (self inlineClass methodFor: self inlineSelector)
				into: (class methodFor: sourceSelector)) ifFalse: [self refactoringAborted]].
	nodeUnderSequence := aParseTree.
	[nodeUnderSequence parent isSequence] whileFalse: [nodeUnderSequence := nodeUnderSequence parent].
	nodeUnderSequence parent
		addNodes: (statements copyFrom: 1 to: (statements size - 1 max: 0)) before: nodeUnderSequence;
		addTemporariesNamed: inlineParseTree body temporaryNames.
	aParseTree
		replaceWith: (statements isEmpty ifTrue: [StSelfVariableNode start: 0] ifFalse: [statements last])!

insertInlinedMethod
	| node |
	node := sourceMessage.
	self moveComments.
	node parent isCascade 
		ifTrue: 
			[self rewriteCascadedMessage.
			node := node parent].
	node parent isReturn 
		ifTrue: [node := node parent]
		ifFalse: [self removeReturns].
	self replaceArguments.
	self inlineSourceReplacing: node.
	sourceParseTree removeDeadCode.
	self removeEmptyIfTrues.
	self removeImmediateBlocks!

isOverridden
	^self chosenInlineClass subclassRedefines: self inlineSelector!

isPrimitive
	^inlineParseTree isPrimitive!

moveComments
	inlineParseTree nodesDo: 
			[:each | 
			each 
				comments: (each comments collect: 
							[:anInterval | 
							| start stop source |
							source := sourceParseTree source.
							start := source size + 1.
							source := source 
										, (inlineParseTree source copyFrom: anInterval first to: anInterval last).
							stop := source size.
							sourceParseTree source: source.
							start to: stop])]!

normalizeIfTrues
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: '| `@temps | ``@.s1. ``@boolean ifTrue: [| `@t1 | ``@.Stmts1. ^`@r1]. ``@.s2. ^``@r2'
			with: '| `@temps | ``@.s1. ``@boolean ifTrue: [| `@t1 | ``@.Stmts1. ^`@r1] ifFalse: [``@.s2. ^``@r2]';
		replace: '| `@temps | ``@.s1. ``@boolean ifFalse: [| `@t1 | ``@.Stmts1. ^`@r1]. ``@.s2. ^``@r2'
			with: '| `@temps | ``@.s1. ``@boolean ifTrue: [``@.s2. ^``@r2] ifFalse: [| `@t1 | ``@.Stmts1. ^`@r1]'.
	[rewriter executeTree: inlineParseTree] whileTrue: [inlineParseTree := rewriter tree]!

normalizeReturns
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: '^``@boolean ifTrue: [| `@t1 | `@.Stmts1. ^``@r1] ifFalse: [| `@t2 | `@.Stmts2. ^``@r2]'
			with: '^``@boolean ifTrue: [| `@t1 | `@.Stmts1. ``@r1] ifFalse: [| `@t2 | `@.Stmts2. ``@r2]';
		replace: '^``@boolean ifFalse: [| `@t1 | `@.Stmts1. ^``@r1] ifTrue: [| `@t2 | `@.Stmts2. ^``@r2]'
			with: '^``@boolean ifFalse: [| `@t1 | `@.Stmts1. ``@r1] ifTrue: [| `@t2 | `@.Stmts2. ``@r2]';
		replace: '^``@boolean ifTrue: [| `@t1 | `@.Stmts1. ``@r1] ifFalse: [| `@t2 | `@.Stmts2. ^``@r2]'
			with: '^``@boolean ifTrue: [| `@t1 | `@.Stmts1. ``@r1] ifFalse: [| `@t2 | `@.Stmts2. ``@r2]';
		replace: '^``@boolean ifFalse: [| `@t1 | `@.Stmts1. ``@r1] ifTrue: [| `@t2 | `@.Stmts2. ^``@r2]'
			with: '^``@boolean ifFalse: [| `@t1 | `@.Stmts1. ``@r1] ifTrue: [| `@t2 | `@.Stmts2. ``@r2]';
		replace: '^``@boolean ifTrue: [| `@t1 | `@.Stmts1. ^``@r1] ifFalse: [| `@t2 | `@.Stmts2. ``@r2]'
			with: '^``@boolean ifTrue: [| `@t1 | `@.Stmts1. ``@r1] ifFalse: [| `@t2 | `@.Stmts2. ``@r2]';
		replace: '^``@boolean ifFalse: [| `@t1 | `@.Stmts1. ^``@r1] ifTrue: [| `@t2 | `@.Stmts2. ``@r2]'
			with: '^``@boolean ifFalse: [| `@t1 | `@.Stmts1. ``@r1] ifTrue: [| `@t2 | `@.Stmts2. ``@r2]';
		replace: '``@boolean ifTrue: [| `@t1 | `@.Stmts1. ^``@r1] ifFalse: [| `@t2 | `@.Stmts2. ^``@r2]'
			with: '^``@boolean ifTrue: [| `@t1 | `@.Stmts1. ``@r1] ifFalse: [| `@t2 | `@.Stmts2. ``@r2]';
		replace: '``@boolean ifFalse: [| `@t1 | `@.Stmts1. ^``@r1] ifTrue: [| `@t2 | `@.Stmts2. ^``@r2]'
			with: '^``@boolean ifFalse: [| `@t1 | `@.Stmts1. ``@r1] ifTrue: [| `@t2 | `@.Stmts2. ``@r2]'.
	[rewriter executeTree: inlineParseTree] whileTrue: [inlineParseTree := rewriter tree]!

parseInlineMethod
	self inlineClass isNil
		ifTrue: 
			[self
				refactoringError: ('<1p> or its superclasses don''t contain method <2s>' expandMacrosWith: class
						with: self inlineSelector)].
	inlineParseTree := self inlineClass parseTreeFor: self inlineSelector.
	inlineParseTree isNil ifTrue: [self refactoringError: 'Could not parse sources'].
	inlineParseTree lastIsReturn ifFalse: [inlineParseTree addSelfReturn]!

preconditions
	^(RBCondition definesSelector: sourceSelector in: class)
		& (RBCondition withBlock: 
					[self findSelectedMessage.
					#rbFix.	"Re-order parseInlineMethod and isOverridden check, since want to first check if 
							the method to be inlined is actually defined in the class into which it is to be inlined."
					self parseInlineMethod.
					self isOverridden
						ifTrue: 
							[(self shouldInlineOverriddenMethod: self inlineSelector of: self inlineClass)
								ifFalse: [self refactoringAborted]].
					self isPrimitive ifTrue: [self refactoringError: 'Cannot inline primitives'].
					self checkSuperMessages.
					self rewriteInlinedTree.
					(sourceMessage parent isReturn or: [self hasMultipleReturns not])
						ifFalse: 
							[self
								refactoringError: 'Cannot inline method since it contains multiple returns that cannot be rewritten'].
					true])!

removeEmptyIfTrues
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: '``@boolean ifTrue: [] ifFalse: [| `@temps | ``@.Stmts]'
			with: '``@boolean ifFalse: [|`@temps | ``@.Stmts]';
		replace: '``@boolean ifFalse: [] ifTrue: [| `@temps | ``@.Stmts]'
			with: '``@boolean ifTrue: [|`@temps | ``@.Stmts]';
		replace: '``@boolean ifTrue: [| `@temps | ``@.Stmts] ifFalse: []'
			with: '``@boolean ifTrue: [|`@temps | ``@.Stmts]';
		replace: '``@boolean ifFalse: [| `@temps | ``@.Stmts] ifTrue: []'
			with: '``@boolean ifFalse: [|`@temps | ``@.Stmts]'.
	(rewriter executeTree: sourceParseTree) ifTrue: [sourceParseTree := rewriter tree]!

removeImmediateBlocks
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: '[^``@object] value'
			with: '``.object'
			when: [:aNode | aNode parent isSequence];
		replace: '[``.object `{:node | node isReturn not}] value'
			with: '``.object'
			when: [:aNode | aNode parent isCascade not].
	rewriter replace: '| `@temps | ``@.Stmts1. [| `@bTemps | ``@.bStmts] value. ``@.Stmts2'
		with: '| `@temps `@bTemps | ``@.Stmts1. ``@.bStmts. ``@.Stmts2'.
	(rewriter executeTree: sourceParseTree) ifTrue: [sourceParseTree := rewriter tree]!

removeReturns
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter replace: '^``@object' with: '``@object'.
	(rewriter executeTree: inlineParseTree) ifTrue: [inlineParseTree := rewriter tree]!

renameConflictingTemporaries
	inlineParseTree allDefinedVariables 
		do: [:each | self renameConflictingTemporary: each]!

renameConflictingTemporary: aName
	| allNames newName index seqNode |
	allNames := Set new
				addAll: inlineParseTree allDefinedVariables;
				yourself.
	allNames remove: aName ifAbsent: nil.
	seqNode := sourceMessage.
	[seqNode isSequence] whileFalse: [seqNode := seqNode parent].
	allNames addAll: seqNode allDefinedVariables.	"Add those variables defined in blocks. This might cause a few 
													variables to be renamed that don't need to be, but this should be safe."
	newName := aName.
	index := 0.
	
	[(sourceMessage whoDefines: newName) notNil
		or: [(class hierarchyDefinesVariable: newName) or: [allNames includes: newName]]]
			whileTrue: 
				[index := index + 1.
				newName := aName , index printString].
	newName = aName ifFalse: [self renameTemporary: aName to: newName].
	^newName!

renameTemporary: oldName to: newName
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: oldName with: newName;
		replaceArgument: oldName with: newName.
	(rewriter executeTree: inlineParseTree) ifTrue: [inlineParseTree := rewriter tree]!

replaceArgument: sourceNode with: replacementNode
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter replaceTree: sourceNode withTree: replacementNode.
	(rewriter executeTree: inlineParseTree body) ifTrue: [inlineParseTree body: rewriter tree]!

replaceArguments
	sourceMessage arguments reverse with: inlineParseTree arguments reverse
		do: 
			[:replacement :source | 
			(replacement isImmediateNode or: [self shouldInlineExpression: replacement newSource]) 
				ifTrue: [self replaceArgument: source with: replacement]
				ifFalse: [self addTemporary: source assignedTo: replacement]]!

requestImplementorToInline: implementorsCollection
	^(self lookupOption: #implementorToInline) cull: self cull: implementorsCollection!

rewriteCascadedMessage
	| index messages |
	messages := sourceMessage parent messages.
	index := (1 to: messages size) detect: [:i | sourceMessage == (messages at: i)] ifNone: 0.
	inlineParseTree body addNodesFirst: (messages copyFrom: 1 to: index - 1).
	self removeReturns.
	inlineParseTree body addNodes: (messages copyFrom: index + 1 to: messages size).
	inlineParseTree addReturn!

rewriteInlinedTree
	sourceMessage parent isReturn 
		ifTrue: 
			[(sourceParseTree isLast: sourceMessage parent) 
				ifFalse: [self addSelfReturn]]
		ifFalse: 
			[self
				writeGuardClauses;
				normalizeIfTrues;
				normalizeReturns;
				addSelfReturn]!

shouldInlineExpression: aString
	"This option replaces use of a RefactoringWarning in Dolphin 8 for prompts as to whether expressions that were arguments to the method being inlined should be inlined into the resulting code, or assigned to a a temporary. Note that the 'inline' choice is not guaranteed to preserve behaviour, e.g. if the expression being inlined has side effects so executing it more than once will behave differently that the original code. The richer prompt that this option provides explains this.."

	^(self lookupOption: #inlineExpression) cull: self cull: aString!

shouldInlineOverriddenMethod: aSymbol of: aClass
	"This option replaces use of a RefactoringWarning in Dolphin 8 for inlines of overridden methods, allowing for a more informative message and allowing the user the option to proceed with the refactoring even when not behaviour preserving (i.e. not a true refactoring)."

	^(self lookupOption: #inlineOverridden)
		cull: self
		cull: aSymbol
		cull: aClass!

shouldInlineReordered: inlineRBMethod into: intoRBMethod
	"This option replaces use of a RefactoringWarning in Dolphin 8 for inlines of argument message-expressions where some statements from the inline will need to be placed before the message to which the message-expression forms an argument. It allows for a much more informative message with some help to try and understand the (rather complex) question."

	^(self lookupOption: #inlineReordered)
		cull: self
		cull: inlineRBMethod
		cull: intoRBMethod!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' inline: '.
	sourceInterval storeOn: aStream.
	aStream
		nextPutAll: ' inMethod: ';
		print: sourceSelector;
		nextPutAll: ' forClass: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		renameConflictingTemporaries;
		insertInlinedMethod;
		compileMethod!

writeGuardClauses
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replaceMethod: '`@methodName: `@args | `@temps | `@.s1. `@boolean ifTrue: [| `@t1 | `@.Stmts1. ^`@r1]. `@.s2. ^`@r2'
			with: '`@methodName: `@args | `@temps | `@.s1. `@boolean ifTrue: [| `@t1 | `@.Stmts1. ^`@r1] ifFalse: [`@.s2. ^`@r2]';
		replaceMethod: '`@methodName: `@args | `@temps | `@.s1. `@boolean ifFalse: [| `@t1 | `@.Stmts1. ^`@r1]. `@.s2. ^`@r2'
			with: '`@methodName: `@args | `@temps | `@.s1. `@boolean ifTrue: [`@.s2. ^`@r2] ifFalse: [| `@t1 | `@.Stmts1. ^`@r1]';
		replaceMethod: '`@methodName: `@args | `@temps | `@.s1. `@boolean ifTrue: [| `@t1 | `@.Stmts1. ^`@r1]. `@.s2'
			with: '`@methodName: `@args | `@temps | `@.s1. `@boolean ifTrue: [| `@t1 | `@.Stmts1. ^`@r1] ifFalse: [`@.s2. ^self]';
		replaceMethod: '`@methodName: `@args | `@temps | `@.s1. `@boolean ifFalse: [| `@t1 | `@.Stmts1. ^`@r1]. `@.s2'
			with: '`@methodName: `@args | `@temps | `@.s1. `@boolean ifTrue: [`@.s2. ^self] ifFalse: [| `@t1 | `@.Stmts1. ^`@r1]'.
	[rewriter executeTree: inlineParseTree] whileTrue: [inlineParseTree := rewriter tree]! !
!Refactory.Browser.InlineMethodRefactoring categoriesForMethods!
addSelfReturn!public!transforming! !
addTemporary:assignedTo:!public!transforming! !
checkSuperMessages!public!transforming! !
chosenInlineClass!accessing!public! !
compileMethod!public!transforming! !
findSelectedMessage!public!transforming! !
findSelectedMessageCommon!private!transforming! !
hasMultipleReturns!public!testing! !
inline:inMethod:forClass:!initialize/release!private! !
inlineClass!public!transforming! !
inlineSelector!public!transforming! !
inlineSourceReplacing:!public!transforming! !
insertInlinedMethod!public!transforming! !
isOverridden!public!testing! !
isPrimitive!public!testing! !
moveComments!public!transforming! !
normalizeIfTrues!public!transforming! !
normalizeReturns!public!transforming! !
parseInlineMethod!public!transforming! !
preconditions!preconditions!public! !
removeEmptyIfTrues!public!transforming! !
removeImmediateBlocks!public!transforming! !
removeReturns!public!transforming! !
renameConflictingTemporaries!public!transforming! !
renameConflictingTemporary:!public!transforming! !
renameTemporary:to:!public!transforming! !
replaceArgument:with:!public!transforming! !
replaceArguments!public!transforming! !
requestImplementorToInline:!public!requests! !
rewriteCascadedMessage!public!transforming! !
rewriteInlinedTree!public!transforming! !
shouldInlineExpression:!public!requests! !
shouldInlineOverriddenMethod:of:!preconditions!public! !
shouldInlineReordered:into:!public!requests! !
storeOn:!printing!public! !
transform!public!transforming! !
writeGuardClauses!public!transforming! !
!

!Refactory.Browser.InlineMethodRefactoring class methodsFor!

inline: anInterval inMethod: aSelector forClass: aClass 
	^self new 
		inline: anInterval
		inMethod: aSelector
		forClass: aClass!

model: aRBModel inline: anInterval inMethod: aSelector forClass: aClass
	^self new
		model: aRBModel;
		inline: anInterval
			inMethod: aSelector
			forClass: aClass;
		yourself! !
!Refactory.Browser.InlineMethodRefactoring class categoriesForMethods!
inline:inMethod:forClass:!instance creation!public! !
model:inline:inMethod:forClass:!instance creation!public! !
!

