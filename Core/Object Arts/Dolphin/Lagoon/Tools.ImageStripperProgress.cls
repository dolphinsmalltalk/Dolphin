"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ImageStripperProgress
	instanceVariableNames: 'handle oldWndProc progressProcess progressRange progress status cursor'
	classVariableNames: 'MessageMap'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {
		'CaptionId' -> 16r3F9.
		'ExplanationId' -> 16r3FA.
		'ProgressId' -> 16r3F7.
		'StatusId' -> 16r3F8
	}!
ImageStripperProgress guid: (GUID fromString: '{3645214b-fff1-40c6-91d4-32740d2f6a66}')!
ImageStripperProgress comment: 'ImageStripperProgress is a <topPresenter> used by the <ImageStripper> to display the progress of an image stripping operation.

Instance Variables:
	status			<TextEdit> describing the current stripping operation
	progress			<ProgressBar> indicating the current amount of stripping
	progressProcess		<Process> monitoring the progress
	progressRange		<Interval> which is the range of the progress monitor
	monitorProgressPeriod	<Integer> number of milliseconds between progress monitoring periods

'!
!ImageStripperProgress categoriesForClass!Unclassified! !
!ImageStripperProgress methodsFor!

addToCommandRoute: route
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer the next <Presenter> to visit.
	The receiver is guaranteed not to be on the command path already."

	^nil!

asParameter
	"Answer the receiver in a form suitable for passing to an external
	function call (in this case the receiver's window handle).
	N.B. It is important to implement this, even if we don't use it here, since
	it is needed to pop up a walkback dialog modal to this window should
	some error occur."

	^handle
!

beActive
	"Make the receiver the active window."

	^UserLibrary default setActiveWindow: self asParameter!

currentProgress
	"Private - Answer the number of objects remaining in the image to be used as a measure of
	stripping progress."

	^MemoryManager current objectCount
!

defaultWindowProcessing: message wParam: wParam lParam: lParam
	"Private - Pass a Windows message to the 'default' window procedure of the receiver.
	As the receiver is a dialog we must call the DefDlgProc() instead, this will call
	our own DialogProc() (dialog procs are not WndProcs), which just returns false
	to get the DefDlgProc() to do its stuff."

	^UserLibrary default 
		defDlgProc: handle
			msg: message 
			wParam: wParam 
			lParam: lParam!

defaultWindowStyle
	"Private - Answer the default basic window creation style"

	^##(WS_DLGFRAME | WS_CAPTION)
!

destroy
	"Force the receiver closed. N.B. The receiver will receive WM_DESTROY
	and WM_NCDESTROY messages, but not a WM_CLOSE (Default window processing
	for WM_CLOSE is to call DestroyWindow)."

	self stopProcess.
	^UserLibrary default destroyWindow: handle!

detail: aString
	"Report aString as the current status detail (we ignore here to avoid slowing things
	down too much)."
!

dispatchMessage: message wParam: wParam lParam: lParam
	"Private - Dispatch a Windows message or pass on for default processing."

	| selector answer |
	answer := (selector := MessageMap lookup: message) notNil
				ifTrue: 
					[self
						perform: selector
						with: message
						with: wParam
						with: lParam].

	"We MUST answer an integer value. If one was not provided, then assume default
	window processing is required."
	^answer isInteger
		ifTrue: [answer]
		ifFalse: 
			[self
				defaultWindowProcessing: message
				wParam: wParam
				lParam: lParam]!

enterIdle
	^true!

fontChanged
	"Private - The desktop font has been changed (ignore it)."
!

forecolorChanged
	"Private - The desktop foreground color has been changed (ignore it)."
!

forkProgressMonitor
	"Private - Start a background process to monitor the progress"

	| pollingInterval |
	self progress: self currentProgress.
	pollingInterval := self monitorProgressPeriod.
	progressProcess := 
			[
			[Processor sleep: pollingInterval.
			self progress: self currentProgress] repeat]
					forkAt: Processor userInterruptPriority!

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

isEnabled
	"Private - Answer whether the receiver is enabled for input"

	^UserLibrary default isWindowEnabled: self asParameter
!

isEnabled: aBoolean
	"Set or reset whether the receiver is enabled for user input.
	Sent to views when a modal dialog is opened on top of them."

	UserLibrary default enableWindow: self asParameter bEnable: aBoolean
