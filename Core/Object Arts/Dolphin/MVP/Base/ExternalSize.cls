"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #ExternalSize
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExternalSize guid: (GUID fromString: '{6dbb8332-abe3-4ac8-9388-e209e560e8a3}')!

ExternalSize isAbstract: true!

ExternalSize comment: '`SizeStructure` is the abstract class of structures representing a 2-dimensional extent. There are concrete subclasses for different types of width and height values used by different APIs.'!

!ExternalSize categoriesForClass!Win32-Structs! !

!ExternalSize methodsFor!

asObject
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case
	a <Point>."

	^self asPoint!

asPoint
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case
	a <Point>."

	^Point x: self width y: self height!

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

!ExternalSize categoriesForMethods!
asObject!converting!public! !
asPoint!converting!public! !
height!accessing!public! !
height:!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
x!accessing!public! !
y!accessing!public! !
!

!ExternalSize class methodsFor!

fromPoint: aPoint 
	"Answer a new instance of the receiver representing the magnitude of aPoint."

	^self width: aPoint x height: aPoint y!

icon
	"Answer a suitable iconic representation for the receiver."

	^Icon fromId: 'extent.ico'!

width: cx height: cy
	^self new
		width: cx;
		height: cy;
		yourself! !

!ExternalSize class categoriesForMethods!
fromPoint:!instance creation!public! !
icon!constants!public! !
width:height:!instance creation!public! !
!

