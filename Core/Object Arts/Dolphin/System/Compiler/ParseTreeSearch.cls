"Filed out from Dolphin Smalltalk 2000 release 4.01"!

SmalltalkParseNodeVisitor subclass: #SmalltalkParseTreeSearcher
	instanceVariableNames: 'searches answer argumentSearches context messages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkParseTreeSearcher comment: 'ParseTreeSearcher walks over a normal source code parse tree using the visitor pattern, and then matches these nodes against the meta-nodes using the match:inContext: methods defined for the meta-nodes.

Instance Variables:
	answer	<Object>	the "answer" that is propagated between matches
	argumentSearches	<Collection of: (Association key: BRProgramNode value: BlockClosure)>	argument searches (search for the BRProgramNode and perform the BlockClosure when its found)
	context	<BRSmallDictionary>	a dictionary that contains what each meta-node matches against. This could be a normal Dictionary that is created for each search, but is created once and reused (efficiency).
	searches	<Collection of: (Association key: BRProgramNode value: BlockClosure)>	non-argument searches (search for the BRProgramNode and perform the BlockClosure when its found)'!

SmalltalkParseTreeSearcher guid: (GUID fromString: '{88F9B089-E658-4426-8D0A-F18303952CAD}')!

!SmalltalkParseTreeSearcher categoriesForClass!Refactory-ParseTree Matching! !
!SmalltalkParseTreeSearcher methodsFor!

addArgumentRule: aParseTreeRule 
	argumentSearches add: aParseTreeRule.
	aParseTreeRule owner: self!

addArgumentRules: ruleCollection 
	ruleCollection do: [:each | self addArgumentRule: each]!

addRule: aParseTreeRule 
	searches add: aParseTreeRule.
	aParseTreeRule owner: self!

addRules: ruleCollection 
	ruleCollection do: [:each | self addRule: each]!

answer
	^answer!

answer: anObject
	answer := anObject!

canMatchMethod: aCompiledMethod 
	^self messages isEmpty or: 
			[(self messages detect: [:each | aCompiledMethod sendsSelector: each]
				ifNone: [nil]) notNil]!

context
	^context!

executeMethod: aParseTree initialAnswer: anObject 
	answer := anObject.
	searches detect: [:each | (each performOn: aParseTree) notNil] ifNone: [].
	^answer!

executeTree: aParseTree 
	"Save our current context, in case someone is performing another search inside a match."

	| oldContext |
	oldContext := context.
	context := SmallDictionary new.
	self visitNode: aParseTree.
	context := oldContext.
	^answer!

executeTree: aParseTree initialAnswer: aValue 
	answer := aValue.
	^self executeTree: aParseTree!

foundMatch!

initialize
	super initialize.
	context := SmallDictionary new.
	searches := OrderedCollection new.
	argumentSearches := OrderedCollection new: 0.
	answer := nil!

lookForMoreMatchesInContext: oldContext 
	oldContext keysAndValuesDo: 
			[:key :value | 
			((key isKindOf: String) not and: [key recurseInto]) 
				ifTrue: [value do: [:each | self visitNode: each]]]!

matches: aString do: aBlock 
	self addRule: (SmalltalkParseTreeSearchRule searchFor: aString thenDo: aBlock)!

matchesAnyArgumentOf: stringCollection do: aBlock 
	stringCollection do: [:each | self matchesArgument: each do: aBlock]!

matchesAnyMethodOf: aStringCollection do: aBlock 
	aStringCollection do: [:each | self matchesMethod: each do: aBlock]!

matchesAnyOf: aStringCollection do: aBlock 
	aStringCollection do: [:each | self matches: each do: aBlock]!

matchesAnyTreeOf: treeCollection do: aBlock 
	treeCollection do: [:each | self matchesTree: each do: aBlock]!

matchesArgument: aString do: aBlock 
	self addArgumentRule: (SmalltalkParseTreeSearchRule searchFor: aString thenDo: aBlock)!

matchesArgumentTree: aBRProgramNode do: aBlock 
	self 
		addArgumentRule: (SmalltalkParseTreeSearchRule searchForTree: aBRProgramNode thenDo: aBlock)!

matchesMethod: aString do: aBlock 
	self addRule: (SmalltalkParseTreeSearchRule searchForMethod: aString thenDo: aBlock)!

matchesTree: aBRProgramNode do: aBlock 
	self addRule: (SmalltalkParseTreeSearchRule searchForTree: aBRProgramNode thenDo: aBlock)!

