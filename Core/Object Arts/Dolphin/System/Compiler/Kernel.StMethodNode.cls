"Filed out from Dolphin Smalltalk 7"!

Kernel.StProgramNode subclass: #'Kernel.StMethodNode'
	instanceVariableNames: 'selector selectorParts body source arguments tag replacements nodeReplacements methodClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StMethodNode guid: (Core.GUID fromString: '{a10b25e1-f065-457c-90d9-2571ebf23f51}')!
Kernel.StMethodNode comment: 'StMethodNode is the parse tree node type that represents a Smalltalk method.

Instance Variables:
	arguments	<SequenceableCollection> of <StVariableNode>	the arguments to the method
	body	<StSequenceNode>	the body/statements of the method
	selector	<Symbol | nil>	the method name (cached)
	selectorParts	<SequenceableCollection> of <StValueToken>	the tokens for the selector keywords
	source	<String>	the source we compiled
	tag	<Interval | nil>	the source location of any resource/primitive tags

'!
!Kernel.StMethodNode categoriesForClass!System-Compiler! !
!Kernel.StMethodNode methodsFor!

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
!Kernel.StMethodNode categoriesFor: #=!comparing!public! !
!Kernel.StMethodNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StMethodNode categoriesFor: #actualScope!public! !
!Kernel.StMethodNode categoriesFor: #allArgumentVariableNodesDo:!accessing!public! !
!Kernel.StMethodNode categoriesFor: #allDefinedVariableNodesDo:!accessing!public! !
!Kernel.StMethodNode categoriesFor: #argumentCount!accessing!public! !
!Kernel.StMethodNode categoriesFor: #argumentNames!accessing!public! !
!Kernel.StMethodNode categoriesFor: #arguments!accessing!public! !
!Kernel.StMethodNode categoriesFor: #arguments:!accessing!public! !
!Kernel.StMethodNode categoriesFor: #body!accessing!public! !
!Kernel.StMethodNode categoriesFor: #body:!accessing!public! !
!Kernel.StMethodNode categoriesFor: #buildSelector!helpers!private! !
!Kernel.StMethodNode categoriesFor: #childrenDo:!accessing!public! !
!Kernel.StMethodNode categoriesFor: #defines:!public!testing! !
!Kernel.StMethodNode categoriesFor: #displayOn:!printing!public! !
!Kernel.StMethodNode categoriesFor: #hash!comparing!public! !
!Kernel.StMethodNode categoriesFor: #isExternalCall!public!testing! !
!Kernel.StMethodNode categoriesFor: #isInlined!public!testing! !
!Kernel.StMethodNode categoriesFor: #isLast:!public!testing! !
!Kernel.StMethodNode categoriesFor: #isMethod!public!testing! !
!Kernel.StMethodNode categoriesFor: #isPrimitive!public!testing! !
!Kernel.StMethodNode categoriesFor: #lastIsReturn!public!testing! !
!Kernel.StMethodNode categoriesFor: #methodClass!accessing!public! !
!Kernel.StMethodNode categoriesFor: #methodClass:!accessing!public! !
!Kernel.StMethodNode categoriesFor: #methodComments!accessing!public! !
!Kernel.StMethodNode categoriesFor: #methodNode!accessing!public! !
!Kernel.StMethodNode categoriesFor: #numArgs!accessing!public! !
!Kernel.StMethodNode categoriesFor: #outer!public! !
!Kernel.StMethodNode categoriesFor: #postCopy!copying!public! !
!Kernel.StMethodNode categoriesFor: #printOn:!printing!public! !
!Kernel.StMethodNode categoriesFor: #selector!accessing!public! !
!Kernel.StMethodNode categoriesFor: #selector:!accessing!public! !
!Kernel.StMethodNode categoriesFor: #selectorParts!accessing!private! !
!Kernel.StMethodNode categoriesFor: #selectorParts:!accessing!private! !
!Kernel.StMethodNode categoriesFor: #selectorParts:arguments:!initializing!public! !
!Kernel.StMethodNode categoriesFor: #source!accessing!public! !
!Kernel.StMethodNode categoriesFor: #source:!accessing!public! !
!Kernel.StMethodNode categoriesFor: #start!accessing!public! !
!Kernel.StMethodNode categoriesFor: #stop!accessing!public! !
!Kernel.StMethodNode categoriesFor: #tag!accessing!public! !
!Kernel.StMethodNode categoriesFor: #tag:!accessing!private! !
!Kernel.StMethodNode categoriesFor: #uses:!public!testing! !

!Kernel.StMethodNode class methodsFor!

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
!Kernel.StMethodNode class categoriesFor: #new!instance creation!public! !
!Kernel.StMethodNode class categoriesFor: #selector:arguments:body:!instance creation!public! !
!Kernel.StMethodNode class categoriesFor: #selector:body:!instance creation!public! !
!Kernel.StMethodNode class categoriesFor: #selectorParts:arguments:!instance creation!public! !

