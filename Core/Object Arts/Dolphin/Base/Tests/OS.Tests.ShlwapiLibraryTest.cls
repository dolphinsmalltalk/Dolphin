"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.Tests.ShlwapiLibraryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.ShlwapiLibraryTest guid: (Core.GUID fromString: '{daf20828-d81b-4fb2-ada8-0607b224c723}')!
OS.Tests.ShlwapiLibraryTest comment: ''!
!OS.Tests.ShlwapiLibraryTest categoriesForClass!Unclassified! !
!OS.Tests.ShlwapiLibraryTest methodsFor!

testPathCompactPathEx
	| buf |
	buf := Utf16String newFixed: 20.
	self assert: (ShlwapiLibrary default
				pathCompactPathEx: buf
				pszSrc: 'c:\dolphin\'
				cchMax: buf size - 1
				dwFlags: 0).
	self assert: buf trimNulls equals: 'c:\dolphin\'! !
!OS.Tests.ShlwapiLibraryTest categoriesFor: #testPathCompactPathEx!public!unit tests! !

