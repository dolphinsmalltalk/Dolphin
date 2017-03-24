"Filed out from Dolphin Smalltalk 7"!

View subclass: #ControlView
	instanceVariableNames: 'forecolor oldWndProc'
	classVariableNames: 'CommonControlCallError NmMap'
	poolDictionaries: 'CommCtrlConstants'
	classInstanceVariableNames: ''!
ControlView guid: (GUID fromString: '{87b4c70d-026e-11d3-9fd7-00a0cc3e4a32}')!
ControlView comment: 'ControlView is the abstract superclass for all <view>s that are based on Windows controls. In general, controls are responsible for their own painting and so it is not necessary, or advisable, to override #onPaintRequired: in any of the ControlView subclasses.

Some controls, but not all, allow control over the foreground and background colours used when painting. If neither of the #forecolor and #backcolor aspects is explicitly set then the default control colours will be used.

In general, if you wish to add a new Windows control that is not already present in the system, then the usual place to start is by adding a subclass below ControlView.

Instance Variables:
	forecolor			<color> or nil, to use as an explicit foreground color.
	oldWndProc		<integer> representing the ExternalAddress of the original control window procedure.

Class Variables:
	CommonControlCallError	<exceptionSignaler> to signal if an error occurs during a message to a common control.
	NmMap			<IdentityDictionary> map of Windows notification messages to <selector>s.

'!
!ControlView categoriesForClass!MVP-Views! !
!ControlView methodsFor!

backcolorChanged
	self setControlBackcolor: self actualBackcolor.
	super backcolorChanged!

ccmSetVersion: anInteger
	"Inform the contorl that behavior compliant with a particular common control version is expected."

	^self sendMessage: CCM_SETVERSION wParam: anInteger lParam: 0!

clearHandle
	super clearHandle.
	oldWndProc := nil
	!

defaultWindowProcessing: message wParam: wParam lParam: lParam
	"Private - Pass a message to the 'default' window procedure of the receiver."

	^UserLibrary default
		callWindowProc: oldWndProc
		hWnd: handle
		msg: message
		wParam: wParam
		lParam: lParam!

defaultWindowStyle
	"Private - Answer a default style to use when creating an instance of the receiver.
	All controls have the WS_TABSTOP style by default.

	WARNING: There is a bug in the Windows tabbing algorithm.
	We specify the WS_EX_CONTROLPARENT style for ContainerViews otherwise tabs only
	work between siblings in a single level. If a ContainerView with this style
	contains no tabbable subViews, then pressing the TAB key will causes the
	application to hang."

	^super defaultWindowStyle bitOr: WS_TABSTOP
!

errorInCommonControlCall
	"A call to one of the common control has failed, raise an exception.
	If this is because the view is closed then raise a ViewClosedError"

	^(self isOpen 
		ifTrue: [self class commonControlCallError]
		ifFalse: [self class viewClosedError]) signalWith: self!

errorOutOfMemory
	"Raise a OutOfMemoryError indicating that the receiver has run out of space"

	^OutOfMemoryError signal!

fontChanged
	"Apply the receiver' font to the associated Windows control"

	super fontChanged.
	self setFont: self actualFont!

forecolor
	"Answers the foreground colour of the receiver"

	^forecolor
!

forecolor: aColorOrNil
	"Sets the foreground colour of the receiver to aColorOrNil.
	If aColorOrNil is nil then use the default color"

	forecolor := aColorOrNil.
	self invalidate.
!

itemFromId: dwItemSpec 
	"Private - Answers the sub-item of the receiver with the specified <integer> item spec,
	or nil if there is no such item. This is only relevant to controls that contain visual elements
	that are not themselves windows, such as toolbars."

	^nil!

nmClick: pNMHDR
	"Default handler for a NM_CLICK notification message.
	The return value for this notification is ignored by most subclasses, 
	though generally returning 0 will allow the control's default
	processing, returning a non-zero value will suppress the control's
	default processing."

	^0!

nmCustomDraw: pNMHDR
	"Default handler for a NM_CUSTOMDRAW notification message.
	Answer nil to accept default processing."

	^nil!

nmDblClk: pNMHDR
	"Default handler for a NM_DBLCLK notification message.
	Answer nil to accept default processing."

	^nil!

nmDummy: pNMHDR
	"Default handler for an uninteresting notification message.
	Answer nil to accept default processing."

	^nil!

nmEndWait: pNMHDR
	"Default handler for a NM_ENDWAIT notification message.
	Answer nil to accept default processing."

	^nil
!

nmHover: pNMHDR
	"Default handler for a NM_HOVER notification message.
	Answer nil to accept default processing."

	^nil!

nmKeyDown: pNMHDR
	"Default handler for a NM_KEYDOWN notification message.
	Answer nil to accept default processing.
	Subclasses may answer 0 to prevent the control from processing the key press."

	^nil!

