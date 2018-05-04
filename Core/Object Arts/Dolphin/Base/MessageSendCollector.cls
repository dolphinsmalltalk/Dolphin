"Filed out from Dolphin Smalltalk 7"!

InstructionInterpreter subclass: #MessageSendCollector
	instanceVariableNames: 'messageBlock superMessageBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

