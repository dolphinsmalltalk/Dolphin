"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #StaticPathTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StaticPathTest guid: (GUID fromString: '{50b65118-29ff-4b14-b17a-56e21a6fefca}')!
StaticPathTest comment: ''!
!StaticPathTest categoriesForClass!Unclassified! !
!StaticPathTest methodsFor!

classToTest
	^StaticPath!

testLayout
	| preferredExtent actualExtent displayedText |
	presenter model value: 'c:\program files\dir1\dir2\dir3\dir4\file.txt'.
	preferredExtent := presenter calculateExtent.
	actualExtent := presenter extent.
	"If this fires test won't work because there isn't enough text to require ellipses"
	self assert: actualExtent x < preferredExtent x.
	displayedText := presenter getWindowText.
	self assert: (displayedText indexOfSubCollection: '...') ~~ 0.
	presenter topShell extent: (presenter topShell calcExtentFromClientExtent: preferredExtent).
	presenter ensureLayoutValid.
	displayedText := presenter getWindowText.
	self assert: (displayedText indexOfSubCollection: '...') == 0! !
!StaticPathTest categoriesFor: #classToTest!helpers!private! !
!StaticPathTest categoriesFor: #testLayout!public!unit tests! !

