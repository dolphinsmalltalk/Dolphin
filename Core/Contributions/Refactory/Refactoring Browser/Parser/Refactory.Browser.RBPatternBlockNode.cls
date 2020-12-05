"Filed out from Dolphin Smalltalk 7"!

Kernel.StBlockNode subclass: #'Refactory.Browser.RBPatternBlockNode'
	instanceVariableNames: 'valueBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBPatternBlockNode guid: (Core.GUID fromString: '{63f4ab8a-d94e-4a65-bdae-742311429c7c}')!
Refactory.Browser.RBPatternBlockNode comment: ''!
!Refactory.Browser.RBPatternBlockNode categoriesForClass!Refactory-Parser! !
!Refactory.Browser.RBPatternBlockNode methodsFor!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitPatternBlockNode: self!

addArgumentWithNameBasedOn: aString to: aRBBlockNode 
	| name index vars |
	name := aString.
	vars := aRBBlockNode allDefinedVariables.
	index := 0.
	[vars includes: name] whileTrue: 
			[index := index + 1.
			name := name , index printString].
	aRBBlockNode 
		arguments: (aRBBlockNode arguments copyWith: (RBVariableNode named: name))!

constructLookupNodeFor: aString in: aRBBlockNode
	| argumentNode |
	argumentNode := RBLiteralValueNode literalToken: (RBLiteralToken
						start: nil
						comments: nil
						value: aString
						stop: nil).
	^RBMessageNode
		receiver: (RBVariableNode named: 'self')
		selector: #lookupMatchFor:in:
		arguments: {argumentNode. aRBBlockNode arguments last}!

copyInContext: aDictionary 
	^self replacingBlock value: aDictionary!

createBlockFor: aRBBlockNode
	| source |
	self replacePatternNodesIn: aRBBlockNode.
	source := aRBBlockNode formattedCode.
	^Compiler evaluate: source for: self!

createMatchingBlock
	| newBlock |
	self arguments size > 2 
		ifTrue: 
			[self 
				error: 'Search blocks can only contain arguments for the node and matching dictionary'].
	newBlock := RBBlockNode arguments: arguments body: body.
	newBlock arguments isEmpty 
		ifTrue: [self addArgumentWithNameBasedOn: 'aNode' to: newBlock].
	newBlock arguments size = 1 
		ifTrue: [self addArgumentWithNameBasedOn: 'aDictionary' to: newBlock].
	^self createBlockFor: newBlock!

createReplacingBlock
	| newBlock |
	self arguments size > 1 
		ifTrue: 
			[self 
				error: 'Replace blocks can only contain an argument for the matching dictionary'].
	newBlock := RBBlockNode arguments: arguments body: body.
	self arguments isEmpty 
		ifTrue: [self addArgumentWithNameBasedOn: 'aDictionary' to: newBlock].
	^self createBlockFor: newBlock!

lookupMatchFor: aString in: aDictionary
	^aDictionary at: aString
		ifAbsent: 
			[| variableNode |
			variableNode := RBPatternVariableNode named: aString.
			aDictionary at: variableNode ifAbsent: [nil]]!

match: aNode inContext: aDictionary 
	^self matchingBlock value: aNode value: aDictionary!

matchingBlock
	^valueBlock isNil 
		ifTrue: [valueBlock := self createMatchingBlock]
		ifFalse: [valueBlock]!

replacePatternNodesIn: aRBBlockNode 
	aRBBlockNode body nodesDo: 
			[:each | 
			(each isVariable and: [each isPatternNode]) 
				ifTrue: 
					[each 
						replaceWith: (self constructLookupNodeFor: each name in: aRBBlockNode)]]!

replacingBlock
	^valueBlock isNil 
		ifTrue: [valueBlock := self createReplacingBlock]
		ifFalse: [valueBlock]!

sentMessages
	^OrderedCollection new! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #acceptVisitor:!public!visitor! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #addArgumentWithNameBasedOn:to:!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #constructLookupNodeFor:in:!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #copyInContext:!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #createBlockFor:!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #createMatchingBlock!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #createReplacingBlock!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #lookupMatchFor:in:!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #match:inContext:!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #matchingBlock!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #replacePatternNodesIn:!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #replacingBlock!matching!public! !
!Refactory.Browser.RBPatternBlockNode categoriesFor: #sentMessages!accessing!public! !

