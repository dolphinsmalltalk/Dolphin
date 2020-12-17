"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIB_TCPSTATS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwActiveOpens' -> 16r10.
		'_OffsetOf_dwAttemptFails' -> 16r18.
		'_OffsetOf_dwCurrEstab' -> 16r20.
		'_OffsetOf_dwEstabResets' -> 16r1C.
		'_OffsetOf_dwInErrs' -> 16r30.
		'_OffsetOf_dwInSegs' -> 16r24.
		'_OffsetOf_dwMaxConn' -> 16rC.
		'_OffsetOf_dwNumConns' -> 16r38.
		'_OffsetOf_dwOutRsts' -> 16r34.
		'_OffsetOf_dwOutSegs' -> 16r28.
		'_OffsetOf_dwPassiveOpens' -> 16r14.
		'_OffsetOf_dwRetransSegs' -> 16r2C.
		'_OffsetOf_dwRtoAlgorithm' -> 16r0.
		'_OffsetOf_dwRtoMax' -> 16r8.
		'_OffsetOf_dwRtoMin' -> 16r4
	}!
MIB_TCPSTATS guid: (GUID fromString: '{99d7d43b-06c6-4c23-813c-06ca8119f081}')!
MIB_TCPSTATS comment: '<MIB_TCPSTATS> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_TCPSTATS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_TCPSTATS {
	unsigned long dwRtoAlgorithm;
	unsigned long dwRtoMin;
	unsigned long dwRtoMax;
	unsigned long dwMaxConn;
	unsigned long dwActiveOpens;
	unsigned long dwPassiveOpens;
	unsigned long dwAttemptFails;
	unsigned long dwEstabResets;
	unsigned long dwCurrEstab;
	unsigned long dwInSegs;
	unsigned long dwOutSegs;
	unsigned long dwRetransSegs;
	unsigned long dwInErrs;
	unsigned long dwOutRsts;
	unsigned long dwNumConns;
} MIB_TCPSTATS;
'!
!MIB_TCPSTATS categoriesForClass!Win32-Structs! !
!MIB_TCPSTATS methodsFor!

dwActiveOpens
	"Answer the <Integer> value of the receiver's 'dwActiveOpens' field."

	^bytes dwordAtOffset: _OffsetOf_dwActiveOpens!

dwAttemptFails
	"Answer the <Integer> value of the receiver's 'dwAttemptFails' field."

	^bytes dwordAtOffset: _OffsetOf_dwAttemptFails!

dwCurrEstab
	"Answer the <Integer> value of the receiver's 'dwCurrEstab' field."

	^bytes dwordAtOffset: _OffsetOf_dwCurrEstab!

dwEstabResets
	"Answer the <Integer> value of the receiver's 'dwEstabResets' field."

	^bytes dwordAtOffset: _OffsetOf_dwEstabResets!

dwInErrs
	"Answer the <Integer> value of the receiver's 'dwInErrs' field."

	^bytes dwordAtOffset: _OffsetOf_dwInErrs!

dwInSegs
	"Answer the <Integer> value of the receiver's 'dwInSegs' field."

	^bytes dwordAtOffset: _OffsetOf_dwInSegs!

dwMaxConn
	"Answer the <Integer> value of the receiver's 'dwMaxConn' field."

	^bytes dwordAtOffset: _OffsetOf_dwMaxConn!

dwNumConns
	"Answer the <Integer> value of the receiver's 'dwNumConns' field."

	^bytes dwordAtOffset: _OffsetOf_dwNumConns!

dwOutRsts
	"Answer the <Integer> value of the receiver's 'dwOutRsts' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutRsts!

dwOutSegs
	"Answer the <Integer> value of the receiver's 'dwOutSegs' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutSegs!

dwPassiveOpens
	"Answer the <Integer> value of the receiver's 'dwPassiveOpens' field."

	^bytes dwordAtOffset: _OffsetOf_dwPassiveOpens!

