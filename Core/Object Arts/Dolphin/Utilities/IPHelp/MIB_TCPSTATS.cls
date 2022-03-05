"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #MIB_TCPSTATS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwActiveOpens _OffsetOf_dwAttemptFails _OffsetOf_dwCurrEstab _OffsetOf_dwEstabResets _OffsetOf_dwInErrs _OffsetOf_dwInSegs _OffsetOf_dwMaxConn _OffsetOf_dwNumConns _OffsetOf_dwOutRsts _OffsetOf_dwOutSegs _OffsetOf_dwPassiveOpens _OffsetOf_dwRetransSegs _OffsetOf_dwRtoAlgorithm _OffsetOf_dwRtoMax _OffsetOf_dwRtoMin'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_TCPSTATS guid: (GUID fromString: '{99d7d43b-06c6-4c23-813c-06ca8119f081}')!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwActiveOpens' value: 16r10!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwAttemptFails' value: 16r18!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwCurrEstab' value: 16r20!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwEstabResets' value: 16r1C!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwInErrs' value: 16r30!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwInSegs' value: 16r24!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwMaxConn' value: 16rC!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwNumConns' value: 16r38!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwOutRsts' value: 16r34!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwOutSegs' value: 16r28!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwPassiveOpens' value: 16r14!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwRetransSegs' value: 16r2C!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwRtoAlgorithm' value: 16r0!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwRtoMax' value: 16r8!
MIB_TCPSTATS addClassConstant: '_OffsetOf_dwRtoMin' value: 16r4!
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
!MIB_TCPSTATS categoriesForMethods!
dwActiveOpens!**compiled accessors**!public! !
dwAttemptFails!**compiled accessors**!public! !
dwCurrEstab!**compiled accessors**!public! !
dwEstabResets!**compiled accessors**!public! !
dwInErrs!**compiled accessors**!public! !
dwInSegs!**compiled accessors**!public! !
dwMaxConn!**compiled accessors**!public! !
dwNumConns!**compiled accessors**!public! !
dwOutRsts!**compiled accessors**!public! !
dwOutSegs!**compiled accessors**!public! !
dwPassiveOpens!**compiled accessors**!public! !
dwRetransSegs!**compiled accessors**!public! !
dwRtoAlgorithm!**compiled accessors**!public! !
dwRtoMax!**compiled accessors**!public! !
dwRtoMin!**compiled accessors**!public! !
!

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
!MIB_TCPSTATS class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

