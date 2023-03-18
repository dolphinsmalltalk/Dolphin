"Filed out from Dolphin Smalltalk"!

Kernel.ParseNodeVisitor
	subclass: #'Refactory.Browser.ParseTreeSearcher'
	instanceVariableNames: 'searches answer argumentSearches context messages'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ParseTreeSearcher guid: (Core.GUID fromString: '{88f9b089-e658-4426-8d0a-f18303952cad}')!
Refactory.Browser.ParseTreeSearcher comment: 'ParseTreeSearcher walks over a normal source code parse tree using the visitor pattern, and then matches these nodes against the meta-nodes using the match:inContext: methods defined for the meta-nodes.

Instance Variables:
	answer	<Object>	the "answer" that is propagated between matches
	argumentSearches	<Collection of: (Association key: BRProgramNode value: BlockClosure)>	argument searches (search for the BRProgramNode and perform the BlockClosure when its found)
	context	<BRSmallDictionary>	a dictionary that contains what each meta-node matches against. This could be a normal Dictionary that is created for each search, but is created once and reused (efficiency).
	searches	<Collection of: (Association key: BRProgramNode value: BlockClosure)>	non-argument searches (search for the BRProgramNode and perform the BlockClosure when its found)'!
!Refactory.Browser.ParseTreeSearcher categoriesForClass!Refactory-ParseTree Matching! !
!Refactory.Browser.ParseTreeSearcher methodsFor!

addArgumentRule: aParseTreeRule
	argumentSearches := argumentSearches asOrderedCollection.
	self basicAddArgumentRule: aParseTreeRule!

addArgumentRules: ruleCollection
	ruleCollection do: [:each | self basicAddArgumentRule: each]!

addRule: aParseTreeRule
	searches := searches asOrderedCollection.
	self basicAddRule: aParseTreeRule!

addRules: ruleCollection
	ruleCollection do: [:each | self basicAddRule: each]!

answer
	^answer!

answer: anObject
	answer := anObject!

basicAddArgumentRule: aParseTreeRule
	argumentSearches add: aParseTreeRule.
	aParseTreeRule owner: self!

basicAddRule: aParseTreeRule
	searches add: aParseTreeRule.
	aParseTreeRule owner: self!

basicExecuteTree: aParseTree
	| oldContext result |
	searches := searches asArray.
	argumentSearches := argumentSearches asArray.
	oldContext := context.
	context := RBSmallDictionary new.
	result := self visitNode: aParseTree.
	context := oldContext.
	^result!

canMatchMethod: aCompiledMethod
	| msgs |
	msgs := self messages.
	^msgs isEmpty or: 
			[| symbols |
			symbols := aCompiledMethod allSymbolLiterals.
			msgs anySatisfy: [:each | symbols includes: each]]!

context
	^context!

executeMethod: aParseTree initialAnswer: anObject
	answer := anObject.
	searches detect: [:each | (each performOn: aParseTree) notNil] ifNone: nil.
	^answer!

executeTree: aParseTree
	self basicExecuteTree: aParseTree.
	^answer!

executeTree: aParseTree initialAnswer: aValue 
	answer := aValue.
	^self executeTree: aParseTree!

foundMatch!

initialize
	super initialize.
	context := RBSmallDictionary new.
	searches := OrderedCollection new.
	argumentSearches := #().
	answer := nil!

lookForMoreMatchesInContext: oldContext
	oldContext keysAndValuesDo: 
			[:key :value |
			((key isKindOf: String) not and: [key recurseInto])
				ifTrue: [value do: [:each | self visitNode: each]]]!

matches: aString do: aBlock
	self addRule: (RBSearchRule searchFor: aString thenDo: aBlock)!

matchesAnyArgumentOf: stringCollection do: aBlock 
	stringCollection do: [:each | self matchesArgument: each do: aBlock]!

matchesAnyMethodOf: aStringCollection do: aBlock 
	aStringCollection do: [:each | self matchesMethod: each do: aBlock]!

matchesAnyOf: aStringCollection do: aBlock 
	aStringCollection do: [:each | self matches: each do: aBlock]!

matchesAnyTreeOf: treeCollection do: aBlock 
	treeCollection do: [:each | self matchesTree: each do: aBlock]!

matchesArgument: aString do: aBlock
	self addArgumentRule: (RBSearchRule searchFor: aString thenDo: aBlock)!

matchesArgumentTree: aBRProgramNode do: aBlock
	self addArgumentRule: (RBSearchRule searchForTree: aBRProgramNode thenDo: aBlock)!

matchesMethod: aString do: aBlock
	self addRule: (RBSearchRule searchForMethod: aString thenDo: aBlock)!

matchesTree: aBRProgramNode do: aBlock
	self addRule: (RBSearchRule searchForTree: aBRProgramNode thenDo: aBlock)!

