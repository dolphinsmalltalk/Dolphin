﻿"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.AbstractShellViewTest'
	instanceVariableNames: 'fakeUser32 cursorPos shells'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.AbstractShellViewTest guid: (Core.GUID fromString: '{be6c197d-5333-4ba6-aef4-6b93d2970718}')!

UI.Tests.AbstractShellViewTest isNonInstantiable: true!

UI.Tests.AbstractShellViewTest comment: ''!

!UI.Tests.AbstractShellViewTest methodsFor!

createShell: aRectangle text: aString
	| shell |
	shell := ShellView new.
	shells addLast: shell.
	^shell
		create;
		rectangle: aRectangle;
		text: aString;
		show;
		yourself!

getSecondaryMonitorIfAvailable
	"Private - Attempt to find a non-primary monitor, which will only be possible if more than one display monitor is attached."

	| monitors |
	monitors := DisplayMonitor desktopMonitors.
	^monitors size > 1 ifTrue: [monitors detect: [:each | each isPrimary not]] ifFalse: [monitors first]!

setUp
	super setUp.
	shells := OrderedCollection new.
	cursorPos := 0@0!

setUpFakeUserLibrary
	fakeUser32 := FakeUserLibrary new.
	fakeUser32
		initializeForDesktopActive;
		getCursorPosBlock: 
				[:pointl |
				pointl value: cursorPos.
				1];
		open.
	"In this configuration the active window is nil (i.e. simulating foreground window not a Dolphin window), and the foreground window will be external."
	self assertIsNil: View active!

shouldSetupPresenter
	^false!

tearDown
	fakeUser32 ifNotNil: [fakeUser32 close].
	shells do: [:each | each destroy].
	super tearDown!

workAreaNearest: aPoint
	^(DisplayMonitor nearestPoint: aPoint) workArea! !

!UI.Tests.AbstractShellViewTest categoriesForMethods!
createShell:text:!helpers!private! !
getSecondaryMonitorIfAvailable!helpers!private! !
setUp!public!running! !
setUpFakeUserLibrary!helpers!private! !
shouldSetupPresenter!helpers!private! !
tearDown!public!running! !
workAreaNearest:!helpers!private! !
!

