"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.View'
	instanceVariableNames: 'handle creationParent creationStyle presenter model backcolor preferredExtent flags contextMenu font events interactor'
	classVariableNames: 'MessageMap NextId ViewClosedError WndClassAtom'
	imports: #(#{OS.Win32Constants} #{OS.Win32Errors})
	classInstanceVariableNames: 'theme'
	classConstants: {
		'CreateCenteredMask' -> 16r40.
		'DragSourceMask' -> 16r4.
		'DropTargetMask' -> 16r8.
		'LayoutValidMask' -> 16r1.
		'ManagedMask' -> 16r2.
		'MinimizedMask' -> 16r80.
		'NoInheritMenuMask' -> 16r200.
		'StateRestoringMask' -> 16r20.
		'UIValidMask' -> 16r10.
		'UsePreferredExtentMask' -> 16r100
	}!
UI.View guid: (Core.GUID fromString: '{87b4c4cc-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.View comment: 'View is an abstract class which is the root of the view hierarchy of classes. Instances of view or its subclasses are used to display Model data in windows. View is part of the Model-View-Presenter or MVP framework:

SmalltalkSystem help: ''Overviews/ModelViewPresenter''.

Views are used in conjunction with <model> and <presenter> objects. Model objects are used to hold application data, and the view''s responsibility is to display this data on the screen. Models usually trigger change notification to ensure that the view is kept up-to-date with the current state of their data. Presenter objects sit between the view and the model and negotiate how changes made in the view should be applied to the model. 

Instance Variables:
	handle		<ExternalHandle> for the view''s window held by MS Windows.
	creationParent	<compositeView> which is the parent of the view.
	creationStyle	<Array> of two elements holding the window''s WS_xxx and WS_EX_xxx styles..
	presenter		<presenter> used for negotiating changes to the view''s model.
	model		<Object> holding the view''s data.
	backcolor		<color> for the explicit view background or nil for the default,
	preferredExtent	<Point> specifying an explicit preferred extent or nil for none..
	flags		<integer> holding various <boolean> flags.
	contextMenu	<Menu> a pop-up context menu or nil if none.
	font		<Font> for displaying 
	events		<EventsCollection> holding event subscriptions.
	interactor		<interactor> that handles mouse and keyboard input, normally the view itself.

Class Variables:
	CreateCenteredMask	<integer>
	DragSourceMask		<integer>
	DropTargetMask		<integer>
	LayoutValidMask		<integer>.
	ManagedMask		<integer>
	MessageMap		<Array>. Map between Win32 message id''s and View selectors.
	MinimizedMask		<integer>
	NextId			<integer>
	NoInheritMenuMask	<integer>
	StateRestoringMask		<integer>
	UIValidMask		<integer>
	UsePreferredExtentMask	<integer>
	ViewClosedError		<Signal> raised when operations performed against a closed view
	WndClassAtom		<integer>

'!
!UI.View categoriesForClass!MVP-Resources-Misc!MVP-Views! !
!UI.View methodsFor!

actualBackcolor
	"Private - Answer the <Color> to be applied as the receiver's background colour. If the
	local backcolor is nil then the backcolor is inherited from the parent chain. If the color
	is not nil, but is the default (i.e. 'Color default'), then map that to the corresponding
	real colour for the receiver."

	| color |
	color := self basicActualBackcolor.
	^color isDefault ifTrue: [self defaultBackcolor] ifFalse: [color]!

actualFont
	"Private - Answer the actual font to be used to paint text in the receiver.
	Views which have a nil font inherit their parent's font."

	^self font ifNil: [self parentView actualFont]!

actualPreferredExtent: aLayoutContext 
	"Private - Answer the preferred extent of the receiver given the suggested extent specifed
	by the <Point> argument. A preferred extent can be forced by setting the #preferredExtent
	aspect otherwise we see if one can be offered by any installed layout manager, and failing
	that try calculating an extent."

	^self preferredExtent ifNil: [self calculateExtent: aLayoutContext]!

addSubView: aView
	"Adds aView as a subview of the receiver. Informs the receiver that the view
	has been added"

	self basicAddSubView: aView.
	self onSubViewAdded: aView.
	^aView.!

addToCommandRoute: route
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer the next <Presenter> to visit.
	The receiver is guaranteed not to be on the command path already.
	Implementation Note: By default we fire it straight back."

	^route appendPresenter: self!

addToImageList: aWinImageList mask: aColorOrNil 
	"Private - Add a pictorial representation of the receiver to aWinImageList. Typically this is used to create
	a thumbnail representation of the receiver."

	| thumbnail |
	(self respondsTo: #createThumbnailExtent:mask:) 
		ifFalse: 
			["If GDI+ is not present just use an icon"
			^aWinImageList addIcon: self icon].
	thumbnail := self createThumbnailExtent: aWinImageList extent mask: aColorOrNil.
	^aWinImageList addBitmap: thumbnail mask: aColorOrNil!

adjustRectangle: aRectangle 
	"Update the <Rectangle> argument, which is a proposed new position and extent for the
	receiver, to account for any of the receiver's foibles. The default is to accept the
	rectangle as is, but subclasses may wish to override if, for example, they have a fixed
	width or height."

	^aRectangle!

allParents
	"Answers an <sequencedReadableCollection> of all parents of the receiver including, ultimately,
	the desktop."

	| answer |
	answer := OrderedCollection new.
	self allParentsDo: [:each | answer addLast: each].
	^answer!

allParentsDo: aMonadicValuable 
	"Evaluate the <monadicValuable> argument for each View in the receiver's parent chain
	including, ultimately, the desktop."

	self isOpen ifTrue: [self parentView withAllParentsDo: aMonadicValuable]!

allSubViews
	"Answers an OrderedCollection of all sub views of the receiver"

	| answer |
	answer := OrderedCollection new.
	self allSubViewsDo: [:each | answer add: each].
	^answer!

allSubViewsDo: aMonadicValuable 
	"Evaluate the <monadicValuable> argument for each of the sub-views of the receiver, and each
	of the sub-views' sub-views, and so on, recursively down through the hierarchy. This is a
	pre-order traversal."

	self subViewsDo: 
			[:each | 
			aMonadicValuable value: each.
			each allSubViewsDo: aMonadicValuable]!

ambientBackcolor
	"Private - Answer the background colour that should be inherited by children of this view
	that don't have their own background colour specified. Note that if the receiver is
	transparent, then it will return 'Color none' if no other colour is set, telling the child
	to draw itself transparently if it can."

	^self isTransparent 
		ifTrue: [Color none]
		ifFalse: 
			[self backcolor 
				ifNil: [self parentView ambientBackcolor]
				ifNotNil: [:color | color isDefault ifTrue: [self defaultBackcolor] ifFalse: [color]]]!

arrangement
	"Answer the arrangement parameter for the receiver in its parent's 
	layout manager. If no parameter has been explicitly set, or if the
	parent has no layout manager then answer nil"

	^self parentView arrangementOf: self.
!

arrangement: anObject
	"Set the arrangement parameter for the receiver in its parent's 
	layout manager to be anObject. If the parent has no layout manager 
	then a walkback will result"

	self parentView arrangementOf: self put: anObject.
!

asParameter
	"Answer the receiver in a form suitable for passing to an external
	function call (in this case the receiver's window handle)."

	^handle
!

attachHandle: anIntegerOrHandle
	"Private - Set the handle for this View and ensure that it is registered in our
	AllViews collection. Note that though the View (sub)instance itself
	holds its handle as an instance of ExternalHandle, AllViews is an 
	IdentityDictionary keyed by an Integer (which will be a SmallInteger since 
	window handles are typically small positive numbers). This arrangement
	permits AllViews to be an IdentityDictionary, and a faster lookup results
	for the critical message dispatching."

	self handle: anIntegerOrHandle asExternalHandle.
	SessionManager inputState windowAt: anIntegerOrHandle put: self!

backcolor
	"Answers the background colour of the receiver"

	^backcolor
!

backcolor: aColorOrNil 
	"Sets the background colour of the receiver to aColorOrNil.
	If aColorOrNil is nil then use the default color"

	self backcolor = aColorOrNil ifTrue: [^self].
	backcolor := aColorOrNil.
	self isOpen ifTrue: [self backcolorChanged]!

backcolorChanged
	self subViewsDo: [:each | each backcolorChanged].
	self invalidate!

baseCreationStyle
	"Answer the base window styles to be used to create the window. This might exclude some of
	the configured base styles, e.g. if they are not supported by the host."

	^self baseStyle!

baseStyle
	"Private - Answer the receiver's base creation style.
	N.B. This may not be the receiver's current window style."

	^creationStyle at: 1!

baseStyle: anInteger
	"Private - Set the receiver's base creation style.
	N.B. This does not affect the windows current style (see baseStyle:etc)"

	^creationStyle at: 1 put: anInteger!

baseStyle: anInteger maskedBy: aMaskInteger 
	"Private - Copies the bits in anInteger masked by aMaskInteger to the base style of the
	receiver. This message can be used to both clear and set style bits at the same time (useful
	where some are mutually exclusive). The bits specified only in aMaskInteger are cleared,
	while those in anInteger AND aMaskInteger are set. Answer whether the style was actually
	changed."

	"N.B. Most Windows controls are not capable of accepting dynamic style
	changes so if the style is changed and the receiver is open then the 
	window will be re-created to apply the new style"

	^self 
		baseStyle: anInteger
		maskedBy: aMaskInteger
		recreateIfChanged: true!

baseStyle: styleBitsToAdd maskedBy: styleBitMask recreateIfChanged: aBoolean 
	"Private - Copies the bits in styleBitsToAdd masked by styleBitMask to the base style
	of the receiver. Any bits set in styleBitMask which are not set in styleBitsToAdd
	will also be reset. If the style was changed, and the window is open, then it is
	either recreated, or the style long is set, depending on aBoolean."

	| baseStyle newBaseStyle |
	baseStyle := self baseStyle.
	newBaseStyle := baseStyle maskClear: styleBitMask.
	newBaseStyle := newBaseStyle maskSet: (styleBitsToAdd bitAnd: styleBitMask).
	newBaseStyle = baseStyle ifTrue: [^false].
	aBoolean 
		ifTrue: [self recreateAround: [self baseStyle: newBaseStyle]]
		ifFalse: 
			[| winStyle newWinStyle |
			self baseStyle: newBaseStyle.
			self isOpen 
				ifTrue: 
					[winStyle := self getWindowStyle.
					newWinStyle := winStyle maskClear: styleBitMask.
					newWinStyle := newWinStyle maskSet: (styleBitsToAdd bitAnd: styleBitMask).
					self setWindowStyle: newWinStyle]].
	^true!

baseStyleAllMask: anInteger
	"Private - Answers true if the base creation style bits contains all the bits in anInteger"

	^(creationStyle at: 1) allMask: anInteger!

baseStyleMask: anInteger set: aBoolean 
	"Private - Sets/clears the base creation style bits in anInteger according to aBoolean.
	Answer whether the style was actually changed."

	"N.B. Most Windows controls are not capable of accepting dynamic style changes so if the
	style is changed and the receiver is open then the window will be re-created to apply the
	new style"

	^self 
		baseStyleMask: anInteger
		set: aBoolean
		recreateIfChanged: true!

baseStyleMask: anInteger set: aBoolean recreateIfChanged: recreateIfChanged 
	"Private - Sets/clears the base creation style bits in anInteger according to aBoolean. If
	the style is changed and the receiver is open then the window will be recreated to apply the
	new style. If the style was changed then recreate the view if recreateIfChanged is true.
	Answer whether the style was actually changed."

	^self 
		baseStyle: (aBoolean ifTrue: [anInteger] ifFalse: [0])
		maskedBy: anInteger
		recreateIfChanged: recreateIfChanged!

basicActualBackcolor
	"Private - Answer the <Color> to be applied as the receiver's background colour. This might
	be 'Color default' indicating that the receiver is configured to use its default background
	colour, which might vary by view class. If no background colour is configured in the
	receiver, then it is inherited from the parent view. The inherited colour could be 'Color
	none' if the parent is transparent, but not 'normally Color default' since the parent will
	answers its own default colour if it is so configured. The exception is the desktop view,
	which will answer 'Color default' to instruct top-level views to draw in their own default
	colour."

	^self backcolor ifNil: [self parentView ambientBackcolor]!

basicAddSubView: aView
	"Private - Adds aView as a subview of the receiver. Should normally only be called before
	aView is realized due to a Windows bug where setParent: does not work reliably. The act of
	adding the view realizes it. No notification is generated that this view has been added,"

	aView
		parentView: self;
		show.	"Forces creation"
	^aView!

basicCreateAt: position extent: extentPoint
	"Private - Create the Win32 window for the receiver, and answer its handle.
	N.B. The window may not be properly subclassed - use #createAt:extent: instead."

	| dwStyle |
	dwStyle := self baseCreationStyle.
	^UserLibrary default
		createWindowEx: self extendedStyle
		lpClassName: self class winClassName asUtf16String
		lpWindowName: self windowName
		dwStyle: dwStyle
		x: position x
		y: position y
		nWidth: extentPoint x
		nHeight: extentPoint y
		hWndParent: self creationParentView asParameter
		hMenu: ((dwStyle anyMask: WS_CHILD) ifTrue: [self defaultId])
		hInstance: VMLibrary default applicationHandle
		lpParam: nil!

basicDestroy
	"Private - As #destroy, but must not be overridden."

	^UserLibrary default destroyWindow: handle!

basicInvalidateLayout
	"Private - Invalidates the layout of the receiver (only) indicating that the geometry
	needs to be recalculated. Use #invalidateLayout to fully invalidate the parent chain
	of views."

	flags := flags bitAnd: ##(LayoutValidMask bitInvert)!

basicPaint: message wParam: wParam lParam: lParam
	"Private - This window requires painting and this is to be performed in the
	#onPaintRequired: handler. Generally speaking subclasses should override #onPaintRequired:
	to implement specialized painting. Note that the return value from #onPaintRequired: is
	ignored."

	| user ps |
	ps := PAINTSTRUCT new.
	user := UserLibrary default.
	(user
		getUpdateRect: handle
		lpRect: nil
		bErase: false)
			ifTrue: 
				[| hdc |
				(hdc := user beginPaint: handle lpPaint: ps) isNil
					ifFalse: 
						["Rather than use #ifCurtailed: we use an Error handler so can validate and
						 prevent recursive walkback"
						
						[self onPaintRequired: (PaintEvent
									window: self
									wParam: wParam
									hdc: hdc
									paintStruct: ps)]
								on: Error
								do: 
									[:e |
									user endPaint: handle lpPaint: ps.
									e pass]].
				user endPaint: handle lpPaint: ps]
			ifFalse: 
				[| canv |
				"No update region, therefore assume an internal paint. We mustn't call
				 Begin/End paint - see Win32 docs on WM_PAINT."
				canv := self canvas.
				self onPaintRequired: (PaintEvent
							window: self
							wParam: wParam
							hdc: canv asParameter
							paintStruct: ps).
				canv free].
	^0	"We've handled it"!

beActive
	"Make the receiver the active window."

	^UserLibrary default setActiveWindow: handle!

beCentered
	"Position the receiver in the centre of its parent view."

	| centre newPos |
	centre := self parentView clientRectangle center.
	newPos := centre - (self extent // 2).
	self position: newPos!

beDefaultThemed
	"Restores the default visual theme for the receiver. Only effective on Windows XP and above"

	SystemMetrics current hasThemes
		ifTrue: 
			[ThemeLibrary default
				setWindowTheme: self handle
				pszSubAppName: self themeSubAppName
				pszSubIdList: nil.
			self openTheme]!

beForeground
	"Make the receiver the foreground window."

	^UserLibrary default setForegroundWindow: handle!

beNotThemed
	"Turns off any visual theme for the receiver. Only effective on Windows XP and above"

	SystemMetrics current hasThemes
		ifTrue: 
			[self freeTheme.
			ThemeLibrary default
				setWindowTheme: self handle
				pszSubAppName: Utf16String empty
				pszSubIdList: Utf16String empty]!

beNotTopMost
	"Places the receiver above all non-topmost windows (that is, behind all topmost windows).
	This has no effect if the window is already a non-topmost window.
	Answers whether the operation was successful."

	^self zOrderAfter: HWND_NOTOPMOST!

bePopupFor: aView 
	"Sets the receiver to be a popup window owned by the <View> argument."

	creationParent := aView.
	self isPopup: true!

beTopMost
	"Places the receiver above all non-topmost windows without activating it.
	The window maintains its topmost position even when it is deactivated.
	Answers whether the operation was successful."

	^self zOrderAfter: HWND_TOPMOST!

binaryStoreOn: aStream
	"Stores the receiver in a binary form on aStream that can be reconstituted using Object class>>binaryReadFrom:.
	We must arrange to snip this view from any parent hierarchy before the save"

	| filer viewProxy |
	viewProxy := self whileInvisibleDo: 
					[self filerProxy
						beTopView;
						yourself].
	filer := STBOutFiler on: aStream.
	filer
		override: self with: viewProxy;
		nextPut: self!

bmSetStyle: message wParam: wParam lParam: lParam
	"Private - Handler for BM_SETSTYLE message.
	Implementation Note: This message is only received by Buttons, but we implement here in case
	we have a generic View referencing a button. Obviously we just accept the default processing."

	^nil!

calcClientRectangleFromRectangle: aRectangle 
	"Private - Given a window rectangle represented by the <Rectangle> argument, answer the
	client area that this would provide, taking into account the current window styles etc. This
	method is fed by the calculation from #calcRectangleFromClientRectangle: and should not
	normally have to be overridden in subclasses."

	| inflated |
	inflated := self calcRectangleFromClientRectangle: aRectangle.
	^0 @ 0 extent: aRectangle extent * ##(2@2) - inflated extent!

calcExtentFromClientExtent: aPoint
	"Private - Given a client extent represented by the <Point> argument, answer the external
	view extent that would be required to achieve this taking into account the current window
	styles etc."

	^(self calcRectangleFromClientRectangle: (RECTL extent: aPoint)) extent!

calcRectangleFromClientRectangle: aRectangle
	"Private - Given a client rectangle represented by the <Rectangle> argument, answer the
	window rectangle that would be required to achieve this taking into account the current
	window styles etc Note that the answered rectangle is in the COORDINATE SYSTEM OF THE
	CLIENT.

	This method should be overridden by subclasses that wish to supply an NC rectangle different
	from the default."

	| rect |
	rect := RECTL fromRectangle: aRectangle.
	UserLibrary default
		adjustWindowRectEx: rect
		dwStyle: self baseStyle
		bMenu: self hasMenu
		dwExStyle: self extendedStyle.
	^rect asRectangle!

calculateExtent
	"N.B. You should override #calculateExtent:"

	^self calculateExtent: (LayoutContext forContainer: self)!

calculateExtent: aLayoutContext 
	"Private - Answer the desired window extent (for the receiver within the specified
	<LayoutContext>. By default the current extent recorded in the context (which might be a
	suggestion or the existing extent) is retained. Subclasses can reimplement it to answer an
	fixed preferred extent, or one calculated to fit the current contents of a view (for
	example)."

	"N.B. This should be the complete extent for the Window, including non-client adornments
	such as borders, etc."

	^aLayoutContext extentOf: self!

canAcceptSubViews
	"Answer true if the receiver can accept sub views"

	^false!

canvas
	"Answer a client canvas for this View"

	^Canvas forView: self!

centerExtent: aPoint within: aParentView
	"Private - Answer the position to give a view of extent aPoint in order to center it within aParentView."

	^(aParentView extent - aPoint) // 2

!

clearHandle
	self handle: nil!

clearStateRestoring
	flags := flags bitAnd: ##(StateRestoringMask bitInvert)!

clientExtent
	"Answer a <Point> representing the extent of the receiver's client area."

	^self clientRectangle extent!

clientHeight
	"Answer the height of the receiver's client area."

	^self clientExtent y!

clientRectangle
	"Answer a Rectangle containing the bounding rectangle of the receiver's client area."

	| rect |
	rect := RECTL new.
	UserLibrary default getClientRect: handle lpRect: rect.
	^rect asRectangle!

clientWidth
	"Answer the width of the receiver's client area."

	^self clientExtent x!

clipChildren
	"Answer whether the receiver will exclude the areas occuppied by its sub views from its
	repaints so that it cannot overpaint them. It can be worth setting this style if
	experiencing repaint problems where a child view repaints but is then immediately erased, a
	situation that arises in certain circumstances when embedding Active-X controls."

	"Note that there is a complex interaction with transparency and WS_CLIPCHILDREN. A container
	of transparent children that has this style set will not draw the background for the
	transparent children. We usually leave this style turned off in Dolphin, but it is sometimes
	necessary for views that do any drawing outside of WM_PAINT and which may host children."

	^self baseStyleAllMask: WS_CLIPCHILDREN!

clipChildren: aBoolean 
	"Set whether the receiver will exclude the areas occuppied by its sub views from its
	repaints so that it cannot overpaint them."

	self 
		baseStyleMask: WS_CLIPCHILDREN
		set: aBoolean
		recreateIfChanged: false!

close
	"Asks the receiver to close itself, answering whether does actually close."

	^self destroy; isOpen not.!

command: anInteger id: id
	"Private - Default handler for redirected WM_COMMAND messages.
	 The control-specific notification code is in anInteger."

	^nil!

commandPolicy
	"Answers a <CommandPolicy> object for routing commands originating from the receiver.
	This can be overridden by subclasses which wish to use a different routing policy."

	| policy |
	policy := (self topShell commandPolicyWithSource: self presenter commandSource) 
				asValue.
	self topShell trigger: #requestCommandPolicy: with: policy.
	^policy value!

commandSource
	"Answer the <View> starting point for command routing if a UI command
	is received by the receiver. Can be overridden by subclasses that wish to indicate
	that their commands should be considered as originating elsewhere. The
	commandSource is typically at the head of the command route and therefore
	gets first refusal."

	^self
!

connectModel
	"Connect the receiver to its model, wiring events, etc.
	This method should be overridden by subclasses. There is no need
	to supersend it, as it is provided only as a hook."!

contextMenu
	"Answer a context menu to use for the receiver
	If none then answer nil to indicate no context menu"

	^contextMenu
!

contextMenu: aMenuOrNil
	"Set a per instance context menu to use for the receiver"

	contextMenu := aMenuOrNil
!

create
	"Private - Creates a window with
		creationParent (or the desktop if nil),
		creationStyle,
		default position,
		default size."

	creationParent isNil ifTrue: [self parentView: self class desktop].
	^self
		createAt: (self defaultPositionWithin: creationParent forExtent: self defaultExtent)
		extent: self defaultExtent!

createAt: position extent: extentPoint
	"Private - Create the View window ensuring it has the VM window procedure.
	Answer the receiver."

	self hookWindowCreate.
	self unhookWindowCreate: (self basicCreateAt: position extent: extentPoint).
	self presenter onViewCreated!

creationParentView
	"Private - Answer the View where the receiver must be created"

	^creationParent!

cursor
	"Answers the cursor to be used while over the client area of the receiver. Subclasses
	can override this to provide instance specific cursors."

	^self class cursor
!

cursorPosition
	"Answer the position of the cursor in the receiver's co-ordinate system."

	^self class desktop mapPoint: Cursor position to: self!

ddCut: session
	"Private - The <DragDropSession>, session, has just completed a successful move operation.
	The dragged object(s) now need to be cut from the drag source. We forward this on to the
	higher level protocol, going first to the Presenter, which will usually reflect back here, 
	and the receiver will then usually trigger an event which is typically observed by higher
	level presenters."

	self presenter dragCut: session!

ddDrop: session
	"Private - The drag operation described by the <DragDropSession>, session,
	would like to do a drop over the receiver.  Answer whether or not the drop
	was accepted.
	Implementation Note: We forward this on to the higher level protocol, going first 
	to the Presenter, which will usually reflect back here, and the receiver will then 
	usually trigger an event which is typically observed by higher level presenters."

	^self presenter drop: session!

ddEnter: session
	"Private - The drag operation described by the <DragDropSession>, session,
	has entered the receiver's window.  We forward this on to the
	higher level protocol, going first to the Presenter, which will usually reflect back here, 
	and the receiver will then usually trigger an event which is typically observed by higher
	level presenters."

	self presenter dragEnter: session!

ddGetImages: session
	"Private - The <DragDropSession>, session, has been initiated from the receiver and 
	this is our opportunity to supply custom drag images.  We forward this on to the
	higher level protocol, going first to the Presenter, which will usually reflect back here, 
	and the receiver will then usually trigger an event which is typically observed by higher
	level presenters."

	self presenter requestDragImages: session!

ddGetObjects: session
	"Private - The <DragDropSession>, session, has been initiated from the receiver and a 
	collection of the objects to be dragged is required. We forward this on to the
	higher level protocol, going first to the Presenter, which will usually reflect back here, 
	and the receiver will then usually trigger an event which is typically observed by higher
	level presenters."

	self presenter requestDragObjects: session!

ddLeave: session
	"Private - The drag operation described by the <DragDropSession>, session,
	has left the receiver's window.  We forward this on to the
	higher level protocol, going first to the Presenter, which will usually reflect back here, 
	and the receiver will then usually trigger an event which is typically observed by higher
	level presenters."

	self presenter dragLeave: session!

ddOperations: session
	"Private - The drag operation described by the <DragDropSession>, session,
	wishes to perform an extended (right button) drop, and needs to know what
	operations are available for the pop-up menu. We forward this on to the
	higher level protocol, going first to the Presenter, which will usually reflect back here, 
	and the receiver will then usually trigger an event which is typically observed by higher
	level presenters."

	self presenter requestDropOperations: session!

ddOver: aDragDropSession
	"Private - The drag operation described by the <DragDropSession> argument 
	has moved to a new position over the receiver's window. We do a little hit test
	calculation to determine whether the new drag position is over the receiver's scroll
	regions before forwarding the notification on to the higher level protocol, going first 
	to the Presenter, which will usually reflect back here,  and the receiver will then 
	usually trigger an event which is typically observed by higher level presenters."

	"First test to see if we're in the drop scroll zone. Inform the session
	which will then send us #dropScroll: messages as appropriate"

	| pt rect |
	pt := aDragDropSession dragPointInView: self.
	rect := self clientRectangle insetBy: aDragDropSession defaultScrollInset.
	aDragDropSession isInDropTargetScrollZone: (rect containsPoint: pt) not.

	"Now just ask the presenter to perform any drop highlighting"
	self presenter dragOver: aDragDropSession!

ddScroll: session 
	"Private - The drag operation described by the <DragDropSession>, session,
	is over the scroll region of the receiver's window.  We respond by scrolling the
	the receiver's window using standard scroll messages. Note that this message
	has no equivalent in the higher level 'drop target' protocol."

	| pt rect horz vert |
	pt := session dragPointInView: self.
	rect := self clientRectangle insetBy: session defaultScrollInset.
	pt x < rect left ifTrue: [horz := SB_LINEUP].
	pt x >= rect right ifTrue: [horz := SB_LINEDOWN].
	pt y < rect top ifTrue: [vert := SB_LINEUP].
	pt y >= rect bottom ifTrue: [vert := SB_LINEDOWN].
	session hideCursorWhile: 
			[horz notNil ifTrue: [self sendMessage: WM_HSCROLL wParam: horz].
			vert notNil ifTrue: [self sendMessage: WM_VSCROLL wParam: vert]]!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^Color window!

defaultExtent
	"Private - Answer the default size of the receiver. This is used only to
	set the size of a view when it is created. Thereafter preferredExtent is
	used when the desired size of a view is requested."

	^100 @ 100!

defaultId
	"Private - Answer the id to be used when the receiver is created 
	as a child window (top-level windows do not have ids).
	Implementation Note: Allocate an id from the sequentially increasing
	counter (reset on image startup)."

	^self class defaultId!

defaultPositionWithin: aParentView forExtent: aPoint
	"Private - Answer the default position of the receiver within aParentView given its intended extent aPoint.
	This is used only on creation."

	^Point.Zero!

defaultProportion
	"Private - Answer the default proportion to be assumed by the receiver when associated with
	a container with a <ProportionalLayout>."

	^1!

defaultShowStyle
	^SW_SHOW!

defaultStyle
	"Private - Answer the default window creation style as a two element Array
	The first element contains the standard Windows style bits, the second contains
	the extended style bits."

	^{self defaultWindowStyle. self defaultWindowExStyle}!

defaultWindowExStyle
	"Private - Answer the default extended window creation style"

	^0!

defaultWindowProcessing: message wParam: wParam lParam: lParam
	"Private - Pass an event to the 'default' window procedure of the receiver.
	Overridden by subclasses which need to pass the message to a previous 
	window procedure (e.g. see ControlView).
	This method should be called by subclasses when they need to perform default	
	window processing before some of their own processing in response to a message
	The normal option is to return a value which cannot be converted to an LRESULT
	(usually nil) so that the VM's window procedure does the job for us, but this
	method can be used where more flexibility in ordering is required."

	^UserLibrary default
		defWindowProc: handle
		msg: message
		wParam: wParam
		lParam: lParam!

defaultWindowStyle
	"Private - Answer the default basic window creation style.
	If the view is later given a parent then WS_CHILD will be set.
	Implementation Note: We use WS_CLIPSIBLINGS because we dynamically
	move windows around, and this prevents any possibility of overpainting.
	Note that it has no effect on non-child windows which have this style
	foisted upon them."

	^WS_CLIPSIBLINGS!

deferLayout: aMonadicValuable
	"Private - Evaluate the <monadicValuable> argument, passing it a <LayoutContext> for performing window
	layout operations. On completion, apply any changes recorded in the layout context."

	| context |
	context := LayoutContext forContainer: self.
	^[aMonadicValuable value: context] ensure: [context apply]!

destroy
	"Force the receiver closed. N.B. The receiver will receive WM_DESTROY
	and WM_NCDESTROY messages, but not a WM_CLOSE (Default window processing
	for WM_CLOSE is to call DestroyWindow)."

	^self basicDestroy!

disable
	"Disable the receiver from receiving input events."

	self isEnabled: false!

disableRedraw
	"Disable repaints of the receiver's associated window."

	| noRedrawCount |
	noRedrawCount := self getNoRedrawCount.
	noRedrawCount = 0 ifTrue: [self setRedraw: false].
	self setNoRedrawCount: noRedrawCount + 1!

disconnectFromModel
	"Private - Remove all event registrations lodged with the current model."

	model notNil ifTrue: [model removeEventsTriggeredFor: self]!

dispatchMessage: message wParam: wParam lParam: lParam 
	"Private - Dispatch a message to the first level View message handler, if one
	exists, answering its result. If the message is not handled in
	Smalltalk ask for the default window procedure to be invoked.
	Answer an LRESULT value which is either the result answered by the Dolphin
	handler, or, if that does not yield an LRESULT, the answer from the 'superclass'
	window procedure (e.g. the default window procedure)."

	| answer |
	answer := (message < WM_USER 
				ifTrue: 
					["It's a system message."
					(MessageMap at: message + 1) 
						ifNotNil: 
							[:selector | 
							self 
								perform: selector
								with: message
								with: wParam
								with: lParam]]
				ifFalse: 
					[message <= WM_USER_LAST 
						ifTrue: 
							["It's a user message."
							self 
								dispatchUser: message - WM_USER
								wParam: wParam
								lParam: lParam]
						ifFalse: 
							["It's a registered message."
							self 
								dispatchRegistered: message
								wParam: wParam
								lParam: lParam]]) 
					asUIntPtr.

	"We MUST answer an integer value. If one was not provided, then assume default
	window processing is required."
	^answer isInteger 
		ifTrue: [answer]
		ifFalse: 
			[self 
				defaultWindowProcessing: message
				wParam: wParam
				lParam: lParam]!

dispatchRegistered: registeredId wParam: wParam lParam: lParam
	"Private - Dispatch the registered message which was sent to the receiver.
	To be overridden by subclasses which implement registered messages in an appropriate 
	manner (e.g. by a secondary message map, or, if few in number, by conditional tests)"

	^nil		"accept default processing"!

dispatchUser: userId wParam: wParam lParam: lParam
	"Private - Dispatch the WM_USER+userId message which was sent to the receiver.
	To be overridden by subclasses which implement WM_USER+N messages in an appropriate 
	manner (e.g. by a secondary message map, or, if few in number, by conditional tests)"

	"Note: A nasty to watch out for here is that dialogs use values in the WM_USER 
	for standard system messages (e.g. DM_GETDEFID = WM_USER+0).	Therefore, it 
	is a good idea to base off WM_USER by, for example, 100, to avoid conflicts
	(especially in ShellViews)."

	^nil 	"accept default processing"!

dispatchUser: userId wParam: wParam lParam: lParam map: aLookupTable
	"Private - Dispatch the WM_USER+userId message, aWinMSG, which was sent to the receiver, via
	the message map, aLookupTable (which maps userIds to selectors). A helper
	function for subclasses implementing #dispatchUser:wParam:lParam:."

	^(aLookupTable lookup: userId)
		ifNotNil: 
			[:selector |
			self
				perform: selector
				with: WM_USER + userId
				with: wParam
				with: lParam]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	| description |
	self displayOnFormats detect: 
			[:each |
			description := String streamContents: [:strm | (self perform: each) displayOn: strm].
			description notNil and: [description notEmpty]].
	description size > self displayOnMaxCharacters
		ifTrue: [description := (description leftString: self displayOnMaxCharacters) , '...'].
	aPuttableStream nextPutAll: description!

displayOnFormats
	"Private - Answers an array of selectors that can be used to determine how the receiver is
	represented as a textual display string by #displayOn:. These selectors are sent in turn
	until one yields a non-nil, non-empty string as a result. Can be overridden by subclasses to 
	change the way a view formats itself as text"

	^#(name text class)!

displayOnMaxCharacters
	"Private - Answers the maximum number of characters to display with #displayOn:"

	^24!

dragCut: session
	"The <DragDropSession>, session, has just completed a successful move operation.
	The dragged object(s) now need to be cut from the drag source. Generally speaking
	only high-level Presenters know how to do this, so we fire off a trigger in the hope
	that one might be listening."

	self presenter trigger: #dragCut: with: session!

dragDropSessionClass
	^InternalDragDropSession!

dragEnter: aDragDropSession
	"The drag operation described by the <DragDropSession> argument has entered 
	the receiver's window. Use the session to provide feedback to the user about 
	allowable operations etc."

	self presenter trigger: #dragEnter: with: aDragDropSession!

dragLeave: aDragDropSession
	"The drag operation described by the <DragDropSession> argument
	has left the receiver's window."

	self presenter trigger: #dragLeave: with: aDragDropSession!

dragOver: aDragDropSession
	"The drag operation described by the <DragDropSession> argument
	 has moved to a new position over the receiver's window.
	Fire a trigger off the presenter to give high level observers a chance
	to specify the operation and drop target."

	self presenter trigger: #dragOver: with: aDragDropSession!

drawFocusRect: rectangle
	"Draw a focus rectangle defined by rectangle (which can be a RECTL or a Rectangle)."

	| hdc |
	hdc := self getDC.
	UserLibrary default drawFocusRect: hdc lprc: rectangle asParameter.
	self releaseDC: hdc!

drop: aDragDropSession
	"The drag operation described by the <DragDropSession> argument has 
	culminated in a drop over the receiver. Answer whether the drop was successfull
	so that the Session knows whether to cut the item from the drag source in the case 
	of a #move operation.
	Implementation Note: Fire a trigger to permit observers to participate and possibly
	implement the drop. Observers are expected to set the operation to nil on failure
	or if they do not want the 'cut from drag source' part of a move operation to be 
	performed."

	self presenter trigger: #drop: with: aDragDropSession.
	^aDragDropSession operation notNil!

enable
	"Enable the receiver to receive input events."

	self isEnabled: true!

enableRedraw
	"Enable repaints of the receiver's associated Window."

	| noRedrawCount |
	noRedrawCount := self getNoRedrawCount - 1.
	self setNoRedrawCount: noRedrawCount.
	noRedrawCount <= 0 
		ifTrue: 
			[self setRedraw: true.
			self invalidate]!

ensureLayoutValid
	"If the receiver's layout is invalid, then recurse up the tree to ensure the validity of the
	parent chain. If the parent did not itself require layout validation, then validate the
	layout from this point. Answer whether any layout was performed."

	| parent |
	self isLayoutValid ifTrue: [^false].
	parent := self parentView.
	(parent notNil and: [parent ensureLayoutValid]) ifFalse: [self validateLayout].
	^true!

ensureRectangleVisible: aRectangle
	"Ensures that the area of the receiver identified by the <Rectangle>, area,
	(specified in the view's own co-ordinates) is visible in it's parent, assuming
	that the parent has that level of control."

	self parentView ensureSubView: self rectangleVisible: aRectangle!

ensureSubView: aView rectangleVisible: aRectangle
	"Private - Ensures that the aRectangle area of the aView is visible in
	the receiver if the parent has this level of control.
	Should be overridden by subclasses which, for example, can scroll the
	specified region into view ."

	self parentView
		ensureSubView: self 
		rectangleVisible: (aView mapRectangle: aRectangle to: self)!

ensureSubViewVisible: aSubView
	"Ensures that aSubView is visible in the receiver. Overidden by sub views
	that have this level of control"

	self ensureVisible



	!

ensureVisible
	"Ensures that the receiver is visible in it's parent if the parent has this level of control.
	Note that this is not expected to bring the containing shell window to the top of the z-order."

	self parentView ensureSubViewVisible: self

	!

enterIdle
	"Private - Notification from <InputState> that the system is going idle. This is an
	appropriate point to update the state of visual user interface elements such as toolbar
	buttons."

	self presenter onIdleEntered.
	^true!

eraseParentBackground: aCanvas 
	| lResult canvas parent org |
	parent := self parentView.
	org := self mapPoint: 0 @ 0 to: parent.
	canvas := aCanvas.
	org := canvas offsetWindowOrigin: org.
	lResult := parent 
				sendMessage: WM_ERASEBKGND
				wParam: aCanvas asParameter
				lParam: 0.
	canvas windowOrigin: org.
	^lResult!

exStyle: exStyleBitsToSet maskedBy: exStyleBitMask 
	"Private - Copies the bits in anInteger masked by exStyleBitMask to the extended style of
	the receiver. Answer whether the extended style was actually changed."

	"N.B. Most Windows controls are not capable of accepting dynamic style changes so if the
	style is changed and the receiver is open then the window will be re-created to apply the
	new style."

	^self 
		exStyle: exStyleBitsToSet
		maskedBy: exStyleBitMask
		recreateIfChanged: true!

exStyle: styleBitsInteger maskedBy: styleMaskInteger recreateIfChanged: aBoolean
	"Private - Copies the bits in anInteger masked by exStyleBitMask to the extended style of
	the receiver. If the style is changed then either SetWindowLong is called to set the
	extended style, or the window is recreated, depending on the boolean argument. Answer
	whether the extended style was actually changed."

	| exStyle newExStyle |
	exStyle := self extendedStyle.
	newExStyle := exStyle maskClear: styleMaskInteger.
	newExStyle := newExStyle maskSet: (styleBitsInteger bitAnd: styleMaskInteger).
	newExStyle = exStyle ifTrue: [^false].
	{self baseStyle. newExStyle}.
	aBoolean
		ifTrue: [self recreateAround: [self extendedStyle: newExStyle]]
		ifFalse: 
			[self extendedStyle: newExStyle.
			self isOpen ifTrue: [self setWindowExStyle: newExStyle]].
	^true!

exStyleAllMask: anInteger
	"Private - Answers true if the extended creation style bits contains all the bits in anInteger"

	^self extendedStyle allMask: anInteger.
!

exStyleMask: exStyleBitsMask set: aBoolean 
	"Private - Sets/clears the extended creation style bits in exStyleBitsMask according to
	aBoolean. Answer whether the style was actually changed."

	"N.B. Most Windows controls are not capable of accepting dynamic style changes so if the
	style is changed and the receiver is open then the window will be re-created to apply the
	new style"

	^self 
		exStyleMask: exStyleBitsMask
		set: aBoolean
		recreateIfChanged: true!

exStyleMask: exStyleBitMask set: setBoolean recreateIfChanged: recreateBoolean 
	"Private - Sets/clears the extended creation style bits in exStyleBitMask according to
	setBoolean. If the style is changed and recreateBoolean is true, then request that the
	window be recreated. Answer whether the style was actually changed."

	^self 
		exStyle: (setBoolean ifTrue: [exStyleBitMask] ifFalse: [0])
		maskedBy: exStyleBitMask
		recreateIfChanged: recreateBoolean!

extendedStyle
	"Private - Answer the receiver's extended creation style.
	N.B. This may not be the receiver's current extended window style."

	^creationStyle at: 2!

extendedStyle: anInteger
	"Private - Set the receiver's extended creation style.
	N.B. This does not affect the style of windows which have already been created
	(see exStyle:etc..)."

	^creationStyle at: 2 put: anInteger!

extent
	"Answer the dimensions of the receiver's outer (non-client) window."

	^self getWindowRect extent
!

extent: aPoint 
	"Set the dimensions of the receiver's outer window to aPoint."

	aPoint = self extent ifFalse: [self setExtent: aPoint]!

filerProxy
	"Private - Answer a filer proxy that represents the receiver."

	| filerProxy |
	filerProxy := STBViewProxy forView: self.
	self isTopView ifTrue: [filerProxy beTopView].
	^filerProxy!

findItemHandle: anInteger ifAbsent: exceptionHandler 
	"Private - Answer the handle of a child window within the receiver with the specified
	<integer> id, or if no such immediate child, then the first child of a child with
	encountered with that id, and so on. i.e. this is a recursive version of
	#getItemHandle:ifAbsent: If there is no such child in the receiver, or its children, etc,
	then answer the result of evaluating the niladic valuable, exceptionHandler."

	(self getItemHandle: anInteger ifAbsent: []) 
		ifNil: 
			[self subViewsDo: 
					[:each | 
					| hWnd |
					hWnd := each findItemHandle: anInteger ifAbsent: [].
					hWnd isNil ifFalse: [^hWnd]]]
		ifNotNil: [:hWnd | ^hWnd].
	^exceptionHandler value!

findMatch: aFindDetails inRange: anInterval
	"Private - Find the first occurrence of text in the receiver that matches the specified
	<FindDetails>, within the range, anInterval. Answer the <Interval> of the match (an
	empty interval if not found)."

	| text matchString matchLen start stop textLen |
	textLen := self textLength.
	aFindDetails isForwards
		ifTrue: 
			[text := self plainText.
			matchString := aFindDetails pattern.
			start := anInterval start.
			stop := anInterval stop]
		ifFalse: 
			[text := self plainText reverse.
			matchString := aFindDetails pattern reverse.
			start := textLen - anInterval stop + 1.
			stop := textLen - anInterval start + 1].
	aFindDetails isCaseSensitive
		ifFalse: 
			[text := text asLowercase.
			matchString := matchString asLowercase].
	matchLen := matchString size.
	start to: stop - matchLen + 1
		do: 
			[:pos |
			matchString = (text midString: matchLen from: pos)
				ifTrue: 
					["Possible match - check for whole word if necessary."
					(aFindDetails isWholeWord not or: 
							[aFindDetails isWholeWord and: 
									[(pos > 1 and: [(text at: pos - 1) isAlphaNumeric not])
										and: [pos + matchLen < textLen and: [(text at: pos + matchLen) isAlphaNumeric not]]]])
						ifTrue: 
							[| first |
							first := aFindDetails isForwards ifTrue: [pos] ifFalse: [textLen - pos + 1 - matchLen + 1].
							^first to: first + matchLen - 1]]].
	^0 to: -1!

firstSubView
	"Answers the first sub view of the receiver or nil if there is none"

	| child |
	child := self getFirstChild.
	child isNil ifTrue: [^nil].
	^self class withHandle: child
!

flash: anInteger
	"Flash the receiver in a manner so as to attract the user's attention, anInteger times."

	| canvas rect |
	canvas := self canvas.
	rect := self clientRectangle.
	(1 to: anInteger * 2) do: [:i | canvas invertRectangle: rect]
		separatedBy: [Processor sleep: 65 milliseconds].
	canvas free!

font
	"Answer the current font aspect. "

	^font
!

font: aFontOrNil
	"Set a new font into the receiver. Setting nil implies that the font
	should be inherited from the parent"

	font := aFontOrNil.
	self isOpen ifTrue: [ self fontChanged ].
!

fontChanged
	"Private - The receiver's font has been changed. The default is to cause the receiver ot repaint. Should be overidden by subclasses that need to apply the  font to a Windows control"

	self
		invalidate;
		invalidateCalculatedExtent!

forecolor
	"Answers the foreground colour of the receiver.
	Overidden by subclasses that support foreground colours"

	^Color windowText
!

forecolor: aColorOrNil
	"Sets the foreground colour of the receiver to aColorOrNil.
	Overidden by subclasses that support foreground colours"
!

forecolorChanged
	"Private - The receiver's foreground color has been changed. The default is to cause
	the receiver to repaint"

	self subViewsDo: [:each | each forecolorChanged ].
	self invalidate
!

frameChanged
	"Private - Ask Windows to apply recent frame style changes set with SetWindowLong."

	self 
		setWindowPosAfter: nil
		x: 0
		y: 0
		width: 0
		height: 0
		flags: ##(SWP_FRAMECHANGED | SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER)!

frameWidths
	"Answer the widths of the frames (if any) configured for the receiver."

	^self class frameWidths: self baseStyle!

freeTheme
	"Private - Override point to free any theme related resources. Additional action is not generally required but may be needed if the instance:
		- holds theme handles or resource
		- caches theme metrics or colours that would be wrong if the Windows theme is changed by the user."
!

getDC
	"Answer a device context to enable drawing on the receiver."

	^UserLibrary default getDC: handle!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

getFileLocator
	"Private - Answer the file locator for the receiver. 
	For normal views this is the default <FileLocator>."

	^FileLocator default!

getFirstChild
	"Private - Answers the handle of the first child window of the receiver or nil if there is none"

	^self getWindow: GW_HWNDCHILD!

getItem: anInteger
	"Private - Answer the the receiver's sub view with the specified ID.
	Note: This method is not only useful for Dialogs, as it can be used any parent-child 
	pair, as long as the child window has a unique identifier (as specified by the hMenu parameter in 
	the CreateWindowEx() function that created the child window)."

	^self getItem: anInteger ifAbsent: [Win32Error signal]!

getItem: anInteger ifAbsent: exceptionHandler
	"Private - Answer the the receiver's sub view with the specified ID, or if there is no such child,
	then answer the result of evaluating the niladic valuable, exceptionHandler.
	Note: This method is not only useful for Dialogs, as it can be used any parent-child 
	pair, as long as the child window has a unique identifier (as specified by the hMenu parameter in 
	the CreateWindowEx() function that created the child window). By default Dolphin allocates all
	child windows unique id's.

	N.B. We deliberately reference View specifically rather than 'self' because
	if the item is not a registered Dolphin View then we want a generic
	instance of View to represent it, not an instance of whatever subclass
	sent the message."

	^View fromHandle: (self getItemHandle: anInteger ifAbsent: [^exceptionHandler value])!

getItemHandle: anInteger ifAbsent: exceptionHandler
	"Private - Answer the handle of the receiver's sub view with the specified ID, 
	or if there is no such child, then answer the result of evaluating the niladic 
	valuable, exceptionHandler.
	Note: This method is not only useful for Dialogs, as it can be used any parent-child
	pair, as long as the child window has a unique identifier (as specified by the hMenu parameter in 
	the CreateWindowEx() function that created the child window). By default Dolphin allocates all
	child windows unique id's."

	| hwnd |
	hwnd := UserLibrary default getDlgItem: handle nIDDlgItem: anInteger.
	^hwnd ifNil: [exceptionHandler value]!

getNoRedrawCount
	^self propertyAt: #_noRedrawCount ifAbsent: [0]!

getParent
	"Private - Answers the handle of the parent (or owner) window."

	^UserLibrary default getParent: handle!

getPreviousSibling
	"Private - Answers the handle of the previous sibling window (in Zorder sequence)
	of the receiver or nil if there are no more siblings."

	^self getWindow: GW_HWNDPREV!

getScrollInfo: siStruct bar: bar
	"Private - Get the information about the receivers bar.
	Answer whether values were retrieved."

	^UserLibrary default
		getScrollInfo: handle
		fnBar: bar
		lpsi: siStruct!

getWindow: anInteger
	"Private - Answers the handle of the window with the specified relationship to the receiver."

	^UserLibrary default getWindow: handle uCmd: anInteger!

getWindowDC
	"Private - Answer a device context to enable drawing on the receiver's non client area."

	^UserLibrary default getWindowDC: handle!

getWindowExStyle
	"Private - Answer the extended window style of the receiver."

	^self getWindowLong: GWL_EXSTYLE
!

getWindowLong: anInteger
	"Private - Answer the unsigned intptr value at the specified offset in the receiver."

	^UserLibrary default getWindowLong: handle nIndex: anInteger!

getWindowLongPtr: anInteger
	"Private - Answer the unsigned intptr value at the specified offset in the receiver."

	^VMConstants.IsWin64
		ifTrue: [UserLibrary default getWindowLongPtr: handle nIndex: anInteger]
		ifFalse: [UserLibrary default getWindowLong: handle nIndex: anInteger]!

getWindowRect
	"Private - Answer a raw (unmapped) RECTL containing the bounding rectangle of the receiver's non-client window."

	| rect |
	rect := RECTL newBuffer.
	UserLibrary default getWindowRect: handle lpRect: rect.
	^rect!

getWindowStyle
	"Private - Answer the window style of the receiver."

	^self getWindowLong: GWL_STYLE
!

getWindowText
	"Private - Answers the text from the receiver"

	| textLen text |
	textLen := self textLength.
	text := Utf16String newFixed: textLen.
	UserLibrary default
		getWindowText: handle
		lpString: text
		nMaxCount: textLen + 1.
	"To avoid propagating Utf16Strings everywhere, convert to UTF-8"
	^text asUtf8String!

getWndProc
	"Private - Answer the window procedure of the receiver."

	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64
		ifTrue: [UserLibrary default getWindowULongPtr: handle nIndex: GWLP_WNDPROC]
		ifFalse: [UserLibrary default getWindowULong: handle nIndex: GWL_WNDPROC]!

handle
	"Private - Answer the receiver's handle (an instance of ExternalHandle or nil)."

	handle isNil ifTrue: [self create].
	^handle!

handle: aHandleOrNil
	"Private - Set the handle for the receiver. N.B. This is a simple
	accessor method; set the handle of a View with #attachHandle:"

	handle := aHandleOrNil!

hasBorder
	"Answer whether the receiver has a border (i.e. it has the WS_BORDER style)."

	^self baseStyleAllMask: WS_BORDER!

hasBorder: aBoolean 
	"Sets the receiver to be bordered or not depending on the value of aBoolean, i.e.
	sets/clears the WS_BORDER style."

	(self 
		baseStyleMask: WS_BORDER
		set: aBoolean
		recreateIfChanged: false) ifTrue: [self frameChanged]!

hasCapture
	"Answer true if the receiver has captured the mouse."

	^self == self class capture!

hasClientEdge
	"Answer whether the receiver has the client edge style (a bordering which gives the window a
	sunken 3D edge)."

	^self exStyleAllMask: WS_EX_CLIENTEDGE!

hasClientEdge: aBoolean 
	"Sets the receiver to have a sunken 3D border (Win95 edging style for controls intended to
	accept input) or not depending on the value of aBoolean. This is the WS_EX_CLIENTEDGE
	style."

	(self 
		exStyleMask: WS_EX_CLIENTEDGE
		set: aBoolean
		recreateIfChanged: false) ifTrue: [self frameChanged]!

hasFixedHeight
	"Answer whether this view is of a fixed height. This controls whether or not certain
	<LayoutManager>s will attempt to resize the receiver in the vertical plane. It is
	permissible for the response to vary dynamically, depending on the state of the view. By
	default all views are considered resizable in both dimensions."

	^false!

hasFixedWidth
	"Answer whether this view is of a fixed width. This controls whether or not certain
	<LayoutManager>s will attempt to resize the receiver in the horizontal plane. It is
	permissible for the response to vary dynamically, depending on the state of the view. By
	default all views are considered resizable in both dimensions."

	^false!

hasFocus
	"Answer true if the receiver has focus"

	^self == self class focus!

hasFocusDeeply
	"Answer whether the receiver or any of its children, or its children's children, and so on,
	has focus."

	"Implementation Note: Walk up the parent chain from the window with focus until we find
	either the receiver, or the desktop."

	| hwnd |
	hwnd := self class focusHandle.
	[hwnd ~= 0] whileTrue: 
			[handle = hwnd ifTrue: [^true].
			hwnd := UserLibrary default getParent: hwnd].
	^false!

hasLayoutManager
	"Answer whether the receiver has a layout manager."

	^self layoutManager notNil!

hasMenu
	"Private - Answer true if the receiver has a visible menu bar."

	^false!

hasStaticEdge
	"Answer whether the receiver has the Static Edge style (a subtler 3D sunken edge than
	WS_EX_CLIENTEDGE, intended for use with windows which do not accept input)."

	^self exStyleAllMask: WS_EX_STATICEDGE!

hasStaticEdge: aBoolean 
	"Sets the receiver to have a subtly sunken 3D border (Win95 edging style for controls not
	intended to accept input) or not depending on the value of aBoolean. This is the
	WS_EX_STATICEDGE style."

	(self 
		exStyleMask: WS_EX_STATICEDGE
		set: aBoolean
		recreateIfChanged: false) ifTrue: [self frameChanged]!

hasTransparentBackground
	^self isTransparent!

hasView
	"Private - Answer true if the view is valid.
	Part of the Presenter protocol used when the receiver is in fact its own presenter"

	^true!

hasVisibleStyle
	"Answer whether the receiver has the WS_VISIBLE style."

	^self getWindowStyle anyMask: WS_VISIBLE!

hasVisibleStyle: aBoolean
	"Set or clear the receiever's WS_VISIBLE style flag.
	Answer whether the receiver's window was previously visible."

	^self baseStyleMask: WS_VISIBLE set: aBoolean.
!

height
	"Answer the height of the receiver's outer window."

	^self getWindowRect height
!

height: anInteger
	"Sets the height of the receiver's outer window to anInteger."

	self extent: self width @ anInteger!

helpId
	"Answer the actual helpId to be used to display text for the receiver.
	Views which have a nil helpId inherit from their parents"

	^self presenter = self 
		ifTrue: [self parentView helpId]
		ifFalse: [self presenter helpId]!

hide
	"Makes the receiver invisible"

	^self showWithStyle: SW_HIDE!

hookWindowCreate
	"Private - Hook window creation for the receiver so that we are able to intercept the very
	first message for the receiver and subclass the window at that point. This means
	that we can receiver every message for a View before its class' window proc, even
	if it is a control. We don't need to do anything fancy for our own windows."

	self onAboutToCreate.
	self primHookWindowCreate: true!

id
	"Answer the Integer identifier of the receiver"

	^self getWindowLongPtr: GWLP_ID!

id: anInteger
	"Set the receiver's Integer identifier."

	^self setWindowLong: GWL_ID to: anInteger!

inheritContextMenu
	"Answer whether the receiver will inherit the parent view's context menu if it has
	none of its own. This is the default, and is useful when you wish to define a single
	context menu at container level that is used in a number of sub-views. If, on the other
	hand, you want don't want to inherit the parent's context menu, perhaps because
	you want to use a control's own default menu, then this option must be toggled off."

	^flags noMask: NoInheritMenuMask!

inheritContextMenu: aBoolean 
	flags := flags mask: NoInheritMenuMask set: aBoolean not!

initialize
	"Private - Initialise the new receiver."

	creationStyle := self defaultStyle.
	interactor := presenter := self.
	flags := 0.
	backcolor := Color default.
	self isManaged: true.
	self initializeModel
!

initializeModel
	"Private - Set the default model for the receiver directly. Wire up the event triggers but don't trigger any change
	notifications yet."
	
	self setModel: self class defaultModel.
	self connectModel.
!

interactor
	^interactor!

interactor: anInteractor 
	"Set the receiver's interactor, answering the previous one."

	| oldInteractor |
	oldInteractor := interactor.
	interactor := anInteractor.
	^oldInteractor.!

invalidate
	"Invalidate the entire client area so that it will be re-painted"

	self invalidateRect: nil!

invalidateCalculatedExtent
	"The receiver's internal contents have been changed in such a way that
	the preferred calculatedExtent will also have been changed. If the preferred extent
	is in use and dependent on the calculatedExtent then invalidate the receiver's
	layout."

	(self usePreferredExtent and: [self preferredExtent isNil]) ifFalse: [^self].
	self invalidateLayout.

	"Most often the operation that caused the original contents change will
	have invalidated the receiver's contents. This propagates a validateLayout
	and thereby effects the appropriate layout recalculation. In some cases, however, 
	it is necessary to poke it for a layout to take place. We do this here by invalidating 
	a minimal rectangle of the receiver."
	self invalidateRect: (0 @ 0 extent: 1 @ 1)!

invalidateLayout
	"Invalidates the layout of the receiver and all its parent indicating that the geometry
	hierarchy needs to be recalculated."

	self basicInvalidateLayout.
	self allParentsDo: [:each | each basicInvalidateLayout]!

invalidateLayoutDeeply
	self invalidateLayout.
	self allSubViewsDo: [:each | each basicInvalidateLayout]!

invalidateRect: aRectangle
	"Invalidates the specified client rectangle (a RECTL, Rectangle, or nil for the whole client window)
	erasing the background. Answer whether the function succeeds."

	^self invalidateRect: aRectangle erase: true!

invalidateRect: aRectangle erase: aBoolean
	"Invalidates the specified client rectangle (a RECTL, Rectangle, or nil for the whole client window).
	Set whether to erase the receivers background before repainting. Answer whether the function succeeds."

	"There is a possibility that this may be called before the receiver has been created
	so check for this to avoid accidentally redrawing the entire desktop"

	handle isNull ifTrue: [^false].
	^self hasTransparentBackground
		ifTrue: 
			[self parentView invalidateRect: (aRectangle isNil
						ifTrue: [self rectangle]
						ifFalse: [self mapRectangle: aRectangle to: self parentView])
				erase: aBoolean]
		ifFalse: 
			[UserLibrary default
				invalidate: handle
				lpRect: aRectangle asParameter
				bErase: aBoolean asParameter]!

invalidateRgn: aRegionOrNil
	"Invalidates the client region aRegionOrNil (nil invalidates the whole client area)
	erasing the background. Answer whether the function succeeds."

	^self invalidateRgn: aRegionOrNil erase: true!

invalidateRgn: aRegionOrNil erase: aBoolean
	"Invalidates the client region aRegionOrNil (nil invalidates the whole client area)
	erasing the background. Answer whether the function succeeds."

	^UserLibrary default
		invalidateRgn: handle
		hRgn: aRegionOrNil asParameter
		bErase: aBoolean!

invalidateUserInterface
	"Invalidates the user interface of the receiver indicating that it needs
	to be requeried using #validateUserInterface (usually at idle time)"

	self topShell invalidateUserInterface!

isActive
	"Answer whether the receiver is the current active window."

	^self class activeHandle = self handle!

isDialogMessage: aMSG
	"Private - Answer whether the receiver wishes to gobble up (and indeed has gobbled up) 
	the argument, aMSG. Although IsDialogMessage help mentions only that keyboard messages 
	are translated, the MFC library also calls IsDialogMessage for mouse messages, 
	so we follow suit."

	^(UserLibrary default isDialogMessage: handle lpMsg: aMSG) == true	"in case of callback unwind on image restart"!

isDolphinWindow
	"Private - Answers true if this view is managed by Dolphin."

	^SessionManager inputState isDolphinWindow: handle!

isDragSource
	"Private - Answer whether the receiver can take part in a drag and drop session as a drag source."

	^flags anyMask: DragSourceMask!

isDragSource: aBoolean
	"Set or reset the receiver's isDragSource flag. When true, the receiver can take part in
	a drag and drop operation as a drag source."

	flags := flags mask: DragSourceMask set: aBoolean!

isDropTarget
	"Private - Answer whether the receiver can take part in a drag and drop session as a drop target."

	^flags anyMask: DropTargetMask!

isDropTarget: aBoolean
	"Set or reset the receiver's isDropTarget flag. When true, the receiver can take part in
	a drag and drop operation as a potential drop target."

	flags := flags mask: DropTargetMask set: aBoolean.
!

isEnabled
	"Answer whether the receiver is enabled for input"

	^UserLibrary default isWindowEnabled: handle!

isEnabled: aBoolean
	"Set or reset whether the receiver is enabled for user input"

	UserLibrary default enableWindow: handle bEnable: aBoolean!

isEnabledDeeply: aBoolean 
	"Set whether the receiver and all its subviews are or are not enabled for user input,
	depending on the <boolean> argument."

	self isEnabled: aBoolean.
	self subViewsDo: [:each | each isEnabledDeeply: aBoolean]!

isForeground
	"Answer whether the receiver is the current foreground window."

	^self isOpen and: [self class foregroundHandle = handle]!

isGroupStop
	"Answers whether the receiver has the WS_GROUP style. This style is used to identify the
	first control in a group of controls. All subsequent controls up to (but not including) the
	next control in the group with the style are considered to be part of the same group.
	Controls within the same group can be navigated between by using the keyboard's arrow keys."

	^self baseStyleAllMask: WS_GROUP!

isGroupStop: aBoolean
	"Sets whether the receiver has the WS_GROUP style according to aBoolean."

	self baseStyleMask: WS_GROUP set: aBoolean recreateIfChanged: false!

isLayoutValid
	"Answer true if the layout of the receiver is currently valid"

	^flags allMask: LayoutValidMask.
!

isManaged
	"Answer true if the receiver is managed by its parent's layout manager"

	^flags anyMask: ManagedMask!

isManaged: aBoolean
	"Set the receiver to be managed by its parent's layout manager according to 
	aBoolean"

	flags := flags mask: ManagedMask set: aBoolean!

isOpen
	"Answer whether the receiver has an associated Win32 Window.
	We don't use #handle here since this would force creation of the
	window. Note that the answer is not 100% reliable if affirmative,
	because we may be an old view with a handle which Windows
	has reused."

	^handle notNil and: [UserLibrary default isWindow: handle]!

isPersistentlyDisabled
	"Private - Answer whether the receiver is disabled in a way that should be persisted.
	So, for example, if the receiver has been disabled by a non-Dolphin dialog window
	that cannot itself be persisted, it does not make sense to persist the disabled state either.
	Implementation Note: In the case of generic View's, they are considered persistently
	disabled if just disabled."

	^self isEnabled not!

isPersistentView
	"Answer whether the receiver has persistent state which can and should
	be persistent in the image (i.e. top-level windows which answer true
	to this will be sent #state and #state: messages by the 
	SessionManager before the image is saved, and on session startup, respectively)."

	^self isTopView!

isPopup
	"Answers whether the receiver has the WS_POPUP style. This style is used to identify frame
	windows, typically top-level shells but it is also applied to toolbox windows that are owned
	by some other window.."

	^self baseStyleAllMask: WS_POPUP!

isPopup: aBoolean 
	self 
		baseStyleMask: WS_POPUP
		set: aBoolean
		recreateIfChanged: true!

isReadOnly
	"Answer whether the receiver's contents can be updated. Normally this is equivalent to
	whether or not the view is disabled, but some view classes may have a specific read-only
	mode."

	^self isEnabled not!

isReadOnly: aBoolean
	"Set whether the receiver's contents can be updated. Normally this is equivalent to
	whether or not the view is disabled, but some view classes may have a specific read-only
	mode."

	^self isEnabled: aBoolean not!

isResizable
	"Answers whether the receiver is resizeable, i.e. whether it has the WS_THICKFRAME style."

	^self baseStyleAllMask: WS_THICKFRAME!

isResizable: aBoolean 
	"Sets the receiver to be resizeable or a fixed size, depending on the value of the <boolean> argument.
	i.e. add or remove the WS_THICKFRAME style"

	(self 
		baseStyleMask: WS_THICKFRAME
		set: aBoolean
		recreateIfChanged: false) ifTrue: [self frameChanged]!

isStateRestoring
	"Private - Answer true if the state of the receiver is being restored, i.e. we are
	within a #state: method. Used to disable some notification during this period when
	sibling views may not yet be valid"

	^flags anyMask: StateRestoringMask
!

isStateRestoring: aBoolean
	"Private - Set a flag to indicate that state of the receiver is being restored according to aBoolean. 
	Used to disable some notifications during the period when the view or its siblings/children may not yet be valid."

	aBoolean
		ifTrue: [self setStateRestoring]
		ifFalse: 
			[self isStateRestoring
				ifTrue: 
					[self clearStateRestoring.
					self onStateRestored]]!

isTabStop
	"Answers whether the receiver has the WS_TABSTOP style."

	^self baseStyleAllMask: WS_TABSTOP
!

isTabStop: aBoolean
	"Sets whether the receiver has the WS_TABSTOP style according to aBoolean."

	self baseStyleMask: WS_TABSTOP set: aBoolean recreateIfChanged: false
!

isThemed
	^self theme notNull!

isTopView
	"Answer whether the receiver is child of the Desktop."

	^self isOpen and: [self parentView == self class desktop]!

isTransparent
	"Answer whether the receiver is transparent (i.e. it has the WS_EX_TRANSPARENT style)."

	^self exStyleAllMask: WS_EX_TRANSPARENT!

isTransparent: aBoolean
	"Set whether or not the receiver is transparent (i.e. it 
	set/remove the WS_EX_TRANSPARENT style)."

	self exStyleMask: WS_EX_TRANSPARENT set: aBoolean
