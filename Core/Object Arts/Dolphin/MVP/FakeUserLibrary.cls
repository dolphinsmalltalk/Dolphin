"Filed out from Dolphin Smalltalk"!

UserLibrary subclass: #FakeUserLibrary
	instanceVariableNames: 'user32 process getForegroundWindowBlock getActiveWindowBlock getCursorPosBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FakeUserLibrary guid: (GUID fromString: '{bbf4bdc3-fddb-4f49-8884-67abd17b5abf}')!

FakeUserLibrary comment: ''!

!FakeUserLibrary categoriesForClass!External-Libraries-Win32! !

!FakeUserLibrary methodsFor!

close
	user32
		ifNotNil: 
			[:original |
			handle := user32 := nil.
			UserLibrary setDefault: original]!

free
	self close!

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
	user32 := UserLibrary default.
	handle := user32 handle.
	self beFinalizable.
	UserLibrary setDefault: self! !

!FakeUserLibrary categoriesForMethods!
close!public!realizing/unrealizing! !
free!finalizing!public!realizing/unrealizing! !
getActiveWindow!public!win32 functions-keyboard input! !
getActiveWindowBlock:!initializing!private! !
getCursorPos:!public!win32 functions-cursor! !
getCursorPosBlock:!initializing!private! !
getForegroundWindow!public!win32 functions-keyboard input! !
getForegroundWindowBlock:!initializing!private! !
initializeForDesktopActive!initializing!public! !
open!private!realizing/unrealizing! !
!

!FakeUserLibrary class methodsFor!

clear
	"Private - Clear down cached external function addresses and any default 
	instances of the receiver from previous runs. etc."

	"Nothing to do"! !
!FakeUserLibrary class categoriesForMethods!
clear!initializing!private! !
!

