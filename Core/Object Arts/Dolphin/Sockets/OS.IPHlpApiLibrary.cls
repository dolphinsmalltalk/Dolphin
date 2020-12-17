"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'OS.IPHlpApiLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.IPHlpApiLibrary guid: (Core.GUID fromString: '{a63698ae-5cef-4f53-bf10-c4a77a8b979a}')!
OS.IPHlpApiLibrary comment: 'IPHlpApiLibrary is the <ExternalLibrary> class to represent the dynamic link library, ''iphlpapi.DLL''.It was generated generated from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring for this module
	"IP Helper Library"

Warning: This comment was automatically generated from the module''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	dllname("iphlpapi.DLL"), 
	uuid(A63698AE-5CEF-4F53-BF10-C4A77A8B979A), 
	helpstring("IP Helper Library")
]
module IPHlpApi
{
	[entry(0x60000000)]
	unsigned long __stdcall GetNumberOfInterfaces(
		[out]unsigned long* pdwNumIf);
	[entry(0x60000001)]
	unsigned long __stdcall GetIfEntry(
		[in, out]MIB_IFROW* pIfRow);
	[entry(0x60000002)]
	unsigned long __stdcall GetIfTable(
		[out]MIB_IFTABLE* pIfTable,
		[in, out]unsigned long* pdwSize,
		[in]long bOrder);
	[entry(0x60000003)]
	unsigned long __stdcall GetIpAddrTable(
		[out]MIB_IPADDRTABLE* pIpAddrTable,
		[in, out]unsigned long* pdwSize,
		[in]long bOrder);
	[entry(0x60000004)]
	unsigned long __stdcall GetIpNetTable(
		[out]MIB_IPNETTABLE* pIpNetTable,
		[in, out]unsigned long* pdwSize,
		[in]long bOrder);
	[entry(0x60000005)]
	unsigned long __stdcall GetIpForwardTable(
		[out]MIB_IPFORWARDTABLE* pIpForwardTable,
		[in, out]unsigned long* pdwSize,
		[in]long bOrder);
	[entry(0x60000006)]
	unsigned long __stdcall GetTcpTable(
		[out]MIB_TCPTABLE* pTcpTable,
		[in, out]unsigned long* pdwSize,
		[in]long bOrder);
	[entry(0x60000007)]
	unsigned long __stdcall GetUdpTable(
		[out]MIB_UDPTABLE* pUdpTable,
		[in, out]unsigned long* pdwSize,
		[in]long bOrder);
	[entry(0x60000008)]
	unsigned long __stdcall GetIpStatistics(
		[out]MIB_IPSTATS* pStats);
	[entry(0x60000009)]
	unsigned long __stdcall GetIpStatisticsEx(
		[out]MIB_IPSTATS* pStats,
		[in]unsigned long dwFamily);
	[entry(0x6000000a)]
	unsigned long __stdcall GetIcmpStatistics(
		[out]MIB_ICMP* pStats);
	[entry(0x6000000b)]
	unsigned long __stdcall GetIcmpStatisticsEx(
		[out]MIB_ICMP_EX* pStats,
		[in]unsigned long dwFamily);
	[entry(0x6000000c)]
	unsigned long __stdcall GetTcpStatistics(
		[out]MIB_TCPSTATS* pStats);
	[entry(0x6000000d)]
	unsigned long __stdcall GetTcpStatisticsEx(
		[out]MIB_TCPSTATS* pStats,
		[in]unsigned long dwFamily);
	[entry(0x6000000e)]
	unsigned long __stdcall GetUdpStatistics(
		[out]MIB_UDPSTATS* pStats);
	[entry(0x6000000f)]
	unsigned long __stdcall GetUdpStatisticsEx(
		[out]MIB_UDPSTATS* pStats,
		[in]unsigned long dwFamily);
	[entry(0x60000010)]
	unsigned long __stdcall SetIfEntry(
		[in]MIB_IFROW* pIfRow);
	[entry(0x60000011)]
	unsigned long __stdcall CreateIpForwardEntry(
		[in]MIB_IPFORWARDROW* pRoute);
	[entry(0x60000012)]
	unsigned long __stdcall SetIpForwardEntry(
		[in]MIB_IPFORWARDROW* pRoute);
	[entry(0x60000013)]
	unsigned long __stdcall DeleteIpForwardEntry(
		[in]MIB_IPFORWARDROW* pRoute);
	[entry(0x60000014)]
	unsigned long __stdcall SetIpStatistics(
		[in]MIB_IPSTATS* pIpStats);
	[entry(0x60000015)]
	unsigned long __stdcall SetIpTTL(
		unsigned int nTTL);
	[entry(0x60000016)]
	unsigned long __stdcall CreateIpNetEntry(
		[in]MIB_IPNETROW* pArpEntry);
	[entry(0x60000017)]
	unsigned long __stdcall SetIpNetEntry(
		[in]MIB_IPNETROW* pArpEntry);
	[entry(0x60000018)]
	unsigned long __stdcall DeleteIpNetEntry(
		[in]MIB_IPNETROW* pArpEntry);
	[entry(0x60000019)]
	unsigned long __stdcall FlushIpNetTable(
		[in]unsigned long dwIfIndex);
	[entry(0x6000001a)]
	unsigned long __stdcall CreateProxyArpEntry(
		[in]unsigned long dwAddress,
		[in]unsigned long dwMask,
		[in]unsigned long dwIfIndex);
	[entry(0x6000001b)]
	unsigned long __stdcall DeleteProxyArpEntry(
		[in]unsigned long dwAddress,
		[in]unsigned long dwMask,
		[in]unsigned long dwIfIndex);
	[entry(0x6000001c)]
	unsigned long __stdcall SetTcpEntry(
		[in]MIB_TCPROW* pTcpRow);
	[entry(0x6000001d)]
	unsigned long __stdcall GetInterfaceInfo(
		[in]IP_INTERFACE_INFO* pIfTable,
		[out]unsigned long* dwOutBufLen);
	[entry(0x6000001e)]
	unsigned long __stdcall GetUniDirectionalAdapterInfo(
		[out]IP_UNIDIRECTIONAL_ADAPTER_ADDRESS* pIPIfInfo,
		[out]unsigned long* dwOutBufLen);
	[entry(0x6000001f)]
	unsigned long __stdcall NhpAllocateAndGetInterfaceInfoFromStack(
		[out]ip_interface_name_info** ppTable,
		[out]unsigned long* pdwCount,
		[in]long bOrder,
		[in]long hHeap,
		[in]unsigned long dwFlags);
	[entry(0x60000020)]
	unsigned long __stdcall GetBestInterface(
		[in]unsigned long dwDestAddr,
		[out]unsigned long* pdwBestIfIndex);
	[entry(0x60000021)]
	unsigned long __stdcall GetBestRoute(
		[in]unsigned long dwDestAddr,
		[in]unsigned long dwSourceAddr,
		[out]MIB_IPFORWARDROW* pBestRoute);
	[entry(0x60000022)]
	unsigned long __stdcall NotifyAddrChange(
		[out]long* Handle,
		[in]OVERLAPPED* overlapped);
	[entry(0x60000023)]
	unsigned long __stdcall NotifyRouteChange(
		[out]long* Handle,
		[in]OVERLAPPED* overlapped);
	[entry(0x60000024)]
	long __stdcall CancelIPChangeNotify(
		[in]OVERLAPPED* notifyOverlapped);
	[entry(0x60000025)]
	unsigned long __stdcall GetAdapterIndex(
		[in]LPWSTR AdapterName,
		[out]unsigned long* IfIndex);
	[entry(0x60000026)]
	unsigned long __stdcall AddIPAddress(
		unsigned long Address,
		unsigned long IpMask,
		unsigned long IfIndex,
		unsigned long* NTEContext,
		unsigned long* NTEInstance);
	[entry(0x60000027)]
	unsigned long __stdcall DeleteIPAddress(
		unsigned long NTEContext);
	[entry(0x60000028)]
	unsigned long __stdcall GetNetworkParams(
		_MIDL___MIDL_itf_WIN_0152_0011* pFixedInfo,
		unsigned long* pOutBufLen);
	[entry(0x60000029)]
	unsigned long __stdcall GetAdaptersInfo(
		IP_ADAPTER_INFO* pAdapterInfo,
		unsigned long* pOutBufLen);
	[entry(0x6000002a)]
	IP_ADAPTER_ORDER_MAP* __stdcall GetAdapterOrderMap();
	[entry(0x6000002b)]
	unsigned long __stdcall GetPerAdapterInfo(
		unsigned long IfIndex,
		IP_PER_ADAPTER_INFO* pPerAdapterInfo,
		unsigned long* pOutBufLen);
	[entry(0x6000002c)]
	unsigned long __stdcall IpReleaseAddress(
		IP_ADAPTER_INDEX_MAP* AdapterInfo);
	[entry(0x6000002d)]
	unsigned long __stdcall IpRenewAddress(
		IP_ADAPTER_INDEX_MAP* AdapterInfo);
	[entry(0x6000002e)]
	unsigned long __stdcall SendARP(
		unsigned long DestIP,
		unsigned long SrcIP,
		unsigned long* pMacAddr,
		unsigned long* PhyAddrLen);
	[entry(0x6000002f)]
	long __stdcall GetRTTAndHopCount(
		unsigned long DestIpAddress,
		unsigned long* HopCount,
		unsigned long MaxHops,
		unsigned long* RTT);
	[entry(0x60000030)]
	unsigned long __stdcall GetFriendlyIfIndex(
		unsigned long IfIndex);
	[entry(0x60000031)]
	unsigned long __stdcall EnableRouter(
		long* pHandle,
		OVERLAPPED* pOverlapped);
	[entry(0x60000032)]
	unsigned long __stdcall UnenableRouter(
		OVERLAPPED* pOverlapped,
		unsigned long* lpdwEnableCount);
	[entry(0x60000033)]
	unsigned long __stdcall DisableMediaSense(
		long* pHandle,
		OVERLAPPED* pOverlapped);
	[entry(0x60000034)]
	unsigned long __stdcall RestoreMediaSense(
		OVERLAPPED* pOverlapped,
		unsigned long* lpdwEnableCount);
	[entry(0x60000035)]
	unsigned long __stdcall GetIpErrorString(
		[in]unsigned long ErrorCode,
		[out]unsigned short* Buffer,
		[in, out]unsigned long* Size);
};
'!
!OS.IPHlpApiLibrary categoriesForClass!Win32-Modules! !
!OS.IPHlpApiLibrary methodsFor!

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
!OS.IPHlpApiLibrary categoriesFor: #parseNetworkString:types:addressInfo:portNumber:prefixLength:!**auto generated**!public! !

!OS.IPHlpApiLibrary class methodsFor!

fileName
	"Answer the host system file name for the library."

	^'iphlpapi'
! !
!OS.IPHlpApiLibrary class categoriesFor: #fileName!**auto generated**!constants!public! !

