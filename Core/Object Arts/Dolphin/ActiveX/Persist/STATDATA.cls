"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #STATDATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STATDATA guid: (GUID fromString: '{25f9c177-b0f1-4161-87a4-188c3de0b3e4}')!
STATDATA comment: '<STATDATA> is an <ExternalStructure> class to wrap the struct ''OCIDL.STATDATA'' from type information in the ''OCIDL Library'' library.

The type library contains no documentation for this struct

WARNING: This comment was automatically generated from the struct''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!STATDATA categoriesForClass!No category! !
!STATDATA methodsFor!

advf
	"Answer the receiver's advf field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #advf)!

advf: anObject 
	"Set the receiver's advf field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #advf) put: anObject!

dwConnection
	"Answer the receiver's dwConnection field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwConnection)!

dwConnection: anObject 
	"Set the receiver's dwConnection field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwConnection) put: anObject!

formatetc
	"Answer the receiver's formatetc field as a Smalltalk object."

	^FORMATETC fromAddress: bytes yourAddress!

formatetc: anObject 
	"Set the receiver's formatetc field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: 1
		to: ##(FORMATETC basicByteSize)
		startingAt: 1!

pAdvSink
	"Answer the receiver's pAdvSink field as a Smalltalk object."

	^IAdviseSink fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pAdvSink))!

pAdvSink: anObject 
	"Set the receiver's pAdvSink field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pAdvSink) put: anObject yourAddress! !
!STATDATA categoriesFor: #advf!**compiled accessors**!public! !
!STATDATA categoriesFor: #advf:!**compiled accessors**!public! !
!STATDATA categoriesFor: #dwConnection!**compiled accessors**!public! !
!STATDATA categoriesFor: #dwConnection:!**compiled accessors**!public! !
!STATDATA categoriesFor: #formatetc!**compiled accessors**!public! !
!STATDATA categoriesFor: #formatetc:!**compiled accessors**!public! !
!STATDATA categoriesFor: #pAdvSink!**compiled accessors**!public! !
!STATDATA categoriesFor: #pAdvSink:!**compiled accessors**!public! !

!STATDATA class methodsFor!

defineFields
	"Define the fields of the STATDATA 'structure'.

		STATDATA compileDefinition

		typedef struct  tagSTATDATA
		{
			FORMATETC formatetc;
			DWORD advf;
			/* [unique] */ IAdviseSink __RPC_FAR *pAdvSink;
			DWORD dwConnection;
		}	STATDATA;"

	self
		defineField: #formatetc type: (StructureField type: FORMATETC);
		defineField: #advf type: DWORDField new;
		defineField: #pAdvSink type: (PointerField type: IAdviseSink);
		defineField: #dwConnection type: DWORDField new! !
!STATDATA class categoriesFor: #defineFields!initializing!public! !

