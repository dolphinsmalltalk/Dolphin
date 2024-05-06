"Filed out from Dolphin Smalltalk"!

InputState subclass: #GuiInputState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GuiInputState guid: (GUID fromString: '{63335fe2-2ac2-43b5-9747-3c264e8b7fdf}')!

GuiInputState comment: ''!

!GuiInputState categoriesForClass!Kernel-Support! !

!GuiInputState methodsFor!

aboutToForkUI
	"Private - A new main UI process is being started. Reset any global UI state."

	Cursor reset!

allTopLevelWindowHandlesDo: aMonadicValuable
	| callback answer |
	callback := ExternalCallback block: [:hwnd :lParam | aMonadicValuable value: hwnd]
				descriptor: ##(ExternalDescriptor returnType: 'bool' argumentTypes: 'handle uintptr').
	answer := UserLibrary default enumWindows: callback asParameter lParam: 0.
	callback free.
	^answer!

getLastInputInfo
	| lastInputInfo |
	lastInputInfo := LASTINPUTINFO new.
	^(UserLibrary default getLastInputInfo: lastInputInfo)
		ifTrue: [lastInputInfo dwTime]
		ifFalse: [UserLibrary default systemError]!

guiStartup
	"Private - System startup has entered the second stage, and it is time to reinitialize the
	user interaction subsystem for a GUI session."

	| oldWindows |
	oldWindows := windows.
	lastWindow := nil.
	windows := LookupTable new.
	oldWindows notNil ifTrue: [oldWindows do: [:w | w onStartup]].
	self createPostedActionWindow!

isDolphinWindow: hWnd 
	"Answer whether the window with handle, hWnd, is a Dolphin window or not."

	^(self windowAt: hWnd ifAbsent: []) notNil!

topLevelWindowHandlesDo: aMonadicValuable
	| callback answer |
	callback := ExternalCallback block: [:hwnd :lParam | aMonadicValuable value: hwnd]
				descriptor: ##(ExternalDescriptor returnType: 'bool' argumentTypes: 'handle uintptr').
	answer := UserLibrary default
				enumThreadWindows: KernelLibrary default getCurrentThreadId
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
			(self windowAt: hwnd ifAbsent: []) ifNotNil: [:view | views addLast: view].
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

	(UserLibrary default isWindowVisible: aShellWindow asParameter) ifTrue: [aShellWindow enterIdle]!

userSessionIdleMs
	"Answer the <integer> number of milliseconds that the user session has been idle.
		(Delay forSeconds: 1) wait. SessionManager inputState userSessionIdleMs.
	"

	| currentTime lastInputTime |
	currentTime := KernelLibrary default getTickCount.
	lastInputTime := self getLastInputInfo.
	currentTime < lastInputTime ifTrue: [^currentTime].	"In case of 49.7-day wrap, we understate the idle time"
	^currentTime - lastInputTime!

visibleWindows
	"Private - Answer a collection of the visible windows belonging to the current session."

	"Implementation Note: We use the bare metal UserLibrary functions to avoid any dependency on
	the existing View classes. This might be important to those wanting to implement their own
	window class hieararchy."

	| hDesktop user |
	user := UserLibrary default.
	hDesktop := user getDesktopWindow.
	^windows select: 
			[:each | 
			| hWnd |
			hWnd := each asParameter.
			hWnd notNil and: [hWnd ~= hDesktop and: [(user isWindow: hWnd) and: [user isWindowVisible: hWnd]]]]! !

!GuiInputState categoriesForMethods!
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
!

