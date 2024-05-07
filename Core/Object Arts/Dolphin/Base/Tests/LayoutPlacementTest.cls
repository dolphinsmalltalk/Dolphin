"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #LayoutPlacementTest
	instanceVariableNames: 'view'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LayoutPlacementTest guid: (GUID fromString: '{85bd267a-71c7-4be1-9d4c-85608ec7af19}')!

LayoutPlacementTest comment: ''!

!LayoutPlacementTest categoriesForClass!Unclassified! !

!LayoutPlacementTest methodsFor!

setUp
	view := ShellView show!

tearDown
	view destroy.
	view := nil!

testHasDeferredChange
	| subject |
	subject := LayoutPlacement view: view.
	self assert: subject showFlag equals: 0.
	self deny: subject hasDeferredChange.
	view rectangle: (10 @ 20 extent: 200 @ 100).
	self deny: subject hasDeferredChange.
	subject show: false.
	self assert: subject showFlag equals: Win32Constants.SWP_HIDEWINDOW.
	self assert: subject hasDeferredChange.
	view hide.
	self deny: subject hasDeferredChange.
	subject rectangle: (100 @ 200 extent: 300 @ 200).
	self assert: subject hasDeferredChange.
	subject show: nil.
	self assert: subject showFlag equals: 0.
	self assert: subject hasDeferredChange.
	view rectangle: subject rectangle.
	self deny: subject hasDeferredChange.
	subject show: false.
	self deny: subject hasDeferredChange.
	subject show: true.
	self assert: subject showFlag equals: Win32Constants.SWP_SHOWWINDOW.
	self assert: subject hasDeferredChange.
	subject rectangle: nil.
	self assert: subject hasDeferredChange.
	view show.
	self deny: subject hasDeferredChange! !

!LayoutPlacementTest categoriesForMethods!
setUp!public!running! !
tearDown!public!running! !
testHasDeferredChange!public!unit tests! !
!

