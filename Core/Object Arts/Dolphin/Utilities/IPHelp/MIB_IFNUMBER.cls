"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #MIB_IFNUMBER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_IFNUMBER guid: (GUID fromString: '{9F523FA1-99D3-4B73-83A1-FBF779A77E02}')!
MIB_IFNUMBER comment: '<MIB_IFNUMBER> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IFNUMBER'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IFNUMBER {
	unsigned long dwValue;
} MIB_IFNUMBER;
'!
!MIB_IFNUMBER categoriesForClass!Win32-Structs! !
!MIB_IFNUMBER methodsFor!

dwValue
	"Answer the receiver's dwValue field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)! !
!MIB_IFNUMBER categoriesFor: #dwValue!**compiled accessors**!public! !

!MIB_IFNUMBER class methodsFor!

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
	self byteSize: 4! !
!MIB_IFNUMBER class categoriesFor: #defineFields!initializing!public! !

