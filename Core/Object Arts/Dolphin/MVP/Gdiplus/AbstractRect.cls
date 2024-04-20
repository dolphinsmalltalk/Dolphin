"Filed out from Dolphin Smalltalk"!

ExternalRectangle subclass: #AbstractRect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractRect guid: (GUID fromString: '{d973debe-0309-4211-9cf3-8220b884b4c3}')!

AbstractRect isAbstract: true!

AbstractRect comment: ''!

!AbstractRect categoriesForClass!Win32-Structs! !

!AbstractRect methodsFor!

asRectangle
	^self x @ self y extent: self width @ self height!

bottom
	^self y + self height!

bottom: aNumber
	self height: aNumber - self y!

height
	^self subclassResponsibility!

height: aNumber
	self subclassResponsibility!

left
	^self x!

left: aNumber
	"Sets the position of the receiver's left edge."

	"The corner is not expected to move, so the width must change."

	self width: self width + (self x - aNumber).
	self x: aNumber!

right
	^self x + self width!

right: aNumber
	self width: aNumber - self x!

scaleBy: aMagnitude
	"Scale the receiver in-place by the specified <Point> or <Number> multiplier."

	| p |
	p := self topLeft * aMagnitude.
	self
		x: p x;
		y: p y.
	p := self extent * aMagnitude.
	self
		width: p x;
		height: p y!

top
	^self y!

top: aNumber
	self height: self height + (self y - aNumber).
	self y: aNumber!

width
	^self subclassResponsibility!

width: aNumber
	self subclassResponsibility!

x
	^self subclassResponsibility!

x: aNumber
	self subclassResponsibility!

y
	^self subclassResponsibility!

y: aNumber
	self subclassResponsibility! !

!AbstractRect categoriesForMethods!
asRectangle!converting!public! !
bottom!accessing!public! !
bottom:!accessing!public! !
height!accessing!public! !
height:!accessing!public! !
left!accessing!public! !
left:!accessing!public! !
right!accessing!public! !
right:!accessing!public! !
scaleBy:!public!transforming! !
top!accessing!public! !
top:!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
x!accessing!public! !
x:!accessing!public! !
y!accessing!public! !
y:!accessing!public! !
!

!AbstractRect class methodsFor!

left: left top: top right: right bottom: bottom
	"Answer a new instance of the receiver with the specified position corner positions."

	^self
		left: left
		top: top
		width: right - left
		height: bottom - top!

marshal: aRectangle
	"Answer the argument marshalled as an instance of the receiver."

	self == aRectangle class ifTrue: [^aRectangle].
	^self
		left: aRectangle left
		top: aRectangle top
		width: aRectangle width
		height: aRectangle height!

newBuffer
	^self basicNew bytes: (ByteArray newFixed: self byteSize)! !

!AbstractRect class categoriesForMethods!
left:top:right:bottom:!instance creation!public! !
marshal:!instance creation!public! !
newBuffer!instance creation!public! !
!

