"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #GpPropertyItem
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_id _OffsetOf_length _OffsetOf_Type _OffsetOf_Value'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GpPropertyItem guid: (GUID fromString: '{dad9cd42-c61c-4040-bcd2-2f2e8d725fca}')!

GpPropertyItem addClassConstant: '_OffsetOf_id' value: 16r0!
GpPropertyItem addClassConstant: '_OffsetOf_length' value: 16r4!
GpPropertyItem addClassConstant: '_OffsetOf_Type' value: 16r8!
GpPropertyItem addClassConstant: '_OffsetOf_Value' value: 16rC!

GpPropertyItem comment: '<GpPropertyItem> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpPropertyItem'' from type information in the ''GDI+ Library 1.0'' library.

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

!GpPropertyItem categoriesForClass!Unclassified! !

!GpPropertyItem methodsFor!

id
	"Answer the <Integer> value of the receiver's 'id' field."

	^bytes dwordAtOffset: _OffsetOf_id!

id: anInteger
	"Set the receiver's 'id' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_id put: anInteger!

length
	"Answer the <Integer> value of the receiver's 'length' field."

	^bytes dwordAtOffset: _OffsetOf_length!

length: anInteger
	"Set the receiver's 'length' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_length put: anInteger!

name
	"Answer the receiver's id (property tag) as a string.  If unknown, answer the receiver's id as a hex string."

	^GdiplusConstants keys asOrderedCollection detect: 
			[:e | 
			((e beginsWith: 'PropertyTag') and: [(e beginsWith: 'PropertyTagType') not]) 
				and: [self id = (GdiplusConstants at: e)]]
		ifNone: [self id hex]!

Type
	"Answer the <Integer> value of the receiver's 'Type' field."

	^bytes wordAtOffset: _OffsetOf_Type!

Type: anInteger
	"Set the receiver's 'Type' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_Type put: anInteger!

typeName
	"Answer the receiver's type (property tag type) as a string."

	^GdiplusConstants keys asOrderedCollection 
		detect: [:e | (e beginsWith: 'PropertyTagType') and: [self Type = (GdiplusConstants at: e)]]!

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
	type == 1 ifTrue: [^ByteArray fromAddress: address length: self length].
	type == 2 ifTrue: [^(String fromAddress: address length: self length - 1) trimNulls].
	type == 3 ifTrue: [^WORDArray fromAddress: address length: self length / 2].
	type == 4 ifTrue: [^DWORDArray fromAddress: address length: self length / 4].
	"Next line won't work with an arary returned, i.e., if length > 8."
	type == 5 ifTrue: [^(address dwordAtOffset: 0) / (address dwordAtOffset: 4)].
	"7 is 'Undefined' so just return the bytes."
	type == 7 ifTrue: [^ByteArray fromAddress: address length: self length].
	type == 9 ifTrue: [^SDWORDArray fromAddress: address length: self length / 4].
	"Next line won't work with an arary returned, i.e., if length > 8."
	type == 10 ifTrue: [^(address sdwordAtOffset: 0) / (address sdwordAtOffset: 4)].
	self error: 'unrecognised type'! !

!GpPropertyItem categoriesForMethods!
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

!GpPropertyItem class methodsFor!

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
		defineField: #id type: DWORDField new offset: 0;
		defineField: #length type: DWORDField new offset: 4;
		defineField: #Type type: WORDField new offset: 8;
		defineField: #Value type: LPVOIDField new offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#id #length #Type #Value)! !

!GpPropertyItem class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

