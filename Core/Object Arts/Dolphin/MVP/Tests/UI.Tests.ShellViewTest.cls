﻿"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractShellViewTest
	subclass: #'UI.Tests.ShellViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.ShellViewTest guid: (Core.GUID fromString: '{7f45346b-99e0-4c3f-bcf8-19cde00771e0}')!

UI.Tests.ShellViewTest comment: ''!

!UI.Tests.ShellViewTest methodsFor!

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

testDefaultPositioning
	"Test that newly opened shells open with a default extent based on the monitor and emulate the well-established windows cascading behaviour."

	| shell1 monitor i nextShell defaultExtent lastShell |
	shell1 := self createShell: 'Shell1' centered: false.
	monitor := shell1 monitor.
	self assert: monitor identicalTo: DisplayMonitor active.
	defaultExtent := monitor defaultWindowExtent.
	self assert: shell1 extent equals: defaultExtent.
	lastShell := shell1.
	i := 1.
	
	[(i := i + 1) < 20 and: 
			[nextShell := self createShell: 'Shell2' centered: false.
			nextShell position > shell1 position]]
			whileTrue: 
				[self assert: nextShell monitor identicalTo: monitor.
				self assert: nextShell extent equals: defaultExtent.
				self assert: nextShell position equals: lastShell position + monitor cascadeOffset.
				lastShell := nextShell].
	"Should have wrapped"
	self assert: nextShell position equals: monitor workArea origin + monitor cascadeOffset!

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

testPositionAtOriginOfLastMonitor
	| subject monitor designPosition designExtent |
	monitor := self desktopMonitors last.
	designPosition := (monitor infoWithDpiAwareness: DpiAwareness unaware) rcWork origin.
	designExtent := 200 @ 100.
	subject := shells add: ShellView new.
	subject
		createAt: designPosition extent: designExtent;
		show.
	self assert: subject position equals: monitor origin.
	self assert: subject extent equals: designExtent * monitor dpi // USER_DEFAULT_SCREEN_DPI!

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

!UI.Tests.ShellViewTest categoriesForMethods!
classToTest!helpers!private! !
createShell:centered:!helpers!private! !
testDefaultPositioning!public!unit tests! !
testOpensOnForegroundMonitor!public!unit tests! !
testPositionAtOriginOfLastMonitor!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.ShellViewTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view_D6)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(ColorRef) 8 4278190080 0 517 0 0 0 416 0 234 256 98 0 0 0 0 0 0 1 0 0 0 0 1 0 0 983302 ##(MessageSequence) 202 208 98 2 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 89 117 690 1201 801 416 626 8 #menuBar: 98 1 0 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 44 0 0 0 58 0 0 0 132 2 0 0 202 1 0 0] 98 0 690 193 193 0 27)!

resource_Default_view_D7
	"Answer the literal data for the Shell default view resource in D7.

	To view this resource evaluate, but be careful not to save as doing so will invalidate the associated test.
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view_D7)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 nil 170 192 8 #() nil nil nil nil nil 1 nil nil nil nil 1 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 642 1201 801 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 23 16 0 0 154 1 0 0] 8 #() 642 193 193 nil 27 )!

resource_Default_view_D8_STL5
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view_D8_STL5)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default nil 551 nil nil nil 416 nil 170 192 8 #() nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 626 1201 801 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 87 26 0 0 154 1 0 0] 8 #() 626 193 193 nil 27)! !

!UI.Tests.ShellViewTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
resource_Default_view_D8_STL5!public!resources-views! !
!

