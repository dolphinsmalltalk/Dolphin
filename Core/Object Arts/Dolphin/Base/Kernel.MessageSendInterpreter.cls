"Filed out from Dolphin Smalltalk"!

Kernel.InstructionInterpreter
	subclass: #'Kernel.MessageSendInterpreter'
	instanceVariableNames: 'method'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'SendInstructions'
				-> #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #incrementStackTop #decrementStackTop nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #isZero nil #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: nil nil nil nil nil nil nil nil nil nil nil nil nil #send: #supersend: #specialSend: nil nil nil nil nil nil nil #sendTempZeroArgs: nil nil nil nil #sendSelfZeroArgs: nil nil nil nil nil nil nil #longSend:with: #longSupersend:with: nil nil nil nil nil nil nil #incTemp:temp: #incPushTemp:temp: #decTemp:temp: #decPushTemp:temp: nil #exLongSend:with:with: #exLongSupersend:with:with: nil)
		}!
Kernel.MessageSendInterpreter guid: (Core.GUID fromString: '{e9ff00d3-cfbe-4ed1-aa6e-747d701c9b85}')!
Kernel.MessageSendInterpreter isNonInstantiable: true!
Kernel.MessageSendInterpreter comment: ''!
!Kernel.MessageSendInterpreter methodsFor!

decPushTemp: arg1 temp: offset
	self sendSelector: #- args: 1!

decrementStackTop
	self sendSelector: #- args: 1!

decTemp: arg1 temp: offset
	self sendSelector: #- args: 1!

dispatcher: aByteCodeDispatcher 
	method := aByteCodeDispatcher method.
	super dispatcher: aByteCodeDispatcher!

incPushTemp: arg1 temp: offset
	self sendSelector: #+ args: 1!

incrementStackTop
	self sendSelector: #+ args: 1!

incTemp: arg1 temp: offset
	self sendSelector: #+ args: 1!

isZero
	self sendSelector: #== args: 1!

method
	"Answer the <CompiledMethod> which the receiver is decoding."

	^method!

send: extensionByte
	self sendSelector: (method basicAt: (extensionByte bitAnd: 31) + 1)
		args: (extensionByte bitShift: -5)!

sendSelector: aSymbol args: anInteger
	self subclassResponsibility!

sendSelfZeroArgs: anInteger
	self sendSelector: (method basicAt: anInteger + 1) args: 0!

sendTempZeroArgs: anInteger
	"Interpret a Send [N] to Temp [M] with 0 Args instruction."

	self sendSelector: (method basicAt: (anInteger bitAnd: 16r1F) + 1) args: 0!

shortSendOneArg: literalIndex
	self sendSelector: (method basicAt: literalIndex + 1) args: 1!

shortSendSelfZeroArgs: anInteger
	"Interpret a Short Send Self [N] with 0 Args instruction."

	self sendSelector: (method basicAt: anInteger + 1) args: 0!

shortSendTwoArgs: literalIndex
	self sendSelector: (method basicAt: literalIndex + 1) args: 2!

shortSendZeroArgs: literalIndex
	self sendSelector: (method basicAt: literalIndex + 1) args: 0!

shortSpecialSend: anInteger
	"Interpret a Short Special Send instruction."

	self sendSelector: (VM selectorOfSpecialSend: anInteger) args: 0!

shortSpecialSendEx: anInteger
	"Interpret a Short Special Send instruction."

	self sendSelector: (VM selectorOfSpecialSendEx: anInteger) args: 0!

supersend: literalIndex args: argumentCount
	"Private - Interpret a Supersend [N] with M args instruction."

	self subclassResponsibility! !
!Kernel.MessageSendInterpreter categoriesForMethods!
decPushTemp:temp:!instructions-stack ops!public! !
decrementStackTop!instructions-miscellaneous!public! !
decTemp:temp:!instructions-miscellaneous!public! !
dispatcher:!initializing!public! !
incPushTemp:temp:!instructions-stack ops!public! !
incrementStackTop!instructions-miscellaneous!public! !
incTemp:temp:!instructions-miscellaneous!public! !
isZero!instructions-miscellaneous!public! !
method!accessing!public! !
send:!instructions-sending!public! !
sendSelector:args:!interpreting!private! !
sendSelfZeroArgs:!instructions-sending!public! !
sendTempZeroArgs:!instructions-sending!public! !
shortSendOneArg:!instructions-sending!public! !
shortSendSelfZeroArgs:!instructions-sending!public! !
shortSendTwoArgs:!instructions-sending!public! !
shortSendZeroArgs:!instructions-sending!public! !
shortSpecialSend:!instructions-sending!public! !
shortSpecialSendEx:!instructions-sending!public! !
supersend:args:!interpreting!private! !
!

!Kernel.MessageSendInterpreter class methodsFor!

dispatcher: aByteCodeDispatcher
	"Configure the dispatcher to dispatch only the send instructions as processing the others is a waste of time."

	aByteCodeDispatcher instructions: SendInstructions.
	^super dispatcher: aByteCodeDispatcher!

initialize
	self addClassConstant: 'SendInstructions'
		value: (ByteCodeDispatcher instructions
				collect: [:each | (#('*send*' 'inc*' 'dec*' 'isZero') anySatisfy: [:pattern | pattern match: each]) ifTrue: [each]])! !
!Kernel.MessageSendInterpreter class categoriesForMethods!
dispatcher:!instance creation!public! !
initialize!class initialization!development!public! !
!

