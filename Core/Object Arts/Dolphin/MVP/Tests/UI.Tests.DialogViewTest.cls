﻿"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractShellViewTest
	subclass: #'UI.Tests.DialogViewTest'
	instanceVariableNames: 'owner'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.DialogViewTest guid: (Core.GUID fromString: '{a8b91e26-354f-4420-9358-156da6d19c83}')!

UI.Tests.DialogViewTest comment: ''!

!UI.Tests.DialogViewTest methodsFor!

classToTest
	^DialogView!

createSubjectDialog: aBoolean
	"We request default position, so the dialog should be created initially on the monitor of the owner."
	^self createSubjectDialog: aBoolean at: CreateWindow.UseDefaultGeometry!

createSubjectDialog: aBoolean at: aPosition
	| expectedOwner subject |
	subject := DialogView new
				isInitiallyCentered: aBoolean;
				owner: owner;
				createAt: aPosition extent: self dialogExtent;
				text: self printString;
				yourself.
	expectedOwner := owner ifNil: [View active ifNil: [View desktop]].
	self assert: subject owner identicalTo: expectedOwner.
	self assert: (subject getOwner ifNil: [View desktopHandle]) equals: expectedOwner handle.
	^subject!

createTestShells: aDisplayMonitor
	"If there is more than one monitor, put the dialog owner on a monitor other than the primary monitor (regression test for #1116)"

	owner := self
				createShell: (((100 @ 50 extent: 640 @ 480) scaledBy: aDisplayMonitor dpi / 96) truncated
						translatedBy: aDisplayMonitor workArea origin)
				text: self printString , ' owner'.
	"Create a 2nd shell to take activation from the owner. We do this because normally dialogs are opened modal to the active window."
	self createShell: (((50 @ 25 extent: 320 @ 240) scaledBy: DisplayMonitor primary dpi / 96) truncated
				translatedBy: DisplayMonitor primary workArea origin)
		text: self printString , ' shell2'!

dialogExtent
	"Answer the extent to use for the test dialogs. Note that this is fixed - we deliberately don't scale it to monitor dpi."

	^250 @ 350!

evaluateInModalDialog: aBlock centered: aBoolean
	| dialog |
	dialog := self createSubjectDialog: aBoolean.
	self assert: dialog owner equals: (owner ifNil: [View desktop]).
	
	[
	[[dialog isOpen not or: [dialog isModal]] whileFalse: [2 milliseconds wait].
	aBlock value: dialog]
			ensure: [dialog isModal: false]]
			fork.
	"Use an in-proc loop so the test doesn't cause a new main proc to be spawned. It also allows us to easily terminate the dialog just by setting the isModal flag"
	dialog isInProc: true.
	dialog showModal.
	self deny: dialog isOpen!

testCenteringInOwner
	"Test that a modal dialog is centered in its owner."

	| actualCenter secondary dialogMonitor expectedCenter |
	"Create a 2nd shell to take activation from the owner. We do this because normally dialogs are opened modal to the active window."
	secondary := self getSecondaryMonitorIfAvailable.
	self createTestShells: secondary.
	expectedCenter := owner mapPointToScreen: owner clientRectangle center.
	self evaluateInModalDialog: 
			[:dialog |
			actualCenter := dialog mapPointToScreen: dialog clientRectangle center.
			dialogMonitor := dialog displayMonitor]
		centered: true.
	self assert: dialogMonitor equals: secondary.
	"We expect the client area of the dialog to be centred over the client area of the owner. There might be some rounding error causing the centers to be offset by at most 1"
	self assert: (actualCenter - expectedCenter) abs <= 1.

	"Lose activation and reposition the cursor to the secondary monitor"
	cursorPos := secondary workArea center.
	self setUpFakeUserLibrary.
	self assertIsNil: View active.
	owner := nil.
	self evaluateInModalDialog: 
			[:dialog |
			actualCenter := dialog mapPointToScreen: dialog clientRectangle center.
			dialogMonitor := dialog displayMonitor]
		centered: true.
	self assert: dialogMonitor equals: secondary!

testCenteringInOwnerModeless
	"Test that a modeless dialog which is initially centred is displayed centred on the client area of its owner."

	| secondary dialog |
	secondary := self getSecondaryMonitorIfAvailable.
	self createTestShells: secondary.
	dialog := self createSubjectDialog: true.
	dialog showModeless.
	self assert: dialog displayMonitor equals: secondary.
	dialog
		text: 'Now you see me';
		hasSysMenu: false.
	dialog recreate.
	self deny: dialog hasSysMenu.
	self assert: dialog text equals: 'Now you see me'!

