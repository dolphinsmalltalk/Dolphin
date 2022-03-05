"Filed out from Dolphin Smalltalk"!

StSemanticScope subclass: #StLexicalScope
	instanceVariableNames: 'locals node thisContextVariable flags'
	classVariableNames: 'FarReturnMask NeedsSelfMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLexicalScope guid: (GUID fromString: '{cf1f5402-a16a-4f0c-8c08-630e2b5fbf47}')!
StLexicalScope addClassConstant: 'FarReturnMask' value: 16r2!
StLexicalScope addClassConstant: 'NeedsSelfMask' value: 16r1!
StLexicalScope comment: ''!
!StLexicalScope categoriesForClass!Kernel-Objects! !
!StLexicalScope methodsFor!

argumentCount
	^node argumentCount!

declareArgument: aString
	self declareLocalVariable: (StArgumentVariable node: aString)!

declareLocalVariable: anStLocalVariable
	locals at: anStLocalVariable name
		put: (anStLocalVariable
				scope: self;
				yourself)!

declareTemp: aString
	self declareLocalVariable: (StTempVariable node: aString)!

envTempCount
	"Answer the number of environment temporaries that will be required for this scope."

	^self locals count: [:var | var storage == #shared]!

hasFarReturn
	"Answer whether this scope contains a ^-return."

	^flags anyMask: FarReturnMask!

includesArg: aString
	| local |
	^(local := locals lookup: aString) notNil and: [local isArgument]!

includesLocal: aString
	^locals includesKey: aString!

includesTemp: aString
	| local |
	^(local := locals lookup: aString) notNil and: [local isTempVariable]!

initialize
	super initialize.
	locals := LookupTable new.
	flags := 0!

isInlined
	^node isInlined!

localCount
	^locals size!

locals
	^locals!

lookupVariable: anStVariableNode
	"Lookup and return an <StVariable> describing the variable definition in this scope matching
	the variable reference specified by the <StVariableNode> argument."

	anStVariableNode isSpecialVariable ifTrue: [^anStVariableNode specialVariableInScope: self].
	^(locals lookup: anStVariableNode name)
		ifNil: [outer ifNotNil: [outer lookupVariable: anStVariableNode]]!

markFarReturn
	"Mark this scope as containing a ^-return."

	flags := flags maskSet: FarReturnMask!

markNeedsSelf
	"Mark this scope as accessing self (or super)."

	flags := flags maskSet: NeedsSelfMask!

needsContext
	"Answer whether this scope requires a reified <Context> when physically activated. The
	context is needed to hold shared, closed-over, temporary variables defined in this scope,
	and/or to support ^-returns from blocks."

	^self hasFarReturn or: [self envTempCount > 0]!

needsSelf
	"Answer whether this scope access self (or super)."

	^flags anyMask: NeedsSelfMask!

node
	^node!

printOn: aPuttableStream
	self basicPrintOn: aPuttableStream.
	aPuttableStream
		nextPut: $(;
		print: node;
		nextPut: $)!

realScope
	"Answer the nearest real (non-optimized) scope. If the scope is itself unoptimized, then
	this will be the receiver. The actual scope is the scope in which any variables declared in
	the receiver will actually be allocated."

	^self!

setNode: aBlockOrMethodNode outer: anStLexicalScope
	node := aBlockOrMethodNode.
	outer := anStLexicalScope.
	self initialize!

temporaries
	^locals select: [:each | each isTempVariable]!

thisContextVariable
	^thisContextVariable
		ifNil: 
			[thisContextVariable := (StThisContextVariable new)
						scope: self;
						yourself]!

unreferencedArguments
	^(node isMethod and: [node isPrimitive])
		ifTrue: 
			["All arguments to primitive methods are implicitly referenced"
			#()]
		ifFalse: [locals select: [:each | each isArgument and: [each isRead not]]]! !
!StLexicalScope categoriesForMethods!
argumentCount!accessing!public! !
declareArgument:!helpers!private! !
declareLocalVariable:!helpers!private! !
declareTemp:!helpers!private! !
envTempCount!accessing!development!public! !
hasFarReturn!accessing!public! !
includesArg:!enquiries!public! !
includesLocal:!enquiries!public! !
includesTemp:!enquiries!public! !
initialize!initializing!private! !
isInlined!accessing!public! !
localCount!accessing!public! !
locals!accessing!public! !
lookupVariable:!operations!public! !
markFarReturn!public!visiting! !
markNeedsSelf!public!visiting! !
needsContext!accessing!public! !
needsSelf!accessing!public! !
node!accessing!public! !
printOn:!printing!public! !
realScope!public! !
setNode:outer:!initializing!private! !
temporaries!accessing!private! !
thisContextVariable!public! !
unreferencedArguments!accessing!public! !
!

!StLexicalScope class methodsFor!

initialize
	self addClassConstant: 'NeedsSelfMask' value: 16r1.
	self addClassConstant: 'FarReturnMask' value: 16r2! !
!StLexicalScope class categoriesForMethods!
initialize!class initialization!development!public! !
!

