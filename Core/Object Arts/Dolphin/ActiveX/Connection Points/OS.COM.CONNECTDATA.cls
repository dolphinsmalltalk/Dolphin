"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.CONNECTDATA'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwCookie' -> 16r4.
		'_OffsetOf_punk' -> 16r0
	}!
OS.COM.CONNECTDATA guid: (Core.GUID fromString: '{3438d2e1-01d6-446c-8102-5f238099585d}')!
OS.COM.CONNECTDATA comment: '<CONNECTDATA> is an <ExternalStructure> class to wrap the struct ''OBJIDL.CONNECTDATA'' from type information in the ''ObjIDL Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!OS.COM.CONNECTDATA categoriesForClass!No category! !
!OS.COM.CONNECTDATA methodsFor!

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
!OS.COM.CONNECTDATA categoriesFor: #dwCookie!**compiled accessors**!public! !
!OS.COM.CONNECTDATA categoriesFor: #dwCookie:!**compiled accessors**!public! !
!OS.COM.CONNECTDATA categoriesFor: #punk!**compiled accessors**!public! !
!OS.COM.CONNECTDATA categoriesFor: #punk:!**compiled accessors**!public! !

!OS.COM.CONNECTDATA class methodsFor!

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
!OS.COM.CONNECTDATA class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.COM.CONNECTDATA class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

