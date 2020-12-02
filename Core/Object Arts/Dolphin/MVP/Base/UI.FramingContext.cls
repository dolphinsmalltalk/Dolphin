"Filed out from Dolphin Smalltalk 7"!

Object subclass: #FramingContext
	instanceVariableNames: 'layoutContext view rectangle parentRect'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!FramingContext categoriesFor: #bottom!accessing!public! !
!FramingContext categoriesFor: #height!accessing!public! !
!FramingContext categoriesFor: #left!accessing!public! !
!FramingContext categoriesFor: #parentBottom!accessing!public! !
!FramingContext categoriesFor: #parentExtent!accessing!public! !
!FramingContext categoriesFor: #parentHeight!accessing!public! !
!FramingContext categoriesFor: #parentLeft!accessing!public! !
!FramingContext categoriesFor: #parentRectangle!accessing!public! !
!FramingContext categoriesFor: #parentRight!accessing!public! !
!FramingContext categoriesFor: #parentTop!accessing!public! !
!FramingContext categoriesFor: #parentView!accessing!public! !
!FramingContext categoriesFor: #parentWidth!accessing!public! !
!FramingContext categoriesFor: #previousBottom!accessing!public! !
!FramingContext categoriesFor: #previousLeft!accessing!public! !
!FramingContext categoriesFor: #previousRectangle!accessing!public! !
!FramingContext categoriesFor: #previousRight!accessing!public! !
!FramingContext categoriesFor: #previousSibling!accessing!public! !
!FramingContext categoriesFor: #previousTop!accessing!public! !
!FramingContext categoriesFor: #rectangle!accessing!public! !
!FramingContext categoriesFor: #rectangle:!accessing!public! !
!FramingContext categoriesFor: #right!accessing!public! !
!FramingContext categoriesFor: #setLayoutContext:view:parentRectangle:!initializing!private! !
!FramingContext categoriesFor: #top!accessing!public! !
!FramingContext categoriesFor: #width!accessing!public! !

!FramingContext class methodsFor!

layoutContext: aLayoutContext view: aView parentRectangle: aRectangle 
	^(super new)
		setLayoutContext: aLayoutContext
			view: aView
			parentRectangle: aRectangle;
		yourself! !
!FramingContext class categoriesFor: #layoutContext:view:parentRectangle:!instance creation!public! !

