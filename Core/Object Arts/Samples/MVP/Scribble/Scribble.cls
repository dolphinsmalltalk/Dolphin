"Filed out from Dolphin Smalltalk"!

Presenter subclass: #Scribble
	instanceVariableNames: 'newStroke trackingCanvas'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Scribble guid: (GUID fromString: '{87b4c686-026e-11d3-9fd7-00a0cc3e4a32}')!

Scribble comment: 'Scribble is a <presenter> component that displays a <listModel> of <InkStroke>s within a <ScribbleView>. It is used to for accepting ''ink'' as a series of mouse or pen strokes and populate the model with this data. Scribble is part of the Scribble sample package. For examples of use please see the package comment.'!

!Scribble categoriesForClass!MVP-Presenters!Samples! !

!Scribble methodsFor!

cancelTrackingAt: aPoint 
	"Private - Nothing to do"

	!

continueTrackingAt: aPoint from: aPreviousPoint 
	"Private - Continue ink tracking for the associated view at aPoint when
	the previous tracking position was at aPreviousPoint. Part of the <MouseTracker>
	target protocol. Answers the actual position achieved"

	"Continue with the visual feedback"

	"Add aPoint to the stroke we're assembing"

	newStroke addPoint: aPoint.
	newStroke drawOn: trackingCanvas.
	^aPoint!

endTrackingAt: aPoint
	"Private - End ink tracking for the new position of the receiver.
	Part of the <MouseTracker> target protocol."

	"Add the new stroke to the model and tidy up"
	self model add: newStroke.
	newStroke := trackingCanvas := nil!

initialize
	"Private - Initialize the receiver"

	super initialize.

	"When running as an applet it can be useful do load all necessary classes when the
	applet is started rather than waiting for each to be fetched on demand. The easiest
	way to effect this is by adding references to required classes in the applet's
	initialization. Let's fetch the InkStroke class here... "

	InkStroke yourself.!

onLeftButtonPressed: aMouseEvent
	"A left button down mouse event has occurred. Create a MouseTracker to monitor the mouse
	movement from this point until the button is released."

	(MouseTracker forPresenter: self startingAt: aMouseEvent screenPosition) 
		origin: aMouseEvent position;
		startTracking: self.!

startTrackingAt: aPoint
	"Private - Start ink tracking for the associated view at aPoint. Part of the 
	<MouseTracker> target protocol. Answers the actual position achieved."

	"Draw some visual feedback"
	trackingCanvas := self view canvas.
	trackingCanvas moveTo: aPoint.

	"Create a new stroke"
	newStroke := InkStroke new.
	^newStroke addPoint: aPoint.! !

!Scribble categoriesForMethods!
cancelTrackingAt:!private!tracking! !
continueTrackingAt:from:!private!tracking! !
endTrackingAt:!private!tracking! !
initialize!initializing!private! !
onLeftButtonPressed:!event handling!public! !
startTrackingAt:!private!tracking! !
!

Scribble methodProtocol: #mouseTrackerTarget attributes: #(#readOnly) selectors: #(#cancelTrackingAt: #continueTrackingAt:from: #endTrackingAt: #startTrackingAt:)!

!Scribble class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel new!

icon
	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self sampleDescription
		helpId: 10620!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScribbleView) 34 12 nil nil 34 2 8 1140850688 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #lightYellow nil 7 nil nil nil 416 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 722 481 361 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 111 8 0 0 190 0 0 0] 8 #() 722 193 193 nil 27 )!

sampleDescription
	"Private - Answer the description of the receiver to be used in the samples folder."

	^'Scribble Pad'! !

!Scribble class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
initialize!class initialization!private! !
resource_Default_view!public!resources-views! !
sampleDescription!constants!development!private! !
!

