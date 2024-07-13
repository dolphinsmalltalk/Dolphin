"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.LayoutPlacementTest'
	instanceVariableNames: 'view'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.LayoutPlacementTest guid: (Core.GUID fromString: '{85bd267a-71c7-4be1-9d4c-85608ec7af19}')!

UI.Tests.LayoutPlacementTest comment: ''!

!UI.Tests.LayoutPlacementTest methodsFor!

setUp
	view := ShellView show.!

tearDown
	view destroy.
	view := nil!

testHasDeferredChange
	| subject messages |
	view rectangle: (10 @ 20 extent: 200 @ 100).
	subject := LayoutPlacement view: view.
	self deny: subject hasDeferredChange.
	subject show: false.
	self assert: subject hasDeferredChange.
	messages := self withFakeUserLibraryDo: [subject deferWindowPos: self].
	self assert: messages single equals: (Message selector: #deferWindowPos:hwnd:hwndInsertAfter:x:y:cx:cy:uFlags: arguments: {self. view handle. 0. 0. 0. 0. 0. SWP_HIDEWINDOW | SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOSIZE | SWP_NOMOVE}).
	view hide.
	self deny: subject hasDeferredChange.
	subject rectangle: (100 @ 200 extent: 300 @ 200).
	self assert: subject hasDeferredChange.
	subject show: nil.
	self assert: subject hasDeferredChange.
	messages := self withFakeUserLibraryDo: [subject deferWindowPos: self].
	self assert: messages single equals: (Message selector: #deferWindowPos:hwnd:hwndInsertAfter:x:y:cx:cy:uFlags: arguments: {self. view handle. 0. 100. 200. 300. 200. SWP_NOZORDER | SWP_NOACTIVATE}).
	view rectangle: subject rectangle.
	self deny: subject hasDeferredChange.
	subject show: false.
	self deny: subject hasDeferredChange.
	subject show: true.
	self assert: subject hasDeferredChange.
	messages := self withFakeUserLibraryDo: [subject deferWindowPos: self].
	self assert: messages single equals: (Message selector: #deferWindowPos:hwnd:hwndInsertAfter:x:y:cx:cy:uFlags: arguments: {self. view handle. 0. 100. 200. 300. 200.  SWP_SHOWWINDOW | SWP_NOZORDER | SWP_NOACTIVATE}).
	subject rectangle: nil.
	self assert: subject hasDeferredChange.
	messages := self withFakeUserLibraryDo: [subject deferWindowPos: self].
	self assert: messages single equals: (Message selector: #deferWindowPos:hwnd:hwndInsertAfter:x:y:cx:cy:uFlags: arguments: {self. view handle. 0. 0. 0. 0. 0.  SWP_SHOWWINDOW | SWP_NOSIZE | SWP_NOMOVE | SWP_NOZORDER | SWP_NOACTIVATE}).
	view show.
	self deny: subject hasDeferredChange!

withFakeUserLibraryDo: aNiladicValueable
	| fakeUser32 |
	fakeUser32 := FakeUserLibrary new.
	fakeUser32 open.
	aNiladicValueable ensure: [fakeUser32 close].
	^fakeUser32 messages! !

!UI.Tests.LayoutPlacementTest categoriesForMethods!
setUp!public!running! !
tearDown!public!running! !
testHasDeferredChange!public!unit tests! !
withFakeUserLibraryDo:!helpers!private! !
!

