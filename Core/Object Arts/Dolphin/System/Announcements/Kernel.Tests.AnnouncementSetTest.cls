"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'Kernel.Tests.AnnouncementSetTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.AnnouncementSetTest guid: (Core.GUID fromString: '{9dc83cf2-59b5-4c23-9dc7-c8b79487aa22}')!
Kernel.Tests.AnnouncementSetTest comment: 'SUnit tests for announcement sets'!
!Kernel.Tests.AnnouncementSetTest categoriesForClass!Announcements-Tests-Core-Tests! !
!Kernel.Tests.AnnouncementSetTest methodsFor!

testIncludeOnlyOnce
	| set |
	set := AnnouncementMockA , AnnouncementMockB , AnnouncementMockA.
	self assert: set size equals: 2!

testInstanceCreation
	| set |
	set := AnnouncementMockA , AnnouncementMockB.
	self assert: set size equals: 2! !
!Kernel.Tests.AnnouncementSetTest categoriesForMethods!
testIncludeOnlyOnce!public!testing! !
testInstanceCreation!public!testing! !
!

