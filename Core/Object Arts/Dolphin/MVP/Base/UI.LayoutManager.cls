"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.LayoutManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.LayoutManager guid: (Core.GUID fromString: '{87b4c497-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.LayoutManager isNonInstantiable: true!
UI.LayoutManager comment: 'LayoutManager is the abstract superclass for classes that wish to implement the <layoutManager> protocol for the automatic arrangement of views within a parent <compositeView>. Dolphin supplies a base set of general purpose concrete layout managers which are general purpose enough to cover most requirements. 

To define a new layout manager you must implement the <layoutManager> protocol methods in [subclass responsibility], and you will probably want to override #preferredLayoutExtentOf:context: as well.'!
!UI.LayoutManager categoriesForClass!MVP-Layout Managers-Abstract! !
!UI.LayoutManager methodsFor!

arrangementOf: aView
	"Answer the arrangement parameter of aView in the receiver. 
	If an arrangement parameter has not explicitly been set 
	then answer nil. Overidden by subclasses that take notice of
	arrangement parameters"

	^nil

!

arrangementOf: aView put: anObject
	"Set the arrangement parameter of aView in the receiver to be anObject.
	The arrangement parameter has different meanings depending on the 
	class of the receiver. Overidden by subclasses that take notice of
	arrangement parameters"


!

layoutContainer: aContainerView
	"Lay out the managed sub-views of the <ContainerView> argument."

	| context |
	context := LayoutContext forContainer: aContainerView.
	[self layoutContainer: aContainerView context: context] ensure: [context apply]!

layoutContainer: aCompositeView context: aLayoutContext 
	"Private - Update the <LayoutContext> argument with rectangles for the sub-views of its the
	specified container view, laying out those sub-views according to the rules and
	configuration of the particular layout manager."

	^self subclassResponsibility!

preferredLayoutExtentOf: aCompositeView context: aLayoutContext 
	"Answer a <Point> specifying the preferred extent for the <CompositeView> argument when
	laying out in the context of the specified <LayoutContext>."

	^aLayoutContext extentOf: aCompositeView!

removeSubView: aView
	"Remove aView from the collection of views which have been explicitly
	arranged by the receiver.
	Answer aView."

	^aView
!

reposition: aView to: aPoint 
	"Private - Move the <view>, aView, to the specified position within the layout of the
	container view managed by the receiver. In some circumstances the movement may not be
	allowed."

	self layoutContainer: aView parentView!

resize: aView to: aRectangle 
	"Resize the <view>, aView, to occupy the specified <Rectangle> in the container
	view who's layout is managed by the receiver. In some circumstances the resize may not be
	allowed."

	self layoutContainer: aView parentView!

resolutionScaledBy: scale
	"Private - The receiver is being loaded and it has been determined that the pixel resolution
	has changed since the point at which the view was saved. Scale any internal pixels by <Point>
	scale."


!

visibleSubViewsOf: aCompositeView context: aLayoutContext 
	^aCompositeView managedSubViews select: [:each | aLayoutContext isViewVisible: each]! !
!UI.LayoutManager categoriesForMethods!
arrangementOf:!accessing!public! !
arrangementOf:put:!accessing!public! !
layoutContainer:!geometry!public! !
layoutContainer:context:!geometry!private! !
preferredLayoutExtentOf:context:!enquiries!public! !
removeSubView:!public!removing! !
reposition:to:!geometry!private! !
resize:to:!geometry!public! !
resolutionScaledBy:!geometry!private! !
visibleSubViewsOf:context:!helpers!private! !
!

UI.LayoutManager methodProtocol: #layoutManager attributes: #(#readOnly) selectors: #(#arrangementOf: #arrangementOf:put: #layoutContainer: #preferredLayoutExtentOf:context: #removeSubView:)!

!UI.LayoutManager class methodsFor!

new
	"Answer an instance of the receiver. Instances require initialization"

	^super new initialize! !
!UI.LayoutManager class categoriesForMethods!
new!instance creation!public! !
!

