"Filed out from Dolphin Smalltalk"!

UI.ValidationResultPresenter
	subclass: #'UI.ValidationHintPresenter'
	instanceVariableNames: 'bubble hintFont dwell filterBlock positionBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ValidationHintPresenter guid: (Core.GUID fromString: '{b7b6f02e-372e-4291-b168-a240397d658f}')!

UI.ValidationHintPresenter comment: '`ValidationHintPresenter` is a `ValidationResultPresenter` that displays a `ValidationResult` using a `MessageBubble` (a form of tool-tip that looks like a speech bubble).'!

!UI.ValidationHintPresenter methodsFor!

closeHintBubble
	bubble
		ifNotNil: 
			[bubble close.
			bubble := nil]!

createSchematicWiring
	parentPresenter
		when: #positionChanged:
		send: #onParentPositionChanged:
		to: self!

defaultPositionFor: aValidationResult
	^(aValidationResult presenter ifNil: [parentPresenter]) view screenRectangle centerRight!

dwell
	"Answer the <Duration> for which a hint bubble should be shown before fading away."

	^dwell!

dwell: aDuration
	"Set the <Duration> for which a hint bubble should be shown before fading away."

	dwell := aDuration!

filterBlock
	^filterBlock!

filterBlock: aMonadicValuable
	"Set the <monadicValuable> predicated be evaluated to determine whether a new validation result should result in the display of a hint."

	filterBlock := aMonadicValuable!

getCaption: aValidationResult
	^aValidationResult caption
		ifNil: [aValidationResult hint iconStyle == #error ifTrue: ['Invalid Input']]!

getPosition: aValidationResult
	^positionBlock cull: aValidationResult!

hintFont
	"Answer the `Font` to be used for the main text of any hint bubble. This does not affect the headline text, the font of which is not configurable."

	^hintFont ifNil: [super hintFont]!

hintFont: aFont
	"Set the `Font` to be used for the main text of any hint bubble. This does not affect the headline text, the font of which is not configurable."

	hintFont := aFont!

initialize
	"Private - Initialize the receiver."

	super initialize.
	filterBlock := [:result | true].
	positionBlock := [:result | self defaultPositionFor: result].
	dwell := SystemMetrics current messageDuration!

onParentPositionChanged: aPositionEvent
	"Private - The parent has been moved/resized. The hint bubble is a child of the desktop, so won't move with the parent. Leaving it behind may orphan the bubble visually, which is aesthetically unpleasing, so ensure it is closed."

	self closeHintBubble!

onValueChanged
	"Private - The value held by the receiver's model has changed. We may want to display the validation result in a hint bubble."

	self showHintBubble: self value.
	super onValueChanged!

positionBlock
	"Answer the <monadicValuable> to be evaluated to determine the position at which to display any hint bubble. The block is expected to answer a <Point> specifying the desired screen co-ordinates of the tip of the tail of the speech bubble. By default the tail-tip is positioned to the centre of the right edge of the presenter associated with the validation result. The OS will decide where best to place the cartouche."

	^positionBlock!

positionBlock: aMonadicValuable
	"Set the <monadicValuable> to be evaluated to determine the position at which to display any hint bubble. Needs to answer a <Point> specifying the desired screen co-ordinates of the tip of the tail of the speech bubble."

	positionBlock := aMonadicValuable!

shouldShowHint: aValidationResult
	^aValidationResult notNil
		and: [aValidationResult hint notNil and: [self filterBlock cull: aValidationResult]]!

showHintBubble: aValidationResult
	self closeHintBubble.
	(self shouldShowHint: aValidationResult) ifFalse: [^self].
	bubble := MessageBubble new.
	bubble
		caption: (self getCaption: aValidationResult);
		font: self hintFont;
		timeout: self dwell;
		position: (self getPosition: aValidationResult);
		exceptionDescription: aValidationResult hint;
		isSilent: true;
		open! !

!UI.ValidationHintPresenter categoriesForMethods!
closeHintBubble!helpers!private! !
createSchematicWiring!initializing!private! !
defaultPositionFor:!helpers!private! !
dwell!accessing!public! !
dwell:!accessing!public! !
filterBlock!accessing!public! !
filterBlock:!accessing!public! !
getCaption:!helpers!private! !
getPosition:!helpers!private! !
hintFont!accessing!public! !
hintFont:!accessing!public! !
initialize!initializing!private! !
onParentPositionChanged:!event handling!private! !
onValueChanged!event handling!private! !
positionBlock!accessing!public! !
positionBlock:!accessing!public! !
shouldShowHint:!private!testing! !
showHintBubble:!helpers!private! !
!

