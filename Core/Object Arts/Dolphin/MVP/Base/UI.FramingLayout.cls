"Filed out from Dolphin Smalltalk 7"!

UI.LayoutManager subclass: #'UI.FramingLayout'
	instanceVariableNames: 'framings'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.FramingLayout guid: (Core.GUID fromString: '{87b4c649-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.FramingLayout comment: 'FramingLayout implements a general purpose <layoutManager> to layout <view> objects within a <compositeView>. This is the most complex of the layout managers provided with the base Dolphin image but also the most flexible. Each of the managed views is given a series of constraints which indicate how it should be laid out within the parent. These constraints are instances of <FramingConstraints> and are specified by setting the #arrangement aspects of the various views. See the class comment for FramingConstraints for more details.

Some examples of the use of FramingLayout managers can be seen in the default views for ChoicePrompter and for AXTypeLibraryPrompter. Try evaluating the following and resizing the dialogs to see the effect.

ChoicePrompter choices: Object subclasses.
AXTypeLibraryPrompter showModal.

Instance Variables:
	framings	<LookupTable> mapping the managed views to their FramingConstraints
'!
!UI.FramingLayout categoriesForClass!MVP-Layout Managers-General! !
!UI.FramingLayout methodsFor!

arrangementOf: aView 
	"Answer the current framing constraints for aView. This will lazily
	generate one if none has currently been set."

	^framings at: aView ifAbsentPutClean: [self newConstraintFor: aView]!

arrangementOf: aView put: aFramingConstraints
	"Set the arrangement parameter of the <View>, aView< in the receiver to be the
	<FramingConstraints> argument."

	| existing |
	existing := framings lookup: aView.
	framings at: aView put: aFramingConstraints.
	existing notNil ifTrue: [aFramingConstraints offsets = existing offsets ifFalse: [^self]].
	self resize: aView to: aView rectangle!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	framings := LookupTable new!

layoutContainer: aCompositeView context: aLayoutContext 
	"Private - Update the <LayoutContext> argument with rectangles for the sub-views of its the
	specified container view, laying out those sub-views according to the rules and
	configuration of the particular layout manager."

	| containerRect |
	containerRect := (aLayoutContext clientRectangleOf: aCompositeView) 
				insetBy: (aCompositeView actualInsets: aLayoutContext).
	aCompositeView managedSubViewsDo: 
			[:each | 
			aLayoutContext setView: each
				rectangle: ((self arrangementOf: each) 
						rectangleFor: each
						within: containerRect
						context: aLayoutContext)]!

newConstraintFor: aView
	| framing context aRectangle |
	framing := FramingConstraints new.
	context := LayoutContext forContainer: aView parentView.
	aRectangle := context rectangleOf: aView.
	framing
		updateFor: aView
		rectangle: aRectangle
		layoutContext: context.
	^framing!

removeSubView: aView
	"Remove view from the collection of views which have been explicitly
	arranged by the receiver.
	Answer view."

	framings removeKey: aView ifAbsent: [].
	^super removeSubView: aView!

reposition: aView to: aPoint 
	"Private - Set the new position of the <View>, aView, and update our <FramingConstraints> object
	for it to reflect this new original rectangle."

	aView parentView deferLayout: 
			[:context | 
			| rect |
			rect := aPoint extent: (context extentOf: aView).
			(self arrangementOf: aView) 
				updateFor: aView
				rectangle: rect
				layoutContext: context.
			context setView: aView rectangle: rect]!

resize: aView to: aRectangle 
	"Set the new size and position of the <View>, aView, and update our
	<FramingConstraints> object for it to reflect this new rectangle."

	aView parentView deferLayout: 
			[:context | 
			(self arrangementOf: aView) 
				updateFor: aView
				rectangle: aRectangle
				layoutContext: context.
			context setView: aView rectangle: aRectangle]!

resolutionScaledBy: aPoint 
	"Private - The receiver is being loaded and it has been determined that the pixel resolution
	has changed since the point at which the view was saved. Scale any internal pixels by <Point>
	scale."

	framings do: [:each | each resolutionScaledBy: aPoint]! !
!UI.FramingLayout categoriesFor: #arrangementOf:!accessing!public! !
!UI.FramingLayout categoriesFor: #arrangementOf:put:!accessing!public! !
!UI.FramingLayout categoriesFor: #initialize!initializing!private! !
!UI.FramingLayout categoriesFor: #layoutContainer:context:!geometry!private! !
!UI.FramingLayout categoriesFor: #newConstraintFor:!helpers!private! !
!UI.FramingLayout categoriesFor: #removeSubView:!public!removing! !
!UI.FramingLayout categoriesFor: #reposition:to:!geometry!private! !
!UI.FramingLayout categoriesFor: #resize:to:!geometry!public! !
!UI.FramingLayout categoriesFor: #resolutionScaledBy:!geometry!private! !

