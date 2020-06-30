"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ExternalResourceLibraryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalResourceLibraryTest guid: (GUID fromString: '{53144b4f-aa74-4ab2-a1c5-7b9c8f0fffec}')!
ExternalResourceLibraryTest comment: ''!
!ExternalResourceLibraryTest categoriesForClass!Unclassified! !
!ExternalResourceLibraryTest methodsFor!

testLibrariesRegister
	self deny: ExternalResourceLibrary.Libraries hasWeakKeys.
	self assert: ExternalResourceLibrary.Libraries hasWeakValues.! !
!ExternalResourceLibraryTest categoriesFor: #testLibrariesRegister!public! !

