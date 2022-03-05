"Filed out from Dolphin Smalltalk"!

VirtualColorTest subclass: #PluggableColorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluggableColorTest guid: (GUID fromString: '{45e67cc5-eb59-46fa-9c66-7bd0cd8335d8}')!
PluggableColorTest comment: ''!
!PluggableColorTest categoriesForClass!Unclassified! !
!PluggableColorTest methodsFor!

testWith
	| pc pc2 originalMethod testMethod |
	pc := PluggableColor with: [Color window].
	self assert: pc equals: Color window.
	originalMethod := PluggableColor class compiledMethodAt: #with:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	pc2 := testMethod value: PluggableColor withArguments: {[Color black]}.
	self assert: pc2 equals: Color black! !
!PluggableColorTest categoriesForMethods!
testWith!public!unit tests! !
!

