"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractKeyboardTest
	subclass: #'UI.Tests.KeyboardTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.KeyboardTest guid: (Core.GUID fromString: '{9cecaad7-bd3c-4b84-aff3-bbf32cb900fc}')!
UI.Tests.KeyboardTest comment: ''!
!UI.Tests.KeyboardTest methodsFor!

testInvariantMap
	| invariant delete |
	self skipUnless: [self setCurrentKeyboardLayout: '00000809'].
	invariant := Keyboard invariant.
	delete := ##(VK_DELETE | KF_EXTENDED).
	(invariant virtualKeys associations reject: [:each | each value = delete]) do: 
			[:each |
			| keyName |
			keyName := invariant keyNameFromVKey: each value ifNone: [].
			self assert: keyName equals: each key].
	self assert: ((invariant keyNameFromVKey: delete ifNone: []) beginsWith: 'DEL')! !
!UI.Tests.KeyboardTest categoriesForMethods!
testInvariantMap!public!unit tests! !
!

