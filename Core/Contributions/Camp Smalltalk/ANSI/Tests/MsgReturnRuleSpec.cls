"Filed out from Dolphin Smalltalk"!

MsgReturnSpec subclass: #MsgReturnRuleSpec
	instanceVariableNames: 'ruleSourceCode ruleBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MsgReturnRuleSpec guid: (GUID fromString: '{884d8673-6298-4068-b920-fc07e0d7c86f}')!

MsgReturnRuleSpec comment: ''!

!MsgReturnRuleSpec categoriesForClass!Unclassified! !

!MsgReturnRuleSpec methodsFor!

isConformingReturnClass: returnClass ruleReceiver: receiver 
	"Answer true if the class, returnClass, of the result of sending a message conforms to the receiver, else false."

	| returnProtocolName |
	#todo.	"??? bug does not allow return in block ???"
	returnProtocolName := self ruleBlock value: receiver.
	^returnClass conformsToAnsiProtocolNamed: returnProtocolName!

isConformingReturnClass: returnClass ruleReceiver: receiver operand: operand 
	"Answer true if the class, returnClass, of the result of sending a message conforms to the receiver, else false."

	| returnProtocolName |
	#todo.	"??? bug does not allow return in block ???"
	returnProtocolName := self ruleBlock value: receiver value: operand.
	^returnClass conformsToAnsiProtocolNamed: returnProtocolName!

newRetValRuleSourceCode: ruleBlockSource 
	"Private - ."

	ruleBlock := nil.
	ruleSourceCode := ruleBlockSource.
	(ruleSourceCode includes: $^) ifFalse: [^self].
	ruleSourceCode := ruleSourceCode select: [:c | c ~~ $^]!

printOn: targetStream 
	"Append to targetStream a text representation of the receiver as a developer would want to see it (inspector, etc)."

	targetStream nextPutAll: self class name;
	 nextPut: $(;
	 nextPutAll: self returnValueRuleBlockSource;
	 nextPut: $)!

returnProtocolName: receiver

	^self ruleBlock value: receiver!

returnValueAliasingAttribute
	"Signal an error as the receiver specifies no behavior."

	self error: 'Protocol msg. return value rule specifies no aliasing attribute.'!

returnValueProtocolNames
	"Signal an error as the receiver specifies no behavior."

	self error: 'Protocol msg. return value rule specifies no protocol.'!

returnValueRuleBlockSource
	"Answer the rule block source code that when evaluated with appropiate values answers the protocol message return value conforms-to protocol name."

	^ ruleSourceCode!

returnValueRuleBlockSource: blockSource 
	"Set the rule block source code that when evaluated with appropiate values answers the protocol message return value conforms-to protocol name."

	ruleBlock := nil.
	ruleSourceCode := blockSource.
	(ruleSourceCode includes: $^) ifFalse: [^self].
	ruleSourceCode := ruleSourceCode select: [:c | c ~~ $^]!

ruleBlock

	ruleBlock isNil ifTrue: [ruleBlock := Compiler evaluate: ruleSourceCode].
	^ruleBlock! !

!MsgReturnRuleSpec categoriesForMethods!
isConformingReturnClass:ruleReceiver:!public! !
isConformingReturnClass:ruleReceiver:operand:!public! !
newRetValRuleSourceCode:!public! !
printOn:!public! !
returnProtocolName:!public! !
returnValueAliasingAttribute!public! !
returnValueProtocolNames!public! !
returnValueRuleBlockSource!public! !
returnValueRuleBlockSource:!public! !
ruleBlock!public! !
!

!MsgReturnRuleSpec class methodsFor!

newRetValRuleSourceCode: ruleBlockSource 
	"Answer a new return value specification representing a protocol message's return value conforms-to protocol determined by evaluating the rule, ruleBlockSource, with appropiate values."

	^ self privateNewRetValRuleSourceCode: ruleBlockSource!

privateNewRetValRuleSourceCode: ruleBlockSource 
	"Private - ."

	(ruleBlockSource isKindOf: String)
		ifFalse: [self error: 'Protocol msg. return value rule block source not a String.'].
	^ self basicNew newRetValRuleSourceCode: ruleBlockSource;
	 yourself! !

!MsgReturnRuleSpec class categoriesForMethods!
newRetValRuleSourceCode:!public! !
privateNewRetValRuleSourceCode:!public! !
!

