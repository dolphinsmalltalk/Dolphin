"Filed out from Dolphin Smalltalk"!

UI.DoubleBufferedView subclass: #'UI.Examples.BouncingBallView'
	instanceVariableNames: 'balls stepProcess'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.BouncingBallView guid: (Core.GUID fromString: '{247666e7-6b23-4e88-86d1-76d228924535}')!
UI.Examples.BouncingBallView comment: ''!
!UI.Examples.BouncingBallView methodsFor!

ballExtent
	^48 @ 48!

balls
	^self model!

defaultExtent
	^640 @ 480!

frameRate
	^25!

initialize
	| rnd icons |
	rnd := Random new.
	icons := {Ball redIcon. Ball greenIcon. Ball blueIcon. Ball yellowIcon}.
	super initialize.
	self backcolor: Color wheat.
	self numberOfBalls timesRepeat: 
			[| ball |
			ball := Ball new
						position: 100 @ 100;
						velocity: (rnd next * 20) @ (rnd next * 20);
						icon: (icons at: (rnd next * icons size) truncated + 1);
						yourself.
			self balls add: ball].
	stepProcess := [
			[Processor sleep: 1000 // self frameRate.
			self step] repeat] fork!

numberOfBalls 
	^20!

onDestroyed
	self stepProcess terminate.
	^super onDestroyed!

render
	"Private - Render the background image"

	| canvas |
	canvas := self canvas.
	canvas erase.
	"canvas backcolor: Color yellow; erase."

	self balls do: [:each | each drawOn: canvas ].
	canvas free. "useful to avoid build up of finalizable garbage"
	super render
!

step
	| width height |
	width := self clientWidth.
	height := self clientHeight.
	self balls do: 
			[:each |
			| p v w h ext |
			v := each velocity.
			p := each position + v.
			ext := each icon extent.
			w := ext x / 2.
			h := ext y / 2.

			"Hit testing"
			p x < w
				ifTrue: 
					[p x: w.
					v x: v x negated].
			p y < h
				ifTrue: 
					[p y: h.
					v y: v y negated].
			p x > (width - w)
				ifTrue: 
					[p x: width - w.
					v x: v x negated].
			p y > (height - h)
				ifTrue: 
					[p y: height - h.
					v y: v y negated].
			each position: p.
			each velocity: v.
			self invalidate]!

stepProcess
	^stepProcess! !
!UI.Examples.BouncingBallView categoriesForMethods!
ballExtent!constants!private! !
balls!accessing!private! !
defaultExtent!constants!private! !
frameRate!constants!public! !
initialize!initializing!private! !
numberOfBalls!constants!public! !
onDestroyed!event handling!private! !
render!operations!private! !
step!operations!public! !
stepProcess!accessing!private! !
!

!UI.Examples.BouncingBallView class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^OrderedCollection new!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Bouncing Balls'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon text: $\x1F3B1 fontName: 'Segoe UI Emoji')!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10611!

show
	"Answer and show an instance of the receiver"

	^super show topShell text: self displayString; yourself! !
!UI.Examples.BouncingBallView class categoriesForMethods!
defaultModel!models!public! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!development!initializing!private! !
show!operations!public! !
!

