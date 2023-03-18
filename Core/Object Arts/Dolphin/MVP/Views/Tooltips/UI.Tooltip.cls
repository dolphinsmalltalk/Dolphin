"Filed out from Dolphin Smalltalk"!

UI.ControlView
	subclass: #'UI.Tooltip'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.TooltipConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tooltip guid: (Core.GUID fromString: '{ba32bd21-5167-4bd1-949c-ab76875cdeb7}')!
UI.Tooltip comment: 'Tooltip is a <ControlView> class which wraps the Windows Tool Tip control.'!
!UI.Tooltip categoriesForClass!MVP-Views! !
!UI.Tooltip methodsFor!

add: aTOOLINFOA tool: aView 
	"Adds a tool tip for aWinWindow to the receiever."

	self ttmAddTool: aTOOLINFOA.
	aView toolTipWindow: self!

alwaysTip
	^self baseStyleAllMask: TTS_ALWAYSTIP!

alwaysTip: aBoolean 
	self 
		baseStyleMask: TTS_ALWAYSTIP
		set: aBoolean
		recreateIfChanged: false!

defaultBackcolor
	^Color tooltip!

endTracking
	self sendMessage: TTM_TRACKACTIVATE wParam: false asParameter!

forecolor: aColorOrNil
	"Sets the foreground colour of the receiver to aColorOrNil.
	If aColorOrNil is nil then use the default color"

	| clrref |
	super forecolor: aColorOrNil.
	clrref := (aColorOrNil isNil ifTrue: [Color tooltipText] ifFalse: [aColorOrNil]) asCOLORREF.
	self sendMessage: TTM_SETTIPTEXTCOLOR wParam: clrref!

hasCloseButton
	"Answer whether the balloon tooltip has a close button."

	^self baseStyleAllMask: TTS_CLOSE!

hasCloseButton: aBoolean
	"Set whether the bubble message will have a close button,
	off by default. Changing this style has no effect once opened."

	self 
		baseStyleMask: TTS_CLOSE
		set: aBoolean
		recreateIfChanged: false!

isActive: aBoolean 
	"Activate or deactivate the tips, depending on the <Boolean> argument."

	self sendMessage: TTM_ACTIVATE wParam: aBoolean asParameter!

isBalloon
	"Answer whether the receiver has the balloon (speech bubble) style."

	^self baseStyleAllMask: TTS_BALLOON!

isBalloon: aBoolean 
	"Sets the rectangle style of this static control."

	self 
		baseStyleMask: TTS_BALLOON
		set: aBoolean
		recreateIfChanged: false!

margins
	"Answer a <Rectangle> specifying the left, right, top and bottom margins.
	Each margin is the distance in pixels between the relevant edge and the tip text."

	| rect |
	rect := RECTL newBuffer.
	self
		sendMessage: TTM_GETMARGIN
		wParam: 0
		lpParam: rect.
	^rect asRectangle!

margins: aRectangle 
	self 
		sendMessage: TTM_SETMARGIN
		wParam: 0
		lpParam: aRectangle asParameter!

maxWidth
	"Answer the maximum width of the tip, or -1 if none is specified.
	If a maximum width is set and the tip text needs more space, then 
	the tip window will expand to multiple lines."

	^self sendMessage: TTM_GETMAXTIPWIDTH!

maxWidth: anInteger 
	self 
		sendMessage: TTM_SETMAXTIPWIDTH
		wParam: 0
		lParam: anInteger!

nmNotify: pNMHDR
	"Private - Handler for a redirected WM_NOTIFY message."

	^(##((Array new: TTN_FIRST - TTN_LINKCLICK + 1 withAll: #nmDummy:)
		at: TTN_FIRST - TTN_SHOW + 1 put: #ttnShow:;
		at: TTN_FIRST - TTN_POP + 1 put: #ttnPop:;
		at: TTN_FIRST - TTN_LINKCLICK + 1 put: #ttnLinkClick:;
		yourself) lookup: ##(TTN_FIRST + 1) - (pNMHDR int32AtOffset: 8))
		ifNil: [super nmNotify: pNMHDR]
		ifNotNil: [:action | self perform: action with: pNMHDR]!

