"Filed out from Dolphin Smalltalk"!

Kernel.StRealVariableNode
	subclass: #'Refactory.Browser.RBPatternVariableNode'
	instanceVariableNames: 'recurseInto isList isLiteral isStatement isAnything'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBPatternVariableNode guid: (Core.GUID fromString: '{f486bd69-8849-4076-8297-971b56451981}')!
Refactory.Browser.RBPatternVariableNode comment: 'RBPatternVariableNode is a parse tree node that is used to match several other types of nodes (literals, variables, value nodes, statement nodes, and sequences of statement nodes).

The different types of matches are determined by the name of the node. If the name contains a # character, then it will match a literal. If it contains, a . then it matches statements. If it contains no extra characters, then it matches only variables. These options are mutually exclusive.

The @ character can be combined with the name to match lists of items. If combined with the . character, then it will match a list of statement nodes (0 or more). If used without the . or # character, then it matches anything except for list of statements. Combining the @ with the # is not supported.

Adding another ` in the name will cause the search/replace to look for more matches inside the node that this node matched. This option should not be used for top level expressions since that would cause infinite recursion (e.g., searching only for "``@anything").

Instance Variables:
	isList	<Boolean>	can we match a list of items (@)
	isLiteral	<Boolean>	only match a literal node (#)
	isStatement	<Boolean>	only match statements (.)
	recurseInto	<Boolean>	search for more matches in the node we match (`)

'!
!Refactory.Browser.RBPatternVariableNode categoriesForClass!Refactory-Parser! !
!Refactory.Browser.RBPatternVariableNode methodsFor!

copyInContext: aDictionary
	^(isList and: [isStatement])
		ifTrue: [self copyList: (aDictionary at: self) inContext: aDictionary]
		ifFalse: [(aDictionary at: self) collect: [:each | each copy]]!

identifierToken: anIdentifierToken 
	super identifierToken: anIdentifierToken.
	self initializePatternVariables!

initializePatternVariables
	| pattern |
	pattern := self name.
	isAnything := isList := isLiteral := isStatement := recurseInto := false.
	2 to: pattern size
		do: 
			[:i |
			| character |
			character := pattern at: i.
			character == RBPatternScanner.ListCharacter
				ifTrue: [isAnything := isList := true]
				ifFalse: 
					[character == self literalCharacter
						ifTrue: [isLiteral := true]
						ifFalse: 
							[character == self statementCharacter
								ifTrue: [isStatement := true]
								ifFalse: [character == self recurseIntoCharacter ifTrue: [recurseInto := true] ifFalse: [^self]]]]]!

isAnything
	^isAnything!

isList
	^isList!

isLiteralNode
	^isLiteral!

isPatternNode
	^true!

isStatement
	^isStatement!

match: aNode inContext: aDictionary 
	self isAnything 
		ifTrue: [^(aDictionary at: self ifAbsentPut: [aNode]) = aNode].
	self isLiteralNode ifTrue: [^self matchLiteral: aNode inContext: aDictionary].
	self isStatement 
		ifTrue: [^self matchStatement: aNode inContext: aDictionary].
	(aNode isKindOf: self matchingClass) ifFalse: [^false].
	^(aDictionary at: self ifAbsentPut: [aNode]) = aNode!

matchingClass
	^StVariableNode!

matchLiteral: aNode inContext: aDictionary 
	^aNode isLiteralNode
		and: [(aDictionary at: self ifAbsentPut: [aNode]) = aNode]!

matchStatement: aNode inContext: aDictionary 
	(aNode parent notNil and: [aNode parent isSequence]) ifFalse: [^false].
	^(aDictionary at: self ifAbsentPut: [aNode]) = aNode!

parent: aBRProgramNode
	"Fix the case where '``@node' should match a single node, not a sequence node."

	super parent: aBRProgramNode.
	parent isDynamicArray ifTrue: [self isStatement ifFalse: [isList := false]].
	parent isSequence
		ifTrue: [(self isStatement or: [parent temporaries includes: self]) ifFalse: [isList := false]]!

recurseInto
	^recurseInto!

setName: aString start: anInteger
	super setName: aString start: anInteger.
	self initializePatternVariables! !
!Refactory.Browser.RBPatternVariableNode categoriesForMethods!
copyInContext:!matching!public! !
identifierToken:!initialize/release!public! !
initializePatternVariables!initialize/release!private! !
isAnything!public!testing/matching! !
isList!public!testing/matching! !
isLiteralNode!public!testing! !
isPatternNode!public!testing/matching! !
isStatement!public!testing/matching! !
match:inContext:!matching!public! !
matchingClass!constants!matching!private! !
matchLiteral:inContext:!matching!private! !
matchStatement:inContext:!matching!private! !
parent:!accessing!public! !
recurseInto!public!testing/matching! !
setName:start:!initializing!private! !
!

!Refactory.Browser.RBPatternVariableNode class methodsFor!

identifierToken: anIdentifierToken
	^anIdentifierToken isPatternVariable
		ifTrue: [self named: anIdentifierToken value start: anIdentifierToken start]
		ifFalse: [StVariableNode named: anIdentifierToken value start: anIdentifierToken start]! !
!Refactory.Browser.RBPatternVariableNode class categoriesForMethods!
identifierToken:!instance creation!public! !
!

