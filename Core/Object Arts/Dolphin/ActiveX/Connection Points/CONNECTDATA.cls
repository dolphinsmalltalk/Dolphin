"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #CONNECTDATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CONNECTDATA guid: (GUID fromString: '{3438D2E1-01D6-446C-8102-5F238099585D}')!
CONNECTDATA comment: '<CONNECTDATA> is an <ExternalStructure> class to wrap the struct ''OBJIDL.CONNECTDATA'' from type information in the ''ObjIDL Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CONNECTDATA categoriesForClass!No category! !
!CONNECTDATA methodsFor!

dwCookie
	"Answer the receiver's dwCookie field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

dwCookie: anObject
	"Set the receiver's dwCookie field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

punk
	"Answer the receiver's punk field as a Smalltalk object."

	^IUnknown fromAddress: (bytes intPtrAtOffset: 0)!

punk: anObject 
	"Set the receiver's punk field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress! !
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
		defineField: #dwCookie type: DWORDField new! !
!CONNECTDATA class categoriesFor: #defineFields!**auto generated**!initializing!public! !

