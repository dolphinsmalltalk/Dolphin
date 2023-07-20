"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'Graphics.AbstractPen'
	instanceVariableNames: 'logPen'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'LineJoinNames'
				-> #('LineJoinMiter' 'LineJoinBevel' 'LineJoinRound' 'LineJoinMiterClipped')
		}!
Graphics.AbstractPen guid: (Core.GUID fromString: '{af590a75-95a8-46f6-8835-9349b173b75c}')!
Graphics.AbstractPen isNonInstantiable: true!
Graphics.AbstractPen comment: ''!
!Graphics.AbstractPen methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: [self species == anObject species and: [self logPen = anObject logPen]]!

color
	^logPen color!

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
!Graphics.AbstractPen categoriesForMethods!
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

!Graphics.AbstractPen class methodsFor!

black
	"Answer the stock black pen."

	^StockPen fromId: BLACK_PEN!

icon
	"Answers an Icon that can be used to represent this class"

	^Pen defaultIcon!

null
	^StockPen fromId: NULL_PEN!

styleNames
	^#(#solid #dashed #dotted #dashDot #dashDotDot #null #insideFrame)!

white
	"Answer the stock white pen."

	^StockPen fromId: WHITE_PEN! !
!Graphics.AbstractPen class categoriesForMethods!
black!instance creation!public! !
icon!constants!public! !
null!instance creation!public! !
styleNames!constants!private! !
white!instance creation!public! !
!

