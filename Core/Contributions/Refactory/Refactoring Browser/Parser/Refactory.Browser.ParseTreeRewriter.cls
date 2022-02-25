"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ParseTreeSearcher subclass: #'Refactory.Browser.ParseTreeRewriter'
	instanceVariableNames: 'tree'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ParseTreeRewriter guid: (Core.GUID fromString: '{e902bffe-805d-4946-b0ea-0e7501c75c73}')!
Refactory.Browser.ParseTreeRewriter comment: 'ParseTreeRewriter walks over and transforms its BRProgramNode (tree). If the tree is modified, then answer is set to true, and the modified tree can be retrieved by the #tree method.

Instance Variables:
	tree	<BRProgramNode>	the parse tree we''re transforming'!
!Refactory.Browser.ParseTreeRewriter categoriesForClass!Refactory-ParseTree Matching! !
!Refactory.Browser.ParseTreeRewriter methodsFor!

executeTree: aParseTree
	answer := false.
	tree := self basicExecuteTree: aParseTree.
	^answer!

foundMatch
	answer := true!

lookForMoreMatchesInContext: oldContext
	oldContext keysAndValuesDo: 
			[:key :value |
			(key isString not and: [key recurseInto])
				ifTrue: [oldContext at: key put: (value collect: [:each | self visitNode: each])]]!

replace: searchString with: replaceString
	self addRule: (RBStringReplaceRule searchFor: searchString replaceWith: replaceString)!

replace: searchString with: replaceString when: aBlock
	self addRule: (RBStringReplaceRule
				searchFor: searchString
				replaceWith: replaceString
				when: aBlock)!

replace: searchString withValueFrom: replaceBlock
	self addRule: (RBBlockReplaceRule searchFor: searchString replaceWith: replaceBlock)!

replace: searchString withValueFrom: replaceBlock when: conditionBlock
	self addRule: (RBBlockReplaceRule
				searchFor: searchString
				replaceWith: replaceBlock
				when: conditionBlock)!

replaceArgument: searchString with: replaceString
	self addArgumentRule: (RBStringReplaceRule searchFor: searchString replaceWith: replaceString)!

replaceArgument: searchString with: replaceString when: aBlock
	self addArgumentRule: (RBStringReplaceRule
				searchFor: searchString
				replaceWith: replaceString
				when: aBlock)!

replaceArgument: searchString withValueFrom: replaceBlock
	self addArgumentRule: (RBBlockReplaceRule searchFor: searchString replaceWith: replaceBlock)!

replaceArgument: searchString withValueFrom: replaceBlock when: conditionBlock
	self addArgumentRule: (RBBlockReplaceRule
				searchFor: searchString
				replaceWith: replaceBlock
				when: conditionBlock)!

replaceLiteral: literal with: newLiteral
	self replaceTree: (StLiteralNode value: literal) withTree: (StLiteralNode value: newLiteral)!

replaceMethod: searchString with: replaceString
	self addRule: (RBStringReplaceRule searchForMethod: searchString replaceWith: replaceString)!

replaceMethod: searchString with: replaceString when: aBlock
	self addRule: (RBStringReplaceRule
				searchForMethod: searchString
				replaceWith: replaceString
				when: aBlock)!

replaceMethod: searchString withValueFrom: replaceBlock
	self addRule: (RBBlockReplaceRule searchForMethod: searchString replaceWith: replaceBlock)!

replaceMethod: searchString withValueFrom: replaceBlock when: conditionBlock
	self addRule: (RBBlockReplaceRule
				searchForMethod: searchString
				replaceWith: replaceBlock
				when: conditionBlock)!

replaceTree: searchTree withTree: replaceTree
	self addRule: (RBStringReplaceRule searchForTree: searchTree replaceWith: replaceTree)!

replaceTree: searchTree withTree: replaceTree when: aBlock
	self addRule: (RBStringReplaceRule
				searchForTree: searchTree
				replaceWith: replaceTree
				when: aBlock)!

replaceTree: searchTree withValueFrom: replaceBlock
	self addRule: (RBBlockReplaceRule searchForTree: searchTree replaceWith: replaceBlock)!

tree
	^tree!

visitAnnotationNode: aStAnnotationNode
	aStAnnotationNode arguments: (aStAnnotationNode arguments collect: [:arg | self visitNode: arg]).
	^aStAnnotationNode!

visitArgumentNodes: aNodeCollection
	^aNodeCollection collect: [:each | self visitArgumentNode: each]!

