"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #CONNECTDATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwCookie' -> 16r4.
		'_OffsetOf_punk' -> 16r0
	}!
CONNECTDATA guid: (GUID fromString: '{3438d2e1-01d6-446c-8102-5f238099585d}')!
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
!CONNECTDATA categoriesFor: #dwCookie!**compiled accessors**!public! !
!CONNECTDATA categoriesFor: #dwCookie:!**compiled accessors**!public! !
!CONNECTDATA categoriesFor: #punk!**compiled accessors**!public! !
!CONNECTDATA categoriesFor: #punk:!**compiled accessors**!public! !

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
!CONNECTDATA class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!CONNECTDATA class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

