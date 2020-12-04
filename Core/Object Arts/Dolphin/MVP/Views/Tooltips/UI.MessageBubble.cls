"Filed out from Dolphin Smalltalk 7"!

UI.MessageBoxAbstract subclass: #'UI.MessageBubble'
	instanceVariableNames: 'iconId tooltip position itemFlags timeout tooltipStyle timeoutProcess font forecolor backcolor margins maxWidth'
	classVariableNames: ''
	imports: #(#{OS.TooltipConstants} #{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {
		'IconIds' -> #[64 48 16]
	}!
UI.MessageBubble guid: (Core.GUID fromString: '{00e5c07e-c4fc-471c-b037-25bc55861176}')!
UI.MessageBubble comment: 'MessageBubble is similar to <MessageBox>, and has a similar protocol. The principle difference is that messages are displayed using a Tooltip (normally a balloon tooltip), rather than in a traditional dialog. This provides a general capability for Dolphin applications to implement speech bubble style help like that which sometimes pops up for tray icons in Windows XP. 

The other main differences from <MessageBox> are:
- MessageBubbles can only be used to display information, not garner a response (i.e. prompting for a yes/no or abort/retry/ignore response is not supported). 
- Normal message boxes are always modal, but MessageBubbles can be be modal (NOT YET IMPLEMENTED), or modeless.
- The close box is optional on a MessageBubble; if absent then the bubble is closed when clicked.
- HTML hyperlinks can be embedded in MessageBubbles, with an event being fired when these are clicked.
- MessageBubbles support a timeout, allowing control over the maximum period for which a message is displayed.
- The icon in a MessageBubble is limited to the standard system error, warning and notification icons, whereas MessageBox can display any icon (except on Win9X).
- Traditional message boxes are usually displayed centred over the owner view, whereas the position of a MessageBubbles is either the current cursor position, or a pre-defined position (specified in screen co-ordinates). The arrow of balloon style bubbles points at this position.
- MessageBubble has a more configurable appearance in that it allows one to define the width of the balloon, the font to be used, etc.

