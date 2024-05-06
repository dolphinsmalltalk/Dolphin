"Filed out from Dolphin Smalltalk"!

Object subclass: #FramingContext
	instanceVariableNames: 'layoutContext view rectangle parentRect'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FramingContext guid: (GUID fromString: '{ccf52b24-63ff-41c2-ab62-fe905a47ba3f}')!

FramingContext comment: ''!

!FramingContext categoriesForClass!Kernel-Objects! !

!FramingContext methodsFor!

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
		ifNil: [Rectangle new]
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

!FramingContext categoriesForMethods!
bottom!accessing!public! !
height!accessing!public! !
left!accessing!public! !
parentBottom!accessing!public! !
parentExtent!accessing!public! !
parentHeight!accessing!public! !
parentLeft!accessing!public! !
parentRectangle!accessing!public! !
parentRight!accessing!public! !
parentTop!accessing!public! !
parentView!accessing!public! !
parentWidth!accessing!public! !
previousBottom!accessing!public! !
previousLeft!accessing!public! !
previousRectangle!accessing!public! !
previousRight!accessing!public! !
previousSibling!accessing!public! !
previousTop!accessing!public! !
rectangle!accessing!public! !
rectangle:!accessing!public! !
right!accessing!public! !
setLayoutContext:view:parentRectangle:!initializing!private! !
top!accessing!public! !
width!accessing!public! !
!

!FramingContext class methodsFor!

layoutContext: aLayoutContext view: aView parentRectangle: aRectangle 
	^(super new)
		setLayoutContext: aLayoutContext
			view: aView
			parentRectangle: aRectangle;
		yourself! !

!FramingContext class categoriesForMethods!
layoutContext:view:parentRectangle:!instance creation!public! !
!

