"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.GUIDTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.GUIDTest guid: (Core.GUID fromString: '{d26741d7-8e33-457e-8ba7-817a6f36b193}')!
Core.Tests.GUIDTest comment: ''!
!Core.Tests.GUIDTest methodsFor!

testSpaceships
	| subject null |
	subject := GUID newUnique.
	null := GUID null.
	self assert: subject <=> null equals: 1.
	self assert: subject <==> null equals: 1.
	self assert: subject <=> subject equals: 0.
	self assert: subject <==> subject equals: 0.
	self assert: null <=> subject equals: -1.
	self assert: null <==> subject equals: -1.
	self assert: null <=> null equals: 0.
	self assert: null <==> null equals: 0.
	! !
!Core.Tests.GUIDTest categoriesForMethods!
testSpaceships!public!unit tests! !
!