!

isView
	"Answer whether the receiver is a View."

	^true!

isWindowUnicode
	"This should always be true in Dolphin now."

	^UserLibrary default isWindowUnicode: handle!

isWindowVisible
	"Answer whether both the receiver and its parent have the WS_VISIBLE style,  it is therefore possible
	that this method will answer true even if the receiver is totally obscured by other windows."

	^UserLibrary default isWindowVisible: handle!

isWindowVisible: aBoolean
	"Set the window visibility according to aBoolean"

	aBoolean ifTrue: [self show] ifFalse: [self hide]
!

keyboardCommands
	^#()!

killTimer: anIntegerId
	"Stops a timer for this window. The timer identifier (anIntegerId)
	is an integer that identifies the particular timer to kill. Answers
	true if the operation succeeds."

	^UserLibrary default killTimer: handle uIDEvent: anIntegerId!

layout
	"Recalculate the geometry of the receiver. Subclasses should override #layout:."

	self deferLayout: [:context | self layout: context]!

layout: aLayoutContext 
	"Private - Recalculate the geometry of the receiver."

	!

layoutExtent: aLayoutContext 
	"Answer the extent of the receiver that should be used by a layout manager during it's layout
	process. The <Point> argument is the suggested extent."

	"Implementation Note: If the view has been flagged as requiring its preferred extent to be used then it is,
	otherwise the suggested extent is answered. Subclasses can override this to answer an extent
	that is perhaps based on the current contents of the view."

	^self usePreferredExtent 
		ifTrue: [self actualPreferredExtent: aLayoutContext]
		ifFalse: [aLayoutContext extentOf: self]!

