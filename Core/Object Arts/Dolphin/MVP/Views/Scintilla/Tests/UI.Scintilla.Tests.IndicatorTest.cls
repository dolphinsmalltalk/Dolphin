"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'UI.Scintilla.Tests.IndicatorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Tests.IndicatorTest guid: (Core.GUID fromString: '{f9336218-5504-41d4-bf04-d9bbe66ecfbe}')!
UI.Scintilla.Tests.IndicatorTest comment: ''!
!UI.Scintilla.Tests.IndicatorTest methodsFor!

testStyleNameRangeTag
	| indicator1 indicator2 tag originalMethod testMethod |
	tag := Object new.
	indicator1 := Indicator
				styleName: #normal
				range: (1 to: 10)
				tag: tag.
	self assert: indicator1 styleName identicalTo: #normal.
	self assert: indicator1 range equals: (1 to: 10).
	self assert: indicator1 tag identicalTo: tag.
	originalMethod := Indicator class lookupMethod: #styleName:range:tag:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	indicator2 := testMethod value: Indicator withArguments: {#normal. 1 to: 10. tag}.
	self assert: indicator2 styleName identicalTo: #normal.
	self assert: indicator2 range equals: (1 to: 10).
	self assert: indicator2 tag identicalTo: tag! !
!UI.Scintilla.Tests.IndicatorTest categoriesForMethods!
testStyleNameRangeTag!public!unit tests! !
!

