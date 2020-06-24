"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETMITERLIMIT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_eMiterLimit'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETMITERLIMIT guid: (GUID fromString: '{bc8dabd4-f8b4-4f42-895c-1b712c75fc43}')!
EMRSETMITERLIMIT addClassConstant: '_OffsetOf_eMiterLimit' value: 16r8!
EMRSETMITERLIMIT comment: '<EMRSETMITERLIMIT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETMITERLIMIT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(BC8DABD4-F8B4-4F42-895C-1B712C75FC43)]
struct tagEMRSETMITERLIMIT {
	EMR EMR;
	float eMiterLimit;
} EMRSETMITERLIMIT;
'!
!EMRSETMITERLIMIT categoriesForClass!Win32-Structs! !
!EMRSETMITERLIMIT methodsFor!

eMiterLimit
	"Answer the <Float> value of the receiver's 'eMiterLimit' field."

	^bytes floatAtOffset: _OffsetOf_eMiterLimit!

eMiterLimit: aFloat
	"Set the receiver's 'eMiterLimit' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eMiterLimit put: aFloat! !
!EMRSETMITERLIMIT categoriesFor: #eMiterLimit!**compiled accessors**!public! !
!EMRSETMITERLIMIT categoriesFor: #eMiterLimit:!**compiled accessors**!public! !

!EMRSETMITERLIMIT class methodsFor!

defineFields
	"Define the fields of the EMRSETMITERLIMIT structure.

	EMRSETMITERLIMIT  compileDefinition

		typedef [uuid(BC8DABD4-F8B4-4F42-895C-1B712C75FC43)]
		struct tagEMRSETMITERLIMIT {
			EMR EMR;
			float eMiterLimit;
		} EMRSETMITERLIMIT;
"

	super defineFields.
	self
		defineField: #eMiterLimit
			type: FLOATField new
			offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #eMiterLimit)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETMITERLIMIT}! !
!EMRSETMITERLIMIT class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRSETMITERLIMIT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSETMITERLIMIT class categoriesFor: #iTypes!constants!public! !

