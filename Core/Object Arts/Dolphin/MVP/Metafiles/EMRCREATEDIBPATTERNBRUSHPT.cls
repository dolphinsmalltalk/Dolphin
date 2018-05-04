"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRCREATEDIBPATTERNBRUSHPT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCREATEDIBPATTERNBRUSHPT guid: (GUID fromString: '{ae1203b9-a6b7-4cca-8fc6-408d43a80c8c}')!
EMRCREATEDIBPATTERNBRUSHPT comment: '<EMRCREATEDIBPATTERNBRUSHPT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATEDIBPATTERNBRUSHPT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(AE1203B9-A6B7-4CCA-8FC6-408D43A80C8C)]
struct tagEMRCREATEDIBPATTERNBRUSHPT {
	EMR EMR;
	[helpstring("Brush handle index")] DWORD ihBrush;
	[helpstring("Bitmap info color table usage")] DWORD iUsage;
	[helpstring("Offset to the BITMAPINFO structure")] DWORD offBmi;
	[helpstring("Size of the BITMAPINFO structure")] DWORD cbBmi;
	[helpstring("Offset to the bitmap bits")] DWORD offBits;
	[helpstring("Size of the bitmap bits")] DWORD cbBits;
} EMRCREATEDIBPATTERNBRUSHPT;
'!
!EMRCREATEDIBPATTERNBRUSHPT categoriesForClass!Win32-Structs! !
!EMRCREATEDIBPATTERNBRUSHPT methodsFor!

cbBits
	"Answer the receiver's cbBits field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBits)!

cbBits: anObject 
	"Set the receiver's cbBits field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbBits) put: anObject!

cbBmi
	"Answer the receiver's cbBmi field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbBmi)!

cbBmi: anObject 
	"Set the receiver's cbBmi field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbBmi) put: anObject!

ihBrush
	"Answer the receiver's ihBrush field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ihBrush)!

ihBrush: anObject 
	"Set the receiver's ihBrush field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ihBrush) put: anObject!

iUsage
	"Answer the receiver's iUsage field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iUsage)!

iUsage: anObject 
	"Set the receiver's iUsage field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iUsage) put: anObject!

offBits
	"Answer the receiver's offBits field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #offBits)!

offBits: anObject 
	"Set the receiver's offBits field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #offBits) put: anObject!

offBmi
	"Answer the receiver's offBmi field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #offBmi)!

offBmi: anObject 
	"Set the receiver's offBmi field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #offBmi) put: anObject! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #cbBits!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #cbBits:!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #cbBmi!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #cbBmi:!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #ihBrush!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #ihBrush:!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #iUsage!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #iUsage:!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #offBits!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #offBits:!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #offBmi!**compiled accessors**!public! !
!EMRCREATEDIBPATTERNBRUSHPT categoriesFor: #offBmi:!**compiled accessors**!public! !

!EMRCREATEDIBPATTERNBRUSHPT class methodsFor!

defineFields
	"Define the fields of the EMRCREATEDIBPATTERNBRUSHPT structure.

	EMRCREATEDIBPATTERNBRUSHPT  compileDefinition

		typedef [uuid(AE1203B9-A6B7-4CCA-8FC6-408D43A80C8C)]
		struct tagEMRCREATEDIBPATTERNBRUSHPT {
			EMR EMR;
			[helpstring('Brush handle index')] DWORD ihBrush;
			[helpstring('Bitmap info color table usage')] DWORD iUsage;
			[helpstring('Offset to the BITMAPINFO structure')] DWORD offBmi;
			[helpstring('Size of the BITMAPINFO structure')] DWORD cbBmi;
			[helpstring('Offset to the bitmap bits')] DWORD offBits;
			[helpstring('Size of the bitmap bits')] DWORD cbBits;
		} EMRCREATEDIBPATTERNBRUSHPT;
"

	super defineFields.
	self
		defineField: #ihBrush type: DWORDField new offset: 8;
		defineField: #iUsage type: DWORDField new offset: 12;
		defineField: #offBmi type: DWORDField new offset: 16;
		defineField: #cbBmi type: DWORDField new offset: 20;
		defineField: #offBits type: DWORDField new offset: 24;
		defineField: #cbBits type: DWORDField new offset: 28.
	self byteSize: 32!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_CREATEDIBPATTERNBRUSHPT! !
!EMRCREATEDIBPATTERNBRUSHPT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRCREATEDIBPATTERNBRUSHPT class categoriesFor: #iTypes!constants!public! !

