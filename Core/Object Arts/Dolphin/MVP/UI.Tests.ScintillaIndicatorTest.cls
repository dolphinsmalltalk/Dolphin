"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'UI.Tests.ScintillaIndicatorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ScintillaIndicatorTest guid: (Core.GUID fromString: '{f9336218-5504-41d4-bf04-d9bbe66ecfbe}')!
UI.Tests.ScintillaIndicatorTest comment: ''!
!UI.Tests.ScintillaIndicatorTest categoriesForClass!Unclassified! !
!UI.Tests.ScintillaIndicatorTest methodsFor!

testStyleNameRangeTag
	| indicator1 indicator2 tag originalMethod testMethod |
	tag := Object new.
	indicator1 := Smalltalk.ScintillaIndicator
				styleName: #normal
				range: (1 to: 10)
				tag: tag.
	self assert: indicator1 styleName identicalTo: #normal.
	self assert: indicator1 range equals: (1 to: 10).
	self assert: indicator1 tag identicalTo: tag.
	originalMethod := Smalltalk.ScintillaIndicator class lookupMethod: #styleName:range:tag:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	indicator2 := testMethod value: Smalltalk.ScintillaIndicator withArguments: {#normal. 1 to: 10. tag}.
	self assert: indicator1 styleName identicalTo: #normal.
	self assert: indicator1 range equals: (1 to: 10).
	self assert: indicator1 tag identicalTo: tag! !
!UI.Tests.ScintillaIndicatorTest categoriesFor: #testStyleNameRangeTag!public!unit tests! !