!

isPersistentView
	"Answer whether the receiver has persistent state which can and should
	be persistent in the image (i.e. top-level windows which answer true
	to this will be sent #state and #state: messages by the 
	SessionManager before the image is saved, and on session startup, respectively)."

	^false!

isView
	"Answer whether the receiver is considered a real View"

	^false!

isWindowVisible
	"Answer whether both the receiver and its parent have the WS_VISIBLE style,  it is therefore possible
	that this method will answer true even if the receiver is totally obscured by other windows."

	^UserLibrary default isWindowVisible: handle
!

monitorProgressPeriod
	"Private - Answer the number of milliseconds to wait between progress monitoring updates"

	^1000
!

onStartup
	"Ensure that the handle of the receiver is set to nil at startup."

	handle := nil!

parentPresenter
	"Answer the presenter that can be considered the parent of the receiver.
	Part of the Presenter protocol used when the receiver is in fact its own presenter"

	^nil!

presenter
	"Answers the presenter for the receiver"

	^self!

preTranslateMessage: aMSG
	"Answer whether the receiver would like to consume the argument aMSG."

	^false!

primHookWindowCreate: hookBoolean
	"Private - Ask the VM to hook the first subsequent window creation event for the receiver.
	When it receives such an event it will send a #subclassWindow: callback with the
	handle of the newly created window to the receiver. This allows controls to be
	subclassed BEFORE they return from the CreateWindowEx() call.
	The VM uses a CBT hook to achieve this. The hook is implemented in the VM to
	minimise the performance impact. The hook is automatically 'unhooked' by the VM
	when it receive's the create notification before it sends the #subclassWindow:
	callback."

	<primitive: 108>
	^self primitiveFailed: _failureCode!

progress: anInteger 
	"Private - Report anInteger as the current level of progress"

	| i |
	i := (self progressRange last - anInteger) * 100 // self progressRange size.
	UserLibrary default 
		sendMessage: progress
		msg: 1026
		wParam: i asInteger
		lParam: 0.	"PBM_SETPOS"
	SessionManager inputState pumpMessages!

progressRange
	"Private - Answer the range for the progress monitoring. We use a count of the number of
	objects in the image to mark the progress of the strip"

	"The best we can get is the number of objects left in the image after stripping a minimal
	console application. This figure was taken from the Hello World (Console) strip log"

	progressRange isNil ifTrue: [
		progressRange := 7742 to: self currentProgress ].
	^progressRange!

resourceLib
	"Answer the library/handle of the module containing the receiver's template."

	^SessionManager current defaultResourceLibrary!

setItem: anInteger font: aFontOrHandle
	"Private - Set the font of the receiver's control with the specified id."

	UserLibrary default
		sendMessage: (self getItemHandle: anInteger ifAbsent: [])
		msg: WM_SETFONT
		wParam: aFontOrHandle asParameter
		lParam: 0!

setItem: anInteger text: aString
	"Private - Set the text of the receiver's control with the specified id."

	(UserLibrary default setDlgItemText: handle nIDDlgItem: anInteger lpString: aString)
		ifFalse: [UserLibrary default systemError]!

show
	| hWnd |
	self primHookWindowCreate: true.
	"Note: If the CreateDialogIndirect() API call GPFs it is almost certainly because 
	an attempt is being made to load a dialog template from a resource library that
	has been opened with the LOAD_LIBRARY_AS_DATAFILE flag. Dialog templates
	can only be loaded from DLLs that have been loaded as normal code modules."
	hWnd := UserLibrary default 
				createDialog: self resourceLib asParameter
				lpTemplate: self template asResourceId
				hWndParent: nil
				lpDialogFunc: VMLibrary default getDlgProc
				dwInitParam: 0.
	self primHookWindowCreate: false.
	hWnd isNull ifTrue: [self error: 'Failed to create window'].
	UserLibrary default showWindow: handle nCmdShow: SW_SHOWNORMAL!

status: aString
	"Report aString as the current status"

	UserLibrary default setWindowText: status lpString: aString.
	SessionManager inputState pumpMessages!

stopProcess
	"Private - Stop the progress monitor process"

	progressProcess notNil 
		ifTrue: 
			[progressProcess terminate.
			progressProcess := nil]!

