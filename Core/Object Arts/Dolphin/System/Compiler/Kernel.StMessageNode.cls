"Filed out from Dolphin Smalltalk"!

Kernel.StValueNode
	subclass: #'Kernel.StMessageNode'
	instanceVariableNames: 'receiver selector selectorParts arguments'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StMessageNode guid: (Core.GUID fromString: '{3a681160-291e-495f-a7ce-71b4a751f5d4}')!
Kernel.StMessageNode comment: 'StMessageNode is a parse tree node that represents a message send.

Instance Variables:
	arguments	<SequenceableCollection of: StValueNode>	our argument nodes
	receiver	<StValueNode>	the receiver''s node
	selector	<Symbol | nil>	the selector we''re sending (cached)
	selectorParts	<SequenceableCollection of: StValueToken>	the tokens for each keyword

'!
!Kernel.StMessageNode categoriesForClass!System-Compiler! !
!Kernel.StMessageNode methodsFor!

= anObject
	self == anObject ifTrue: [^true].
	self class == anObject class ifFalse: [^false].
	(receiver = anObject receiver and: [self selector = anObject selector]) ifFalse: [^false].
	1 to: arguments size do: [:i | (arguments at: i) = (anObject arguments at: i) ifFalse: [^false]].
	^true!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitMessageNode: self!

argument
	"Answer the argument. Fails if the message does not have exactly one argument."

	| args |
	args := self arguments.
	^args size == 1
		ifTrue: [args first]
		ifFalse: [self error: 'Not a binary or one argument keyword message']!

argumentCount
	^self arguments size!

arguments
	^arguments!

arguments: argCollection 
	arguments := argCollection.
	arguments do: [:each | each parent: self]!

bestNodeFor: anInterval 
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval) ifTrue: [^self].
	selectorParts do: 
			[:each | 
			((anInterval first between: each start and: each stop) 
				or: [each start between: anInterval first and: anInterval last]) ifTrue: [^self]].
	self childrenDo: 
			[:each | 
			| node |
			node := each bestNodeFor: anInterval.
			node notNil ifTrue: [^node]]!

buildSelector
	| selectorStream symbol |
	selectorStream := WriteStream on: (Utf8String new: selectorParts size * 10).
	selectorParts do: [:each | selectorStream nextPutAll: each value].
	symbol := selectorStream contents asSymbol.
	self setSelector: symbol.
	^symbol!

childrenDo: aMonadicValuable
	aMonadicValuable value: receiver.
	arguments do: aMonadicValuable!

hash
	^(self receiver hash bitXor: self selector hash) 
		bitXor: (self arguments isEmpty 
				ifTrue: [0]
				ifFalse: [self arguments first hash])!

isBinary
	^(self isUnary or: [self isKeyword]) not!

isCascaded
	^parent notNil and: [parent isCascade]!

isFirstCascaded
	^self isCascaded and: [parent messages first == self]!

isFirstSendToReceiver
	^parent isNil or: [parent isCascade not or: [parent messages first == self]]!

isInlineable
	"Answer whether this is an optimisable message, such as #whileTrue."

	^InlinedBlockSelectors includes: self selector!

isKeyword
	^selectorParts first value lastCodeUnit == $:!

isMessage
	^true!

isUnary
	^arguments isEmpty!

