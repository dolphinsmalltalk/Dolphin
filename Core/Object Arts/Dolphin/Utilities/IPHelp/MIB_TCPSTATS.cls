"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #MIB_TCPSTATS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_TCPSTATS guid: (GUID fromString: '{99D7D43B-06C6-4C23-813C-06CA8119F081}')!
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
	"Answer the receiver's dwActiveOpens field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

dwAttemptFails
	"Answer the receiver's dwAttemptFails field as a Smalltalk object."

	^(bytes dwordAtOffset: 24)!

dwCurrEstab
	"Answer the receiver's dwCurrEstab field as a Smalltalk object."

	^(bytes dwordAtOffset: 32)!

dwEstabResets
	"Answer the receiver's dwEstabResets field as a Smalltalk object."

	^(bytes dwordAtOffset: 28)!

dwInErrs
	"Answer the receiver's dwInErrs field as a Smalltalk object."

	^(bytes dwordAtOffset: 48)!

dwInSegs
	"Answer the receiver's dwInSegs field as a Smalltalk object."

	^(bytes dwordAtOffset: 36)!

dwMaxConn
	"Answer the receiver's dwMaxConn field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

dwNumConns
	"Answer the receiver's dwNumConns field as a Smalltalk object."

	^(bytes dwordAtOffset: 56)!

dwOutRsts
	"Answer the receiver's dwOutRsts field as a Smalltalk object."

	^(bytes dwordAtOffset: 52)!

dwOutSegs
	"Answer the receiver's dwOutSegs field as a Smalltalk object."

	^(bytes dwordAtOffset: 40)!

dwPassiveOpens
	"Answer the receiver's dwPassiveOpens field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)!

dwRetransSegs
	"Answer the receiver's dwRetransSegs field as a Smalltalk object."

	^(bytes dwordAtOffset: 44)!

dwRtoAlgorithm
	"Answer the receiver's dwRtoAlgorithm field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

dwRtoMax
	"Answer the receiver's dwRtoMax field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

dwRtoMin
	"Answer the receiver's dwRtoMin field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)! !
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
	self byteSize: 60! !
!MIB_TCPSTATS class categoriesFor: #defineFields!initializing!public! !

