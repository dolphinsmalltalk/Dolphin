"Filed out from Dolphin Smalltalk"!

Brush subclass: #HatchBrush
	instanceVariableNames: 'id color'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HatchBrush guid: (GUID fromString: '{7b044e62-1bef-40c1-a50a-1f63f6d10c2d}')!
HatchBrush comment: '`HatchBrush` is type of `Brush` that wraps a Windows GDI Brush object for drawing in one of the standard hashed patterns.

HatchBrushes are not normally instantiated directly, but rather through one of the relevant instance creation methods of the superclass, `Brush`. For example:

	`Brush diamond: Color ghostWhite`

## Instance Variables:
  `id`		`<integer>` code from the HS_xxx enumeration, which specified the hatched pattern that will be drawn
  `color`	`<Color>` of the lines that will be drawn to form the pattern
'!
!HatchBrush categoriesForClass!Graphics-Tools! !
!HatchBrush methodsFor!

createHandle
	^GDILibrary default createHatchBrush: id color: color asCOLORREF!

name
	"Answer the symbolic name of this hatched brush."

	^#(#horizontal #vertical #reverseDiagonal #diagonal #cross #diamond) at: id + 1!

printOn: aPuttableStream
	"Append, to the <puttableStream> argument a string whose characters are a the same as those which would result from sending a #printString message to the receiver."

	color = Color black
		ifTrue: 
			[aPuttableStream
				print: Brush;
				space;
				display: self name]
		ifFalse: 
			[aPuttableStream
				nextPut: $(;
				print: Brush;
				space;
				display: self name;
				nextPutAll: ': ';
				print: color;
				nextPut: $)]!

setId: anInteger color: aColor 
	id := anInteger.
	color := aColor! !
!HatchBrush categoriesForMethods!
createHandle!private!realizing/unrealizing! !
name!accessing!public! !
printOn:!printing!public! !
setId:color:!initializing!private! !
!

!HatchBrush class methodsFor!

fromId: anInteger color: aColor
	"Answer a new instance of the receiver for painting a hatched pattern of the type identifiedby the <integer> argument, anInteger, which should be a code from the HS_xxx enumeration, in the <Color>, aColor."

	^self new setId: anInteger color: aColor! !
!HatchBrush class categoriesForMethods!
fromId:color:!instance creation!public! !
!

