"Filed out from Dolphin Smalltalk"!

UI.Tests.StaticViewTest subclass: #'UI.Tests.StaticPathTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.StaticPathTest guid: (Core.GUID fromString: '{50b65118-29ff-4b14-b17a-56e21a6fefca}')!
UI.Tests.StaticPathTest comment: ''!
!UI.Tests.StaticPathTest methodsFor!

classToTest
	^StaticPath!

oldDolphinVersionsForStbUpgrade
	^#(5)!

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
	self assert: (displayedText indexOfSubCollection: '...') identicalTo: 0!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assertIsNil: view backcolor.
	self assert: view interactor identicalTo: view.
	self assert: view plainText equals: 'c:\Program Files\Dolphin Smalltalk'!

vuFile
	^'TextPresenter.Path text.vu'! !
!UI.Tests.StaticPathTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
testCalculateExtent!public!unit tests! !
testLayout!public!unit tests! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.StaticPathTest class methodsFor!

resource_Path_text_D6
	"Answer the literal data from which the 'Path text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Path_text)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.StaticPath)  98 17 0 0 98 2 8 1140850944 1 416 0 0 0 7 0 0 0 416 0 8 4294904617 852486 ##(Smalltalk.NullConverter)  0 0 0 8 'c:\Program Files\Dolphin Smalltalk' 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 690 241 39 416 626 8 #text: 98 1 544 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 239 5 0 0 29 0 0 0] 98 0 690 193 193 0 27 )!

resource_Path_text_D7
	"Answer the literal data from which the 'Path text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Path_text)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticPath) 34 17 nil nil 34 2 8 1140850944 1 416 nil nil nil 7 nil nil nil 416 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 8 'c:\Program Files\Dolphin Smalltalk' 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 2799 21 658 241 39 416 610 #text: 34 1 528 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 239 5 0 0 29 0 0 0] 8 #() 658 193 193 nil 27 )! !
!UI.Tests.StaticPathTest class categoriesForMethods!
resource_Path_text_D6!public!resources-views! !
resource_Path_text_D7!public!resources-views! !
!

