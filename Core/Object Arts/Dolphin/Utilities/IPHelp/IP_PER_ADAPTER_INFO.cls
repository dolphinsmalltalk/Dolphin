"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #IP_PER_ADAPTER_INFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_AutoconfigActive _OffsetOf_AutoconfigEnabled _OffsetOf_CurrentDnsServer _OffsetOf_DnsServerList'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IP_PER_ADAPTER_INFO guid: (GUID fromString: '{e2022105-d714-4780-a2dc-5db76307f035}')!

IP_PER_ADAPTER_INFO addClassConstant: '_OffsetOf_AutoconfigActive' value: 16r4!
IP_PER_ADAPTER_INFO addClassConstant: '_OffsetOf_AutoconfigEnabled' value: 16r0!
IP_PER_ADAPTER_INFO addClassConstant: '_OffsetOf_CurrentDnsServer' value: 16r8!
IP_PER_ADAPTER_INFO addClassConstant: '_OffsetOf_DnsServerList' value: 16rC!

IP_PER_ADAPTER_INFO comment: '<IP_PER_ADAPTER_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.IP_PER_ADAPTER_INFO'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagIP_PER_ADAPTER_INFO {
	unsigned int AutoconfigEnabled;
	unsigned int AutoconfigActive;
	IP_ADDR_STRING* CurrentDnsServer;
	IP_ADDR_STRING DnsServerList;
} IP_PER_ADAPTER_INFO;
'!

!IP_PER_ADAPTER_INFO categoriesForClass!Win32-Structs! !

!IP_PER_ADAPTER_INFO methodsFor!

AutoconfigActive
	"Answer the <Integer> value of the receiver's 'AutoconfigActive' field."

	^bytes dwordAtOffset: _OffsetOf_AutoconfigActive!

AutoconfigEnabled
	"Answer the <Integer> value of the receiver's 'AutoconfigEnabled' field."

	^bytes dwordAtOffset: _OffsetOf_AutoconfigEnabled!

CurrentDnsServer
	"Answer the <IP_ADDR_STRING> value of the receiver's 'CurrentDnsServer' field."

	^IP_ADDR_STRING fromAddress: (bytes intPtrAtOffset: _OffsetOf_CurrentDnsServer)!

DnsServerList
	"Answer the <IP_ADDR_STRING> value of the receiver's 'DnsServerList' field."

	^IP_ADDR_STRING fromAddress: bytes yourAddress + _OffsetOf_DnsServerList! !

!IP_PER_ADAPTER_INFO categoriesForMethods!
AutoconfigActive!**compiled accessors**!public! !
AutoconfigEnabled!**compiled accessors**!public! !
CurrentDnsServer!**compiled accessors**!public! !
DnsServerList!**compiled accessors**!public! !
!

!IP_PER_ADAPTER_INFO class methodsFor!

defineFields
	"Define the fields of the IP_PER_ADAPTER_INFO structure.
		IP_PER_ADAPTER_INFO compileDefinition
	
		typedef 
		struct tagIP_PER_ADAPTER_INFO {
			unsigned int AutoconfigEnabled;
			unsigned int AutoconfigActive;
			IP_ADDR_STRING* CurrentDnsServer;
			IP_ADDR_STRING DnsServerList;
		} IP_PER_ADAPTER_INFO;
"

	self
		defineField: #AutoconfigEnabled
			type: DWORDField readOnly
			offset: 0;
		defineField: #AutoconfigActive
			type: DWORDField readOnly
			offset: 4;
		defineField: #CurrentDnsServer
			type: ((PointerField type: IP_ADDR_STRING)
					beReadOnly;
					yourself)
			offset: 8;
		defineField: #DnsServerList
			type: ((StructureField type: IP_ADDR_STRING)
					beReadOnly;
					yourself)
			offset: 12.
	self byteSize: 52!

getFieldNames
	^#(#AutoconfigEnabled #AutoconfigActive #CurrentDnsServer #DnsServerList)! !

!IP_PER_ADAPTER_INFO class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

