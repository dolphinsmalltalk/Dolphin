"Filed out from Dolphin Smalltalk"!

Presenter subclass: #EtchASketch
	instanceVariableNames: 'upDownKnob leftRightKnob sketchPad lastLocation'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EtchASketch guid: (GUID fromString: '{87b4c68a-026e-11d3-9fd7-00a0cc3e4a32}')!

EtchASketch comment: 'EtchASketch is a <compositePresenter> component that emulates the popular Etch-a-Sketch toy. It allows "ink" to be drawn onto a sketch pad by means of two "knobs"; one for horizontal movement and one for vertical movement. In the basic view the knobs are represented by scroll bars. EtchASketch makes use of the Scribble component for its sketch area.

There are a couple of limitations that make this example not ideal:

1/ It is not possible (with the Windows interface) to move both "knobs" simultaneously. This means that it is not possible to draw diagonal lines.

2/ A new InkStroke object is added for each incremental movement of a "knob". This is relatively inefficient, since a scrollbar will create many events as it is moved, resulting in many InkStrokes being created. A more sophisticated approach would be to coalesce the consequetive movements of a knob into one stroke. This is left as an exercise for the reader.

Example: 

EtchASketch show.

See the package comment for further examples of use.

Instance Variables:
	upDownKnob	<NumberPresenter> for the vertical drawing "knob".
	leftRightKnob	<NumberPresenter> for the horizontal drawing "knob".
	sketchPad		<Scribble> displaying the picture.
	lastLocation	<Point> holding the last location drawn to.





'!

!EtchASketch categoriesForClass!MVP-Presenters!Samples! !

!EtchASketch methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	upDownKnob := self add: NumberPresenter new name: 'upDownKnob'.
	leftRightKnob := self add: NumberPresenter new name: 'leftRightKnob'.
	sketchPad := self add: Scribble new name: 'sketchPad'.
!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	leftRightKnob when: #valueChanged send: #onKnobChanged to: self.
	upDownKnob when: #valueChanged send: #onKnobChanged to: self.
!

initialize
	"Private - Initialize the receiver"

	super initialize.
	lastLocation := 0@0.!

model: aListModel
	"Connects the receiver to aListModel. Since the receiver has the same model as the
	sketch pad (Scribble) component that it holds we pass this down to it."

	super model: aListModel.
	sketchPad model: aListModel.!

onKnobChanged
	"Private - Once of the knobs has been moved. Draw to the correct location in the sketch pad"

	| newLocation inkStroke scale |

	"Find the location indicated by the current state of the knobs. Their range is 0-100%
	so scale this to the extent of the sketch pad view"
	scale := sketchPad view extent / 100.
	newLocation := ((leftRightKnob value @ upDownKnob value) * scale) truncated.

	"Create an InkStroke representing this movement from the last known location.
	Add this to the model."
	inkStroke := InkStroke new
		addPoint: lastLocation;
		addPoint: newLocation;
		yourself.
	self model add: inkStroke.

	"Remember the current location as the last"
	lastLocation := newLocation.! !

!EtchASketch categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
initialize!initializing!private! !
model:!accessing!public! !
onKnobChanged!event handling!private! !
!

!EtchASketch class methodsFor!

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
		helpId: 10619!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1140850688 131073 416 nil 327686 ##(Smalltalk.Color) #red nil 7 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850945 1 544 nil 496 nil 7 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[241 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 32 0 66 0 108 0 97 0 99 0 107 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 544 482 #white 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[20 0 0 0 0 0 0 0 74 1 0 0 25 0 0 0] 193 576 nil 544 818 #text: 34 1 8 'Etch-a-Sketch(tm)' 544 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 410 ##(Smalltalk.Slider) 34 18 nil 416 34 2 8 1140916224 1 1040 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 1170 #hash 8 #() nil 482 #default nil 7 nil nil nil 1040 nil 8 1758656992 722 nil nil 3 nil nil 754 138 144 34 4 818 #createWindow: 34 1 866 898 8 #[20 0 0 0 205 0 0 0 74 1 0 0 230 0 0 0] 193 1072 8 '' 1040 818 #ticks: 34 1 8 #(0 100) 1040 818 #pageSize: 8 #(0) 1040 818 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 1040 3 8 #() 1010 193 193 nil 27 410 ##(Smalltalk.Slider) 34 18 nil 416 34 2 8 1140916226 1 1616 1106 nil false 1152 nil 1248 nil 7 nil nil nil 1616 nil 8 1758656992 722 nil nil 3 nil nil 754 138 144 34 4 818 #createWindow: 34 1 866 898 8 #[49 1 0 0 25 0 0 0 74 1 0 0 205 0 0 0] 193 1648 8 '' 1616 818 #ticks: 34 1 8 #(0 100) 1616 818 #pageSize: 8 #(0) 1616 818 #range: 34 1 1554 1 201 3 1616 3 8 #() 1010 193 193 nil 27 nil 410 ##(Smalltalk.ScribbleView) 34 12 nil 416 34 2 8 1140850688 1 2032 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 482 #face3d nil 7 nil nil nil 2032 754 138 144 34 1 818 #createWindow: 34 1 866 898 8 #[20 0 0 0 25 0 0 0 49 1 0 0 205 0 0 0] 193 2064 8 '' 2032 3 8 #() 1010 193 193 nil 27 170 192 34 6 2032 8 'sketchPad' 1616 8 'upDownKnob' 1040 8 'leftRightKnob' 590342 ##(Smalltalk.Rectangle) 1010 41 1 1010 41 41 754 138 144 34 1 818 #createWindow: 34 1 866 898 8 #[127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 193 448 8 '' 416 3 34 4 1040 1616 2032 544 1010 193 193 nil 27 )!

sampleDescription
	"Private - Answer the description of the receiver to be used in the samples folder."

	^'Etch-a-Sketch'! !

!EtchASketch class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
initialize!class initialization!private! !
resource_Default_view!public!resources-views! !
sampleDescription!constants!development!private! !
!