subclassWindow: anIntegerOrHandle
	"Private - Subclass the receiver's associated Win32 window by substituting the VM's 
	window procedure for the default dialog proc. Note that this is sent by the VM."

	handle := anIntegerOrHandle asExternalHandle.
	SessionManager inputState windowAt: anIntegerOrHandle put: self.
	oldWndProc := VMConstants.IsWin64
				ifTrue: 
					[UserLibrary default
						setWindowULongPtr: handle
						nIndex: GWL_WNDPROC
						dwNewLong: VMLibrary default getWndProc]
				ifFalse: 
					[UserLibrary default
						setWindowULong: handle
						nIndex: GWL_WNDPROC
						dwNewLong: VMLibrary default getWndProc]!

template
	^140!

update
	"Repaint the receiver as necessary, immediately.
	N.B. This causes a callback as Windows sends a WM_PAINT directly."

	UserLibrary default updateWindow: self asParameter!

validateUserInterface
	"Validates the user interface for the receiver. Usually performed at idle time
	when the UI has been flagged as being invalid"
!

wmClose: message wParam: wParam lParam: lParam
	"Private - This window has been asked to close, answer whether or not it accepts the request."

	"Prevent the window being closed with ALT+F4"
	^0!

wmCreate: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_CREATE."

"	self updateIcons."
	^nil!

wmCtlColor: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_CTLCOLORXXX message."

	^(UserLibrary default getSysColorBrush: COLOR_WINDOW) asInteger!

wmInitDialog: message wParam: wParam lParam: lParam 
	"Private - A WM_INITDIALOG message was sent by the dialog proc. Answer false if the focus has been set,
	or true if leaving that to Windows."

	| bkcolor |
	cursor := UserLibrary default loadCursor: 0 lpCursorName: IDC_WAIT.
	self setItem: CaptionId text: 'Application Deployment in Progress'.
	self setItem: ExplanationId
		text: 'The deployment process may take up to a minute depending on the deployment options. 

This progress dialog will disappear some seconds before deployment is complete. A message box will appear informing you when the procedure is finished and, once confirmed, the development image will exit.'.
	progress := self getItemHandle: ProgressId ifAbsent: [].
	bkcolor := UserLibrary default getSysColor: COLOR_WINDOW.
	UserLibrary default 
		sendMessage: progress
		msg: 8193
		wParam: 0
		lParam: bkcolor.	"CCM_SETBKCOLOR"
	status := self getItemHandle: StatusId ifAbsent: [].
	self forkProgressMonitor.
	^true!

wmNcDestroy: message wParam: wParam lParam: lParam
	"Private - Notification that a window is about to disappear so we
 	remove it from our management."

	| answer |

	self stopProcess.
	progressRange := nil.

	SessionManager inputState removeWindowAt: handle.

	answer := self defaultWindowProcessing: message wParam: wParam lParam: lParam.
	handle := nil.
	^answer!

wmSetCursor: message wParam: wParam lParam: lParam
	"Private - Handle the Win32 WM_SETCURSOR message."

	"Set the wait cursor"
	UserLibrary default setCursor: cursor. 
	^0.! !
