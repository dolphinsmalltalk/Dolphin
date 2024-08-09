"Filed out from Dolphin Smalltalk"!

AbstractPen subclass: #Pen
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Pen guid: (GUID fromString: '{87b4c637-026e-11d3-9fd7-00a0cc3e4a32}')!

Pen comment: 'Pen is a <GraphicsTool> that wraps a Windows GDI Pen object. Pens are selected into <Canvas>s to draw lines in various styles, widths, and colours.

Instance Variables:
	logPen	<LOGPEN>. Logical description of the pen.

'!

!Pen categoriesForClass!Graphics-Tools! !

!Pen methodsFor!

color: aColor
	self color = aColor ifTrue: [^self].
	logPen lopnColor: aColor ?? Color.Black.
	self free!

createHandle
	"Private - Answer an <ExternalHandle> to a new pen as described by the receiver's
	<LOGPEN> structure."

	^GDILibrary default createPenIndirect: logPen!

logPen: aLOGPEN 
	"Private - Set the receiver's logical attributes."

	logPen := aLOGPEN.
	self free!

printOn: aPuttableStream
	"Append, to the <puttableStream> argument a string whose characters are a the same as those which would result from sending a #printString message to the receiver."

	| styleName width color |
	width := self width.
	styleName := self styleName.
	color := self color.
	(width == 1 and: [color = Color.Black])
		ifTrue: 
			[aPuttableStream
				print: self class;
				space;
				nextPutAll: self styleName.
			^self].
	aPuttableStream
		nextPut: $(;
		print: self class.
	styleName == #solid
		ifFalse: 
			[aPuttableStream
				nextPutAll: ' styleName: ';
				print: styleName].
	width = 1
		ifFalse: 
			[aPuttableStream
				nextPutAll: ' width: ';
				print: width].
	color = Color.Black
		ifFalse: 
			[aPuttableStream
				nextPutAll: ' color: ';
				print: color].
	aPuttableStream nextPut: $)!

style: flags
	self style = flags ifTrue: [^self].
	logPen style: flags.
	self free!

styleName: aSymbol
	"Set the style of the receiver to that named. Note that dotted/dashed styles 
	are only supported if the pen is one pixel wide."

	self style: (self class styleNamed: aSymbol)!

width: anInteger 
	"Set the <integer> width (in pixels) of the line drawn by the receiver.
	Note that if the width is greater than 1, then the pen style is ignored
	and the pen will always be solid."

	self width = anInteger ifTrue: [^self].
	logPen width: anInteger.
	self free! !

!Pen categoriesForMethods!
color:!accessing!public! !
createHandle!private!realizing/unrealizing! !
logPen:!accessing!private! !
printOn:!development!printing!public! !
style:!accessing!private! !
styleName:!accessing!public! !
width:!accessing!public! !
!

!Pen class methodsFor!

blue
	"Answer a blue pen."

	^self color: Color blue!

color: aColor
	"Answer a new instance of the receiver for painting solid 1-pixel lines in the specified <Color>."

	^aColor pen!

dashDot
	^self style: PS_DASHDOT!

dashDotDot
	^self style: PS_DASHDOTDOT!

dashed
	^self style: PS_DASH!

dotted
	^self style: PS_DOT!

fromLogPen: aLOGPEN
	"Answer a new instance of the receiver containing the given logical pen."

	^self new
		logPen: aLOGPEN;
		yourself
!

green
	"Answer a green pen."

	^self color: Color green
!

insideFrame
	^self style: PS_INSIDEFRAME!

newColor: aColor 
	"Private - Answer a new instance of the receiver for painting 1-pixel wide lines in the specified solid colour."

	^self 
		style: PS_SOLID
		width: 0
		color: aColor!

none
	"Answer a null <Pen>"

	^self
		style: PS_NULL
		width: 0
		color: Color.None!

red
	"Answer a red pen."

	^self color: Color red
!

solid
	^self width: 1!

style: styleFlags
	"Answer a new black 1-pixel pen of the specified style."

	^self
		style: styleFlags
		width: 0
		color: Color.Black!

style: anInteger color: aColour
	"Answer a new 1-pixel wide pen with the specified style and colour attributes."

	^self
		style: anInteger
		width: 0
		color: aColour!

style: styleInteger width: widthInteger
	"Answer a new black pen with the the specified style and width."

	^self
		style: styleInteger
		width: widthInteger
		color: Color.Black!

style: styleInteger width: widthInteger color: aColour
	"Answer a new pen with the specified style, width and colour attributes."

	^self fromLogPen: (LOGPEN newBuffer
				lopnStyle: styleInteger;
				width: widthInteger;
				lopnColor: aColour;
				yourself)!

styleName: aString
	"Answer a new 1-pixedl black pen of the named style."

	^self
		styleName: aString
		width: 0
		color: Color black!

styleName: aSymbol color: aColor
	"Answer a new 1-pixel wide pen of the named style, and specified colour."

	^self
		styleName: aSymbol
		width: 0
		color: aColor!

styleName: aSymbol width: anInteger
	"Answer a new black pen with the of the named style and specified width."

	^self
		styleName: aSymbol
		width: anInteger
		color: Color.Black!

styleName: aSymbol width: anInteger color: aColour
	"Answer a new pen of the named style with the specified width and colour."

	^self fromLogPen: (LOGPEN newBuffer
				lopnStyle: (self styleNamed: aSymbol);
				width: anInteger;
				lopnColor: aColour;
				yourself)!

styleNamed: aString
	| style |
	style := (self styleNames indexOf: aString) - 1.
	style < 0 ifTrue: [self error: 'Unrecognised Pen style <1p>'  << aString].
	^style!

width: anInteger
	"Answer a new solid black pen of the specified width."

	^self
		style: PS_SOLID
		width: anInteger
		color: Color.Black!

width: anInteger color: aColor
	"Answer a new solid pen of the specified width and Color."

	^self
		style: PS_SOLID
		width: anInteger
		color: aColor!

withStyle: styleFlags width: anInteger color: aColor
	#deprecated.
	^self
		style: styleFlags
		width: anInteger
		color: aColor!

withStyleName: aString
	#deprecated.
	^self
		styleName: aString
		width: 0
		color: Color black! !

!Pen class categoriesForMethods!
blue!instance creation!public! !
color:!instance creation!public! !
dashDot!instance creation!public! !
dashDotDot!instance creation!public! !
dashed!instance creation!public! !
dotted!instance creation!public! !
fromLogPen:!instance creation!public! !
green!instance creation!public! !
insideFrame!instance creation!public! !
newColor:!instance creation!private! !
none!instance creation!public! !
red!instance creation!public! !
solid!instance creation!public! !
style:!instance creation!public! !
style:color:!instance creation!public! !
style:width:!instance creation!public! !
style:width:color:!instance creation!public! !
styleName:!public! !
styleName:color:!instance creation!public! !
styleName:width:!instance creation!public! !
styleName:width:color:!instance creation!public! !
styleNamed:!public! !
width:!instance creation!public! !
width:color:!instance creation!public! !
withStyle:width:color:!instance creation!public! !
withStyleName:!public! !
!

