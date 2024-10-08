﻿"Filed out from Dolphin Smalltalk"!

UI.MessageBoxAbstract
	subclass: #'UI.MessageBubble'
	instanceVariableNames: 'iconId tooltip position itemFlags timeout tooltipStyle timeoutProcess font forecolor backcolor margins maxWidth flags'
	classVariableNames: ''
	imports: #(#{OS.TooltipConstants} #{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: { 'IconIds' -> #[64 48 16]. 'LargeIconMask' -> 16r1. 'SilentMask' -> 16r2 }!

UI.MessageBubble guid: (Core.GUID fromString: '{00e5c07e-c4fc-471c-b037-25bc55861176}')!

UI.MessageBubble comment: '`MessageBubble` is similar to `MessageBox`, and supports a subset of its API. The principal difference is that messages are displayed using a `Tooltip` (normally a balloon tooltip), rather than in a traditional dialog. This provides a general capability for Dolphin applications to implement speech bubble style help like that which sometimes pops up for Windows tray icons. 

The other main differences from `MessageBox` are:
- `MessageBubble`s can only be used to display information, not garner a response (i.e. prompting for a yes/no or abort/retry/ignore response is not supported).
- The rich capabilities of the new Task Dialog based `MessageBox` to display custom buttons, expanding detail, progress bars, etc, are not supported.
- Normal message boxes are always modal, but MessageBubbles are modeless.
- If the optional close box is optional is not present then the bubble is closed when clicked.
- HTML hyperlinks can be embedded in MessageBubbles, with an event being fired when these are clicked, although this feature is now also available in the task-dialog based MessageBox.
- MessageBubbles support a timeout, allowing control over the maximum period for which a message is displayed until it ''pops'' (closes).
- The icon in a `MessageBubble` is limited to the standard system error, warning and notification icons, whereas `MessageBox` can display any icon. The icon can be displayed at small (16x16) or large (32x32) size.
- Traditional message boxes are usually displayed centred over the owner view, whereas the position of a `MessageBubble` is either the current cursor position, or a pre-defined position (specified in screen co-ordinates). The arrow of balloon-style bubbles points at this position.
- `MessageBubble` allows the message text font to be configured.

Example usage:
```
	(MessageBubble new)
		owner: Tools.SmalltalkSystemShell default view;
		position: (Tools.SmalltalkSystemShell default view mapPoint: 10@10 to: View desktop);
		hasCloseButton: true;
		timeout: 10 seconds;
		notify: ''Don''''t forget to save the image regularly!!''.
```

## Instance Variables:
  `iconId`			`<integer>` id of the system icon used in the caption.
  `tooltip`			`<Tooltip>` window implementing the actual bubble.
  `position`		`Point`. Absoluate screen position at which the bubble will appear.
  `itemFlags`		`<integer>` flags from the TTF_XXXX enumeration.
  `timeout`		`<Duration>` before the bubble closes automatically, or `nil` if no timeout.
  `tooltipStyle`		`<integer>` flags from the TTS_XXXX enumeration
  `timeoutProcess`	`Process` used to close the balloon after the timeout delay (if set).
  `font`			`Font` used to display text in the bubble
  `forecolor`		`<Color>` of text in the bubble, or `nil` if default.
  `backcolor`		`<Color>` of bubble background, or nil if default.
  `margins`		`<Object>` top, left, bottom and right margins between bubble border and text, in pels. `nil` if default.
  `maxWidth`		`<integer>` soft maximum width of the message text, or `nil` if default (the bubble will attempt to calculate a suitable size based on its content).
  `useLargeIcon`	`<boolean>` controlling whether the large (32x32) or small (16x16, default) icon is displayed in the bubble'!

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
				text: self text ?? '';
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
	tooltip bePopupFor: self owner.
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

	^IconIds at: iconId ifAbsent: 0!

iconStyleFlag: anInteger
	"Private - Set the receiver's icon to be that named by the argument."

	iconId := IconIds keyAtValue: anInteger ifAbsent: 0!

initialize
	iconId := 0.
	"TTF_TRACK is needed so the bubble come up where we tell it to, and not at the current cursor position"
	itemFlags := ##(TTF_PARSELINKS | TTF_TRACK | TTF_ABSOLUTE).
	timeout := 0 seconds.
	tooltipStyle := ##(TTS_BALLOON | TTS_NOPREFIX | TTS_NOFADE).
	maxWidth := SmallInteger maximum.	"Allows a tooltip with embedded CRs to go onto multiple lines"
	flags := 0!

