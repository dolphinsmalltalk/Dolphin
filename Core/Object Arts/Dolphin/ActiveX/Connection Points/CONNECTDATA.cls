"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #CONNECTDATA
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwCookie _OffsetOf_punk'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CONNECTDATA guid: (GUID fromString: '{3438d2e1-01d6-446c-8102-5f238099585d}')!

CONNECTDATA addClassConstant: '_OffsetOf_dwCookie' value: 16r4!
CONNECTDATA addClassConstant: '_OffsetOf_punk' value: 16r0!

CONNECTDATA comment: '<CONNECTDATA> is an <ExternalStructure> class to wrap the struct ''OBJIDL.CONNECTDATA'' from type information in the ''ObjIDL Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!

!CONNECTDATA categoriesForClass!No category! !

!CONNECTDATA methodsFor!

dwCookie
	"Answer the <Integer> value of the receiver's 'dwCookie' field."

	^bytes dwordAtOffset: _OffsetOf_dwCookie!

dwCookie: anInteger
	"Set the receiver's 'dwCookie' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwCookie put: anInteger!

punk
	"Answer the <IUnknown> value of the receiver's 'punk' field."

	^IUnknown fromAddress: (bytes intPtrAtOffset: _OffsetOf_punk)!

punk: anIUnknown
	"Set the receiver's 'punk' field to the value of the argument, anIUnknown"

	bytes uintPtrAtOffset: _OffsetOf_punk put: anIUnknown yourAddress! !

!CONNECTDATA categoriesForMethods!
dwCookie!**compiled accessors**!public! !
dwCookie:!**compiled accessors**!public! !
punk!**compiled accessors**!public! !
punk:!**compiled accessors**!public! !
!

!CONNECTDATA class methodsFor!

defineFields
	"Define the fields of the CONNECTDATA structure.
		CONNECTDATA compileDefinition
	
		typedef 		struct tagCONNECTDATA {
			IUnknown* punk;
			unsigned long dwCookie;
		} CONNECTDATA;

	"

	self
		defineField: #punk type: (PointerField type: IUnknown);
		defineField: #dwCookie type: DWORDField new!

getFieldNames
	^#(#punk #dwCookie)! !

!CONNECTDATA class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

