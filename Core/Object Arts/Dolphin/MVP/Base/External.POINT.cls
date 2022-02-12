"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'External.POINT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.POINT guid: (Core.GUID fromString: '{5a0c3f56-8db8-4509-8563-3affe77805b2}')!
External.POINT isNonInstantiable: true!
External.POINT comment: '`POINT` is the abstract class of structures representing positions in a 2-dimensional space. There are concrete subclasses for different types of co-ordinate value.'!
!External.POINT categoriesForClass!External-Data-Structured! !
!External.POINT methodsFor!

asDword
	"Answer the receiver in a form suitable for passing or returning 
	as a 32-bit value (i.e. a 32-bit integer)."

	^(DWORD fromPoint: self) value!

asObject
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case
	a <Point>."

	^self asPoint!

asPoint
	"Answer a Point created that matches the receiver"

	^Graphics.Point x: self x y: self y!

asUIntPtr
	"Answer the receiver in a form suitable for passing or returning 
	as a  machine-word sized (32 or 64-bit) value."

	^self asPoint asUIntPtr!

value
	"Answer the receiver's value field as an equivalent Smalltalk object (a <Point>)."

	^self asPoint!

value: aPoint
	"Set the value buffered by the receiver to aPoint."

	self
		x: aPoint x;
		y: aPoint y!

x
	^self subclassResponsibility!

x: anObject
	self subclassResponsibility!

y
	^self subclassResponsibility!

y: anObject
	self subclassResponsibility! !
!External.POINT categoriesForMethods!
asDword!converting!public! !
asObject!converting!public! !
asPoint!converting!public! !
asUIntPtr!converting!public! !
value!accessing!public! !
value:!accessing!public! !
x!accessing!public! !
x:!accessing!public! !
y!accessing!public! !
y:!accessing!public! !
!

!External.POINT class methodsFor!

fromPoint: aPoint
	"Answer a new instance of the receiver representing aPoint."
	
	^self x: aPoint x y: aPoint y!

getFieldNames
	^#(#x #y)!

icon
	"Answer a suitable iconic representation for the receiver."

	^Graphics.Point icon!

x: x y: y
	"Answer a new instance of the receiver representing the Point whose 
	cartesian coordinates are the arguments."

	^self basicNew
		x: x;
		y: y;
		yourself! !
!External.POINT class categoriesForMethods!
fromPoint:!instance creation!public! !
getFieldNames!constants!private! !
icon!constants!development!public! !
x:y:!instance creation!public! !
!

