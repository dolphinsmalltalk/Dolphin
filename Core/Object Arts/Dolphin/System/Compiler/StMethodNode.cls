"Filed out from Dolphin Smalltalk 7"!

StProgramNode subclass: #StMethodNode
	instanceVariableNames: 'selector selectorParts body source arguments tag replacements nodeReplacements methodClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StMethodNode guid: (GUID fromString: '{a10b25e1-f065-457c-90d9-2571ebf23f51}')!
StMethodNode comment: 'StMethodNode is the parse tree node type that represents a Smalltalk method.

Instance Variables:
	arguments	<SequenceableCollection> of <StVariableNode>	the arguments to the method
	body	<StSequenceNode>	the body/statements of the method
	selector	<Symbol | nil>	the method name (cached)
	selectorParts	<SequenceableCollection> of <StValueToken>	the tokens for the selector keywords
	source	<String>	the source we compiled
	tag	<Interval | nil>	the source location of any resource/primitive tags

'!
!StMethodNode categoriesForClass!System-Compiler! !
!StMethodNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	(self selector = anObject selector and: [self body = anObject body]) ifFalse: [^false].
	1 to: self arguments size
		do: [:i | (self arguments at: i) = (anObject arguments at: i) ifFalse: [^false]].
	^self tag = anObject tag!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitMethodNode: self!

actualScope
	"Answer the actual scope in which this nodes variables will be defined."

	^self!

allArgumentVariableNodesDo: aMonadicValuable
	self arguments do: aMonadicValuable.
	super allArgumentVariableNodesDo: aMonadicValuable!

allDefinedVariableNodesDo: aMonadicValuable
	self arguments do: aMonadicValuable.
	super allDefinedVariableNodesDo: aMonadicValuable!

argumentCount
	^arguments size!

argumentNames
	^self arguments collect: [:each | each name]!

arguments
	^arguments!

arguments: variableNodes 
	arguments := variableNodes.
	arguments do: [:each | each parent: self]!

body
	^body!

body: stmtsNode 
	body := stmtsNode.
	body parent: self!

buildSelector
	| selectorStream |
	selectorStream := WriteStream on: (Utf8String new: 50).
	selectorParts do: [:each | selectorStream nextPutAll: each value].
	^selectorStream contents asSymbol!

childrenDo: aMonadicValuable 
	self arguments do: aMonadicValuable.
	aMonadicValuable value: self body!

defines: aName 
	^arguments anySatisfy: [:each | each name = aName]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Method'!

hash
	^(self selector hash bitXor: self body hash) bitXor: self arguments hash!

isExternalCall
	^tag notNil and: [tag isExternalCall]!

isInlined
	^false!

isLast: aNode 
	^body isLast: aNode!

isMethod
	^true!

isPrimitive
	#rbFix.	"On Dolphin primitives are parsed into an AST, so the tag is actually a node"
	^tag notNil!

lastIsReturn
	^body lastIsReturn!

methodClass
	^methodClass!

methodClass: aClass 
	methodClass := aClass!

methodComments
	| methodComments |
	methodComments := OrderedCollection withAll: self comments.
	arguments do: [:each | methodComments addAll: each comments].
	^methodComments asSortedCollection: [:a :b | a first < b first]!

methodNode
	^self!

numArgs
	^self argumentCount!

outer
	"Answer the <StMethodNode> or <StBlockNode> being the scope in which this node exists."

	^self!

postCopy
	super postCopy.
	self body: body copy.
	self arguments: (arguments collect: [:each | each copy]).
	^self!

printOn: aStream 
	aStream nextPutAll: self formattedCode!

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

selectorParts: tokenCollection arguments: variableNodes 
	selectorParts := tokenCollection.
	self arguments: variableNodes!

source
	^source!

source: anObject
	source := anObject!

start
	^1!

stop
	^source size!

tag
	^tag!

tag: anStTagNodeOrNil 
	tag := anStTagNodeOrNil!

