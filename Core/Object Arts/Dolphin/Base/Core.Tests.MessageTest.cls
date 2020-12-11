"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.MessageTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.MessageTest guid: (Core.GUID fromString: '{aaa1f3a5-03cb-48f2-b067-a1ec0392ad2b}')!
Core.Tests.MessageTest comment: ''!
!Core.Tests.MessageTest categoriesForClass!Unclassified! !
!Core.Tests.MessageTest methodsFor!

testSelectorArguments
	| msg1 msg2 originalMethod testMethod |
	msg1 := Message selector: #x:y: arguments: #(123 456).
	self assert: msg1 selector identicalTo: #x:y:.
	self assert: msg1 arguments equals: #(123 456).
	originalMethod := Message class compiledMethodAt: #selector:arguments:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	msg2 := testMethod value: Message withArguments: #(#x:y: #(123 456)).
	self assert: msg2 equals: msg1! !
!Core.Tests.MessageTest categoriesFor: #testSelectorArguments!public!unit tests! !

