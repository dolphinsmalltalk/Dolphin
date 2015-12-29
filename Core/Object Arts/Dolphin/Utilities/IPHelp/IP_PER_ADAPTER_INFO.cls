"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #IP_PER_ADAPTER_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IP_PER_ADAPTER_INFO guid: (GUID fromString: '{E2022105-D714-4780-A2DC-5DB76307F035}')!
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
	"Answer the receiver's AutoconfigActive field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

AutoconfigEnabled
	"Answer the receiver's AutoconfigEnabled field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

CurrentDnsServer
	"Answer the receiver's CurrentDnsServer field as a Smalltalk object."

	^IP_ADDR_STRING fromAddress: (bytes sdwordAtOffset: 8)!

DnsServerList
	"Answer the receiver's DnsServerList field as a Smalltalk object."

	^IP_ADDR_STRING fromAddress: (bytes yourAddress + 12)! !
!IP_PER_ADAPTER_INFO categoriesFor: #AutoconfigActive!**compiled accessors**!public! !
!IP_PER_ADAPTER_INFO categoriesFor: #AutoconfigEnabled!**compiled accessors**!public! !
!IP_PER_ADAPTER_INFO categoriesFor: #CurrentDnsServer!**compiled accessors**!public! !
!IP_PER_ADAPTER_INFO categoriesFor: #DnsServerList!**compiled accessors**!public! !

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
	self byteSize: 52! !
!IP_PER_ADAPTER_INFO class categoriesFor: #defineFields!initializing!public! !