initializeTooltip
	| cap |
	cap := self caption.
	(cap notEmpty or: [iconId ~= 0])
		ifTrue: [tooltip ttmSetTitle: cap icon: iconId + (self useLargeIcon ifTrue: [3] ifFalse: [0])].
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

isSilent
	"Answer whether the bubble will remain silent when opened. The default is to beep in an appropriate way depending on the icon style."

	^(flags allMask: SilentMask) or: [super isSilent]!

isSilent: aBoolean
	"Set whether the bubble will remain silent when opened. The default is to beep in an appropriate way depending on the icon style."

	flags := flags mask: SilentMask set: aBoolean!

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
	truncate the text."

	maxWidth := anIntegerOrNil.
	tooltip isNil ifFalse: [tooltip maxWidth: anIntegerOrNil]!

onPopped
	"Private - The tooltip has just been closed, e.g. because the close button has been pressed, or because of timeout."

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
	^owner ifNil: [View activeOrDesktop]!

position
	^position!

position: aPoint 
	position := aPoint.
	self trackPosition!

startTimeout
	timeout isZero
		ifFalse: [timeoutProcess := 
					[timeout wait.
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

useLargeIcon
	^flags allMask: LargeIconMask!

useLargeIcon: aBoolean
	flags := flags mask: LargeIconMask set: aBoolean!

willFade
	"Answer whether the bubble message will use the fade away when closed 
	(the default), assuming that the host system supports it."

	^tooltipStyle noMask: TTS_NOFADE!

willFade: aBoolean 
	"Set whether the bubble message will use the fade away when closed 
	(the default), assuming that the host system supports it. Changing this 
	style has no effect after opening."

	tooltipStyle := tooltipStyle mask: TTS_NOFADE set: aBoolean not! !

!UI.MessageBubble categoriesForMethods!
activateTooltip:!private!realizing/unrealizing! !
addTool!private!realizing/unrealizing! !
areLinksParsed!public!testing! !
areLinksParsed:!accessing-styles!public! !
backcolor!accessing!public! !
backcolor:!accessing!public! !
close!public!realizing/unrealizing! !
createTooltip!private!realizing/unrealizing! !
font!accessing!public! !
font:!accessing!public! !
forecolor!accessing!public! !
forecolor:!accessing!public! !
hasCloseButton!public!testing! !
hasCloseButton:!public!testing! !
iconStyleFlag!accessing-styles!private! !
iconStyleFlag:!accessing-styles!private! !
initialize!initializing!private! !
initializeTooltip!private!realizing/unrealizing! !
isAnimated!accessing!public!testing! !
isAnimated:!accessing-styles!public! !
isBalloon!accessing!public!testing! !
isBalloon:!accessing-styles!public! !
isCentered!public!testing! !
isCentered:!accessing-styles!public! !
isModal!accessing-styles!public!testing! !
isSilent!public!testing! !
isSilent:!public!testing! !
margins!accessing!public! !
margins:!accessing!public! !
maxWidth!accessing!public! !
maxWidth:!accessing!public! !
onPopped!event handling!private! !
onShowTip:!event handling!private! !
open!public!realizing/unrealizing! !
owner!public! !
position!accessing!public! !
position:!accessing!public! !
startTimeout!private!realizing/unrealizing! !
timeout!accessing!public! !
timeout:!accessing!public! !
tooltip!accessing!private! !
trackPosition!operations!private! !
useLargeIcon!accessing!public! !
useLargeIcon:!accessing!public! !
willFade!accessing-styles!public!testing! !
willFade:!accessing-styles!public! !
!

!UI.MessageBubble class methodsFor!

icon
	^Tooltip icon!

initialize
	"Private - Initialize the class variables of the receiver:
		self initialize
	"

	defaultCaptions := (IdentityDictionary
				withAll: { #notify -> 'Note'. #error -> 'Error'. #warning -> 'Warning' })
				beImmutableObject;
				yourself.
	self addClassConstant: 'IconIds'
		value: (ByteArray
				with: MB_ICONINFORMATION
				with: MB_ICONWARNING
				with: MB_ICONERROR)! !

!UI.MessageBubble class categoriesForMethods!
icon!constants!development!public! !
initialize!class initialization!development!private! !
!

