"Filed out from Dolphin Smalltalk"!

AbstractShellViewTest subclass: #ShellViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ShellViewTest guid: (GUID fromString: '{7f45346b-99e0-4c3f-bcf8-19cde00771e0}')!

ShellViewTest comment: ''!

!ShellViewTest categoriesForClass!Unclassified! !

!ShellViewTest methodsFor!

classToTest
	^ShellView!

createShell: aString centered: aBoolean
	| shell |
	shell := ShellView new.
	shells addLast: shell.
	shell isInitiallyCentered: aBoolean.
	^shell
		create;
		text: aString;
		show;
		yourself!

testOpensOnForegroundMonitor
	"Test that shell opens on the monitor of the monitor with cursor, but preferring the monitor with the foreground window if the program manager has focus."

	| primary secondary shell1 shell2 shell3 |
	primary := DisplayMonitor primary.
	secondary := self getSecondaryMonitorIfAvailable.
	self setUpFakeUserLibrary.
	cursorPos := secondary workArea center.
	shell1 := self createShell: self printString , ': shell1' centered: true.
	self assert: shell1 displayMonitor equals: secondary.
	fakeUser32 getActiveWindowBlock: [shell1 handle].
	"Position cursor over the primary window - shell should still open on secondary because the foreground window is there."
	cursorPos := primary workArea center.
	shell2 := self createShell: self printString , ': shell2' centered: false.
	self assert: shell2 displayMonitor equals: secondary.
	"Move the foreground window to the primary monitor"
	shell1 positionNear: primary workArea center.
	"Now a new shell should open on the primary monitor"
	shell3 := self createShell: self printString , ': shell3' centered: false.
	self assert: shell3 displayMonitor equals: primary!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view interactor identicalTo: view.
	self assertIsNil: view largeIcon.
	self assertIsNil: view smallIcon.
	self assertIsNil: view maxExtent.
	self assertIsNil: view minExtent.
	self assert: view defaultButtonId equals: 0! !

!ShellViewTest categoriesForMethods!
classToTest!helpers!private! !
createShell:centered:!helpers!private! !
testOpensOnForegroundMonitor!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

!ShellViewTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(ColorRef) 8 4278190080 0 517 0 0 0 416 0 234 256 98 0 0 0 0 0 0 1 0 0 0 0 1 0 0 983302 ##(MessageSequence) 202 208 98 2 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 89 117 690 1201 801 416 626 8 #menuBar: 98 1 0 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 44 0 0 0 58 0 0 0 132 2 0 0 202 1 0 0] 98 0 690 193 193 0 27)!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 nil 170 192 8 #() nil nil nil nil nil 1 nil nil nil nil 1 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 642 1201 801 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 23 16 0 0 154 1 0 0] 8 #() 642 193 193 nil 27 )! !

!ShellViewTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

