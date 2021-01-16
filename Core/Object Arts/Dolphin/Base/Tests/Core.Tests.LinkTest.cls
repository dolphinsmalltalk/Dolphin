"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.LinkTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.LinkTest guid: (Core.GUID fromString: '{761927ef-cc81-4a3e-b25a-0eef922c3370}')!
Core.Tests.LinkTest comment: ''!
!Core.Tests.LinkTest categoriesForClass!Unclassified! !
!Core.Tests.LinkTest methodsFor!

testClassNextLink
	| link1 link2 link3 originalMethod testMethod |
	link3 := Link new.
	link2 := Link nextLink: link3.
	self assert: link2 nextLink identicalTo: link3.
	originalMethod := Link class compiledMethodAt: #nextLink:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	link1 := testMethod value: Link withArguments: {link2}.
	self assert: link1 nextLink identicalTo: link2! !
!Core.Tests.LinkTest categoriesFor: #testClassNextLink!public!unit tests! !

