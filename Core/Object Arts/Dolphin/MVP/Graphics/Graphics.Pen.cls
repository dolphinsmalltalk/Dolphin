"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'Graphics.Pen'
	instanceVariableNames: 'logPen'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'LineJoinNames'
				-> #('LineJoinMiter' 'LineJoinBevel' 'LineJoinRound' 'LineJoinMiterClipped')
		}!
Graphics.Pen guid: (Core.GUID fromString: '{87b4c637-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.Pen comment: 'Pen is a <GraphicsTool> that wraps a Windows GDI Pen object. Pens are selected into <Canvas>s to draw lines in various styles, widths, and colours.

Instance Variables:
	logPen	<LOGPEN>. Logical description of the pen.

'!
!Graphics.Pen categoriesForClass!Graphics-Tools! !
!Graphics.Pen methodsFor!

color
	^logPen color!

color: aColor
	self color = aColor ifTrue: [^self].
	logPen color: aColor ?? Color.Black.
	self free!

createHandle
	"Private - Answer an <ExternalHandle> to a new pen as described by the receiver's
	<LOGPEN> structure."

	^Gdi32 createPenIndirect: logPen!

handle: anExternalHandle
	"Private - Set the handle for the receiver and query its logical info."

	super handle: anExternalHandle.
	logPen := LOGPEN newBuffer.
	self getData: logPen!

logPen: aLOGPEN 
	"Private - Set the receiver's logical attributes."

	logPen := aLOGPEN.
	self free!

style
	^logPen lopnStyle!

style: flags
	self style = flags ifTrue: [^self].
	logPen lopnStyle: flags.
	self free!

styleName
	^self class styleNames at: self style + 1!

styleName: aSymbol 
	"Set the style of the receiver to that named. Note that dotted/dashed styles 
	are only supported if the pen is one pixel wide."

	self style: (self class styleNames indexOf: aSymbol) - 1!

width
	"Answer the width (in pels) of the line drawn by the receiver."

	^logPen width!

width: anInteger 
	"Set the <integer> width (in pixels) of the line drawn by the receiver.
	Note that if the width is greater than 1, then the pen style is ignored
	and the pen will always be solid."

	self width = anInteger ifTrue: [^self].
	logPen width: anInteger.
	self free! !
!Graphics.Pen categoriesForMethods!
color!accessing!public! !
color:!accessing!public! !
createHandle!private!realizing/unrealizing! !
handle:!accessing!private! !
logPen:!accessing!private! !
style!accessing!private! !
style:!accessing!private! !
styleName!accessing!public! !
styleName:!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
!

!Graphics.Pen class methodsFor!

black
	"Answer the stock black pen."

	^StockPen fromId: BLACK_PEN!

blue
	"Answer a blue pen."

	^self color: Color blue!

color: aColor
	"Answer a new instance of the receiver for painting solid 1-pixel lines in the specified <Color>."

	^aColor pen!

dashDot
	^self withStyleName: #dashDot!

dashDotDot
	^self withStyleName: #dashDotDot!

dashed
	^self withStyleName: #dashed!

dotted
	^self withStyleName: #dotted!

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

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

insideFrame
	^self withStyleName: #insideFrame!

newColor: aColor 
	"Private - Answer a new instance of the receiver for painting 1-pixel wide lines in the specified solid colour."

	^self 
		withStyle: BS_SOLID
		width: 1
		color: aColor!

none
	"Answer a null <Pen>"

	^self
		withStyle: PS_NULL
		width: 1
		color: Color none
	!

red
	"Answer a red pen."

	^self color: Color red
!

solid
	^self black.!

styleNames
	^#(#solid #dash #dot #dashDot #dashDotDot #null #insideFrame)!

white
	"Answer the stock white pen."

	^StockPen fromId: WHITE_PEN!

withStyle: styleFlags width: anInteger color: aColour
	"Answer a new instance of the receiver with the specified style, width and colour attributes."

	^self fromLogPen: (LOGPEN newBuffer
				lopnStyle: styleFlags;
				width: anInteger;
				color: aColour;
				yourself)!

withStyleName: aString
	^self
		withStyle: (self styleNames indexOf: aString) - 1
		width: 0
		color: Color black! !
!Graphics.Pen class categoriesForMethods!
black!instance creation!public! !
blue!instance creation!public! !
color:!instance creation!public! !
dashDot!instance creation!public! !
dashDotDot!instance creation!public! !
dashed!instance creation!public! !
dotted!instance creation!public! !
fromLogPen:!instance creation!public! !
green!instance creation!public! !
icon!constants!public! !
insideFrame!instance creation!public! !
newColor:!instance creation!private! !
none!instance creation!public! !
red!instance creation!public! !
solid!instance creation!public! !
styleNames!constants!private! !
white!instance creation!public! !
withStyle:width:color:!instance creation!public! !
withStyleName:!public! !
!