uses: aNode 
	^body == aNode and: [aNode lastIsReturn]! !
!StMethodNode categoriesFor: #=!comparing!public! !
!StMethodNode categoriesFor: #acceptVisitor:!public!visitor! !
!StMethodNode categoriesFor: #actualScope!public! !
!StMethodNode categoriesFor: #allArgumentVariableNodesDo:!accessing!public! !
!StMethodNode categoriesFor: #allDefinedVariableNodesDo:!accessing!public! !
!StMethodNode categoriesFor: #argumentCount!accessing!public! !
!StMethodNode categoriesFor: #argumentNames!accessing!public! !
!StMethodNode categoriesFor: #arguments!accessing!public! !
!StMethodNode categoriesFor: #arguments:!accessing!public! !
!StMethodNode categoriesFor: #body!accessing!public! !
!StMethodNode categoriesFor: #body:!accessing!public! !
!StMethodNode categoriesFor: #buildSelector!helpers!private! !
!StMethodNode categoriesFor: #childrenDo:!accessing!public! !
!StMethodNode categoriesFor: #defines:!public!testing! !
!StMethodNode categoriesFor: #displayOn:!printing!public! !
!StMethodNode categoriesFor: #hash!comparing!public! !
!StMethodNode categoriesFor: #isExternalCall!public!testing! !
!StMethodNode categoriesFor: #isInlined!public!testing! !
!StMethodNode categoriesFor: #isLast:!public!testing! !
!StMethodNode categoriesFor: #isMethod!public!testing! !
!StMethodNode categoriesFor: #isPrimitive!public!testing! !
!StMethodNode categoriesFor: #lastIsReturn!public!testing! !
!StMethodNode categoriesFor: #methodClass!accessing!public! !
!StMethodNode categoriesFor: #methodClass:!accessing!public! !
!StMethodNode categoriesFor: #methodComments!accessing!public! !
!StMethodNode categoriesFor: #methodNode!accessing!public! !
!StMethodNode categoriesFor: #numArgs!accessing!public! !
!StMethodNode categoriesFor: #outer!public! !
!StMethodNode categoriesFor: #postCopy!copying!public! !
!StMethodNode categoriesFor: #printOn:!printing!public! !
!StMethodNode categoriesFor: #selector!accessing!public! !
!StMethodNode categoriesFor: #selector:!accessing!public! !
!StMethodNode categoriesFor: #selectorParts!accessing!private! !
!StMethodNode categoriesFor: #selectorParts:!accessing!private! !
!StMethodNode categoriesFor: #selectorParts:arguments:!initializing!public! !
!StMethodNode categoriesFor: #source!accessing!public! !
!StMethodNode categoriesFor: #source:!accessing!public! !
!StMethodNode categoriesFor: #start!accessing!public! !
!StMethodNode categoriesFor: #stop!accessing!public! !
!StMethodNode categoriesFor: #tag!accessing!public! !
!StMethodNode categoriesFor: #tag:!accessing!private! !
!StMethodNode categoriesFor: #uses:!public!testing! !

!StMethodNode class methodsFor!

new
	^(super new)
		initialize;
		yourself!

selector: aSymbol arguments: variableNodes body: aSequenceNode 
	^(self new)
		arguments: variableNodes;
		selector: aSymbol;
		body: aSequenceNode;
		yourself!

selector: aSymbol body: aSequenceNode 
	^self 
		selector: aSymbol
		arguments: #()
		body: aSequenceNode!

selectorParts: tokenCollection arguments: variableNodes 
	^(self new)
		selectorParts: tokenCollection arguments: variableNodes;
		yourself! !
!StMethodNode class categoriesFor: #new!instance creation!public! !
!StMethodNode class categoriesFor: #selector:arguments:body:!instance creation!public! !
!StMethodNode class categoriesFor: #selector:body:!instance creation!public! !
!StMethodNode class categoriesFor: #selectorParts:arguments:!instance creation!public! !