layoutManager
	"Answer the layout manager for the receiver.
	The default is to answer nil, and this is overridden in ContainerView."

	^nil!

literalStoreOn: aStream
	"Stores the receiver in a literal form on aStream that can be reconstituted using Object class>>literalReadFrom:.
	We must arrange to snip this view from any parent hierarchy before the save"

	| filer viewProxy |
	viewProxy := self whileInvisibleDo: 
					[self filerProxy
						beTopView;
						yourself].
	filer := STLOutFiler on: aStream.
	filer
		override: self with: viewProxy;
		nextPut: self!

loadViewResource: aResourceArray forEdit: isLoadingForEdit
	"Add an instance of the resource held in anSTLArray. Answer the new view."

	| stream filerClass |
	filerClass := (aResourceArray isKindOf: ByteArray) ifTrue: [STBInFiler] ifFalse: [STLInFiler].
	stream := aResourceArray readStream.
	^
	[(filerClass on: stream)
		isUpgrading: isLoadingForEdit;
		context: self;
		next]
			ensure: [stream close]!

managedSubViews
	"Answer an OrderedCollection of the sub views of the receiver that are managed.
	Managed sub views can be edited by the ViewComposer and are arranged
	by the layout manager (if any)"

	| answer |
	answer := OrderedCollection new.
	self managedSubViewsDo: [:each | answer addLast: each].
	^answer!

managedSubViewsDo: aMonadicValuable 
	"Evaluate the <monadicValuable> argument for each of the receiver's managed sub-views, in
	z-order sequence. Managed sub-views can be edited by the ViewComposer and are arranged by
	the layout manager (if any)."

	self subViewsDo: [:each | each isManaged ifTrue: [aMonadicValuable value: each]]!

mapPoint: aPoint to: anotherView
	"Maps aPoint from the coordinate system of the receiver into that of anotherView"

	| pt |
	pt := POINTL fromPoint: aPoint.
	UserLibrary default
		mapWindowPoints: handle
		hWndTo: anotherView asParameter
		lpPoints: pt
		cPoints: 1.
	^pt asPoint!

mapPointToScreen: aPoint
	"Maps the `Point` argument from the coordinate system of the receiver to screen coordindates."

	| pt |
	pt := POINTL fromPoint: aPoint.
	UserLibrary default clientToScreen: handle lpPoint: pt.
	^pt asPoint!

mapRectangle: aRectangle to: anotherView
	"Maps aRectangle from the coordinate system of the receiver into that of anotherView."

	^(self class
		mapRectangle: aRectangle
		from: self
		to: anotherView) asRectangle
!

maxExtent
	"Answers the maximum extent for the receiver or nil if there is no constraint.
	This only applies for	views being resized directly by the UI. It is not considered
	during layout by a LayoutManager."

	^nil!

minExtent
	"Answers the minimum extent for the receiver or nil if there is no constraint.
	This only applies for	views being resized directly by the UI. It is not considered
	during layout by a LayoutManager."

	^nil!

model
	"Answer the model (if any) for the receiver"
	
	^model!

model: aModel
	"Set model for the receiver. Subclasses that wish to connect to specific update 
	events generated by the model should override #connectModel."
	
	self 
		disconnectFromModel;
		setModel: aModel;
		connectModel;
		onModelChanged!

name
	"Answer the name of the receiver in its parent or nil if no
	name has been set"

	^self parentView nameOf: self.
!

name: aStringOrNil
	"Set the name of the receiver in its parent to aStringOrNil"

	^self parentView name: self as: aStringOrNil.
!

nameOf: aView
	"Answer the name of aView within the receiver or nil
	if it has not been assigned a name"

	^nil!

needsValidateLayout
	"Answer true if the layout of the receiver or any of its subViews is invalid. This is an
	indication that a #validateLayout needs to be sent to sort out the geometry."

	^self isLayoutValid not or: [self subViews anySatisfy: [:each | each needsValidateLayout]]!

nextSiblingView
	"Answers the sibling immediately behind the receiver in the Zorder, or nil if there is none."

	| sibling |
	sibling := self getWindow: GW_HWNDNEXT.
	sibling isNil ifTrue: [^nil].
	^self class withHandle: sibling!

nmNotify: anNMHDR
	"Private - Default handler for a redirected WM_NOTIFY message."

	^nil!

nonClientCanvas
	"Answer a canvas for drawing on the non-client areas of this View"

	^Canvas forNonClientView: self!

nonReferenceAncestor
	"Answer the view that is the first non-reference view in the parent chain of this view, inclusive."

	^self!

noRedrawDo: aNiladicBlock
	"Evaluate the niladic <BlockClosure> argument with redraw disabled, answering its result."

	self disableRedraw.
	^aNiladicBlock ensure: [self enableRedraw]!

oldWndProc: anAddress
	"Private - Save the address of the old window procedure prior to subclassing."

	"Do nothing by default"
	^self!

onAboutToCreate
	"Default handler for pre-creation event.
	The receiver is about to be realized, perform once off processing
	required before that happens. The default is to do nothing."

	^nil!

onAboutToDisplayMenu: popup
	"The pop-up <Menu>, popup, is about to be displayed.
	This is our opportunity to update it, e.g. to add/remove items."

	self presenter trigger: #aboutToDisplayMenu: with: popup.
	^0  "prevent default processing" !

onActionPerformed
	"Handler for an action in the receiver. 
	The default is to trigger an #action event off the presenter"

	Cursor wait showWhile: [self presenter trigger: #actionPerformed].
	self invalidateUserInterface!

onBegin: dragOp drag: dragee 
	"Handler for a begin drag initiated by the mouse button identified by the <Symbol>, dragOp.
	The <Object>, dragee, is a suggestion for the drag object."

	"First check that the mouse button is still down. Sometimes bringing up a dialog or message box
	on a left click can cause the receiver to miss a corresponding mouse up."

	(Keyboard default isButtonDown: dragOp) 
		ifTrue: 
			[(self dragDropSessionClass dragSource: self item: dragee) doDragDropAt: Cursor position
				button: dragOp]!

onCaptureChanged: aViewOrNil
	"The view with capture of the mouse has changed to the argument (which is nil if no
	Dolphin window has capture)."

	^nil!

onCloseRequested
	"Default handler for a close request event.
	Answer nil to accept the default processing."

	^nil!

onColorRequired: aColorEvent
	"Colour event handler for aColorEvent (WM_CTLCOLORXXX). 
	We can set up the canvas provided by the event with the appropriate foreground 
	and background colours for the receiver. Windows WM_CTLCOLORXXX messages require 
	that we answer the background brush handle"

	^nil "Perform default processing"!

onCommand: aCommandDescription
	"Performs aCommandDescription for the receiver. We use the standard routing policy,
	and display the wait cursor until the action is completed."

	| answer |
	answer := Cursor wait showWhile: [ 
		self presenter commandPolicy route: aCommandDescription].
	"The command may have closed the window"
	self isOpen ifTrue: [self invalidateUserInterface].
	^answer!

onCreated: anEvent
	"Default handler for creation. Note that it is a vagary of Windows that the receiver
	may not yet be fully created at this point. If this is important then override
	#onFullyCreated to guarantee that the receiver is fully consistent. 
	Answer nil to accept the default processing."

	^nil!

onDestroyed
	"Private - Default handler for destroy. Inform the parent that it's layout
	is now probably invalid. Inform the presenter that its view is now
	gone. Answer nil to accept the default processing."

	self isStateRestoring ifFalse: [self model removeEventsTriggeredFor: self].
	self parentView onSubViewRemoved: self.
	self presenter onViewClosed.
	^nil!

onDrawItem: aDRAWITEMSTRUCT 
	^nil!

onDrawMenuItem: aDRAWITEMSTRUCT 
	self queryContextMenu 
		ifNotNil: 
			[:menu | 
			(menu menuFromHandle: aDRAWITEMSTRUCT hwndItem) 
				ifNotNil: 
					[:subMenu | 
					subMenu onDrawItem: aDRAWITEMSTRUCT.
					^TRUE]].
	^nil!

onEraseRequired: aColorEvent 
	"Handler for erase background event- erase to the background colour,
	or answer nil if no colour is set to accept the default window processing."

	| bkColor |
	self hasTransparentBackground 
		ifFalse: 
			[bkColor := self actualBackcolor.
			bkColor isNone 
				ifFalse: 
					[aColorEvent canvas fillRectangle: self clientRectangle color: bkColor.
					^true]].
	^self eraseParentBackground: aColorEvent canvas!

onGetCursor: aSymbol
	"The named area of the window associated with the receiver has been hit.
	Answer the appropriate mouse cursor, or nil to accept the default."

	^aSymbol == #client ifTrue: [self cursor]!

onHotKey: anInteger 
	"Private - Default handler for a hotKey event. The parameter identifies the hot key."

	self presenter trigger: #hotKey: with: anInteger.
	^nil!

onHScroll: aScrollEvent
	"Default handler for a horizontal scroll event.
	Answer nil to accept the default processing."

	^nil!

onIdleEntered
	"There are no messages in the input queue and the input state is
	about to go idle. Perform any idle processing.
	N.B. Usually actioned only by top level windows, but also received by
	any other views without a presenter."

	^true!

onInputLanguageChanged: aWindowsEvent
	SessionManager current onInputLanguageChanged: aWindowsEvent.
	self presenter trigger: #inputLanguageChanged: with: aWindowsEvent.
	^aWindowsEvent lResult!

onInputMaskRequired: anEvent
	"Handler for a WM_GETDLGCODE request from Windows.
	The lParam is a pointer to the MSG that may be sent depending on the response.
	The answer should be some combination of DLGC_XXXX flags (e.g. DLGC_WANTARROWS | DLGC_WANTTAB).
	By default we perform the default window processing (which at the time of writing, ansers 0) 
	and bitOr: in DLGC_WANTCHARS, since this gives more useful and intuitive behaviour for 
	specialized View subclasses which will often want alpha-numeric keyboard input."

	^anEvent defaultWindowProcessing bitOr: DLGC_WANTCHARS!

onKeyPressed: aKeyEvent
	"Default handler for a key press event.
	Accept the default window processing."

	self presenter trigger: #keyPressed: with: aKeyEvent.
	^aKeyEvent defaultWindowProcessing!

