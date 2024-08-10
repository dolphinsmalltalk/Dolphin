"Filed out from Dolphin Smalltalk"!

UI.Presenter
	subclass: #'UI.Examples.EtchASketch'
	instanceVariableNames: 'upDownKnob leftRightKnob sketchPad lastLocation'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.EtchASketch guid: (Core.GUID fromString: '{87b4c68a-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Examples.EtchASketch comment: 'EtchASketch is a <compositePresenter> component that emulates the popular Etch-a-Sketch toy. It allows "ink" to be drawn onto a sketch pad by means of two "knobs"; one for horizontal movement and one for vertical movement. In the basic view the knobs are represented by scroll bars. EtchASketch makes use of the Scribble component for its sketch area.

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

!UI.Examples.EtchASketch categoriesForClass!MVP-Presenters!Samples! !

!UI.Examples.EtchASketch methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	upDownKnob := self add: NumberPresenter new name: 'upDownKnob'.
	leftRightKnob := self add: NumberPresenter new name: 'leftRightKnob'.
	sketchPad := self add: Smalltalk.Scribble new name: 'sketchPad'!

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
	newLocation := (leftRightKnob value @ upDownKnob value * scale) truncated.

	"Create an InkStroke representing this movement from the last known location.
	Add this to the model."
	inkStroke := Smalltalk.InkStroke new
				addPoint: lastLocation;
				addPoint: newLocation;
				yourself.
	self model add: inkStroke.

	"Remember the current location as the last"
	lastLocation := newLocation! !

!UI.Examples.EtchASketch categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
initialize!initializing!private! !
model:!accessing!public! !
onKnobChanged!event handling!private! !
!

!UI.Examples.EtchASketch class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1140850688 131073 32 nil 6 #{Graphics.Color} #red nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850945 1 176 nil 128 nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[241 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 32 0 66 0 108 0 97 0 99 0 107 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 176 114 #white nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[20 0 0 0 0 0 0 0 74 1 0 0 25 0 0 0] 193 208 nil 176 418 #text: 50 1 8 'Etch-a-Sketch(tm)' 176 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 18 #{UI.Slider} 50 18 nil 32 50 2 8 1140916224 1 640 1094 2 #{UI.ValueHolder} nil false 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 770 #hash 8 #() nil 114 #default nil 5 nil nil nil 640 nil nil 338 nil nil 3 nil nil 370 50 4 418 #createWindow: 50 1 466 498 8 #[20 0 0 0 205 0 0 0 74 1 0 0 230 0 0 0] 193 672 8 '' 640 418 #ticks: 50 1 8 #(0 100) 640 418 #pageSize: 8 #(0) 640 418 #range: 50 1 774 #{Core.Interval} 1 201 3 640 3 8 #() 610 193 193 nil 27 18 #{UI.Slider} 50 18 nil 32 50 2 8 1140916226 1 1184 706 nil false 752 nil 848 nil 5 nil nil nil 1184 nil nil 338 nil nil 3 nil nil 370 50 4 418 #createWindow: 50 1 466 498 8 #[49 1 0 0 25 0 0 0 74 1 0 0 205 0 0 0] 193 1216 8 '' 1184 418 #ticks: 50 1 8 #(0 100) 1184 418 #pageSize: 8 #(0) 1184 418 #range: 50 1 1122 1 201 3 1184 3 8 #() 610 193 193 nil 27 nil 18 #{Smalltalk.ScribbleView} 50 12 nil 32 50 2 8 1140850688 1 1568 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 114 #face3d nil 5 nil nil nil 1568 370 50 1 418 #createWindow: 50 1 466 498 8 #[20 0 0 0 25 0 0 0 49 1 0 0 205 0 0 0] 193 1600 8 '' 1568 3 8 #() 610 193 193 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 6 640 8 'leftRightKnob' 1568 8 'sketchPad' 1184 8 'upDownKnob' 518 #{Graphics.Rectangle} 610 41 1 610 41 41 370 50 1 418 #createWindow: 50 1 466 498 8 #[255 14 0 0 10 0 0 0 93 16 0 0 4 1 0 0] 193 80 8 '' 32 3 50 4 640 1184 1568 176 610 193 193 nil 27)!

sampleDescription
	"Private - Answer the description of the receiver to be used in the samples folder."

	^'Etch-a-Sketch'! !

!UI.Examples.EtchASketch class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
initialize!class initialization!private! !
resource_Default_view!public!resources-views! !
sampleDescription!constants!development!private! !
!

