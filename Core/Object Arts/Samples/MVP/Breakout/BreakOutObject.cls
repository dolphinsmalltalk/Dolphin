"Filed out from Dolphin Smalltalk 2002 release 5.00"!

AnimationObject subclass: #BreakOutObject
	instanceVariableNames: 'extent color'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BreakOutObject guid: (GUID fromString: '{81BEDC98-CEDF-45D0-8C53-C2AC6970ED55}')!
BreakOutObject comment: ''!
!BreakOutObject categoriesForClass!Unclassified! !
!BreakOutObject methodsFor!

color
	"Answer the value of the receiver's ''color'' instance variable."

	^color!

color: anObject
	"Set the value of the receiver's ''color'' instance variable to the argument, anObject."

	color := anObject!

defaultColor
	"Private - Answer the default colour of the receiver. "

	^Color white!

defaultExtent
	"Private - Answer the default size of the receiver. "

	^30@30!

drawOn: aCanvas
	"Draws the receiver on aCanvas"

	aCanvas fillRectangle: self rectangle brush: (Brush color: self color)!

extent
	"Answer the value of the receiver's ''extent'' instance variable."

	^extent!

extent: anObject
	"Set the value of the receiver's ''extent'' instance variable to the argument, anObject."

	extent := anObject!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self extent: self defaultExtent; color: self defaultColor!

rectangle
	"Answer the bounding rectangle of the receiver"

	^Rectangle center: self position truncated extent: self extent
! !
!BreakOutObject categoriesFor: #color!accessing!public! !
!BreakOutObject categoriesFor: #color:!accessing!public! !
!BreakOutObject categoriesFor: #defaultColor!constants!private! !
!BreakOutObject categoriesFor: #defaultExtent!constants!private! !
!BreakOutObject categoriesFor: #drawOn:!drawing!operations!public! !
!BreakOutObject categoriesFor: #extent!accessing!public! !
!BreakOutObject categoriesFor: #extent:!accessing!public! !
!BreakOutObject categoriesFor: #initialize!initializing!private! !
!BreakOutObject categoriesFor: #rectangle!accessing!public! !

