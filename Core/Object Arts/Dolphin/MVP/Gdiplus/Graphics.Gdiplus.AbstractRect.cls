"Filed out from Dolphin Smalltalk"!

External.RECT
	subclass: #'Graphics.Gdiplus.AbstractRect'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.AbstractRect guid: (Core.GUID fromString: '{bca1fb68-f510-4822-a575-403073367635}')!
Graphics.Gdiplus.AbstractRect isNonInstantiable: true!
Graphics.Gdiplus.AbstractRect comment: ''!
!Graphics.Gdiplus.AbstractRect methodsFor!

asRectangle
	^self x @ self y extent: self width @ self height!

bottom
	^self y + self height!

bottom: aNumber
	self height: aNumber - self y!

height: aFloat
	self subclassResponsibility!

left
	^self x!

left: aNumber
	self width: self width + (self x - aNumber).
	self x: aNumber!

right
	^self x + self width!

right: aNumber
	self width: aNumber - self x!

top
	^self y!

top: aNumber
	self height: self height + (self y - aNumber).
	self y: aNumber!

width: aFloat
	self subclassResponsibility!

x
	self subclassResponsibility!

x: aFloat
	self subclassResponsibility!

y
	self subclassResponsibility!

y: aFloat
	self subclassResponsibility! !
!Graphics.Gdiplus.AbstractRect categoriesForMethods!
asRectangle!converting!public! !
bottom!accessing!public! !
bottom:!accessing!public! !
height:!accessing!public! !
left!accessing!public! !
left:!accessing!public! !
right!accessing!public! !
right:!accessing!public! !
top!accessing!public! !
top:!accessing!public! !
width:!accessing!public! !
x!accessing!public! !
x:!accessing!public! !
y!accessing!public! !
y:!accessing!public! !
!

!Graphics.Gdiplus.AbstractRect class methodsFor!

getFieldNames
	^#(#x #y #width #height)!

left: left top: top right: right bottom: bottom
	"Answer a new instance of the receiver with the specified position corner positions."

	^self
		left: left
		top: top
		width: right - left
		height: bottom - top!

marshal: aRect
	self == aRect class ifTrue: [^aRect].
	^self
		left: aRect left
		top: aRect top
		width: aRect width
		height: aRect height!

newBuffer
	^self basicNew bytes: (ByteArray newFixed: self byteSize)! !
!Graphics.Gdiplus.AbstractRect class categoriesForMethods!
getFieldNames!**compiled accessors**!constants!private! !
left:top:right:bottom:!instance creation!public! !
marshal:!instance creation!public! !
newBuffer!instance creation!public! !
!

