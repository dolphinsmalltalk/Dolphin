"Filed out from Dolphin Smalltalk"!

Kernel.StSemanticScope
	subclass: #'Kernel.StLexicalScope'
	instanceVariableNames: 'node outer locals thisContextVariable flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'FarReturnMask' -> 16r2. 'NeedsSelfMask' -> 16r1 }!
Kernel.StLexicalScope guid: (Core.GUID fromString: '{cf1f5402-a16a-4f0c-8c08-630e2b5fbf47}')!
Kernel.StLexicalScope isNonInstantiable: true!
Kernel.StLexicalScope comment: ''!
!Kernel.StLexicalScope categoriesForClass!Kernel-Objects! !
!Kernel.StLexicalScope methodsFor!

argumentCount
	^node argumentCount!

declareArgument: aStParameterNode
	^self declareLocalVariable: (StArgumentVariable node: aStParameterNode)!

declareLocalVariable: aStLocalVariable
	^locals at: aStLocalVariable name
		put: (aStLocalVariable
				scope: self;
				yourself)!

declareTemp: aString
	^self declareLocalVariable: (StTempVariable node: aString)!

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
	"Answer whether this scope accesses self (or super)."

	^flags anyMask: NeedsSelfMask!

node
	^node!

node: aBlockOrMethodNode outer: aStLexicalScope
	node := aBlockOrMethodNode.
	outer := aStLexicalScope.
	self initialize.
	^self!

outer
	^outer!

outer: aStSemanticScope
	outer := aStSemanticScope!

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

resolveIdentifier: aString
	^(locals lookup: aString) ifNil: [outer ifNotNil: [outer resolveIdentifier: aString]]!

temporaries
	^locals select: [:each | each isTempVariable]!

thisContextVariable
	^thisContextVariable
		ifNil: 
			[thisContextVariable := StThisContextVariable new
						scope: self;
						yourself]!

unreferencedArguments
	^(node isMethod and: [node isPrimitive])
		ifTrue: 
			["All arguments to primitive methods are implicitly referenced"
			#()]
		ifFalse: [locals select: [:each | each isArgument and: [each isRead not]]]!

visibleVariablesDo: aMonadicValuable visited: aSet
	locals do: [:each | (aSet addNewElement: each name) ifTrue: [aMonadicValuable value: each]].
	outer visibleVariablesDo: aMonadicValuable visited: aSet! !
!Kernel.StLexicalScope categoriesForMethods!
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
markFarReturn!public!visiting! !
markNeedsSelf!public!visiting! !
needsContext!accessing!public! !
needsSelf!accessing!public! !
node!accessing!public! !
node:outer:!initializing!private! !
outer!accessing!public! !
outer:!accessing!public! !
printOn:!printing!public! !
realScope!accessing!public! !
resolveIdentifier:!operations!private! !
temporaries!accessing!private! !
thisContextVariable!accessing!public! !
unreferencedArguments!accessing!public! !
visibleVariablesDo:visited:!operations!public! !
!

