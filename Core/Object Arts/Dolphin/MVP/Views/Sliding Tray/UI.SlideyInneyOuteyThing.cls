"Filed out from Dolphin Smalltalk 7"!

UI.ContainerView subclass: #'UI.SlideyInneyOuteyThing'
	instanceVariableNames: 'tabs tray trayExtent animationDuration tickCounter siotFlags _siotReserved1 _siotReserved2'
	classVariableNames: 'AnimationDuration Animations SlideInDelay'
	imports: #(#{OS.ThemeConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'AnimatedCardChangeMask' -> 16r8.
		'AnimatedUnpinMask' -> 16r2.
		'AnimationMask' -> 16rC0010.
		'HideOnUnpinMask' -> 16r1.
		'ResizableMask' -> 16r4
	}!
UI.SlideyInneyOuteyThing guid: (Core.GUID fromString: '{b9cf8580-efea-4336-84cd-3108804dd202}')!
UI.SlideyInneyOuteyThing comment: 'SlideyInneyOuteyThing is a decorator for a <CardContainer> which behaves like one of those slidey-inney-outey-things one sees in Visual Studio.NET, i.e: It display a thin tab strip most of the time, but slides cards smoothly out (as if they were on a sliding "tray") when one hovers over them. . The tray slides out over the top of any sibling views of the SlideyInneyOuteyThing, and so it does not cause any relayout within the parent. The tray can then be pinned into place if desired, in which case the parent is re-layed out to accomodate the full extent of the SlideyInneyOuteyThing. When pinned a SlideyInneyOuteyThing behaves visually like a normal <CardContainer>. When unpinned, the tray will slide back when the user moves outside the tray/tabs for a short period. This is useful for panes which are used only occassionally since they need consume only a little space (for the tabs) when they are not being used.

A SlideyInneyOuteyThing must be used in conjunction with a <SlidingCardTray> as its actual <CardContainer>, and can host only one such card container. The cards themselves must be added to the <SlidingCardTray>, NOT to the SlideyInneyOuteyThing which, as mentioned, is a decorator rather than a card container itself.

Instance Variables:
	tabs			<TabView>. The tabs, shared with the tray.
	tray			<SlidingCardTray> which actually contains the cards.
	slideExtent	<Point>. The extent of the tray when slid out.
	'!
!UI.SlideyInneyOuteyThing categoriesForClass!MVP-Resources-Card Containers!MVP-Views! !
!UI.SlideyInneyOuteyThing methodsFor!

actualPreferredExtent: aLayoutContext 
	"Private - Answer the preferred extent of the receiver given the suggested extent specifed
	by the <Point> argument. The preferred extent of a sliding container specifies the extent when pinned.
	When unpinned the extent is always calculated to display the channel bar."

	^(self preferredExtent notNil and: [self isPinned]) 
		ifTrue: [self preferredExtent]
		ifFalse: [self calculateExtent: aLayoutContext]!

addSubView: aView 
	"Adds aView as a subview of the receiver. Informs the receiver that the view
	has been added"

	(aView isManaged and: [self managedSubViews notEmpty]) 
		ifTrue: [^self error: 'can slide only a single child'].
	^super addSubView: aView!

animateNegativeFlag
	^self isVertical ifTrue: [AW_HOR_NEGATIVE] ifFalse: [AW_VER_NEGATIVE]!

animatePositiveFlag
	^self isVertical ifTrue: [AW_HOR_POSITIVE] ifFalse: [AW_VER_POSITIVE]!

animateTray: aBoolean
	UserLibrary default
		animateWindow: tray asParameter
		dwTime: self animationDuration
		dwFlags: (self trayAnimationType bitOr: (aBoolean
						ifFalse: 
							[AW_HIDE | (self isInverted ifFalse: [self animateNegativeFlag] ifTrue: [self animatePositiveFlag])]
						ifTrue: [self isInverted ifTrue: [self animateNegativeFlag] ifFalse: [self animatePositiveFlag]]))!

