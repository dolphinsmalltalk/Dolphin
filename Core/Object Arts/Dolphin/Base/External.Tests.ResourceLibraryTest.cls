"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'External.Tests.ResourceLibraryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.ResourceLibraryTest guid: (Core.GUID fromString: '{53144b4f-aa74-4ab2-a1c5-7b9c8f0fffec}')!
External.Tests.ResourceLibraryTest comment: ''!
!External.Tests.ResourceLibraryTest categoriesForClass!Unclassified! !
!External.Tests.ResourceLibraryTest methodsFor!

testLibrariesRegister
	self deny: ResourceLibrary.Libraries hasWeakKeys.
	self assert: ResourceLibrary.Libraries hasWeakValues.! !
!External.Tests.ResourceLibraryTest categoriesFor: #testLibrariesRegister!public! !

