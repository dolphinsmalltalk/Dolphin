"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #AnnouncementSetTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AnnouncementSetTest guid: (GUID fromString: '{9dc83cf2-59b5-4c23-9dc7-c8b79487aa22}')!
AnnouncementSetTest comment: 'SUnit tests for announcement sets'!
!AnnouncementSetTest categoriesForClass!Announcements-Tests-Core-Tests! !
!AnnouncementSetTest methodsFor!

testIncludeOnlyOnce
	| set |
	set := AnnouncementMockA , AnnouncementMockB , AnnouncementMockA.
	self assert: set size equals: 2!

testInstanceCreation
	| set |
	set := AnnouncementMockA , AnnouncementMockB.
	self assert: set size equals: 2! !
!AnnouncementSetTest categoriesFor: #testIncludeOnlyOnce!public!testing! !
!AnnouncementSetTest categoriesFor: #testInstanceCreation!public!testing! !