animation
	"Answer the symbolic name of the animation used to reveal the card tray. This could be
	#roll, #slide, #blend or #collapse. Note that #blend doesn't actually fade in the tray, but
	shows it immediately (which effectively allows animation to be disabled)."

	^Animations keyAtValue: (siotFlags bitAnd: AnimationMask)!

animation: aSymbol 
	siotFlags := (siotFlags maskClear: AnimationMask) maskSet: (Animations at: aSymbol ifAbsent: [0])!

animationDuration
	"Answer the number of milliseconds that the animations should take. This is only relevant if
	#slide or #roll animations are configured."

	^animationDuration!

autoHideTimerInterval
	^50!

backcolor: aColorOrNil 
	"Sets the background colour of the receiver to aColorOrNil.
	If aColorOrNil is nil then use the default color"

	backcolor := aColorOrNil.
	tabs backcolor: aColorOrNil!

calculateExtent: aLayoutContext 
	"Private - Answer the calculated extent of the receiver that should be used by a layout
	manager during it's layout process."

	^self isPinned 
		ifTrue: [self layoutManager preferredLayoutExtentOf: self context: aLayoutContext]
		ifFalse: 
			[| currentExtent client |
			currentExtent := aLayoutContext clientExtentOf: self.
			client := self isVertical 
						ifTrue: 
							["If we use a width of 0, then we get 0@0 back regardless of height"
							1 @ currentExtent y]
						ifFalse: [currentExtent x @ 0].
			(tabs calcExtentFromClientExtent: client) - (0@0)]!

canAcceptSubViews
	"Answer true if the receiver can host arbitrary sub-views."

	^false!

cardLayout
	^tray ifNil: [self layoutManager] ifNotNil: [tray cardLayout]!

cards
	^tray cards!

createTabs
	"Private - Add a <TabView> as a non-managed sub view of the receiver"

	tabs notNil ifTrue: [^self].
	tabs := self newTabs.
	tabs isManaged: false.
	self basicAddSubView: tabs!

createTray
	self createTabs.
	self isStateRestoring ifTrue: [^self].
	tray := SlidingCardTray new
				layoutManager: self layoutManager;
				setSlider: self;
				parentView: self;
				create;
				zOrderTop;
				yourself!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^Color face3d!

defaultLayoutManager
	^CardLayout new!

hasFixedHeight
	"Answer whether this view is of a fixed height."

	"A SlideyInneyOuteyThing is of fixed height when unpinned with horizontal tabs - its width
	will be fixed at that required to display those tabs."

	^self isVertical not and: [self isPinned not]!

hasFixedWidth
	"Answer whether this view is of a fixed width."

	"A SlideyInneyOuteyThing is of fixed width when unpinned with vertical tabs - its width will
	be fixed at that required to display those tabs."

	^self isVertical and: [self isPinned not]!

hideTray
	"Hide the tray, i.e. slide it in. Note that this request is ignored if the receiver is pinned"

	self isPinned ifTrue: [^self].
	self killAutoHideTimer.
	trayExtent := tray extent.
	(self isTrayVisible and: [self isUnpinAnimated]) 
		ifTrue: [self animateTray: false]
		ifFalse: [tray hide]!

implicitInsets: aLayoutContext 
	"Private - Answer a <Rectangle> whose edges specify the implicit distance (in pixels) by
	which the sub views have to be inset from the border of the receiver."

	"Implementation Note: We must calculate this to allow space for the TabView's decoration
	(the tabs themselves, borders, etc)."

	| rect clientRect |
	rect := aLayoutContext rectangleOf: tabs.
	clientRect := tabs calcClientRectangleFromRectangle: rect.
	^rect insetBy: clientRect!

initialize
	"Private - Initialize the receiver"

	super initialize.
	trayExtent := 100 @ 100.
	animationDuration := AnimationDuration.
	siotFlags := AnimatedUnpinMask | HideOnUnpinMask | AnimatedCardChangeMask!

isCardChangeAnimated
	"Answer whether changing cards when unpinned is animated. This does not apply when the tray is pinned."

	^siotFlags allMask: AnimatedCardChangeMask!

