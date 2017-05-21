"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #STATPROPSTG
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STATPROPSTG guid: (GUID fromString: '{485d4e8d-124f-443d-8eea-b20ddc264f6e}')!
STATPROPSTG comment: '<STATPROPSTG> is an <ExternalStructure> class to wrap the struct ''OBJIDL.STATPROPSTG'' from type information in the ''ObjIDL Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef struct tagSTATPROPSTG {
	LPWSTR lpwstrName;
	unsigned long propid;
	unsigned short vt;
} STATPROPSTG;
'!
!STATPROPSTG categoriesForClass!OBJIDL-Structs! !
!STATPROPSTG methodsFor!

lpwstrName
	"Answer the receiver's lpwstrName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: 0)!

lpwstrName: anObject 
	"Set the receiver's lpwstrName field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress!

propid
	"Answer the receiver's propid field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #propid)!

propid: anObject 
	"Set the receiver's propid field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #propid) put: anObject!

vt
	"Answer the receiver's vt field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #vt)!

vt: anObject 
	"Set the receiver's vt field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #vt) put: anObject! !
!STATPROPSTG categoriesFor: #lpwstrName!**compiled accessors**!public! !
!STATPROPSTG categoriesFor: #lpwstrName:!**compiled accessors**!public! !
!STATPROPSTG categoriesFor: #propid!**compiled accessors**!public! !
!STATPROPSTG categoriesFor: #propid:!**compiled accessors**!public! !
!STATPROPSTG categoriesFor: #vt!**compiled accessors**!public! !
!STATPROPSTG categoriesFor: #vt:!**compiled accessors**!public! !

!STATPROPSTG class methodsFor!

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
		defineField: #lpwstrName type: (PointerField type: UnicodeString);
		defineField: #propid type: DWORDField new;
		defineField: #vt type: WORDField new! !
!STATPROPSTG class categoriesFor: #defineFields!**auto generated**!initializing!public! !

