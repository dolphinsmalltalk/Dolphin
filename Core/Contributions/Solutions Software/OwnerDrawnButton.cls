"Filed out from Dolphin Smalltalk"!

PushButton subclass: #OwnerDrawnButton
	instanceVariableNames: 'displayState transitionDurations shouldShowKeyboardCues animationEndTime setFocusTime'
	classVariableNames: ''
	poolDictionaries: 'ThemeConstants'
	classInstanceVariableNames: ''!

OwnerDrawnButton guid: (GUID fromString: '{b1b80a82-7d68-47aa-b70a-d079b92fca12}')!

OwnerDrawnButton comment: 'Abstract superclass for implementing custom-look buttons with standard Windows behavior, including support for animated transitions.
As a minimum, subclasses need to implement drawOn:'!

!OwnerDrawnButton categoriesForClass!Unclassified! !

!OwnerDrawnButton methodsFor!

animateTransitionTo: aSymbol

	"Private - Return success"

	| transition params sourceDC destDC animation sourceCanvas destCanvas |

	self isOpen ifFalse: [^false].

	"Suppress a second notification to draw the same state whilst a transition to that state is being animated"
	(self displayState = aSymbol and: [Time millisecondClockValue < self animationEndTime]) ifTrue: [^true].

	ThemeLibrary default bufferedPaintStopAllAnimations: self handle.

	transition := self transitionTo: aSymbol.

	params := BP_ANIMATIONPARAMS new.
	params style: 1 "BPAS_LINEAR"; dwDuration: (self durationOfTransition: transition).
	sourceDC := ExternalHandle new.
	destDC := ExternalHandle new.

	animation := 
		ThemeLibrary default 
			beginBufferedAnimation: self handle 
			hdcTarget: self canvas asParameter 
			prcTarget: (0@0 extent: self extent) asParameter
			dwFormat: BPBF_COMPATIBLEBITMAP 
			pPaintParams: nil 
			pAnimationParams: params 
			phdcFrom: sourceDC 
			phdcTo: destDC.

	(sourceDC isNull or: [destDC isNull]) ifTrue: [^false].

	sourceCanvas := Canvas withNonOwnedDC: sourceDC.
	destCanvas := Canvas withNonOwnedDC: destDC.

	sourceCanvas backcolor: self actualBackcolor; erase.
	destCanvas backcolor: self actualBackcolor; erase.

	self drawOn: sourceCanvas.
	self displayState: aSymbol.
	self drawOn: destCanvas.

	^(ThemeLibrary default endBufferedAnimation: animation fUpdateTarget: true) = 0
		ifTrue: [self animationEndTime: (Time millisecondClockValue + params dwDuration). true]
		ifFalse: [false]!

animationEndTime

	^animationEndTime ifNil: [0]!

animationEndTime: anInteger

	animationEndTime := anInteger!

defaultTransitionDurations

	^self nilTransitionDurations!

displayState
	^displayState!

displayState: anObject
	displayState := anObject!

drawOn: aCanvas

	self subclassResponsibility!

durationOfTransition: aSymbol

	^(self transitionDurations at: aSymbol ifAbsent: [nil]) ifNil: [0]!

initialize

	super initialize.

	self transitionDurations: self defaultTransitionDurations!

isHot

	^self displayState = #hot!

isOffScreen

	"Primarily to detect if the receiver is in the ViewComposer"
	^(View desktop rectangle containsPoint: (self mapPoint: self clientRectangle topLeft to: View desktop)) not!

isPressed

	^self displayState = #pressed
!

iState

	"State ID for Theme API"

	^##(Dictionary new
		at: #disabled put: PBS_DISABLED;
		at: #pressed put: PBS_PRESSED;
		at: #hot put: PBS_HOT;
		at: #default put: PBS_DEFAULTED;
		at: #normal put: PBS_NORMAL;
		yourself) at: self displayState ifAbsent: [PBS_NORMAL]!

nilTransitionDurations

	^Dictionary new
		at: #hot put: nil;
		at: #cold put: nil;
		at: #pressed put: nil;
		at: #released put: nil;
		at: #disabled put: nil;
		at: #enabled put: nil;
		yourself!

nmCustomDraw: pNMHDR

	"Private - Intercept a pre-paint notification to handle all painting ourselves"

	| customDraw |

	customDraw := NMCUSTOMDRAW fromAddress: pNMHDR.
	(customDraw dwDrawStage allMask: CDDS_PREPAINT) ifTrue: [self onCustomDraw: customDraw].

	^CDRF_SKIPDEFAULT!

