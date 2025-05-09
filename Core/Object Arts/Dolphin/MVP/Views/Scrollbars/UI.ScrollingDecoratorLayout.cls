﻿"Filed out from Dolphin Smalltalk"!

UI.LayoutManager
	subclass: #'UI.ScrollingDecoratorLayout'
	instanceVariableNames: 'stretchToFit'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ScrollingDecoratorLayout guid: (Core.GUID fromString: '{87b4c64c-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ScrollingDecoratorLayout comment: 'ScrollingDecoratorLayout implements a specialised <layoutManager> to layout a single <view> object contained within a <scrollingDecoratorView>. The ScrollingDecoratorLayout does not attempt to resize the managed view (although see the #shouldStretchToFit aspect) but, instead, it repositions it according to scroll information that it receives from the view''s parent. Scrollbars will become available in the parent <scrollingDecoratorView> when its extent goes below the preferred extent recommended by the ScrollingDecoratorLayout.




'!

!UI.ScrollingDecoratorLayout categoriesForClass!MVP-Layout Managers-Specialized! !

!UI.ScrollingDecoratorLayout methodsFor!

initialize
	stretchToFit := true!

layoutContainer: aScrollingDecorator context: aLayoutContext 
	"Private - Update the <LayoutContext> argument with rectangles for the sub-views of the
	specified container view, laying out those sub-views according to the rules and
	configuration of the particular layout manager."

	| newScroll |
	(self scrolledChildOf: aScrollingDecorator) 
		ifNil: [newScroll := 0 @ 0]
		ifNotNil: 
			[:scrolled | 
			| clientExtent desiredExtent scrollOffset viewExtent |
			clientExtent := aLayoutContext clientExtentOf: aScrollingDecorator.
			desiredExtent := scrolled layoutExtent: aLayoutContext.
			viewExtent := self shouldStretchToFit 
						ifTrue: [clientExtent max: desiredExtent]
						ifFalse: [desiredExtent].
			scrollOffset := aScrollingDecorator scrollOffset.
			newScroll := ((scrollOffset x min: viewExtent x - clientExtent x) max: 0) 
						@ ((scrollOffset y min: viewExtent y - clientExtent y) max: 0).
			aLayoutContext setView: scrolled rectangle: (scrollOffset negated extent: viewExtent)].
	aScrollingDecorator scrollOffset: newScroll context: aLayoutContext.
	aScrollingDecorator updateScrollBars: aLayoutContext!

positionScrolledViewOf: aScrollingDecorator context: aLayoutContext 
	"Private - Reposition the scrolled sub-view."

	(self scrolledChildOf: aScrollingDecorator) 
		ifNotNil: [:scrolled | aLayoutContext setView: scrolled origin: aScrollingDecorator scrollOffset negated].!

preferredLayoutExtentOf: aScrollingDecorator context: aLayoutContext 
	"Answer a <Point> specifying the preferred extent for the <CompositeView> argument when
	laying out in the context of the specified <LayoutContext>."

	"Implementation Note: A single managed sub-view is assumed."

	^(self scrolledChildOf: aScrollingDecorator) 
		ifNil: [0 @ 0]
		ifNotNil: [:scrolled | scrolled layoutExtent: aLayoutContext]!

scrolledChildOf: aScrollingDecorator 
	| subviews |
	subviews := aScrollingDecorator managedSubViews.
	^subviews isEmpty ifFalse: [subviews first]!

shouldStretchToFit
	"Answer whether subviews that are smaller than the available client area of the
	<ScrollingDecorator> managed by the receiver should be expanded to fill that area. Note that
	when this option is enabled (it is the default) the subviews may have an extent greater than
	their preferred extent, but they are never shrunk below that preferred extent. Scrollbars
	will appear only if the available client area shrinks below that required to display the
	subviews at their preferred extents."

	^stretchToFit!

shouldStretchToFit: aBoolean 
	stretchToFit := aBoolean! !

!UI.ScrollingDecoratorLayout categoriesForMethods!
initialize!initializing!public! !
layoutContainer:context:!geometry!private! !
positionScrolledViewOf:context:!helpers!private! !
preferredLayoutExtentOf:context:!public! !
scrolledChildOf:!helpers!private! !
shouldStretchToFit!accessing!public! !
shouldStretchToFit:!accessing!public! !
!

!UI.ScrollingDecoratorLayout class methodsFor!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier schema.
		Version 0: No vars
		Version1: stretchToFit (default = true)
		"

	anSTBClassFormat version == 0 ifTrue: [^[:data | { true } becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	^1! !

!UI.ScrollingDecoratorLayout class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
stbVersion!constants!public! !
!