lastIsReturn
	^(#(#ifTrue:ifFalse: #ifFalse:ifTrue:) includes: self selector) and: 
			[arguments first isBlock and: 
					[arguments first body lastIsReturn
						and: [arguments last isBlock and: [arguments last body lastIsReturn]]]]!

needsParenthesis
	^parent isNil 
		ifTrue: [false]
		ifFalse: 
			[self precedence > parent precedence 
				or: [self precedence = parent precedence and: [self isUnary not]]]!

numArgs
	#rbFix.	"Use ANSI standard #argumentCount message"
	^self argumentCount!

postCopy
	super postCopy.
	self receiver: receiver copy.
	self arguments: (arguments collect: [:each | each copy]).
	^self!

precedence
	^self isUnary 
		ifTrue: [1]
		ifFalse: [self isKeyword ifTrue: [3] ifFalse: [2]]!

receiver
	^receiver!

receiver: aValueNode 
	receiver := aValueNode.
	receiver parent: self!

receiver: aValueNode selectorParts: keywordTokens arguments: valueNodes 
	self receiver: aValueNode.
	selectorParts := keywordTokens.
	self arguments: valueNodes!

renameSelector: newSelector andArguments: varNodeCollection 
	self
		arguments: varNodeCollection;
		selector: newSelector!

selector
	^selector ifNil: [self buildSelector]!

selector: aSelector
	| keywords numArgs |
	keywords := aSelector keywords.
	numArgs := aSelector argumentCount.
	numArgs == arguments size
		ifFalse: [self error: 'Attempting to assign selector with wrong number of arguments.'].
	selectorParts := numArgs == 0
				ifTrue: [{StIdentifierToken
							start: nil
							comments: nil
							value: keywords first}]
				ifFalse: 
					[keywords first lastCodeUnit == $:
						ifTrue: 
							[keywords collect: 
									[:each |
									StKeywordToken
										start: nil
										comments: nil
										value: each]]
						ifFalse: 
							[{StBinarySelectorToken
									start: nil
									comments: nil
									value: aSelector}]].
	selector := aSelector!

selectorParts
	^selectorParts!

selectorParts: tokenCollection 
	selectorParts := tokenCollection!

sentMessages
	^(super sentMessages)
		add: self selector;
		yourself!

setSelector: aSymbol
	<mutable>
	selector := aSymbol!

startWithoutParentheses
	^receiver start!

stopWithoutParentheses
	^arguments isEmpty 
		ifTrue: [selectorParts first stop]
		ifFalse: [arguments last stop]!

value
	^self selector! !
!Kernel.StMessageNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
argument!accessing!public! !
argumentCount!accessing!public! !
arguments!accessing!public! !
arguments:!accessing!public! !
bestNodeFor:!public!querying! !
buildSelector!helpers!private! !
childrenDo:!accessing!public! !
hash!comparing!public! !
isBinary!public!testing! !
isCascaded!public!testing! !
isFirstCascaded!public!testing! !
isFirstSendToReceiver!public!testing! !
isInlineable!public!testing! !
isKeyword!public!testing! !
isMessage!public!testing! !
isUnary!public!testing! !
lastIsReturn!public!testing! !
needsParenthesis!public!testing! !
numArgs!accessing!public! !
postCopy!copying!public! !
precedence!accessing!public! !
receiver!accessing!public! !
receiver:!accessing!public! !
receiver:selectorParts:arguments:!initializing!public! !
renameSelector:andArguments:!accessing!public! !
selector!accessing!public! !
selector:!accessing!public! !
selectorParts!accessing!private! !
selectorParts:!accessing!private! !
sentMessages!accessing!public! !
setSelector:!initializing!private! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
value!accessing!public! !
!

!Kernel.StMessageNode class methodsFor!

receiver: aValueNode selector: aSymbol 
	^self 
		receiver: aValueNode
		selector: aSymbol
		arguments: #()!

receiver: aValueNode selector: aSymbol arguments: valueNodes 
	^(self new)
		receiver: aValueNode;
		arguments: valueNodes;
		selector: aSymbol;
		yourself!

receiver: aValueNode selectorParts: keywordTokens arguments: valueNodes 
	^(self new)
		receiver: aValueNode
			selectorParts: keywordTokens
			arguments: valueNodes;
		yourself! !
!Kernel.StMessageNode class categoriesForMethods!
receiver:selector:!instance creation!public! !
receiver:selector:arguments:!instance creation!public! !
receiver:selectorParts:arguments:!instance creation!public! !
!

