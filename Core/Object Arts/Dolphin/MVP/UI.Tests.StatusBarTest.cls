"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest subclass: #'UI.Tests.StatusBarTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.StatusBarTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!
UI.Tests.StatusBarTest comment: ''!
!UI.Tests.StatusBarTest methodsFor!

classToTest
	^StatusBar!

oldDolphinVersionsForStbUpgrade
	^1 to: 4!

testItemLayout
	"This test assumes that the bar is large enough to fit all the fixed size items without truncation."

	self assert: presenter clientExtent x >= 200.
	presenter hasSizeGrip: true.
	self assert: presenter sizeGripWidth equals: SystemMetrics current scrollThumbExtent x.
	2 timesRepeat: 
			["One resizable item (only)"
			self testItemLayout: {StatusBarItem new
							width: -1;
							yourself}.

			"One fixed item (only)"
			self testItemLayout: {StatusBarItem new
							width: 147;
							yourself}.

			"One resizable item (first), one fixed (last)"
			self testItemLayout: {StatusBarItem new
							width: -1;
							yourself.
						StatusBarItem new
							width: 109;
							yourself}.

			"One resizable item (last), one fixed (first)"
			self testItemLayout: {StatusBarItem new
							width: 148;
							yourself.
						StatusBarItem new
							width: -1;
							yourself}.

			"One resizable item between two fixed"
			self testItemLayout: {StatusBarItem new
							width: 50;
							yourself.
						StatusBarItem new
							width: -1;
							yourself.
						StatusBarItem new
							width: 100;
							yourself}.
			"Two resizable items in the middle"
			self testItemLayout: {StatusBarItem new
							width: 50;
							yourself.
						StatusBarItem new
							width: -1;
							yourself.
						StatusBarItem new
							width: -1;
							yourself.
						StatusBarItem new
							width: 100;
							yourself}.

			"Two resizable items, at start and in the middle"
			self testItemLayout: {StatusBarItem new
							width: -1;
							yourself.
						StatusBarItem new
							width: 50;
							yourself.
						StatusBarItem new
							width: -1;
							yourself.
						StatusBarItem new
							width: 100;
							yourself}.
			"Two resizable items, at start and end"
			self testItemLayout: {StatusBarItem new
							width: -1;
							yourself.
						StatusBarItem new
							width: 101;
							yourself.
						StatusBarItem new
							width: 52;
							yourself.
						StatusBarItem new
							width: -1;
							yourself}.
			"Repeat without size grip"
			presenter hasSizeGrip: false.
			self assert: presenter sizeGripWidth equals: 0]!

testItemLayout: aCollectionOfStatusBarItems
	| widths items barWidth borders totalWidth gap rightMargin |
	presenter items: aCollectionOfStatusBarItems.
	items := presenter items.
	widths := (1 to: items size) collect: 
					[:i |
					| actualWidth item |
					actualWidth := (presenter itemRect: i) width.
					item := items at: i.
					item isAutoResize
						ifFalse: 
							["Non-resizable items should be the exact size requested"
							self assert: actualWidth equals: item width].
					actualWidth].
	borders := presenter sbGetBorders.
	rightMargin := borders at: 1.
	gap := borders at: 3.
	totalWidth := rightMargin + widths sum + ((widths size - 1) * gap)
				+ (presenter hasSizeGrip ifTrue: [SystemMetrics current scrollThumbExtent x] ifFalse: [0]).
	"These tests assume that the bar is of sufficient width to at least fit all items at full width."
	barWidth := presenter clientExtent x.
	self assert: totalWidth <= barWidth.
	(items anySatisfy: [:each | each width == -1])
		ifTrue: 
			["At least one resizable item, so the items should precisely fill the bar, allowing for the resize thumb, right margin, and gap between items."
			self assert: totalWidth equals: barWidth]!

testToggleItemAutoResize
	| borders expectedWidth subject |
	subject := StatusBarItem new
				width: 75;
				yourself.
	presenter items: {StatusBarItem new
					width: 50;
					yourself.
				subject.
				StatusBarItem new
					width: 100;
					yourself}.
	self assert: (presenter itemRect: 2) width equals: 75.
	"Make middle item auto-resize"
	subject isAutoResize: true.
	self assert: subject width equals: -1.
	borders := presenter sbGetBorders.
	expectedWidth := presenter clientWidth - 150 - (borders at: 1) - ((borders at: 2) * 2)
				- presenter sizeGripWidth.
	self assert: subject rectangle width equals: expectedWidth.
	"Toggle back to fixed size - current size should not change"
	subject isAutoResize: false.
	self assert: subject width equals: expectedWidth.
	self assert: subject rectangle width equals: expectedWidth.
	"Toggle back to auto-resize, again size should not change."
	subject isAutoResize: true.
	self assert: subject width equals: -1.
	self assert: subject rectangle width equals: expectedWidth!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view backcolor
		identicalTo: (anInteger < 13 ifTrue: [Color face3d] ifFalse: [Color default]).
	self assert: (view contents allSatisfy: [:each | each isKindOf: StatusBarItemAbstract]).
	self assert: (view baseStyleAllMask: OS.CommCtrlConstants.CCS_NOPARENTALIGN)!

vuFile
	^'StatusBar.Status bar.vu'! !
!UI.Tests.StatusBarTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
testItemLayout!public!unit tests! !
testItemLayout:!helpers!private! !
testToggleItemAutoResize!public!unit tests! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.StatusBarTest class methodsFor!

resource_Status_bar_D6
	"Answer the literal data from which the 'Status bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Status_bar)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.StatusBar) 98 18 0 0 98 2 8 1409288460 1 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 0 416 0 8 4294903525 234 256 98 0 98 1 853766 ##(Smalltalk.StatusBarItem) 1 -1 416 0 459270 ##(Smalltalk.Message) 8 #displayString 98 0 754 8 #iconImageIndex 688 1049670 1 ##(Smalltalk.IconImageManager) 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 416 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 626 3359 21 626 701 45 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 237 7 0 0 32 0 0 0] 98 0 626 193 193 0 27)!

resource_Status_bar_D7
	"Answer the literal data from which the 'Status bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Status_bar)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StatusBar) 34 18 nil nil 34 2 8 1409288460 1 416 nil 327686 ##(Smalltalk.Color) #default nil 5 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 8 1903688272 170 192 8 #() 34 1 853766 ##(Smalltalk.StatusBarItem) 1 -1 416 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 722 #iconImageIndex 8 #() nil 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 416 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 3839 21 594 701 45 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 32 0 0 0] 8 #() 594 193 193 nil 27)! !
!UI.Tests.StatusBarTest class categoriesForMethods!
resource_Status_bar_D6!public!resources-views! !
resource_Status_bar_D7!public!resources-views! !
!

