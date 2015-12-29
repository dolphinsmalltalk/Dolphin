"Filed out from Dolphin Smalltalk 2000 release 4.01"!

SmalltalkParseTreeSearcher subclass: #SmalltalkParseTreeRewriter
	instanceVariableNames: 'tree'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkParseTreeRewriter comment: 'ParseTreeRewriter walks over and transforms its BRProgramNode (tree). If the tree is modified, then answer is set to true, and the modified tree can be retrieved by the #tree method.

Instance Variables:
	tree	<BRProgramNode>	the parse tree we''re transforming'!

SmalltalkParseTreeRewriter guid: (GUID fromString: '{E902BFFE-805D-4946-B0EA-0E7501C75C73}')!

!SmalltalkParseTreeRewriter categoriesForClass!Refactory-ParseTree Matching! !
!SmalltalkParseTreeRewriter methodsFor!

acceptAssignmentNode: anAssignmentNode 
	anAssignmentNode variable: (self visitNode: anAssignmentNode variable).
	anAssignmentNode value: (self visitNode: anAssignmentNode value)!

acceptBlockNode: aBlockNode 
	aBlockNode arguments: (self visitArguments: aBlockNode arguments).
	aBlockNode body: (self visitNode: aBlockNode body)!

acceptCascadeNode: aCascadeNode 
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
	notFound 
		do: [:each | each arguments: (each arguments collect: [:arg | self visitNode: arg])].
	aCascadeNode messages: newMessages!

acceptMessageNode: aMessageNode 
	aMessageNode receiver: (self visitNode: aMessageNode receiver).
	aMessageNode 
		arguments: (aMessageNode arguments collect: [:each | self visitNode: each])!

acceptMethodNode: aMethodNode 
	aMethodNode arguments: (self visitArguments: aMethodNode arguments).
	aMethodNode body: (self visitNode: aMethodNode body)!

acceptOptimizedNode: anOptimizedNode 
	anOptimizedNode body: (self visitNode: anOptimizedNode body)!

acceptReturnNode: aReturnNode 
	aReturnNode value: (self visitNode: aReturnNode value)!

acceptSequenceNode: aSequenceNode 
	aSequenceNode temporaries: (self visitArguments: aSequenceNode temporaries).
	aSequenceNode statements: (aSequenceNode statements collect: [:each | self visitNode: each])!

executeTree: aParseTree 
	| oldContext |
	oldContext := context.
	context := SmallDictionary new.
	answer := false.
	tree := self visitNode: aParseTree.
	context := oldContext.
	^answer!

foundMatch
	answer := true!

lookForMoreMatchesInContext: oldContext 
	oldContext keysAndValuesDo: 
			[:key :value | 
			((key isKindOf: String) not and: [key recurseInto]) 
				ifTrue: 
					[oldContext at: key put: (value collect: [:each | self visitNode: each])]]!

replace: searchString with: replaceString 
	self addRule: (SmalltalkParseTreeStringReplaceRule searchFor: searchString
				replaceWith: replaceString)!

replace: searchString with: replaceString when: aBlock 
	self addRule: (SmalltalkParseTreeStringReplaceRule 
				searchFor: searchString
				replaceWith: replaceString
				when: aBlock)!

replace: searchString withValueFrom: replaceBlock 
	self addRule: (SmalltalkParseTreeBlockReplaceRule searchFor: searchString
				replaceWith: replaceBlock)!

replace: searchString withValueFrom: replaceBlock when: conditionBlock 
	self addRule: (SmalltalkParseTreeBlockReplaceRule 
				searchFor: searchString
				replaceWith: replaceBlock
				when: conditionBlock)!

replaceArgument: searchString with: replaceString 
	self addArgumentRule: (SmalltalkParseTreeStringReplaceRule searchFor: searchString
				replaceWith: replaceString)!

replaceArgument: searchString with: replaceString when: aBlock 
	self addArgumentRule: (SmalltalkParseTreeStringReplaceRule 
				searchFor: searchString
				replaceWith: replaceString
				when: aBlock)!

replaceArgument: searchString withValueFrom: replaceBlock 
	self addArgumentRule: (SmalltalkParseTreeBlockReplaceRule searchFor: searchString
				replaceWith: replaceBlock)!

replaceArgument: searchString withValueFrom: replaceBlock when: conditionBlock 
	self addArgumentRule: (SmalltalkParseTreeBlockReplaceRule 
				searchFor: searchString
				replaceWith: replaceBlock
				when: conditionBlock)!

replaceMethod: searchString with: replaceString 
	self addRule: (SmalltalkParseTreeStringReplaceRule searchForMethod: searchString
				replaceWith: replaceString)!

replaceMethod: searchString with: replaceString when: aBlock 
	self addRule: (SmalltalkParseTreeStringReplaceRule 
				searchForMethod: searchString
				replaceWith: replaceString
				when: aBlock)!

replaceMethod: searchString withValueFrom: replaceBlock 
	self addRule: (SmalltalkParseTreeBlockReplaceRule searchForMethod: searchString
				replaceWith: replaceBlock)!

replaceMethod: searchString withValueFrom: replaceBlock when: conditionBlock 
	self addRule: (SmalltalkParseTreeBlockReplaceRule 
				searchForMethod: searchString
				replaceWith: replaceBlock
				when: conditionBlock)!

replaceTree: searchTree withTree: replaceTree 
	self addRule: (SmalltalkParseTreeStringReplaceRule searchForTree: searchTree
				replaceWith: replaceTree)!

