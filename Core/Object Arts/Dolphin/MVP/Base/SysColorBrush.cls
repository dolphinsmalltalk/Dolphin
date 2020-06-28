"Filed out from Dolphin Smalltalk 7"!

StockBrush subclass: #SysColorBrush
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SysColorBrush guid: (GUID fromString: '{87b4c63b-026e-11d3-9fd7-00a0cc3e4a32}')!
SysColorBrush comment: '`SysColorBrush` is type of `Brush` that paints in one of the current Windows theme colours.

SysColorBrushes are not normally instantiated directly, but rather by sending the `#brush` message to a suitable system colour, for example `Color face3d brush`.

## Instance Variables:
  `id`		`<integer>` code identifying the theme colour, from the COLOR_xxxx enumeration
'!
!SysColorBrush categoriesForClass!Graphics-Tools! !
!SysColorBrush methodsFor!

color
	"Answer the <Color> of this solid brush."
	
	^SystemColor fromId: id!

createHandle
	"Private - Get the handle of the system color brush with the receiver's id."

	^UserLibrary default getSysColorBrush: id!

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
!SysColorBrush categoriesFor: #color!accessing!public! !
!SysColorBrush categoriesFor: #createHandle!private!realizing/unrealizing! !
!SysColorBrush categoriesFor: #printOn:!development!printing!public! !

!SysColorBrush class methodsFor!

newColor: aSystemColor 
	"Private - Answer a new instance of the receiver for painting in the specified solid colour."

	^self fromId: aSystemColor id! !
!SysColorBrush class categoriesFor: #newColor:!instance creation!private! !