testCreatedNearOwnerModeless
	"Test that a modeless dialog which is not initially centred is at least displayed on the same monitor as its owner"

	| secondary subject rect |
	secondary := self getSecondaryMonitorIfAvailable.
	self createTestShells: secondary.
	subject := self createSubjectDialog: false.
	self assert: subject displayMonitor equals: owner monitor.
	rect := subject getRect.
	self assert: rect extent equals: self dialogExtent * owner dpi // USER_DEFAULT_SCREEN_DPI.
	"Deliberately reposition to other monitor"
	subject position: subject position - subject displayMonitor origin.
	self assert: subject displayMonitor equals: DisplayMonitor primary.
	"Should be rescaled (if dpi's different), but rounding error is possible"
	self
		assert: subject extent
		closeTo: self dialogExtent * DisplayMonitor primary dpi // USER_DEFAULT_SCREEN_DPI
		precision: 1.
	subject showModeless.
	"When shown, should reposition back to owner monitor"
	self assert: subject displayMonitor equals: secondary.
	self
		assert: subject position
		closeTo: rect origin
		precision: 1.
	self
		assert: subject extent
		closeTo: rect extent
		precision: 1.
	subject destroy!

testInplaceNotRepositioned
	| desktopMonitors position dialog leftMonitor ownerRect |
	desktopMonitors := self desktopMonitors.
	leftMonitor := desktopMonitors first.
	"This test requires multiple monitors arranged in a typical horizontal configuration. It could be made to work in a vertical configuration, but there isn't much value."
	self skipUnless: 
			[desktopMonitors size > 1
				and: [desktopMonitors second workArea origin >= leftMonitor workArea topRight]].
	"We need a view that is mainly on the left-most monitor, and partially on the next"
	ownerRect := (leftMonitor workArea corner x - 400) @ 100 extent: 640 @ 480.
	owner := self createShell: ownerRect text: self printString , ' owner'.
	self assert: owner displayMonitor equals: leftMonitor.
	dialog := DialogView new
				isInitiallyCentered: false;
				create;
				yourself.
	"Position the dialog on the 2nd monitor, but still over the owner view, before we show it"
	dialog rectangle: (ownerRect corner - self dialogExtent + 50 extent: self dialogExtent).
	self deny: dialog displayMonitor equals: leftMonitor.
	position := dialog position.
	"Show the dialog - it shouldn't get moved"
	dialog showModeless.
	self deny: dialog displayMonitor equals: leftMonitor.
	self assert: dialog position equals: position.
	dialog destroy!

testNearOwnerModal
	"Test that a modal dialog that is not initially centred is at least shown on the same display as its owner."

	| secondary dialogMonitor rect |
	secondary := self getSecondaryMonitorIfAvailable.
	self createTestShells: secondary.
	self evaluateInModalDialog: 
			[:dialog |
			dialogMonitor := dialog displayMonitor.
			rect := dialog getRect]
		centered: false.
	self assert: dialogMonitor equals: secondary.
	self assert: rect extent equals: self dialogExtent * owner dpi // USER_DEFAULT_SCREEN_DPI.
	"Lose activation and reposition the cursor to the secondary monitor"
	cursorPos := secondary workArea center.
	self setUpFakeUserLibrary.
	self assertIsNil: View active.
	self evaluateInModalDialog: [:dialog | dialogMonitor := dialog displayMonitor] centered: false.
	self assert: dialogMonitor equals: secondary!

testRecreate
	"Test that a modeless dialog recreates with correct owner, positioning, etc."

	| secondary subject rect |
	secondary := self getSecondaryMonitorIfAvailable.
	self createTestShells: secondary.
	subject := self createSubjectDialog: false.
	rect := subject rectangle.
	self assert: rect extent equals: self dialogExtent * owner dpi // USER_DEFAULT_SCREEN_DPI.
	subject showModeless.
	self assert: subject getOwner equals: owner handle.
	self assert: subject displayMonitor equals: owner monitor.
	self assert: subject getRect equals: rect.
	self assert: subject getWindowText equals: self printString.
	subject recreate.
	self assert: subject getOwner equals: owner handle.
	self assert: subject isWindowVisible.
	self assert: subject getRect equals: rect.
	self assert: subject getWindowText equals: self printString.
!

