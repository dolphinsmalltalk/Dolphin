"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ShlwapiLibraryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ShlwapiLibraryTest guid: (GUID fromString: '{DAF20828-D81B-4FB2-ADA8-0607B224C723}')!
ShlwapiLibraryTest comment: ''!
!ShlwapiLibraryTest categoriesForClass!Unclassified! !
!ShlwapiLibraryTest methodsFor!

testPathCompactPathEx
	| buf |
	buf := String newFixed: 20.
	self assert: (ShlwapiLibrary default 
				pathCompactPathEx: buf
				pszSrc: 'c:\dolphin\'
				cchMax: buf size - 1
				dwFlags: 0).
	self assert: buf trimNulls = 'c:\dolphin\'! !
!ShlwapiLibraryTest categoriesFor: #testPathCompactPathEx!public!unit tests! !

