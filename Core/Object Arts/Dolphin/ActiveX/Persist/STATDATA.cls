"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #STATDATA
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_advf _OffsetOf_dwConnection _OffsetOf_formatetc _OffsetOf_pAdvSink'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STATDATA guid: (GUID fromString: '{25f9c177-b0f1-4161-87a4-188c3de0b3e4}')!
STATDATA addClassConstant: '_OffsetOf_advf' value: 16r14!
STATDATA addClassConstant: '_OffsetOf_dwConnection' value: 16r1C!
STATDATA addClassConstant: '_OffsetOf_formatetc' value: 16r0!
STATDATA addClassConstant: '_OffsetOf_pAdvSink' value: 16r18!
STATDATA comment: '<STATDATA> is an <ExternalStructure> class to wrap the struct ''OCIDL.STATDATA'' from type information in the ''OCIDL Library'' library.

The type library contains no documentation for this struct

WARNING: This comment was automatically generated from the struct''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!STATDATA categoriesForClass!External-Data-Structured-COM! !
!STATDATA methodsFor!

advf
	"Answer the <Integer> value of the receiver's 'advf' field."

	^bytes dwordAtOffset: _OffsetOf_advf!

advf: anInteger
	"Set the receiver's 'advf' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_advf put: anInteger!

dwConnection
	"Answer the <Integer> value of the receiver's 'dwConnection' field."

	^bytes dwordAtOffset: _OffsetOf_dwConnection!

dwConnection: anInteger
	"Set the receiver's 'dwConnection' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwConnection put: anInteger!

formatetc
	"Answer the <FORMATETC> value of the receiver's 'formatetc' field."

	^FORMATETC fromAddress: bytes yourAddress!

formatetc: aFORMATETC
	"Set the receiver's 'formatetc' field to the value of the argument, aFORMATETC"

	aFORMATETC
		replaceBytesOf: bytes
		from: ##(_OffsetOf_formatetc + 1)
		to: ##(_OffsetOf_formatetc + FORMATETC basicByteSize)
		startingAt: 1!

pAdvSink
	"Answer the <IAdviseSink> value of the receiver's 'pAdvSink' field."

	^IAdviseSink fromAddress: (bytes intPtrAtOffset: _OffsetOf_pAdvSink)!

pAdvSink: anIAdviseSink
	"Set the receiver's 'pAdvSink' field to the value of the argument, anIAdviseSink"

	bytes uintPtrAtOffset: _OffsetOf_pAdvSink put: anIAdviseSink yourAddress! !
!STATDATA categoriesForMethods!
advf!**compiled accessors**!public! !
advf:!**compiled accessors**!public! !
dwConnection!**compiled accessors**!public! !
dwConnection:!**compiled accessors**!public! !
formatetc!**compiled accessors**!public! !
formatetc:!**compiled accessors**!public! !
pAdvSink!**compiled accessors**!public! !
pAdvSink:!**compiled accessors**!public! !
!

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
		defineField: #dwConnection type: DWORDField new!

getFieldNames
	^#(#formatetc #advf #pAdvSink #dwConnection)! !
!STATDATA class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