nmKillFocus: pNMHDR
	"Default handler for a NM_KILLFOCUS notification message.
	Answer nil to accept default processing."

	^nil
!

nmNotify: pNMHDR
	"Private - Handler for a redirected generic WM_NOTIFY message."

	^(NmMap lookup: (pNMHDR sdwordAtOffset: 8)) ifNotNil: [:action | self perform: action with: pNMHDR]!

nmOutOfMemory: pNMHDR
	"Default handler for a NM_OUTOFMEMORY notification message.
	Signal an OutOfMemoryError"

	^self errorOutOfMemory
!

nmRClick: pNMHDR
	"Default handler for a NM_RCLICK notification message.
	The return value for this notification is ignored by most subclasses, 
	though generally returning 0 will allow the control's default
	processing, returning a non-zero value will suppress the control's
	default processing."

	^nil!

nmRDblClk: pNMHDR
	"Default handler for a NM_RDBLCLK notification message.
	Answer nil to accept default processing."

	^nil
!

nmReturn: pNMHDR
	"Default handler for a NM_RETURN notification message.
	Answer nil to accept default processing."

	^nil
!

nmSetFocus: pNMHDR
	"Default handler for a NM_SETFOCUS notification message.
	Answer nil to accept default processing."

	^nil!

nmStartWait: pNMHDR
	"Default handler for a NM_STARTWAIT notification message.
	Answer nil to accept default processing."

	^nil
!

oldWndProc
	"Private - Answer the window procedure of the control before we subclassed it."

	^oldWndProc!

oldWndProc: anAddress
	"Private - Set the window procedure of the control before we subclassed it."

	oldWndProc := anAddress!

onColorRequired: aColorEvent
	"Private - Colour event handler for aColorEvent. We set up the canvas provided by the event
	with the appropriate foreground and background colours for the receiver. Windows
	WM_CTLCOLORXXX messages require that we answer the background brush handle."

	"Implementation Note: From MSDN: 'The system does not automatically destroy the returned
	brush. It is the application's responsibility to destroy the brush when it is no longer
	needed.'. This presents us with a lifetime management issue for the brush that unfortunately
	requires that we store it into an instance variable."

	| canvas back brush |
	back := self basicActualBackcolor.
	canvas := aColorEvent canvas.
	back isDefault
		ifTrue: [brush := aColorEvent defaultWindowProcessing]
		ifFalse: 
			[brush := back brush.
			back isNone
				ifTrue: 
					[self paintTransparentBackgroundOn: canvas.
					canvas backgroundMode: TRANSPARENT]
				ifFalse: [canvas backcolor: back].
			canvas brush: brush].
	self forecolor ifNotNil: [:fore | canvas forecolor: fore].
	^brush asParameter!

onEraseRequired: aColorEvent 
	"Handler for erase background event - allow the control to take care of this, unless
	transparent backcolor is set in which case the erase is suppressed.."

	self actualBackcolor isNone ifTrue: [^true].
	^nil!

onInputMaskRequired: anEvent
	"Handler for a WM_GETDLGCODE request from Windows.
	Most controls will have their own specific implementation, so we override
	to just call the controls wndproc."

	^anEvent defaultWindowProcessing!

onViewCreated
	"The receiver's window has been created. Copy any instance variable information
	across."

	super onViewCreated.
	self setFont: self actualFont!

paintTransparentBackgroundOn: canvas 
	"Private - Paint the parent background behind the control onto the <Canvas> argument for partially transparent controls.
	The default is to do nothing, and generally nothing is needed as the controls will handle this correctly themselves."

	!

setControlBackcolor
	| color |
	color := self basicActualBackcolor.
	color isDefault ifFalse: [self setControlBackcolor: color]!

setControlBackcolor: anIndexedColor 
	"Private - Overridden by subclasses wrapping controls that support a background colour."

	!

setFont: aFont
	"Private - Apply the specified font to the receiver's associated 
	Windows control"
	
	"Ensure that the font is realized for the view resolution; i.e. the screen's
	logical pixel's per inch."
	aFont resolution: self resolution.
	
	self sendMessage: WM_SETFONT wParam: aFont asParameter lParam: 1.!

subclassWindow: hWnd
	"Private - Subclass the receiver's associated Win32 window by substituting the VM's 
	window procedure and saving the control's one, and record hWnd as the handle 
	of the receiver's window."

	super subclassWindow: hWnd.
	self subclassWindow!

