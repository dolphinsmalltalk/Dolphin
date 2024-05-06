"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #CommandDescriptionTest
	instanceVariableNames: 'savedKeyboardLayout'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CommandDescriptionTest guid: (GUID fromString: '{f36e555c-9741-49d2-89aa-fa4db14bc62f}')!

CommandDescriptionTest comment: ''!

!CommandDescriptionTest categoriesForClass!SUnit! !

!CommandDescriptionTest methodsFor!

setCurrentKeyboardLayout: aString
	| current |
	current := Keyboard layoutName.
	^current = aString or: 
			[(Keyboard layoutName: aString) and: 
					[savedKeyboardLayout ifNil: [savedKeyboardLayout := current].
					true]]!

tearDown
	savedKeyboardLayout ifNotNil: [Keyboard layoutName: savedKeyboardLayout].
	super tearDown!

testAcceleratorKeyString
	"Regression test for https://github.com/dolphinsmalltalk/Dolphin/issues/929"

	"Use the US keyboard layout so that this test at least will run on the CI build"
	| subject |
	self skipUnless: [self setCurrentKeyboardLayout: '00000409'].
	subject := CommandDescription command: #dummy.
	subject acceleratorKeyString: 'NUMMULT'.
	self assert: subject acceleratorKey equals: 618.
	self assert: subject acceleratorKeyString equals: 'NUMMULT'.
	self assert: subject acceleratorKeyDisplayString equals: 'Num *'.
	self should: [subject acceleratorKeyString: 'Num *'] raise: Error matching: [:ex | ex description equals: 'Unrecognised virtual key: ''Num *''']
!

testRegistry
	self assert: CommandDescription.CommandDescriptionRegistry hasWeakKeys.
	self deny: CommandDescription.CommandDescriptionRegistry hasWeakValues! !

!CommandDescriptionTest categoriesForMethods!
setCurrentKeyboardLayout:!helpers!private! !
tearDown!private!running! !
testAcceleratorKeyString!public!unit tests! !
testRegistry!public!unit tests! !
!

