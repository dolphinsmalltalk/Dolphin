"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.FramingContext'
	instanceVariableNames: 'layoutContext view rectangle parentRect'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.FramingContext guid: (Core.GUID fromString: '{ccf52b24-63ff-41c2-ab62-fe905a47ba3f}')!
UI.FramingContext comment: ''!
!UI.FramingContext categoriesForClass!Kernel-Objects! !
!UI.FramingContext methodsFor!

bottom
	^rectangle bottom!

height
	^rectangle height!

left
	^rectangle left!

parentBottom
	^parentRect bottom!

parentExtent
	^parentRect extent!

parentHeight
	^parentRect height!

parentLeft
	^parentRect left!

parentRectangle
	^parentRect!

parentRight
	^parentRect right!

parentTop
	^parentRect top!

parentView
	^view parentView!

parentWidth
	^parentRect width!

previousBottom
	^self previousRectangle bottom!

previousLeft
	^self previousRectangle left!

previousRectangle
	^self previousSibling
		ifNil: [Rectangle.Empty]
		ifNotNil: [:sibling | layoutContext rectangleOf: sibling]!

previousRight
	^self previousRectangle right!

previousSibling
	^view previousSiblingView!

previousTop
	^self previousRectangle top!

rectangle
	^rectangle!

rectangle: anObject
	rectangle := anObject!

right
	^rectangle right!

setLayoutContext: aLayoutContext view: aView parentRectangle: aRectangle 
	layoutContext := aLayoutContext.
	view := aView.
	parentRect := aRectangle.
	rectangle := (aLayoutContext rectangleOf: aView) copy!

top
	^rectangle top!

width
	^rectangle width! !
!UI.FramingContext categoriesFor: #bottom!accessing!public! !
!UI.FramingContext categoriesFor: #height!accessing!public! !
!UI.FramingContext categoriesFor: #left!accessing!public! !
!UI.FramingContext categoriesFor: #parentBottom!accessing!public! !
!UI.FramingContext categoriesFor: #parentExtent!accessing!public! !
!UI.FramingContext categoriesFor: #parentHeight!accessing!public! !
!UI.FramingContext categoriesFor: #parentLeft!accessing!public! !
!UI.FramingContext categoriesFor: #parentRectangle!accessing!public! !
!UI.FramingContext categoriesFor: #parentRight!accessing!public! !
!UI.FramingContext categoriesFor: #parentTop!accessing!public! !
!UI.FramingContext categoriesFor: #parentView!accessing!public! !
!UI.FramingContext categoriesFor: #parentWidth!accessing!public! !
!UI.FramingContext categoriesFor: #previousBottom!accessing!public! !
!UI.FramingContext categoriesFor: #previousLeft!accessing!public! !
!UI.FramingContext categoriesFor: #previousRectangle!accessing!public! !
!UI.FramingContext categoriesFor: #previousRight!accessing!public! !
!UI.FramingContext categoriesFor: #previousSibling!accessing!public! !
!UI.FramingContext categoriesFor: #previousTop!accessing!public! !
!UI.FramingContext categoriesFor: #rectangle!accessing!public! !
!UI.FramingContext categoriesFor: #rectangle:!accessing!public! !
!UI.FramingContext categoriesFor: #right!accessing!public! !
!UI.FramingContext categoriesFor: #setLayoutContext:view:parentRectangle:!initializing!private! !
!UI.FramingContext categoriesFor: #top!accessing!public! !
!UI.FramingContext categoriesFor: #width!accessing!public! !

!UI.FramingContext class methodsFor!

layoutContext: aLayoutContext view: aView parentRectangle: aRectangle 
	^(super new)
		setLayoutContext: aLayoutContext
			view: aView
			parentRectangle: aRectangle;
		yourself! !
!UI.FramingContext class categoriesFor: #layoutContext:view:parentRectangle:!instance creation!public! !

