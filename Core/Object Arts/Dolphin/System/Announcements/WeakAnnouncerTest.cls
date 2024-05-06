"Filed out from Dolphin Smalltalk"!

AnnouncerTest subclass: #WeakAnnouncerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WeakAnnouncerTest guid: (GUID fromString: '{26a69917-162e-4a6f-8383-df020cbf176f}')!

WeakAnnouncerTest comment: 'SUnit tests for weak announcements'!

!WeakAnnouncerTest categoriesForClass!Announcements-Tests-Core-Tests! !

!WeakAnnouncerTest methodsFor!

testNoWeakBlock
	"Blocks are never weak"

	| counter subscription |
	counter := 0.
	subscription := announcer subscribe: AnnouncementMockA do: [:ann | counter := counter + 1].
	MemoryManager current collectGarbage.
	announcer announce: AnnouncementMockA.
	self assert: counter equals: 1.
	subscription makeWeak.
	MemoryManager current collectGarbage.
	announcer announce: AnnouncementMockA.
	self assert: counter equals: 2!

testWeakObject
	| counter collector forwarder |
	counter := 0.
	collector := [counter := counter + 1].
	forwarder := MessageSend receiver: collector selector: #value.
	(announcer
		subscribe: AnnouncementMockA
		send: #value
		to: forwarder) makeWeak.

	" shouldn't go away, we are still holding a reference to 'forwarder': "
	MemoryManager current collectGarbage.
	announcer announce: AnnouncementMockA.
	self assert: counter equals: 1.

	" should go away as we let the only reference to 'forwarder' go: "
	forwarder := nil.
	MemoryManager current collectGarbage.
	announcer announce: AnnouncementMockA.
	self assert: counter equals: 1!

testWeakSubscription
	| obj subscription |
	obj := Object new.
	subscription := (announcer
				when: AnnouncementMockA
				send: #value
				to: obj) makeWeak.
	self assert: obj identicalTo: subscription subscriber! !

!WeakAnnouncerTest categoriesForMethods!
testNoWeakBlock!public!testing! !
testWeakObject!public!testing! !
testWeakSubscription!public!testing! !
!

