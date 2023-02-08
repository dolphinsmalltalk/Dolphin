"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #PushButtonTest
	instanceVariableNames: 'shell shellButtonA shellButtonB dialog dialogButtonA dialogButtonB'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushButtonTest guid: (GUID fromString: '{e927fec8-865b-4be1-928d-fd9eb29c16c4}')!
PushButtonTest comment: ''!
!PushButtonTest categoriesForClass!Unclassified! !
!PushButtonTest methodsFor!

assertButton: aPushButton isDefault: aBoolean
	self assert: aPushButton isDefault equals: aBoolean.
	aBoolean ifTrue: [self assert: aPushButton topShell defaultButtonId equals: aPushButton id]!

getButton: aPushButton textExtent: actualText
	| textExtent canvas |
	canvas := aPushButton canvas.
	canvas font: aPushButton actualFont.
	textExtent := canvas textExtent: actualText.
	canvas free.
	^textExtent!

showDialogWithButtons
	dialog := DialogView show.
	dialogButtonA := dialog addSubView: PushButton new.
	dialogButtonB := dialog addSubView: PushButton new!

showShellWithButtons
	shell := ShellView show.
	shellButtonA := shell addSubView: PushButton new.
	shellButtonB := shell addSubView: PushButton new!

tearDown
	shell
		ifNotNil: 
			[shell destroy.
			shell := shellButtonA := shellButtonB := nil].
	dialog
		ifNotNil: 
			[dialog destroy.
			dialog := dialogButtonA := dialogButtonB := nil].
	super tearDown!

testCalculateExtent
	"Test that checkboxes are able to resize to fit their text (and button). We really don't need to verify this precisely as we aren't testing the control's behaviour, rather that it does size to fit."

	| actualText textWidth |
	self showShellWithButtons.
	shellButtonA usePreferredExtent: true.
	"Use a non-proportional font to make calculating the expected result predictable"
	actualText := '	The quick brown 狐狸 jumped over the lazy Лиса'.
	shellButtonA text: actualText.
	shell
		extent: 500 @ 75;
		layoutManager: FlowLayout new.
	actualText := '	The quick brown 狐狸 jumped over the lazy Лиса'.
	shellButtonA text: actualText.
	textWidth := (self getButton: shellButtonA textExtent: actualText) x.
	self assert: (shellButtonA extent x between: textWidth and: textWidth + 25).
	"Button should shrink if given less text"
	shellButtonA text: 'abc'.
	textWidth := (self getButton: shellButtonA textExtent: 'abc') x.
	self assert: (shellButtonA extent x between: textWidth and: textWidth + 25)!

testDialogDefaultButtons
	self showDialogWithButtons.
	self tryDefaultButtonsA: dialogButtonA B: dialogButtonB!

testShellDefaultButtons
	self showShellWithButtons.
	self tryDefaultButtonsA: shellButtonA B: shellButtonB!

tryDefaultButtonsA: buttonA B: buttonB 
	"Private - No defaults yet"

	self assertButton: buttonA isDefault: false.
	self assertButton: buttonB isDefault: false.

	"Set A to default"
	buttonA isDefault: true.
	self assertButton: buttonA isDefault: true.
	self assertButton: buttonB isDefault: false.

	"Toggle to B"
	buttonB isDefault: true.
	self assertButton: buttonA isDefault: false.
	self assertButton: buttonB isDefault: true.

	"Toggle to A"
	buttonA isDefault: true.
	self assertButton: buttonA isDefault: true.
	self assertButton: buttonB isDefault: false.

	"Set default when already set"
	buttonA isDefault: false.
	buttonB isDefault: false.
	buttonA isDefault: true.
	buttonA isDefault: true.
	self assertButton: buttonA isDefault: true.
	self assertButton: buttonB isDefault: false.

	"Reset default when already reset"
	buttonB isDefault: false.
	buttonB isDefault: false.
	self assertButton: buttonA isDefault: true.
	self assertButton: buttonB isDefault: false! !
!PushButtonTest categoriesForMethods!
assertButton:isDefault:!helpers!private! !
getButton:textExtent:!helpers!private! !
showDialogWithButtons!helpers!private! !
showShellWithButtons!helpers!private! !
tearDown!public!running! !
testCalculateExtent!public!unit tests! !
testDialogDefaultButtons!public!unit tests! !
testShellDefaultButtons!public!unit tests! !
tryDefaultButtonsA:B:!private!unit tests! !
!

