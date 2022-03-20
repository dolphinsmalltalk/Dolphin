"Filed out from Dolphin Smalltalk"!

TestCase subclass: #TestCaseProtocol
	instanceVariableNames: ''
	classVariableNames: 'IsStrict'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestCaseProtocol guid: (GUID fromString: '{403355e6-9806-435f-8bba-139199ccd171}')!
TestCaseProtocol isAbstract: true!
TestCaseProtocol comment: ''!
!TestCaseProtocol categoriesForClass!Unclassified! !
!TestCaseProtocol methodsFor!

asANSITestArray: arrays
	^arrays collect: 
			[:each |
			each
				collect: [:each1 | each1 = #true ifTrue: [true] ifFalse: [each1 = #false ifTrue: [false] ifFalse: [each1]]]]!

assertSend: aSelector 
	self assertSend: aSelector inProtocol: self protocol.!

assertSend: aSelector inProtocol: aSymbol 
	self assertSend: aSelector toObject: self canonicalObject inProtocol: aSymbol.!

assertSend: aSelector toObject: anObject inProtocol: aSymbol
	| opResult msgSpec |
	opResult := anObject perform: aSelector.
	msgSpec := (ProtocolSpec protocolNamed: aSymbol) messageOrNilAtSelector: aSelector.
	msgSpec isNil ifTrue: [self signalFailure: aSelector , ' is not in protocol ' , aSymbol].
	self assert: (msgSpec isConformingReturn: opResult)!

canonicalObject
	^self subclassResponsibility!

endOfLineSequence
	^String lineDelimiter!

isStrict
	^IsStrict!

msgSpecFor: msgSelector inProtocol: protocolName
	| msgSpec newEx |
	msgSpec := (ProtocolSpec protocolNamed: protocolName) messageAtSelector: msgSelector.
	"] on: Error do: [ :except |"
	"Generate TestFailure as if originally signaled in except's place."
	"		newEx := TestResult failure new.
		newEx messageText: except description.
		except resignalAs: newEx
	]"
	^msgSpec!

notDone
	"change this to self halt when you want to find all methods that are not done"!

selector: aSelector inProtocol: aSymbol behavesLike: arrays
	(self asANSITestArray: arrays) do: 
			[:each |
			self
				value: [each first perform: aSelector withArguments: (each copyFrom: 2 to: each size - 1)]
				should: [:r | r = each last]
				conformTo: aSymbol
				selector: aSelector]!

value: opBlock should: shouldBlock conformTo: protocolName selector: msgSelector
	"	self value: [2 = 2] should: [:result | result] conformTo: #'Object' selector: 
	#'='. "

	| msgSpec opResult |
	opResult := opBlock value.
	self assert: (shouldBlock value: opResult).
	[msgSpec := (ProtocolSpec protocolNamed: protocolName) messageAtSelector: msgSelector] on: Exception
		do: 
			[:except |
			"Generate TestFailure as if originally signaled in except's place."
			self signalFailure: except description].
	msgSpec isReturnValueSpecByRule ifTrue: [self signalFailure: 'Conformence failed - requires rule.'].
	(msgSpec isConformingReturn: opResult) ifFalse: [self signalFailure: 'Conformence failed']!

value: opBlock should: shouldBlock conformTo: protocolName selector: msgSelector opRECEIVER: receiver 
	"	| negFlt2 |	negFlt2 := -2.0. 
	self value: [negFlt2 abs] should: [:result | result = 2.0] 
	conformTo: #'number' selector: #'abs' opRECEIVER: negFlt2.
	"
	| msgSpec opResult |
	opResult := opBlock value.
	self assert: (shouldBlock value: opResult).
	msgSpec := self msgSpecFor: msgSelector inProtocol: protocolName.
	(msgSpec
		isConformingReturn: opResult
		opRECEIVER: receiver
		conformTo: protocolName
		selector: msgSelector)
		ifFalse: [self signalFailure: 'Conformence failed return RECEIVER: ' , receiver printString]!

value: opBlock should: shouldBlock conformTo: protocolName selector: msgSelector ruleReceiver: receiver 
	"	| negFlt2 |	negFlt2 := -2.0. 
	self value: [negFlt2 integerPart] should: [:result | result = -2] 
	conformTo: #'number' selector: #'integerPart' ruleReceiver: negFlt2.
	"
	| msgSpec opResult |
	opResult := opBlock value.
	self assert: (shouldBlock value: opResult).
	msgSpec := self msgSpecFor: msgSelector inProtocol: protocolName.
	msgSpec isReturnValueSpecByRule ifFalse: [TestResult failure signal: 'Conformence failed - requires rule.'].
	(msgSpec isConformingReturn: opResult ruleReceiver: receiver)
		ifFalse: [self signalFailure: 'Conformence failed rule value: ' , receiver printString]!

value: opBlock should: shouldBlock conformTo: protocolName selector: msgSelector
ruleReceiver: receiver operand: operand
"	| negInt2 posInt2 |	negInt2 := -2.	posInt2 := 2.
	self value: [negInt2 * posInt2] should: [:result | result = -4]
		conformTo: #'number' selector: #'*'
		ruleReceiver: negInt2 operand: posInt2"
	| msgSpec opResult |
	opResult := opBlock value.
	self assert: (shouldBlock value: opResult).
	msgSpec := self msgSpecFor: msgSelector inProtocol: protocolName.
	msgSpec isReturnValueSpecByRule 
		ifFalse: [self signalFailure: 'Conformence failed - requires rule.'].
	(msgSpec
		isConformingReturn: opResult
		ruleReceiver: receiver
		operand: operand
	) ifFalse: [self signalFailure: ('Conformence failed rule value: ', receiver printString, ' rec: ', operand printString)].!

value: opBlock shouldnt: shouldNotBlock conformTo: protocolName
selector: msgSelector
"	self value: [2 = -2]
		shouldnt: [:result | result] conformTo: #'Object' selector: #'='.
"
	self value: opBlock
		should: [:result | (shouldNotBlock value: result) not]
		conformTo: protocolName
		selector: msgSelector!

value: opBlock shouldnt: shouldNotBlock conformTo: protocolName
selector: msgSelector 
opRECEIVER: receiver
"	| negFlt2 |	negFlt2 := -2.0.
	self value: [negFlt2 abs] shouldnt: [:result | result = 0.0]
		conformTo: #'number' selector: #'abs' opRECEIVER: negFlt2.
"
	self value: opBlock
		should: [:result | (shouldNotBlock value: result) not]
		conformTo: protocolName
		selector: msgSelector
		opRECEIVER: receiver!

value: opBlock shouldnt: shouldNotBlock conformTo: protocolName
selector: msgSelector ruleReceiver: receiver
"	| negFlt2 |	negFlt2 := -2.0.
	self value: [negFlt2 integerPart]
		shouldnt: [:result | result = 2]
		conformTo: #'number' selector: #'integerPart' ruleReceiver: negFlt2.
"
	self value: opBlock
		should: [:result | (shouldNotBlock value: result) not]
		conformTo: protocolName
		selector: msgSelector
		ruleReceiver: receiver!

value: opBlock shouldnt: shouldNotBlock
conformTo: protocolName selector: msgSelector
ruleReceiver: receiver operand: operand
"	| negInt2 posInt2 |	negInt2 := -2.	posInt2 := 2.
	self value: [negInt2 * posInt2] shouldnt: [:result | result = 4]
		conformTo: #'number' selector: #'*'
		ruleReceiver: negInt2 operand: posInt2.
"
	self value: opBlock
		should: [:result | (shouldNotBlock value: result) not]
		conformTo: protocolName
		selector: msgSelector
		ruleReceiver: receiver
		operand: operand!

value: aBlockContext shouldRaise: anException
	| ok |
	#'ACSUEnh'. 
	ok := [ aBlockContext value. false ] on: anException do: [:ex | ex return: true ].
	self assert: ok! !
!TestCaseProtocol categoriesForMethods!
asANSITestArray:!public! !
assertSend:!public! !
assertSend:inProtocol:!public! !
assertSend:toObject:inProtocol:!public! !
canonicalObject!public! !
endOfLineSequence!private! !
isStrict!public! !
msgSpecFor:inProtocol:!public! !
notDone!public! !
selector:inProtocol:behavesLike:!public! !
value:should:conformTo:selector:!public! !
value:should:conformTo:selector:opRECEIVER:!public! !
value:should:conformTo:selector:ruleReceiver:!public! !
value:should:conformTo:selector:ruleReceiver:operand:!public! !
value:shouldnt:conformTo:selector:!public! !
value:shouldnt:conformTo:selector:opRECEIVER:!public! !
value:shouldnt:conformTo:selector:ruleReceiver:!public! !
value:shouldnt:conformTo:selector:ruleReceiver:operand:!public! !
value:shouldRaise:!public! !
!

!TestCaseProtocol class methodsFor!

initialize
	"Allow certain traditional implementation transgressions against the standard as written. Given that it was an objective of the standards committee that the standard should not make existing traditional implementations of core protocols automatically non-compliant, there are probably areas of the standard that are either too strict (and perhaps certain behaviours should have been left undefined), and there are of course also some errors."

	IsStrict := false!

testMethods
^self selectors select: [:each | 'test*' match: each].! !
!TestCaseProtocol class categoriesForMethods!
initialize!public! !
testMethods!public! !
!

