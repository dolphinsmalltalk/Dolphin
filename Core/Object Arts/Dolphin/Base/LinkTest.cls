"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #LinkTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LinkTest guid: (GUID fromString: '{761927ef-cc81-4a3e-b25a-0eef922c3370}')!
LinkTest comment: ''!
!LinkTest categoriesForClass!Unclassified! !
!LinkTest methodsFor!

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
!LinkTest categoriesForMethods!
testClassNextLink!public!unit tests! !
!

