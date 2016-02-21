"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #AnnouncementSetTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AnnouncementSetTest guid: (GUID fromString: '{9DC83CF2-59B5-4C23-9DC7-C8B79487AA22}')!
AnnouncementSetTest comment: 'SUnit tests for announcement sets'!
!AnnouncementSetTest categoriesForClass!Announcements-Tests-Core-Tests! !
!AnnouncementSetTest methodsFor!

testIncludeOnlyOnce	|set|	set := AnnouncementMockA, AnnouncementMockB, AnnouncementMockA.	self assert: set size = 2!

testInstanceCreation	|set|	set := AnnouncementMockA, AnnouncementMockB.	self assert: set size = 2 ! !
!AnnouncementSetTest categoriesFor: #testIncludeOnlyOnce!public!testing! !
!AnnouncementSetTest categoriesFor: #testInstanceCreation!public!testing! !