visitArrayNode: anArrayNode
	anArrayNode statements: (anArrayNode statements collect: [:each | self visitNode: each]).
	^anArrayNode!

visitAssignmentNode: anAssignmentNode
	anAssignmentNode variable: (self visitNode: anAssignmentNode variable).
	anAssignmentNode value: (self visitNode: anAssignmentNode value).
	^anAssignmentNode!

visitBlockNode: aBlockNode
	aBlockNode arguments: (self visitArgumentNodes: aBlockNode arguments).
	aBlockNode body: (self visitNode: aBlockNode body).
	^aBlockNode!

visitCascadeNode: aCascadeNode
	| newMessages notFound count |
	count := aCascadeNode messages size.
	newMessages := OrderedCollection new: count.
	notFound := OrderedCollection new: count.
	aCascadeNode messages do: 
			[:each |
			| newNode |
			newNode := self performSearches: searches on: each.
			newNode isNil
				ifTrue: 
					[newNode := each.
					notFound add: newNode].
			newNode isMessage
				ifTrue: [newMessages add: newNode]
				ifFalse: 
					[newNode isCascade
						ifTrue: [newMessages addAll: newNode messages]
						ifFalse: 
							[Transcript
								show: 'Cannot replace message node inside of cascaded node with non-message node.';
								cr.
							newMessages add: each]]].
	notFound size == count
		ifTrue: 
			[| receiver |
			receiver := self visitNode: aCascadeNode messages first receiver.
			newMessages do: [:each | each receiver: receiver]].
	notFound do: [:each | each arguments: (each arguments collect: [:arg | self visitNode: arg])].
	aCascadeNode messages: newMessages!

visitExternalArgTypeNode: aStExternalArgTypeNode
	aStExternalArgTypeNode structClass
		ifNotNil: [:structVar | aStExternalArgTypeNode structClass: (self visitNode: structVar)].
	^aStExternalArgTypeNode!

visitExternalCallNode: aStExternalCallNode
	aStExternalCallNode returnType: (self visitNode: aStExternalCallNode returnType).
	aStExternalCallNode
		argumentTypes: (aStExternalCallNode argumentTypes collect: [:each | self visitNode: each]).
	^aStExternalCallNode!

visitLiteralArrayNode: aLiteralArrayNode
	aLiteralArrayNode contents: (aLiteralArrayNode contents collect: [:each | self visitNode: each]).
	^aLiteralArrayNode!

visitMessageNode: aMessageNode
	aMessageNode receiver: (self visitNode: aMessageNode receiver).
	aMessageNode arguments: (aMessageNode arguments collect: [:each | self visitNode: each]).
	^aMessageNode!

visitMethodNode: aMethodNode
	aMethodNode arguments: (self visitArgumentNodes: aMethodNode arguments).
	aMethodNode tags: (aMethodNode tags collect: [:each | self visitNode: each]).
	aMethodNode body: (self visitNode: aMethodNode body).
	^aMethodNode!

visitOptimizedNode: anOptimizedNode
	anOptimizedNode body: (self visitNode: anOptimizedNode body).
	^anOptimizedNode!

visitReturnNode: aReturnNode
	aReturnNode value: (self visitNode: aReturnNode value).
	^aReturnNode!

visitSequenceNode: aSequenceNode
	aSequenceNode temporaries: (self visitArgumentNodes: aSequenceNode temporaries).
	aSequenceNode statements: (aSequenceNode statements collect: [:each | self visitNode: each]).
	^aSequenceNode! !
!Refactory.Browser.ParseTreeRewriter categoriesForMethods!
executeTree:!accessing!public! !
foundMatch!helpers!private! !
lookForMoreMatchesInContext:!operations!private! !
replace:with:!public!replacing! !
replace:with:when:!public!replacing! !
replace:withValueFrom:!public!replacing! !
replace:withValueFrom:when:!public!replacing! !
replaceArgument:with:!public!replacing! !
replaceArgument:with:when:!public!replacing! !
replaceArgument:withValueFrom:!public!replacing! !
replaceArgument:withValueFrom:when:!public!replacing! !
replaceLiteral:with:!instance creation!public! !
replaceMethod:with:!public!replacing! !
replaceMethod:with:when:!public!replacing! !
replaceMethod:withValueFrom:!public!replacing! !
replaceMethod:withValueFrom:when:!public!replacing! !
replaceTree:withTree:!public!replacing! !
replaceTree:withTree:when:!public!replacing! !
replaceTree:withValueFrom:!public!replacing! !
tree!accessing!public! !
visitAnnotationNode:!public!visiting! !
visitArgumentNodes:!public!visiting! !
visitArrayNode:!public!visitor/double dispatching! !
visitAssignmentNode:!public!visitor/double dispatching! !
visitBlockNode:!public!visitor/double dispatching! !
visitCascadeNode:!public!visitor/double dispatching! !
visitExternalArgTypeNode:!public! !
visitExternalCallNode:!public! !
visitLiteralArrayNode:!public!visitor/double dispatching! !
visitMessageNode:!public!visitor/double dispatching! !
visitMethodNode:!public!visitor/double dispatching! !
visitOptimizedNode:!public!visitor/double dispatching! !
visitReturnNode:!public!visitor/double dispatching! !
visitSequenceNode:!public!visitor/double dispatching! !
!