onKeyReleased: aKeyEvent
	"Default handler for a key up event.
	Accept the default window processing."

	self presenter trigger: #keyReleased: with: aKeyEvent.
	^aKeyEvent defaultWindowProcessing!

onKeyTyped: aKeyEvent
	"Default handler for a keyboard event.
	Accept the default window processing."

	self presenter trigger: #keyTyped: with: aKeyEvent.
	^aKeyEvent defaultWindowProcessing!

onKillFocus
	"Handler for loss of focus"

	self presenter trigger: #focusLost.
	^nil "Perform default processing"!

onLeftButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse left button double-click event.
	Accept the default window processing."

	self presenter trigger: #leftButtonDoubleClicked: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onLeftButtonPressed: aMouseEvent
	"Default handler for a left button down mouse event.
	Accept the default window processing."

	self presenter trigger: #leftButtonPressed: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onLeftButtonReleased: aMouseEvent
	"Default handler for a Left button up mouse event.
	Accept the default window processing."

	self presenter trigger: #leftButtonReleased: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onMiddleButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse middle button double-click event.
	Accept the default window processing."

	self presenter trigger: #middleButtonDoubleClicked: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onMiddleButtonPressed: aMouseEvent
	"Default handler for a middle button down mouse event.
	Accept the default window processing."

	self presenter trigger: #middleButtonPressed: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onMiddleButtonReleased: aMouseEvent
	"Default handler for a middle button up mouse event.
	Accept the default window processing."

	self presenter trigger: #middleButtonReleased: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onModelChanged
	"The model held by the associated presenter has been replaced (i.e. the complete
	contents have changed) so refresh the receiver here."

	self isOpen ifTrue: [self refreshContents]!

onMouseHovering: aMouseEvent
	"Default handler for a mouse leave event. Accept the default processing."

	self presenter trigger: #mouseHovering: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onMouseLeave: aMouseEvent
	"Default handler for a mouse leave event. Accept the default processing."

	self presenter trigger: #mouseLeave: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onMouseMoved: aMouseEvent
	"Default handler for a mouse move event.
	Accept the default processing.
	Note: As of D6 we do now trigger an event on mouse move."

	self presenter trigger: #mouseMoved: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onMouseWheeled: aMouseWheelEvent
	"Default handler for a mouse wheel movement event.
	Accept the default window processing."

	self presenter trigger: #mouseWheeled: with: aMouseWheelEvent.
	^aMouseWheelEvent defaultWindowProcessing!

onPaintRequired: aPaintEvent
	"Default handler for paint.
	N.B. Do not invoke default processing from this event because BeginPaint() has already
	been called. If you need to invoke default processing then you will have to override
	#wmPaint:wParam:lParam: (e.g. see ControlView)."!

onPositionChanged: aPositionEvent
	"Default handler for window position change (move or resize).
	Inform the parent view that its layout is now invalid. Accept the 
	default processing as well by answering the receiver.
	This event is new for Dolphin 3.0, and superceeds #onResized: and 
	#onMoved: which are no longer sent."

	aPositionEvent isRectangleChanged 
		ifTrue: [self invalidateLayout].
	self presenter trigger: #positionChanged: with: aPositionEvent!

onPositionChanging: aPositionEvent
	"Default handler for window position changing (move or resize).
	Modifying the contents of aPositionEvent can alter how it gets mapped
	to an actual position change of the receiver."

	self presenter trigger: #positionChanging: with: aPositionEvent.
	^nil!

onRestoredFromProxy
	"Override point for subclasses to take any further action they might want on rehydration"

	"Default actions are performed in #restoreFromProxy:"

	!

onRightButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse Right button double-click event.
	Accept the default window processing."

	self presenter trigger: #rightButtonDoubleClicked: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onRightButtonPressed: aMouseEvent
	"Default handler for a Right button down mouse event.
	Accept the default window processing."

	self presenter trigger: #rightButtonPressed: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onRightButtonReleased: aMouseEvent
	"Default handler for a Right button up mouse event.
	Accept the default window processing."

	self presenter trigger: #rightButtonReleased: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onSetFocus
	"Handler for set focus event"

	self invalidateUserInterface.
	self presenter trigger: #focusGained.
	^nil "Perform default processing"!

onStartup
	"Ensure that the handle of the receiver is set to nil at startup."

	self clearHandle!

onStateRestored
	"Override point for subclasses to perform post-state restoral actions. State may be restored in three circumstances:
		1) Rehydration from binary filed state
		2) Restore after image save
		3) Recreation after the change of style flag that can only be specified at view creation time."!

onSubViewAdded: aView
	"Received when aView has been added to the receiver.
	Can be overridden by subclasses to perform necessary housekeeping regarding the
	new contents of the receiver"


	!

onSubViewRemoved: aView
	"Received when aView has been removed from the receiver.
	Can be overridden by subclasses to perform necessary housekeeping regarding the
	new contents of the receiver"

!

onSysKeyPressed: aKeyEvent
	"Default handler for a sys key press event (e.g. ALT down). Accept the default window
	processing."

	self presenter trigger: #sysKeyPressed: with: aKeyEvent.
	^aKeyEvent defaultWindowProcessing!

onSysKeyReleased: aKeyEvent
	"Default handler for a sys key up event (e.g. ALT up). Accept the default window
	processing."

	self presenter trigger: #sysKeyReleased: with: aKeyEvent.
	^aKeyEvent defaultWindowProcessing!

onSysKeyTyped: aKeyEvent
	"Default handler for a sys key press sequence. Accept the default window processing."

	self presenter trigger: #sysKeyTyped: with: aKeyEvent.
	^aKeyEvent defaultWindowProcessing!

onTipDetailsRequired: aNMTTDISPINFO 
	self presenter trigger: #tipDetailsRequired: with: aNMTTDISPINFO!

onTipTextRequired: tool
	"Tool tip text is required for the <ToolbarItem>, tool.
	This event is sent to the receiver if it is current <commandTarget>
	for the command associated with the toolbar item."

	^tool toolTipText!

onViewClosed
	"Handler for view destroy"

	self presenter trigger: #viewClosed.
!

onViewCreated
	"The receiver has just been fully created. This is a suitable place to perform
	initialization of the window from the receiver's instance variables."

	"Implementation Note: In earlier versions of Dolphin (prior to D6) the equivalent
	#onFullyCreated message was sent on receipt of a WM_PARENTNOTIFY Windows message sent to the
	Window's parent, and thus was not available for views that used the WS_EXNOPARENTNOTIFY
	extended style, or which were created as immediate children of the desktop or any other
	Windows not subclassed by Dolphin. In D6 and later it is sent from Smalltalk code when the
	CreateWindow API call has returned (as opposed to in response to the parent notification
	message sent by Windows just before the CreateWindow call returned), and so is reliably sent
	to all views, regardless of their style, or whether they are a child window."
!

onViewDestroyed
	"Handler for view final view destruction. This is sent on receipt of WM_NCDESTROY,
	and is expected to be the last communication from Windows. There is nothing
	more we can do to save the patient. No event is triggered.
	Note that we don't do finalization actions here, because a more robust choice
	is in the actual handler for WM_NCDESTROY, just in case the presenter fails
	to forward on this message."!

onViewOpened
	"Handler for view opened"

	self presenter trigger: #viewOpened.!

onVScroll: aScrollEvent
	"Default handler for a vertical scroll event.
	Answer nil to accept the default processing."

	^nil

!

onXButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse X button double-click event. Accept the default window
	processing."

	self presenter trigger: #xButtonDoubleClicked: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onXButtonPressed: aMouseEvent
	"Default handler for an X button down mouse event. Accept the default window processing."

	self presenter trigger: #xButtonPressed: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onXButtonReleased: aMouseEvent
	"Default handler for an X button up mouse event. Accept the default window processing."

	self presenter trigger: #xButtonReleased: with: aMouseEvent.
	^aMouseEvent defaultWindowProcessing!

onZOrderChanged
	"Received when the Zorder of the subviews within the receiver has been
	directly changed. Can be overridden by subclasses to perform necessary 
	housekeeping regarding the new Zorder."

!

openTheme
	"Generally the theme handle is common to the class and is opened lazily on demand. Generally no instance specific action is required."!

parentPresenter
	"Answer the presenter that can be considered the parent of the receiver.
	Part of the Presenter protocol used when the receiver is in fact its own presenter"

	| parent |
	presenter == self ifFalse: [^presenter parentPresenter].
	parent := self parentView.
	^(parent isNil or: [parent == self class desktop]) ifFalse: [parent presenter]!

parentView
	"Answer the parent View of the receiver assigned before creation,
	or nil if none."

	^creationParent!

parentView: aView 
	"Private - Sets the parent of the receiver to aView. Can only be used when the
	receiver is not yet realized since Windows has a bug when reparenting"

	creationParent := aView.
	creationStyle at: 1 put: (self baseStyle mask: WS_CHILD set: true)!

performAction
	"Cause an #actionPerformed event to be routed"

	self presenter onActionPerformed!

placement
	"Answers an instance of WINDOWPLACEMENT filled with information about
	the current minimized/maximized/restored locations of the receiver and
	its current state. This can be restored at a later date using
	View>>placement:"

	| placement |
	placement := WINDOWPLACEMENT new.
	(UserLibrary default getWindowPlacement: handle lpwndpl: placement)
		ifFalse: [UserLibrary default systemError].

	"If the receiver is invisible, we have to clear the SW_SHOWNORMAL flag which
	is set for some reason. A bug in Windows ?"
	(self getWindowStyle anyMask: WS_VISIBLE)
		ifFalse: [placement showCmd: (placement showCmd maskClear: SW_SHOWNORMAL)].
	^placement!

placement: aWINDOWPLACEMENT
	"Sets the current minimized/maximized/restored locations of the receiver and
	its current state from information in aWINDOWPLACEMENT"

	UserLibrary default setWindowPlacement: handle lpwndpl: aWINDOWPLACEMENT asParameter!

plainText
	"Answers the plain, unformatted, text from the receiver."

	^self getWindowText!

plainText: aString
	"Private - Set the text contents of the receiver to the plain text aString.
	Part of the RichText double dispatching protocol"

	self setWindowText: aString
!

plainTextFrom: startInteger to: stopInteger
	"Answer a string containing the plain text contents of the receiver
	in the specified 1-based, end-inclusive, range. If stopInteger is -1, 
	then answers text from startInteger up to the end."

	| text |
	text := self plainText.
	^stopInteger < 0 
		ifTrue: [text copyFrom: startInteger]
		ifFalse: [text copyFrom: startInteger to: stopInteger]!

plainTextRange: anInterval
	^self plainTextFrom: anInterval start to: anInterval stop!

position
	"Answers the position of the receiver in the coordinates of its parent."

	^self rectangle topLeft
!

position: aPoint
	"Set the top left position of the receiver to aPoint. aPoint is in the coordinate
	system of the receiver's parent. Answer whether the position request was accepted."

	^self setWindowPosAfter: 0 
		x: aPoint x y: aPoint y  
		width: 0 height: 0
		flags: ##(SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE)!

positionForKeyboardContextMenu
	"Answer the desired position for a context menu requested from the keyboard.
	This should be based on the 'current selection', whatever that means in the context of the
	receiver. Should be overridden by subclasses as appropriate."

	^self screenRectangle topLeft + 10!

postMessage: anIntegerMessageID wParam: wParam lParam: lParam
	"Private - Post the Win32 message anIntegerMessageID with parameters wParam and lParam to the receiver"

	^UserLibrary default
		postMessage: handle
		msg: anIntegerMessageID
		wParam: wParam
		lParam: lParam!

preferredExtent
	"Answer the preferred size of the receiver or nil if none has been specified"

	^preferredExtent!

preferredExtent: aPointOrNil 
	"Set the preferred size of the receiver to aPointOrNil. If nil is specified then this implies that
	the receiver has no preferred extent"

	preferredExtent = aPointOrNil ifTrue: [^self].
	preferredExtent := aPointOrNil.
	self parentView invalidateLayout!

presenter
	"Answers the presenter for the receiver"

	^presenter!

presenter: aPresenter
	"Sets the presenter associated with the receiver"

	interactor := presenter := aPresenter.!

presenterConnectionPoint
	"Answer the view within the receiver to which a same named presenter should connect.
	Normally this is the receiver itself. Some views that wish to direct the presenter
	to connect to another view may override this method however"

	^self!

preTranslateKeyboardInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG,
	which is a keyboard message.
	Implementation Note: Most views have no special pretranslation for
	keyboard input, so we answer false to have the message dispatched
	as normal."

	^false!

preTranslateMessage: aMSG
	"Answer whether the receiver would like to consume the argument aMSG.
	There are separate pre-translation handlers for mouse and keyboard
	input, which can be overridden as necessary (e.g. see shells)."

	^(aMSG isKeyboardInput and: [self preTranslateKeyboardInput: aMSG])
		or: [aMSG isMouseInput and: [self preTranslateMouseInput: aMSG]]
!

preTranslateMouseInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG.
	Implementation Note: By default we relay the mouse message to any tool tip 
	associated with the receiver, otherwise answering false to have the message
	dispatched as normal."

	| toolTip |
	^(toolTip := self toolTipWindow) notNil and: [toolTip ttmRelayEvent: aMSG]

!

previousSiblingView
	"Answers the sibling immediately before the receiver in the Zorder, or nil if there is none."

	| sibling |
	sibling := self getPreviousSibling.
	sibling isNil ifTrue: [^nil].
	^View withHandle: sibling!

primHookWindowCreate: hookBoolean
	"Private - Ask the VM to hook the first subsequent window creation event for the receiver.
	When it receives such an event it will send a #subclassWindow: callback with the handle of the newly created window to the receiver. This allows controls to be subclassed BEFORE they return from the CreateWindowEx() call.
	The VM uses a CBT hook to achieve this. The hook is implemented in the VM to minimise the performance impact. The hook is automatically 'unhooked' by the VM when it receive's the create notification before it sends the #subclassWindow: callback."

	"Primitive failure reasons:
		InvalidParameter1	- hookBoolean not a boolean
		IllegalStateChange	- already hooked by another view
		NotSupported		- The VM is for console apps only"

	<primitive: 108>
	^self primitiveFailed: _failureCode!

printOn: aStream
	"Append a short description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		display: (handle isNil ifTrue: ['NULL'] ifFalse: [handle asInteger printStringRadix: 16]);
		nextPutAll: ', ';
		print: self displayString;
		nextPut: $)!

propagateSettingsChange: aSettingsChangeEvent
	self subViewsDo: [:each | each settingChanged: aSettingsChangeEvent]!

queryCommand: aCommandQuery
	"Private - Update aCommandQuery to indicates how a command would be processed.
	if sent to the receiver. Answers whether the receiver recognised the command
	as one of its own (this may be ignored by the command router). This need not
	be supersent if the #isEnabled: is sent to the <CommandQuery> to explicitly
	enable or disable a particular command."

	(aCommandQuery canPerformAgainst: self) ifTrue: [
		aCommandQuery beEnabled].
	^false "not explicitly recognised at this level"!

queryCommandRouteFor: action
	"Private - Answer <CommandQuery> that indicates how the <commandDescription>, action,
	would be processed if sent to the receiver.
	Implementation Note: We use the receiver's command policy to route the command and query it"

	^self presenter commandPolicy query: action!

queryContextMenu
	"Answer the context <Menu> that is associated with the receiver, if any. View's without
	their own context menu inherit that of the parent, or the parent's parent, and so on. The
	recursion will terminate at the desktop if no intervening views have a context menu,
	answering nil to indicate that there is no menu."

	^self contextMenu ifNil: [self inheritContextMenu ifTrue: [self parentView queryContextMenu]]!

queryMouseTracking
	| tme |
	tme := TRACKMOUSEEVENT new.
	tme dwFlags: TME_QUERY.
	tme hwndTrack: handle.
	^(UserLibrary default trackMouseEvent: tme) ifTrue: [tme] ifFalse: [nil]!

recreate
	"Recreate the receiver if it is currently open. Useful for applying styles that are only
	available as pre-creation options"

	self recreateAround: []!

recreateAround: aNiladicValuable
	| prevSibling existingPresenter state savedEvents |
	self isOpen
		ifFalse: 
			[aNiladicValuable value.
			^self].
	existingPresenter := presenter.
	presenter := self.
	"Remember the z order position so it can be restored"
	prevSibling := self getPreviousSibling.
	"Destroy and recreate - As we are going to restore the state, we may want to avoid certain
	actions we'd do in a normal destroy, so inform the ViewState this is a recreate."
	state := ViewState recordStateOf: self forRecreate: true.
	savedEvents := self getEvents.
	self basicDestroy.
	aNiladicValuable value.
	state restore.
	"Restore z-order position"
	self zOrderAfter: prevSibling.
	self setEvents: savedEvents.
	"Finally restore the presenter"
	presenter := existingPresenter!

rectangle
	"Answer a Rectangle containing the receiver's outer rectangle in the coordinate system of its parent."

	^(self class
		mapRectangle: self getWindowRect
		from: nil
		to: self parentView) asRectangle!

