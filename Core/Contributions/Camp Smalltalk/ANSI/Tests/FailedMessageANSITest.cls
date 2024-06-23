"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #FailedMessageANSITest
	instanceVariableNames: 'failedMsg'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FailedMessageANSITest guid: (GUID fromString: '{5ff43c19-14d8-4626-8169-a70eb12eb4ef}')!

FailedMessageANSITest comment: ''!

!FailedMessageANSITest categoriesForClass!Unclassified! !

!FailedMessageANSITest methodsFor!

canonicalObject
	"Return a Message object, which is created when the VM traps a misunderstood message"
	^failedMsg!

protocol
	^#'failedMessage'!

setUp
	"Make a failed message and put it in failedMsg"
	super setUp.
	[nil foo] on: MessageNotUnderstood do: [:ex | failedMsg := ex message].!

testXarguments
	" <failedMessage>#arguments "
	#'Fundamental'.

#todo. "???
	self op: [failedMsg := nil.
			self + 1.
			failedMsg arguments]
		should: [:r | r size = 1 & (r first = 1) ]
		conformTo: #'failedMessage' selector: #'arguments'.

	self op: [failedMsg := nil.
			self dum.
			failedMsg arguments]
		should: [:r | r size = 0]
		conformTo: #'failedMessage' selector: #'arguments'.

	self op: [failedMsg := nil.
			self dum: 1 dum: 2 dum: 3.
			failedMsg arguments]
		should: [:r | r size = 3 & (r first = 1) & (r last = 3) ]
		conformTo: #'failedMessage' selector: #'arguments'.

???"!

testXselector
	" <failedMessage>#selector "
	#'Fundamental'.

#todo. "???
	self op: [failedMsg := nil.
			self + 1.
			failedMsg selector]
		should: [:r | r = #'+']
		conformTo: #'failedMessage' selector: #'selector'.

	self op: [failedMsg := nil.
			self dum.
			failedMsg selector]
		should: [:r | r = #'dum']
		conformTo: #'failedMessage' selector: #'selector'.

	self op: [failedMsg := nil.
			self dum: 1 dum: 2 dum: 3.
			failedMsg selector]
		should: [:r | r = #'dum:dum:dum:']
		conformTo: #'failedMessage' selector: #'selector'.

???"! !

!FailedMessageANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!public! !
testXarguments!public! !
testXselector!public! !
!

