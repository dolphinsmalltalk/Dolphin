"Filed out from Dolphin Smalltalk"!

UI.ValueConvertingControlView
	subclass: #'UI.ProgressBar'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ProgressBarConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

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

isMarquee
	^self baseStyleAllMask: PBS_MARQUEE!

isMarquee: aBoolean 
	self 
		baseStyleMask: PBS_MARQUEE
		set: aBoolean
		recreateIfChanged: false!

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

	^(self sendMessage: PBM_GETRANGE wParam: 1) to: (self sendMessage: PBM_GETRANGE wParam: 0)!

range: anIntegerInterval
	"Set the receiver's bar range to anIntegerInterval. Answer the previous range of nil
	if there was not one."

	| start stop |
	start := anIntegerInterval start asInteger.
	stop := anIntegerInterval stop asInteger.
	stop <= start
		ifTrue: 
			[InvalidArgumentError signal: 'Invalid range <1p>' << { anIntegerInterval } with: 'anIntegerInterval'].
	self
		sendMessageNz: PBM_SETRANGE32
		wParam: anIntegerInterval start asInteger
		lpParam: anIntegerInterval stop.
	self refreshContents.
	^self range!

setControlBackcolor: aColor 
	self 
		sendMessage: CCM_SETBKCOLOR
		wParam: 0
		lParam: aColor asCOLORREF!

startMarquee
	self sendMessage: PBM_SETMARQUEE wParam: 1!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state"

	^super state
		add: (MessageSend
					receiver: self
					selector: #range:
					argument: self range);
		yourself!

stopMarquee
	self sendMessage: PBM_SETMARQUEE wParam: 0! !

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
isMarquee!accessing-styles!public! !
isMarquee:!accessing-styles!public! !
isSmooth!accessing-styles!public! !
isSmooth:!accessing-styles!public! !
onViewCreated!accessing!public! !
range!accessing!public! !
range:!accessing!public! !
setControlBackcolor:!accessing!private! !
startMarquee!positioning!public! !
state!accessing!private! !
stopMarquee!positioning!public! !
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

