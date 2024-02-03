"Filed out from Dolphin Smalltalk"!

UI.View
	subclass: #'UI.ControlView'
	instanceVariableNames: 'forecolor oldWndProc'
	classVariableNames: 'CommonControlCallError'
	imports: #(#{OS.CommCtrlConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ControlView guid: (Core.GUID fromString: '{87b4c70d-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ControlView comment: 'ControlView is the abstract superclass for all <view>s that are based on Windows controls. In general, controls are responsible for their own painting and so it is not necessary, or advisable, to override #onPaintRequired: in any of the ControlView subclasses.

Some controls, but not all, allow control over the foreground and background colours used when painting. If neither of the #forecolor and #backcolor aspects is explicitly set then the default control colours will be used.

In general, if you wish to add a new Windows control that is not already present in the system, then the usual place to start is by adding a subclass below ControlView.

Instance Variables:
	forecolor			<color> or nil, to use as an explicit foreground color.
	oldWndProc		<integer> representing the ExternalAddress of the original control window procedure.

Class Variables:
	CommonControlCallError	<exceptionSignaler> to signal if an error occurs during a message to a common control.
	NmMap			<IdentityDictionary> map of Windows notification messages to <selector>s.

'!
!UI.ControlView categoriesForClass!MVP-Views! !
!UI.ControlView methodsFor!

applyFont
	"Private - Apply the receiver's font to the associated Windows control"

	super applyFont.
	self setFont: self actualFont!

backcolorChanged
	self setControlBackcolor: self actualBackcolor.
	super backcolorChanged!

ccmGetVersion
	^self sendMessage: CCM_GETVERSION!

ccmSetVersion: anInteger
	"Inform the contorl that behavior compliant with a particular common control version is expected."

	^self sendMessage: CCM_SETVERSION wParam: anInteger lParam: 0!

clearHandle
	handle := oldWndProc := nil!

commonNotificationMap
	"Private - Answer a 'map' between notification codes and the selector of the corresponding event handlers in the receiver. 
	We used to store this in a class variable, but then special steps are needed to ensure the notification handlers are not stripped during application deployment. By returning a constant from a method we ensure that the notification handlers are always reachable when traversing the reference graph."

	^##(| nmMap |
	nmMap := IdentityDictionary new.
	nmMap
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
	nmMap
		at: NM_CUSTOMDRAW put: #nmCustomDraw:;
		at: NM_HOVER put: #nmHover:.

	"IE4 Notifications - Common controls version 4.71"
	nmMap
		at: NM_NCHITTEST put: #nmDummy:;
		at: NM_KEYDOWN put: #nmKeyDown:;
		at: NM_RELEASEDCAPTURE put: #nmDummy:;
		at: NM_SETCURSOR put: #nmDummy:;
		at: NM_CHAR put: #nmDummy:;
		at: NM_TOOLTIPSCREATED put: #nmDummy:;
		at: NM_LDOWN put: #nmDummy:;
		at: NM_RDOWN put: #nmDummy:;
		at: NM_THEMECHANGED put: #nmDummy:;
		at: NM_FONTCHANGED put: #nmDummy:;
		at: NM_CUSTOMTEXT put: #nmDummy:.

	"Tooltip support - because these are discontinuous, we can't use an array for the lookup table here"
	nmMap at: TTN_GETDISPINFOW put: #ttnGetDispInfoW:.
	nmMap shrink.
	nmMap)!

defaultWindowProcessing: message wParam: wParam lParam: lParam
	"Private - Pass a message to the 'default' window procedure of the receiver."

	^User32
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

filerProxyIn: anSTxOutFiler
	"Private - Answer a filer proxy that represents the receiver for use with the <STxOutFiler> argument."

	| proxy |
	proxy := super filerProxyIn: anSTxOutFiler.
	proxy instVars at: ##(self indexOfInstVar: 'oldWndProc') put: nil.
	^proxy!

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

