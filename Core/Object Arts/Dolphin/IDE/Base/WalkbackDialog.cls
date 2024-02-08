"Filed out from Dolphin Smalltalk"!

DialogView subclass: #WalkbackDialog
	instanceVariableNames: 'callStack resumable caption debuggable'
	classVariableNames: 'CallStackId Commands IconId'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WalkbackDialog guid: (GUID fromString: '{87b4c723-026e-11d3-9fd7-00a0cc3e4a32}')!

WalkbackDialog addClassConstant: 'CallStackId' value: 16r3E9!
WalkbackDialog addClassConstant: 'IconId' value: 16r3F1!

WalkbackDialog comment: '
Instance Variables:
	callStack		<readableString> containing the walkback trace.
	resumable		<boolean> indicating if the process is resumable.
	caption		<readableString> holding the walkback caption.

Class Variables:
	CallStackId	<integer> ID of the call stack text window.
	DebugId		<integer> ID of the "debug" button.
	IconId		<integer> ID of the warning icon.
	ResumeId		<integer> ID of the "resume" button.
	TerminateId	<integer> ID of the "terminate" button.
	KillId		<integer> ID of the "kill" button.

'!

!WalkbackDialog categoriesForClass!MVP-Views! !

!WalkbackDialog methodsFor!

actualBackcolor
	"Private - Answer the <Color> to be applied as the receiver's background colour. If the
	local backcolor is nil then the backcolor is inherited from the parent chain. If the
	parent's actual background colour is nil, then the default background colour is used."

	^Color face3d!

callStack: aString
	"Set the call stack to be displayed by the receiver."

	callStack := aString!

caption: aString
	"Set the caption of the receiver to aString"

	caption := aString!

copyWalkbackToClipboard
	"Copy the walkback details to the clipboard, which is useful for submitting a bug report (etc),
	although a VM 'crash' dump is typically better."

	(String writeStream 
		display: DateAndTime now; 
		nextPutAll: ': '; 
		print: caption; cr; 
		nextPutAll: callStack; 
		contents) copyToClipboard!

debuggable: aBoolean
	"Set whether the Debug key should be enabled or disabled."

	debuggable := aBoolean!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter #preferredExtent is used when the desired size of a view is requested."
	
	"As the receiver is created from a dialog template, this is actually ignored and the dialog will be scaled by Windows from the template definition."

	^252@126!

onInitDialog
	"Private - The walkback is opening and all controls have been created.
	Initialize as necessary."

	[
		self class releaseCapture.
	 	resumable 
			ifTrue: [ 
				self setItem: IconId icon: Icon warning.
				Sound warningBeep]
			ifFalse: [
				self setItem: IconId icon: Icon error.
				Sound errorBeep].
		self text: caption.
		self setItem: CallStackId text: callStack.
		self 
			enableItem: (Commands keyAtValue: #resume) state: resumable;
			enableItem: IDOK state: debuggable.
		
		"Set default answer used if window closed rather than button pressed"
		self answer: #terminate.
	] on: Error do: [:e | e resignalAsWarning].
	^true	"direct Windows to set the focus"!

primHookWindowCreate: hookBoolean
	"Private - Hook the first window creation event for the receiver.
	We override this to force the hooking if another window is currently
	hogging it. This prevents recursive walkbacks in some situations."

	"Primitive failure reasons:
		InvalidParameter1	- hookBoolean not a boolean
		IllegalStateChange	- already hooked by another view
		NotSupported		- The VM is for console apps only"

	<primitive: 108>
	^_failureCode == _PrimitiveFailureCode.IllegalStateChange
		ifTrue: 
			["First forcibly unhook so error walkback can be displayed"
			self primHookWindowCreate: nil.
			Notification signal: 'Forcibly unhooked failed window creation'.
			"Now retry"
			super primHookWindowCreate: hookBoolean]
		ifFalse: [self primitiveFailed: _failureCode]!

resumable: aBoolean
	"Set whether the resume key should be enabled or disabled."

	resumable := aBoolean!

runModalLoop
	"Private - create a modal message loop. We override this here due to a strange effect under
	Windows 95 where one walkback immediately following another will not be shown successfully.
	At least, it IS shown temporarily, but vanishes when the previous dialog is destroyed."

	[self show] postToMessageQueue.
	super runModalLoop!

templateId
	"Private - Answer the dialog template for the receiver."

	^136!

unhookWindowCreate: hWnd
	"Private - Undo #hookWindowCreate. Override to ignore
	failure to open the walkback. The likelihood is that any
	subsequent attempt to open a walkback would fail, and hence
	a recursive error would result, therefore it is best to fall back
	on using a message box for the walkback."

	self primHookWindowCreate: false.
	hWnd isNull
		ifTrue: [Notification signal: 'Failed to open walkback dialog']
!

wmCommand: message wParam: wParam lParam: lParam
	"Our command handling requirements are very simple, so to avoid having to create Smalltalk
	button objects to represent the buttons on the template, we simply implement a rudimentary
	wmCommand: handler. We set the answer to the command name so that the caller can decide what
	to do with the process."

	| copyid |
	self answer: (Commands lookup: wParam).
	copyid := Commands keyAtValue: #copy.
	wParam > copyid ifTrue: [^false].
	wParam == copyid
		ifTrue: 
			[self copyWalkbackToClipboard.
			^false].
	^self destroy!

wmSize: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_SIZE (window resized) message."

	#todo "Resize the controls".
	^nil
! !

!WalkbackDialog categoriesForMethods!
actualBackcolor!accessing!private! !
callStack:!accessing!public! !
caption:!accessing!public! !
copyWalkbackToClipboard!commands!public! !
debuggable:!accessing!public! !
defaultExtent!constants!private! !
onInitDialog!event handling!private! !
primHookWindowCreate:!helpers!private! !
resumable:!accessing!public! !
runModalLoop!operations!private! !
templateId!constants!private! !
unhookWindowCreate:!operations!private! !
wmCommand:wParam:lParam:!event handling-win32!public! !
wmSize:wParam:lParam:!event handling-win32!private! !
!

!WalkbackDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self addClassConstant: 'Commands'
		value: (LookupTable new
				at: IDCANCEL put: #terminate;
				at: IDOK put: #debug;
				at: 3 put: #resume;
				at: 4 put: #copy;
				shrink;
				isImmutable: true;
				yourself).
	self addClassConstant: 'CallStackId' value: 1001.
	self addClassConstant: 'IconId' value: 1009! !

!WalkbackDialog class categoriesForMethods!
initialize!initializing!private! !
!