!ImageStripperProgress categoriesFor: #addToCommandRoute:!commands!public! !
!ImageStripperProgress categoriesFor: #asParameter!converting!public! !
!ImageStripperProgress categoriesFor: #beActive!operations!public! !
!ImageStripperProgress categoriesFor: #currentProgress!operations!private! !
!ImageStripperProgress categoriesFor: #defaultWindowProcessing:wParam:lParam:!dispatching!private! !
!ImageStripperProgress categoriesFor: #defaultWindowStyle!constants!private! !
!ImageStripperProgress categoriesFor: #destroy!public!realizing/unrealizing! !
!ImageStripperProgress categoriesFor: #detail:!accessing!public! !
!ImageStripperProgress categoriesFor: #dispatchMessage:wParam:lParam:!dispatching!private! !
!ImageStripperProgress categoriesFor: #enterIdle!event handling-win32!private! !
!ImageStripperProgress categoriesFor: #fontChanged!private!updating! !
!ImageStripperProgress categoriesFor: #forecolorChanged!private!updating! !
!ImageStripperProgress categoriesFor: #forkProgressMonitor!operations!private! !
!ImageStripperProgress categoriesFor: #getItemHandle:ifAbsent:!hierarchy!private! !
!ImageStripperProgress categoriesFor: #isEnabled!private!testing! !
!ImageStripperProgress categoriesFor: #isEnabled:!accessing!public! !
!ImageStripperProgress categoriesFor: #isPersistentView!public!testing! !
!ImageStripperProgress categoriesFor: #isView!public!testing! !
!ImageStripperProgress categoriesFor: #isWindowVisible!public!testing! !
!ImageStripperProgress categoriesFor: #monitorProgressPeriod!constants!private! !
!ImageStripperProgress categoriesFor: #onStartup!event handling!public! !
!ImageStripperProgress categoriesFor: #parentPresenter!presenter!public! !
!ImageStripperProgress categoriesFor: #presenter!accessing!public! !
!ImageStripperProgress categoriesFor: #preTranslateMessage:!dispatching!public! !
!ImageStripperProgress categoriesFor: #primHookWindowCreate:!helpers!private! !
!ImageStripperProgress categoriesFor: #progress:!accessing!must not strip!private! !
!ImageStripperProgress categoriesFor: #progressRange!operations!private! !
!ImageStripperProgress categoriesFor: #resourceLib!constants!public! !
!ImageStripperProgress categoriesFor: #setItem:font:!accessing!private! !
!ImageStripperProgress categoriesFor: #setItem:text:!accessing!private! !
!ImageStripperProgress categoriesFor: #show!operations!public! !
!ImageStripperProgress categoriesFor: #status:!accessing!public! !
!ImageStripperProgress categoriesFor: #stopProcess!helpers!private! !
!ImageStripperProgress categoriesFor: #subclassWindow:!operations!private! !
!ImageStripperProgress categoriesFor: #template!constants!public! !
!ImageStripperProgress categoriesFor: #update!drawing!public! !
!ImageStripperProgress categoriesFor: #validateUserInterface!operations!public! !
!ImageStripperProgress categoriesFor: #wmClose:wParam:lParam:!event handling-win32!private! !
!ImageStripperProgress categoriesFor: #wmCreate:wParam:lParam:!event handling-win32!private! !
!ImageStripperProgress categoriesFor: #wmCtlColor:wParam:lParam:!event handling-win32!private! !
!ImageStripperProgress categoriesFor: #wmInitDialog:wParam:lParam:!event handling-win32!private! !
!ImageStripperProgress categoriesFor: #wmNcDestroy:wParam:lParam:!event handling-win32!private! !
!ImageStripperProgress categoriesFor: #wmSetCursor:wParam:lParam:!event handling-win32!private! !

ImageStripperProgress methodProtocol: #window attributes: #(#readOnly) selectors: #(#asParameter #destroy #dispatchMessage:wParam:lParam: #enterIdle #isPersistentView #isWindowVisible #onStartup #preTranslateMessage: #subclassWindow:)!

!ImageStripperProgress class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	MessageMap := LookupTable new.
	MessageMap
		at: WM_CREATE put: #wmCreate:wParam:lParam:;
		at: WM_CLOSE put: #wmClose:wParam:lParam:;
		at: WM_NCDESTROY put: #wmNcDestroy:wParam:lParam:;
		at: WM_INITDIALOG put: #wmInitDialog:wParam:lParam:;
		at: WM_SETCURSOR put: #wmSetCursor:wParam:lParam:;
		at: WM_CTLCOLORMSGBOX put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLOREDIT put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLORLISTBOX put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLORBTN put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLORDLG put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLORSCROLLBAR put: #wmCtlColor:wParam:lParam:;
		at: WM_CTLCOLORSTATIC put: #wmCtlColor:wParam:lParam:!

onPreStripImage
	self
		removeSelectors: #(#forkProgressMonitor #primHookWindowCreate: #show #subclassWindow: #template #wmInitDialog:wParam:lParam: #wmCreate:wParam:lParam:).
	self class removeSelectors: self selectors!

show
	^self new show! !
!ImageStripperProgress class categoriesFor: #initialize!initializing!must not strip!public! !
!ImageStripperProgress class categoriesFor: #onPreStripImage!private! !
!ImageStripperProgress class categoriesFor: #show!operations!public! !

