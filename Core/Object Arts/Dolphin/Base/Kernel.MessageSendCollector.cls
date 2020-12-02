"Filed out from Dolphin Smalltalk 7"!

InstructionInterpreter subclass: #MessageSendCollector
	instanceVariableNames: 'messageBlock superMessageBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'SendInstructions' -> #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: nil nil #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: nil nil nil nil nil nil nil nil nil nil nil nil #send: #supersend: #specialSend: nil nil nil nil nil nil nil #sendTempZeroArgs: nil nil nil nil #sendSelfZeroArgs: nil nil nil nil nil nil nil #longSend:with: #longSupersend:with: nil nil nil nil nil nil nil nil nil nil nil nil #exLongSend:with:with: #exLongSupersend:with:with: nil)
	}!
MessageSendCollector guid: (GUID fromString: '{5228f2f4-3ec1-4fdb-a520-c6e478fcd8ad}')!
MessageSendCollector comment: 'MessageSendCollector is an <InstructionInterpreter> that evaluates user supplied blocks against all the message send instructions it is dispatched. It is typically used to collect all the message sends in a method, hence the name.

Instance Variables:
	messageBlock			<monadicValuable>
	superMessageBlock		<monadicValuable>

'!
!MessageSendCollector categoriesForClass!Kernel-Objects! !
!MessageSendCollector methodsFor!

dispatchNext
	dispatcher dispatchNext!

initialize
	superMessageBlock := messageBlock := [:selector | ]!

messagesDo: aBlockClosure 
	superMessageBlock := messageBlock := aBlockClosure.
	self interpret!

sendSelector: aSymbol args: anObject 
	messageBlock value: aSymbol!

sendSelfSelector: aSymbol args: anObject 
	messageBlock value: aSymbol!

shortSpecialSend: anInteger
	"Interpret a Short Special Send instruction."

	"Implementation Note: This override is not strictly needed, but since we don't need the argument count 
	we can avoid the cost of asking a selector for its argument count."

	self sendSelector: (dispatcher selectorOfSpecialSend: anInteger) args: -1!

shortSpecialSendEx: anInteger
	"Interpret a Short Special Send instruction."

	"Implementation Note: This override is not strictly needed, but since we don't need the argument count 
	we can avoid the cost of asking a selector for its argument count."

	self sendSelector: (dispatcher selectorOfSpecialSendEx: anInteger) args: -1!

superMessagesDo: aBlockClosure 
	superMessageBlock := aBlockClosure.
	self interpret!

supersendSelector: aSymbol 
	superMessageBlock value: aSymbol! !
!MessageSendCollector categoriesFor: #dispatchNext!interpreting!private! !
!MessageSendCollector categoriesFor: #initialize!initializing!private! !
!MessageSendCollector categoriesFor: #messagesDo:!enumerating!public! !
!MessageSendCollector categoriesFor: #sendSelector:args:!interpreting!private! !
!MessageSendCollector categoriesFor: #sendSelfSelector:args:!interpreting!private! !
!MessageSendCollector categoriesFor: #shortSpecialSend:!instructions-sending!public! !
!MessageSendCollector categoriesFor: #shortSpecialSendEx:!instructions-sending!public! !
!MessageSendCollector categoriesFor: #superMessagesDo:!enumerating!public! !
!MessageSendCollector categoriesFor: #supersendSelector:!interpreting!private! !

!MessageSendCollector class methodsFor!

dispatcher: aByteCodeDispatcher
	"Configure the dispatcher to dispatch only the send instructions as processing the others is a waste of time."

	aByteCodeDispatcher instructions: SendInstructions.
	^super dispatcher: aByteCodeDispatcher!

initialize
	self addClassConstant: 'SendInstructions'
		value: (ByteCodeDispatcher instructions collect: [:each | ('*send*' match: each) ifTrue: [each]])! !
!MessageSendCollector class categoriesFor: #dispatcher:!instance creation!public! !
!MessageSendCollector class categoriesFor: #initialize!class initialization!development!public! !

