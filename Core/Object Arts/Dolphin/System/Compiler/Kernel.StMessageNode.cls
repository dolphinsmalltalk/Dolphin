"Filed out from Dolphin Smalltalk 7"!

Kernel.StValueNode subclass: #'Kernel.StMessageNode'
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
	self class = anObject class ifFalse: [^false].
	(self receiver = anObject receiver 
		and: [self selector = anObject selector]) ifFalse: [^false].
	1 to: self arguments size
		do: [:i | (self arguments at: i) = (anObject arguments at: i) ifFalse: [^false]].
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
	^arguments ?? #()!

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
	| selectorStream |
	selectorStream := WriteStream on: (Utf8String new: selectorParts size * 10).
	selectorParts do: [:each | selectorStream nextPutAll: each value].
	^selectorStream contents asSymbol!

childrenDo: aMonadicValuable 
	aMonadicValuable value: self receiver.
	self arguments do: aMonadicValuable!

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

isInlineable
	"Answer whether this is an optimisable message, such as #whileTrue."

	^InlinedBlockSelectors includes: self selector!

isKeyword
	^selectorParts first value last == $:!

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
	^selector ifNil: [selector := self buildSelector]!

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
					[keywords first last == $:
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

startWithoutParentheses
	^receiver start!

stopWithoutParentheses
	^arguments isEmpty 
		ifTrue: [selectorParts first stop]
		ifFalse: [arguments last stop]!

value
	^self selector! !
!Kernel.StMessageNode categoriesFor: #=!comparing!public! !
!Kernel.StMessageNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StMessageNode categoriesFor: #argument!accessing!public! !
!Kernel.StMessageNode categoriesFor: #argumentCount!accessing!public! !
!Kernel.StMessageNode categoriesFor: #arguments!accessing!public! !
!Kernel.StMessageNode categoriesFor: #arguments:!accessing!public! !
!Kernel.StMessageNode categoriesFor: #bestNodeFor:!public!querying! !
!Kernel.StMessageNode categoriesFor: #buildSelector!helpers!private! !
!Kernel.StMessageNode categoriesFor: #childrenDo:!accessing!public! !
!Kernel.StMessageNode categoriesFor: #hash!comparing!public! !
!Kernel.StMessageNode categoriesFor: #isBinary!public!testing! !
!Kernel.StMessageNode categoriesFor: #isCascaded!public!testing! !
!Kernel.StMessageNode categoriesFor: #isFirstCascaded!public!testing! !
!Kernel.StMessageNode categoriesFor: #isInlineable!public! !
!Kernel.StMessageNode categoriesFor: #isKeyword!public!testing! !
!Kernel.StMessageNode categoriesFor: #isMessage!public!testing! !
!Kernel.StMessageNode categoriesFor: #isUnary!public!testing! !
!Kernel.StMessageNode categoriesFor: #lastIsReturn!public!testing! !
!Kernel.StMessageNode categoriesFor: #needsParenthesis!public!testing! !
!Kernel.StMessageNode categoriesFor: #numArgs!accessing!public! !
!Kernel.StMessageNode categoriesFor: #postCopy!copying!public! !
!Kernel.StMessageNode categoriesFor: #precedence!accessing!public! !
!Kernel.StMessageNode categoriesFor: #receiver!accessing!public! !
!Kernel.StMessageNode categoriesFor: #receiver:!accessing!public! !
!Kernel.StMessageNode categoriesFor: #receiver:selectorParts:arguments:!initializing!public! !
!Kernel.StMessageNode categoriesFor: #renameSelector:andArguments:!accessing!public! !
!Kernel.StMessageNode categoriesFor: #selector!accessing!public! !
!Kernel.StMessageNode categoriesFor: #selector:!accessing!public! !
!Kernel.StMessageNode categoriesFor: #selectorParts!accessing!private! !
!Kernel.StMessageNode categoriesFor: #selectorParts:!accessing!private! !
!Kernel.StMessageNode categoriesFor: #sentMessages!accessing!public! !
!Kernel.StMessageNode categoriesFor: #startWithoutParentheses!accessing!public! !
!Kernel.StMessageNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!Kernel.StMessageNode categoriesFor: #value!accessing!public! !

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
!Kernel.StMessageNode class categoriesFor: #receiver:selector:!instance creation!public! !
!Kernel.StMessageNode class categoriesFor: #receiver:selector:arguments:!instance creation!public! !
!Kernel.StMessageNode class categoriesFor: #receiver:selectorParts:arguments:!instance creation!public! !

