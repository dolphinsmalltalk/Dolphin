"Filed out from Dolphin Smalltalk 2002 release 5.00"!

BreakOutObject subclass: #BreakOutBall
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BreakOutBall guid: (GUID fromString: '{CAC62F19-769E-410F-8754-630535C5B564}')!
BreakOutBall comment: ''!
!BreakOutBall categoriesForClass!Unclassified! !
!BreakOutBall methodsFor!

defaultExtent
	"Private - Answer the default size of the receiver. "

	^10@10!

drawOn: aCanvas
	"Draws the receiver on aCanvas"

	aCanvas 
		pen: (Pen color: self color);
		brush: (Brush color: self color);
		ellipse: self rectangle! !
!BreakOutBall categoriesFor: #defaultExtent!constants!private! !
!BreakOutBall categoriesFor: #drawOn:!drawing!operations!public! !

