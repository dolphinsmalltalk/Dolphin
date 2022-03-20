"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.ClassCommentChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ClassCommentChangeTest guid: (Core.GUID fromString: '{73f174df-5724-421f-b73a-01a9a39917a5}')!
Refactory.Browser.Tests.ClassCommentChangeTest comment: ''!
!Refactory.Browser.Tests.ClassCommentChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ClassCommentChangeTest methodsFor!

testAsUndo
	| subject undo |
	subject := ClassCommentChange comment: 'Blah blah blah' in: Object.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: ClassCommentChange.
	self assert: undo comment equals: Object comment.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject comment printString format |
	comment := 'Blah blah blah'.
	subject := ClassCommentChange comment: comment in: Object.
	format := 'Core.Object comment: <1p>!!'.
	self assert: subject beforeText equals: format << Object comment.
	printString := format << comment.
	self assert: subject afterText equals: printString.
	self assert: subject changeString equals: 'Comment Core.Object'.
	self assert: subject printString equals: printString! !
!Refactory.Browser.Tests.ClassCommentChangeTest categoriesForMethods!
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
!

