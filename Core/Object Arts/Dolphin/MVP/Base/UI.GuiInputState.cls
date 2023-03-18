"Filed out from Dolphin Smalltalk"!

Kernel.InputState
	subclass: #'UI.GuiInputState'
	instanceVariableNames: ''
	classVariableNames: 'EnumHandlesDescriptor'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.GuiInputState guid: (Core.GUID fromString: '{63335fe2-2ac2-43b5-9747-3c264e8b7fdf}')!
UI.GuiInputState comment: ''!
!UI.GuiInputState categoriesForClass!Kernel-Support! !
!UI.GuiInputState methodsFor!

aboutToForkUI
	"Private - A new main UI process is being started. Reset any global UI state."

	Cursor reset!

allTopLevelWindowHandlesDo: aMonadicValuable
	| callback answer |
	callback := External.Callback block: [:hwnd :lParam | aMonadicValuable value: hwnd. true]
				descriptor: EnumHandlesDescriptor.
	answer := User32 enumWindows: callback asParameter lParam: 0.
	callback free.
	^answer!

getLastInputInfo
	| lastInputInfo |
	lastInputInfo := LASTINPUTINFO new.
	^(User32 getLastInputInfo: lastInputInfo)
		ifTrue: [lastInputInfo dwTime]
		ifFalse: [User32 systemError]!

guiStartup
	"Private - System startup has entered the second stage, and it is time to reinitialize the
	user interaction subsystem for a GUI session."

	| oldWindows |
	oldWindows := windows.
	lastWindow := nil.
	windows := LookupTable new.
	oldWindows ifNotNil: [oldWindows do: [:w | w onStartup]].
	self createPostedActionWindow!

isDolphinWindow: hWnd
	"Answer whether the window with handle, hWnd, is a Dolphin window or not."

	^(self lookupWindow: hWnd) notNil!

topLevelWindowHandlesDo: aMonadicValuable
	| callback answer |
	callback := External.Callback block: [:hwnd :lParam | aMonadicValuable value: hwnd]
				descriptor: EnumHandlesDescriptor.
	answer := User32
				enumThreadWindows: Kernel32 getCurrentThreadId
				lpfn: callback asParameter
				lParam: 0.
	callback free.
	^answer!

topLevelWindows
	"Answer an unordered <Collection> containing all top level windows belonging to the Dolphin
	process. Note that this will include windows which are not frame windows (e.g. tool tips),
	and in a random order."

	| shells bEnabled desktop |
	shells := Array writeStream: 20.
	desktop := View desktop.
	bEnabled := Processor enableAsyncEvents: false.
	windows do: 
			[:each |
			"This selection filter has been re-written for bug fix #2261. Previously
			WS_CHILD views that were children of the desktop were not being included in
			the answered collection. This resulted in the View Composer not having any
			non-shell views it was editing being saved and restored across an image
			restart."
			(each isView and: [each parentView == desktop]) ifTrue: [shells nextPut: each]].
	Processor enableAsyncEvents: bEnabled.
	^shells contents!

topLevelWindowsInZOrder
	"Answer a <sequencedReadableCollection> containing all top level windows belonging to the
	Dolphin process in the correct z-order (i.e. the topmost window is first). Note that this
	will include windows which are not frame windows (e.g. tool tips), and furthermore it is not
	lightening fast. In fact it is more than an order of magnitude slower than #topLevelWindows,
	which answers the same collection of windows in a random order."

	| views |
	views := OrderedCollection new: 20.
	self topLevelWindowHandlesDo: 
			[:hwnd |
			(self lookupWindow: hwnd) ifNotNil: [:view | views addLast: view].
			true].
	^views!

uiIdle
	"Private - Inform the receiver's registered windows that the UI is going idle so that they
	can update visual elements accordingly - e.g. enable/disable toolbar buttons. The windows
	can do other processing from their idle notification handlers, but it should be of very
	short duration, or the responsiveness of the UI will be adversely affected."

	self topLevelWindows do: 
			[:each | 
			self isInputAvailable 
				ifTrue: 
					[self inputSemaphore set.
					^false	"stop enumerating"]
				ifFalse: [self uiIdle: each]].
	^true!

uiIdle: aShellWindow
	"Private - If the argument is one of the receiver's currently visible windows, then request
	it to update its UI."

	(User32 isWindowVisible: aShellWindow asParameter) ifTrue: [aShellWindow enterIdle]!

userSessionIdleMs
	"Answer the <integer> number of milliseconds that the user session has been idle.
		(Delay forSeconds: 1) wait. SessionManager inputState userSessionIdleMs.
	"

	| currentTime lastInputTime |
	currentTime := Kernel32 getTickCount.
	lastInputTime := self getLastInputInfo.
	currentTime < lastInputTime ifTrue: [^currentTime].	"In case of 49.7-day wrap, we understate the idle time"
	^currentTime - lastInputTime!

visibleWindows
	"Private - Answer a collection of the visible windows belonging to the current session."

	"Implementation Note: We use the bare metal UserLibrary functions to avoid any dependency on
	the existing View classes. This might be important to those wanting to implement their own
	window class hieararchy."

	| hDesktop |
	hDesktop := User32 getDesktopWindow.
	^windows select: 
			[:each |
			| hWnd |
			hWnd := each asParameter.
			hWnd notNil
				and: [hWnd ~= hDesktop and: [(User32 isWindow: hWnd) and: [User32 isWindowVisible: hWnd]]]]!

windowCreated: hWnd param: anInteger
	"Private - A window with the handle, hWnd, and creation parameter, anInteger, has been created in the Dolphin process."

	"WARNING: This method is an entry point from the VM, and must not be invoked from Smalltalk code, as it returns directly to the VM as if from a callback. Do not modify or remove this method."

	"Implementation Note: The VM sends this message with asynchronous process switching disabled."

	| thread |
	thread := Processor activeProcess.
	thread newWindow
		ifNotNil: 
			[:window |
			thread newWindow: nil.
			window subclassWindow: hWnd].
	^0! !
!UI.GuiInputState categoriesForMethods!
aboutToForkUI!idling!private! !
allTopLevelWindowHandlesDo:!enumerating!private! !
getLastInputInfo!helpers!private! !
guiStartup!operations-startup!private! !
isDolphinWindow:!private!testing! !
topLevelWindowHandlesDo:!enumerating!private! !
topLevelWindows!enumerating!public! !
topLevelWindowsInZOrder!enumerating!public! !
uiIdle!idling!private! !
uiIdle:!idling!private! !
userSessionIdleMs!idling!public! !
visibleWindows!private!testing! !
windowCreated:param:!private!vm entry points! !
!

!UI.GuiInputState class methodsFor!

initialize
	EnumHandlesDescriptor := External.FunctionDescriptor returnType: 'bool'
				argumentTypes: 'handle uintptr'! !
!UI.GuiInputState class categoriesForMethods!
initialize!development!initializing!public! !
!

