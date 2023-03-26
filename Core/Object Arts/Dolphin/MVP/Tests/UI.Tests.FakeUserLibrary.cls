"Filed out from Dolphin Smalltalk"!

OS.UserLibrary
	subclass: #'UI.Tests.FakeUserLibrary'
	instanceVariableNames: 'user32 process getForegroundWindowBlock getActiveWindowBlock getCursorPosBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.FakeUserLibrary guid: (Core.GUID fromString: '{bbf4bdc3-fddb-4f49-8884-67abd17b5abf}')!
UI.Tests.FakeUserLibrary comment: ''!
!UI.Tests.FakeUserLibrary categoriesForClass!External-Libraries-Win32! !
!UI.Tests.FakeUserLibrary methodsFor!

close
	user32
		ifNotNil: 
			[:original |
			handle := user32 := nil.
			UserLibrary setDefault: original]!

getActiveWindow
	^(getActiveWindowBlock notNil and: [Processor activeProcess == process])
		ifTrue: [getActiveWindowBlock value]
		ifFalse: [super getActiveWindow]!

getActiveWindowBlock: aNiladicValuable
	getActiveWindowBlock := aNiladicValuable!

getCursorPos: aPOINT
	^(getCursorPosBlock notNil and: [Processor activeProcess == process])
		ifTrue: [getCursorPosBlock value: aPOINT]
		ifFalse: [super getCursorPos: aPOINT]!

getCursorPosBlock: aMonadicValuable
	getCursorPosBlock := aMonadicValuable!

getForegroundWindow
	"Answer the handle of the window with which the user is currently working.
		HWND GetForegroundWindow(VOID)"

	^(getForegroundWindowBlock notNil and: [Processor activeProcess == process])
		ifTrue: [getForegroundWindowBlock value]
		ifFalse: [super getForegroundWindow]!

getForegroundWindowBlock: aNiladicValuable
	getForegroundWindowBlock := aNiladicValuable!

initializeForDesktopActive
	getForegroundWindowBlock := [self findWindow: 'Progman' lpWindowName: nil].
	getActiveWindowBlock := []!

open
	process := Processor activeProcess.
	user32 := User32.
	handle := user32 handle.
	self beFinalizable.
	UserLibrary setDefault: self! !
!UI.Tests.FakeUserLibrary categoriesForMethods!
close!public!realizing/unrealizing! !
getActiveWindow!public!win32 functions-keyboard input! !
getActiveWindowBlock:!initializing!private! !
getCursorPos:!public!win32 functions-cursor! !
getCursorPosBlock:!initializing!private! !
getForegroundWindow!public!win32 functions-keyboard input! !
getForegroundWindowBlock:!initializing!private! !
initializeForDesktopActive!initializing!public! !
open!private!realizing/unrealizing! !
!

!UI.Tests.FakeUserLibrary class methodsFor!

openDefault
	"Do nothing - we don't want to overwrite the real UserLibrary on startup"!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	"Override so that we don't close the default user library and undeclare User32"
! !
!UI.Tests.FakeUserLibrary class categoriesForMethods!
openDefault!instance creation!private!realizing/unrealizing! !
uninitialize!class hierarchy-removing!private! !
!

