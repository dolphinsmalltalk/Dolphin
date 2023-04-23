"Filed out from Dolphin Smalltalk"!

UI.ValueConvertingControlView
	subclass: #'UI.ProgressBar'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ProgressBarConstants})
	classInstanceVariableNames: ''
	classConstants: { 'ValidRange' -> (16r0 to: 16rFFFF) }!
UI.ProgressBar guid: (Core.GUID fromString: '{87b4c737-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ProgressBar comment: 'ProgressBar is a <valueView> implementing the Windows "msctls_progress32" common control. The <valueModel> associated with a ProgressBar must always yield an <integer> value when mapped through the installed type converter. A ProgressBar will normally be used in conjunction with a <NumberPresenter>.

Class Variables:
	ValidRange	<Interval> describing the range of displayable <integer> values.

'!
!UI.ProgressBar categoriesForClass!MVP-Views! !
!UI.ProgressBar methodsFor!

backcolorChanged
	"Private - Note that setting the colours of a progress bar has no effect when XP
	visual themes are enabled."

	super backcolorChanged.
	"For some reason immediate invalidation done by superclass method has no effect"
	[self invalidate] postToMessageQueue!

barPosition
	"Private - Answer the current bar position of the receiver."

	^self deltaBarPosition: 0!

barPosition: aNumber
	"Private - Set the receiver's bar position to aNumber.
	Answers the previous position"

	^self sendMessage: PBM_SETPOS wParam: aNumber asInteger!

defaultWindowStyle
	"Private - Answer a default style to use when creating a progress bar."

	^super defaultWindowStyle maskClear: WS_TABSTOP
!

deltaBarPosition: aNumber
	"Private - Move the bar position relative to its current position
	by the increment/decrement specified by aNumber. Answers the previous
	position."

	^self sendMessage: PBM_DELTAPOS wParam: aNumber asInteger!

displayValue
	"Private - Answer the current displayable contents of the receiver
	(the integer bar position)."

	^self barPosition!

displayValue: anInteger
	"Private - Set the displayable contents of the receiver, the bar position,
	 to anInteger"

	self barPosition: anInteger!

forecolor: aColorOrNil 
	"Sets the foreground colour of the receiver to aColorOrNil.
	If aColorOrNil is nil then use the default color"

	super forecolor: aColorOrNil.
	self 
		sendMessage: PBM_SETBARCOLOR
		wParam: 0
		lParam: (self forecolor ifNil: [CLR_DEFAULT] ifNotNil: [:color | color asCOLORREF]).
	[self invalidate] postToMessageQueue!

incrementBy: anInteger
	"Advance the receiver's bar position by anInteger increment.
	Answer the previous position."

	^self
		sendMessage: PBM_DELTAPOS
		wParam: anInteger asParameter!

isSmooth
	^self baseStyleAllMask: PBS_SMOOTH!

isSmooth: aBoolean 
	self 
		baseStyleMask: PBS_SMOOTH
		set: aBoolean
		recreateIfChanged: false!

onViewCreated
	super onViewCreated.
	self setControlBackcolor.
	self forecolor ifNotNil: [:fore | self forecolor: fore]!

range
	"Answer the current bar range of the receiver."

	| range |
	self noRedrawDo: 
			[range := self range: (0 to: 100).
			self range: range].
	^range!

range: anIntegerInterval
	"Set the receiver's bar range to anIntegerInterval. Answer the previous range of nil
	if there was not one."

	| answer |
	self
		assert: [anIntegerInterval start >= ValidRange start & (anIntegerInterval stop <= ValidRange stop)].
	answer := self
				sendMessage: PBM_SETRANGE
				wParam: 0
				lpParam: (anIntegerInterval start asInteger bitOr: (anIntegerInterval stop asInteger bitShift: 16)).
	^answer == 0
		ifTrue: [self errorInCommonControlCall]
		ifFalse: 
			[self refreshContents.
			answer lowWord to: answer highWord]!

setControlBackcolor: aColor 
	self 
		sendMessage: CCM_SETBKCOLOR
		wParam: 0
		lParam: aColor asCOLORREF!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state"

	^super state
		add: (MessageSend
					receiver: self
					selector: #range:
					argument: self range);
		yourself! !
!UI.ProgressBar categoriesForMethods!
backcolorChanged!helpers!private! !
barPosition!accessing!private! !
barPosition:!accessing!private! !
defaultWindowStyle!constants!private! !
deltaBarPosition:!positioning!private! !
displayValue!private!updating! !
displayValue:!private!updating! !
forecolor:!accessing!public! !
incrementBy:!positioning!public! !
isSmooth!accessing-styles!public!updating! !
isSmooth:!accessing-styles!public!updating! !
onViewCreated!accessing!public! !
range!accessing!public! !
range:!accessing!public! !
setControlBackcolor:!accessing!private! !
state!accessing!private! !
!

!UI.ProgressBar class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^0 asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialise the receiver."

	CommCtrlLibrary addInitFlag: ICC_PROGRESS_CLASS!

themePartName
	^'PROGRESS'!

uninitialize
	CommCtrlLibrary removeInitFlag: ICC_PROGRESS_CLASS!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'msctls_progress32'
! !
!UI.ProgressBar class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
initialize!development!initializing!private! !
themePartName!constants!private! !
uninitialize!class hierarchy-removing!private! !
winClassName!constants!private! !
!

