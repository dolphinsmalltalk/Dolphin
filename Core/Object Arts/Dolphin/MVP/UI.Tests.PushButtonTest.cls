"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest subclass: #'UI.Tests.PushButtonTest'
	instanceVariableNames: 'shell shellButtonA shellButtonB dialog dialogButtonA dialogButtonB'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.PushButtonTest guid: (Core.GUID fromString: '{e927fec8-865b-4be1-928d-fd9eb29c16c4}')!
UI.Tests.PushButtonTest comment: ''!
!UI.Tests.PushButtonTest methodsFor!

assertButton: aPushButton isDefault: aBoolean
	self assert: aPushButton isDefault equals: aBoolean.
	aBoolean ifTrue: [self assert: aPushButton topShell defaultButtonId equals: aPushButton id]!

classToTest
	^PushButton!

initializePresenter
	shell := ShellView show.
	shellButtonA := shell addSubView: PushButton new.
	shellButtonB := shell addSubView: PushButton new.
	dialog := DialogView show.
	dialogButtonA := dialog addSubView: PushButton new.
	dialogButtonB := dialog addSubView: PushButton new!

oldDolphinVersionsForStbUpgrade
	^1 to: 5!

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
	self assertButton: buttonB isDefault: false!

verifyStbUpgrade: anInteger
	super verifyStbUpgrade: anInteger.
	self assert: self view backcolor identicalTo: Color default!

verifyUpgradedView: anInteger
	| view command |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assertIsNil: view image.
	self assert: view text equals: ''.
	self deny: view isDefault.
	self assert: view note equals: ''.
	command := view commandDescription.
	self assertIsNil: command command.
	self assertIsNil: command description.
	self deny: command hasAcceleratorKey.
	self assert: command isAbortable.
	self deny: command isModalCommand.
	self assertIsNil: command image!

vuFile
	^'PushButton.Push button.vu'! !
!UI.Tests.PushButtonTest categoriesForMethods!
assertButton:isDefault:!helpers!private! !
classToTest!helpers!private! !
initializePresenter!public!Running! !
oldDolphinVersionsForStbUpgrade!constants!private! !
tearDown!public!running! !
testDialogDefaultButtons!public!unit tests! !
testShellDefaultButtons!public!unit tests! !
tryDefaultButtonsA:B:!private!unit tests! !
verifyStbUpgrade:!helpers!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.PushButtonTest class methodsFor!

resource_Push_button_D6
	"Answer the literal data from which the 'Push button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Push_button)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(PushButton) 98 17 0 0 98 2 8 1140924416 1 416 0 0 0 5 0 0 0 416 0 8 4294906781 1180998 4 ##(CommandDescription) 0 0 1 1 0 0 32 983302 ##(MessageSequence) 202 208 98 2 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 11 11 674 141 51 416 610 8 #isEnabled: 98 1 32 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 75 0 0 0 30 0 0 0] 98 0 674 193 193 0 27)!

resource_Push_button_D7
	"Answer the literal data from which the 'Push button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Push_button)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.PushButton) 34 20 nil nil 34 2 8 1140924416 1 416 nil nil nil 5 nil nil nil 416 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) nil nil 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 11 11 642 141 51 416 594 #isEnabled: 8 #(false) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 75 0 0 0 30 0 0 0] 8 #() 642 193 193 nil 29)! !
!UI.Tests.PushButtonTest class categoriesForMethods!
resource_Push_button_D6!public!resources-views! !
resource_Push_button_D7!public!resources-views! !
!

