"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure
	subclass: #'Graphics.Gdiplus.PropertyItem'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_id' -> 16r0.
			'_OffsetOf_length' -> 16r4.
			'_OffsetOf_Type' -> 16r8.
			'_OffsetOf_Value' -> 16rC.
			'_PropertyItem_Size' -> 16r10
		}!

Graphics.Gdiplus.PropertyItem guid: (Core.GUID fromString: '{dad9cd42-c61c-4040-bcd2-2f2e8d725fca}')!

Graphics.Gdiplus.PropertyItem comment: '<GpPropertyItem> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpPropertyItem'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(DAD9CD42-C61C-4040-BCD2-2F2E8D725FCA)]
struct tagGpPropertyItem {
	unsigned long id;
	unsigned long length;
	unsigned short type;
	void* Value;
} GpPropertyItem;
'!

!Graphics.Gdiplus.PropertyItem methodsFor!

id
	"Answer the <Integer> value of the receiver's 'id' field."

	^bytes uint32AtOffset: _OffsetOf_id!

id: anInteger
	"Set the receiver's 'id' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_id put: anInteger!

length
	"Answer the <Integer> value of the receiver's 'length' field."

	^bytes uint32AtOffset: _OffsetOf_length!

length: anInteger
	"Set the receiver's 'length' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_length put: anInteger!

name
	"Answer the receiver's id (property tag) as a string.  If unknown, answer the receiver's id as a hex string."

	^(Gdiplus classConstants detect: 
			[:each |
			((each key beginsWith: 'PropertyTag') and: [(each key beginsWith: 'PropertyTagType') not])
				and: [self id = each value]]
		ifNone: [self id hex -> nil]) key!

Type
	"Answer the <Integer> value of the receiver's 'Type' field."

	^bytes uint16AtOffset: _OffsetOf_Type!

Type: anInteger
	"Set the receiver's 'Type' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_Type put: anInteger!

typeName
	"Answer the receiver's type (property tag type) as a string."

	^(Gdiplus classConstants
		detect: [:each | (each key beginsWith: 'PropertyTagType') and: [self Type = each value]]) key!

Value
	"Answer the <ExternalAddress> value of the receiver's 'Value' field."

	^(bytes uintPtrAtOffset: _OffsetOf_Value) asExternalAddress!

Value: anExternalAddress
	"Set the receiver's 'Value' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_Value put: anExternalAddress!

valueArray
	"Answer the array pointed at by the receiver's Value. The receiver's type gives a hint at
	the type of array, and length gives the number of items in the array."

	| address type |
	address := self Value.
	type := self Type.
	type == PropertyTagTypeByte ifTrue: [^ByteArray fromAddress: address length: self length].
	type == PropertyTagTypeASCII ifTrue: [^(AnsiString fromAddress: address length: self length - 1) trimNulls].
	type == PropertyTagTypeShort ifTrue: [^UInt16Array fromAddress: address length: (self length bitShift: -1)].
	type == PropertyTagTypeLong ifTrue: [^UInt32Array fromAddress: address length: (self length bitShift: -2)].
	"Next line won't work with an array value, i.e., if length > 8."
	type == PropertyTagTypeRational ifTrue: [^(address uint32AtOffset: 0) / (address uint32AtOffset: 4)].
	"7 is 'Undefined' so just return the bytes."
	type == PropertyTagTypeUndefined ifTrue: [^ByteArray fromAddress: address length: self length].
	type == PropertyTagTypeSLONG ifTrue: [^Int32Array fromAddress: address length: (self length bitShift: -2)].
	"Next line won't work with an array value, i.e., if length > 8."
	type == PropertyTagTypeSRational ifTrue: [^(address int32AtOffset: 0) / (address int32AtOffset: 4)].
	self error: 'unrecognised type'! !

!Graphics.Gdiplus.PropertyItem categoriesForMethods!
id!**compiled accessors**!public! !
id:!**compiled accessors**!public! !
length!**compiled accessors**!public! !
length:!**compiled accessors**!public! !
name!accessing!public! !
Type!**compiled accessors**!public! !
Type:!**compiled accessors**!public! !
typeName!accessing!public! !
Value!**compiled accessors**!public! !
Value:!**compiled accessors**!public! !
valueArray!accessing!public! !
!

!Graphics.Gdiplus.PropertyItem class methodsFor!

byteSize
	^_PropertyItem_Size!

defineFields
	"Define the fields of the GpPropertyItem structure.
		GpPropertyItem compileDefinition
	
		typedef [uuid(DAD9CD42-C61C-4040-BCD2-2F2E8D725FCA)]
		struct tagGpPropertyItem {
			[helpstring('ID of this property')] unsigned long id;
			[helpstring('Length of the property value, in bytes')] unsigned long length;
			[helpstring('Type of the value, as one of TAG_TYPE_XXX defined above')] unsigned short Type;
			[helpstring('property value')] void* Value;
		} GpPropertyItem;
"

	self
		defineField: #id
			type: UInt32Field new
			offset: 0;
		defineField: #length
			type: UInt32Field new
			offset: 4;
		defineField: #Type
			type: UInt16Field new
			offset: 8;
		defineField: #Value
			type: LPVOIDField new
			offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#id #length #Type #Value)! !

!Graphics.Gdiplus.PropertyItem class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