isCardChangeAnimated: aBoolean 
	"Set whether changing cards when unpinned is animated. This does not apply when the tray is pinned."

	siotFlags := siotFlags mask: AnimatedCardChangeMask set: aBoolean!

isHiddenOnUnpin
	"Answer whether or not the tray should be hidden when it is unpinned."

	^siotFlags allMask: HideOnUnpinMask!

isHiddenOnUnpin: aBoolean
	"Answer whether or not the tray should be hidden when it is unpinned."

	siotFlags := siotFlags mask: HideOnUnpinMask set: aBoolean!

isInverted
	"Answer whether the receiver has its buttons or tabs
	along its bottom or right edges rather than along
	its top or left edges."

	^tray isInverted!

isInverted: aBoolean 
	"Set whether the receiver has its buttons or tabs
	along its bottom or right edges rather than along
	its top or left edges."

	^tray isInverted: aBoolean!

isPinned
	"Answer whether the receiver has been pinned (i.e. permanently slid out)"

	^tray notNil and: [tray parentView == self]!

isPinned: aBoolean 
	"Pin or unpin the tray, depending on the <boolean> argument."

	self isPinned == aBoolean ifTrue: [^self].
	aBoolean ifTrue: [self pin] ifFalse: [self unpin]!

isTrayResizable
	"Answer whether the tray should be resizable when unpinned - i.e. it has a sizing frame that allows the user to resize it as per their preference."

	^siotFlags allMask: ResizableMask!

isTrayResizable: aBoolean 
	"Set whether the tray should be resizable when unpinned - i.e. it has a sizing frame that
	allows the user to resize it as per their preference."

	siotFlags := siotFlags mask: ResizableMask set: aBoolean!

isTrayVisible
	^tray isWindowVisible!

isUnpinAnimated
	"Answer whether the unpin operation is animated - note that this is only relevant if
	#isHiddenOnUnpin is true."

	^(siotFlags allMask: AnimatedUnpinMask) and: 
			["When aero is enabled the unpin animation results in scarring on some display drivers"
			DwmApiLibrary isDesktopCompositionEnabled not]!

isUnpinAnimated: aBoolean 
	"Set whether the unpin operation is animated - note that this is only relevant if
	#isHiddenOnUnpin is true."

	siotFlags := siotFlags mask: AnimatedUnpinMask set: aBoolean!

isVertical
	"Answer whether the receiver has a vertical (portrait as opposed to landscape) orientation."

	^tray isVertical!

isVertical: aBoolean 
	"Set whether or not the receiver a vertical (address book) orientation
	(i.e. with the buttons/tabs at the right of left hand sides instead of 
	along the top or bottom)."

	^tray isVertical: aBoolean!

killAutoHideTimer
	self killTimer: AW_HIDE!

layout: aLayoutContext 
	"Private - Recalculate the geometry of the receiver. Ensure the slide out tray is appropriately positioned."

	self positionTray: aLayoutContext.
	aLayoutContext setView: tabs rectangle: (0 @ 0 extent: (aLayoutContext extentOf: self)).
	super layout: aLayoutContext.

	"This is necessay to get the tray to relayout when sizing down, even when pinned (?)"
	tray validateLayout!

layoutManager: aLayoutManager
	"Private - Set the receiver's <LayoutManager>. The layout manager is responsible for controlling the
	position and extent of the receiver's sub-views."

	"The receiver's layout manager must be a CardLayout"

	(aLayoutManager isKindOf: CardLayout) ifFalse: [^self error: 'invalid layout manager'].
	super layoutManager: aLayoutManager!

newTabs
	^TabViewXP new
		isVertical: true;
		yourself!

observeTabs
	tabs
		when: #mouseMoved:
			send: #onMouseMoved:
			to: self;
		when: #mouseHovering:
			send: #onMouseHovering:
			to: self;
		when: #selectionChanging:
			send: #onTabChanging:
			to: self;
		when: #selectionChanged
			send: #onTabChanged
			to: self;
		when: #leftButtonPressed:
			send: #onTabClicked
			to: self!

onMouseHovering: aMouseEvent 
	"Private - Default handler for a mouse hover event. Accept the default processing."

	"Implementation Note: This may be due to a mouse hover over a tab, or some other area of the tab-view."

	self showTray!

