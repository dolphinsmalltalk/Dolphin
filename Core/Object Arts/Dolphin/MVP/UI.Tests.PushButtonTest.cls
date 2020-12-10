"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #PushButtonTest
	instanceVariableNames: 'shell shellButtonA shellButtonB dialog dialogButtonA dialogButtonB'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PushButtonTest guid: (GUID fromString: '{e927fec8-865b-4be1-928d-fd9eb29c16c4}')!
PushButtonTest comment: ''!
!PushButtonTest categoriesForClass!Unclassified! !
!PushButtonTest methodsFor!

assertButton: aPushButton isDefault: aBoolean
	self assert: aPushButton isDefault equals: aBoolean.
	aBoolean ifTrue: [self assert: aPushButton topShell defaultButtonId equals: aPushButton id]!

setUp
	super setUp.
	shell := ShellView show.
	shellButtonA := shell addSubView: PushButton new.
	shellButtonB := shell addSubView: PushButton new.

	dialog := DialogView show.
	dialogButtonA := dialog addSubView: PushButton new.
	dialogButtonB := dialog addSubView: PushButton new.

	
!

tearDown
	shell destroy.
	shell := shellButtonA := shellButtonB := nil.
	dialog destroy.
	dialog := dialogButtonA := dialogButtonB := nil.
	super tearDown
!

testDialogDefaultButtons
	self tryDefaultButtonsA: dialogButtonA B: dialogButtonB!

testShellDefaultButtons
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
!PushButtonTest categoriesFor: #assertButton:isDefault:!helpers!private! !
!PushButtonTest categoriesFor: #setUp!public!running! !
!PushButtonTest categoriesFor: #tearDown!public!running! !
!PushButtonTest categoriesFor: #testDialogDefaultButtons!public!unit tests! !
!PushButtonTest categoriesFor: #testShellDefaultButtons!public!unit tests! !
!PushButtonTest categoriesFor: #tryDefaultButtonsA:B:!private!unit tests! !