!Refactory.Browser.ParseTreeRewriter class methodsFor!

classVariable: aVarName getter: getMethod setter: setMethod 
	^self 
		variable: aVarName
		getter: getMethod
		setter: setMethod
		receiver: 'self class'!

removeTemporaryNamed: aName 
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule replace: '| `@temps1 ' , aName , ' `@temps2 | ``@.Statements'
		with: '| `@temps1  `@temps2 | ``@.Statements'.
	^rewriteRule!

rename: varName to: newVarName 
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule
		replace: varName with: newVarName;
		replaceArgument: varName with: newVarName.
	^rewriteRule!

rename: varName to: newVarName handler: aBlock 
	"Rename varName to newVarName, evaluating aBlock if there is a 
	temporary variable with the same name as newVarName. This 
	does not change temporary variables with varName."

	| rewriteRule |
	rewriteRule := self new.
	rewriteRule
		replace: varName with: newVarName;
		replaceArgument: newVarName
			withValueFrom: 
				[:aNode | 
				aBlock value.
				aNode].
	^rewriteRule!

replace: code with: newCode in: aParseTree 
	^(self 
		replace: code
		with: newCode
		method: false)
		executeTree: aParseTree;
		tree!

replace: code with: newCode in: aParseTree onInterval: anInterval 
	| rewriteRule |
	rewriteRule := self new.
	^rewriteRule
		replace: code
			with: newCode
			when: [:aNode | aNode intersectsInterval: anInterval];
		executeTree: aParseTree;
		tree!

replace: code with: newCode method: aBoolean 
	| rewriteRule |
	rewriteRule := self new.
	aBoolean 
		ifTrue: [rewriteRule replaceMethod: code with: newCode]
		ifFalse: [rewriteRule replace: code with: newCode].
	^rewriteRule!

replaceLiteral: literal with: newLiteral
	^self new
		replaceLiteral: literal with: newLiteral;
		yourself!

replaceStatements: code with: newCode in: aParseTree onInterval: anInterval
	| tree replaceStmt |
	tree := self buildTree: code method: false.
	tree isSequence ifFalse: [tree := StSequenceNode statements: {tree}].
	tree temporaries: {RBPatternVariableNode named: '`@temps'}.
	tree addNodeFirst: (RBPatternVariableNode named: '`@.S1').
	tree lastIsReturn
		ifTrue: [replaceStmt := '| `@temps | `@.S1. ^' , newCode]
		ifFalse: 
			[tree addNode: (RBPatternVariableNode named: '`@.S2').
			replaceStmt := '| `@temps | `@.S1. ' , newCode , '.
`@.S2'].
	^self
		replace: tree formattedCode
		with: replaceStmt
		in: aParseTree
		onInterval: anInterval!

variable: aVarName getter: getMethod setter: setMethod 
	^self 
		variable: aVarName
		getter: getMethod
		setter: setMethod
		receiver: 'self'!

variable: aVarName getter: getMethod setter: setMethod receiver: aString 
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule
		replace: aVarName , ' := ``@object' with: aString , ' ' , setMethod , ' ``@object';
		replace: aVarName with: aString , ' ' , getMethod.
	^rewriteRule! !
!Refactory.Browser.ParseTreeRewriter class categoriesForMethods!
classVariable:getter:setter:!instance creation!public! !
removeTemporaryNamed:!instance creation!public! !
rename:to:!instance creation!public! !
rename:to:handler:!instance creation!public! !
replace:with:in:!accessing!public! !
replace:with:in:onInterval:!accessing!public! !
replace:with:method:!instance creation!public! !
replaceLiteral:with:!instance creation!public! !
replaceStatements:with:in:onInterval:!accessing!public! !
variable:getter:setter:!instance creation!public! !
variable:getter:setter:receiver:!instance creation!public! !
!