onMouseMoved: aMouseEvent 
	"Private - Handler for mouseMoved: events. If the tray is not slid out, then we want to detect hovering
	over the container."

	"Implementation Note: The TabView returns HTTRANSPARENT to WM_NCHITTEST when the mouse is
	over the tab-strip but not over an actual tab. This causes Windows to direct the mouse move
	event to the parent, as if that area of the tab control were transparent, which is why we
	need this handler."

	self isTrayVisible ifFalse: [aMouseEvent window trackMouseHover: -1]!

onTabChanged
	"Private - A tab has been selected by the user. The contained CardContainer will display the
	appropriate card so we do not need the superclass behaviour. We do, however, want to make
	sure that the tray is slid out when a tab is clicked."

	(self isPinned not and: [self isCardChangeAnimated]) ifTrue: [tray hide].
	tray onTabChanged.
	self showTray!

onTabChanging: aSelectionChangingEvent 
	tray onTabChanging: aSelectionChangingEvent!

onTabClicked
	self isTrayVisible ifTrue: [^self].
	[self showTray] postToMessageQueue!

onTimerTick: anInteger
	| pos |
	(anInteger ~~ AW_HIDE or: [View capture == tray]) ifTrue: [^self].
	self isPinned
		ifTrue: 
			[self killAutoHideTimer.
			^self].
	pos := Cursor position.
	((self screenRectangle merge: tray screenRectangle) containsPoint: pos)
		ifTrue: [tickCounter := 0]
		ifFalse: 
			[tickCounter := tickCounter + 1.
			tickCounter > (SlideInDelay // self autoHideTimerInterval) ifTrue: [self hideTray]]!

onViewCreated
	self createTray.
	self presenter 
		when: #timerTick:
		send: #onTimerTick:
		to: self.
	tray 
		when: #headerClicked
		send: #hideTray
		to: self.
	self assert: [self isStateRestoring or: [tabs isManaged not]].
	self usePreferredExtent: true.
	self observeTabs.
!

onViewDestroyed
	"Private - Handler for view final view destruction. This is sent on receipt of WM_NCDESTROY,
	and is expected to be the last communication from Windows. There is nothing
	more we can do to save the patient. No event is triggered.
	Note that we don't do finalization actions here, because a more robust choice
	is in the actual handler for WM_NCDESTROY, just in case the presenter fails
	to forward on this message."

	super onViewDestroyed.
	tray destroy!

pin
	"Pin the tray in its shown (slid out) position."

	| corner trayResized |
	self isPinned ifTrue: [^self].
	tabs hasHotTracking: false.
	self showTray.
	trayResized := trayExtent ~= tray extent.
	corner := tray rectangle topRight.
	tray setParent: self.
	"When pinned the receiver's CardLayout needs to position the tray thankyou"
	tray isManaged: true.
	tray show.
	trayResized ifFalse: [^self].
	"Hmmm, unfortunately we have to revalidate the layout first because otherwise the splitter may be hidden and does not get moved."
	(self parentView)
		invalidateLayout;
		validateLayout.
	self parentView layoutManager 
		ifNotNil: [:layout | self nextSiblingView ifNotNil: [:next | layout reposition: next to: corner]]!

positionTray: aLayoutContext 
	| nc myExtent rect myRect |
	self isPinned 
		ifTrue: 
			["Tray is position by card layout when pinned"
			^self].
	nc := self implicitInsets: aLayoutContext.
	myRect := aLayoutContext rectangleOf: self.
	myExtent := myRect extent.
	rect := self isVertical 
				ifTrue: 
					[self isInverted 
						ifTrue: [(myRect left + nc left - trayExtent x) @ myRect top extent: trayExtent x @ myExtent y]
						ifFalse: [(myRect left + nc left) @ myRect top extent: trayExtent x @ myExtent y]]
				ifFalse: 
					[| right left |
					right := myRect right "- nc right + 2".
					left := myRect left + 1.
					self isInverted 
						ifTrue: 
							[| bottom |
							bottom := myRect bottom - nc bottom - 1.
							left @ (bottom - trayExtent y max: 0) corner: right @ bottom]
						ifFalse: 
							[| top |
							top := myRect top + nc top.
							left @ top corner: right @ (top + trayExtent y min: self parentView height)]].
	aLayoutContext setView: tray rectangle: rect!

showShell
	"Private - Show the receiver within a shell"

	| shell |
	shell := ShellView new
				create;
				yourself.
	shell extent: (shell calcExtentFromClientExtent: self defaultExtent).
	shell layoutManager: BorderLayout new.
	self
		parentView: shell;
		arrangement: #west.
	self create show.
	shell show!

showTray
	"Show the tray, i.e. slide it out."

	self isTrayVisible ifTrue: [^self].
	self animateTray: true.
	"Rather than capture the mouse and slide the tray back immediately the user moves outside
	the window, we can use the simpler mechanism of a timer, the even handler for which tests
	whether the user is still over the receiver's tabs or tray and slides in the tray if not.
	This is more useable anyway, as it allows us to introduce a slight delay before the window
	slides in. This means that if the user moves the mouse outside the tray momentarily by
	mistake the tray will not slide in."
	self startAutoHideTimer!

startAutoHideTimer
	tickCounter := 0.
	self setTimer: AW_HIDE interval: self autoHideTimerInterval!

tabs
	^tabs!

tray
	^tray!

trayAnimationType
	^siotFlags bitAnd: AnimationMask!

unpin
	"Unpin the tray so that it no longer consumes any screen real-estate. The receiver resumes
	its slide-out-on-hover behaviour."

	self isPinned ifFalse: [^self].
	trayExtent := tray extent.
	"Prevent the CardLayout from attempting to position the tray"
	tray isManaged: false.
	tray setParent: self parentView.
	self isHiddenOnUnpin 
		ifTrue: 
			["We must relayout the parent first, or gaps will be left as the tray slides back"
			self invalidateLayout.
			self parentView update.
			self hideTray]
		ifFalse: 
			[self
				startAutoHideTimer;
				invalidateLayout].
	tabs hasHotTracking: true!

validateSubViewLayouts: aLayoutContext 
	super validateSubViewLayouts: aLayoutContext.
	"#2114 - when unpinned the tray is an unmanaged child of the parent container, and so will
	not get layed out by the normal mechanism."
	self isPinned ifFalse: [tray validateLayout: aLayoutContext]!

wmPrint: message wParam: wParam lParam: lParam
	| result canvas insetRect prev |
	self ensureLayoutValid.
	(self isPinned not or: [lParam noMask: PRF_CHILDREN]) ifTrue: [^nil].
	result := self
				defaultWindowProcessing: message
				wParam: wParam
				lParam: lParam.
	insetRect := self actualInsets: (LayoutContext forContainer: self parentView).
	canvas := Canvas withNonOwnedDC: wParam.
	prev := canvas offsetWindowOrigin: insetRect topLeft * -1.
	tray
		sendMessage: message
		wParam: wParam
		lParam: lParam.
	canvas windowOrigin: prev.
	^result! !
!UI.SlideyInneyOuteyThing categoriesFor: #actualPreferredExtent:!geometry!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #addSubView:!hierarchy!public!sub views! !
!UI.SlideyInneyOuteyThing categoriesFor: #animateNegativeFlag!constants!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #animatePositiveFlag!constants!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #animateTray:!helpers!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #animation!accessing!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #animation:!accessing!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #animationDuration!constants!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #autoHideTimerInterval!constants!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #backcolor:!accessing!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #calculateExtent:!geometry!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #canAcceptSubViews!hierarchy!public!sub views! !
!UI.SlideyInneyOuteyThing categoriesFor: #cardLayout!accessing!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #cards!public!updating! !
!UI.SlideyInneyOuteyThing categoriesFor: #createTabs!helpers!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #createTray!helpers!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #defaultBackcolor!colors!constants!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #defaultLayoutManager!initializing!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #hasFixedHeight!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #hasFixedWidth!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #hideTray!commands!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #implicitInsets:!accessing!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #initialize!initializing!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #isCardChangeAnimated!public!testing! !
!UI.SlideyInneyOuteyThing categoriesFor: #isCardChangeAnimated:!accessing!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #isHiddenOnUnpin!public!testing! !
!UI.SlideyInneyOuteyThing categoriesFor: #isHiddenOnUnpin:!accessing!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #isInverted!accessing-styles!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #isInverted:!accessing-styles!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #isPinned!public!testing! !
!UI.SlideyInneyOuteyThing categoriesFor: #isPinned:!commands!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #isTrayResizable!public!testing! !
!UI.SlideyInneyOuteyThing categoriesFor: #isTrayResizable:!public!testing! !
!UI.SlideyInneyOuteyThing categoriesFor: #isTrayVisible!public!testing! !
!UI.SlideyInneyOuteyThing categoriesFor: #isUnpinAnimated!public!testing! !
!UI.SlideyInneyOuteyThing categoriesFor: #isUnpinAnimated:!accessing!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #isVertical!accessing!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #isVertical:!accessing-styles!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #killAutoHideTimer!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #layout:!geometry!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #layoutManager:!development!geometry!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #newTabs!helpers!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #observeTabs!event handling!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #onMouseHovering:!constants!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #onMouseMoved:!event handling!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #onTabChanged!event handling!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #onTabChanging:!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #onTabClicked!event handling!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #onTimerTick:!event handling!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #onViewCreated!event handling!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #onViewDestroyed!event handling!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #pin!commands!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #positionTray:!geometry!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #showShell!operations!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #showTray!commands!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #startAutoHideTimer!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #tabs!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #tray!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #trayAnimationType!constants!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #unpin!commands!public! !
!UI.SlideyInneyOuteyThing categoriesFor: #validateSubViewLayouts:!geometry!private! !
!UI.SlideyInneyOuteyThing categoriesFor: #wmPrint:wParam:lParam:!private! !

!UI.SlideyInneyOuteyThing class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	AnimationDuration := 200.
	SlideInDelay := 500.
	self addClassConstant: 'AnimationMask' value: AW_SLIDE | AW_BLEND | AW_CENTER.
	self addClassConstant: 'Animations'
		value: (IdentityDictionary new
				at: #roll put: 0;
				at: #collapse put: AW_CENTER;
				at: #slide put: AW_SLIDE;
				at: #blend put: AW_BLEND;
				shrink;
				isImmutable: true;
				yourself)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.SlideyInneyOuteyThing) 34 23 nil nil 34 2 8 1409286144 131073 416 nil 917510 ##(Graphics.Color) #default nil 517 nil nil nil 416 853318 1 ##(UI.CardLayout) 138 144 8 #() nil nil nil nil 170 192 560 nil 410 ##(UI.TabViewXP) 34 28 nil 416 34 2 8 1140916864 1 592 787270 2 ##(UI.ListModel) 138 144 560 nil 1638406 ##(Kernel.IdentitySearchPolicy) 496 nil 1 nil nil nil 592 nil 8 1920388864 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 1 1 898 701 501 592 850 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 592 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 898 193 193 nil 27 410 ##(UI.SlidingCardTray) 34 22 nil 416 34 2 8 1140850688 131073 1056 nil 496 nil 5 nil nil nil 1056 528 170 192 560 nil 592 nil 416 898 33 33 1246790 1 ##(UI.ButtonInteractor) 1056 nil 1 1180166 ##(Graphics.Rectangle) 898 649 3 898 681 35 nil 1377606 4 ##(UI.CommandDescription) #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 9 9 898 685 485 1056 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 246 0 0 0] 8 #() 1040 nil 27 898 201 201 401 nil 31 nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 6143 21 898 701 501 416 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 34 2 1056 592 1040 nil 27)! !
!UI.SlideyInneyOuteyThing class categoriesFor: #icon!constants!public! !
!UI.SlideyInneyOuteyThing class categoriesFor: #initialize!class initialization!development!private! !
!UI.SlideyInneyOuteyThing class categoriesFor: #resource_Default_view!public!resources-views! !

