"Filed out from Dolphin Smalltalk"!

Kernel.InstructionInterpreter
	subclass: #LiteralReferenceCollector
	instanceVariableNames: 'referenceCounts lastReferenced'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
LiteralReferenceCollector guid: (Core.GUID fromString: '{298ab962-1bef-4ec2-aef3-947eda9812d2}')!
LiteralReferenceCollector comment: ''!
!LiteralReferenceCollector methodsFor!

countLiteralReferences
	self
		reset;
		interpret.
	^self!

lastReferenced
	^lastReferenced!

literalReferenced: literalOffset
	"Note that the literal 'index' argument is a byte code index, so zero-based."

	| i |
	i := literalOffset + 1.
	referenceCounts at: i put: (referenceCounts at: i) + 1.
	i > lastReferenced ifTrue: [lastReferenced := i]!

popStatic: literalOffset
	"Interpret a Pop And Store Literal Variable instruction."

	self literalReferenced: literalOffset!

pushConst: literalOffset
	"Private - Interpret a Push Literal Constant instruction."

	self literalReferenced: literalOffset!

pushStatic: literalOffset
	"Private - Interpret a Short Push Literal Variable instruction."

	self literalReferenced: literalOffset!

reset
	| method |
	super reset.
	method := self method.
	referenceCounts := Array new: method literalCount withAll: 0.
	lastReferenced := 0.
	method isAnnotated ifTrue: [self literalReferenced: method size - 1].
	(method isExternalCall or: 
			[| extra |
			extra := method extraIndex.
			extra == CompiledCode.ReturnLiteralConstant0 or: [extra == CompiledCode.ReturnLiteralStatic0]])
		ifTrue: [self literalReferenced: 0]!

send: literalOffset args: argumentCount
	"Private - Interpret a Send [N]with M args instruction."

	self literalReferenced: literalOffset!

storeStatic: literalOffset
	"Private - Interpret a Store Literal Variable instruction."

	self literalReferenced: literalOffset!

supersend: literalOffset args: argumentCount
	"Private - Interpret a Supersend [N] with M args instruction."

	self literalReferenced: literalOffset! !
!LiteralReferenceCollector categoriesForMethods!
countLiteralReferences!public! !
lastReferenced!accessing!public! !
literalReferenced:!interpreting!private! !
popStatic:!instructions-stack ops!public! !
pushConst:!instructions-stack ops!private! !
pushStatic:!instructions-stack ops!private! !
reset!positioning!public! !
send:args:!interpreting!private! !
storeStatic:!instructions-stack ops!private! !
supersend:args:!interpreting!private! !
!

!LiteralReferenceCollector class methodsFor!

countLiteralReferencesIn: aCompiledMethod
	^(self method: aCompiledMethod)
		reset;
		interpret;
		yourself! !
!LiteralReferenceCollector class categoriesForMethods!
countLiteralReferencesIn:!instance creation!public! !
!

