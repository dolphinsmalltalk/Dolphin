"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ShlwapiLibraryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ShlwapiLibraryTest guid: (GUID fromString: '{daf20828-d81b-4fb2-ada8-0607b224c723}')!
ShlwapiLibraryTest comment: ''!
!ShlwapiLibraryTest categoriesForClass!Unclassified! !
!ShlwapiLibraryTest methodsFor!

testPathCompactPathEx
	| buf |
	buf := Utf16String newFixed: 20.
	self assert: (ShlwapiLibrary default
				pathCompactPathEx: buf
				pszSrc: 'c:\dolphin\'
				cchMax: buf size - 1
				dwFlags: 0).
	self assert: buf trimNulls equals: 'c:\dolphin\'! !
!ShlwapiLibraryTest categoriesForMethods!
testPathCompactPathEx!public!unit tests! !
!

