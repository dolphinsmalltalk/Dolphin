"Filed out from Dolphin Smalltalk 7"!

ExternalRectangle subclass: #RECTF
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RECTF guid: (GUID fromString: '{9a449c4a-8ae9-45d9-b94d-1e1d91fedcd5}')!
RECTF comment: '<RECTF> is an <ExternalStructure> class to wrap the struct ''Gdiplus.RECTF'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(9A449C4A-8AE9-45D9-B94D-1E1D91FEDCD5)]
struct tagRECTF {
	float x;
	float y;
	float Width;
	float Height;
} RECTF;
'!
!RECTF categoriesForClass!Unclassified! !
!RECTF methodsFor!

asRectangle
	^self x @ self y extent: self width @ self height!

height
	"Answer the <Float> value of the receiver's 'height' field."

	^bytes floatAtOffset: ##(self offsetOf: #height)!

height: aFloat
	"Set the receiver's 'height' field to the value of the argument, aFloat"

	bytes floatAtOffset: ##(self offsetOf: #height) put: aFloat!

left
	^self x!

top
	^self y!

width
	"Answer the <Float> value of the receiver's 'width' field."

	^bytes floatAtOffset: ##(self offsetOf: #width)!

width: aFloat
	"Set the receiver's 'width' field to the value of the argument, aFloat"

	bytes floatAtOffset: ##(self offsetOf: #width) put: aFloat!

x
	"Answer the <Float> value of the receiver's 'x' field."

	^bytes floatAtOffset: 0!

x: aFloat
	"Set the receiver's 'x' field to the value of the argument, aFloat"

	bytes floatAtOffset: 0 put: aFloat!

y
	"Answer the <Float> value of the receiver's 'y' field."

	^bytes floatAtOffset: ##(self offsetOf: #y)!

y: aFloat
	"Set the receiver's 'y' field to the value of the argument, aFloat"

	bytes floatAtOffset: ##(self offsetOf: #y) put: aFloat! !
!RECTF categoriesFor: #asRectangle!converting!public! !
!RECTF categoriesFor: #height!**compiled accessors**!public! !
!RECTF categoriesFor: #height:!**compiled accessors**!public! !
!RECTF categoriesFor: #left!public! !
!RECTF categoriesFor: #top!public! !
!RECTF categoriesFor: #width!**compiled accessors**!public! !
!RECTF categoriesFor: #width:!**compiled accessors**!public! !
!RECTF categoriesFor: #x!**compiled accessors**!public! !
!RECTF categoriesFor: #x:!**compiled accessors**!public! !
!RECTF categoriesFor: #y!**compiled accessors**!public! !
!RECTF categoriesFor: #y:!**compiled accessors**!public! !

!RECTF class methodsFor!

defineFields
	"Define the fields of the RECTF structure.
		RECTF compileDefinition
	
		typedef [uuid(9A449C4A-8AE9-45D9-B94D-1E1D91FEDCD5)]
		struct tagRECTF {
			float x;
			float y;
			float Width;
			float Height;
		} RECTF;
"

	self
		defineField: #x type: FLOATField new;
		defineField: #y type: FLOATField new;
		defineField: #width type: FLOATField new;
		defineField: #height type: FLOATField new!

fromRectangle: aRect
	self == aRect class ifTrue: [^aRect].
	^(self new)
		x: aRect left;
		y: aRect top;
		width: aRect width;
		height: aRect height;
		yourself!

getFieldNames
	^#(#x #y #width #height)!

left: left top: top right: right bottom: bottom
	"Answer a new instance of the receiver with the specified position corner positions."

	^self
		left: left
		top: top
		width: right - left
		height: bottom - top!

left: left top: top width: width height: height
	"Answer a new instance of the receiver with the specified origin and extent."

	^self basicNew bytes: ((ByteArray newFixed: 16)
				floatAtOffset: 0 put: left;
				floatAtOffset: 4 put: top;
				floatAtOffset: 8 put: width;
				floatAtOffset: 12 put: height;
				yourself)!

newBuffer
	^self basicNew bytes: (ByteArray newFixed: 16)! !
!RECTF class categoriesFor: #defineFields!initializing!public! !
!RECTF class categoriesFor: #fromRectangle:!instance creation!public! !
!RECTF class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!RECTF class categoriesFor: #left:top:right:bottom:!instance creation!public! !
!RECTF class categoriesFor: #left:top:width:height:!instance creation!public! !
!RECTF class categoriesFor: #newBuffer!instance creation!public! !

