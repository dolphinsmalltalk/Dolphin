"Filed out from Dolphin Smalltalk 7"!

UserLibrary subclass: #FakeUserLibrary
	instanceVariableNames: 'user32 getForegroundWindowBlock getActiveWindowBlock getCursorPosBlock'
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
	^getActiveWindowBlock ifNotNil: [getActiveWindowBlock value] ifNil: [super getActiveWindow]!

getActiveWindowBlock: aNiladicValuable
	getActiveWindowBlock := aNiladicValuable!

getCursorPos: aPOINT
	^getCursorPosBlock ifNotNil: [getCursorPosBlock value: aPOINT] ifNil: [super getCursorPos: aPOINT]!

getCursorPosBlock: aMonadicValuable
	getCursorPosBlock := aMonadicValuable!

getForegroundWindow
	"Answer the handle of the window with which the user is currently working.
		HWND GetForegroundWindow(VOID)"

	^getForegroundWindowBlock
		ifNotNil: [getForegroundWindowBlock value]
		ifNil: [super getForegroundWindow]!

getForegroundWindowBlock: aNiladicValuable
	getForegroundWindowBlock := aNiladicValuable!

initializeForDesktopActive
	getForegroundWindowBlock := [self findWindow: 'Progman' lpWindowName: nil].
	getActiveWindowBlock := []!

open
	user32 := UserLibrary default.
	handle := user32 handle.
	self beFinalizable.
	UserLibrary setDefault: self! !
!FakeUserLibrary categoriesFor: #close!public!realizing/unrealizing! !
!FakeUserLibrary categoriesFor: #free!finalizing!public!realizing/unrealizing! !
!FakeUserLibrary categoriesFor: #getActiveWindow!public!win32 functions-keyboard input! !
!FakeUserLibrary categoriesFor: #getActiveWindowBlock:!initializing!private! !
!FakeUserLibrary categoriesFor: #getCursorPos:!public!win32 functions-cursor! !
!FakeUserLibrary categoriesFor: #getCursorPosBlock:!initializing!private! !
!FakeUserLibrary categoriesFor: #getForegroundWindow!public!win32 functions-keyboard input! !
!FakeUserLibrary categoriesFor: #getForegroundWindowBlock:!initializing!private! !
!FakeUserLibrary categoriesFor: #initializeForDesktopActive!initializing!public! !
!FakeUserLibrary categoriesFor: #open!private!realizing/unrealizing! !

