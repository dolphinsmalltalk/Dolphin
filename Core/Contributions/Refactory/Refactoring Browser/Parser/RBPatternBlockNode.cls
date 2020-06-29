"Filed out from Dolphin Smalltalk 7"!

StBlockNode subclass: #RBPatternBlockNode
	instanceVariableNames: 'valueBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RBPatternBlockNode guid: (GUID fromString: '{63f4ab8a-d94e-4a65-bdae-742311429c7c}')!
RBPatternBlockNode comment: ''!
!RBPatternBlockNode categoriesForClass!Refactory-Parser! !
!RBPatternBlockNode methodsFor!

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
		arguments: (Array with: argumentNode with: aRBBlockNode arguments last)

!

copyInContext: aDictionary 
	^self replacingBlock value: aDictionary!

createBlockFor: aRBBlockNode 
	| source |
	self replacePatternNodesIn: aRBBlockNode.
	source := aRBBlockNode formattedCode.
	^Compiler 
		evaluate: source
		for: self!

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
!RBPatternBlockNode categoriesFor: #acceptVisitor:!public!visitor! !
!RBPatternBlockNode categoriesFor: #addArgumentWithNameBasedOn:to:!matching!public! !
!RBPatternBlockNode categoriesFor: #constructLookupNodeFor:in:!matching!public! !
!RBPatternBlockNode categoriesFor: #copyInContext:!matching!public! !
!RBPatternBlockNode categoriesFor: #createBlockFor:!matching!public! !
!RBPatternBlockNode categoriesFor: #createMatchingBlock!matching!public! !
!RBPatternBlockNode categoriesFor: #createReplacingBlock!matching!public! !
!RBPatternBlockNode categoriesFor: #lookupMatchFor:in:!matching!public! !
!RBPatternBlockNode categoriesFor: #match:inContext:!matching!public! !
!RBPatternBlockNode categoriesFor: #matchingBlock!matching!public! !
!RBPatternBlockNode categoriesFor: #replacePatternNodesIn:!matching!public! !
!RBPatternBlockNode categoriesFor: #replacingBlock!matching!public! !
!RBPatternBlockNode categoriesFor: #sentMessages!accessing!public! !

