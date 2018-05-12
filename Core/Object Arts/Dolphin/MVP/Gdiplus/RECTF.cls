"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #RECTF
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
	"Answer the receiver's height field as a Smalltalk object."

	^(bytes floatAtOffset: 12)!

height: anObject
	"Set the receiver's height field to the value of anObject."

	bytes floatAtOffset: 12 put: anObject!

width
	"Answer the receiver's width field as a Smalltalk object."

	^(bytes floatAtOffset: 8)!

width: anObject
	"Set the receiver's width field to the value of anObject."

	bytes floatAtOffset: 8 put: anObject!

x
	"Answer the receiver's x field as a Smalltalk object."

	^(bytes floatAtOffset: 0)!

x: anObject
	"Set the receiver's x field to the value of anObject."

	bytes floatAtOffset: 0 put: anObject!

y
	"Answer the receiver's y field as a Smalltalk object."

	^(bytes floatAtOffset: 4)!

y: anObject
	"Set the receiver's y field to the value of anObject."

	bytes floatAtOffset: 4 put: anObject! !
!RECTF categoriesFor: #asRectangle!converting!public! !
!RECTF categoriesFor: #height!**compiled accessors**!public! !
!RECTF categoriesFor: #height:!**compiled accessors**!public! !
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
	self = aRect class ifTrue: [^aRect].
	^(self new)
		x: aRect left;
		y: aRect top;
		width: aRect width;
		height: aRect height;
		yourself! !
!RECTF class categoriesFor: #defineFields!initializing!public! !
!RECTF class categoriesFor: #fromRectangle:!instance creation!public! !

