"Filed out from Dolphin Smalltalk"!

Object subclass: #InkStroke
	instanceVariableNames: 'data'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

InkStroke guid: (GUID fromString: '{87b4c493-026e-11d3-9fd7-00a0cc3e4a32}')!

InkStroke comment: 'InkStroke consists of an <OrderedCollection> of <Point>s that describe the movement of a pen (or mouse) drawing a single stroke of ink. A <Scribble> presenter operates on a <listModel> of InkStrokes that, when replayed, comprises the scribbled picture.

Instance Variables:
	data	<OrderedCollection> of <Points> describing the strokes track.

'!

!InkStroke categoriesForClass!Samples! !

!InkStroke methodsFor!

addPoint: aPoint
	"Adds aPoint to the collection of data points held by the receiver.
	Answers aPoint"

	^data add: aPoint!

drawOn: aCanvas 
	"Draw the receiver on aCanvas"

	aCanvas
		moveTo: data first;
		pen: (Pen 
					withStyle: Win32Constants.PS_SOLID
					width: self inkWidth
					color: Color black).
	data do: [:each | aCanvas lineTo: each]!

initialize
	"Private - Initialize the receiver"

	data := OrderedCollection new!

inkWidth
	^3!

length
	"Answer the length of the receiver"

	| last |
	last := self points first.
	^(self points inject: 0
		into: 
			[:sum :each | 
			| delta |
			delta := each - last.
			last := each.
			sum + delta r]) 
			rounded!

points
	"Answer the collection of <Points> associated with the receiver"

	^data!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream
		basicPrint: self;
		nextPut: $(; display: data size; nextPutAll: ' points)'! !

!InkStroke categoriesForMethods!
addPoint:!adding!public! !
drawOn:!drawing!public! !
initialize!initializing!private! !
inkWidth!public! !
length!accessing!public! !
points!accessing!public! !
printOn:!printing!public! !
!

!InkStroke class methodsFor!

new
	"Answer an initialized instance of the receiver"

	^super new initialize! !

!InkStroke class categoriesForMethods!
new!instance creation!public! !
!