testRemainsOnScreen
	"Test that an initially centred dialog is positioned so that it is fully visible, even if this means not being completely centred in the owner."

	| rect workArea captureRect monitor |
	workArea := SystemMetrics current virtualScreenRectangle.
	"Position the (small) owner top-left so the dialog needs to be bumped back to the origin"
	monitor := DisplayMonitor nearestPoint: workArea origin.
	owner := self
				createShell: (Rectangle origin: monitor workArea origin + (25 @ 25 * monitor dpi // 96)
						extent: 75 @ 50 * monitor dpi // 96)
				text: self printString , ' owner'.
	captureRect := [:dialog | rect := dialog rectangle].
	self evaluateInModalDialog: captureRect centered: true.
	"Note that there may be areas of the virtual screen that are not visible on any monitor, either because the monitors are deliberately staggered, or are of different sizes"
	self assert: rect origin equals: monitor workArea topLeft.
	"Now bottom-left"
	monitor := DisplayMonitor nearestPoint: workArea bottomLeft.
	owner rectangle: (Rectangle origin: monitor workArea bottomLeft + (25 @ -100 * monitor dpi // 96)
				extent: 75 @ 50 * monitor dpi // 96).
	self evaluateInModalDialog: captureRect centered: true.
	self assert: rect origin
		equals: monitor workArea bottomLeft - (0 @ self dialogExtent y * monitor dpi // 96).
	"Now bottom-right"
	monitor := DisplayMonitor nearestPoint: workArea bottomRight.
	owner rectangle: (Rectangle origin: monitor workArea bottomRight + (-75 @ -100 * monitor dpi // 96)
				extent: 75 @ 50 * monitor dpi // 96).
	self evaluateInModalDialog: captureRect centered: true.
	self assert: rect origin
		equals: monitor workArea bottomRight - (self dialogExtent * monitor dpi // 96).
	"Finally, top-right"
	monitor := DisplayMonitor nearestPoint: workArea topRight.
	owner rectangle: (Rectangle origin: monitor workArea topRight + (-75 @ 25 * monitor dpi // 96)
				extent: 75 @ 50 * monitor dpi // 96).
	self evaluateInModalDialog: captureRect centered: true.
	self assert: rect origin
		equals: (self workAreaNearest: workArea topRight) topRight
				- (self dialogExtent x @ 0 * monitor dpi // 96)!

testShownNearOwnerModeless
	"Test that a modeless dialog which is not initially centred is at least displayed on the same monitor as its owner"

	| secondary subject rect |
	secondary := self getSecondaryMonitorIfAvailable.
	self createTestShells: secondary.
	"Test the case of creating a dialog with a desired position on a monitor other than the owner monitor. This will initially get created on the owner monitor (since we the Windows APIs for creating dialogs do not provide any way to control the position and extent), and then get moved. When moved, a DPI change may occur, making this a rather complex case to implement correctly."
	subject := self createSubjectDialog: false at: 10 @ 10.
	self assert: subject displayMonitor equals: DisplayMonitor primary.
	rect := subject getRect.
	self
		assert: rect extent
		closeTo: self dialogExtent * DisplayMonitor primary dpi // USER_DEFAULT_SCREEN_DPI
		precision: 1.
	subject showModeless.
	self assert: subject displayMonitor equals: secondary.
	"We should maintain the same position relative to the display origin"
	self assert: subject position - secondary origin equals: rect origin.
	self
		assert: subject extent
		closeTo: self dialogExtent * secondary dpi // USER_DEFAULT_SCREEN_DPI
		precision: 1.
	subject destroy! !

!UI.Tests.DialogViewTest categoriesForMethods!
classToTest!helpers!private! !
createSubjectDialog:!helpers!private! !
createSubjectDialog:at:!helpers!private! !
createTestShells:!helpers!private! !
dialogExtent!constants!private! !
evaluateInModalDialog:centered:!private! !
testCenteringInOwner!public!unit tests! !
testCenteringInOwnerModeless!public!unit tests! !
testCreatedNearOwnerModeless!public!unit tests! !
testInplaceNotRepositioned!public!unit tests! !
testNearOwnerModal!public!unit tests! !
testRecreate!public!unit tests! !
testRemainsOnScreen!public!unit tests! !
testShownNearOwnerModeless!public! !
!

!UI.Tests.DialogViewTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 133 0 0 0 416 788230 ##(BorderLayout)  1 1 0 410 8 ##(ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 560 0 0 0 5 0 0 0 560 1180166 ##(ResourceIdentifier)  8 ##(Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  21 437 834 469 71 560 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 218 0 0 0 244 0 0 0 253 0 0 0] 98 0 834 193 193 0 27 0 0 0 234 256 928 590342 ##(Rectangle)  834 21 21 834 21 21 0 0 0 0 12301 0 0 0 0 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 706 202 208 98 2 770 800 98 2 834 1341 905 834 521 591 416 770 8 #menuBar: 98 1 0 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 158 2 0 0 196 1 0 0 162 3 0 0 235 2 0 0] 98 1 560 944 0 27 )!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 21 423 738 449 71 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 211 0 0 0 234 0 0 0 246 0 0 0] 8 #() 738 193 193 nil 27 nil nil nil 170 192 832 590342 ##(Smalltalk.Rectangle) 738 21 21 738 21 21 nil nil nil nil 9977 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007860128 626 138 144 34 1 690 #createAt:extent: 34 2 738 7039 21 738 521 591 416 786 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 195 14 0 0 49 1 0 0] 34 1 528 848 nil 27)! !

!UI.Tests.DialogViewTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

