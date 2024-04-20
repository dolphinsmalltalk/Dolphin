"Filed out from Dolphin Smalltalk"!

AbstractRect subclass: #GpRect
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_height _OffsetOf_width _OffsetOf_x _OffsetOf_y'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GpRect guid: (GUID fromString: '{5ee5267a-d864-4ccb-a24c-0d01c419885f}')!

GpRect addClassConstant: '_OffsetOf_height' value: 16rC!
GpRect addClassConstant: '_OffsetOf_width' value: 16r8!
GpRect addClassConstant: '_OffsetOf_x' value: 16r0!
GpRect addClassConstant: '_OffsetOf_y' value: 16r4!

GpRect comment: ''!

!GpRect categoriesForClass!Win32-Structs! !

!GpRect methodsFor!

height
	"Answer the <Integer> value of the receiver's 'height' field."

	^bytes sdwordAtOffset: _OffsetOf_height!

height: anInteger
	"Set the receiver's 'height' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_height put: anInteger!

scaleToDpi: desiredInteger from: currentInteger
	"Scale the receiver in-place by from the DPI represented by the first <integer> argument to that represented by the second integer argument."

	bytes
		sdwordAtOffset: _OffsetOf_x
			put: (bytes sdwordAtOffset: _OffsetOf_x) * desiredInteger // currentInteger;
		sdwordAtOffset: _OffsetOf_y
			put: (bytes sdwordAtOffset: _OffsetOf_y) * desiredInteger // currentInteger;
		sdwordAtOffset: _OffsetOf_width
			put: (bytes sdwordAtOffset: _OffsetOf_width) * desiredInteger // currentInteger;
		sdwordAtOffset: _OffsetOf_height
			put: (bytes sdwordAtOffset: _OffsetOf_height) * desiredInteger // currentInteger!

width
	"Answer the <Integer> value of the receiver's 'width' field."

	^bytes sdwordAtOffset: _OffsetOf_width!

width: anInteger
	"Set the receiver's 'width' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_width put: anInteger!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: _OffsetOf_x!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_x put: anInteger!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: _OffsetOf_y!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_y put: anInteger! !

!GpRect categoriesForMethods!
height!**compiled accessors**!public! !
height:!**compiled accessors**!public! !
scaleToDpi:from:!public!transforming! !
width!**compiled accessors**!public! !
width:!**compiled accessors**!public! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

!GpRect class methodsFor!

defineFields
	"Define the fields of the GpRect structure.
		GpRect compileDefinition
	"

	self
		defineField: #x type: SDWORDField new;
		defineField: #y type: SDWORDField new;
		defineField: #width type: SDWORDField new;
		defineField: #height type: SDWORDField new!

getFieldNames
	^#(#x #y #width #height)!

left: left top: top width: width height: height
	"Answer a new instance of the receiver with the specified origin and extent."

	^self basicNew bytes: ((ByteArray newFixed: 16)
				sdwordAtOffset: _OffsetOf_x put: left;
				sdwordAtOffset: _OffsetOf_y put: top;
				sdwordAtOffset: _OffsetOf_width put: width;
				sdwordAtOffset: _OffsetOf_height put: height;
				yourself)! !

!GpRect class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
left:top:width:height:!public! !
!

