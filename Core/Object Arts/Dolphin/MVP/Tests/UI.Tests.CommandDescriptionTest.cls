"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.CommandDescriptionTest'
	instanceVariableNames: 'savedKeyboardLayout'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.CommandDescriptionTest guid: (Core.GUID fromString: '{f36e555c-9741-49d2-89aa-fa4db14bc62f}')!

UI.Tests.CommandDescriptionTest comment: ''!

!UI.Tests.CommandDescriptionTest categoriesForClass!SUnit! !

!UI.Tests.CommandDescriptionTest methodsFor!

setCurrentKeyboardLayout: aString
	| current |
	current := Keyboard layoutName.
	^current = aString or: 
			[(Keyboard layoutName: aString) and: 
					[savedKeyboardLayout ifNil: [savedKeyboardLayout := current].
					true]]!

setUsKeyboard
	^self setCurrentKeyboardLayout: '00000409'!

tearDown
	savedKeyboardLayout ifNotNil: [Keyboard layoutName: savedKeyboardLayout].
	super tearDown!

testAcceleratorKeyString
	"Regression test for https://github.com/dolphinsmalltalk/Dolphin/issues/929"

	"Use the US keyboard layout so that this test at least will run on the CI build"
	<skipUnless: #setUsKeyboard>
	| subject |
	subject := CommandDescription command: #dummy.
	subject acceleratorKeyString: 'NUMMULT'.
	self assert: subject acceleratorKey equals: 618.
	self assert: subject acceleratorKeyString equals: 'NUMMULT'.
	self assert: subject acceleratorKeyDisplayString equals: 'Num *'.
	self
		should: [subject acceleratorKeyString: 'Num *']
		raise: Error
		matching: [:ex | ex description = 'Unrecognised virtual key: ''Num *''']!

testRegistry
	self assert: CommandDescription.CommandDescriptionRegistry hasWeakKeys.
	self deny: CommandDescription.CommandDescriptionRegistry hasWeakValues! !

!UI.Tests.CommandDescriptionTest categoriesForMethods!
setCurrentKeyboardLayout:!helpers!private! !
setUsKeyboard!initializing!private! !
tearDown!private!running! !
testAcceleratorKeyString!public!unit tests! !
testRegistry!public!unit tests! !
!