messages
	messages notNil ifTrue: [^messages].
	argumentSearches notEmpty ifTrue: [^messages := #()].
	messages := IdentitySet new.
	searches do: 
			[:each |
			| searchMessages |
			searchMessages := each sentMessages.
			StProgramNode optimizedSelectors do: [:sel | searchMessages remove: sel ifAbsent: nil].
			searchMessages isEmpty ifTrue: [^messages := #()].
			messages addAll: searchMessages].
	^messages := messages asArray!

performSearches: aSearchCollection on: aNode 
	1 to: aSearchCollection size
		do: 
			[:i | 
			| value |
			value := (aSearchCollection at: i) performOn: aNode.
			value notNil 
				ifTrue: 
					[self foundMatch.
					^value]].
	^nil!

recusivelySearchInContext
	"We need to save the matched context since the other searches might overwrite it."

	| oldContext |
	oldContext := context.
	context := RBSmallDictionary new.
	self lookForMoreMatchesInContext: oldContext.
	context := oldContext!

visitArgumentNode: aNode
	^(self performSearches: argumentSearches on: aNode) ifNil: [super visitArgumentNode: aNode]!

visitArgumentNodes: aNodeCollection
	^aNodeCollection do: [:each | self visitArgumentNode: each]!

visitNode: aNode
	^(self performSearches: searches on: aNode)
		ifNil: 
			[aNode acceptVisitor: self.
			aNode]! !
!Refactory.Browser.ParseTreeSearcher categoriesForMethods!
addArgumentRule:!accessing!public! !
addArgumentRules:!accessing!public! !
addRule:!accessing!public! !
addRules:!accessing!public! !
answer!accessing!public! !
answer:!initialize/release!public! !
basicAddArgumentRule:!accessing!private! !
basicAddRule:!accessing!private! !
basicExecuteTree:!private!searching! !
canMatchMethod:!public!testing! !
context!accessing!public! !
executeMethod:initialAnswer:!accessing!public! !
executeTree:!accessing!public! !
executeTree:initialAnswer:!accessing!public! !
foundMatch!helpers!private! !
initialize!initialize/release!public! !
lookForMoreMatchesInContext:!operations!private! !
matches:do:!public!searching! !
matchesAnyArgumentOf:do:!public!searching! !
matchesAnyMethodOf:do:!public!searching! !
matchesAnyOf:do:!public!searching! !
matchesAnyTreeOf:do:!public!searching! !
matchesArgument:do:!public!searching! !
matchesArgumentTree:do:!public!searching! !
matchesMethod:do:!public!searching! !
matchesTree:do:!public!searching! !
messages!accessing!public! !
performSearches:on:!operations!private! !
recusivelySearchInContext!operations!private! !
visitArgumentNode:!public!visiting! !
visitArgumentNodes:!public!visiting! !
visitNode:!public!visiting! !
!

!Refactory.Browser.ParseTreeSearcher class methodsFor!

buildSelectorString: aSelector
	| stream keywords |
	aSelector argumentCount = 0 ifTrue: [^aSelector].
	stream := WriteStream on: String new.
	keywords := aSelector keywords.
	1 to: keywords size
		do: 
			[:i |
			stream
				nextPutAll: (keywords at: i);
				nextPutAll: ' ``@arg';
				nextPutAll: i printString;
				nextPut: $\x20].
	^stream contents!

buildSelectorTree: aSelector
	aSelector isEmpty ifTrue: [^nil].
	^Refactory.Browser.RBPatternParser
		parseExpression: '``@receiver ' , (self buildSelectorString: aSelector)
		onError: [:err :pos | ^nil]!

buildTree: aString method: aBoolean
	^aBoolean
		ifTrue: [RBPatternParser parseMethod: aString]
		ifFalse: [RBPatternParser parseExpression: aString]!

getterMethod: aVarName 
	^(self new)
		matchesMethod: '`method ^' , aVarName do: [:aNode :ans | aNode selector];
		yourself!

justSendsSuper
	^(self new)
		matchesAnyMethodOf: 
				#('`@method: `@Args ^super `@method: `@Args' 
				'`@method: `@Args super `@method: `@Args')
			do: [:aNode :ans | true];
		yourself!

returnSetterMethod: aVarName 
	^(self new)
		matchesMethod: '`method: `Arg ^' , aVarName , ' := `Arg'
			do: [:aNode :ans | aNode selector];
		yourself!

setterMethod: aVarName
	^self new
		matchesAnyMethodOf: {'`method: `Arg ' , aVarName , ' := `Arg'.
					'`method: `Arg ^' , aVarName , ' := `Arg'}
			do: [:aNode :ans | aNode selector];
		yourself!

treeMatching: aString in: aParseTree 
	(self new)
		matches: aString do: [:aNode :answer | ^aNode];
		executeTree: aParseTree.
	^nil!

treeMatchingStatements: aString in: aParseTree
	| notifier tree |
	notifier := self new.
	tree := Parser parseExpression: aString.
	tree isSequence ifFalse: [tree := StSequenceNode statements: {tree}].
	tree temporaries: {RBPatternVariableNode named: '`@temps'}.
	tree addNodeFirst: (RBPatternVariableNode named: '`@.S1').
	tree lastIsReturn ifFalse: [tree addNode: (RBPatternVariableNode named: '`@.S2')].
	notifier matchesTree: tree do: [:aNode :answer | ^Parser parseExpression: aString].
	notifier executeTree: aParseTree.
	^nil! !
!Refactory.Browser.ParseTreeSearcher class categoriesForMethods!
buildSelectorString:!helpers!private! !
buildSelectorTree:!helpers!private! !
buildTree:method:!helpers!private! !
getterMethod:!instance creation!public! !
justSendsSuper!instance creation!public! !
returnSetterMethod:!instance creation!public! !
setterMethod:!instance creation!public! !
treeMatching:in:!accessing!public! !
treeMatchingStatements:in:!accessing!public! !
!