messages
	messages notNil ifTrue: [^messages].
	argumentSearches isEmpty ifFalse: [^messages := #()].
	messages := Set new.
	searches do: 
			[:each | 
			| searchMessages |
			searchMessages := each sentMessages.
			SmalltalkParserNode optimizedSelectors 
				do: [:sel | searchMessages remove: sel ifAbsent: []].
			searchMessages isEmpty ifTrue: [^messages := #()].
			messages addAll: searchMessages].
	^messages := messages asArray!

performSearches: aSearchCollection on: aNode 
	| value |
	1 to: aSearchCollection size
		do: 
			[:i | 
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
	context := SmallDictionary new.
	self lookForMoreMatchesInContext: oldContext.
	context := oldContext!

visitArgument: aNode 
	| value |
	value := self performSearches: argumentSearches on: aNode.
	^value isNil 
		ifTrue: 
			[aNode acceptVisitor: self.
			aNode]
		ifFalse: [value]!

visitNode: aNode 
	| value |
	value := self performSearches: searches on: aNode.
	^value isNil 
		ifTrue: 
			[aNode acceptVisitor: self.
			aNode]
		ifFalse: [value]! !
!SmalltalkParseTreeSearcher categoriesFor: #addArgumentRule:!accessing!public! !
!SmalltalkParseTreeSearcher categoriesFor: #addArgumentRules:!accessing!public! !
!SmalltalkParseTreeSearcher categoriesFor: #addRule:!accessing!public! !
!SmalltalkParseTreeSearcher categoriesFor: #addRules:!accessing!public! !
!SmalltalkParseTreeSearcher categoriesFor: #answer!accessing!public! !
!SmalltalkParseTreeSearcher categoriesFor: #answer:!initialize/release!public! !
!SmalltalkParseTreeSearcher categoriesFor: #canMatchMethod:!public!testing! !
!SmalltalkParseTreeSearcher categoriesFor: #context!accessing!public! !
!SmalltalkParseTreeSearcher categoriesFor: #executeMethod:initialAnswer:!accessing!public! !
!SmalltalkParseTreeSearcher categoriesFor: #executeTree:!accessing!public! !
!SmalltalkParseTreeSearcher categoriesFor: #executeTree:initialAnswer:!accessing!public! !
!SmalltalkParseTreeSearcher categoriesFor: #foundMatch!*-unclassified!private! !
!SmalltalkParseTreeSearcher categoriesFor: #initialize!initialize/release!public! !
!SmalltalkParseTreeSearcher categoriesFor: #lookForMoreMatchesInContext:!*-unclassified!private! !
!SmalltalkParseTreeSearcher categoriesFor: #matches:do:!public!searching! !
!SmalltalkParseTreeSearcher categoriesFor: #matchesAnyArgumentOf:do:!public!searching! !
!SmalltalkParseTreeSearcher categoriesFor: #matchesAnyMethodOf:do:!public!searching! !
!SmalltalkParseTreeSearcher categoriesFor: #matchesAnyOf:do:!public!searching! !
!SmalltalkParseTreeSearcher categoriesFor: #matchesAnyTreeOf:do:!public!searching! !
!SmalltalkParseTreeSearcher categoriesFor: #matchesArgument:do:!public!searching! !
!SmalltalkParseTreeSearcher categoriesFor: #matchesArgumentTree:do:!public!searching! !
!SmalltalkParseTreeSearcher categoriesFor: #matchesMethod:do:!public!searching! !
!SmalltalkParseTreeSearcher categoriesFor: #matchesTree:do:!public!searching! !
!SmalltalkParseTreeSearcher categoriesFor: #messages!accessing!public! !
!SmalltalkParseTreeSearcher categoriesFor: #performSearches:on:!*-unclassified!private! !
!SmalltalkParseTreeSearcher categoriesFor: #recusivelySearchInContext!*-unclassified!private! !
!SmalltalkParseTreeSearcher categoriesFor: #visitArgument:!public!visiting! !
!SmalltalkParseTreeSearcher categoriesFor: #visitNode:!public!visiting! !

!SmalltalkParseTreeSearcher class methodsFor!

buildSelectorString: aSelector 
	| stream keywords |
	aSelector numArgs = 0 ifTrue: [^aSelector].
	stream := WriteStream on: String new.
	keywords := aSelector keywords.
	1 to: keywords size
		do: 
			[:i | 
			stream nextPutAll: (keywords at: i);
				nextPutAll: ' ``@arg';
				nextPutAll: i printString;
				nextPut: $ ].
	^stream contents!

buildSelectorTree: aSelector 
	aSelector isEmpty ifTrue: [^nil].
	^SmalltalkParser parseRewriteExpression: '``@receiver ' 
				, (self buildSelectorString: aSelector)
		onError: [:err :pos | ^nil]!

buildTree: aString method: aBoolean 
	^aBoolean 
		ifTrue: [SmalltalkParser parseRewriteMethod: aString]
		ifFalse: [SmalltalkParser parseRewriteExpression: aString]!

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
	^(self new)
		matchesAnyMethodOf: (Array with: '`method: `Arg ' , aVarName , ' := `Arg'
					with: '`method: `Arg ^' , aVarName , ' := `Arg')
			do: [:aNode :ans | aNode selector];
		yourself!

treeMatching: aString in: aParseTree 
	(self new)
		matches: aString do: [:aNode :answer | ^aNode];
		executeTree: aParseTree.
	^nil!

treeMatchingStatements: aString in: aParseTree 
	| notifier tree lastIsReturn |
	notifier := self new.
	tree := SmalltalkParser parseExpression: aString.
	lastIsReturn := tree lastIsReturn.
	notifier matches: (lastIsReturn 
				ifTrue: ['| `@temps | `@.S1. ' , tree formattedCode]
				ifFalse: ['| `@temps | `@.S1. ' , tree formattedCode , '. `@.S2'])
		do: [:aNode :answer | ^tree].
	notifier executeTree: aParseTree.
	^nil! !
!SmalltalkParseTreeSearcher class categoriesFor: #buildSelectorString:!*-unclassified!private! !
!SmalltalkParseTreeSearcher class categoriesFor: #buildSelectorTree:!*-unclassified!public! !
!SmalltalkParseTreeSearcher class categoriesFor: #buildTree:method:!*-unclassified!public! !
!SmalltalkParseTreeSearcher class categoriesFor: #getterMethod:!instance creation!public! !
!SmalltalkParseTreeSearcher class categoriesFor: #justSendsSuper!instance creation!public! !
!SmalltalkParseTreeSearcher class categoriesFor: #returnSetterMethod:!instance creation!public! !
!SmalltalkParseTreeSearcher class categoriesFor: #setterMethod:!instance creation!public! !
!SmalltalkParseTreeSearcher class categoriesFor: #treeMatching:in:!accessing!public! !
!SmalltalkParseTreeSearcher class categoriesFor: #treeMatchingStatements:in:!accessing!public! !

