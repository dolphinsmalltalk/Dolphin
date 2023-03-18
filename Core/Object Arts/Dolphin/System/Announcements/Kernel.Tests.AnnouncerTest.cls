"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'Kernel.Tests.AnnouncerTest'
	instanceVariableNames: 'announcer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.AnnouncerTest guid: (Core.GUID fromString: '{4fe1d4e3-9cb9-4d37-bb20-d8441f9eeb1e}')!
Kernel.Tests.AnnouncerTest comment: 'An AnnouncerTest is a test class used to test Announcer.

Instance Variables
	announcer:		<Announcer>  the announcer to test

announcer
	- the announcer that is tested
'!
!Kernel.Tests.AnnouncerTest categoriesForClass!Announcements-Tests-Core-Tests! !
!Kernel.Tests.AnnouncerTest methodsFor!

newAnnouncer
	^Announcer new!

setUp
	super setUp.
	announcer := self newAnnouncer!

testAnnounceClass
	self assert: (announcer announce: AnnouncementMockA) class
		equals: AnnouncementMockA!

testAnnounceInstance
	| instance |
	instance := AnnouncementMockA new.
	self assert: (announcer announce: instance) equals: instance!

testAnnouncingReentrant
	" Test that it is safe to announce when handling announcement,
	so announcer are reentrant "

	" self run: #testAnnouncingReentrant "

	| bool ok |
	ok := bool := false.
	announcer when: Announcement
		do: 
			[bool
				ifFalse: 
					[bool := true.
					announcer announce: Announcement new]
				ifTrue: [ok := true]].
	announcer announce: Announcement new.
	self assert: ok!

testNoArgBlock
	"we are supposed to accept zero-argument blocks as actions "

	| counter |
	counter := nil.
	announcer subscribe: AnnouncementMockA do: [counter := 1].
	announcer announce: AnnouncementMockA new.
	self assert: counter equals: 1!

testSubscribeBlock
	| announcement instance |
	announcer subscribe: AnnouncementMockA do: [:ann | announcement := ann].
	announcement := nil.
	instance := announcer announce: AnnouncementMockA.
	self assert: announcement equals: instance.
	announcement := nil.
	instance := announcer announce: AnnouncementMockB.
	self assertIsNil: announcement!

testSubscribeSend
	| announcement instance |
	announcer
		subscribe: AnnouncementMockA
		send: #value:
		to: [:ann | announcement := ann].
	announcement := nil.
	instance := announcer announce: AnnouncementMockA.
	self assert: announcement equals: instance.
	announcement := nil.
	instance := announcer announce: AnnouncementMockB new.
	self assertIsNil: announcement!

testSubscribeSet
	| announcement instance |
	announcer subscribe: AnnouncementMockA , AnnouncementMockC
		do: [:ann | announcement := ann].
	announcement := nil.
	instance := announcer announce: AnnouncementMockA.
	self assert: announcement equals: instance.
	announcement := nil.
	instance := announcer announce: AnnouncementMockB.
	self assertIsNil: announcement.
	announcement := nil.
	instance := announcer announce: AnnouncementMockC.
	self assert: announcement equals: instance!

testSubscribeSubclass
	| announcement instance |
	announcer subscribe: AnnouncementMockB do: [:ann | announcement := ann].
	announcement := nil.
	instance := announcer announce: AnnouncementMockA.
	self assertIsNil: announcement.
	announcement := nil.
	instance := announcer announce: AnnouncementMockB.
	self assert: announcement equals: instance.
	announcement := nil.
	instance := announcer announce: AnnouncementMockC.
	self assert: announcement equals: instance!

testSymbolIdentifier
	| passed |
	passed := false.
	
	[announcer
		when: #FOO
			send: #bar
			to: nil;
		announce: #FOO] on: MessageNotUnderstood
			do: [:ex | passed := ex message selector = #bar].
	self assert: passed!

testTwoArgBlock
	"we are supposed to accept two-argument blocks as actions "

	| flag |
	flag := false.
	announcer subscribe: AnnouncementMockA
		do: [:ann :announcer2 | flag := announcer2 == announcer].
	announcer announce: AnnouncementMockA new.
	self assert: flag!

testUnsubscribeBlock
	| announcement receiver |
	announcer subscribe: AnnouncementMockA do: (receiver := [:ann | announcement := ann]).
	announcer unsubscribe: receiver.
	announcement := nil.
	announcer announce: AnnouncementMockA new.
	self assertIsNil: announcement!

testUnsubscribeSend
	| announcement receiver |
	announcer
		subscribe: AnnouncementMockA
		send: #value:
		to: (receiver := [:ann | announcement := ann]).
	announcer unsubscribe: receiver.
	announcement := nil.
	announcer announce: AnnouncementMockA new.
	self assertIsNil: announcement!

testUnsubscribeSet
	| announcement receiver |
	announcer subscribe: AnnouncementMockA , AnnouncementMockB
		do: (receiver := [:ann | announcement := ann]).
	announcer unsubscribe: receiver.
	announcement := nil.
	announcer announce: AnnouncementMockA new.
	self assertIsNil: announcement.
	announcement := nil.
	announcer announce: AnnouncementMockB new.
	self assertIsNil: announcement! !
!Kernel.Tests.AnnouncerTest categoriesForMethods!
newAnnouncer!private! !
setUp!private!running! !
testAnnounceClass!public!testing! !
testAnnounceInstance!public!testing! !
testAnnouncingReentrant!public!testing! !
testNoArgBlock!public!testing! !
testSubscribeBlock!public!testing! !
testSubscribeSend!public!testing! !
testSubscribeSet!public!testing! !
testSubscribeSubclass!public!testing! !
testSymbolIdentifier!public!testing! !
testTwoArgBlock!public!testing! !
testUnsubscribeBlock!public!testing! !
testUnsubscribeSend!public!testing! !
testUnsubscribeSet!public!testing! !
!

!Kernel.Tests.AnnouncerTest class methodsFor!

shouldInheritSelectors
	^ true! !
!Kernel.Tests.AnnouncerTest class categoriesForMethods!
shouldInheritSelectors!public!testing! !
!

