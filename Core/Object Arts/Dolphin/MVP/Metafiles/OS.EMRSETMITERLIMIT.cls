"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRSETMITERLIMIT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_EMRSETMITERLIMIT_Size' -> 16rC. '_OffsetOf_eMiterLimit' -> 16r8 }!
OS.EMRSETMITERLIMIT guid: (Core.GUID fromString: '{bc8dabd4-f8b4-4f42-895c-1b712c75fc43}')!
OS.EMRSETMITERLIMIT comment: '<EMRSETMITERLIMIT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETMITERLIMIT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(BC8DABD4-F8B4-4F42-895C-1B712C75FC43)]
struct tagEMRSETMITERLIMIT {
	EMR EMR;
	float eMiterLimit;
} EMRSETMITERLIMIT;
'!
!OS.EMRSETMITERLIMIT categoriesForClass!Win32-Structs! !
!OS.EMRSETMITERLIMIT methodsFor!

eMiterLimit
	"Answer the <Float> value of the receiver's 'eMiterLimit' field."

	^bytes floatAtOffset: _OffsetOf_eMiterLimit!

eMiterLimit: aFloat
	"Set the receiver's 'eMiterLimit' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eMiterLimit put: aFloat! !
!OS.EMRSETMITERLIMIT categoriesForMethods!
eMiterLimit!**compiled accessors**!public! !
eMiterLimit:!**compiled accessors**!public! !
!

!OS.EMRSETMITERLIMIT class methodsFor!

byteSize
	^_EMRSETMITERLIMIT_Size!

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
!OS.EMRSETMITERLIMIT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

