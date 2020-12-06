"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'External.SIZE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SIZE guid: (Core.GUID fromString: '{6dbb8332-abe3-4ac8-9388-e209e560e8a3}')!
External.SIZE isNonInstantiable: true!
External.SIZE comment: '`SizeStructure` is the abstract class of structures representing a 2-dimensional extent. There are concrete subclasses for different types of width and height values used by different APIs.'!
!External.SIZE categoriesForClass!Win32-Structs! !
!External.SIZE methodsFor!

asObject
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case
	a <Point>."

	^self asPoint!

asPoint
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case
	a <Point>."

	^self width @ self height!

height
	^self subclassResponsibility!

height: anObject
	self subclassResponsibility!

width
	^self subclassResponsibility!

width: anObject
	self subclassResponsibility!

x
	^self width!

y
	^self height! !
!External.SIZE categoriesFor: #asObject!converting!public! !
!External.SIZE categoriesFor: #asPoint!converting!public! !
!External.SIZE categoriesFor: #height!accessing!public! !
!External.SIZE categoriesFor: #height:!accessing!public! !
!External.SIZE categoriesFor: #width!accessing!public! !
!External.SIZE categoriesFor: #width:!accessing!public! !
!External.SIZE categoriesFor: #x!accessing!public! !
!External.SIZE categoriesFor: #y!accessing!public! !

!External.SIZE class methodsFor!

fromPoint: aPoint 
	"Answer a new instance of the receiver representing the magnitude of aPoint."

	^self width: aPoint x height: aPoint y!

icon
	"Answer a suitable iconic representation for the receiver."

	^Graphics.Icon fromId: 'extent.ico'!

width: cx height: cy
	^self new
		width: cx;
		height: cy;
		yourself! !
!External.SIZE class categoriesFor: #fromPoint:!instance creation!public! !
!External.SIZE class categoriesFor: #icon!constants!public! !
!External.SIZE class categoriesFor: #width:height:!instance creation!public! !

