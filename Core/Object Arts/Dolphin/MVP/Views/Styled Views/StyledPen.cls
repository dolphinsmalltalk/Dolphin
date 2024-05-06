"Filed out from Dolphin Smalltalk"!

Object subclass: #StyledPen
	instanceVariableNames: 'color width dashPattern'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!

StyledPen guid: (GUID fromString: '{981954b0-d34d-400f-8e8c-01faa46311ab}')!

StyledPen comment: 'A StyledPen holds persistent details for a GdiplusPen.'!

!StyledPen categoriesForClass!Kernel-Objects! !

!StyledPen methodsFor!

asGdiplusPen
	^(GdiplusPen color: self color width: self width)
		dashPattern: dashPattern;
		yourself!

color
	^color!

color: aColor 
	color := aColor isNil ifTrue: [Color none] ifFalse: [aColor]!

dashPattern
	^dashPattern!

dashPattern: anArrayOfNumbers 
	dashPattern := anArrayOfNumbers!

printOn: aStream 
	"Render the receiver to aStream as a developer would wish to see it"

	aStream
		nextPut: $(;
		display: self class;
		nextPutAll: ' color: '.
	self color printOn: aStream.
	aStream nextPutAll: ' width: '.
	self width displayOn: aStream.
	aStream nextPutAll: ' dashPattern: '.
	self dashPattern printOn: aStream.
	aStream nextPut: $)!

width
	^width!

width: anInteger 
	width := anInteger! !

!StyledPen categoriesForMethods!
asGdiplusPen!public! !
color!accessing!public! !
color:!accessing!public! !
dashPattern!public! !
dashPattern:!public! !
printOn:!public! !
width!accessing!public! !
width:!accessing!public! !
!

!StyledPen class methodsFor!

color: aColor width: anInteger dashPattern: anArray 
	^(super new)
		color: aColor;
		width: anInteger;
		dashPattern: anArray!

color: aColor width: anInteger style: aSymbol 
	^(super new)
		color: aColor;
		width: anInteger;
		dashPattern: (self styles at: aSymbol)!

dashDot
	^self 
		color: Color black
		width: 1
		style: #dashDot!

dashDotDot
	^self 
		color: Color black
		width: 1
		style: #dashDotDot!

dashed
	^self 
		color: Color black
		width: 1
		style: #dashed!

dotted
	^self color: Color black width: 1 style: #dotted!

icon
	^Pen icon!

new
	^self 
		color: Color black
		width: 1
		style: #solid!

solid
	^self color: Color black width: 1 style: #solid!

styles
	^##(IdentityDictionary new
		at: #solid put: #(1);
		at: #dashed put: #(4 4);
		at: #dotted put: #(2 2);
		at: #dashDot put: #(4 4 1 4);
		at: #dashDotDot put: #(4 4 1 2 1 2);
		yourself)! !

!StyledPen class categoriesForMethods!
color:width:dashPattern:!public! !
color:width:style:!public! !
dashDot!public! !
dashDotDot!public! !
dashed!public! !
dotted!public! !
icon!constants!development!public! !
new!public! !
solid!public! !
styles!private! !
!

