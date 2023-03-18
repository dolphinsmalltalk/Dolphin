"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.IP_PER_ADAPTER_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_IP_PER_ADAPTER_INFO_Size' -> 16r34.
		'_OffsetOf_AutoconfigActive' -> 16r4.
		'_OffsetOf_AutoconfigEnabled' -> 16r0.
		'_OffsetOf_CurrentDnsServer' -> 16r8.
		'_OffsetOf_DnsServerList' -> 16rC
	}!
OS.IP_PER_ADAPTER_INFO guid: (Core.GUID fromString: '{e2022105-d714-4780-a2dc-5db76307f035}')!
OS.IP_PER_ADAPTER_INFO comment: '<IP_PER_ADAPTER_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.IP_PER_ADAPTER_INFO'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.IP_PER_ADAPTER_INFO categoriesForClass!Win32-Structs! !
!OS.IP_PER_ADAPTER_INFO methodsFor!

AutoconfigActive
	"Answer the <Integer> value of the receiver's 'AutoconfigActive' field."

	^bytes uint32AtOffset: _OffsetOf_AutoconfigActive!

AutoconfigEnabled
	"Answer the <Integer> value of the receiver's 'AutoconfigEnabled' field."

	^bytes uint32AtOffset: _OffsetOf_AutoconfigEnabled!

CurrentDnsServer
	"Answer the <IP_ADDR_STRING> value of the receiver's 'CurrentDnsServer' field."

	^IP_ADDR_STRING fromAddress: (bytes intPtrAtOffset: _OffsetOf_CurrentDnsServer)!

DnsServerList
	"Answer the <IP_ADDR_STRING> value of the receiver's 'DnsServerList' field."

	^IP_ADDR_STRING fromAddress: bytes yourAddress + _OffsetOf_DnsServerList! !
!OS.IP_PER_ADAPTER_INFO categoriesForMethods!
AutoconfigActive!**compiled accessors**!public! !
AutoconfigEnabled!**compiled accessors**!public! !
CurrentDnsServer!**compiled accessors**!public! !
DnsServerList!**compiled accessors**!public! !
!

!OS.IP_PER_ADAPTER_INFO class methodsFor!

byteSize
	^_IP_PER_ADAPTER_INFO_Size!

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
			type: UInt32Field readOnly
			offset: 0;
		defineField: #AutoconfigActive
			type: UInt32Field readOnly
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
!OS.IP_PER_ADAPTER_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

