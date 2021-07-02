"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractShellViewTest subclass: #'UI.Tests.ShellViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ShellViewTest guid: (Core.GUID fromString: '{7f45346b-99e0-4c3f-bcf8-19cde00771e0}')!
UI.Tests.ShellViewTest comment: ''!
!UI.Tests.ShellViewTest categoriesForClass!Unclassified! !
!UI.Tests.ShellViewTest methodsFor!

createShell: aString
	| shell |
	shell := ShellView new.
	shells addLast: shell.
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
	shell1 := self createShell: self printString , ': shell1'.
	self assert: shell1 displayMonitor equals: secondary.
	fakeUser32 getForegroundWindowBlock: [shell1].
	"Position cursor over the primary window - shell should still open on secondary because the foreground window is there."
	cursorPos := primary workArea center.
	shell2 := self createShell: self printString , ': shell2'.
	self assert: shell2 displayMonitor equals: secondary.
	"Move the foreground window to the primary monitor"
	shell1 positionNear: primary workArea center.
	"Now a new shell should open on the primary monitor"
	shell3 := self createShell: self printString , ': shell3'.
	self assert: shell3 displayMonitor equals: primary! !
!UI.Tests.ShellViewTest categoriesFor: #createShell:!private! !
!UI.Tests.ShellViewTest categoriesFor: #testOpensOnForegroundMonitor!public!unit tests! !

