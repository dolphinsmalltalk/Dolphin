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
	self assert: shell3 displayMonitor equals: primary! !

!ShellViewTest categoriesForMethods!
createShell:centered:!private! !
testOpensOnForegroundMonitor!public!unit tests! !
!

