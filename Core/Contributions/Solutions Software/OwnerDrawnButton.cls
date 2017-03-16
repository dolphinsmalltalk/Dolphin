"Filed out from Dolphin Smalltalk 7"!

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

	self displayState = aSymbol ifTrue: [^false].

	transition := self transitionTo: aSymbol.
	(self shouldAnimateTransition: transition) ifFalse: [^false].

	ThemeLibrary default bufferedPaintStopAllAnimations: self handle.

	params := BP_ANIMATIONPARAMS new.
	params cbSize: params size; style: 1 "BPAS_LINEAR"; dwDuration: (self durationOfTransition: transition).
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

	^Dictionary new
		at: #hot put: nil;
		at: #cold put: nil;
		at: #pressed put: nil;
		at: #released put: nil;
		at: #disabled put: nil;
		at: #enabled put: nil;
		yourself!

displayState
	^displayState!

displayState: anObject
	displayState := anObject!

displayText

	^self shouldShowKeyboardAccelerators
		ifTrue: [self text]
		ifFalse: [self unadornedText]!

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
		at: #focus put: PBS_DEFAULTED;
		at: #normal put: PBS_NORMAL;
		yourself) at: self displayState ifAbsent: [PBS_NORMAL]!

nmCustomDraw: pNMHDR

	"Private - Intercept a pre-paint notification to handle all painting ourselves"

	| customDraw |

	customDraw := NMCUSTOMDRAW fromAddress: pNMHDR.
	(customDraw dwDrawStage allMask: CDDS_PREPAINT) ifTrue: [self onCustomDraw: customDraw].

	^CDRF_SKIPDEFAULT!

onCustomDraw: anNMCUSTOMDRAW

	| newDisplayState |

	self isOpen ifFalse: [^self].

	"Primarily to handle displaying the receiver in the ViewComposer"
	self isOffScreen ifTrue: [^self drawOn: anNMCUSTOMDRAW canvas].

	self isDefault 
		ifTrue: [newDisplayState := #focus]
		ifFalse: [newDisplayState := #normal].

	anNMCUSTOMDRAW isHot ifTrue: [newDisplayState := #hot].
	anNMCUSTOMDRAW isSelected ifTrue: [newDisplayState := #pressed].
	anNMCUSTOMDRAW isDisabled ifTrue: [newDisplayState := #disabled].

	self shouldShowKeyboardCues: (anNMCUSTOMDRAW uItemState allMask: 16r200 "CDIS_SHOWKEYBOARDCUES").

	"Pressing the button when it did not previously have focus appears to have a zero transition period"
	(self displayState = #hot and: [newDisplayState = #pressed and: [Time millisecondClockValue < (self setFocusTime + 100"ms, nominal")]]) ifTrue: 
		[self displayState: newDisplayState. 
		^self drawOn: anNMCUSTOMDRAW canvas].

	"Suppress a second notification to draw the same state whilst a transition to that state is being animated"
	[(newDisplayState = self displayState
		ifTrue: [Time millisecondClockValue < self animationEndTime ]
		ifFalse: [self animateTransitionTo: newDisplayState]) ifFalse: [self displayState: newDisplayState; drawOn: self canvas]] postToInputQueue!

setFocusTime
	^setFocusTime ifNil: [0]!

setFocusTime: anObject
	setFocusTime := anObject!

shouldAnimateTransition: aSymbol

	^self isThemed and: [(self durationOfTransition: aSymbol) > 0]!

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

transitionDurations
	^transitionDurations!

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

unadornedText

	| index |

	(self text includes: $&) ifFalse: [^self text].

	"Check for doubled &"
	index := 0.
	^self text reject: [ :char | index := index + 1. char = $& and: [index = self text size or: [(self text at: (index + 1)) ~= $&]]]
!

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
!OwnerDrawnButton categoriesFor: #animateTransitionTo:!operations!private! !
!OwnerDrawnButton categoriesFor: #animationEndTime!accessing!private! !
!OwnerDrawnButton categoriesFor: #animationEndTime:!accessing!private! !
!OwnerDrawnButton categoriesFor: #defaultTransitionDurations!constants!public! !
!OwnerDrawnButton categoriesFor: #displayState!accessing!private! !
!OwnerDrawnButton categoriesFor: #displayState:!accessing!private! !
!OwnerDrawnButton categoriesFor: #displayText!accessing!public! !
!OwnerDrawnButton categoriesFor: #drawOn:!operations!private! !
!OwnerDrawnButton categoriesFor: #durationOfTransition:!accessing!public! !
!OwnerDrawnButton categoriesFor: #initialize!initialize/release!public! !
!OwnerDrawnButton categoriesFor: #isHot!public!testing! !
!OwnerDrawnButton categoriesFor: #isOffScreen!public!testing! !
!OwnerDrawnButton categoriesFor: #isPressed!public!testing! !
!OwnerDrawnButton categoriesFor: #iState!accessing!public! !
!OwnerDrawnButton categoriesFor: #nmCustomDraw:!event handling-win32!private! !
!OwnerDrawnButton categoriesFor: #onCustomDraw:!event handling!public! !
!OwnerDrawnButton categoriesFor: #setFocusTime!public! !
!OwnerDrawnButton categoriesFor: #setFocusTime:!public! !
!OwnerDrawnButton categoriesFor: #shouldAnimateTransition:!public!testing! !
!OwnerDrawnButton categoriesFor: #shouldShowFocusRect!public!testing! !
!OwnerDrawnButton categoriesFor: #shouldShowKeyboardAccelerators!public!testing! !
!OwnerDrawnButton categoriesFor: #shouldShowKeyboardCues!accessing!private! !
!OwnerDrawnButton categoriesFor: #shouldShowKeyboardCues:!accessing!private! !
!OwnerDrawnButton categoriesFor: #style!constants!private! !
!OwnerDrawnButton categoriesFor: #style:!constants!private! !
!OwnerDrawnButton categoriesFor: #transitionDurations!accessing!private! !
!OwnerDrawnButton categoriesFor: #transitionDurations:!accessing!private! !
!OwnerDrawnButton categoriesFor: #transitionTo:!accessing!public! !
!OwnerDrawnButton categoriesFor: #unadornedText!accessing!public! !
!OwnerDrawnButton categoriesFor: #uState!accessing!public! !
!OwnerDrawnButton categoriesFor: #wmKillFocus:wParam:lParam:!event handling-win32!private! !
!OwnerDrawnButton categoriesFor: #wmPaint:wParam:lParam:!event handling-win32!private! !
!OwnerDrawnButton categoriesFor: #wmSetFocus:wParam:lParam:!event handling-win32!private! !

