"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Tools.Tests.MethodSearchTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.MethodSearchTest guid: (Core.GUID fromString: '{36cbd988-e85b-4005-8a80-f05c62b5b953}')!
Tools.Tests.MethodSearchTest comment: ''!
!Tools.Tests.MethodSearchTest methodsFor!

testNewSelector
	| subject filter |
	subject := MethodSearch newSelector: 'testNewSelector'.
	self assert: subject pattern identicalTo: #testNewSelector.
	self assert: subject literal identicalTo: #testNewSelector.
	self assert: subject searchMode identicalTo: #text.
	filter := subject methodDefinitionFilter.
	self assert: (filter value: self class >> self selector).
	self deny: (filter value: Object >> #size)! !
!Tools.Tests.MethodSearchTest categoriesForMethods!
testNewSelector!public! !
!

