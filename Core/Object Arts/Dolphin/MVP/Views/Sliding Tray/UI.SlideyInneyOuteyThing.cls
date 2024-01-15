"Filed out from Dolphin Smalltalk"!

UI.ContainerView
	subclass: #'UI.SlideyInneyOuteyThing'
	instanceVariableNames: 'tabs tray trayExtent animationDuration tickCounter siotFlags _siotReserved1 _siotReserved2'
	classVariableNames: ''
	imports: #(#{OS.ThemeConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'AnimatedCardChangeMask' -> 16r8.
			'AnimatedUnpinMask' -> 16r2.
			'AnimationDuration' -> 16rC8.
			'AnimationMask' -> 16rC0010.
			'Animations' -> (IdentityDictionary
						withAll: { #blend -> 16r80000. #collapse -> 16r10. #roll -> 16r0. #slide -> 16r40000 }).
			'HideOnUnpinMask' -> 16r1.
			'ResizableMask' -> 16r4.
			'SlideInDelay' -> 16r1F4
		}!
UI.SlideyInneyOuteyThing guid: (Core.GUID fromString: '{b9cf8580-efea-4336-84cd-3108804dd202}')!
UI.SlideyInneyOuteyThing comment: '`SlideyInneyOuteyThing` is a decorator for a `CardContainer` which behaves like one of those slidey-inney-outey-things one sees in Visual Studio, i.e: It displays a thin tab strip most of the time, but slides cards smoothly out (as if they were on a sliding "tray") when one hovers over them. The tray slides out over the top of any sibling views of the `SlideyInneyOuteyThing`, and so it does not cause any re-layout within the parent. The tray can then be pinned into place if desired, in which case the parent is re-layed out to accommodate the full extent of the `SlideyInneyOuteyThing`. When pinned a `SlideyInneyOuteyThing` behaves visually like a normal `CardContainer`. When unpinned, the tray will slide back when the user moves outside the tray/tabs for a short period. This is useful for panes which are used only occasionally since they need consume only a little space (for the tabs) when they are not being used.

A `SlideyInneyOuteyThing` must be used in conjunction with a `SlidingCardTray` as its actual `CardContainer`, and can host only one such card container. The cards themselves must be added to the `SlidingCardTray`,  *not* to the `SlideyInneyOuteyThing` which, as mentioned, is a decorator rather than a card container itself.

## Instance Variables:
  `tabs`		`TabView`. The tabs. Shared with the tray.
  `tray`		`SlidingCardTray` that actually contains the cards.
  `trayExtent`		`Point`. The extent of the tray when slid out.
  `animationDuration`		`<integer>`. Number of milliseconds for sliding animations.
  `tickCounter`		`<integer>`. Internal counter of 50mS timer ticks used to determine when to hide the tray.
  `siotFlags`		`<integer>`. Various flags specific to the SIOT.
  `_siotReserved1`		Reserved for future use.
  `_siotReserved2`		Reserved for future use.

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
	animationDuration = 0
		ifTrue: [User32 showWindow: tray asParameter nCmdShow: (aBoolean ifTrue: [SW_SHOW] ifFalse: [SW_HIDE])]
		ifFalse: 
			[User32
				animateWindow: tray asParameter
				dwTime: animationDuration
				dwFlags: self trayAnimationType | (aBoolean
								ifFalse: 
									[AW_HIDE | (self isInverted ifFalse: [self animateNegativeFlag] ifTrue: [self animatePositiveFlag])]
								ifTrue: [self isInverted ifTrue: [self animateNegativeFlag] ifFalse: [self animatePositiveFlag]])]!

animation
	"Answer the symbolic name of the animation used to reveal the card tray. This could be #roll, #slide, #blend or #collapse. Note that is only retained for backwards compatibility as it isn't actually a valid choice for non-top-level windows. The effect of using #blends is to disable animation, although this can also be achieved more correctly by setting the animation duration to 0."

	^Animations keyAtValue: (siotFlags bitAnd: AnimationMask)!

animation: aSymbol
	siotFlags := (siotFlags maskClear: AnimationMask) maskSet: (Animations at: aSymbol ifAbsent: 0)!

animationDuration
	"Answer the <Duration> that the animations should take. If the duration is empty, then there is no animation."

	^animationDuration milliseconds!

animationDuration: aDuration
	animationDuration := aDuration asMilliseconds rounded!

autoHideTimerInterval
	^50!

backcolor: aColorOrNil 
	"Sets the background colour of the receiver to aColorOrNil.
	If aColorOrNil is nil then use the default color"

	backcolor := aColorOrNil.
	tabs backcolor: aColorOrNil!

calculateExtent: aLayoutContext 
	"Private - Answer the calculated extent of the receiver that should be used by a layout
	manager during its layout process."

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
				beDefaultThemed;
				layoutManager: self layoutManager;
				setSlider: self;
				parentView: self;
				create;
				zOrderTop;
				yourself!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^Color.Face3d!

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
	siotFlags := ##(AnimatedUnpinMask | HideOnUnpinMask | AnimatedCardChangeMask)!

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
	"Set whether or not the tray should be hidden when it is unpinned."

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
			Dwmapi isDesktopCompositionEnabled not]!

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

	"This is necessary to get the tray to re-layout when sizing down, even when pinned (?)"
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
			["Tray is positioned by card layout when pinned"
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
	the window, we can use the simpler mechanism of a timer, the event handler for which tests
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
!UI.SlideyInneyOuteyThing categoriesForMethods!
actualPreferredExtent:!geometry!private! !
addSubView:!hierarchy!public!sub views! !
animateNegativeFlag!constants!private! !
animatePositiveFlag!constants!private! !
animateTray:!helpers!private! !
animation!accessing!public! !
animation:!accessing!public! !
animationDuration!constants!public! !
animationDuration:!accessing!public! !
autoHideTimerInterval!constants!private! !
backcolor:!accessing!public! !
calculateExtent:!geometry!private! !
canAcceptSubViews!hierarchy!public!sub views! !
cardLayout!accessing!private! !
cards!public!updating! !
createTabs!helpers!private! !
createTray!helpers!private! !
defaultBackcolor!colors!constants!private! !
defaultLayoutManager!initializing!private! !
hasFixedHeight!public! !
hasFixedWidth!public! !
hideTray!commands!public! !
implicitInsets:!accessing!private! !
initialize!initializing!private! !
isCardChangeAnimated!public!testing! !
isCardChangeAnimated:!accessing!public! !
isHiddenOnUnpin!public!testing! !
isHiddenOnUnpin:!accessing!public! !
isInverted!accessing-styles!public! !
isInverted:!accessing-styles!public! !
isPinned!public!testing! !
isPinned:!commands!public! !
isTrayResizable!public!testing! !
isTrayResizable:!public!testing! !
isTrayVisible!public!testing! !
isUnpinAnimated!public!testing! !
isUnpinAnimated:!accessing!public! !
isVertical!accessing!public! !
isVertical:!accessing-styles!public! !
killAutoHideTimer!private! !
layout:!geometry!private! !
layoutManager:!development!geometry!private! !
newTabs!helpers!private! !
observeTabs!event handling!private! !
onMouseHovering:!constants!private! !
onMouseMoved:!event handling!private! !
onTabChanged!event handling!private! !
onTabClicked!event handling!private! !
onTimerTick:!event handling!private! !
onViewCreated!event handling!private! !
onViewDestroyed!event handling!private! !
pin!commands!public! !
positionTray:!geometry!private! !
showShell!operations!private! !
showTray!commands!public! !
startAutoHideTimer!private! !
tabs!public! !
tray!public! !
trayAnimationType!constants!private! !
unpin!commands!public! !
validateSubViewLayouts:!geometry!private! !
wmPrint:wParam:lParam:!private! !
!

!UI.SlideyInneyOuteyThing class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	self addClassConstant: 'AnimationMask' value: AW_SLIDE | AW_BLEND | AW_CENTER.
	self addClassConstant: 'Animations'
		value: (IdentityDictionary
				withAll: { #roll -> 0. #collapse -> AW_CENTER. #slide -> AW_SLIDE. #blend -> AW_BLEND })!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.SlideyInneyOuteyThing} 38 #{Core.Array} 23 nil nil 50 2 8 1409286144 131073 32 nil 6 #{Graphics.Color} #default nil 517 nil nil nil 32 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 0 nil nil nil nil 550 #{Core.IdentityDictionary} 0 nil 18 #{UI.TabViewXP} 50 28 nil 32 50 2 8 1140916864 1 240 838 2 #{UI.ListModel} 178 0 nil 6 #{Kernel.IdentitySearchPolicy} 128 nil 1 nil nil nil 240 nil nil 518 #{Core.Message} #displayString 8 #() 386 #iconImageIndex 416 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #noIcons nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 578 701 501 240 530 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 240 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 578 193 193 nil 27 18 #{UI.SlidingCardTray} 50 22 nil 32 50 2 8 1140850688 131073 736 nil 128 nil 5 nil nil nil 736 160 210 0 nil 240 nil 32 578 33 33 1606 1 #{UI.ButtonInteractor} 736 nil 1 518 #{Graphics.Rectangle} 578 649 3 578 681 35 nil 1350 4 #{UI.CommandDescription} #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 482 50 1 530 #createAt:extent: 50 2 578 9 9 578 685 485 736 658 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 246 0 0 0] 8 #() 720 nil 27 578 201 201 401 nil 31 nil nil 482 50 1 530 #createAt:extent: 50 2 578 6143 21 578 701 501 32 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 50 2 736 240 720 nil 27)! !
!UI.SlideyInneyOuteyThing class categoriesForMethods!
icon!constants!public! !
initialize!class initialization!development!private! !
resource_Default_view!public!resources-views! !
!

