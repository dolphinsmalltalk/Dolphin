"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIB_TCPROW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwLocalAddr' -> 16r4.
		'_OffsetOf_dwLocalPort' -> 16r8.
		'_OffsetOf_dwRemoteAddr' -> 16rC.
		'_OffsetOf_dwRemotePort' -> 16r10.
		'_OffsetOf_dwState' -> 16r0
	}!
MIB_TCPROW guid: (GUID fromString: '{f066336f-3aa1-4146-8b59-29b9f4cd065b}')!
MIB_TCPROW comment: '<MIB_TCPROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_TCPROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_TCPROW {
	unsigned long dwState;
	unsigned long dwLocalAddr;
	unsigned long dwLocalPort;
	unsigned long dwRemoteAddr;
	unsigned long dwRemotePort;
} MIB_TCPROW;
'!
!MIB_TCPROW categoriesForClass!Win32-Structs! !
!MIB_TCPROW methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: self port;
		nextPut: $:;
		display: self portName!

dwLocalAddr
	"Answer the <Integer> value of the receiver's 'dwLocalAddr' field."

	^bytes dwordAtOffset: _OffsetOf_dwLocalAddr!

dwLocalPort
	"Answer the <Integer> value of the receiver's 'dwLocalPort' field."

	^bytes dwordAtOffset: _OffsetOf_dwLocalPort!

dwRemoteAddr
	"Answer the <Integer> value of the receiver's 'dwRemoteAddr' field."

	^bytes dwordAtOffset: _OffsetOf_dwRemoteAddr!

dwRemotePort
	"Answer the <Integer> value of the receiver's 'dwRemotePort' field."

	^bytes dwordAtOffset: _OffsetOf_dwRemotePort!

dwState
	"Answer the <Integer> value of the receiver's 'dwState' field."

	^bytes dwordAtOffset: _OffsetOf_dwState!

port
	^WS2_32Library default htons: self dwLocalPort lowWord!

portName
	| psrvent |
	psrvent := WS2_32Library default getservbyport: self dwLocalPort proto: 'tcp'.
	^psrvent isNull ifFalse: [psrvent s_name]! !
!MIB_TCPROW categoriesFor: #displayOn:!public! !
!MIB_TCPROW categoriesFor: #dwLocalAddr!**compiled accessors**!public! !
!MIB_TCPROW categoriesFor: #dwLocalPort!**compiled accessors**!public! !
!MIB_TCPROW categoriesFor: #dwRemoteAddr!**compiled accessors**!public! !
!MIB_TCPROW categoriesFor: #dwRemotePort!**compiled accessors**!public! !
!MIB_TCPROW categoriesFor: #dwState!**compiled accessors**!public! !
!MIB_TCPROW categoriesFor: #port!accessing!public! !
!MIB_TCPROW categoriesFor: #portName!accessing!public! !

!MIB_TCPROW class methodsFor!

defineFields
	"Define the fields of the MIB_TCPROW structure.
		MIB_TCPROW compileDefinition
	
		typedef 
		struct tagMIB_TCPROW {
			unsigned long dwState;
			unsigned long dwLocalAddr;
			unsigned long dwLocalPort;
			unsigned long dwRemoteAddr;
			unsigned long dwRemotePort;
		} MIB_TCPROW;
"

	self
		defineField: #dwState
			type: DWORDField readOnly
			offset: 0;
		defineField: #dwLocalAddr
			type: DWORDField readOnly
			offset: 4;
		defineField: #dwLocalPort
			type: DWORDField readOnly
			offset: 8;
		defineField: #dwRemoteAddr
			type: DWORDField readOnly
			offset: 12;
		defineField: #dwRemotePort
			type: DWORDField readOnly
			offset: 16.
	self byteSize: 20!

getFieldNames
	^#(#dwState #dwLocalAddr #dwLocalPort #dwRemoteAddr #dwRemotePort)! !
!MIB_TCPROW class categoriesFor: #defineFields!initializing!public! !
!MIB_TCPROW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