replaceTree: searchTree withTree: replaceTree when: aBlock 
	self addRule: (SmalltalkParseTreeStringReplaceRule 
				searchForTree: searchTree
				replaceWith: replaceTree
				when: aBlock)!

tree
	^tree!

visitArguments: aNodeCollection 
	^aNodeCollection collect: [:each | self visitArgument: each]! !
!SmalltalkParseTreeRewriter categoriesFor: #acceptAssignmentNode:!public!visitor/double dispatching! !
!SmalltalkParseTreeRewriter categoriesFor: #acceptBlockNode:!public!visitor/double dispatching! !
!SmalltalkParseTreeRewriter categoriesFor: #acceptCascadeNode:!public!visitor/double dispatching! !
!SmalltalkParseTreeRewriter categoriesFor: #acceptMessageNode:!public!visitor/double dispatching! !
!SmalltalkParseTreeRewriter categoriesFor: #acceptMethodNode:!public!visitor/double dispatching! !
!SmalltalkParseTreeRewriter categoriesFor: #acceptOptimizedNode:!public!visitor/double dispatching! !
!SmalltalkParseTreeRewriter categoriesFor: #acceptReturnNode:!public!visitor/double dispatching! !
!SmalltalkParseTreeRewriter categoriesFor: #acceptSequenceNode:!public!visitor/double dispatching! !
!SmalltalkParseTreeRewriter categoriesFor: #executeTree:!accessing!public! !
!SmalltalkParseTreeRewriter categoriesFor: #foundMatch!*-unclassified!private! !
!SmalltalkParseTreeRewriter categoriesFor: #lookForMoreMatchesInContext:!*-unclassified!private! !
!SmalltalkParseTreeRewriter categoriesFor: #replace:with:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replace:with:when:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replace:withValueFrom:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replace:withValueFrom:when:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replaceArgument:with:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replaceArgument:with:when:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replaceArgument:withValueFrom:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replaceArgument:withValueFrom:when:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replaceMethod:with:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replaceMethod:with:when:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replaceMethod:withValueFrom:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replaceMethod:withValueFrom:when:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replaceTree:withTree:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #replaceTree:withTree:when:!public!replacing! !
!SmalltalkParseTreeRewriter categoriesFor: #tree!accessing!public! !
!SmalltalkParseTreeRewriter categoriesFor: #visitArguments:!public!visiting! !

!SmalltalkParseTreeRewriter class methodsFor!

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
	rewriteRule 
		replace: '`#literal'
		withValueFrom: [:aNode | aNode]
		when: 
			[:aNode | 
			self 
				replaceLiteral: literal
				with: newLiteral
				inToken: aNode token].
	^rewriteRule!

replaceLiteral: literal with: newLiteral inToken: literalToken 
	| value |
	value := literalToken realValue.
	(value class = literal class and: [value = literal]) 
		ifTrue: 
			[literalToken 
				value: newLiteral
				start: nil
				stop: nil.
			^true].
	^value class == Array and: 
			[literalToken value inject: false
				into: 
					[:bool :each | 
					bool | (self 
								replaceLiteral: literal
								with: newLiteral
								inToken: each)]]!

replaceStatements: code with: newCode in: aParseTree onInterval: anInterval 
	| tree searchStmt replaceStmt |
	tree := self buildTree: code method: false.
	tree lastIsReturn
		ifTrue: 
			[searchStmt := '| `@temps | `@.Statements. ' , code.
			replaceStmt := '| `@temps | `@.Statements. ^' , newCode]
		ifFalse: 
			[searchStmt := '| `@temps | `@.Statements1. ' , code , '.  `@.Statements2'.
			replaceStmt := '| `@temps | `@.Statements1. ' , newCode , '.  `@.Statements2'].
	^self
		replace: searchStmt
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
		replace: aVarName , ' := ``@object'
			with: aString , ' ' , setMethod , ' ``@object';
		replace: aVarName with: aString , ' ' , getMethod.
	^rewriteRule! !
!SmalltalkParseTreeRewriter class categoriesFor: #classVariable:getter:setter:!instance creation!public! !
!SmalltalkParseTreeRewriter class categoriesFor: #removeTemporaryNamed:!instance creation!public! !
!SmalltalkParseTreeRewriter class categoriesFor: #rename:to:!instance creation!public! !
!SmalltalkParseTreeRewriter class categoriesFor: #rename:to:handler:!instance creation!public! !
!SmalltalkParseTreeRewriter class categoriesFor: #replace:with:in:!accessing!public! !
!SmalltalkParseTreeRewriter class categoriesFor: #replace:with:in:onInterval:!accessing!public! !
!SmalltalkParseTreeRewriter class categoriesFor: #replace:with:method:!instance creation!public! !
!SmalltalkParseTreeRewriter class categoriesFor: #replaceLiteral:with:!instance creation!public! !
!SmalltalkParseTreeRewriter class categoriesFor: #replaceLiteral:with:inToken:!*-unclassified!private! !
!SmalltalkParseTreeRewriter class categoriesFor: #replaceStatements:with:in:onInterval:!accessing!public! !
!SmalltalkParseTreeRewriter class categoriesFor: #variable:getter:setter:!instance creation!public! !
!SmalltalkParseTreeRewriter class categoriesFor: #variable:getter:setter:receiver:!instance creation!public! !

