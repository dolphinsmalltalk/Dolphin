"Filed out from Dolphin Smalltalk"!

View subclass: #ScribbleView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScribbleView guid: (GUID fromString: '{87b4c714-026e-11d3-9fd7-00a0cc3e4a32}')!

ScribbleView comment: 'ScribbleView is a sample <view> capable of displaying the contents of a <listModel> populated with <InkStroke>a. ScribbleView will normally be used in conjunction with a <Scribble> presenter. 

'!

!ScribbleView categoriesForClass!MVP-Views!Samples! !

!ScribbleView methodsFor!

connectModel
	"Connect the receiver to its model, wiring events, etc."

	self model 
		when: #listChanged send: #refreshContents to: self;
		when: #item:addedAtIndex: send: #onItem:addedAtIndex: to: self;
		when: #item:removedAtIndex: send: #refreshContents to: self;
		when: #item:updatedAtIndex: send: #refreshContents to: self.!

onItem: anInkStroke addedAtIndex: anIntegerIndex
	"Event received when anInkStroke has been added to the receiver's
	model at anIntegerIndex. In this case we just need to draw the stroke rather
	than the whole model"

	anInkStroke drawOn: self canvas.
	
!

onPaintRequired: aPaintEvent
	"Handler for paint event. Show the scribble"

	| canvas |
	canvas := aPaintEvent canvas.
	self model do: [:each | each drawOn: canvas ].	! !

!ScribbleView categoriesForMethods!
connectModel!models!public! !
onItem:addedAtIndex:!event handling!public! !
onPaintRequired:!event handling!public! !
!

!ScribbleView class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^ListModel new!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

stbConvertFromVersion1: anArray
	"Private - Perform an STB conversion from a version 1 (or earlier) <View> to version 2."

	"Originally ScribbleView had 3 instance variables, subsequently removed. Also the model wasn't necessarily initialized."

	(anArray at: 5) ifNil: [anArray at: 5 put: ListModel new].
	^anArray resize: 10! !

!ScribbleView class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
stbConvertFromVersion1:!binary filing!private! !
!