getFont
	"Private - Get the control's current font."

	| hFont |
	hFont := self sendMessage: WM_GETFONT.
	^hFont == 0 ifTrue: [Font system] ifFalse: [Font fromHandle: hFont]!

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
	"Default handler for an uninteresting notification message."

	^0!

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
	In some cases subclasses may answer 0 to prevent the control from processing the key press."

	^nil!

nmKillFocus: pNMHDR
	"Default handler for a NM_KILLFOCUS notification message.
	Answer nil to accept default processing."

	^nil
!

nmNotify: pNMHDR
	"Private - Handler for a redirected generic WM_NOTIFY message."

	^(self commonNotificationMap lookup: (pNMHDR int32AtOffset: NMHDR._OffsetOf_code))
		ifNotNil: [:action | self perform: action with: pNMHDR]!

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

sendMessageNz: anIntegerMessageID wParam: wParam lpParam: lParam
	| rc |
	rc := User32
				sendMessage: handle
				msg: anIntegerMessageID
				wParam: wParam
				lpParam: lParam.
	rc == 0 ifTrue: [self errorInCommonControlCall].
	^rc!

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
	
	self sendMessage: WM_SETFONT wParam: aFont asParameter lParam: 0!

subclassWindow: hWnd
	"Private - Subclass the receiver's associated Win32 window by substituting the VM's 
	window procedure and saving the control's one, and record hWnd as the handle 
	of the receiver's window."

	super subclassWindow: hWnd.
	self subclassWindow!

ttnGetDispInfo: anNMTTDISPINFOW
	"Private - Handler for the TTN_GETDISPINFOW notification message."

	^anNMTTDISPINFOW idIsHandle
		ifTrue: 
			[(View withHandle: anNMTTDISPINFOW idFrom)
				ifNotNil: [:view | view presenter onTipDetailsRequired: anNMTTDISPINFOW]]
		ifFalse: 
			[(self itemFromId: anNMTTDISPINFOW idFrom)
				ifNotNil: 
					[:tool |
					anNMTTDISPINFOW text: (self presenter onTipTextRequired: tool).
					0]]!

ttnGetDispInfoW: pNMHDR
	"Private - Default handler for the TTN_GETDISPINFOW notification message."

	^self ttnGetDispInfo: (NMTTDISPINFOW fromAddress: pNMHDR)!

unsubclassWindow
	self setWndProc: oldWndProc!

wantParentNotifications
	"Answer whether the receiver's parent will be sent notifications from the receiver
	according to aBoolean.
	N.B. Dolphin reflects these notifications back to the receiver."

	^self extendedStyle noMask: WS_EX_NOPARENTNOTIFY!

wantParentNotifications: aBoolean
	"Set the whether the receiver's parent will be sent notifications from the receiver
	according to aBoolean.
	N.B. Dolphin reflects these notifications back to the receiver."

	self exStyleMask: WS_EX_NOPARENTNOTIFY set: aBoolean not recreateIfChanged: false!

winFinalize
	self unsubclassWindow.
	^super winFinalize!

