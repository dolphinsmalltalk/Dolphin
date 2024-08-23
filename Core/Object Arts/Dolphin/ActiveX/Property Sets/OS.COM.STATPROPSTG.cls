"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.COM.STATPROPSTG'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_lpwstrName' -> 16r0.
			'_OffsetOf_propid' -> 16r4.
			'_OffsetOf_vt' -> 16r8.
			'_STATPROPSTG_Size' -> 16rC
		}!

OS.COM.STATPROPSTG guid: (Core.GUID fromString: '{485d4e8d-124f-443d-8eea-b20ddc264f6e}')!

OS.COM.STATPROPSTG comment: '<STATPROPSTG> is an <ExternalStructure> class to wrap the struct ''OBJIDL.STATPROPSTG'' from type information in the ''ObjIDL Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef struct tagSTATPROPSTG {
	LPWSTR lpwstrName;
	unsigned long propid;
	unsigned short vt;
} STATPROPSTG;
'!

!OS.COM.STATPROPSTG categoriesForClass!OBJIDL-Structs! !

!OS.COM.STATPROPSTG methodsFor!

lpwstrName
	"Answer the <Utf16String> value of the receiver's 'lpwstrName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpwstrName)!

lpwstrName: anUtf16String
	"Set the receiver's 'lpwstrName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpwstrName put: anUtf16String yourAddress!

propid
	"Answer the <Integer> value of the receiver's 'propid' field."

	^bytes uint32AtOffset: _OffsetOf_propid!

propid: anInteger
	"Set the receiver's 'propid' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_propid put: anInteger!

vt
	"Answer the <Integer> value of the receiver's 'vt' field."

	^bytes uint16AtOffset: _OffsetOf_vt!

vt: anInteger
	"Set the receiver's 'vt' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_vt put: anInteger! !

!OS.COM.STATPROPSTG categoriesForMethods!
lpwstrName!**compiled accessors**!public! !
lpwstrName:!**compiled accessors**!public! !
propid!**compiled accessors**!public! !
propid:!**compiled accessors**!public! !
vt!**compiled accessors**!public! !
vt:!**compiled accessors**!public! !
!

!OS.COM.STATPROPSTG class methodsFor!

byteSize
	^_STATPROPSTG_Size!

defineFields
	"Define the fields of the STATPROPSTG structure.
		STATPROPSTG compileDefinition
	
		typedef 		struct tagSTATPROPSTG {
			LPWSTR lpwstrName;
			PROPID propid;
			VARTYPE vt;
		} STATPROPSTG;

	"

	self
		defineField: #lpwstrName type: (PointerField type: Utf16String);
		defineField: #propid type: UInt32Field new;
		defineField: #vt type: UInt16Field new!

getFieldNames
	^#(#lpwstrName #propid #vt)! !

!OS.COM.STATPROPSTG class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

