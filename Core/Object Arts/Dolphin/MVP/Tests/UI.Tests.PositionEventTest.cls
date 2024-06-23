"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.PositionEventTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.PositionEventTest guid: (Core.GUID fromString: '{dfddf958-2f9b-4f9e-b2ba-59c2fa09ebf8}')!

UI.Tests.PositionEventTest comment: ''!

!UI.Tests.PositionEventTest methodsFor!

testIsRectangleChanged
	| subject windowPos |
	windowPos := WINDOWPOS newBuffer.
	"Both SWP_NOMOVE and SWP_NOSIZE must be set to indicate that there is no layout change"
	windowPos bytes uint32AtOffset: WINDOWPOS._OffsetOf_flags put: SWP_NOSIZE | SWP_NOMOVE.
	subject := PositionEvent
				window: Transcript
				message: WM_WINDOWPOSCHANGED
				wParam: 0
				lParam: windowPos yourAddress.
	self deny: subject isRectangleChanged.
	subject flags: SWP_NOMOVE.
	self assert: subject isRectangleChanged.
	subject flags: SWP_NOSIZE.
	self assert: subject isRectangleChanged! !

!UI.Tests.PositionEventTest categoriesForMethods!
testIsRectangleChanged!public!unit tests! !
!