withOldWndProc: operation
	"Private - Evaluate the niladic valuable, operation, with the old (unsubclassed) window
	procedure. This avoids us having to process (and slow down!!) messages in which we are not
	interested."

	self unsubclassWindow.
	^operation ensure: [self subclassWindow]!

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
!UI.ControlView categoriesForMethods!
applyFont!font!private!updating! !
backcolorChanged!helpers!private! !
ccmGetVersion!operations!public! !
ccmSetVersion:!operations!public! !
clearHandle!private!realizing/unrealizing! !
commonNotificationMap!constants!private! !
defaultWindowProcessing:wParam:lParam:!dispatching!private! !
defaultWindowStyle!constants!private! !
errorInCommonControlCall!exceptions!public! !
errorOutOfMemory!exceptions!public! !
filerProxyIn:!binary filing!private! !
forecolor!accessing!public! !
forecolor:!accessing!public! !
getFont!accessing!font!private! !
itemFromId:!accessing!private! !
nmClick:!event handling-win32!private! !
nmCustomDraw:!event handling-win32!private! !
nmDblClk:!event handling-win32!private! !
nmDummy:!event handling-win32!private! !
nmEndWait:!event handling-win32!private! !
nmHover:!event handling-win32!private! !
nmKeyDown:!event handling-win32!private! !
nmKillFocus:!event handling-win32!private! !
nmNotify:!event handling-win32!private! !
nmOutOfMemory:!event handling-win32!private! !
nmRClick:!event handling-win32!private! !
nmRDblClk:!event handling-win32!private! !
nmReturn:!event handling-win32!private! !
nmSetFocus:!event handling-win32!private! !
nmStartWait:!event handling-win32!private! !
oldWndProc!accessing!private! !
oldWndProc:!accessing!private! !
onColorRequired:!event handling!private! !
onEraseRequired:!event handling!public! !
onInputMaskRequired:!event handling!public! !
onViewCreated!event handling!public! !
paintTransparentBackgroundOn:!private!updating! !
sendMessageNz:wParam:lpParam:!operations!private! !
setControlBackcolor!helpers!private! !
setControlBackcolor:!helpers!private! !
setFont:!accessing!font!private! !
subclassWindow:!operations!private! !
ttnGetDispInfo:!event handling-win32!private! !
ttnGetDispInfoW:!event handling-win32!private! !
unsubclassWindow!operations!private! !
wantParentNotifications!accessing-styles!public! !
wantParentNotifications:!accessing-styles!public! !
winFinalize!finalizing!private! !
withOldWndProc:!dispatching!private! !
wmPaint:wParam:lParam:!event handling-win32!private! !
wmPrintClient:wParam:lParam:!event handling-win32!private! !
wmSysColorChange:wParam:lParam:!event handling-win32!private! !
wmWindowPosChanged:wParam:lParam:!event handling-win32!private! !
!

!UI.ControlView class methodsFor!

commonControlCallError
	"Answer the exceptionSignaler/exceptionSelector used to signal/catch common
	control message errors."

	^CommonControlCallError!

controlColorMessages
	^{WM_CTLCOLORMSGBOX. WM_CTLCOLORBTN. WM_CTLCOLORDLG. WM_CTLCOLORSTATIC}!

initialize
	"Private - Initialise the map of generic notification codes to selectors. We could use an
	array, but a dictionary is more convenient and loses very little in performance.

		ControlView initialize
	"

	CommCtrlLibrary addInitFlag: ICC_STANDARD_CLASSES.
	CommonControlCallError := Signal description: 'Common control call failed'.
	View registerMessageMappings: self messageMappings!

maxTextLimit
	"Answer the absolute maximum amount of text that the receiver can ever hold."

	^16r7FFFFFFE!

messageMappings
	^(self controlColorMessages collect: [:each | each -> #wmCtlColor:wParam:lParam:])
		, {WM_DRAWITEM -> #wmDrawItem:wParam:lParam:. WM_MEASUREITEM -> #wmMeasureItem:wParam:lParam:}!

onStartup
	"Perform post startup processing to initialize the View system"

	"Load the Common Control Library."

	CommCtrlLibrary openDefault!

uninitialize
	| deadMessages |
	CommCtrlLibrary removeInitFlag: ICC_STANDARD_CLASSES.
	deadMessages := self controlColorMessages.
	#{Menu} isDefined ifFalse: [deadMessages := deadMessages , {WM_DRAWITEM. WM_MEASUREITEM}].
	View unregisterMessageMappings: deadMessages!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^self subclassResponsibility! !
!UI.ControlView class categoriesForMethods!
commonControlCallError!constants!public! !
controlColorMessages!constants!private! !
initialize!development!initializing!private! !
maxTextLimit!constants!public! !
messageMappings!initializing!must not strip!private! !
onStartup!event handling!public! !
uninitialize!class hierarchy-removing!private! !
winClassName!constants!private! !
!