Example usage:
	(MessageBubble new)
		owner: SmalltalkSystemShell allSubinstances first view;
		position: (SmalltalkSystemShell allSubinstances first view mapPoint: 10@10 to: View desktop);
		hasCloseButton: true;
		timeout: 10000;
		notify: ''Don''''t forget to save the image regularly!!''.

Instance Variables:
	iconId		<integer> id of the system icon used in the caption.
	tooltip		<Tooltip> window implementing the actual bubble.
	position		<Point>. Absoluate screen position at which the bubble will appear.
	itemFlags	<integer> flags from the TTF_XXXX enumeration.
	timeout		<integer> number of milliseconds before the bubble closes automatically, or 0 if no timeout.
	tooltipStyle	<integer> flags from the TTS_XXXX enumeration
	timeoutProcess	<Process> used to close the balloon after the timeout delay (if set).
	font		<Font> used to display text in the bubble (emboldened for the caption)
	forecolor	<color> of text in the bubble, or nil if default.
	backcolor	<color> of bubble background, or nil if default.
	margins		<rectangle> top, left, bottom and right margins between bubble border and text, in pels. nil if default.
	maxWidth	<integer> soft maximum width of the message text, or nil if default.

'!
!UI.MessageBubble categoriesForClass!Kernel-Objects! !
!UI.MessageBubble methodsFor!

activateTooltip: aTOOLINFO 
	tooltip startTracking: aTOOLINFO.
!

addTool
	| ti hwnd |
	hwnd := self ownerHandle.
	ti := TOOLINFOW new
				uFlags: (itemFlags bitOr: TTF_IDISHWND);
				text: self text;
				hwnd: hwnd;
				uId: hwnd;
				yourself.
	tooltip ttmAddTool: ti.
	^ti!

areLinksParsed
	"Answer whether any URLs in the text will be parsed and treated
	as hyperlinks."

	^itemFlags allMask: TTF_PARSELINKS!

areLinksParsed: aBoolean 
	"Set whether any URLs in the text will be parsed and treated
	as hyperlinks."

	itemFlags := itemFlags mask: TTF_PARSELINKS set: aBoolean!

backcolor
	"Answer the background <Color> of the bubble, or nil 
	if the default system colour for tooltips is used."

	^backcolor!

backcolor: aColorOrNil 
	"Set the background <Color> of the bubble. If the argument is 
	nil then the default system colour for tooltips is used."

	backcolor := aColorOrNil.
	tooltip notNil ifTrue: [tooltip backcolor: aColorOrNil]!

close
	tooltip notNil 
		ifTrue: 
			[tooltip destroy.
			self isModal ifTrue: [owner topView isEnabled: true].
			tooltip := nil].
	timeoutProcess notNil ifTrue: [timeoutProcess terminate]!

createTooltip
	tooltip := Tooltip new.
	tooltip bePopupFor: (owner ifNil: [View active]).
	tooltip
		baseStyle: tooltipStyle
		maskedBy: ##(TTS_BALLOON | TTS_ALWAYSTIP | TTS_CLOSE | TTS_NOANIMATE | TTS_NOFADE | TTS_NOPREFIX)
		recreateIfChanged: false.
	tooltip
		when: #showTip:
			send: #onShowTip:
			to: self;
		when: #tipPopped
			send: #onPopped
			to: self.
	tooltip create!

defaultCaption
	^self class defaultCaption: self iconStyle!

font
	"Answer the <Font> to be used for the tip text, or nil if the default font is to be applied.
	The font cannot be changed after the bubble has been opened."

	^font!

font: aFontOrNil 
	"Set the <Font> to be used for the tip text, or nil if the default font is to be applied.
	The font cannot be changed after the bubble has been opened."

	font := aFontOrNil!

forecolor
	"Answers the foreground <Color> of the bubble - i.e. the colour of the text 
	and border, or nil if the default system colour is in use."

	^forecolor
!

forecolor: aColorOrNil 
	"Set the foreground <Color> of the bubble - i.e. the colour of the text 
	and border. if the argument is nil then the default system colour for tip-
	text is used."

	forecolor := aColorOrNil.
	tooltip notNil ifTrue: [tooltip forecolor: aColorOrNil]!

hasCloseButton
	"Answer whether the bubble message will have a close button,
	off by default."

	^tooltipStyle allMask: TTS_CLOSE!

hasCloseButton: aBoolean
	"Set whether the bubble message will have a close button,
	off by default. Changing this style has no effect once opened."

	tooltipStyle := tooltipStyle mask: TTS_CLOSE set: aBoolean!

iconStyleFlag
	"Private - Answer the icon style bits from the receiver's style mask."

	^IconIds at: iconId ifAbsent: [0]!

iconStyleFlag: anInteger 
	"Private - Set the receiver's icon to be that named by the argument."

	iconId := IconIds keyAtValue: anInteger ifAbsent: [0]!

initialize
	iconId := 0.
	"TTF_TRACK is needed so the bubble come up where we tell it to, and not at the current cursor position"
	itemFlags := ##(TTF_PARSELINKS | TTF_TRACK | TTF_ABSOLUTE).
	timeout := 0 seconds.
	tooltipStyle := ##(TTS_BALLOON | TTS_NOPREFIX | TTS_NOFADE).
	maxWidth := SmallInteger maximum	"Allows a toolip with embedded CRs to go onto multiples lines"!

initializeTooltip
	| cap |
	cap := self caption.
	(cap notEmpty or: [iconId ~= 0]) ifTrue: [tooltip ttmSetTitle: cap icon: iconId].
	font isNil ifFalse: [tooltip font: font].
	forecolor isNil ifFalse: [tooltip forecolor: forecolor].
	backcolor isNil ifFalse: [tooltip backcolor: backcolor].
	margins isNil ifFalse: [tooltip margins: margins].
	maxWidth isNil ifFalse: [tooltip maxWidth: maxWidth].
	tooltip trackPosition: (self position ifNil: [Cursor position])!

isAnimated
	"Answer whether the bubble message will use tooltip animation when opened
	(the default), assuming that the host system supports it."

	^tooltipStyle noMask: TTS_NOANIMATE!

isAnimated: aBoolean 
	"Sets whether the bubble message will use tooltip animation when opened,
	assuming that the host system supports it. Changing this style has no effect 
	after opening."

	tooltipStyle := tooltipStyle mask: TTS_NOANIMATE set: aBoolean not!

isBalloon
	"Answer whether the bubble message will use balloon (the default) or normal 
	rectangular style when opened."

	^tooltipStyle allMask: TTS_BALLOON!

isBalloon: aBoolean 
	"Sets whether the bubble message will use balloon (the default) or normal 
	rectangular style when opened. Changing this style has no effect after opening."

	tooltipStyle := tooltipStyle mask: TTS_BALLOON set: aBoolean!

isCentered
	"Answer whether the tooltip bubble will be centered on the position. If so then the bubble
	arrow will be in the centre of its top or bottom edge."

	^itemFlags allMask: TTF_CENTERTIP!

isCentered: aBoolean 
	"Set whether the tooltip bubble will be centered on the position. If so then the bubble
	arrow will be in the centre of its top or bottom edge."

	itemFlags := itemFlags mask: TTF_CENTERTIP set: aBoolean!

isModal
	"Answer whether the receiver will act as a modal, or modeless, message box."

	#todo.	"Support modal MessageBubbles"
	^false!

margins
	"Answer a <Rectangle> specifying the left, right, top and bottom margins.
	Each margin is the distance in pixels between the relevant edge and the 
	bubble text. The answer will be nil if the default system metric for tooltips
	is used."

	^margins!

margins: aRectangleOrNil 
	"Set the <Rectangle> specifying the left, right, top and bottom margins.
	Each margin is the distance in pixels between the relevant edge and the 
	bubble text. If the argument is nil then the default system metric for tooltips
	is used. Changing this property has no effect once the tooltip has been
	opened."

	margins := aRectangleOrNil!

maxWidth
	"Answer the maximum width of the bubble, or nil if none is specified.
	If a maximum width is set and the text will not fit within that space
	on a single line, then the text is wrapped to multiple lines. However
	the width is not a hard maximum, and if the text cannot be wrapped
	the bubble may be wider."

	^maxWidth!

maxWidth: anIntegerOrNil 
	"Set the maximum width of the bubble, or nil to use the system default.
	If a maximum width is set and the text will not fit within that space
	on a single line, then the text is wrapped to multiple lines.
	Changing this property after opening has no effect."

	"A word of warning: If the maximum width is too small relative to the amount
	of text to be displayed, then it seems the Tooltip control may arbitrarily
	truncate the	text."

	maxWidth := anIntegerOrNil.
	tooltip isNil ifFalse: [tooltip maxWidth: anIntegerOrNil]!

onPopped
	"Private - The tooltip has just been closed, e.g. because the close button has been pressed."

	self close!

onShowTip: anObject 
	"Private - The tooltip bubble has just been shown."

	!

open
	"Display the tool tip 'message box' for the receiver.
	Note that the message box will beep when opened by the user if
	an icon style has been configured."

	| ti rootOwner own |
	own := self owner.
	own isOpen ifFalse: [^self].
	self beep.
	self createTooltip.
	self initializeTooltip.
	ti := self addTool.
	rootOwner := own topView.
	rootOwner beForeground.
	self isModal ifTrue: [rootOwner isEnabled: false].
	self activateTooltip: ti.
	self startTimeout.
	^#ok!

owner
	^owner ifNil: [View active]!

position
	^position!

position: aPoint 
	position := aPoint.
	self trackPosition!

startTimeout
	timeout isZero
		ifFalse: 
			[timeoutProcess := 
					[(Delay forDuration: timeout) wait.
					[self close] postToMessageQueue] fork]!

timeout
	"Answer the <Duration> for which the bubble will be displayed.
	If the <Duration> is zero, then the bubble is displayed until clicked or otherwise closed explicitly."

	^timeout!

timeout: aDuration
	timeout := aDuration!

tooltip
	^tooltip!

trackPosition
	tooltip isNil ifFalse: [tooltip trackPosition: position]!

willFade
	"Answer whether the bubble message will use the fade away when closed 
	(the default), assuming that the host system supports it."

	^tooltipStyle noMask: TTS_NOFADE!

willFade: aBoolean 
	"Set whether the bubble message will use the fade away when closed 
	(the default), assuming that the host system supports it. Changing this 
	style has no effect after opening."

	tooltipStyle := tooltipStyle mask: TTS_NOFADE set: aBoolean not! !
!UI.MessageBubble categoriesFor: #activateTooltip:!private!realizing/unrealizing! !
!UI.MessageBubble categoriesFor: #addTool!private!realizing/unrealizing! !
!UI.MessageBubble categoriesFor: #areLinksParsed!public!testing! !
!UI.MessageBubble categoriesFor: #areLinksParsed:!accessing-styles!public! !
!UI.MessageBubble categoriesFor: #backcolor!accessing!public! !
!UI.MessageBubble categoriesFor: #backcolor:!accessing!public! !
!UI.MessageBubble categoriesFor: #close!public!realizing/unrealizing! !
!UI.MessageBubble categoriesFor: #createTooltip!private!realizing/unrealizing! !
!UI.MessageBubble categoriesFor: #defaultCaption!displaying!private! !
!UI.MessageBubble categoriesFor: #font!accessing!public! !
!UI.MessageBubble categoriesFor: #font:!accessing!public! !
!UI.MessageBubble categoriesFor: #forecolor!accessing!public! !
!UI.MessageBubble categoriesFor: #forecolor:!accessing!public! !
!UI.MessageBubble categoriesFor: #hasCloseButton!public!testing! !
!UI.MessageBubble categoriesFor: #hasCloseButton:!public!testing! !
!UI.MessageBubble categoriesFor: #iconStyleFlag!accessing-styles!private! !
!UI.MessageBubble categoriesFor: #iconStyleFlag:!accessing-styles!private! !
!UI.MessageBubble categoriesFor: #initialize!initializing!private! !
!UI.MessageBubble categoriesFor: #initializeTooltip!private!realizing/unrealizing! !
!UI.MessageBubble categoriesFor: #isAnimated!accessing!public!testing! !
!UI.MessageBubble categoriesFor: #isAnimated:!accessing-styles!public! !
!UI.MessageBubble categoriesFor: #isBalloon!accessing!public!testing! !
!UI.MessageBubble categoriesFor: #isBalloon:!accessing-styles!public! !
!UI.MessageBubble categoriesFor: #isCentered!public!testing! !
!UI.MessageBubble categoriesFor: #isCentered:!accessing-styles!public! !
!UI.MessageBubble categoriesFor: #isModal!accessing-styles!public!testing! !
!UI.MessageBubble categoriesFor: #margins!accessing!public! !
!UI.MessageBubble categoriesFor: #margins:!accessing!public! !
!UI.MessageBubble categoriesFor: #maxWidth!accessing!public! !
!UI.MessageBubble categoriesFor: #maxWidth:!accessing!public! !
!UI.MessageBubble categoriesFor: #onPopped!event handling!private! !
!UI.MessageBubble categoriesFor: #onShowTip:!event handling!private! !
!UI.MessageBubble categoriesFor: #open!public!realizing/unrealizing! !
!UI.MessageBubble categoriesFor: #owner!public! !
!UI.MessageBubble categoriesFor: #position!accessing!public! !
!UI.MessageBubble categoriesFor: #position:!accessing!public! !
!UI.MessageBubble categoriesFor: #startTimeout!private!realizing/unrealizing! !
!UI.MessageBubble categoriesFor: #timeout!accessing!public! !
!UI.MessageBubble categoriesFor: #timeout:!accessing!public! !
!UI.MessageBubble categoriesFor: #tooltip!accessing!private! !
!UI.MessageBubble categoriesFor: #trackPosition!operations!private! !
!UI.MessageBubble categoriesFor: #willFade!accessing-styles!public!testing! !
!UI.MessageBubble categoriesFor: #willFade:!accessing-styles!public! !

!UI.MessageBubble class methodsFor!

icon
	^Tooltip icon!

initialize
	"Private - Initialize the class variables of the receiver:
		self initialize
	"

	self addClassConstant: 'IconIds'
		value: (ByteArray
				with: MB_ICONINFORMATION
				with: MB_ICONWARNING
				with: MB_ICONERROR)! !
!UI.MessageBubble class categoriesFor: #icon!constants!development!public! !
!UI.MessageBubble class categoriesFor: #initialize!class initialization!development!private! !