onLeftButtonReleased: aMouseEvent 
	"Default handler for a Left button up mouse event.
	Accept the default window processing."

	self hasCloseButton ifFalse: [
			[self
				pop;
				close] postToMessageQueue].
	^super onLeftButtonPressed: aMouseEvent!

onLinkClicked
	"A hyperlink embedded in the text of the tooltip has been clicked."

	self presenter trigger: #linkClicked.
	^nil!

onPop
	"The ToolTip is about to be hidden."

	self presenter trigger: #tipPopped!

onShow
	"The ToolTip is about to be shown. Answer false to display the tooltip in its default position. 
	Or reposition the tooltip (with SetWindowPos) and return true to suppress the default 
	positioning."

	| suppress |
	suppress := false asValue.
	self presenter trigger: #showTip: with: suppress.
	^suppress value!

pop
	self sendMessage: TTM_POP!

registerView: aView
	self ttmAddTool: (TOOLINFOW new
				uFlags: ##(TTF_IDISHWND | TTF_CENTERTIP);
				textCallback;
				hwnd: aView asParameter;
				uId: aView asParameter;
				yourself)!

reshowDelay
	"Answer the <integer> number of milliseconds of delay between appearances of the tip window
	after it has popped up the first time - e.g. when sliding between buttons in a toolbar."

	^self ttmGetDelayTime: TTDT_RESHOW!

reshowDelay: anInteger 
	"Set the number of milliseconds of delay between appearances of the tip window after 
	it has popped up the first time - e.g. when sliding between buttons in a toolbar, to the
	<integer> argument."

	self ttmSetDelayTime: TTDT_RESHOW milliseconds: anInteger!

setControlBackcolor: aColor 
	self sendMessage: TTM_SETTIPBKCOLOR wParam: aColor asCOLORREF!

showDelay
	"Answer the <integer> number of milliseconds that the mouse must remain stationary
	over a tool before the tip window appears for the first time."

	^self ttmGetDelayTime: TTDT_INITIAL!

showDelay: anInteger 
	"Set the number of milliseconds that the mouse must remain stationary
	over a tool before the tip window appears for the first time to the 
	<integer> argument."

	self ttmSetDelayTime: TTDT_INITIAL milliseconds: anInteger!

showDuration
	"Answer the <integer> number of milliseconds that is the maximum period for which
	the tip window will be shown, even if the mouse remains stationary."

	^self ttmGetDelayTime: TTDT_AUTOPOP!

showDuration: anInteger 
	"Set the number of milliseconds that is the maximum period for which
	the tip window will be shown, even if the mouse remains stationary,
	to the <integer> argument."

	self ttmSetDelayTime: TTDT_AUTOPOP milliseconds: anInteger!

startTracking: aTOOLINFO 
	self 
		sendMessage: TTM_TRACKACTIVATE
		wParam: true asParameter
		lpParam: aTOOLINFO!

tools
	^(0 to: self ttmGetToolCount - 1) collect: 
			[:each |
			| tool |
			tool := TOOLINFOW new.
			self ttmEnumTools: each info: tool.
			tool]!

trackPosition: aPoint 
	self 
		sendMessage: TTM_TRACKPOSITION
		wParam: 0
		lParam: aPoint asUIntPtr!

ttmAddTool: aTOOLINFOW
	"Register a new tool with the receiver."

	(self
		sendMessage: TTM_ADDTOOLW
		wParam: 0
		lpParam: aTOOLINFOW asParameter) == 0
		ifTrue: [^self errorInCommonControlCall]!

ttmDelTool: aTOOLINFOW
	"Unregister a tool from the receiver."

	self
		sendMessage: TTM_DELTOOLW
		wParam: 0
		lpParam: aTOOLINFOW asParameter!

ttmEnumTools: anInteger info: aTOOLINFOW
	"Enumerate the tools set up for the receiver."

	^(self
		sendMessage: TTM_ENUMTOOLSW
		wParam: anInteger
		lpParam: aTOOLINFOW) asBoolean!

ttmGetCurrentTool
	"Retrieve the text for the current tool."

	| struct |
	struct := TOOLINFOW new.
	^(self
		sendMessage: TTM_GETCURRENTTOOLW
		wParam: 0
		lpParam: struct) == 0
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [struct]!

