"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #PROPSPEC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PROPSPEC guid: (GUID fromString: '{25EB5BE3-CA5D-49BC-8359-1D1EFA196BC5}')!
PROPSPEC comment: '<PROPSPEC> is an <ExternalStructure> class to wrap the OLE Property Set structure  of the same name.
'!
!PROPSPEC categoriesForClass!OBJIDL-Structs! !
!PROPSPEC methodsFor!

lpwstr
	"Answer the receiver's lpwstr field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpwstr))!

lpwstr: anObject 
	"Set the receiver's lpwstr field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpwstr) put: anObject yourAddress!

propid
	"Answer the receiver's propid field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #propid)!

propid: anObject 
	"Set the receiver's propid field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #propid) put: anObject!

ulKind
	"Answer the receiver's ulKind field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

ulKind: anObject 
	"Set the receiver's ulKind field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!PROPSPEC categoriesFor: #lpwstr!**compiled accessors**!public! !
!PROPSPEC categoriesFor: #lpwstr:!**compiled accessors**!public! !
!PROPSPEC categoriesFor: #propid!**compiled accessors**!public! !
!PROPSPEC categoriesFor: #propid:!**compiled accessors**!public! !
!PROPSPEC categoriesFor: #ulKind!**compiled accessors**!public! !
!PROPSPEC categoriesFor: #ulKind:!**compiled accessors**!public! !

!PROPSPEC class methodsFor!

defineFields
	"Define the fields of the PROPSPEC structure.
		PROPSPEC compileDefinition
	
		typedef 		struct tagPROPSPEC {
			unsigned long ulKind;
			union {
				PROPID propid;
				LPOLESTR lpwstr;
				};
		} PROPSPEC;

	"

	self
		defineField: #ulKind type: DWORDField new;
		defineField: #propid type: DWORDField new.
	"Note the Union"
	self 
		defineField: #lpwstr
		type: (PointerField type: UnicodeString)
		offset: (self offsetOf: #propid)! !
!PROPSPEC class categoriesFor: #defineFields!initializing!public! !