dwRetransSegs
	"Answer the <Integer> value of the receiver's 'dwRetransSegs' field."

	^bytes dwordAtOffset: _OffsetOf_dwRetransSegs!

dwRtoAlgorithm
	"Answer the <Integer> value of the receiver's 'dwRtoAlgorithm' field."

	^bytes dwordAtOffset: _OffsetOf_dwRtoAlgorithm!

dwRtoMax
	"Answer the <Integer> value of the receiver's 'dwRtoMax' field."

	^bytes dwordAtOffset: _OffsetOf_dwRtoMax!

dwRtoMin
	"Answer the <Integer> value of the receiver's 'dwRtoMin' field."

	^bytes dwordAtOffset: _OffsetOf_dwRtoMin! !
!MIB_TCPSTATS categoriesFor: #dwActiveOpens!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwAttemptFails!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwCurrEstab!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwEstabResets!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwInErrs!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwInSegs!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwMaxConn!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwNumConns!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwOutRsts!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwOutSegs!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwPassiveOpens!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwRetransSegs!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwRtoAlgorithm!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwRtoMax!**compiled accessors**!public! !
!MIB_TCPSTATS categoriesFor: #dwRtoMin!**compiled accessors**!public! !

!MIB_TCPSTATS class methodsFor!

defineFields
	"Define the fields of the MIB_TCPSTATS structure.
		MIB_TCPSTATS compileDefinition
	
		typedef 
		struct tagMIB_TCPSTATS {
			unsigned long dwRtoAlgorithm;
			unsigned long dwRtoMin;
			unsigned long dwRtoMax;
			unsigned long dwMaxConn;
			unsigned long dwActiveOpens;
			unsigned long dwPassiveOpens;
			unsigned long dwAttemptFails;
			unsigned long dwEstabResets;
			unsigned long dwCurrEstab;
			unsigned long dwInSegs;
			unsigned long dwOutSegs;
			unsigned long dwRetransSegs;
			unsigned long dwInErrs;
			unsigned long dwOutRsts;
			unsigned long dwNumConns;
		} MIB_TCPSTATS;
"

	self
		defineField: #dwRtoAlgorithm
			type: DWORDField readOnly
			offset: 0;
		defineField: #dwRtoMin
			type: DWORDField readOnly
			offset: 4;
		defineField: #dwRtoMax
			type: DWORDField readOnly
			offset: 8;
		defineField: #dwMaxConn
			type: DWORDField readOnly
			offset: 12;
		defineField: #dwActiveOpens
			type: DWORDField readOnly
			offset: 16;
		defineField: #dwPassiveOpens
			type: DWORDField readOnly
			offset: 20;
		defineField: #dwAttemptFails
			type: DWORDField readOnly
			offset: 24;
		defineField: #dwEstabResets
			type: DWORDField readOnly
			offset: 28;
		defineField: #dwCurrEstab
			type: DWORDField readOnly
			offset: 32;
		defineField: #dwInSegs
			type: DWORDField readOnly
			offset: 36;
		defineField: #dwOutSegs
			type: DWORDField readOnly
			offset: 40;
		defineField: #dwRetransSegs
			type: DWORDField readOnly
			offset: 44;
		defineField: #dwInErrs
			type: DWORDField readOnly
			offset: 48;
		defineField: #dwOutRsts
			type: DWORDField readOnly
			offset: 52;
		defineField: #dwNumConns
			type: DWORDField readOnly
			offset: 56.
	self byteSize: 60!

getFieldNames
	^#(#dwRtoAlgorithm #dwRtoMin #dwRtoMax #dwMaxConn #dwActiveOpens #dwPassiveOpens #dwAttemptFails #dwEstabResets #dwCurrEstab #dwInSegs #dwOutSegs #dwRetransSegs #dwInErrs #dwOutRsts #dwNumConns)! !
!MIB_TCPSTATS class categoriesFor: #defineFields!initializing!public! !
!MIB_TCPSTATS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