onCustomDraw: anNMCUSTOMDRAW

	| newDisplayState |

	self isOpen ifFalse: [^self].

	self isDefault 
		ifTrue: [newDisplayState := #default]
		ifFalse: [newDisplayState := #normal].

	anNMCUSTOMDRAW isHot ifTrue: 
		[self displayState = #pressed 
			ifTrue: [newDisplayState := #released] 
			ifFalse: [newDisplayState := #hot]].
	anNMCUSTOMDRAW isSelected ifTrue: [newDisplayState := #pressed].
	anNMCUSTOMDRAW isDisabled ifTrue: [newDisplayState := #disabled].
	self shouldShowKeyboardCues: (anNMCUSTOMDRAW uItemState allMask: CDIS_SHOWKEYBOARDCUES).

	(self shouldAnimateTransitionTo: newDisplayState)
		ifTrue: [[(self animateTransitionTo: newDisplayState) ifFalse: ["Failed" self isOpen ifTrue: [self drawOn: self canvas]]] postToInputQueue]
		ifFalse: [self animationEndTime: 0; displayState: newDisplayState; drawOn: anNMCUSTOMDRAW canvas]!

setFocusTime
	^setFocusTime ifNil: [0]!

setFocusTime: anObject
	setFocusTime := anObject!

shouldAnimateTransitionTo: newDisplayState

	self isThemed ifFalse: [^false].
	self displayState = newDisplayState ifTrue: [^false].

	"Pressing the button when it did not previously have focus appears to have a zero transition period"
	(self displayState = #hot and: [newDisplayState = #pressed and: [Time millisecondClockValue < (self setFocusTime + 100"ms, nominal")]]) ifTrue: [^false].

	"To handle displaying the receiver in the ViewComposer or Resource view preview"
	(self isOffScreen or: [self topShell view hasVisibleStyle not]) ifTrue: [^false].

	^(self durationOfTransition: (self transitionTo: newDisplayState)) > 0!

shouldShowFocusRect

	^self shouldShowKeyboardCues and: [super shouldShowFocusRect]!

shouldShowKeyboardAccelerators

	^self shouldShowKeyboardCues and: [super shouldShowKeyboardAccelerators]!

shouldShowKeyboardCues
	^shouldShowKeyboardCues ifNil: [false]!

shouldShowKeyboardCues: anObject
	shouldShowKeyboardCues := anObject!

style

	"Always push style"

	^#push!

style: aSymbol

	"Always push style - ignore"!

themeTransitionDurations

	| durations lookups |

	self isThemed ifFalse: [^self nilTransitionDurations].

	durations := Dictionary new.
	lookups := 
		##(Dictionary new
			at: #hot put: ##(Array with: PBS_NORMAL with: PBS_HOT);
			at: #cold put: ##(Array with: PBS_HOT with: PBS_NORMAL);
			at: #pressed put: ##(Array with: PBS_NORMAL with: PBS_PRESSED);
			at: #released put: ##(Array with: PBS_PRESSED with: PBS_NORMAL);
			at: #disabled put: ##(Array with: PBS_NORMAL with: PBS_DISABLED);
			at: #enabled put: ##(Array with: PBS_DISABLED with: PBS_NORMAL);
			yourself).

	lookups keysAndValuesDo: 
		[ :transition :iStates || pdwDuration |
		pdwDuration := SDWORD new.
		ThemeLibrary default getThemeTransitionDuration: self theme asParameter iPartId: BP_PUSHBUTTON iStateIdFrom: iStates first iStateIdTo: iStates last iPropId: 6000 "TMT_TRANSITIONDURATIONS" pdwDuration: pdwDuration.
		durations at: transition put: pdwDuration value].

	^durations!

transitionDurations
	^transitionDurations ifNil: [transitionDurations := self defaultTransitionDurations]!

transitionDurations: anObject
	transitionDurations := anObject!

transitionTo: aSymbol

	"Return a Symbol indicating the type of transition from the receiver's last displayState to aSymbol.
	The return value should be a key of the transitionDurations Dictionary"

	"Some states always name themselves"
	(#(#hot #pressed #disabled) includes: aSymbol) ifTrue: [^aSymbol].

	"Opposites"
	(self displayState = #hot) ifTrue: [^#cold].
	(self displayState = #disabled) ifTrue: [^#enabled].
	(self displayState = #pressed) ifTrue: [^#released].

	"No recognised transition"
	^nil!

uState

	"Non-theme button display API state ID"

	| uState |

	uState := DFCS_BUTTONPUSH.

	self isEnabled
		ifTrue: [self isPressed ifTrue: [uState := uState | DFCS_PUSHED]]
		ifFalse: [uState := uState | DFCS_INACTIVE].

	^uState!

wmKillFocus: message wParam: wParam lParam: lParam

	"Override to ensure we redraw in the new state"

	self invalidate.

	^super wmKillFocus: message wParam: wParam lParam: lParam!

wmPaint: message wParam: wParam lParam: lParam 

	"All prompts to display the next animation frame come through here"

	^(ThemeLibrary default bufferedPaintRenderAnimation: self handle hdcTarget: self canvas asParameter)
		ifTrue: [nil]
		ifFalse: [super wmPaint: message wParam: wParam lParam: lParam]!

wmSetFocus: message wParam: wParam lParam: lParam

	"Override to set the time and ensure we redraw in the new state"

	self setFocusTime: Time millisecondClockValue.

	self invalidate.

	^super wmSetFocus: message wParam: wParam lParam: lParam! !

!OwnerDrawnButton categoriesForMethods!
animateTransitionTo:!drawing!private! !
animationEndTime!accessing!private! !
animationEndTime:!accessing!private! !
defaultTransitionDurations!accessing!public! !
displayState!accessing!private! !
displayState:!accessing!private! !
drawOn:!drawing!private! !
durationOfTransition:!accessing!public! !
initialize!initialize/release!public! !
isHot!public!testing! !
isOffScreen!public!testing! !
isPressed!public!testing! !
iState!accessing!public! !
nilTransitionDurations!constants!public! !
nmCustomDraw:!event handling-win32!private! !
onCustomDraw:!event handling!public! !
setFocusTime!accessing!public! !
setFocusTime:!accessing!public! !
shouldAnimateTransitionTo:!public!testing! !
shouldShowFocusRect!public!testing! !
shouldShowKeyboardAccelerators!public!testing! !
shouldShowKeyboardCues!accessing!private! !
shouldShowKeyboardCues:!accessing!private! !
style!accessing!private! !
style:!accessing!private! !
themeTransitionDurations!constants!public! !
transitionDurations!accessing!private! !
transitionDurations:!accessing!private! !
transitionTo:!accessing!public! !
uState!accessing!public! !
wmKillFocus:wParam:lParam:!event handling-win32!private! !
wmPaint:wParam:lParam:!event handling-win32!private! !
wmSetFocus:wParam:lParam:!event handling-win32!private! !
!

