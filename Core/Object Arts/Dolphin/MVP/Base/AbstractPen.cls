"Filed out from Dolphin Smalltalk"!

GraphicsTool subclass: #AbstractPen
	instanceVariableNames: 'logPen'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractPen guid: (GUID fromString: '{af590a75-95a8-46f6-8835-9349b173b75c}')!

AbstractPen isAbstract: true!

AbstractPen comment: ''!

!AbstractPen categoriesForClass!Graphics-Tools! !

!AbstractPen methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: [self species == anObject species and: [self logPen = anObject logPen]]!

color
	^logPen lopnColor!

handle: anExternalHandle
	"Private - Set the handle for the receiver and query its logical info."

	super handle: anExternalHandle.
	logPen := LOGPEN newBuffer.
	self getData: logPen!

hash
	"Answer the hash of the identifier."

	^logPen hash!

logPen
	^logPen!

species
	^Pen!

style
	^logPen lopnStyle!

styleName
	^self class styleNames at: self style + 1!

width
	"Answer the width (in pels) of the line drawn by the receiver."

	^logPen width! !

!AbstractPen categoriesForMethods!
=!comparing!public! !
color!accessing!public! !
handle:!accessing!private! !
hash!comparing!public! !
logPen!accessing!private! !
species!public! !
style!accessing!private! !
styleName!accessing!public! !
width!accessing!public! !
!

!AbstractPen class methodsFor!

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

icon
	"Answers an Icon that can be used to represent this class"

	^Pen defaultIcon!

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

null
	^StockPen fromId: NULL_PEN!

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
				color: aColour;
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
				color: aColour;
				yourself)!

styleNamed: aString
	| style |
	style := (self styleNames indexOf: aString) - 1.
	style < 0 ifTrue: [self error: 'Unrecognised Pen style <1p>'  << aString].
	^style!

styleNames
	^#(#solid #dashed #dotted #dashDot #dashDotDot #null #insideFrame)!

white
	"Answer the stock white pen."

	^StockPen fromId: WHITE_PEN!

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

!AbstractPen class categoriesForMethods!
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
null!instance creation!public! !
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
styleNames!constants!private! !
white!instance creation!public! !
width:!instance creation!public! !
width:color:!instance creation!public! !
withStyle:width:color:!instance creation!public! !
withStyleName:!public! !
!

