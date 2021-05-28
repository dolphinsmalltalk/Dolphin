"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #StatusBarTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StatusBarTest guid: (GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!

StatusBarTest comment: ''!

!StatusBarTest categoriesForClass!Unclassified! !

!StatusBarTest methodsFor!

classToTest
	^StatusBar!

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
	self assert: subject rectangle width equals: expectedWidth! !
!StatusBarTest categoriesForMethods!
classToTest!helpers!private! !
testItemLayout!public!unit tests! !
testItemLayout:!helpers!private! !
testToggleItemAutoResize!public!unit tests! !
!

