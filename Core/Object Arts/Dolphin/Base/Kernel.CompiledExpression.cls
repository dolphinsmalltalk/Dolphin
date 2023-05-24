"Filed out from Dolphin Smalltalk"!

Kernel.CompiledCode
	variableSubclass: #'Kernel.CompiledExpression'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CompiledExpression guid: (Core.GUID fromString: '{87b4c543-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.CompiledExpression comment: 'CompiledExpression is the class of CompiledCode objects representing unbound compiled expressions, i.e. compiled code resulting from the compilation of arbitrary code segments, rather than actual methods of objects (see also CompiledMethod).

'!
!Kernel.CompiledExpression categoriesForClass!Kernel-Methods! !
!Kernel.CompiledExpression methodsFor!

evaluate: aString for: anObject evaluationPools: anArrayOfPools
	"Private - Evaluate the receiver (whose source is aString), with the receiver, anObject, 
	within the additional compilation context, anArrayOfPools.
	N.B. This message is sent by the compiler to evaluate constant expressions
	DO NOT REMOVE IT."

	self storeSourceString: aString evaluationPools: anArrayOfPools.
	^self value: anObject!

evaluationPools
	"Answer the evaluation pools used to compiler the receiver, or nil if none."

	| descrip |
	descrip := self sourceDescriptor.
	^descrip isString ifFalse: [descrip at: 2]!

expressionClass
	| exprClass |
	exprClass := self methodClass.
	^exprClass == UndefinedObject ifFalse: [exprClass]!

getDebugInfo
	"Private - Invoke the compiler to answer a compilation result containing a 
	recompilation of the receiver, a map between IP ranges and expressions 
	in the source, and a map between IP ranges 	and an OrderedCollection of 
	Associations between IP positions and temporaries up to that position in 
	the receiver, ordered by IP."

	^self compilerClass
		debugInfoForExpression: self getSource
		in: self expressionClass
		environment: self customEnvironment
		evaluationPools: self evaluationPools
		debug: self isDebugMethod!

getSource
	"Answer the source of the receiver."

	| descrip |
	descrip := self sourceDescriptor.
	^descrip isString ifTrue: [descrip] ifFalse: [descrip at: 1]!

isExpression
	"Private - Answer whether the receiver is a standalone (unbound) expression as opposed to 
	a method."

	^true!

owningPackage
	^self methodClass owningPackage!

storeSourceString: aString evaluationPools: anArray
	"Private - Ask the receiver's source manager to record its expression 
	source, aString, logging the evaluation to the change log if requested."

	| pools |
	pools := anArray notNil
				ifTrue: 
					[| nonEmptyPools |
					nonEmptyPools := anArray reject: [:each | each isEmpty].
					nonEmptyPools notEmpty ifTrue: [nonEmptyPools]].
	self sourceDescriptor: (pools isNil ifTrue: [aString] ifFalse: [{aString. pools}])!

suppressionId
	^sourceDescriptor hash!

value
	"Evaluate the expression with nil as 'self'."

	^self value: nil!

value: anObject
	"Evaluate the receiver with the argument, anObject, as its receiver, answering the result."

	^self value: anObject withArguments: #()! !
!Kernel.CompiledExpression categoriesForMethods!
evaluate:for:evaluationPools:!evaluating!private! !
evaluationPools!accessing!development!public! !
expressionClass!accessing!private! !
getDebugInfo!development!private! !
getSource!accessing!development!public! !
isExpression!private!testing! !
owningPackage!accessing!public! !
storeSourceString:evaluationPools:!accessing!private! !
suppressionId!accessing!private! !
value!evaluating!public! !
value:!evaluating!public! !
!

