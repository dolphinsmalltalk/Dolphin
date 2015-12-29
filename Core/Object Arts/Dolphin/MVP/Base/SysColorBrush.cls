"Filed out from Dolphin Smalltalk X6"!

StockBrush subclass: #SysColorBrush
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SysColorBrush guid: (GUID fromString: '{87B4C63B-026E-11D3-9FD7-00A0CC3E4A32}')!
SysColorBrush comment: ''!
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
		basicPrint: self;
		nextPut: $(;
		display: self color idName;
		nextPut: $)! !
!SysColorBrush categoriesFor: #color!accessing!public! !
!SysColorBrush categoriesFor: #createHandle!private!realizing/unrealizing! !
!SysColorBrush categoriesFor: #printOn:!development!printing!public! !

!SysColorBrush class methodsFor!

newColor: aSystemColor 
	"Private - Answer a new instance of the receiver for painting in the specified solid colour."

	^self fromId: aSystemColor id! !
!SysColorBrush class categoriesFor: #newColor:!instance creation!private! !

