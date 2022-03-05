"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #ExternalPoint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalPoint guid: (GUID fromString: '{5a0c3f56-8db8-4509-8563-3affe77805b2}')!
ExternalPoint isAbstract: true!
ExternalPoint comment: '`PointStructure` is the abstract class of structures representing positions in a 2-dimensional space. There are concrete subclasses for different types of co-ordinate value.'!
!ExternalPoint categoriesForClass!External-Data-Structured! !
!ExternalPoint methodsFor!

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

	^self x @ self y!

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
!ExternalPoint categoriesForMethods!
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

!ExternalPoint class methodsFor!

fromPoint: aPoint
	"Answer a new instance of the receiver representing aPoint."
	
	^self x: aPoint x y: aPoint y!

getFieldNames
	^#(#x #y)!

icon
	"Answer a suitable iconic representation for the receiver."

	^Point icon!

x: x y: y
	"Answer a new instance of the receiver representing the Point whose 
	cartesian coordinates are the arguments."

	^self basicNew
		x: x;
		y: y;
		yourself! !
!ExternalPoint class categoriesForMethods!
fromPoint:!instance creation!public! !
getFieldNames!constants!private! !
icon!constants!development!public! !
x:y:!instance creation!public! !
!