ttnGetDispInfo: anNMTTDISPINFO 
	"Private - Generic handler for the TTN_GETDISPINFO(A/W) notification message."

	^anNMTTDISPINFO idIsHandle 
		ifTrue: 
			[(View withHandle: anNMTTDISPINFO idFrom) 
				ifNotNil: [:view | view presenter onTipDetailsRequired: anNMTTDISPINFO]]
		ifFalse: 
			[(self itemFromId: anNMTTDISPINFO idFrom) 
				ifNotNil: 
					[:tool | 
					anNMTTDISPINFO text: (self presenter onTipTextRequired: tool).
					0]]!

ttnGetDispInfoA: pNMHDR 
	"Private - Default handler for the TTN_GETDISPINFOA notification message."

	"Implementation Note: Tool tips do not appear on Win95 unless we implement
	the ANSI version."

	^self ttnGetDispInfo: (NMTTDISPINFOA fromAddress: pNMHDR)!

ttnGetDispInfoW: pNMHDR 
	"Private - Default handler for the TTN_GETDISPINFOW notification message."

	"Implementation Note: Tool tips do not appear on NT4.0 unless we implement 
	the Unicode version, so like the MFC we implement both handlers."

	^self ttnGetDispInfo: (NMTTDISPINFOW fromAddress: pNMHDR)!

wantParentNotifications
	"Answer whether the receiver's parent receiver notifications from the receiver
	according to aBoolean.
	N.B. Dolphin reflects these notifications back to the receiver."

	^(self exStyleAllMask: WS_EX_NOPARENTNOTIFY) not!

wantParentNotifications: aBoolean
	"Set the whether the receiver's parent receivers notifications from the receiver
	according to aBoolean.
	N.B. Dolphin reflects these notifications back to the receiver."

	self exStyleMask: WS_EX_NOPARENTNOTIFY set: aBoolean not recreateIfChanged: false!

withOldWndProc: operation 
	"Private - Evaluate the niladic valuable, operation, with the old (unsubclassed) window
	procedure. This avoids us having to process (and slow down!!) messages in which we are not
	interested."

	self setWndProc: self oldWndProc.
	^operation ensure: [self setWndProc: VMLibrary default getWndProc]!

wmPaint: message wParam: wParam lParam: lParam 
	"Private - Controls do their own painting so only allow the default."

	self ensureLayoutValid.
	^self defaultWindowProcessing: message wParam: wParam lParam: lParam!

wmPrintClient: message wParam: wParam lParam: lParam 
	self ensureLayoutValid.
	^nil!

wmSysColorChange: message wParam: wParam lParam: lParam
	"Private - A system color has occurred. Just accept the default window processing as the
	control should handle it."

	^nil!

wmWindowPosChanged: message wParam: wParam lParam: lParam
	"Private - The position of the receiver is about to change in some manner.
	The superclass doesn't invoke default window processing in order to suppress
	the old WM_SIZE and WM_MOVE events which aren't needed by Dolphin 3.0,
	however most controls still depended on these messages so we must override to
	cause the default processing to be invoked."

	super wmWindowPosChanged: message wParam: wParam lParam: lParam.
	^nil	"Accept default processing"
