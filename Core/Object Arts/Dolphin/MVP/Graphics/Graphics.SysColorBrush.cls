"Filed out from Dolphin Smalltalk"!

Graphics.StockBrush
	subclass: #'Graphics.SysColorBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.SysColorBrush guid: (Core.GUID fromString: '{87b4c63b-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.SysColorBrush comment: '`SysColorBrush` is type of `Brush` that paints in one of the current Windows theme colours.

SysColorBrushes are not normally instantiated directly, but rather by sending the `#brush` message to a suitable system colour, for example `Color face3d brush`.

## Instance Variables:
  `id`		`<integer>` code identifying the theme colour, from the COLOR_xxxx enumeration
'!
!Graphics.SysColorBrush categoriesForClass!Graphics-Tools! !
!Graphics.SysColorBrush methodsFor!

color
	"Answer the <Color> of this solid brush."

	^SystemColor withIndex: id!

createHandle
	"Private - Get the handle of the system color brush with the receiver's id."

	^User32 getSysColorBrush: id!

printOn: aStream 
	"Put an ASCII representation of receiver onto aStream."

	aStream
		nextPut: $(;
		print: Brush;
		space;
		display: #color:;
		space;
		print: self color;
		nextPut: $)! !
!Graphics.SysColorBrush categoriesForMethods!
color!accessing!public! !
createHandle!private!realizing/unrealizing! !
printOn:!development!printing!public! !
!

!Graphics.SysColorBrush class methodsFor!

newColor: aSystemColor 
	"Private - Answer a new instance of the receiver for painting in the specified solid colour."

	^self fromId: aSystemColor id! !
!Graphics.SysColorBrush class categoriesForMethods!
newColor:!instance creation!private! !
!

