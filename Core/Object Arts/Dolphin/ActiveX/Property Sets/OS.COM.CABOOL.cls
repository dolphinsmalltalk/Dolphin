"Filed out from Dolphin Smalltalk"!

OS.COM.CountedArray
	subclass: #'OS.COM.CABOOL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CABOOL_Size' -> 16r8 }!

OS.COM.CABOOL guid: (Core.GUID fromString: '{abb67e82-a32f-4975-9cea-62516ee47100}')!

OS.COM.CABOOL comment: '`OS.COM.CABOOL` is an `OS.COM.CountedArray` class to wrap the COM Property Storage counted array of the same name.

Note that the unmanaged elements of the array are of type `VARIANT_BOOL`, i.e. `CABOOL` is _not_an counted array of `BOOL`. 

`VARIANT_BOOL` is the unusual 16-bit boolean value from the VB (variant) type system where all 16 bits are set (i.e. -1) to represent true, and none of the 16 bits are set (i.e. 0) for false.

* `CABOOL>>#at:` unmarshals the `VARIANT_BOOL` elements to Smalltalk `Boolean` values (true or false)
* `CABOOL>>#at:put:` marshal from Smalltalk `Boolean`s to `VARIANT_BOOL` representation.

IDL definition follows:
```
typedef 
struct tagCABOOL {
	ULONG cElems;
	[size_is("cElems")] VARIANT_BOOL* pElems;
} CABOOL;
```
'!

!OS.COM.CABOOL categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CABOOL class methodsFor!

byteSize
	^_CABOOL_Size!

defineFields
	"Define the fields of the CABOOL structure.

	CABOOL compileDefinition

		typedef 
		struct tagCABOOL {
			ULONG cElems;
			[size_is('cElems')] VARIANT_BOOL* pElems;
		} CABOOL;
"

	self
		defineField: #cElems type: UInt32Field new offset: 0;
		defineField: #pElems type: (ArrayPointerField type: VARIANT_BOOLArray lengthField: #cElems) offset: 4.
	self byteSize: 8!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^VARIANT_BOOL
! !

!OS.COM.CABOOL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
elementClass!constants!public! !
!

