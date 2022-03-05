"Filed out from Dolphin Smalltalk"!

VirtualColorTest subclass: #ThemeColorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ThemeColorTest guid: (GUID fromString: '{9ed13d02-48b3-41cc-a5be-b5b070af8b53}')!
ThemeColorTest comment: ''!
!ThemeColorTest categoriesForClass!Unclassified! !
!ThemeColorTest methodsFor!

testNameActualColor
	| tc tc2 originalMethod testMethod |
	tc := ThemeColor name: #dialog actualColor: Color face3d.
	self assert: tc equals: Color face3d.
	originalMethod := ThemeColor class compiledMethodAt: #name:actualColor:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	tc2 := testMethod value: ThemeColor withArguments: {#dialog. Color face3d}.
	self assert: tc2 equals: tc! !
!ThemeColorTest categoriesForMethods!
testNameActualColor!public!unit tests! !
!

