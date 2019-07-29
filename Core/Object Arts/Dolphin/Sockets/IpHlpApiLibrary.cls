"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #IpHlpApiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WinSocketConstants'
	classInstanceVariableNames: ''!
IpHlpApiLibrary guid: (GUID fromString: '{a63698ae-5cef-4f53-bf10-c4a77a8b979a}')!
IpHlpApiLibrary comment: 'IpHlpApiLibrary is the <ExternalLibrary> class to represent the dynamic link library, ''Iphlpapi.DLL''.It was generated generated from type information in the ''Win32 API'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring for this module
	"The Internet Protocol Helper (IP Helper) API enables the retrieval and modification of network configuration settings for the local computer."'!
!IpHlpApiLibrary categoriesForClass!Win32-Modules! !
!IpHlpApiLibrary methodsFor!

parseNetworkString: networkString types: types addressInfo: addressInfo portNumber: portNumber prefixLength: prefixLength
	"Invoke the ParseNetworkString() function of the module wrapped by the receiver.
	Helpstring: Parses the input network string and checks whether it is a legal representation of the specified IP network string type. If the string matches a type and its specification, the function can optionally return the parsed result.

		unsigned long __stdcall ParseNetworkString(
			LPCWSTR NetworkString,
			unsigned long Types,
			PNET_ADDRESS_INFO AddressInfo,
			unsigned short* PortNumber,
			BYTE* PrefixLength);"

	<stdcall: dword ParseNetworkString lpwstr dword NET_ADDRESS_INFO* word* byte*>
	^self invalidCall: _failureCode! !
!IpHlpApiLibrary categoriesFor: #parseNetworkString:types:addressInfo:portNumber:prefixLength:!**auto generated**!public! !

!IpHlpApiLibrary class methodsFor!

fileName
	"Answer the host system file name for the library."

	^'Iphlpapi'
! !
!IpHlpApiLibrary class categoriesFor: #fileName!**auto generated**!constants!public! !

