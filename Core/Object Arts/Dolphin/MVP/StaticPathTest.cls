"Filed out from Dolphin Smalltalk"!

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

testCalculateExtent
	| actualText canvas shell expected actual |
	shell := presenter parentView.
	shell extent: 300 @ 100.
	shell layoutManager: FlowLayout new.
	presenter alignment: #simple.
	"In path's the & should be displayed as part of the path and not interpreted in any way"
	actualText := 'c:\windows\system32\kernel32.dll&'.
	presenter text: actualText.
	"If debugging through it can be useful to see the size the control actually wants to be"
	presenter usePreferredExtent: true.
	presenter extent: 20 @ 10.
	canvas := presenter canvas.
	canvas font: presenter actualFont.
	expected := presenter calcExtentFromClientExtent: (canvas textExtent: actualText).
	canvas free.
	actual := presenter calculateExtent: (LayoutContext forContainer: shell).
	self assert: actual equals: expected!

testLayout
	| preferredExtent actualExtent displayedText |
	presenter model value: 'c:\program files\dir1\dir2\dir3\dir4\file.txt'.
	preferredExtent := presenter calculateExtent.
	actualExtent := presenter extent.
	"If this fires test won't work because there isn't enough text to require ellipses"
	self assert: actualExtent x < preferredExtent x.
	displayedText := presenter getWindowText.
	self deny: (displayedText indexOfSubCollection: '...') identicalTo: 0.
	presenter topShell extent: (presenter topShell calcExtentFromClientExtent: preferredExtent).
	presenter ensureLayoutValid.
	displayedText := presenter getWindowText.
	self assert: (displayedText indexOfSubCollection: '...') identicalTo: 0! !
!StaticPathTest categoriesForMethods!
classToTest!helpers!private! !
testCalculateExtent!public! !
testLayout!public!unit tests! !
!