rectangle: aRectangle 
	"Set the boundary of the receiver to aRectangle. 
	aRectangle is in the coordinate system of the receiver's parent."

	| newRectangle |
	newRectangle := self adjustRectangle: aRectangle.
	newRectangle = self rectangle 
		ifFalse: 
			[self 
				setWindowPosAfter: 0
				x: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height
				flags: ##(SWP_NOZORDER | SWP_NOACTIVATE)]!

refreshContents
	"The receiver's display needs to be refreshed. The default is to invalidate the
	receiver and cause it to repaint. This works fine for all views that do not cache
	data but work direct from the model data itself. Other subclasses may need to refresh 
	their cache."

	self invalidate!

registerHotKeyId: id modifiers: modifiers vkey: vk
	UserLibrary default
		registerHotKey: self handle
		id: id
		fsModifiers: modifiers
		vk: vk!

releaseDC: hDC
	"Release the specified hDC (assumed to have been allocated
	by the receiver's #getDC). Answer whether the DC was indeed
	released."

	^(UserLibrary default releaseDC: handle hDC: hDC asParameter) == 1!

removeSubView: aView 
	"Removes aView as a subview of the receiver. The removed view is destroyed. If , for some
	reason, aView is not a subview of the receiver then it is NOT destroyed. This behaviour can
	be useful when re-parenting a view"

	"Validate that aView is indeed one of the receiver's subviews"

	aView parentView == self ifFalse: [^aView].
	^aView
		destroy;
		yourself!

requestDragImages: session
	"This is where the receiver specifies any drag image overrides. 
	To do this use DragDropSession>>#imageAt: <Symbol> put: <Image> where 
	the Symbol is an either #object (to specify the underlying icon), or an 
	operation Symbol such as #none, #move, #copy, #link, #moveScroll, #copyScroll, 
	#linkScroll or some other Symbol to match an operation symbol. The Image
	is any <Image> (e.g. <Icon> or <Cursor>)."

	self presenter trigger: #requestDragImages: with: session!

requestDragObjects: session
	"This is where the receiver specifies which object(s) the <DragDropSession>, session,
	is to drag using DragDropSession>>addDragObject: or DragDropSession>>dragObjects:.
	The default is to fire a trigger, #drag:, off the Presenter which gives its observers an opportunity
	to supply the dragger objects"

	self presenter trigger: #drag: with: session!

requestDropOperations: aDragDropSession
	"Update the <DragDropSession>, session, with the set of supported 
	drag and drop operation symbols (for right-button drags).
	Implementation Note: Set up some sensible default operations, and then trigger a 
	#requestDropOperations: event off the receiver's presenter to give its observers an 
	opportunity to override those defaults."

	aDragDropSession supportedOperations isNil 
		ifTrue: 
			["Presenter hasn't suggested anything, fill in some defaults"

			aDragDropSession supportedOperations: #(#move #copy)].
	self presenter trigger: #requestDropOperations: with: aDragDropSession!

requestLayoutExtent: aPointExtent 
	"Request that the receiver occupies has aPointExtent. If under the control of a layout manager we
	have to delegate the request through this"

	self requestLayoutRectangle: (self position extent: aPointExtent)!

requestLayoutRectangle: aRectangle 
	"Request that the receiver occupies aRectangle. If under the control of a layout manager we
	have to delegate the request through this"

	| parentLayoutManager |
	parentLayoutManager := self parentView layoutManager.
	parentLayoutManager isNil 
		ifTrue: 
			[self
				position: aRectangle topLeft;
				extent: aRectangle extent]
		ifFalse: [parentLayoutManager resize: self to: aRectangle].
	self parentView validateLayout!

resolution
	"Answer the logical pixels per inch for the receiver; i.e. the screen's
	logical pixels per inch"

	^self class desktop resolution!

resolutionScaledBy: scale
	"Private - The receiver is being loaded and it has been determined that the pixel resolution
	has changed since the point at which the view was saved. Scale any internal pixels by <Point>
	scale. Note that the placement (position and extent) of the receiver has already been scaled
	in #restorePlacement:resolution:."

	preferredExtent notNil ifTrue: [
		preferredExtent := (preferredExtent*scale) truncated ]

!

restoreFromProxy: aViewProxy
	"Private - Complete state restoration from proxy form by apply the saved state, and restoring the subviews from their proxies."

	"The creationParent is already set, but we set it again here
	to so that #parentView: can set the WS_CHILD style appropriately."

	self parentView: self creationParentView.
	self isStateRestoring: true.
	self state: aViewProxy state.
	aViewProxy subViews do: [:proxy | proxy restoreView].
	aViewProxy placement
		ifNotNil: [:placement | self restorePlacement: placement resolution: aViewProxy resolution].
	self isStateRestoring: false.

	"The STB mechanism does not save and restore event triggers.
	We must cause these to be rebuilt here"
	self connectModel.

	"In some situations (notably when restoring a ReferenceView for example) it may be that nothing has
	yet caused the view to be realized. We do this here by forcing an access to its window handle. #57"
	self handle.
	self onRestoredFromProxy!

restorePlacement: aWINDOWPLACEMENT resolution: aPointResolution 
	"Private - Restore the placement for the receiver to aWINDOWPLACEMENT which was
	measured at a screen resolution of aPointResolution. If the current resolution is different
	then the placement rectangle will have to be scaled appropriately. 
	Subclasses can override this message to compensate for a resolution change
	in any other ways required."

	| placement res |
	placement := aWINDOWPLACEMENT.
	res := self resolution.
	aPointResolution = res 
		ifFalse: 
			["Resolution is now different so recompute the placement"

			| rect scale |
			scale := res / aPointResolution.
			rect := placement rcNormalPosition asRectangle.
			rect := rect scaleBy: scale.
			placement rcNormalPosition: rect truncated asParameter.
			self resolutionScaledBy: scale].
	self placement: placement!

richText: aRichText
	"Private - Set the text contents of the receiver to the RTF text, aRichText.
	Part of the RichText double dispatching protocol"

	self plainText: aRichText asString
!

screenRectangle
	"Answer the boundary of the receiver window in screen coordinates"

	| localRect |
	localRect := self rectangle.
	^self parentView mapRectangle: localRect to: self class desktop.
!

screenRectangle: aRectangle
	"Sets the boundary of the receiver to aRectangle.
	aRectangle is in screen coordinates"

	| localRect |
	localRect := self class desktop mapRectangle: aRectangle to: self parentView.
	self rectangle: localRect.
!

scrollBy: aPoint clip: clipRectangle
	"Scroll the contents of the receiver by aPoint"

	^self scrollBy: aPoint scroll: nil clip: clipRectangle
!

scrollBy: aPoint scroll: scrollRectangle clip: clipRectangle
	"Scroll the contents of the receiver by aPoint."

	^UserLibrary default
		scrollWindowEx: handle
		dx: aPoint x
		dy: aPoint y
		prcScroll: scrollRectangle asParameter
		prcClip: clipRectangle asParameter
		hrgnUpdate: nil
		prcUpdate: nil
		flags: SW_ERASE | SW_INVALIDATE!

sendMessage: anIntegerMessageID
	"Private - Send the Win32 message anIntegerMessageID to the receiver's real window with wParam and lParam set to 0."

	^UserLibrary default
		sendMessage: handle
		msg: anIntegerMessageID
		wParam: 0
		lParam: 0!

sendMessage: anIntegerMessageID wParam: anInteger
	"Private - Send the Win32 message anIntegerMessageID to the receiver's real window with the specified
	wParam and lParam set to 0."

	^UserLibrary default
		sendMessage: handle
		msg: anIntegerMessageID
		wParam: anInteger
		lParam: 0!

sendMessage: anIntegerMessageID wParam: wParam lParam: lParam
	"Private - Send the Win32 message anIntegerMessageID with parameters wParam and lParam to the receiver"

	^UserLibrary default
		sendMessage: handle
		msg: anIntegerMessageID
		wParam: wParam
		lParam: lParam!

sendMessage: anIntegerMessageID wParam: wParam lpParam: lParam
	"Private - Send the Win32 message anIntegerMessageID with parameters wParam and lpParam (pointer) to the receiver's
	Window."

	^UserLibrary default
		sendMessage: handle
		msg: anIntegerMessageID
		wParam: wParam
		lpParam: lParam!

sendMessage: anIntegerMessageID wParam: wParam szParam: lParam
	"Private - Send the Win32 message anIntegerMessageID with parameters wParam and lpParam (pointer) to the receiver's
	Window."

	^UserLibrary default
		sendMessage: handle
		msg: anIntegerMessageID
		wParam: wParam
		lpParam: lParam asUtf16String!

setCapture
	"Sets mouse capture to the receiver."

	UserLibrary default setCapture: handle!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

setExtent: aPoint 
	self 
		setWindowPosAfter: 0
		x: 0
		y: 0
		width: aPoint x
		height: aPoint y
		flags: ##(SWP_NOMOVE | SWP_NOZORDER | SWP_NOACTIVATE)!

setFocus
	"Sets focus to the receiver. Answers the View which previously had focus, or nil if
	none/invalid handle. Implicitly re-enables the enclosing popup (shell) view if currently
	disabled."

	| top |
	top := self.
	[top isTopView or: [top isPopup]] whileFalse: [top := top parentView].
	top isEnabled ifFalse: [top enable].
	^UserLibrary default setFocus: handle!

setModel: aModel
	"Private - Set model for the receiver directly. Don't trigger any change
	notifications"
	
	model := aModel.
!

setNoRedrawCount: anInteger 
	anInteger <= 0 ifTrue: [^self removePropertyAt: #_noRedrawCount ifAbsent: []].
	^self propertyAt: #_noRedrawCount put: anInteger!

setParent: aView
	| isDesktopParent |
	self parentView: aView.
	isDesktopParent := aView == self class desktop.
	self setWindowStyle: (self getWindowStyle mask: WS_CHILD set: isDesktopParent not).
	UserLibrary default setParent: handle hWndNewParent: aView asParameter!

setRedraw: aBoolean
	"Private - Enable/disable repainting of the receiver's window."

	self sendMessage: WM_SETREDRAW wParam: aBoolean asParameter
!

setScrollInfo: siStruct bar: bar
	"Private - Set the specified scroll info for the receivers bar.
	Answer the current position of the bars thumb."

	^UserLibrary default
		setScrollInfo: handle
		fnBar: bar
		lpsi: siStruct
		fRedraw: true!

setStateRestoring
	flags := flags bitOr: StateRestoringMask!

setTimer: id interval: interval
	"Sets up a timer for this window. The <integer> timer identifier (id)
	will be passed to the wmTimer:wParam:lParam: event approximately every
	<integer> interval milliseconds. Answers true if the function succeeds."

	id == WM_ENTERIDLE
		ifTrue: 
			[^self error: 'Sorry, timer id ' , WM_ENTERIDLE displayString , ' is reserved for system purposes.'].
	^(UserLibrary default
		setTimer: handle
		nIDEvent: id
		uElapse: interval
		lpTimerFunc: nil) ~= 0!

settingChanged: aSettingsChangeEvent
	"Private - A system wide setting has been changed. Propagate the change event to all sub-views, and updated as required."

	self propagateSettingsChange: aSettingsChangeEvent.
	self updateSetting: aSettingsChangeEvent!

setWindowExStyle: anInteger
	"Private - Set the receiver's extended window style bits to anInteger."

	self setWindowLong: GWL_EXSTYLE to: anInteger !

setWindowLong: anIntegerOffset to: anIntegerValue
	"Private - Set the receiver's Window DWORD at the specified offset to the specified integer value."

	^UserLibrary default
		setWindowLong: handle
		nIndex: anIntegerOffset
		dwNewLong: anIntegerValue!

setWindowPosAfter: aWindow x: xInteger y: yInteger width: widthInteger height: heightInteger flags: flagsInteger
	"Private - Set the 'position' of the receiver. Answer whether the request
	succeeded."

	^UserLibrary default
		setWindowPos: handle
		hWndInsertAfter: aWindow asParameter
		x: xInteger
		y: yInteger
		cx: widthInteger
		cy: heightInteger
		uFlags: flagsInteger!

setWindowStyle: aDWORD
	"Private - Set the receiver's window style bits to aDWORD."

	UserLibrary default
		setWindowDWORD: handle
		nIndex: GWL_STYLE
		dwNewDWORD: aDWORD!

setWindowText: aString
	"Private - Sets the text of the receiver"

	^UserLibrary default setWindowText: handle lpString: aString!

setWndProc: anAddress
	"Private - Set the window procedure of the receiver to the argument, anAddress.
	Answer the old window procedure address."

	"Here we are overridding to subclass as Unicode, which enables the full Unicode character set to be used in static views."

	"Note that the compiler should optimise away the condition as VMConstants.IsWin64 is a constant value"

	^VMConstants.IsWin64
		ifTrue: 
			[UserLibrary default
				setWindowULongPtr: handle
				nIndex: GWL_WNDPROC
				dwNewLong: anAddress]
		ifFalse: 
			[UserLibrary default
				setWindowULong: handle
				nIndex: GWL_WNDPROC
				dwNewLong: anAddress]!

show
	"Makes the receiver visible."

	self isOpen ifFalse: [self create].
	self showWithStyle: self defaultShowStyle!

showShell
	"Private - Show the receiver within a shell"

	| shell |
	shell := ShellView new
				create;
				yourself.
	shell extent: (shell calcExtentFromClientExtent: self defaultExtent).
	shell layoutManager: GridLayout new.
	self parentView: shell.
	self create show.
	shell show!

showWithStyle: anInteger
	"Private - Makes this window appear with the required style.
	Answer whether the window was previously visible."

	anInteger == SW_HIDE ifFalse: [self invalidateLayoutDeeply].
	^UserLibrary default showWindow: handle nCmdShow: anInteger!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state.
	Implementation Note: We avoid saving unecessary window state by only recording 
	differences from the default state of a new View. This reduces the size of View resources
	and a saved image, and speeds up view restoration."

	| answer |
	answer := MessageSequence new.
	handle notNull
		ifTrue: 
			[| txt |
			answer add: (MessageSend
						receiver: self
						selector: #createAt:extent:
						arguments: {self position. self extent}).
			self isPersistentlyDisabled
				ifTrue: 
					[answer add: (MessageSend
								receiver: self
								selector: #isEnabled:
								argument: false)].
			self contextMenu isNil
				ifFalse: 
					["views do not have context menus by default"
					answer add: (MessageSend
								receiver: self
								selector: #contextMenu:
								argument: self contextMenu)].
			(txt := self text) notEmpty
				ifTrue: 
					["views have no text by default"
					answer add: (MessageSend
								receiver: self
								selector: #text:
								argument: txt)]].
	^answer!

state: aMessageSequence
	"Private - Restore the receiver to the state saved in the <MessageSequence> argument."

	aMessageSequence value!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler.
	Implementation Note: No need to override events collection with nil, as filed out as a proxy
	which will do that. Note, however, that (for performance reasons) STBViewProxy statically
	records the indices of certain instance variables here defined, and if new instance variables
	are added not only must the STBViewProxy conversion block be updated, but it may also
	be necessary to re-initialize STBViewProxy so the class variables are updated."

	anSTBOutFiler saveObject: self as: self filerProxy!

styles
	"Answer a two element Array containing the creation style bits for the receiver.
	See the comment under #style:"

	^creationStyle!

styles: aStyleArray 
	"Private - Sets the creation style bits for the receiver from the two element aStyleArray. 
	Windows seems to use the style bits as a rather confusing mixture of style and state (for example
	WS_VSCROLL is used at creation time to indicate whether a vertical scroll bar
	is required. Later it is used to indicate the actual presence of the bar). Here
	we save the style bits so they can later be used if the window needs re-creating"

	creationStyle := aStyleArray.
	handle isNil ifTrue: [^self].
	self setWindowStyle: self baseStyle.
	self setWindowExStyle: self extendedStyle!

subclassWindow
	"Private - Install the Dolphin VM's WndProc as the Window Procedure of the receiver's window.
	This is a helper function to be sent from View classes which need to be subclassed (e.g. 
	ControlViews) in order that messages are received and dispatched through the Dolphin WndProc.
	The previous window procedure is typically stored in an instance variable, since windows
	can be 'subclassed' on an instance specific basis, and we may be subclassing a window
	that has already been subclassed (!!)."

	| dolphinWndProc oldProc |
	dolphinWndProc := VMLibrary default getWndProc.
	(oldProc := self setWndProc: dolphinWndProc) = dolphinWndProc ifFalse: [self oldWndProc: oldProc]!

subclassWindow: hWnd
	"Private - Subclass the receiver's associated Win32 window, if necessary, by substituting the VM's 
	window procedure and saving the old one, and record hWnd as the handle of the receiver's window.
	Windows of Smalltalk registered classes (i.e. most windows apart from Windows controls) need only 
	record the handle passed by the VM (which has previously been instructed to hook the window create
	for the receiver).
	Implementation Note: This message is sent by the VM with asynchronous process switching disabled."

	self attachHandle: hWnd!

subViewFromPoint: aPoint
	"Answers the receiver's immediate subview beneath aPoint (in the receiver's coordinates)
	or nil if the receiver has no subview under that point.
	Implementation Note: Priority is given to non-transparent subviews, even if overlapped
	by transparent subviews."

	| viewFound |
	viewFound := self subViewFromPoint: aPoint
				flags: ##(CWP_SKIPTRANSPARENT | CWP_SKIPINVISIBLE | CWP_SKIPDISABLED).
	^viewFound 
		ifNil: 
			["Look for a transparent subview"
			self subViewFromPoint: aPoint flags: CWP_ALL]!

subViewFromPoint: aPoint flags: cwpFlags
	"Private - Answers the View in the receiver beneath aPoint (in the receivers coordinates)."

	| handleFound viewFound |
	handleFound := UserLibrary default
				childWindowFromPointEx: handle
				pt: aPoint asParameter
				uFlags: cwpFlags.
	^(handleFound notNil and: 
			[handleFound ~= self handle
				and: [(viewFound := self class withHandle: handleFound) notNil and: [viewFound isManaged]]])
		ifTrue: [viewFound]!

subViews
	"Answer a sequenceable collection of the sub views of the receiver in z-order sequence"

	| answer |
	answer := OrderedCollection new.
	self subViewsDo: [:each | answer addLast: each].
	^answer!

subViewsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's sub-views, in z-order
	sequence"

	| child userLib |
	userLib := UserLibrary default.
	child := userLib getWindow: handle uCmd: GW_HWNDCHILD.
	[child isNil] whileFalse: 
			[(View withHandle: child) ifNotNil: [:childView | aMonadicValuable value: childView].
			child := userLib getWindow: child uCmd: GW_HWNDNEXT]!

tabFirst
	"Set focus to the receiver"

	^self tabFocus!

tabFocus
	"Private - Sets focus to the receiver. Answers the View which previously had focus,
	or nil if none/invalid handle."

	^self setFocus!

tabNext
	"Tab to next control after the receiver in the tab order of the parent."

	| parent next |
	parent := self parentView.
	[parent notNil and: [next isNil]] whileTrue: [
		next := parent tabNextSiblingFrom: self forward: true.
		parent := parent parentView].
	next isNil ifFalse: [next tabFocus]!

tabNextSiblingFrom: aView forward: aBoolean
	"Private - Answer the next sibling view after aView in the TAB sequence of the receiver,
	or nil if there is none."

	"There seems to be a bug in GetNextDlgTabItem().
	If you ask for the next item after nil, it answers the first (as documented).
	But if you ask for the previous item before nil it doesn't answer the last.
	Instead, it answers nil. We handle this as a special case."

	| nextHandle nextView |
	(aView isNil and: [aBoolean not])
		ifTrue: 
			[| first |
			"Find the first item in the TAB sequence ..."
			first := UserLibrary default
						getNextDlgTabItem: handle
						hCtl: nil asParameter
						bPrevious: false.
			"... and then ask for the item before it.
			This will give us the last item."
			nextHandle := UserLibrary default
						getNextDlgTabItem: handle
						hCtl: first
						bPrevious: true]
		ifFalse: 
			[nextHandle := UserLibrary default
						getNextDlgTabItem: handle
						hCtl: aView asParameter
						bPrevious: aBoolean not].
	nextView := View fromHandle: nextHandle.
	nextView = aView ifTrue: [^nil].
	nextView = self ifTrue: [^nil].

	"There's another bug in GetNextDlgTabItem().
	If there are no TABSTOP children in a container, then the function answers an (arbitary)
	non-TABSTOP child."
	nextView isTabStop ifFalse: [^nil].
	^nextView!

text
	"Answers the text from the receiver.
	N.B. Some subclasses may answer RichText in response to this message,
	just as they accept RichText (or plain text) as the argument to #text: 
	to set their content. To get the plain, unformatted, text from any View, 
	you must send #plainText."

	^self plainText
!

text: text
	"Sets the text for the receiver to the argument, text 
	(either plain or RichText)."

	text setTextInto: self

!

textLength
	"Private - Answers the length of text for the receiver.
	Note that this will send a WM_GETTEXTLENGTH message to the receiver's
	window."

	^UserLibrary default getWindowTextLength: handle!

theme
	^self class theme!

themeSubAppName
	"Answer the theme class name to use for the view, or nil to use the default."

	^nil!

toolTipWindow
	"Private - Answer the WinToolTip for the receiver, or nil if one has not been set."

	^self propertyAt: #toolTipWindow ifAbsent: []!

toolTipWindow: aWinToolTip
	"Private - Set the tool tip for the receiver to aWinToolTip."

	self propertyAt: #toolTipWindow put: aWinToolTip!

topShell
	"Answer the eventual shell presenter located in the parent chain of the receiver.
	Note that this is a recursive implementation terminated by a different
	implementation in ShellView/DesktopView."

	^self parentView topShell	!

topView
	"Answer the top-most parent of the receiver"

	| topMost |
	topMost := self.
	[topMost isTopView] whileFalse: [topMost := topMost parentView].
	^topMost!

trackContextMenu: aPointEvent
	"Private - Shows and tracks a context menu for the receiver from the mouse position in
	aPointEvent. Answer nil if the receiver does not have a contextMenu to show, or a Boolean if
	it has."

	^self queryContextMenu 
		ifNotNil: 
			[:menu | 
			| pos |
		pos := aPointEvent position.
			pos = (-1 @ -1) ifTrue: [pos := self positionForKeyboardContextMenu].
		menu showIn: self position: pos.
			true]!

trackMouseHover: anInteger
	"Request that the system send a WM_MOUSEHOVER event should the user hover the mouse over the
	window for at least the specified <integer> number of milliseconds (if the argument is -1,
	then the system default hover time is used). The default handling for WM_MOUSEHOVER results
	in a mouseHovering: event being triggered off the receiver's presenter (see
	#onMouseHovering:)."

	| tme |
	tme := self queryMouseTracking.
	tme dwFlags: (tme dwFlags bitOr: TME_HOVER).
	tme dwHoverTime: anInteger.
	tme hwndTrack: handle.
	(UserLibrary default trackMouseEvent: tme) ifFalse: [UserLibrary default systemError]!

trackMouseLeave
	"Request that the system send a WM_MOUSELEAVE message when the mouse cursor leaves the
	window. This will result in a #mouseLeave: event being triggered off the receiver's
	presenter."

	"Note that this is single-shot event, and #trackMouseLeave must be called again when the
	mouse re-enters the window in order to get further WM_MOUSELEAVE messages. See the MSDN
	documentation for TrackMouseEvent() for further information."

	| tme |
	tme := self queryMouseTracking.
	tme dwFlags: (tme dwFlags bitOr: TME_LEAVE).
	tme hwndTrack: handle.
	UserLibrary default trackMouseEvent: tme!

unhookWindowCreate: hWnd
	"Private - Undo #hookWindowCreate. The VM auto-unhooks, but if the window
	create fails this needs to be called as the VM may not have received
	any messages. We unhook before raising any error."

	self primHookWindowCreate: false.
	hWnd isNull ifTrue: [^Win32Error signal: 'failed to create window']!

unregisterHotKeyId: id
	UserLibrary default
		registerHotKey: self handle
		id: id
		fsModifiers: 0
		vk: VK_CANCEL!

update
	"Repaint the receiver as necessary, immediately.
	N.B. This causes a callback as Windows sends a WM_PAINT directly."

	UserLibrary default updateWindow: handle!

updateModel
	"Flush changes in the view back to the associated model.
	Some views cache their edit changes and do not modify the 
	model data until the edit is complete. Such subclasses should
	override this method to update the model if there have been
	changes"
!

updateSetting: aSettingsChangeEvent
	(font isNil and: [aSettingsChangeEvent isFontChange]) ifTrue: [self fontChanged]!

usePreferredExtent
	"Answers true if the receiver's preferred extent should be used by a layout manager when
	laying out the contents of a container view containing the receiver"

	^flags anyMask: UsePreferredExtentMask!

usePreferredExtent: aBoolean
	"Set the receiver to use it's preferred extent during layout according to aBoolean"

	flags := flags mask: UsePreferredExtentMask set: aBoolean.
	self isOpen ifTrue: [self parentView invalidateLayout]!

validate
	"Validate the entire client area so that it will be not be re-painted"

	self validateRect: nil. !

validateLayout
	"Validates the layout for the receiver."

	self isLayoutValid ifTrue: [^self].
	self deferLayout: [:context | self validateLayout: context].!

validateLayout: aLayoutContext 
	"Private - Validate the receiver's layout using the specified <LayoutContext>."

	[self isLayoutValid] whileFalse: 
			[flags := flags maskSet: LayoutValidMask.
			self layout: aLayoutContext].
	self validateSubViewLayouts: aLayoutContext!

validateRect: rectangle
	"Validates the specified client rectangle (a RECTL, Rectangle, or nil for the whole client window).
	Answer whether the function succeeds."

	^UserLibrary default validate: handle lpRect: rectangle asParameter!

validateSubViewLayouts: aLayoutContext 
	"Private - Validate the layout of the visible sub-views of the receiver."

	!

validateUserInterface
	"Validates the user interface for the receiver. Usually performed at idle time
	when the UI has been flagged as being invalid"

	!

view
	"Answer the view associated with the receiver. Part of the <presenter>
	protocol used when the receiver is in fact its own presenter"

	^self!

viewNamed: aString
	"Answer the sub-view within the receiver's hierarchy with aString as its
	name. Signals a NotFoundError if no matching named view exists."

	^self viewNamed: aString ifNone: [self errorNotFound: aString]!

viewNamed: aString ifNone: aBlock
	"Answer the sub-view within the receiver's hierarchy with aString as its
	name. Evaluates aBlock if no matching named view exists. Elementary views
	have no named sub views"

	^aBlock value!

whileInvisibleDo: aNiladicValuable 
	| wasVisible |
	wasVisible := self hasVisibleStyle: false.
	^aNiladicValuable ensure: [self hasVisibleStyle: wasVisible]!

width
	"Answer the width of the receiver's outer window."

	^self getWindowRect width!

width: anInteger
	"Sets the width of the receiver's outer window to anInteger."

	self extent: anInteger @ self height
!

windowName
	^''!

winFinalize
	"Private - Perform finalization actions for this view on destruction of the associated Window.
	Implementation Note: We don't release events/dependents if the view is being destroyed
	as the result of a recreate (noted by the state restoring flag being set), and also we don't
	nil the handle at this stage because it may be required to complete processing of the
	destroy message that caused this finalization."

	self freeTheme.
	self isStateRestoring ifFalse: [self release].
	SessionManager inputState removeWindowAt: handle!

withAllParents
	"Answer an <sequencedReadableCollection> of self and all its parent Views, in inverse hierarchy order."

	| answer |
	answer := OrderedCollection new.
	self withAllParentsDo: [:each | answer addLast: each].
	^answer!

withAllParentsDo: aMonadicValuable 
	"Evaluate the <monadicValuable> argument for the receiver and each of the its parent views,
	including, ultimately, the desktop."

	self isOpen ifFalse: [^self].
	aMonadicValuable value: self.
	self parentView withAllParentsDo: aMonadicValuable!

withAllSubViews
	"Answer an OrderedCollection of self and all its sub views."

	| answer |
	answer := OrderedCollection with: self.
	self allSubViewsDo: [:each | answer addLast: each].
	^answer!

withAllSubViewsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for the receiver and all of its sub views."

	aMonadicValuable value: self.
	self allSubViewsDo: aMonadicValuable.
!

wmActivate: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_ACTIVATE.
	Answer nil to accept default window processing."

	^nil!

wmActivateApp: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_ACTIVATEAPP.
	Answer nil to accept default window processing."

	^nil!

wmCancelMode: message wParam: wParam lParam: lParam
	"Private - Default handler for WM_CANCELMODE"

	^nil
!

wmCaptureChanged: message wParam: wParam lParam: lParam
	"Private - Default handler for WM_CAPTURECHANGED."

	^self interactor onCaptureChanged: (self class withHandle: lParam)!

wmChar: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_CHAR. Forward to the receiver #onKeyTyped: handler
	which should answer a non-Integer/non-Boolean value if it wants to accept
	the default processing for the message."

	^self interactor onKeyTyped: (KeyEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmClose: message wParam: wParam lParam: lParam
	"Private - This window has been asked to close, answer whether or not it accepts the request."

	^self presenter onCloseRequested!

wmCommand: message wParam: wParam lParam: lParam
	"Private - Handles a WM_COMMAND message. These can originate in a variety of ways each with slightly different
	processing requirements as follows:
		Control notifications commands		-	Pass onto the control window via #command:
		Pull down menu commmand		-	Pass onto focus window via #onCommand:
		Context menu command			- 	Pass onto receiver window via #onCommand:"

	| id |
	id := wParam lowWord.
	^lParam isNull
		ifTrue: 
			[| foundCommand |
			"Check for context menus"
			(foundCommand := CommandDescription withId: id ifAbsent: []) notNil
				ifTrue: [self onCommand: foundCommand]
				ifFalse: 
					["accept the default processing"
					]]
		ifFalse: 
			[| control |
			"Command notification from a control."
			control := self class withHandle: lParam.
			control notNil
				ifTrue: [control command: wParam highWord id: id]
				ifFalse: 
					["accept the default processing"
					]]!

wmContextMenu: message wParam: wParam lParam: lParam
	"Private - Shows and tracks a context menu for the receiver"

	^self trackContextMenu: (PointEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmCreate: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_CREATE."

	| event |
	interactor isNil
		ifTrue: 
			["Necessary for some old resources"
			interactor := self presenter].
	event := WindowsEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam.
	self onCreated: event.
	^event defaultWindowProcessing!

wmCtlColor: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_CTLCOLORXXX family of messages. This is sent to the
	parent of the control, but we reflect it back to the ControlView to which it actually
	relates."

	^(self class withHandle: lParam)
		ifNotNil: 
			[:window |
			"Note that the event has the handle of the original (parent) window to which the message was sent."
			window onColorRequired: (ColorEvent
						window: self
						message: message
						wParam: wParam
						lParam: lParam)]!

wmDestroy: message wParam: wParam lParam: lParam
	"Private - This receiver is being destroyed."

	^self onDestroyed!

wmDrawItem: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_DRAWITEM."

	| struct |
	struct := DRAWITEMSTRUCT fromAddress: lParam.
	^struct CtlType == ODT_MENU
		ifTrue: [self onDrawMenuItem: struct]
		ifFalse: 
			[(self class withHandle: struct hwndItem)
				ifNotNil: [:destinationWindow | destinationWindow onDrawItem: struct]]!

wmEnterIdle: message wParam: wParam lParam: lParam
	"Private - Default handler for WM_ENTERIDLE.
	The intent of the sleep here is to give background tasks a change to run when Windows
	is performing some task (such as displaying a common dialog box) which steals all
	of Dolphin's cycles."

	"We'll try disrupting the user's menu activities too, and see how it
	works out, if there's a problem, re-enable this line.!!!!"

	"wParam = MSGF_MENU ifTrue: [^nil]."

	SessionManager inputState enterIdle.
	^0!

wmEnterMenuLoop: message wParam: wParam lParam: lParam
	"Private - The system has entered the modal menu loop."

	"Implementation Note: The menu loop steals all our processor cycles, and it doesn't even
	send WM_ENTERIDLE messages unless the mouse is moved. This means that if a menu is popped,
	the entire system grinds to a halt. To prevent this happening we schedule a special timer
	while the menu loop is active. Be warned, this uses a magic number for the timer
	(WM_ENTERIDLE = 289). The timer fires every 1/10th of a second."

	SessionManager inputState startIdleTimer: self.
	^nil!

wmEraseBkGnd: message wParam: wParam lParam: lParam
	"Private - Handle the WM_ERASEBKGND message from Windows. This is sent to clear an area of
	a window during a repaint (normally when BeginPaint() is called)."

	"self ensureLayoutValid."

	^self onEraseRequired: (ColorEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmExitMenuLoop: message wParam: wParam lParam: lParam
	"Private - The system has exited the modal menu loop. 
	Implementation Note: See wmEnterMenuLoop:&c. We must ensure the idle
	kick timer is killed."

	SessionManager inputState stopIdleTimer: self.
	^nil!

wmGetDlgCode: message wParam: wParam lParam: aMSGAddress
	"Private - Low-level handler for a WM_GETDLGCODE sent by Windows to determine what
	input a particular window would like (usually when the window receivers focus).
	The lParam is a pointer to the MSG that may be sent depending on the response.
	The answer should be some combination of DLGC_XXXX flags (e.g. DLGC_WANTARROWS |
	DLGC_WANTTAB)."

	^self presenter onInputMaskRequired: (WindowsEvent
				window: self
				message: message
				wParam: wParam
				lParam: aMSGAddress)!

wmGetMinMaxInfo: message wParam: wParam lParam: lParam 
	"Private - Default handler for a WM_GETMINMAXINFO message."

	^nil!

wmHotKey: message wParam: wParam lParam: lParam 
	"Private - Default handler for a WM_HOTKEY event. The <integer>, wParam, identifies the hot
	key registration."

	^self presenter onHotKey: wParam!

wmHScroll: message wParam: wParam lParam: lParam
	"Private - A vertical Scroll event has occured. Pass onto receivers controller. Have to check
	whether the event came from a standard scrool bar or a scroll bar controller."

	^(lParam == 0 ifTrue: [self] ifFalse: [SessionManager inputState windowAt: lParam ifAbsent: []])
		ifNotNil: 
			[:window |
			window onHScroll: (ScrollEvent
						window: self
						message: message
						wParam: wParam
						lParam: lParam)]!

wmInitMenu: message wParam: wParam lParam: lParam
	"Private - Default handler for initializing bar menus to screen.
	Answer nil to accept default window processing as this is
	relevant only to <ShellView>s."

	^nil

!

wmInitMenuPopup: message wParam: wParam lParam: lParam
	"Private - Context menu or sub-menu can update its state on screen to reflect the
	current event target."

	| ctxtMenu subMenu |
	lParam highWord ~= 0 ifTrue: [^nil "default processing for system menus" ].
	^((ctxtMenu := self queryContextMenu) notNil 
			and: [(subMenu := ctxtMenu menuFromHandle: wParam) notNil])
		ifTrue: [subMenu queryAllFromView: self].
!

wmInputLangChange: message wParam: wParam lParam: lParam
	"Private - Handle the Win32 WM_INPUTLANGCHANGE message."

	^self presenter onInputLanguageChanged: (WindowsEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmKeyDown: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_KEYDOWN."

	^self interactor onKeyPressed: (KeyEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmKeyUp: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_KEYUP."

	^self interactor onKeyReleased: (KeyEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmKillFocus: message wParam: wParam lParam: lParam
	"Private - This window is losing focus"

	^self presenter onKillFocus!

wmLButtonDblClk: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_LBUTTONDBLCLK event."

	^self interactor onLeftButtonDoubleClicked: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmLButtonDown: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_LBUTTONDOWN event."

	^self interactor onLeftButtonPressed: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmLButtonUp: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_LBUTTONUP event."

	^self interactor onLeftButtonReleased: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmMButtonDblClk: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_MBUTTONDBLCLICK event."

	^self interactor onMiddleButtonDoubleClicked: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmMButtonDown: message wParam: wParam lParam: lParam
	^self interactor onMiddleButtonPressed: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmMButtonUp: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_MBUTTONUP event."

	^self interactor onMiddleButtonReleased: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmMeasureItem: message wParam: wParam lParam: lParam
	| struct extent |
	struct := MEASUREITEMSTRUCT fromAddress: lParam.
	struct CtlType == ODT_MENU ifFalse: [^nil].
	extent := SystemMetrics current menuImageExtent.
	struct itemWidth: extent x + SystemMetrics current menuImageTextGap.
	struct itemHeight: extent y.
	^TRUE!

wmMenuCommand: message wParam: wParam lParam: lParam
	"Private - Handles a WM_MENUCOMMAND message."

	^nil!

wmMouseHover: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_MOUSEHOVER event."

	^self interactor onMouseHovering: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmMouseHWheel: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_MOUSEHWHEEL event."

	^self interactor onMouseWheeled: (MouseWheelEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmMouseLeave: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_MOUSELEAVE event."

	^self interactor onMouseLeave: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmMouseMove: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_MOUSEMOVE event."

	^self interactor onMouseMoved: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmMouseWheel: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_MOUSEWHEEL event."

	^self interactor onMouseWheeled: (MouseWheelEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmNcActivate: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_NCACTIVATE.
	Answer nil to accept default window processing."

	^nil!

wmNcCalcSize: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_NCCALCSIZE message. 
	See MSDN for further information about this rather complex Windows message."

	^nil
!

wmNcCreate: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_NCCREATE. 
	Answer nil to accept default window processing."

	^nil
!

wmNcDestroy: message wParam: wParam lParam: lParam 
	"Private - Notification that a window is about to disappear so we
 	remove it from our management."

	| answer |
	self presenter onViewDestroyed.
	self winFinalize.
	answer := self 
				defaultWindowProcessing: message
				wParam: wParam
				lParam: lParam.
	self clearHandle.
	self isStateRestoring ifFalse: [interactor := creationParent := presenter := DeafObject.Current].	"If not being recreated, discard the presenter"
	^answer!

wmNcHitTest: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_NCHITTEST. 
	Answer nil to accept default window processing."

	^nil
!

wmNcPaint: message wParam: wParam lParam: lParam 
	"Private - This window non-client area requires painting. 
	Do not set a breakpoint in this or subordinate methods, and beware errors!!"

	^self 
		defaultWindowProcessing: message
		wParam: wParam
		lParam: lParam!

wmNotify: message wParam: wParam lParam: lParam
	"Private - Redirects WM_NOTIFY messages to the appropriate control as a notify message."

	"Implementation Note: Rather than create a structure here, we just treat as an address as notifications
	 are very frequent and mostly ignored."

	| pNMHdr |
	^(self class withHandle: ((pNMHdr := VMLibrary default addressFromInteger: lParam) dwordAtOffset: 0))
		ifNotNil: [:control | control nmNotify: pNMHdr]!

wmPaint: message wParam: wParam lParam: lParam
	"Private - This window requires painting. By default we use the internal painting
	 dispatch."

	self ensureLayoutValid.
	^self basicPaint: message wParam: wParam lParam: lParam

!

wmParentNotify: message wParam: wParam lParam: lParam 
	"Private - This window received a notification from one of its children"

	^nil!

wmPrint: message wParam: wParam lParam: lParam 
	self ensureLayoutValid.
	^nil!

wmPrintClient: message wParam: wParam lParam: lParam
	self ensureLayoutValid.
	^self onPaintRequired: (PaintEvent
				window: self
				wParam: 0
				hdc: wParam
				paintStruct: nil)!

wmQueryEndSession: message wParam: wParam lParam: lParam
	"Private - This system is shutting down, answer false if we'd rather it didn't"

	^SessionManager current onQueryWindowsShutdown!

wmRButtonDblClk: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_RBUTTONDBLCLICK."

	^self interactor onRightButtonDoubleClicked: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmRButtonDown: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_RBUTTONDOWN."

	^self interactor onRightButtonPressed: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmRButtonUp: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_RBUTTONUP."

	^self interactor onRightButtonReleased: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmSetCursor: message wParam: wParam lParam: lParam
	"Private - Handle the Win32 WM_SETCURSOR message."

	| myCursor hitType |
	hitType := #(#transparent #nowhere #client #caption #sysMenu #size #menu #hscroll #vscroll #minimize #maximize #left #right #top #topLeft #topRight #bottom #bottomLeft #bottomRight #border #object #close #help) 
				at: lParam lowPartSigned + 2
				ifAbsent: [#error].
	myCursor := self interactor onGetCursor: hitType.
	^myCursor isNil 
		ifFalse: 
			[myCursor setCursor.
			true]!

wmSetFocus: message wParam: wParam lParam: lParam
	"Private - This window is getting focus."

	^self presenter onSetFocus!

wmSettingChange: message wParam: wParam lParam: lParam
	"Private - Handle the Win32 WM_SETTINGCHANGE message."

	"Should only be received by top-level windows."
	^nil!

wmShowWindow: message wParam: wParam lParam: lParam
	"Private - The receiver window is being shown (i.e. made visible)."

	^nil!

wmSize: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_SIZE (window resized) message.
	As of Dolphin 3.0 this event is largely superceeded by WM_WINDOWPOSCHANGING,
	and in fact it is suppressed by the default handler for that event."

	^nil!

wmSysChar: message wParam: wParam lParam: lParam
	"Private - Handles a WM_SYSCHARmessage. From MSDN:

	The WM_SYSCHAR message is posted to the window with the keyboard focus when a WM_SYSKEYDOWN
	message is translated by the TranslateMessage function. It specifies the character code of a
	system character key that is, a character key that is pressed while the ALT key is down. "

	^self interactor onSysKeyTyped: (KeyEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmSysColorChange: message wParam: wParam lParam: lParam
	"Private - A system color change has occurred. Forward the message to all children in case any are
	common controls (see Win32 help)."

	self subViewsDo: [:child | child sendMessage: message wParam: wParam lParam: lParam].
	^nil!

wmSysCommand: message wParam: wParam lParam: lParam 
	"Private - Handles a WM_SYSCOMMAND message. "

	^nil!

wmSysDeadChar: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_SYSDEADCHAR.
	Answer nil to accept default window processing."

	^nil!

wmSysKeyDown: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_SYSKEYDOWN."

	^self interactor onSysKeyPressed: (KeyEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmSysKeyUp: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_SYSKEYUP."

	^self interactor onSysKeyReleased: (KeyEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmThemeChanged: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_THEMECHANGED message from Windows."

	self freeTheme.
	self class freeTheme.
	self openTheme.
	"Let the control see the theme change event too, otherwise it will not change style"
	^nil!

wmTimeChange: message wParam: wParam lParam: lParam
	"Private - Handle the Win32 WM_TIMECHANGE message."

	"Should only be received by top-level windows."
	^nil!

wmTimer: message wParam: wParam lParam: lParam
	"Private - A timer event, identified by the <integer> id, wParam, has fired."

	wParam == WM_ENTERIDLE
		ifTrue: 
			["Simulated WM_ENTERIDLE fired when menus popped"
			SessionManager inputState enterIdle.
			^0].
	self presenter trigger: #timerTick: with: wParam.
	^nil!

wmVScroll: message wParam: wParam lParam: lParam
	"Private - A vertical Scroll event has occured. Pass onto the receivers controller. Have to check
	whether the event came from a standard scroll bar or a scroll bar controller."

	^(lParam == 0 ifTrue: [self] ifFalse: [SessionManager inputState windowAt: lParam ifAbsent: []])
		ifNotNil: 
			[:window |
			window onVScroll: (ScrollEvent
						window: self
						message: message
						wParam: wParam
						lParam: lParam)]!

wmWindowPosChanged: message wParam: wParam lParam: lParam
	"Private - The position of the receiver has changed in some manner."

	self isStateRestoring
		ifFalse: 
			[self presenter onPositionChanged: (PositionEvent
						window: self
						message: message
						wParam: wParam
						lParam: lParam)].
	"Ignore any return value from the high-level event, and answer 0 to 
	prevent the DefWindowProc being invoked, which in turn prevents
	WM_SIZE and WM_MOVE which we don't use anymore"
	^0!

wmWindowPosChanging: message wParam: wParam lParam: lParam
	"Private - The position of the receiver is about to change in some manner."

	^self isStateRestoring
		ifFalse: 
			[self presenter onPositionChanging: (PositionEvent
						window: self
						message: message
						wParam: wParam
						lParam: lParam)]!

wmXButtonDblClk: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_XBUTTONDBLCLICK event."

	^self interactor onXButtonDoubleClicked: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmXButtonDown: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_XBUTTONDOWN event."

	^self interactor onXButtonPressed: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

wmXButtonUp: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_XBUTTONUP event."

	^self interactor onXButtonReleased: (MouseEvent
				window: self
				message: message
				wParam: wParam
				lParam: lParam)!

x
	"Answer the left coordinate of the receiver in the coordinate system of the parent."

	^self rectangle left!

x: anInteger
	"Sets the left edge position of the receiver to anInteger."

	self position: (anInteger @ self y)!

y
	"Answer the top coordinate of the receiver in the coordinate system of the parent."

	^self rectangle top!

y: anInteger
	"Sets the top edge position of the receiver to anInteger."

	self position: (self x @ anInteger)!

zOrderAfter: aViewOrNil
	"Change the receiver's Z-order without affecting any other aspects of its
	position, size, or activation."

	self zOrderAfter: aViewOrNil withFlags: SWP_NOACTIVATE !

zOrderAfter: aViewOrNil withFlags: anInteger
	"Calls the SetWindowPos() API function to set the receiver's Z order.
	The flags specified by anInteger are ORed with (SWP_NOSIZE | SWP_NOMOVE)."

	aViewOrNil isNil
		ifTrue: [ self zOrderTop ]
		ifFalse: [ self setWindowPosAfter: aViewOrNil asParameter
			x: 0 y: 0 width: 0 height: 0 
			flags: (anInteger bitOr: ##(SWP_NOSIZE | SWP_NOMOVE)).
			self parentView onZOrderChanged ]!

zOrderBottom
	"Places the receiver at the bottom of the Z order. If the receiver is a topmost window,
	it loses its topmost status and is placed at the bottom of all other windows."

	self zOrderAfter: HWND_BOTTOM.!

zOrderTop
	"Brings the receiver to the top of the Z order.
	If the receiver is a top-level window, it is activated.
	If the receiver is a child window, the top-level parent view associated with the child is activated."

	UserLibrary default bringWindowToTop: handle.
	self parentView onZOrderChanged! !
!UI.View categoriesFor: #actualBackcolor!accessing!private! !
!UI.View categoriesFor: #actualFont!accessing!private! !
!UI.View categoriesFor: #actualPreferredExtent:!geometry!private! !
!UI.View categoriesFor: #addSubView:!hierarchy!public!sub views! !
!UI.View categoriesFor: #addToCommandRoute:!commands!public! !
!UI.View categoriesFor: #addToImageList:mask:!double dispatch!private! !
!UI.View categoriesFor: #adjustRectangle:!geometry!public! !
!UI.View categoriesFor: #allParents!hierarchy!public! !
!UI.View categoriesFor: #allParentsDo:!hierarchy!public! !
!UI.View categoriesFor: #allSubViews!hierarchy!public! !
!UI.View categoriesFor: #allSubViewsDo:!hierarchy!public! !
!UI.View categoriesFor: #ambientBackcolor!accessing!private! !
!UI.View categoriesFor: #arrangement!accessing!public! !
!UI.View categoriesFor: #arrangement:!accessing!public! !
!UI.View categoriesFor: #asParameter!converting!public! !
!UI.View categoriesFor: #attachHandle:!private!realizing/unrealizing! !
!UI.View categoriesFor: #backcolor!accessing!public! !
!UI.View categoriesFor: #backcolor:!accessing!public! !
!UI.View categoriesFor: #backcolorChanged!helpers!private! !
!UI.View categoriesFor: #baseCreationStyle!private!realizing/unrealizing! !
!UI.View categoriesFor: #baseStyle!accessing-styles!private! !
!UI.View categoriesFor: #baseStyle:!accessing-styles!private! !
!UI.View categoriesFor: #baseStyle:maskedBy:!accessing-styles!private! !
!UI.View categoriesFor: #baseStyle:maskedBy:recreateIfChanged:!accessing-styles!private! !
!UI.View categoriesFor: #baseStyleAllMask:!accessing-styles!private! !
!UI.View categoriesFor: #baseStyleMask:set:!accessing-styles!private! !
!UI.View categoriesFor: #baseStyleMask:set:recreateIfChanged:!accessing-styles!private! !
!UI.View categoriesFor: #basicActualBackcolor!accessing!private! !
!UI.View categoriesFor: #basicAddSubView:!hierarchy!private!sub views! !
!UI.View categoriesFor: #basicCreateAt:extent:!private!realizing/unrealizing! !
!UI.View categoriesFor: #basicDestroy!private!realizing/unrealizing! !
!UI.View categoriesFor: #basicInvalidateLayout!geometry!private! !
!UI.View categoriesFor: #basicPaint:wParam:lParam:!drawing!private! !
!UI.View categoriesFor: #beActive!operations!public! !
!UI.View categoriesFor: #beCentered!operations!public! !
!UI.View categoriesFor: #beDefaultThemed!modes!public! !
!UI.View categoriesFor: #beForeground!operations!public! !
!UI.View categoriesFor: #beNotThemed!modes!public!wine fix! !
!UI.View categoriesFor: #beNotTopMost!operations!public! !
!UI.View categoriesFor: #bePopupFor:!operations!public! !
!UI.View categoriesFor: #beTopMost!operations!public! !
!UI.View categoriesFor: #binaryStoreOn:!binary filing!public! !
!UI.View categoriesFor: #bmSetStyle:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #calcClientRectangleFromRectangle:!geometry!private! !
!UI.View categoriesFor: #calcExtentFromClientExtent:!geometry!private! !
!UI.View categoriesFor: #calcRectangleFromClientRectangle:!geometry!private! !
!UI.View categoriesFor: #calculateExtent!geometry!private! !
!UI.View categoriesFor: #calculateExtent:!geometry!private! !
!UI.View categoriesFor: #canAcceptSubViews!hierarchy!public!sub views!testing! !
!UI.View categoriesFor: #canvas!drawing!public! !
!UI.View categoriesFor: #centerExtent:within:!geometry!private! !
!UI.View categoriesFor: #clearHandle!private!realizing/unrealizing! !
!UI.View categoriesFor: #clearStateRestoring!helpers!private! !
!UI.View categoriesFor: #clientExtent!geometry!public! !
!UI.View categoriesFor: #clientHeight!geometry!public! !
!UI.View categoriesFor: #clientRectangle!geometry!public! !
!UI.View categoriesFor: #clientWidth!geometry!public! !
!UI.View categoriesFor: #clipChildren!accessing-styles!public! !
!UI.View categoriesFor: #clipChildren:!accessing-styles!public! !
!UI.View categoriesFor: #close!public!realizing/unrealizing! !
!UI.View categoriesFor: #command:id:!commands!private! !
!UI.View categoriesFor: #commandPolicy!commands!public! !
!UI.View categoriesFor: #commandSource!accessing!public! !
!UI.View categoriesFor: #connectModel!models!public! !
!UI.View categoriesFor: #contextMenu!menus!public! !
!UI.View categoriesFor: #contextMenu:!menus!public! !
!UI.View categoriesFor: #create!private!realizing/unrealizing! !
!UI.View categoriesFor: #createAt:extent:!private!realizing/unrealizing! !
!UI.View categoriesFor: #creationParentView!accessing!private! !
!UI.View categoriesFor: #cursor!constants!public! !
!UI.View categoriesFor: #cursorPosition!accessing!public! !
!UI.View categoriesFor: #ddCut:!drag & drop!private! !
!UI.View categoriesFor: #ddDrop:!drag & drop!private! !
!UI.View categoriesFor: #ddEnter:!drag & drop!private! !
!UI.View categoriesFor: #ddGetImages:!drag & drop!private! !
!UI.View categoriesFor: #ddGetObjects:!drag & drop!private! !
!UI.View categoriesFor: #ddLeave:!drag & drop!private! !
!UI.View categoriesFor: #ddOperations:!drag & drop!private! !
!UI.View categoriesFor: #ddOver:!drag & drop!private! !
!UI.View categoriesFor: #ddScroll:!drag & drop!private! !
!UI.View categoriesFor: #defaultBackcolor!colors!constants!private! !
!UI.View categoriesFor: #defaultExtent!constants!private! !
!UI.View categoriesFor: #defaultId!accessing!private! !
!UI.View categoriesFor: #defaultPositionWithin:forExtent:!geometry!private! !
!UI.View categoriesFor: #defaultProportion!constants!private! !
!UI.View categoriesFor: #defaultShowStyle!constants!private! !
!UI.View categoriesFor: #defaultStyle!constants!private! !
!UI.View categoriesFor: #defaultWindowExStyle!constants!private! !
!UI.View categoriesFor: #defaultWindowProcessing:wParam:lParam:!dispatching!private! !
!UI.View categoriesFor: #defaultWindowStyle!constants!private! !
!UI.View categoriesFor: #deferLayout:!constants!private! !
!UI.View categoriesFor: #destroy!public!realizing/unrealizing! !
!UI.View categoriesFor: #disable!operations!public! !
!UI.View categoriesFor: #disableRedraw!drawing!public! !
!UI.View categoriesFor: #disconnectFromModel!operations!private! !
!UI.View categoriesFor: #dispatchMessage:wParam:lParam:!dispatching!private! !
!UI.View categoriesFor: #dispatchRegistered:wParam:lParam:!dispatching!private! !
!UI.View categoriesFor: #dispatchUser:wParam:lParam:!dispatching!private! !
!UI.View categoriesFor: #dispatchUser:wParam:lParam:map:!dispatching!private! !
!UI.View categoriesFor: #displayOn:!displaying!public! !
!UI.View categoriesFor: #displayOnFormats!displaying!private! !
!UI.View categoriesFor: #displayOnMaxCharacters!constants!displaying!private! !
!UI.View categoriesFor: #dragCut:!drag & drop!public! !
!UI.View categoriesFor: #dragDropSessionClass!constants!public! !
!UI.View categoriesFor: #dragEnter:!drag & drop!public! !
!UI.View categoriesFor: #dragLeave:!drag & drop!public! !
!UI.View categoriesFor: #dragOver:!drag & drop!public! !
!UI.View categoriesFor: #drawFocusRect:!drawing!public! !
!UI.View categoriesFor: #drop:!drag & drop!public! !
!UI.View categoriesFor: #enable!operations!public! !
!UI.View categoriesFor: #enableRedraw!drawing!public! !
!UI.View categoriesFor: #ensureLayoutValid!geometry!public! !
!UI.View categoriesFor: #ensureRectangleVisible:!public!updating! !
!UI.View categoriesFor: #ensureSubView:rectangleVisible:!private!updating! !
!UI.View categoriesFor: #ensureSubViewVisible:!public!sub views! !
!UI.View categoriesFor: #ensureVisible!accessing!public! !
!UI.View categoriesFor: #enterIdle!event handling-win32!private! !
!UI.View categoriesFor: #eraseParentBackground:!event handling!private! !
!UI.View categoriesFor: #exStyle:maskedBy:!accessing-styles!private! !
!UI.View categoriesFor: #exStyle:maskedBy:recreateIfChanged:!accessing-styles!private! !
!UI.View categoriesFor: #exStyleAllMask:!accessing-styles!private! !
!UI.View categoriesFor: #exStyleMask:set:!accessing-styles!private! !
!UI.View categoriesFor: #exStyleMask:set:recreateIfChanged:!accessing-styles!private! !
!UI.View categoriesFor: #extendedStyle!accessing-styles!private! !
!UI.View categoriesFor: #extendedStyle:!accessing-styles!private! !
!UI.View categoriesFor: #extent!geometry!public! !
!UI.View categoriesFor: #extent:!geometry!public! !
!UI.View categoriesFor: #filerProxy!binary filing!private! !
!UI.View categoriesFor: #findItemHandle:ifAbsent:!hierarchy!private! !
!UI.View categoriesFor: #findMatch:inRange:!private!searching & replacing! !
!UI.View categoriesFor: #firstSubView!hierarchy!public!sub views! !
!UI.View categoriesFor: #flash:!operations!public! !
!UI.View categoriesFor: #font!accessing!public! !
!UI.View categoriesFor: #font:!accessing!public! !
!UI.View categoriesFor: #fontChanged!private!updating! !
!UI.View categoriesFor: #forecolor!accessing!public! !
!UI.View categoriesFor: #forecolor:!accessing!public! !
!UI.View categoriesFor: #forecolorChanged!private!updating! !
!UI.View categoriesFor: #frameChanged!helpers!private! !
!UI.View categoriesFor: #frameWidths!accessing!public! !
!UI.View categoriesFor: #freeTheme!private!theming! !
!UI.View categoriesFor: #getDC!accessing!public! !
!UI.View categoriesFor: #getEvents!events!private! !
!UI.View categoriesFor: #getFileLocator!accessing!private! !
!UI.View categoriesFor: #getFirstChild!hierarchy!private!sub views! !
!UI.View categoriesFor: #getItem:!hierarchy!private! !
!UI.View categoriesFor: #getItem:ifAbsent:!hierarchy!private! !
!UI.View categoriesFor: #getItemHandle:ifAbsent:!hierarchy!private! !
!UI.View categoriesFor: #getNoRedrawCount!private! !
!UI.View categoriesFor: #getParent!hierarchy!private! !
!UI.View categoriesFor: #getPreviousSibling!hierarchy!private! !
!UI.View categoriesFor: #getScrollInfo:bar:!accessing!private! !
!UI.View categoriesFor: #getWindow:!hierarchy!private! !
!UI.View categoriesFor: #getWindowDC!drawing!private! !
!UI.View categoriesFor: #getWindowExStyle!accessing-styles!private! !
!UI.View categoriesFor: #getWindowLong:!accessing!private! !
!UI.View categoriesFor: #getWindowLongPtr:!accessing!private! !
!UI.View categoriesFor: #getWindowRect!geometry!private! !
!UI.View categoriesFor: #getWindowStyle!accessing-styles!private! !
!UI.View categoriesFor: #getWindowText!accessing!private! !
!UI.View categoriesFor: #getWndProc!accessing!private! !
!UI.View categoriesFor: #handle!accessing!private! !
!UI.View categoriesFor: #handle:!accessing!private! !
!UI.View categoriesFor: #hasBorder!accessing-styles!public! !
!UI.View categoriesFor: #hasBorder:!accessing-styles!public! !
!UI.View categoriesFor: #hasCapture!public!testing! !
!UI.View categoriesFor: #hasClientEdge!accessing-styles!public! !
!UI.View categoriesFor: #hasClientEdge:!accessing-styles!public! !
!UI.View categoriesFor: #hasFixedHeight!public!testing! !
!UI.View categoriesFor: #hasFixedWidth!public!testing! !
!UI.View categoriesFor: #hasFocus!public!testing! !
!UI.View categoriesFor: #hasFocusDeeply!public!testing! !
!UI.View categoriesFor: #hasLayoutManager!public!testing! !
!UI.View categoriesFor: #hasMenu!private!testing! !
!UI.View categoriesFor: #hasStaticEdge!accessing-styles!public! !
!UI.View categoriesFor: #hasStaticEdge:!accessing-styles!public! !
!UI.View categoriesFor: #hasTransparentBackground!private!testing! !
!UI.View categoriesFor: #hasView!presenter!private! !
!UI.View categoriesFor: #hasVisibleStyle!public!testing! !
!UI.View categoriesFor: #hasVisibleStyle:!public!testing! !
!UI.View categoriesFor: #height!geometry!public! !
!UI.View categoriesFor: #height:!geometry!public! !
!UI.View categoriesFor: #helpId!accessing!public! !
!UI.View categoriesFor: #hide!operations!public! !
!UI.View categoriesFor: #hookWindowCreate!operations!private! !
!UI.View categoriesFor: #id!accessing!public! !
!UI.View categoriesFor: #id:!accessing!public! !
!UI.View categoriesFor: #inheritContextMenu!public!testing! !
!UI.View categoriesFor: #inheritContextMenu:!accessing!public! !
!UI.View categoriesFor: #initialize!initializing!private! !
!UI.View categoriesFor: #initializeModel!accessing!private! !
!UI.View categoriesFor: #interactor!accessing!public! !
!UI.View categoriesFor: #interactor:!accessing!public! !
!UI.View categoriesFor: #invalidate!drawing!public! !
!UI.View categoriesFor: #invalidateCalculatedExtent!geometry!public! !
!UI.View categoriesFor: #invalidateLayout!geometry!public! !
!UI.View categoriesFor: #invalidateLayoutDeeply!public!updating! !
!UI.View categoriesFor: #invalidateRect:!drawing!public! !
!UI.View categoriesFor: #invalidateRect:erase:!drawing!public! !
!UI.View categoriesFor: #invalidateRgn:!drawing!public! !
!UI.View categoriesFor: #invalidateRgn:erase:!drawing!public! !
!UI.View categoriesFor: #invalidateUserInterface!accessing!public! !
!UI.View categoriesFor: #isActive!public!testing! !
!UI.View categoriesFor: #isDialogMessage:!dispatching!private! !
!UI.View categoriesFor: #isDolphinWindow!private!testing! !
!UI.View categoriesFor: #isDragSource!private!testing! !
!UI.View categoriesFor: #isDragSource:!accessing!public! !
!UI.View categoriesFor: #isDropTarget!private!testing! !
!UI.View categoriesFor: #isDropTarget:!accessing!public! !
!UI.View categoriesFor: #isEnabled!public!testing! !
!UI.View categoriesFor: #isEnabled:!accessing!public! !
!UI.View categoriesFor: #isEnabledDeeply:!accessing!public! !
!UI.View categoriesFor: #isForeground!public!testing! !
!UI.View categoriesFor: #isGroupStop!accessing-styles!public! !
!UI.View categoriesFor: #isGroupStop:!accessing-styles!public! !
!UI.View categoriesFor: #isLayoutValid!geometry!public!testing! !
!UI.View categoriesFor: #isManaged!accessing!public! !
!UI.View categoriesFor: #isManaged:!accessing!public! !
!UI.View categoriesFor: #isOpen!public!testing! !
!UI.View categoriesFor: #isPersistentlyDisabled!private!testing! !
!UI.View categoriesFor: #isPersistentView!public!testing! !
!UI.View categoriesFor: #isPopup!accessing-styles!public!testing! !
!UI.View categoriesFor: #isPopup:!accessing-styles!public! !
!UI.View categoriesFor: #isReadOnly!public!testing! !
!UI.View categoriesFor: #isReadOnly:!public!testing! !
!UI.View categoriesFor: #isResizable!accessing-styles!public! !
!UI.View categoriesFor: #isResizable:!accessing-styles!public! !
!UI.View categoriesFor: #isStateRestoring!private!testing! !
!UI.View categoriesFor: #isStateRestoring:!accessing!private! !
!UI.View categoriesFor: #isTabStop!accessing-styles!public! !
!UI.View categoriesFor: #isTabStop:!accessing-styles!public! !
!UI.View categoriesFor: #isThemed!private!testing! !
!UI.View categoriesFor: #isTopView!public!testing! !
!UI.View categoriesFor: #isTransparent!accessing-styles!public! !
!UI.View categoriesFor: #isTransparent:!accessing-styles!public! !
!UI.View categoriesFor: #isView!accessing!public!testing! !
!UI.View categoriesFor: #isWindowUnicode!public!testing! !
!UI.View categoriesFor: #isWindowVisible!public!testing! !
!UI.View categoriesFor: #isWindowVisible:!accessing!public!testing! !
!UI.View categoriesFor: #keyboardCommands!accessing!public! !
!UI.View categoriesFor: #killTimer:!public!timers! !
!UI.View categoriesFor: #layout!geometry!public! !
!UI.View categoriesFor: #layout:!geometry!private! !
!UI.View categoriesFor: #layoutExtent:!geometry!public! !
!UI.View categoriesFor: #layoutManager!geometry!public! !
!UI.View categoriesFor: #literalStoreOn:!literal filing!public! !
!UI.View categoriesFor: #loadViewResource:forEdit:!binary filing!public! !
!UI.View categoriesFor: #managedSubViews!hierarchy!public!sub views! !
!UI.View categoriesFor: #managedSubViewsDo:!hierarchy!public!sub views! !
!UI.View categoriesFor: #mapPoint:to:!geometry!public! !
!UI.View categoriesFor: #mapPointToScreen:!geometry!public! !
!UI.View categoriesFor: #mapRectangle:to:!geometry!public! !
!UI.View categoriesFor: #maxExtent!accessing!public! !
!UI.View categoriesFor: #minExtent!accessing!public! !
!UI.View categoriesFor: #model!accessing!public! !
!UI.View categoriesFor: #model:!accessing!public! !
!UI.View categoriesFor: #name!accessing!public! !
!UI.View categoriesFor: #name:!accessing!public! !
!UI.View categoriesFor: #nameOf:!hierarchy!public!sub views! !
!UI.View categoriesFor: #needsValidateLayout!geometry!public!testing! !
!UI.View categoriesFor: #nextSiblingView!hierarchy!public!sub views! !
!UI.View categoriesFor: #nmNotify:!event handling-win32!private! !
!UI.View categoriesFor: #nonClientCanvas!drawing!public! !
!UI.View categoriesFor: #nonReferenceAncestor!accessing!public! !
!UI.View categoriesFor: #noRedrawDo:!operations!public! !
!UI.View categoriesFor: #oldWndProc:!accessing!private! !
!UI.View categoriesFor: #onAboutToCreate!event handling!public! !
!UI.View categoriesFor: #onAboutToDisplayMenu:!event handling!public! !
!UI.View categoriesFor: #onActionPerformed!event handling!public! !
!UI.View categoriesFor: #onBegin:drag:!event handling!public! !
!UI.View categoriesFor: #onCaptureChanged:!event handling!public! !
!UI.View categoriesFor: #onCloseRequested!event handling!public! !
!UI.View categoriesFor: #onColorRequired:!event handling!public! !
!UI.View categoriesFor: #onCommand:!event handling!public! !
!UI.View categoriesFor: #onCreated:!event handling!public! !
!UI.View categoriesFor: #onDestroyed!event handling!private! !
!UI.View categoriesFor: #onDrawItem:!event handling-win32!public! !
!UI.View categoriesFor: #onDrawMenuItem:!event handling-win32!public! !
!UI.View categoriesFor: #onEraseRequired:!event handling!public! !
!UI.View categoriesFor: #onGetCursor:!event handling!public! !
!UI.View categoriesFor: #onHotKey:!event handling!public! !
!UI.View categoriesFor: #onHScroll:!event handling!public! !
!UI.View categoriesFor: #onIdleEntered!event handling!public! !
!UI.View categoriesFor: #onInputLanguageChanged:!event handling-win32!public! !
!UI.View categoriesFor: #onInputMaskRequired:!event handling!public! !
!UI.View categoriesFor: #onKeyPressed:!event handling!public! !
!UI.View categoriesFor: #onKeyReleased:!event handling!public! !
!UI.View categoriesFor: #onKeyTyped:!event handling!public! !
!UI.View categoriesFor: #onKillFocus!event handling!public! !
!UI.View categoriesFor: #onLeftButtonDoubleClicked:!event handling!public! !
!UI.View categoriesFor: #onLeftButtonPressed:!event handling!public! !
!UI.View categoriesFor: #onLeftButtonReleased:!event handling!public! !
!UI.View categoriesFor: #onMiddleButtonDoubleClicked:!event handling!public! !
!UI.View categoriesFor: #onMiddleButtonPressed:!event handling!public! !
!UI.View categoriesFor: #onMiddleButtonReleased:!event handling!public! !
!UI.View categoriesFor: #onModelChanged!event handling!public! !
!UI.View categoriesFor: #onMouseHovering:!event handling!public! !
!UI.View categoriesFor: #onMouseLeave:!event handling!public! !
!UI.View categoriesFor: #onMouseMoved:!event handling!public! !
!UI.View categoriesFor: #onMouseWheeled:!event handling!public! !
!UI.View categoriesFor: #onPaintRequired:!event handling!public! !
!UI.View categoriesFor: #onPositionChanged:!event handling!public! !
!UI.View categoriesFor: #onPositionChanging:!event handling!public! !
!UI.View categoriesFor: #onRestoredFromProxy!binary filing!public! !
!UI.View categoriesFor: #onRightButtonDoubleClicked:!event handling!public! !
!UI.View categoriesFor: #onRightButtonPressed:!event handling!public! !
!UI.View categoriesFor: #onRightButtonReleased:!event handling!public! !
!UI.View categoriesFor: #onSetFocus!event handling!public! !
!UI.View categoriesFor: #onStartup!event handling!public! !
!UI.View categoriesFor: #onStateRestored!event handling!public! !
!UI.View categoriesFor: #onSubViewAdded:!event handling!public! !
!UI.View categoriesFor: #onSubViewRemoved:!event handling!public! !
!UI.View categoriesFor: #onSysKeyPressed:!event handling!public! !
!UI.View categoriesFor: #onSysKeyReleased:!event handling!public! !
!UI.View categoriesFor: #onSysKeyTyped:!event handling!public! !
!UI.View categoriesFor: #onTipDetailsRequired:!event handling!public! !
!UI.View categoriesFor: #onTipTextRequired:!event handling!public! !
!UI.View categoriesFor: #onViewClosed!event handling!public! !
!UI.View categoriesFor: #onViewCreated!event handling!public! !
!UI.View categoriesFor: #onViewDestroyed!event handling!public! !
!UI.View categoriesFor: #onViewOpened!event handling!public! !
!UI.View categoriesFor: #onVScroll:!event handling!public! !
!UI.View categoriesFor: #onXButtonDoubleClicked:!event handling!public! !
!UI.View categoriesFor: #onXButtonPressed:!event handling!public! !
!UI.View categoriesFor: #onXButtonReleased:!event handling!public! !
!UI.View categoriesFor: #onZOrderChanged!event handling!public! !
!UI.View categoriesFor: #openTheme!private!theming! !
!UI.View categoriesFor: #parentPresenter!presenter!public! !
!UI.View categoriesFor: #parentView!hierarchy!public! !
!UI.View categoriesFor: #parentView:!hierarchy!private! !
!UI.View categoriesFor: #performAction!operations!public! !
!UI.View categoriesFor: #placement!geometry!public! !
!UI.View categoriesFor: #placement:!geometry!public! !
!UI.View categoriesFor: #plainText!accessing!public! !
!UI.View categoriesFor: #plainText:!private!updating! !
!UI.View categoriesFor: #plainTextFrom:to:!accessing!public! !
!UI.View categoriesFor: #plainTextRange:!accessing!public! !
!UI.View categoriesFor: #position!geometry!public! !
!UI.View categoriesFor: #position:!geometry!public! !
!UI.View categoriesFor: #positionForKeyboardContextMenu!enquiries!public! !
!UI.View categoriesFor: #postMessage:wParam:lParam:!operations!private! !
!UI.View categoriesFor: #preferredExtent!geometry!public! !
!UI.View categoriesFor: #preferredExtent:!geometry!public! !
!UI.View categoriesFor: #presenter!accessing!public! !
!UI.View categoriesFor: #presenter:!initializing!public! !
!UI.View categoriesFor: #presenterConnectionPoint!accessing!public! !
!UI.View categoriesFor: #preTranslateKeyboardInput:!dispatching!public! !
!UI.View categoriesFor: #preTranslateMessage:!dispatching!public! !
!UI.View categoriesFor: #preTranslateMouseInput:!dispatching!public! !
!UI.View categoriesFor: #previousSiblingView!hierarchy!public!sub views! !
!UI.View categoriesFor: #primHookWindowCreate:!helpers!private! !
!UI.View categoriesFor: #printOn:!development!printing!public! !
!UI.View categoriesFor: #propagateSettingsChange:!event handling!private! !
!UI.View categoriesFor: #queryCommand:!commands!private! !
!UI.View categoriesFor: #queryCommandRouteFor:!commands!private! !
!UI.View categoriesFor: #queryContextMenu!menus!public! !
!UI.View categoriesFor: #queryMouseTracking!enquiries!private! !
!UI.View categoriesFor: #recreate!public!realizing/unrealizing! !
!UI.View categoriesFor: #recreateAround:!private!realizing/unrealizing! !
!UI.View categoriesFor: #rectangle!geometry!public! !
!UI.View categoriesFor: #rectangle:!geometry!public! !
!UI.View categoriesFor: #refreshContents!public!updating! !
!UI.View categoriesFor: #registerHotKeyId:modifiers:vkey:!helpers!public! !
!UI.View categoriesFor: #releaseDC:!operations!public! !
!UI.View categoriesFor: #removeSubView:!hierarchy!public!sub views! !
!UI.View categoriesFor: #requestDragImages:!drag & drop!public! !
!UI.View categoriesFor: #requestDragObjects:!drag & drop!public! !
!UI.View categoriesFor: #requestDropOperations:!drag & drop!public! !
!UI.View categoriesFor: #requestLayoutExtent:!geometry!public! !
!UI.View categoriesFor: #requestLayoutRectangle:!geometry!public! !
!UI.View categoriesFor: #resolution!accessing!public! !
!UI.View categoriesFor: #resolutionScaledBy:!geometry!private! !
!UI.View categoriesFor: #restoreFromProxy:!binary filing!private! !
!UI.View categoriesFor: #restorePlacement:resolution:!geometry!private! !
!UI.View categoriesFor: #richText:!accessing!private! !
!UI.View categoriesFor: #screenRectangle!geometry!public! !
!UI.View categoriesFor: #screenRectangle:!geometry!public! !
!UI.View categoriesFor: #scrollBy:clip:!public!scrolling! !
!UI.View categoriesFor: #scrollBy:scroll:clip:!public!scrolling! !
!UI.View categoriesFor: #sendMessage:!operations!private! !
!UI.View categoriesFor: #sendMessage:wParam:!operations!private! !
!UI.View categoriesFor: #sendMessage:wParam:lParam:!operations!private! !
!UI.View categoriesFor: #sendMessage:wParam:lpParam:!operations!private! !
!UI.View categoriesFor: #sendMessage:wParam:szParam:!operations!private! !
!UI.View categoriesFor: #setCapture!operations!public! !
!UI.View categoriesFor: #setEvents:!events!private! !
!UI.View categoriesFor: #setExtent:!geometry!public! !
!UI.View categoriesFor: #setFocus!operations!public! !
!UI.View categoriesFor: #setModel:!accessing!private! !
!UI.View categoriesFor: #setNoRedrawCount:!private! !
!UI.View categoriesFor: #setParent:!accessing!private! !
!UI.View categoriesFor: #setRedraw:!operations!private! !
!UI.View categoriesFor: #setScrollInfo:bar:!accessing!private! !
!UI.View categoriesFor: #setStateRestoring!accessing!private! !
!UI.View categoriesFor: #setTimer:interval:!public!timers! !
!UI.View categoriesFor: #settingChanged:!event handling!private!updating! !
!UI.View categoriesFor: #setWindowExStyle:!accessing-styles!private! !
!UI.View categoriesFor: #setWindowLong:to:!accessing!private! !
!UI.View categoriesFor: #setWindowPosAfter:x:y:width:height:flags:!geometry!private! !
!UI.View categoriesFor: #setWindowStyle:!accessing-styles!private! !
!UI.View categoriesFor: #setWindowText:!accessing!private! !
!UI.View categoriesFor: #setWndProc:!accessing!private! !
!UI.View categoriesFor: #show!operations!public! !
!UI.View categoriesFor: #showShell!operations!private! !
!UI.View categoriesFor: #showWithStyle:!operations!private! !
!UI.View categoriesFor: #state!accessing!private! !
!UI.View categoriesFor: #state:!accessing!private! !
!UI.View categoriesFor: #stbSaveOn:!binary filing!public! !
!UI.View categoriesFor: #styles!accessing-styles!public! !
!UI.View categoriesFor: #styles:!accessing-styles!private! !
!UI.View categoriesFor: #subclassWindow!operations!private! !
!UI.View categoriesFor: #subclassWindow:!operations!private! !
!UI.View categoriesFor: #subViewFromPoint:!hierarchy!public! !
!UI.View categoriesFor: #subViewFromPoint:flags:!hierarchy!private! !
!UI.View categoriesFor: #subViews!hierarchy!public!sub views! !
!UI.View categoriesFor: #subViewsDo:!hierarchy!public!sub views! !
!UI.View categoriesFor: #tabFirst!public!tabbing! !
!UI.View categoriesFor: #tabFocus!private!tabbing! !
!UI.View categoriesFor: #tabNext!commands!public! !
!UI.View categoriesFor: #tabNextSiblingFrom:forward:!private!tabbing! !
!UI.View categoriesFor: #text!accessing!public! !
!UI.View categoriesFor: #text:!accessing!public! !
!UI.View categoriesFor: #textLength!accessing!private! !
!UI.View categoriesFor: #theme!public!theming! !
!UI.View categoriesFor: #themeSubAppName!constants!private! !
!UI.View categoriesFor: #toolTipWindow!accessing!private! !
!UI.View categoriesFor: #toolTipWindow:!accessing!not an aspect!private! !
!UI.View categoriesFor: #topShell!hierarchy!public! !
!UI.View categoriesFor: #topView!hierarchy!public! !
!UI.View categoriesFor: #trackContextMenu:!menus!private! !
!UI.View categoriesFor: #trackMouseHover:!operations!public! !
!UI.View categoriesFor: #trackMouseLeave!operations!public! !
!UI.View categoriesFor: #unhookWindowCreate:!operations!private! !
!UI.View categoriesFor: #unregisterHotKeyId:!helpers!public! !
!UI.View categoriesFor: #update!drawing!public! !
!UI.View categoriesFor: #updateModel!public!updating! !
!UI.View categoriesFor: #updateSetting:!event handling!private!updating! !
!UI.View categoriesFor: #usePreferredExtent!accessing!public! !
!UI.View categoriesFor: #usePreferredExtent:!accessing!public! !
!UI.View categoriesFor: #validate!drawing!public! !
!UI.View categoriesFor: #validateLayout!geometry!public! !
!UI.View categoriesFor: #validateLayout:!geometry!private! !
!UI.View categoriesFor: #validateRect:!drawing!public! !
!UI.View categoriesFor: #validateSubViewLayouts:!geometry!private! !
!UI.View categoriesFor: #validateUserInterface!operations!public! !
!UI.View categoriesFor: #view!presenter!public! !
!UI.View categoriesFor: #viewNamed:!hierarchy!public!sub views! !
!UI.View categoriesFor: #viewNamed:ifNone:!hierarchy!public!sub views! !
!UI.View categoriesFor: #whileInvisibleDo:!operations!public! !
!UI.View categoriesFor: #width!geometry!public! !
!UI.View categoriesFor: #width:!geometry!public! !
!UI.View categoriesFor: #windowName!private!realizing/unrealizing! !
!UI.View categoriesFor: #winFinalize!finalizing!private! !
!UI.View categoriesFor: #withAllParents!hierarchy!public! !
!UI.View categoriesFor: #withAllParentsDo:!hierarchy!public! !
!UI.View categoriesFor: #withAllSubViews!hierarchy!public! !
!UI.View categoriesFor: #withAllSubViewsDo:!hierarchy!public! !
!UI.View categoriesFor: #wmActivate:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmActivateApp:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmCancelMode:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmCaptureChanged:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmChar:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmClose:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmCommand:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmContextMenu:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmCreate:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmCtlColor:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmDestroy:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmDrawItem:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmEnterIdle:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmEnterMenuLoop:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmEraseBkGnd:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmExitMenuLoop:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmGetDlgCode:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmGetMinMaxInfo:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmHotKey:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmHScroll:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmInitMenu:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmInitMenuPopup:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmInputLangChange:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmKeyDown:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmKeyUp:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmKillFocus:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmLButtonDblClk:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmLButtonDown:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmLButtonUp:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmMButtonDblClk:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmMButtonDown:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmMButtonUp:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmMeasureItem:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmMenuCommand:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmMouseHover:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmMouseHWheel:wParam:lParam:!private! !
!UI.View categoriesFor: #wmMouseLeave:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmMouseMove:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmMouseWheel:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmNcActivate:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmNcCalcSize:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmNcCreate:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmNcDestroy:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmNcHitTest:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmNcPaint:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmNotify:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmPaint:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmParentNotify:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmPrint:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmPrintClient:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmQueryEndSession:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmRButtonDblClk:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmRButtonDown:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmRButtonUp:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmSetCursor:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmSetFocus:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmSettingChange:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmShowWindow:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmSize:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmSysChar:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmSysColorChange:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmSysCommand:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmSysDeadChar:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmSysKeyDown:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmSysKeyUp:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmThemeChanged:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmTimeChange:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmTimer:wParam:lParam:!event handling-win32!private!timers! !
!UI.View categoriesFor: #wmVScroll:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmWindowPosChanged:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmWindowPosChanging:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmXButtonDblClk:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmXButtonDown:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #wmXButtonUp:wParam:lParam:!event handling-win32!private! !
!UI.View categoriesFor: #x!geometry!public! !
!UI.View categoriesFor: #x:!geometry!public! !
!UI.View categoriesFor: #y!geometry!public! !
!UI.View categoriesFor: #y:!geometry!public! !
!UI.View categoriesFor: #zOrderAfter:!operations!public! !
!UI.View categoriesFor: #zOrderAfter:withFlags:!operations!public! !
!UI.View categoriesFor: #zOrderBottom!operations!public! !
!UI.View categoriesFor: #zOrderTop!operations!public! !

UI.View methodProtocol: #commandTarget attributes: #(#readOnly) selectors: #(#queryCommand:)!
UI.View methodProtocol: #dcSource attributes: #(#readOnly) selectors: #(#getDC #releaseDC:)!
UI.View methodProtocol: #dragDropSessionSource attributes: #(#readOnly) selectors: #(#ddCut: #ddGetImages: #ddGetObjects:)!
UI.View methodProtocol: #dragDropSessionTarget attributes: #(#readOnly) selectors: #(#ddDrop: #ddEnter: #ddLeave: #ddOperations: #ddOver: #ddScroll:)!
UI.View methodProtocol: #dragSource attributes: #(#readOnly) selectors: #(#dragCut: #requestDragImages: #requestDragObjects:)!
UI.View methodProtocol: #dropTarget attributes: #(#readOnly) selectors: #(#dragEnter: #dragLeave: #dragOver: #drop: #requestDropOperations:)!
UI.View methodProtocol: #interactor attributes: #(#readOnly) selectors: #(#onGetCursor: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMiddleButtonDoubleClicked: #onMiddleButtonPressed: #onMiddleButtonReleased: #onMouseLeave: #onMouseMoved: #onMouseWheeled: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSysKeyPressed: #onSysKeyReleased: #onSysKeyTyped: #onXButtonDoubleClicked: #onXButtonPressed: #onXButtonReleased:)!
UI.View methodProtocol: #presenter attributes: #(#readOnly) selectors: #(#addToCommandRoute: #commandPolicy #ensureVisible #isOpen #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMiddleButtonPressed: #onMiddleButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewDestroyed #onViewOpened #parentPresenter #performAction #setFocus #show #topShell #view)!
UI.View methodProtocol: #whatsThisHelp attributes: #(#readOnly) selectors: #(#helpId)!
UI.View methodProtocol: #window attributes: #(#readOnly) selectors: #(#asParameter #destroy #dispatchMessage:wParam:lParam: #enterIdle #isPersistentView #isWindowVisible #onStartup #preTranslateMessage: #subclassWindow:)!

!UI.View class methodsFor!

active
	"Answers a Dolphin View for the active Window. This may not be
	a registered Dolphin window (e.g. the Window does not belong to Dolphin
	or is a control on a dialog template which has not been subclassed).

	N.B. We deliberately reference View specifically rather than 'self' because
	if the active window is not a registered Dolphin View then we want an
	instance of View to represent it, not an instance of whatever subclass
	sent the #active message."

	^View fromHandle: self activeHandle!

activeHandle
	"Private - Answers the handle of the current active Window."

	^UserLibrary default getActiveWindow!

buildMessageMap
	"Private - Initialize the map of Windows message numbers to the selectors of the low-level event handlers in the receiver.
	N.B. Must not be stripped, as this is the only thing which prevents the handlers themselves from being stripped.
	"

	^(Array new: 1024)
		at: WM_CREATE + 1 put: #wmCreate:wParam:lParam:;
		at: WM_DESTROY + 1 put: #wmDestroy:wParam:lParam:;
		at: WM_MOVE + 1 put: nil;
		at: WM_SIZE + 1 put: #wmSize:wParam:lParam:;
		at: WM_ACTIVATE + 1 put: #wmActivate:wParam:lParam:;
		at: WM_SETFOCUS + 1 put: #wmSetFocus:wParam:lParam:;
		at: WM_KILLFOCUS + 1 put: #wmKillFocus:wParam:lParam:;
		at: WM_PAINT + 1 put: #wmPaint:wParam:lParam:;
		at: WM_CLOSE + 1 put: #wmClose:wParam:lParam:;
		at: WM_ERASEBKGND + 1 put: #wmEraseBkGnd:wParam:lParam:;
		at: WM_SHOWWINDOW + 1 put: #wmShowWindow:wParam:lParam:;
		at: WM_NCACTIVATE + 1 put: #wmNcActivate:wParam:lParam:;
		at: WM_NCCREATE + 1 put: #wmNcCreate:wParam:lParam:;
		at: WM_NCDESTROY + 1 put: #wmNcDestroy:wParam:lParam:;
		at: WM_NCCALCSIZE + 1 put: #wmNcCalcSize:wParam:lParam:;
		at: WM_NCHITTEST + 1 put: #wmNcHitTest:wParam:lParam:;
		at: WM_NCPAINT + 1 put: #wmNcPaint:wParam:lParam:;
		at: WM_NOTIFY + 1 put: #wmNotify:wParam:lParam:;
		at: WM_PARENTNOTIFY + 1 put: #wmParentNotify:wParam:lParam:;
		at: WM_CHAR + 1 put: #wmChar:wParam:lParam:;
		at: WM_INITDIALOG + 1 put: #wmInitDialog:wParam:lParam:;
		at: WM_COMMAND + 1 put: #wmCommand:wParam:lParam:;
		at: WM_TIMER + 1 put: #wmTimer:wParam:lParam:;
		at: WM_MOUSEMOVE + 1 put: #wmMouseMove:wParam:lParam:;
		at: WM_LBUTTONDOWN + 1 put: #wmLButtonDown:wParam:lParam:;
		at: WM_LBUTTONUP + 1 put: #wmLButtonUp:wParam:lParam:;
		at: WM_LBUTTONDBLCLK + 1 put: #wmLButtonDblClk:wParam:lParam:;
		at: WM_RBUTTONDOWN + 1 put: #wmRButtonDown:wParam:lParam:;
		at: WM_RBUTTONUP + 1 put: #wmRButtonUp:wParam:lParam:;
		at: WM_RBUTTONDBLCLK + 1 put: #wmRButtonDblClk:wParam:lParam:;
		at: WM_MBUTTONDOWN + 1 put: #wmMButtonDown:wParam:lParam:;
		at: WM_MBUTTONUP + 1 put: #wmMButtonUp:wParam:lParam:;
		at: WM_MBUTTONDBLCLK + 1 put: #wmMButtonDblClk:wParam:lParam:;
		at: WM_XBUTTONDOWN + 1 put: #wmXButtonDown:wParam:lParam:;
		at: WM_XBUTTONUP + 1 put: #wmXButtonUp:wParam:lParam:;
		at: WM_XBUTTONDBLCLK + 1 put: #wmXButtonDblClk:wParam:lParam:;
		at: WM_HSCROLL + 1 put: #wmHScroll:wParam:lParam:;
		at: WM_VSCROLL + 1 put: #wmVScroll:wParam:lParam:;
		at: WM_SETCURSOR + 1 put: #wmSetCursor:wParam:lParam:;
		at: WM_QUERYENDSESSION + 1 put: #wmQueryEndSession:wParam:lParam:;
		at: WM_DRAWITEM + 1 put: #wmDrawItem:wParam:lParam:;
		at: WM_KEYDOWN + 1 put: #wmKeyDown:wParam:lParam:;
		at: WM_KEYUP + 1 put: #wmKeyUp:wParam:lParam:;
		at: WM_SYSKEYDOWN + 1 put: #wmSysKeyDown:wParam:lParam:;
		at: WM_SYSKEYUP + 1 put: #wmSysKeyUp:wParam:lParam:;
		at: WM_SYSDEADCHAR + 1 put: #wmSysDeadChar:wParam:lParam:;
		at: WM_SYSCOLORCHANGE + 1 put: #wmSysColorChange:wParam:lParam:;
		at: WM_CTLCOLORMSGBOX + 1 put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLOREDIT + 1 put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLORLISTBOX + 1 put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLORBTN + 1 put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLORDLG + 1 put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLORSCROLLBAR + 1 put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLORSTATIC + 1 put: #wmCtlColor:wParam:lParam:;
		at: WM_GETDLGCODE + 1 put: #wmGetDlgCode:wParam:lParam:;
		at: WM_ENTERIDLE + 1 put: #wmEnterIdle:wParam:lParam:;
		at: WM_WINDOWPOSCHANGING + 1 put: #wmWindowPosChanging:wParam:lParam:;
		at: WM_WINDOWPOSCHANGED + 1 put: #wmWindowPosChanged:wParam:lParam:;
		at: WM_ENTERMENULOOP + 1 put: #wmEnterMenuLoop:wParam:lParam:;
		at: WM_EXITMENULOOP + 1 put: #wmExitMenuLoop:wParam:lParam:;
		at: WM_CANCELMODE + 1 put: #wmCancelMode:wParam:lParam:;
		at: WM_CAPTURECHANGED + 1 put: #wmCaptureChanged:wParam:lParam:;
		at: WM_MOUSEWHEEL + 1 put: #wmMouseWheel:wParam:lParam:;
		at: WM_MOUSEHWHEEL + 1 put: #wmMouseHWheel:wParam:lParam:;
		at: WM_GETMINMAXINFO + 1 put: #wmGetMinMaxInfo:wParam:lParam:;
		at: WM_MENUCOMMAND + 1 put: #wmMenuCommand:wParam:lParam:;
		at: WM_MEASUREITEM + 1 put: #wmMeasureItem:wParam:lParam:;
		at: WM_DRAWITEM + 1 put: #wmDrawItem:wParam:lParam:;
		at: WM_SYSCOMMAND + 1 put: #wmSysCommand:wParam:lParam:;
		at: WM_SYSCHAR + 1 put: #wmSysChar:wParam:lParam:;
		at: WM_HOTKEY + 1 put: #wmHotKey:wParam:lParam:;
		at: WM_MOUSELEAVE + 1 put: #wmMouseLeave:wParam:lParam:;
		at: WM_MOUSEHOVER + 1 put: #wmMouseHover:wParam:lParam:;
		at: WM_THEMECHANGED + 1 put: #wmThemeChanged:wParam:lParam:;
		at: WM_SETTINGCHANGE + 1 put: #wmSettingChange:wParam:lParam:;
		at: WM_PRINTCLIENT + 1 put: #wmPrintClient:wParam:lParam:;
		at: WM_PRINT + 1 put: #wmPrint:wParam:lParam:;
		at: WM_ACTIVATEAPP + 1 put: #wmActivateApp:wParam:lParam:;
		at: WM_TIMECHANGE + 1 put: #wmTimeChange:wParam:lParam:;
		at: WM_INPUTLANGCHANGE + 1 put: #wmInputLangChange:wParam:lParam:;
		yourself!

capture
	"Answer the View that has the mouse capture or nil if none."

	| capturedHandle |
	capturedHandle := UserLibrary default getCapture.
	^capturedHandle notNil ifTrue: [self withHandle: capturedHandle] ifFalse: []!

closeAll
	"Private - Ask all top level views to close (they will receiver a WM_CLOSE, which
	they may refuse). Answer whether all windows are closed."

	^(self topLevelViews reject: [ :w | w close ]) isEmpty!

cursor
	"Answers the default cursor to be used for the mouse pointer when over instances of the receiver.
	Answer nil so the default cursor for the window class is used. This can be overridden for entire classes, 
	or on an instance basis."

	^nil!

defaultId
	"Private - Answer a new id to use for a View"

	"We start some distance away from the standard Windows IDs for command buttons such as IDOK,
	etc, to avoid any clashes now or in future. Note that these id's need to fit in16-bits
	because of DM_GETDEFID."

	^4096 + (NextId := NextId + 1) bitAnd: 16rFFFF!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized. Answer nil for no default. Overidden by subclasses
	that can provide a more sensible default"

	^nil!

defaultView
	"Answer the resource name of the default view for the receiver.
	Subclasses should override this method if they wish to use a different
	resource name for the default view"

	^'Default view'!

desktop
	"Answer the Desktop View"

	^DesktopView current!

desktopHandle
	"Private - Answer the handle of the Desktop window."

	^UserLibrary default getDesktopWindow!

destroyAll
	"Private - Forcibly close all windows (the Windows will not receiver a WM_CLOSE).
	This is a rather drastic action in that any unsaved data in any window will be lost."

	self topLevelViews do: [:w | w destroy].
	SessionManager inputState purgeDeadWindows!

focus
	"Answers the View with focus or nil if there is none.
	Implementation Note: We ensure that the answer is a basic View if not
	a registered view of a specific class. This avoid unpleasant
	surprises when evaluating 'self class focus' from subclasses, 
	especially DialogViews created from templates, where the children
	of the view may not themselves be Dolphin views."

	| focusHwnd |
	^(focusHwnd := self focusHandle) isNil
		ifTrue: []
		ifFalse: 
			["N.B. Reference to specific class rather than self is deliberate"
			View fromHandle: focusHwnd]!

focusHandle
	"Private - Answers handle of the Window with focus, or nil if there is none."

	^UserLibrary default getFocus!

foreground
	"Answers a Dolphin View for the foreground Window. This may not be
	a registered Dolphin View (e.g. the Window does not belong to Dolphin
	or is a control on a dialog template which has not been subclassed).

	N.B. We deliberately reference View specifically rather than 'self' because
	if the foreground window is not a registered Dolphin View then we want an
	instance of View to represent it, not an instance of whatever subclass
	sent the #foreground message."

	^View fromHandle: self foregroundHandle!

foregroundHandle
	"Private - Answers handle of the current foreground window."

	^UserLibrary default getForegroundWindow!

frameWidths: anInteger
	"Answer the widths of the frames (if any) which will result from the Window style bits in the <integer> argument."

	^(anInteger allMask: WS_DLGFRAME)
		ifTrue: [SystemMetrics current dialogFrameExtent]
		ifFalse: 
			[(anInteger allMask: WS_THICKFRAME)
				ifTrue: [SystemMetrics current sizingFrameExtent]
				ifFalse: [(anInteger allMask: WS_BORDER) ifTrue: [SystemMetrics current borderExtent] ifFalse: [0 @ 0]]]!

freeTheme
	theme notNull ifTrue: [ThemeLibrary default closeThemeData: theme].
	theme := nil!

fromHandle: aHandle
	"Answers a <View> that has a handle of aHandle (an Integer or
	ExternalHandle). This method answers a View whether or not
	aHandle is registered - if it isn't then the object is a temporary
	created for the purpose. The View will also be correctly wired
	to its parent, even if that parent is also unknown, and so on.
	See also #withHandle:, which answers only registered (known)
	Views."

	^SessionManager inputState windowAt: aHandle
		ifAbsent: 
			[| unknownView parentView parentHandle |
			unknownView := self new handle: aHandle.

			"Locate a suitable parent view"
			parentHandle := unknownView getParent.
			parentView := View withHandle: parentHandle.
			parentView isNil
				ifTrue: 
					[| parentStyle parentClass |
					"Decide in a suitable class for the parent"
					parentStyle := UserLibrary default getWindowLong: parentHandle nIndex: GWL_STYLE.
					parentClass := (parentStyle anyMask: WS_CHILD) ifTrue: [ContainerView] ifFalse: [ShellView].
					parentView := parentClass fromHandle: parentHandle].
			unknownView parentView: parentView.
			unknownView]!

fromPoint: aPoint
	"Private - Answers the View beneath aPoint (in screen coordinates)."

	| handleFound |
	handleFound := UserLibrary default windowFromPoint: aPoint asParameter.
	^self fromHandle: handleFound!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables:
		View initialize
	"

	NextId := 0.
	ViewClosedError := Signal description: 'View closed'.
	"Note that the message map is not const variable, since view packages may add new messages they want to receive, although must do so by sending #registerMessageMappings:"
	MessageMap isNil
		ifTrue: 
			[MessageMap := self buildMessageMap
						isImmutable: true;
						yourself].
	VMLibrary default registryAtIndex: 54 put: #subclassWindow:!

mapRectangle: aRectangle from: aSourceView to: aDestinationView
	"Answers a RECTL like aRectangle mapped from the coordinate system of aSourceView 
	into that of aDestinationView"

	| rect |
	rect := RECTL fromRectangle: aRectangle.
	UserLibrary default
		mapWindowPoints: aSourceView asParameter
		hWndTo: aDestinationView asParameter
		lpPoints: rect
		cPoints: 2.
	^rect!

new
	"Answer a new, initialized, instance of the receiver."

	^super new initialize!

onExit
	"Clean up the residue on Dolphin exit."

	self allSubclassesDo: [:c | c freeTheme].
	ThemeLibrary default onExit.
	self destroyAll.	"Destroy rather than close as more forcible and avoids save prompts"
	self unregisterClass!

onStartup
	"Perform post startup processing to initialize the View system"

	WndClassAtom := nil.
	self allSubclassesDo: 
			[:c |
			c resetTheme.
			(c class includesSelector: #onStartup) ifTrue: [c onStartup]].

	"Load the Common Control Library."
	CommCtrlLibrary openDefault.
	NextId := 0.

	"Register a hot key so that Ctrl+Break does not cancel dialogs (closes user interrupt walkback)"
	UserLibrary default
		registerHotKey: nil
		id: 0
		fsModifiers: MOD_CONTROL
		vk: VK_CANCEL.
	ThemeLibrary default onStartup!

openTheme
	^(self themePartName isNil or: [ThemeLibrary isAppThemed not])
		ifTrue: [##(External.Handle new)]
		ifFalse: [ThemeLibrary default openThemeData: nil pszClassList: self themePartName asUtf16String]!

registerClass
	"Private - Register the receivers corresponding Win32 class - answer the class atom.
	Will work for subclasses that implement at least #winClassName, and 
	optionally #winClassStyle and #winClassBrush"

	| atom classStruct |
	classStruct := WNDCLASS new
				className: self wndClassName;
				lpfnWndProc: VMLibrary default getWndProc;
				hInstance: VMLibrary default applicationHandle;
				style: self winClassStyle;
				hbrBackground: self winClassBrush asParameter;
				hIcon: self winClassIcon asParameter;
				hCursor: self winClassCursor asParameter;
				yourself.
	atom := UserLibrary default registerClass: classStruct asParameter.
	^atom == 0 ifTrue: [UserLibrary default systemError] ifFalse: [atom]!

registerMessage: aString
	"Register a named window message, answering the message id to use."

	^UserLibrary default registerWindowMessage: aString!

registerMessageMappings: aCollectionOfAssociations
	MessageMap
		whileMutableDo: [aCollectionOfAssociations do: [:each | MessageMap at: each key + 1 put: each value]]!

releaseCapture
	"Release mouse capture."

	UserLibrary default releaseCapture!

reregisterClass
	"Private - Un-register then re-register receivers corresponding Win32 class."

	^self
		unregisterClass;
		registerClass
!

resetTheme
	theme := nil!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.View) 34 12 nil nil 34 2 8 1140850688 1 416 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 416 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 626 201 201 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 99 12 0 0 110 0 0 0] 8 #() 626 193 193 nil 27)!

selectorForMessage: anInteger
	"Private - Answer the selector for the specified message, or nil if not recognised."

	^anInteger < WM_USER 
		ifTrue: [MessageMap at: anInteger + 1]!

show
	"Shows an instance of the receiver as a child of the desktop"

	^(self new) showShell; yourself!

stbConvert: instVarArray fromVersion: verInteger 
	"Convert from earlier version view by updating and answering the array of instance variables
	(for the View), instVarArray."

	"Note that versions prior to 10 were common across all Views, but at version 10 the
	STBViewProxy class was enhanced to support an individual version, and consequently the
	version may vary by individual class. However it is still necessary to support these earlier
	conversions, so remember to supersend."

	| instVars |
	instVars := instVarArray.
	verInteger < 1 ifTrue: [instVars := self stbConvertFromVersion0: instVars].
	verInteger < 2 ifTrue: [instVars := self stbConvertFromVersion1: instVars].
	verInteger < 3 ifTrue: [instVars := self stbConvertFromVersion2: instVars].
	verInteger < 4 ifTrue: [instVars := self stbConvertFromVersion3: instVars].
	verInteger < 5 ifTrue: [instVars := self stbConvertFromVersion4: instVars].
	verInteger < 6 ifTrue: [instVars := self stbConvertFromVersion5: instVars].
	verInteger < 8 ifTrue: [instVars := self stbConvertFromVersion7: instVars].
	verInteger < 9 ifTrue: [instVars := self stbConvertFromVersion8: instVars].
	verInteger < 10 ifTrue: [instVars := self stbConvertFromVersion9: instVars].
	verInteger < 11 ifTrue: [instVars := self stbConvertFromVersion10: instVars].
	verInteger < 12 ifTrue: [instVars := self stbConvertFromVersion11: instVars].
	verInteger < 13 ifTrue: [instVars := self stbConvertFromVersion12: instVars].
	^instVars!

stbConvertFromVersion0: anArray 
	"Private - Perform an STB conversion from a version 0 <View> to version 1.
	i.e. insert largeIcon/smallIcon inst vars in 	ShellView and subclasses."

	^anArray	"No change at this level"!

stbConvertFromVersion1: anArray 
	"Private - Perform an STB conversion from a version 1 (or earlier) <View> to version 2."

	^anArray	"No change at this level"!

stbConvertFromVersion10: anArray 
	"Private - Perform an STB conversion from a version 10 <View> to version 11."

	^anArray	"No change at this level, but subclasses may redefine"!

stbConvertFromVersion11: anArray 
	"Private - Perform an STB conversion from a version 11 <View> to version 12."

	^anArray	"No change at this level, but subclasses may redefine"!

stbConvertFromVersion12: anArray 
	"Private - Perform an STB conversion from a version 12 <View> to version 13. 13 adds
	inheritable background colours if the backcolor is nil (similar to the way fonts are
	inherited). The special colour 'default' can be used to specify the control's default
	background colour, and there is also a special colour 'none' that indicates that the
	background should be transparent if this is supported by the control (though not many
	controls do support transparency)."

	(anArray at: 6) ifNil: [anArray at: 6 put: Color default].
	^anArray!

stbConvertFromVersion2: anArray 
	"Private - Perform an STB conversion from a version 2 (or earlier) <View> to version 3,
	i.e. add iconSpacing inst var in ListView and subclasses"

	^anArray	"No change at this level"!

stbConvertFromVersion3: anArray 
	"Private - Perform an STB conversion from a version 3 (or earlier) <View> to version 4, 
	i.e. add getInfoTipBlock inst var in IconicListAbstract and subclasses."

	^anArray	"No change at this level"!

stbConvertFromVersion4: array
	"Private - Perform an STB conversion from a version 4 (or earlier) <View> to version 5,
	i.e. insert maxExtent/minExtent inst vars in ShellView and subclasses."

	^array	"No change at this level"

!

stbConvertFromVersion5: array
	"Private - Perform an STB conversion from a version 5 (or earlier) <View> to version 6,
	i.e. insert lvStyle inst var in ListView and subclasses."

	^array 	"No change at this level"!

stbConvertFromVersion6: anArray 
	"Private - Perform an STB conversion from a version 6 (or earlier) <View> to version 7."

	^anArray	"No change at this level"!

stbConvertFromVersion7: anArray
	"Private - Perform an STB conversion from a version 7 (or earlier) <View> to version 8,
	i.e. Add events and unused inst. vars to View."

	| newArray |
	newArray := Array new: anArray size + 2.
	newArray
		replaceFrom: 1
		to: 10
		with: anArray
		startingAt: 1.
	newArray
		replaceFrom: 13
		to: newArray size
		with: anArray
		startingAt: 11.
	^newArray!

stbConvertFromVersion8: anArray 
	"Private - Perform an STB conversion from a version 8 (or earlier) <View> to version 9,
	i.e. convert defaultButton inst. var. of <ShellView> and subclasses to integer id."

	^anArray	"No change at this level"!

stbConvertFromVersion9: anArray 
	"Private - Perform an STB conversion from a version 9 <View> to version 10."

	^anArray	"No change at this level, but subclasses may redefine"!

stbConvertProxy: anSTBViewProxy
	"Convert from earlier version view proxy by updating it in-place."

	anSTBViewProxy instVars: (self stbConvert: anSTBViewProxy instVars 
							fromVersion: anSTBViewProxy version)!

stbVersion
	"Answer the current binary filer version number for instances of the receiver.
	Versions up to and include 9 are common, but in Dolphin 4.0 you may now
	upgrade Views individually. Just override this method to answer a version
	from 14 and up. See STBViewProxy>>stbVersion for details of the common 
	version upgrades that have happened to views in the past."

	^13!

theme
	^theme ifNil: [theme := self openTheme]!

themePartName
	"Answer the <string> name of the Windows theme part that might be used for rendering this view."

	^nil
	!

topLevelViews
	"Answer a Collection containing all top level Dolphin Views.
	Note that this will include Views which are not Shells (e.g. tool tips)."

	^SessionManager inputState topLevelWindows select: [:w | w isKindOf: ##(self)]!

uninitialize
	"Private - Remove any special selectors sent by the VM."

	self unregisterClass.
	"N.B. If you have implemented your own View hierarchy that uses the VM's Window class, then
	you may need the VM to be able to notify the image of Windows messages, and will have to
	register appropriate selectors to replace these. Note further that #wndProc:message:wParam:lParam:cookie:
	cannot be unregistered here because it is needed by the ImageStripper progress dialog."
	#(#subclassWindow:) do: [:each | VMLibrary default unregisterObject: each]!

unregisterClass
	"Private - Unregister the receivers corresponding Win32 class - answer whether it succeeds."

	^UserLibrary default unregisterClass: WndClassAtom hInstance: VMLibrary default applicationHandle!

unregisterMessageMappings: aCollectionOfIntegers
	MessageMap whileMutableDo: [aCollectionOfIntegers do: [:each | MessageMap at: each + 1 put: nil]]!

viewClosedError
	"Answer the exceptionSignaler/exceptionSelector used to signal/catch common
	control message errors."

	^ViewClosedError!

winClassBrush
	"Private - Answer the default class background brush handle to be used for instances 
	of the receiver. Note that as of Dolphin 6 we no longer provide a class brush."

	^0!

winClassCursor
	"Private - Answer the default icon handle to be used for instances of the receiver.
	Implementation Note: Avoid creating a dependency on Cursor class."

	^UserLibrary default loadCursor: nil lpCursorName: IDC_ARROW!

winClassIcon
	"Private - Answer the default icon handle to be used for instances of the receiver.
	Answer null to have windows provide a default icon."

	^0!

winClassName
	"Private - Answer the Windows class name to be used when creating Windows attached
	to instances of the receiver."

	WndClassAtom isNil ifTrue: [WndClassAtom := self reregisterClass].
	^self wndClassName
!

winClassStyle
	"Private - Answer the default class style to be used for instances of the receiver."

	^CS_DBLCLKS !

withHandle: aHandle
	"Private - Answers an open window that has a handle of aHandle (an Integer or
	ExternalHandle). AllViews is an IdentityDictionary associating SmallInteger
	window handles to View subinstances. SmallIntegers are used for performance
	reasons, but this can be changed by using #asExternalHandle instead of #asInteger,
	although you will need to visit #dispatchMessage:, (and any other direct users 
	of AllViews)."

	^SessionManager current inputState windowAt: aHandle ifAbsent: []!

wndClassName
	"Private - Answer the Windows class name to be registered with Win32 for instances of the receiver.
	Typically it is not necessary to override this message when creating custom views, the exceptional
	cases being when one wants different attributes associated with the Window class than the Dolphin
	defaults."

	^'DolphinWindow'! !
!UI.View class categoriesFor: #active!accessing!public! !
!UI.View class categoriesFor: #activeHandle!accessing!private! !
!UI.View class categoriesFor: #buildMessageMap!constants!must not strip!private! !
!UI.View class categoriesFor: #capture!accessing!public! !
!UI.View class categoriesFor: #closeAll!operations!private! !
!UI.View class categoriesFor: #cursor!accessing!public! !
!UI.View class categoriesFor: #defaultId!accessing!private! !
!UI.View class categoriesFor: #defaultModel!models!public! !
!UI.View class categoriesFor: #defaultView!constants!public! !
!UI.View class categoriesFor: #desktop!accessing!public! !
!UI.View class categoriesFor: #desktopHandle!enquiries!private! !
!UI.View class categoriesFor: #destroyAll!operations!private! !
!UI.View class categoriesFor: #focus!accessing!public! !
!UI.View class categoriesFor: #focusHandle!accessing!private! !
!UI.View class categoriesFor: #foreground!accessing!public! !
!UI.View class categoriesFor: #foregroundHandle!accessing!private! !
!UI.View class categoriesFor: #frameWidths:!constants!public! !
!UI.View class categoriesFor: #freeTheme!private!theming! !
!UI.View class categoriesFor: #fromHandle:!instance creation!public! !
!UI.View class categoriesFor: #fromPoint:!instance creation!private! !
!UI.View class categoriesFor: #icon!constants!public! !
!UI.View class categoriesFor: #initialize!development!initializing!private! !
!UI.View class categoriesFor: #mapRectangle:from:to:!geometry!public! !
!UI.View class categoriesFor: #new!instance creation!public! !
!UI.View class categoriesFor: #onExit!event handling!public! !
!UI.View class categoriesFor: #onStartup!event handling!public! !
!UI.View class categoriesFor: #openTheme!private!theming! !
!UI.View class categoriesFor: #registerClass!operations!private! !
!UI.View class categoriesFor: #registerMessage:!dispatching!public! !
!UI.View class categoriesFor: #registerMessageMappings:!class initialization!public! !
!UI.View class categoriesFor: #releaseCapture!operations!public! !
!UI.View class categoriesFor: #reregisterClass!operations!private! !
!UI.View class categoriesFor: #resetTheme!private!theming! !
!UI.View class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.View class categoriesFor: #selectorForMessage:!dispatching!private! !
!UI.View class categoriesFor: #show!instance creation!public! !
!UI.View class categoriesFor: #stbConvert:fromVersion:!binary filing!public! !
!UI.View class categoriesFor: #stbConvertFromVersion0:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion1:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion10:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion11:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion12:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion2:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion3:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion4:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion5:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion6:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion7:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion8:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertFromVersion9:!binary filing!private! !
!UI.View class categoriesFor: #stbConvertProxy:!binary filing!public! !
!UI.View class categoriesFor: #stbVersion!binary filing!public! !
!UI.View class categoriesFor: #theme!public!theming! !
!UI.View class categoriesFor: #themePartName!constants!public!theming! !
!UI.View class categoriesFor: #topLevelViews!accessing!public! !
!UI.View class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!UI.View class categoriesFor: #unregisterClass!operations!private! !
!UI.View class categoriesFor: #unregisterMessageMappings:!class hierarchy-removing!public! !
!UI.View class categoriesFor: #viewClosedError!accessing!public! !
!UI.View class categoriesFor: #winClassBrush!constants!private! !
!UI.View class categoriesFor: #winClassCursor!constants!private! !
!UI.View class categoriesFor: #winClassIcon!constants!private! !
!UI.View class categoriesFor: #winClassName!constants!private! !
!UI.View class categoriesFor: #winClassStyle!constants!private! !
!UI.View class categoriesFor: #withHandle:!accessing!private! !
!UI.View class categoriesFor: #wndClassName!constants!private! !