ttmGetDelayTime: anInteger 
	^self sendMessage: TTM_GETDELAYTIME wParam: anInteger!

ttmGetMargin
	| answer |
	answer := RECTL newBuffer.
	(self
		sendMessage: TTM_GETMARGIN
		wParam: 0
		lpParam: answer) == 0
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [answer]!

ttmGetToolCount
	"Answer the number of tools with which the receiver is associated."

	^self sendMessage: TTM_GETTOOLCOUNT!

ttmGetToolInfo: aTOOLINFOW
	"Retrieve tool details identified in aTOOLINFOW, filling out the structure."

	(self
		sendMessage: TTM_GETTOOLINFOW
		wParam: 0
		lpParam: aTOOLINFOW asParameter) == 0
		ifTrue: [^self errorInCommonControlCall]!

ttmRelayEvent: aMSG 
	"Private - Forward the windows mouse message, aMSG, to the tool tip control."

	self 
		sendMessage: TTM_RELAYEVENT
		wParam: 0
		lpParam: aMSG asParameter.
	"Return false as we don't want to consume the MSG"
	^false!

ttmSetDelayTime: dwInteger milliseconds: msInteger 
	self 
		sendMessage: TTM_SETDELAYTIME
		wParam: dwInteger
		lParam: msInteger!

ttmSetTitle: aString icon: anInteger
	self
		sendMessage: TTM_SETTITLEW
		wParam: anInteger
		szParam: aString!

ttnLinkClick: pNMHDR 
	"Default handler for the TTN_LINKCLICK message, which is a notification that the 
	user has clicked an underlined link in the tooltip. Answer nil to accept the default processing."

	^self presenter onLinkClicked!

ttnPop: anNMHDR 
	"Default handler for the TTN_POP message, which is a notification that the tooltip
	window is about to be hidden. Answer nil to accept the default processing."

	self presenter onPop.
	^nil!

ttnShow: anNMHDR 
	"Private - Handler for the TTN_SHOW message, which is forwarded to the presenter."

	^self presenter onShow! !
!UI.Tooltip categoriesForMethods!
add:tool:!operations!private! !
alwaysTip!public!testing! !
alwaysTip:!accessing!public! !
defaultBackcolor!colors!constants!public! !
endTracking!operations!public! !
forecolor:!accessing!public! !
hasCloseButton!public!testing! !
hasCloseButton:!accessing!public! !
isActive:!accessing!public! !
isBalloon!public!testing! !
isBalloon:!accessing!public! !
margins!accessing!public! !
margins:!accessing!public! !
maxWidth!accessing!public! !
maxWidth:!accessing!public! !
nmNotify:!events-win32!private! !
onLeftButtonReleased:!event handling!public! !
onLinkClicked!event handling!public! !
onPop!events-win32!public! !
onShow!events-win32!public! !
pop!operations!public! !
registerView:!operations!private! !
reshowDelay!accessing!public! !
reshowDelay:!accessing!public! !
setControlBackcolor:!helpers!private! !
showDelay!accessing!public! !
showDelay:!accessing!public! !
showDuration!accessing!public! !
showDuration:!accessing!public! !
startTracking:!operations!public! !
tools!operations!private! !
trackPosition:!geometry!public! !
ttmAddTool:!operations!private! !
ttmDelTool:!operations!private! !
ttmEnumTools:info:!operations!private! !
ttmGetCurrentTool!accessing!private! !
ttmGetDelayTime:!accessing!private! !
ttmGetMargin!accessing!private! !
ttmGetToolCount!accessing!private! !
ttmGetToolInfo:!accessing!private! !
ttmRelayEvent:!operations!private! !
ttmSetDelayTime:milliseconds:!accessing!private! !
ttmSetTitle:icon:!operations!private! !
ttnLinkClick:!events-win32!private! !
ttnPop:!events-win32!private! !
ttnShow:!events-win32!private! !
!

!UI.Tooltip class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

themePartName
	^#Tooltip!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'tooltips_class32'
! !
!UI.Tooltip class categoriesForMethods!
icon!constants!public! !
themePartName!constants!private! !
winClassName!constants!private! !
!

