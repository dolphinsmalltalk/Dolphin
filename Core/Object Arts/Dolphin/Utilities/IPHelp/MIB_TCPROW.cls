"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #MIB_TCPROW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwLocalAddr _OffsetOf_dwLocalPort _OffsetOf_dwRemoteAddr _OffsetOf_dwRemotePort _OffsetOf_dwState'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MIB_TCPROW guid: (GUID fromString: '{f066336f-3aa1-4146-8b59-29b9f4cd065b}')!

MIB_TCPROW addClassConstant: '_OffsetOf_dwLocalAddr' value: 16r4!
MIB_TCPROW addClassConstant: '_OffsetOf_dwLocalPort' value: 16r8!
MIB_TCPROW addClassConstant: '_OffsetOf_dwRemoteAddr' value: 16rC!
MIB_TCPROW addClassConstant: '_OffsetOf_dwRemotePort' value: 16r10!
MIB_TCPROW addClassConstant: '_OffsetOf_dwState' value: 16r0!

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

displayOn: aStream 
	aStream
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

!MIB_TCPROW categoriesForMethods!
displayOn:!public! !
dwLocalAddr!**compiled accessors**!public! !
dwLocalPort!**compiled accessors**!public! !
dwRemoteAddr!**compiled accessors**!public! !
dwRemotePort!**compiled accessors**!public! !
dwState!**compiled accessors**!public! !
port!accessing!public! !
portName!accessing!public! !
!

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

!MIB_TCPROW class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

