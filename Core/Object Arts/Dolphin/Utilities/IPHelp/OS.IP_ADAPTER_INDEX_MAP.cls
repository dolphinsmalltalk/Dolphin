﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.IP_ADAPTER_INDEX_MAP'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_IP_ADAPTER_INDEX_MAP_Size' -> 16r104.
			'_OffsetOf_index' -> 16r0.
			'_OffsetOf_Name' -> 16r4
		}!

OS.IP_ADAPTER_INDEX_MAP guid: (Core.GUID fromString: '{fc9307a0-b028-4f04-81c9-9d74847a63ef}')!

OS.IP_ADAPTER_INDEX_MAP comment: '<IP_ADAPTER_INDEX_MAP> is an <ExternalStructure> class to wrap the struct ''Win32.IP_ADAPTER_INDEX_MAP'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagIP_ADAPTER_INDEX_MAP {
	unsigned long index;
	unsigned short Name[128];
} IP_ADAPTER_INDEX_MAP;
'!

!OS.IP_ADAPTER_INDEX_MAP categoriesForClass!Win32-Structs! !

!OS.IP_ADAPTER_INDEX_MAP methodsFor!

index
	"Answer the <Integer> value of the receiver's 'index' field."

	^bytes uint32AtOffset: _OffsetOf_index!

Name
	"Answer the <Utf16String> value of the receiver's 'Name' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_Name! !

!OS.IP_ADAPTER_INDEX_MAP categoriesForMethods!
index!**compiled accessors**!public! !
Name!**compiled accessors**!public! !
!

!OS.IP_ADAPTER_INDEX_MAP class methodsFor!

byteSize
	^_IP_ADAPTER_INDEX_MAP_Size!

defineFields
	"Define the fields of the IP_ADAPTER_INDEX_MAP structure.
		IP_ADAPTER_INDEX_MAP compileDefinition
	
		typedef 
		struct tagIP_ADAPTER_INDEX_MAP {
			unsigned long index;
			unsigned short Name[128];
		} IP_ADAPTER_INDEX_MAP;
"

	self
		defineField: #index
			type: UInt32Field readOnly
			offset: 0;
		defineField: #Name
			type: ((StringField type: Utf16String length: 128)
					beReadOnly;
					yourself)
			offset: 4.
	self byteSize: 260!

getFieldNames
	^#(#index #Name)! !

!OS.IP_ADAPTER_INDEX_MAP class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

