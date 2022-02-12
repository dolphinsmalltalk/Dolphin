"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.MIB_IFNUMBER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_MIB_IFNUMBER_Size' -> 16r4.
		'_OffsetOf_dwValue' -> 16r0
	}!
OS.MIB_IFNUMBER guid: (Core.GUID fromString: '{9f523fa1-99d3-4b73-83a1-fbf779a77e02}')!
OS.MIB_IFNUMBER comment: '<MIB_IFNUMBER> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IFNUMBER'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IFNUMBER {
	unsigned long dwValue;
} MIB_IFNUMBER;
'!
!OS.MIB_IFNUMBER categoriesForClass!Win32-Structs! !
!OS.MIB_IFNUMBER methodsFor!

dwValue
	"Answer the <Integer> value of the receiver's 'dwValue' field."

	^bytes dwordAtOffset: _OffsetOf_dwValue! !
!OS.MIB_IFNUMBER categoriesForMethods!
dwValue!**compiled accessors**!public! !
!

!OS.MIB_IFNUMBER class methodsFor!

byteSize
	^_MIB_IFNUMBER_Size!

defineFields
	"Define the fields of the MIB_IFNUMBER structure.
		MIB_IFNUMBER compileDefinition
	
		typedef 
		struct tagMIB_IFNUMBER {
			unsigned long dwValue;
		} MIB_IFNUMBER;
"

	self
		defineField: #dwValue type: DWORDField readOnly offset: 0.
	self byteSize: 4!

getFieldNames
	^#(#dwValue)! !
!OS.MIB_IFNUMBER class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

