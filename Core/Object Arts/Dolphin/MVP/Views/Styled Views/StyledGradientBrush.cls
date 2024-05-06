"Filed out from Dolphin Smalltalk"!

Object subclass: #StyledGradientBrush
	instanceVariableNames: 'startColor endColor startPoint endPoint'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StyledGradientBrush guid: (GUID fromString: '{4a31f78c-2126-4b71-bf0b-064199a1f828}')!

StyledGradientBrush comment: 'A StyledBrush holds persistent details for a GdiplusLinearGradientBrush.'!

!StyledGradientBrush categoriesForClass!Kernel-Objects! !

!StyledGradientBrush methodsFor!

asBackgroundGdiplusBrushFor: aView 
	"Answers a GdiplushLinearGradientBrush suitable for painting the receiver inside aView"

	| clientRect colorRect p1 mid p2 c1 c2 brush |
	clientRect := aView clientRectangle.
	colorRect := clientRect expandBy: 1 asPoint.
	p1 := self startPoint * colorRect extent + colorRect position.
	mid := self endPoint * colorRect extent + colorRect position.
	p2 := p1 + ((mid - p1) * 2).
	c1 := self startColorARGB.
	c2 := self endColorARGB.
	brush := GdiplusLinearGradientBrush 
				point1: p1
				point2: p2
				color1: c1
				color2: c2.
	brush blendFactors: #(0.0 0.2 0.4 0.6 0.8 1.0 1.0 0.8 0.6 0.4 0.2 0.0)
		positions: #(0 0.1 0.2 0.3 0.4 0.5 0.5 0.6 0.7 0.8 0.9 1.0).
	^brush!

endColor
	^endColor!

endColor: aColorOrNil 
	endColor := aColorOrNil!

endColorARGB
	^(self endColor ifNotNil: [:c | c] ifNil: [Color none])!

endPoint
	^endPoint!

endPoint: aPoint 
	endPoint := aPoint!

isPartlyTransparent
	^self startColorARGB alpha < 255 or: [self endColorARGB alpha < 255]!

printOn: aStream 
	"Render the receiver to aStream as a developer would wish to see it"

	aStream
		nextPut: $(;
		display: self class.
	aStream nextPutAll: ' from: '.
	self startColor printOn: aStream.
	aStream nextPutAll: ' at: '.
	self startPoint displayOn: aStream.
	aStream nextPutAll: ' to: '.
	self endColor printOn: aStream.
	aStream nextPutAll: ' at: '.
	self endPoint printOn: aStream.
	aStream nextPut: $)!

startColor
	^startColor!

startColor: aColorOrNil 
	startColor := aColorOrNil!

startColorARGB
	^(self startColor ifNotNil: [:c | c] ifNil: [Color none])!

startPoint
	^startPoint!

startPoint: aPoint 
	startPoint := aPoint! !

!StyledGradientBrush categoriesForMethods!
asBackgroundGdiplusBrushFor:!converting!public! !
endColor!accessing!public! !
endColor:!accessing!public! !
endColorARGB!converting!public! !
endPoint!accessing!public! !
endPoint:!accessing!public! !
isPartlyTransparent!public!testing! !
printOn:!printing!public! !
startColor!accessing!public! !
startColor:!accessing!public! !
startColorARGB!converting!public! !
startPoint!accessing!public! !
startPoint:!accessing!public! !
!

!StyledGradientBrush class methodsFor!

black
	^self color: Color black!

color: aColor 
	^self 
		from: aColor
		at: 0.5 @ 0
		to: aColor
		at: 0.5 @ 1!

face3dLeftToRightFade
	^self 
		from: Color face3d
		at: 0 @ 0.5
		to: nil
		at: 1 @ 0.5!

face3dTopLeftToBottomRightFade
	^self 
		from: Color face3d
		at: 0 @ 0
		to: nil
		at: 1 @ 1!

face3dTopToBottomFade
	^self 
		from: Color face3d
		at: 0.5 @ 0
		to: nil
		at: 0.5 @ 1!

from: aColor1 at: aPoint1 to: aColor2 at: aPoint2 
	^(super new)
		startColor: aColor1;
		startPoint: aPoint1;
		endColor: aColor2;
		endPoint: aPoint2;
		yourself!

icon
	^Brush icon!

new
	^self color: Color black!

white
	^self color: Color white! !

!StyledGradientBrush class categoriesForMethods!
black!instance creation!public! !
color:!instance creation!public! !
face3dLeftToRightFade!instance creation!public! !
face3dTopLeftToBottomRightFade!instance creation!public! !
face3dTopToBottomFade!instance creation!public! !
from:at:to:at:!instance creation!public! !
icon!constants!development!public! !
new!instance creation!public! !
white!instance creation!public! !
!

