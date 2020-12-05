"Filed out from Dolphin Smalltalk 7"!

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
			((key isKindOf: String) not and: [key recurseInto])
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

tree
	^tree!

visitArgumentNodes: aNodeCollection
	^aNodeCollection collect: [:each | self visitArgumentNode: each]!

visitArrayNode: anArrayNode
	anArrayNode statements: (anArrayNode statements collect: [:each | self visitNode: each])!

visitAssignmentNode: anAssignmentNode
	anAssignmentNode variable: (self visitNode: anAssignmentNode variable).
	anAssignmentNode value: (self visitNode: anAssignmentNode value)!

visitBlockNode: aBlockNode
	aBlockNode arguments: (self visitArgumentNodes: aBlockNode arguments).
	aBlockNode body: (self visitNode: aBlockNode body)!

visitCascadeNode: aCascadeNode
	| newMessages notFound |
	newMessages := OrderedCollection new: aCascadeNode messages size.
	notFound := OrderedCollection new: aCascadeNode messages size.
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
	notFound size == aCascadeNode messages size
		ifTrue: 
			[| receiver |
			receiver := self visitNode: aCascadeNode messages first receiver.
			newMessages do: [:each | each receiver: receiver]].
	notFound do: [:each | each arguments: (each arguments collect: [:arg | self visitNode: arg])].
	aCascadeNode messages: newMessages!

visitLiteralArrayNode: aRBArrayLiteralNode
	aRBArrayLiteralNode contents: (aRBArrayLiteralNode contents collect: [:each | self visitNode: each])!

visitMessageNode: aMessageNode
	aMessageNode receiver: (self visitNode: aMessageNode receiver).
	aMessageNode arguments: (aMessageNode arguments collect: [:each | self visitNode: each])!

visitMethodNode: aMethodNode
	aMethodNode arguments: (self visitArgumentNodes: aMethodNode arguments).
	aMethodNode body: (self visitNode: aMethodNode body)!

visitOptimizedNode: anOptimizedNode
	anOptimizedNode body: (self visitNode: anOptimizedNode body)!

visitReturnNode: aReturnNode
	aReturnNode value: (self visitNode: aReturnNode value)!

visitSequenceNode: aSequenceNode
	aSequenceNode temporaries: (self visitArgumentNodes: aSequenceNode temporaries).
	aSequenceNode statements: (aSequenceNode statements collect: [:each | self visitNode: each])! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #executeTree:!accessing!public! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #foundMatch!helpers!private! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #lookForMoreMatchesInContext:!operations!private! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replace:with:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replace:with:when:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replace:withValueFrom:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replace:withValueFrom:when:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replaceArgument:with:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replaceArgument:with:when:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replaceArgument:withValueFrom:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replaceArgument:withValueFrom:when:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replaceMethod:with:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replaceMethod:with:when:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replaceMethod:withValueFrom:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replaceMethod:withValueFrom:when:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replaceTree:withTree:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #replaceTree:withTree:when:!public!replacing! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #tree!accessing!public! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitArgumentNodes:!public!visiting! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitArrayNode:!public!visiting! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitAssignmentNode:!public!visitor/double dispatching! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitBlockNode:!public!visitor/double dispatching! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitCascadeNode:!public!visitor/double dispatching! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitLiteralArrayNode:!public!visitor/double dispatching! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitMessageNode:!public!visitor/double dispatching! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitMethodNode:!public!visitor/double dispatching! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitOptimizedNode:!public!visitor/double dispatching! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitReturnNode:!public!visitor/double dispatching! !
!Refactory.Browser.ParseTreeRewriter categoriesFor: #visitSequenceNode:!public!visitor/double dispatching! !

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
	| rewriteRule |
	rewriteRule := self new.
	rewriteRule replaceTree: (RBLiteralNode value: literal)
		withTree: (RBLiteralNode value: newLiteral).
	^rewriteRule!

replaceStatements: code with: newCode in: aParseTree onInterval: anInterval
	| tree replaceStmt |
	tree := self buildTree: code method: false.
	tree isSequence ifFalse: [tree := RBSequenceNode statements: {tree}].
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
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #classVariable:getter:setter:!instance creation!public! !
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #removeTemporaryNamed:!instance creation!public! !
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #rename:to:!instance creation!public! !
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #rename:to:handler:!instance creation!public! !
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #replace:with:in:!accessing!public! !
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #replace:with:in:onInterval:!accessing!public! !
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #replace:with:method:!instance creation!public! !
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #replaceLiteral:with:!instance creation!public! !
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #replaceStatements:with:in:onInterval:!accessing!public! !
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #variable:getter:setter:!instance creation!public! !
!Refactory.Browser.ParseTreeRewriter class categoriesFor: #variable:getter:setter:receiver:!instance creation!public! !

