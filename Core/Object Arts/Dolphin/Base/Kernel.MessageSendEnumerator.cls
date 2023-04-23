"Filed out from Dolphin Smalltalk"!

Kernel.MessageSendInterpreter
	subclass: #'Kernel.MessageSendEnumerator'
	instanceVariableNames: 'messageBlock superMessageBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.MessageSendEnumerator guid: (Core.GUID fromString: '{5228f2f4-3ec1-4fdb-a520-c6e478fcd8ad}')!
Kernel.MessageSendEnumerator comment: '`MessageSendCollector` is an `InstructionInterpreter` that evaluates user supplied blocks against all the message send instructions it is dispatched.

## Instance Variables:
  `messageBlock`		`<monadicValuable>`
  `superMessageBlock`	`<monadicValuable>`

'!
!Kernel.MessageSendEnumerator categoriesForClass!Kernel-Objects! !
!Kernel.MessageSendEnumerator methodsFor!

initialize
	superMessageBlock := messageBlock := [:selector | ]!

messagesDo: aBlockClosure 
	superMessageBlock := messageBlock := aBlockClosure.
	self interpret!

sendSelector: aSymbol args: anInteger 
	messageBlock value: aSymbol!

shortSpecialSend: anInteger
	"Private - Enumerate a Short Special Send instruction."

	messageBlock value: (VM selectorOfSpecialSend: anInteger)!

shortSpecialSendEx: anInteger
	"Private - Enumerate a Short Special Send instruction."

	messageBlock value: (VM selectorOfSpecialSendEx: anInteger)!

superMessagesDo: aBlockClosure 
	superMessageBlock := aBlockClosure.
	self interpret!

supersend: literalIndex args: argumentCount
	"Private - Interpret a Supersend [N] with M args instruction."

	superMessageBlock value: (method basicAt: literalIndex + 1)! !
!Kernel.MessageSendEnumerator categoriesForMethods!
initialize!initializing!private! !
messagesDo:!enumerating!public! !
sendSelector:args:!private! !
shortSpecialSend:!instructions-sending!private! !
shortSpecialSendEx:!instructions-sending!private! !
superMessagesDo:!enumerating!public! !
supersend:args:!interpreting!private! !
!