! !
!ControlView categoriesFor: #backcolorChanged!helpers!private! !
!ControlView categoriesFor: #ccmSetVersion:!operations!public! !
!ControlView categoriesFor: #clearHandle!private!realizing/unrealizing! !
!ControlView categoriesFor: #defaultWindowProcessing:wParam:lParam:!dispatching!private! !
!ControlView categoriesFor: #defaultWindowStyle!constants!private! !
!ControlView categoriesFor: #errorInCommonControlCall!exceptions!public! !
!ControlView categoriesFor: #errorOutOfMemory!exceptions!public! !
!ControlView categoriesFor: #fontChanged!public!updating! !
!ControlView categoriesFor: #forecolor!accessing!public! !
!ControlView categoriesFor: #forecolor:!accessing!public! !
!ControlView categoriesFor: #itemFromId:!accessing!private! !
!ControlView categoriesFor: #nmClick:!event handling-win32!private! !
!ControlView categoriesFor: #nmCustomDraw:!event handling-win32!private! !
!ControlView categoriesFor: #nmDblClk:!event handling-win32!private! !
!ControlView categoriesFor: #nmDummy:!event handling-win32!private! !
!ControlView categoriesFor: #nmEndWait:!event handling-win32!private! !
!ControlView categoriesFor: #nmHover:!event handling-win32!private! !
!ControlView categoriesFor: #nmKeyDown:!event handling-win32!private! !
!ControlView categoriesFor: #nmKillFocus:!event handling-win32!private! !
!ControlView categoriesFor: #nmNotify:!event handling-win32!private! !
!ControlView categoriesFor: #nmOutOfMemory:!event handling-win32!private! !
!ControlView categoriesFor: #nmRClick:!event handling-win32!private! !
!ControlView categoriesFor: #nmRDblClk:!event handling-win32!private! !
!ControlView categoriesFor: #nmReturn:!event handling-win32!private! !
!ControlView categoriesFor: #nmSetFocus:!event handling-win32!private! !
!ControlView categoriesFor: #nmStartWait:!event handling-win32!private! !
!ControlView categoriesFor: #oldWndProc!accessing!private! !
!ControlView categoriesFor: #oldWndProc:!accessing!private! !
!ControlView categoriesFor: #onColorRequired:!event handling!private! !
!ControlView categoriesFor: #onEraseRequired:!event handling!public! !
!ControlView categoriesFor: #onInputMaskRequired:!event handling!public! !
!ControlView categoriesFor: #onViewCreated!event handling!public! !
!ControlView categoriesFor: #paintTransparentBackgroundOn:!private!updating! !
!ControlView categoriesFor: #setControlBackcolor!helpers!private! !
!ControlView categoriesFor: #setControlBackcolor:!helpers!private! !
!ControlView categoriesFor: #setFont:!accessing!private! !
!ControlView categoriesFor: #subclassWindow:!operations!private! !
!ControlView categoriesFor: #ttnGetDispInfo:!event handling-win32!private! !
!ControlView categoriesFor: #ttnGetDispInfoA:!event handling-win32!private! !
!ControlView categoriesFor: #ttnGetDispInfoW:!event handling-win32!private! !
!ControlView categoriesFor: #wantParentNotifications!accessing-styles!public! !
!ControlView categoriesFor: #wantParentNotifications:!accessing-styles!public! !
!ControlView categoriesFor: #withOldWndProc:!dispatching!private! !
!ControlView categoriesFor: #wmPaint:wParam:lParam:!event handling-win32!private! !
!ControlView categoriesFor: #wmPrintClient:wParam:lParam:!event handling-win32!private! !
!ControlView categoriesFor: #wmSysColorChange:wParam:lParam:!event handling-win32!private! !
!ControlView categoriesFor: #wmWindowPosChanged:wParam:lParam:!event handling-win32!private! !

!ControlView class methodsFor!

commonControlCallError
	"Answer the exceptionSignaler/exceptionSelector used to signal/catch common
	control message errors."

	^CommonControlCallError!

initialize
	"Private - Initialise the map of generic notification codes to selectors. We could use an
	array, but a dictionary is more convenient and loses very little in performance.

		ControlView initialize
	"

	CommonControlCallError := Signal description: 'Common control call failed'.

	self initializeNotificationMap!

initializeNotificationMap
	"Private - Initialise the receiver's map between notification codes and the selector of
	the corresponding event handlers in the receiver. N.B. Must not be stripped in order
	to prevent notification handlers from being stripped."

	NmMap := IdentityDictionary new.
	NmMap
		at: NM_OUTOFMEMORY put: #nmOutOfMemory:;
		at: NM_CLICK put: #nmClick:;
		at: NM_DBLCLK put: #nmDblClk:;
		at: NM_RETURN put: #nmReturn:;
		at: NM_RCLICK put: #nmRClick:;
		at: NM_RDBLCLK put: #nmRDblClk:;
		at: NM_SETFOCUS put: #nmSetFocus:;
		at: NM_KILLFOCUS put: #nmKillFocus:;
		at: -9 put: #nmStartWait:;
		at: -10 put: #nmEndWait:;
		at: -11 put: #nmDummy:.

	"IE3 Notifications - Common controls version 4.70"
	NmMap
		at: NM_CUSTOMDRAW put: #nmCustomDraw:;
		at: NM_HOVER put: #nmHover:.

	"IE4 Notifications - Common controls version 4.71"
	NmMap
		at: NM_NCHITTEST put: #nmDummy:;
		at: NM_KEYDOWN put: #nmKeyDown:;
		at: NM_RELEASEDCAPTURE put: #nmDummy:;
		at: NM_SETCURSOR put: #nmDummy:;
		at: NM_CHAR put: #nmDummy:.

	"Tooltip support - because these are discontinuous, we can't use an array for the lookup table here"
	NmMap
		at: TTN_GETDISPINFOW put: #ttnGetDispInfoW:;
		at: TTN_GETDISPINFOA put: #ttnGetDispInfoA:.
	NmMap shrink!

maxTextLimit
	"Answer the absolute maximum amount of text that the receiver can ever hold."

	^16r7FFFFFFE!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^self subclassResponsibility! !
!ControlView class categoriesFor: #commonControlCallError!constants!public! !
!ControlView class categoriesFor: #initialize!development!initializing!private! !
!ControlView class categoriesFor: #initializeNotificationMap!initializing!must not strip!private! !
!ControlView class categoriesFor: #maxTextLimit!constants!public! !
!ControlView class categoriesFor: #winClassName!constants!private! !

