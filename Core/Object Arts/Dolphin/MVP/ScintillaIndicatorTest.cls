"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ScintillaIndicatorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaIndicatorTest guid: (GUID fromString: '{f9336218-5504-41d4-bf04-d9bbe66ecfbe}')!
ScintillaIndicatorTest comment: ''!
!ScintillaIndicatorTest categoriesForClass!Unclassified! !
!ScintillaIndicatorTest methodsFor!

testStyleNameRangeTag
	| indicator1 indicator2 tag originalMethod testMethod |
	tag := Object new.
	indicator1 := ScintillaIndicator
				styleName: #normal
				range: (1 to: 10)
				tag: tag.
	self assert: indicator1 styleName identicalTo: #normal.
	self assert: indicator1 range equals: (1 to: 10).
	self assert: indicator1 tag identicalTo: tag.
	originalMethod := ScintillaIndicator class lookupMethod: #styleName:range:tag:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	indicator2 := testMethod value: ScintillaIndicator withArguments: {#normal. 1 to: 10. tag}.
	self assert: indicator1 styleName identicalTo: #normal.
	self assert: indicator1 range equals: (1 to: 10).
	self assert: indicator1 tag identicalTo: tag! !
!ScintillaIndicatorTest categoriesForMethods!
testStyleNameRangeTag!public!unit tests! !
!

