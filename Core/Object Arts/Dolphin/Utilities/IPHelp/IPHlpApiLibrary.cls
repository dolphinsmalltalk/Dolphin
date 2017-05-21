"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #IPHlpApiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'IPHlpApiConstants'
	classInstanceVariableNames: ''!
IPHlpApiLibrary guid: (GUID fromString: '{a63698ae-5cef-4f53-bf10-c4a77a8b979a}')!
IPHlpApiLibrary comment: 'IPHlpApiLibrary is the <ExternalLibrary> class to represent the dynamic link library, ''iphlpapi.DLL''.It was generated generated from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

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
!IPHlpApiLibrary categoriesForClass!Win32-Modules! !
!IPHlpApiLibrary methodsFor!

AddIPAddress: address ipMask: ipMask ifIndex: ifIndex nteContext: nteContext nteInstance: nteInstance
	"Invoke the AddIPAddress() function of the module wrapped by the receiver.

		unsigned long __stdcall AddIPAddress(
			unsigned long Address,
			unsigned long IpMask,
			unsigned long IfIndex,
			unsigned long* NTEContext,
			unsigned long* NTEInstance);"

	<stdcall: dword AddIPAddress  dword dword dword dword* dword*>
	^self invalidCall!

AllocateAndGetTcpExTableFromStack: pTcpTable bOrder: bOrder heap: heap zero: zero flags: flags
	"Invoke the AllocateAndGetTcpExTableFromStack() function of the module wrapped by the receiver.

		unsigned long __stdcall AllocateAndGetTcpExTableFromStack(
			MIB_TCPEXTABLE** pTcpTable,
			long bOrder,
			long heap,
			unsigned long zero,
			unsigned long flags);"

	<stdcall: dword AllocateAndGetTcpExTableFromStack  MIB_TCPEXTABLE** sdword sdword dword dword>
	^self invalidCall!

AllocateAndGetUdpExTableFromStack: pTcpTable bOrder: bOrder heap: heap zero: zero flags: flags
	"Invoke the AllocateAndGetUdpExTableFromStack() function of the module wrapped by the receiver.

		unsigned long __stdcall AllocateAndGetUdpExTableFromStack(
			MIB_UDPEXTABLE** pTcpTable,
			long bOrder,
			long heap,
			unsigned long zero,
			unsigned long flags);"

	<stdcall: dword AllocateAndGetUdpExTableFromStack  MIB_UDPEXTABLE** sdword sdword dword dword>
	^self invalidCall!

CancelIPChangeNotify: notifyOverlapped
	"Invoke the CancelIPChangeNotify() function of the module wrapped by the receiver.

		long __stdcall CancelIPChangeNotify(
			[in]OVERLAPPED* notifyOverlapped);"

	<stdcall: sdword CancelIPChangeNotify  OVERLAPPED*>
	^self invalidCall!

CreateIpForwardEntry: pRoute
	"Invoke the CreateIpForwardEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall CreateIpForwardEntry(
			[in]MIB_IPFORWARDROW* pRoute);"

	<stdcall: dword CreateIpForwardEntry  MIB_IPFORWARDROW*>
	^self invalidCall!

CreateIpNetEntry: pArpEntry
	"Invoke the CreateIpNetEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall CreateIpNetEntry(
			[in]MIB_IPNETROW* pArpEntry);"

	<stdcall: dword CreateIpNetEntry  MIB_IPNETROW*>
	^self invalidCall!

CreateProxyArpEntry: dwAddress dwMask: dwMask dwIfIndex: dwIfIndex
	"Invoke the CreateProxyArpEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall CreateProxyArpEntry(
			[in]unsigned long dwAddress,
			[in]unsigned long dwMask,
			[in]unsigned long dwIfIndex);"

	<stdcall: dword CreateProxyArpEntry  dword dword dword>
	^self invalidCall!

DeleteIPAddress: nteContext
	"Invoke the DeleteIPAddress() function of the module wrapped by the receiver.

		unsigned long __stdcall DeleteIPAddress(
			unsigned long NTEContext);"

	<stdcall: dword DeleteIPAddress  dword>
	^self invalidCall!

DeleteIpForwardEntry: pRoute
	"Invoke the DeleteIpForwardEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall DeleteIpForwardEntry(
			[in]MIB_IPFORWARDROW* pRoute);"

	<stdcall: dword DeleteIpForwardEntry  MIB_IPFORWARDROW*>
	^self invalidCall!

DeleteIpNetEntry: pArpEntry
	"Invoke the DeleteIpNetEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall DeleteIpNetEntry(
			[in]MIB_IPNETROW* pArpEntry);"

	<stdcall: dword DeleteIpNetEntry  MIB_IPNETROW*>
	^self invalidCall!

DeleteProxyArpEntry: dwAddress dwMask: dwMask dwIfIndex: dwIfIndex
	"Invoke the DeleteProxyArpEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall DeleteProxyArpEntry(
			[in]unsigned long dwAddress,
			[in]unsigned long dwMask,
			[in]unsigned long dwIfIndex);"

	<stdcall: dword DeleteProxyArpEntry  dword dword dword>
	^self invalidCall!

DisableMediaSense: pHandle pOverlapped: pOverlapped
	"Invoke the DisableMediaSense() function of the module wrapped by the receiver.

		unsigned long __stdcall DisableMediaSense(
			long* pHandle,
			OVERLAPPED* pOverlapped);"

	<stdcall: dword DisableMediaSense  sdword* OVERLAPPED*>
	^self invalidCall!

EnableRouter: pHandle pOverlapped: pOverlapped
	"Invoke the EnableRouter() function of the module wrapped by the receiver.

		unsigned long __stdcall EnableRouter(
			long* pHandle,
			OVERLAPPED* pOverlapped);"

	<stdcall: dword EnableRouter  sdword* OVERLAPPED*>
	^self invalidCall!

FlushIpNetTable: dwIfIndex
	"Invoke the FlushIpNetTable() function of the module wrapped by the receiver.

		unsigned long __stdcall FlushIpNetTable(
			[in]unsigned long dwIfIndex);"

	<stdcall: dword FlushIpNetTable  dword>
	^self invalidCall!

GetAdapterIndex: adapterName ifIndex: ifIndex
	"Invoke the GetAdapterIndex() function of the module wrapped by the receiver.

		unsigned long __stdcall GetAdapterIndex(
			[in]LPWSTR AdapterName,
			[out]unsigned long* IfIndex);"

	<stdcall: dword GetAdapterIndex  lpwstr dword*>
	^self invalidCall!

GetAdapterOrderMap
	"Invoke the GetAdapterOrderMap() function of the module wrapped by the receiver.

		IP_ADAPTER_ORDER_MAP* __stdcall GetAdapterOrderMap();"

	<stdcall: IP_ADAPTER_ORDER_MAP* GetAdapterOrderMap >
	^self invalidCall!

getAdaptersInfo
	"
	self default getAdaptersInfo
	"
	| dwSize struct |
	dwSize := DWORD new.
	self GetAdaptersInfo: nil pOutBufLen: dwSize.
	struct := IP_ADAPTER_INFO new: dwSize value.
	self GetAdaptersInfo: struct pOutBufLen: dwSize.
	^struct!

GetAdaptersInfo: pAdapterInfo pOutBufLen: pOutBufLen
	"Invoke the GetAdaptersInfo() function of the module wrapped by the receiver.

		unsigned long __stdcall GetAdaptersInfo(
			IP_ADAPTER_INFO* pAdapterInfo,
			unsigned long* pOutBufLen);"

	<stdcall: dword GetAdaptersInfo  IP_ADAPTER_INFO* dword*>
	^self invalidCall!

GetBestInterface: dwDestAddr pdwBestIfIndex: pdwBestIfIndex
	"Invoke the GetBestInterface() function of the module wrapped by the receiver.

		unsigned long __stdcall GetBestInterface(
			[in]unsigned long dwDestAddr,
			[out]unsigned long* pdwBestIfIndex);"

	<stdcall: dword GetBestInterface  dword dword*>
	^self invalidCall!

GetBestRoute: dwDestAddr dwSourceAddr: dwSourceAddr pBestRoute: pBestRoute
	"Invoke the GetBestRoute() function of the module wrapped by the receiver.

		unsigned long __stdcall GetBestRoute(
			[in]unsigned long dwDestAddr,
			[in]unsigned long dwSourceAddr,
			[out]MIB_IPFORWARDROW* pBestRoute);"

	<stdcall: dword GetBestRoute  dword dword MIB_IPFORWARDROW*>
	^self invalidCall!

GetFriendlyIfIndex: ifIndex
	"Invoke the GetFriendlyIfIndex() function of the module wrapped by the receiver.

		unsigned long __stdcall GetFriendlyIfIndex(
			unsigned long IfIndex);"

	<stdcall: dword GetFriendlyIfIndex  dword>
	^self invalidCall!

getIcmpStatistics
	"
	self default getIcmpStatistics
	"

	| struct err |
	struct := MIB_ICMP new.
	err := self GetIcmpStatistics: struct.
	err == 0 ifFalse: [Win32Error signalWith: err].
	^struct!

GetIcmpStatistics: pStats
	"Invoke the GetIcmpStatistics() function of the module wrapped by the receiver.

		unsigned long __stdcall GetIcmpStatistics(
			[out]MIB_ICMP* pStats);"

	<stdcall: dword GetIcmpStatistics  MIB_ICMP*>
	^self invalidCall!

GetIcmpStatisticsEx: pStats dwFamily: dwFamily
	"Invoke the GetIcmpStatisticsEx() function of the module wrapped by the receiver.

		unsigned long __stdcall GetIcmpStatisticsEx(
			[out]MIB_ICMP_EX* pStats,
			[in]unsigned long dwFamily);"

	<stdcall: dword GetIcmpStatisticsEx  MIB_ICMP_EX* dword>
	^self invalidCall!

GetIfEntry: pIfRow
	"Invoke the GetIfEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall GetIfEntry(
			[in, out]MIB_IFROW* pIfRow);"

	<stdcall: dword GetIfEntry  MIB_IFROW*>
	^self invalidCall!

getIfTable
	"
	self default getIfTable
	"

	| struct err dwSize |
	dwSize := DWORD new.
	self 
		GetIfTable: nil
		pdwSize: dwSize
		bOrder: TRUE.
	struct := MIB_IFTABLE new: dwSize value.
	err := self 
				GetIfTable: struct
				pdwSize: dwSize
				bOrder: TRUE.
	err == 0 ifFalse: [Win32Error signalWith: err].
	^struct!

GetIfTable: pIfTable pdwSize: pdwSize bOrder: bOrder
	"Invoke the GetIfTable() function of the module wrapped by the receiver.

		unsigned long __stdcall GetIfTable(
			[out]MIB_IFTABLE* pIfTable,
			[in, out]unsigned long* pdwSize,
			[in]long bOrder);"

	<stdcall: dword GetIfTable  MIB_IFTABLE* dword* sdword>
	^self invalidCall!

getInterfaceInfo
	"
	self default getInterfaceInfo
	"

	| dwSize struct |
	dwSize := DWORD new.
	self GetInterfaceInfo: nil dwOutBufLen: dwSize.
	struct := IP_INTERFACE_INFO new: dwSize value.
	self GetInterfaceInfo: struct dwOutBufLen: dwSize.
	^struct!

GetInterfaceInfo: pIfTable dwOutBufLen: dwOutBufLen
	"Invoke the GetInterfaceInfo() function of the module wrapped by the receiver.

		unsigned long __stdcall GetInterfaceInfo(
			[in]IP_INTERFACE_INFO* pIfTable,
			[out]unsigned long* dwOutBufLen);"

	<stdcall: dword GetInterfaceInfo  IP_INTERFACE_INFO* dword*>
	^self invalidCall!

getIpAddrTable
	"
	self default getIpAddrTable
	"

	| struct err dwSize |
	dwSize := DWORD new.
	self 
		GetIpAddrTable: nil
		pdwSize: dwSize
		bOrder: TRUE.
	struct := MIB_IPADDRTABLE new: dwSize value.
	err := self 
				GetIpAddrTable: struct
				pdwSize: dwSize
				bOrder: TRUE.
	err == 0 ifFalse: [Win32Error signalWith: err].
	^struct!

GetIpAddrTable: pIpAddrTable pdwSize: pdwSize bOrder: bOrder
	"Invoke the GetIpAddrTable() function of the module wrapped by the receiver.

		unsigned long __stdcall GetIpAddrTable(
			[out]MIB_IPADDRTABLE* pIpAddrTable,
			[in, out]unsigned long* pdwSize,
			[in]long bOrder);"

	<stdcall: dword GetIpAddrTable  MIB_IPADDRTABLE* dword* sdword>
	^self invalidCall!

GetIpErrorString: errorCode buffer: buffer size: size
	"Invoke the GetIpErrorString() function of the module wrapped by the receiver.

		unsigned long __stdcall GetIpErrorString(
			[in]unsigned long ErrorCode,
			[out]unsigned short* Buffer,
			[in, out]unsigned long* Size);"

	<stdcall: dword GetIpErrorString  dword word* dword*>
	^self invalidCall!

getIpForwardTable
	"
	self default getIpForwardTable
	"

	| struct err dwSize |
	dwSize := DWORD new.
	self 
		GetIpForwardTable: nil
		pdwSize: dwSize
		bOrder: TRUE.
	struct := MIB_IPFORWARDTABLE new: dwSize value.
	err := self 
				GetIpForwardTable: struct
				pdwSize: dwSize
				bOrder: TRUE.
	err == 0 ifFalse: [Win32Error signalWith: err].
	^struct!

GetIpForwardTable: pIpForwardTable pdwSize: pdwSize bOrder: bOrder
	"Invoke the GetIpForwardTable() function of the module wrapped by the receiver.

		unsigned long __stdcall GetIpForwardTable(
			[out]MIB_IPFORWARDTABLE* pIpForwardTable,
			[in, out]unsigned long* pdwSize,
			[in]long bOrder);"

	<stdcall: dword GetIpForwardTable  MIB_IPFORWARDTABLE* dword* sdword>
	^self invalidCall!

getIpNetTable
	"
	self default getIpNetTable
	"

	| struct err dwSize |
	dwSize := DWORD new.
	self 
		GetIpNetTable: nil
		pdwSize: dwSize
		bOrder: TRUE.
	struct := MIB_IPNETTABLE new: dwSize value.
	err := self 
				GetIpNetTable: struct
				pdwSize: dwSize
				bOrder: TRUE.
	err == 0 ifFalse: [Win32Error signalWith: err].
	^struct!

GetIpNetTable: pIpNetTable pdwSize: pdwSize bOrder: bOrder
	"Invoke the GetIpNetTable() function of the module wrapped by the receiver.

		unsigned long __stdcall GetIpNetTable(
			[out]MIB_IPNETTABLE* pIpNetTable,
			[in, out]unsigned long* pdwSize,
			[in]long bOrder);"

	<stdcall: dword GetIpNetTable  MIB_IPNETTABLE* dword* sdword>
	^self invalidCall!

getIpStatistics
	"
	self default getIpStatistics
	"

	| struct err |
	struct := MIB_IPSTATS new.
	err := self GetIpStatistics: struct.
	err == 0 ifFalse: [Win32Error signalWith: err].
	^struct!

GetIpStatistics: pStats
	"Invoke the GetIpStatistics() function of the module wrapped by the receiver.

		unsigned long __stdcall GetIpStatistics(
			[out]MIB_IPSTATS* pStats);"

	<stdcall: dword GetIpStatistics  MIB_IPSTATS*>
	^self invalidCall!

GetIpStatisticsEx: pStats dwFamily: dwFamily
	"Invoke the GetIpStatisticsEx() function of the module wrapped by the receiver.

		unsigned long __stdcall GetIpStatisticsEx(
			[out]MIB_IPSTATS* pStats,
			[in]unsigned long dwFamily);"

	<stdcall: dword GetIpStatisticsEx  MIB_IPSTATS* dword>
	^self invalidCall!

GetNetworkParams: pFixedInfo pOutBufLen: pOutBufLen
	"Invoke the GetNetworkParams() function of the module wrapped by the receiver.

		unsigned long __stdcall GetNetworkParams(
			FIXED_INFO* pFixedInfo,
			unsigned long* pOutBufLen);"

	<stdcall: dword GetNetworkParams  FIXED_INFO* dword*>
	^self invalidCall!

GetNumberOfInterfaces: pdwNumIf
	"Invoke the GetNumberOfInterfaces() function of the module wrapped by the receiver.

		unsigned long __stdcall GetNumberOfInterfaces(
			[out]unsigned long* pdwNumIf);"

	<stdcall: dword GetNumberOfInterfaces  dword*>
	^self invalidCall!

getPerAdapterInfo: ifIndex 
	"
	self default getPerAdapterInfo: 3
	"

	| struct dwSize error |
	struct := IP_PER_ADAPTER_INFO new.
	dwSize := DWORD fromInteger: struct byteSize.
	error := self 
				GetPerAdapterInfo: ifIndex
				pPerAdapterInfo: struct
				pOutBufLen: dwSize.
	error == 0 
		ifFalse: 
			[Win32Error signal: 'Error retrieving per-adapter info for ' , ifIndex displayString with: error].
	^struct!

GetPerAdapterInfo: ifIndex pPerAdapterInfo: pPerAdapterInfo pOutBufLen: pOutBufLen
	"Invoke the GetPerAdapterInfo() function of the module wrapped by the receiver.

		unsigned long __stdcall GetPerAdapterInfo(
			unsigned long IfIndex,
			IP_PER_ADAPTER_INFO* pPerAdapterInfo,
			unsigned long* pOutBufLen);"

	<stdcall: dword GetPerAdapterInfo  dword IP_PER_ADAPTER_INFO* dword*>
	^self invalidCall!

GetRTTAndHopCount: destIpAddress hopCount: hopCount maxHops: maxHops rtt: rtt
	"Invoke the GetRTTAndHopCount() function of the module wrapped by the receiver.

		long __stdcall GetRTTAndHopCount(
			unsigned long DestIpAddress,
			unsigned long* HopCount,
			unsigned long MaxHops,
			unsigned long* RTT);"

	<stdcall: sdword GetRTTAndHopCount  dword dword* dword dword*>
	^self invalidCall!

getTcpExTable
	"
	self default getTcpExTable
	"
	| struct |
	struct := MIB_TCPEXTABLE newHeapPointer.
	self AllocateAndGetTcpExTableFromStack: struct bOrder: TRUE heap: ExternalMemory processHeap zero: 2 flags: 2.
	^struct!

getTcpStatistics
	"
	self default getTcpStatistics
	"

	| struct err |
	struct := MIB_TCPSTATS new.
	err := self GetTcpStatistics: struct.
	err == 0 ifFalse: [Win32Error signalWith: err].
	^struct!

GetTcpStatistics: pStats
	"Invoke the GetTcpStatistics() function of the module wrapped by the receiver.

		unsigned long __stdcall GetTcpStatistics(
			[out]MIB_TCPSTATS* pStats);"

	<stdcall: dword GetTcpStatistics  MIB_TCPSTATS*>
	^self invalidCall!

GetTcpStatisticsEx: pStats dwFamily: dwFamily
	"Invoke the GetTcpStatisticsEx() function of the module wrapped by the receiver.

		unsigned long __stdcall GetTcpStatisticsEx(
			[out]MIB_TCPSTATS* pStats,
			[in]unsigned long dwFamily);"

	<stdcall: dword GetTcpStatisticsEx  MIB_TCPSTATS* dword>
	^self invalidCall!

getTcpTable
	"
	table := IPHlpApiLibrary default getTcpTable.
	table collect: [:each | each dwLocalPort].
	"

	| dwSize error tcpTable |
	dwSize := DWORD new.
	error := self 
				GetTcpTable: nil
				pdwSize: dwSize
				bOrder: TRUE.
	"		if( error !!= ERROR_INSUFFICIENT_BUFFER ) {"
	tcpTable := MIB_TCPTABLE new: dwSize asInteger.
	error := self 
				GetTcpTable: tcpTable
				pdwSize: dwSize
				bOrder: TRUE.
	error == 0 ifFalse: [self error: 'Failed to snapshot TCP endpoints.'].
	^tcpTable!

GetTcpTable: pTcpTable pdwSize: pdwSize bOrder: bOrder
	"Invoke the GetTcpTable() function of the module wrapped by the receiver.

		unsigned long __stdcall GetTcpTable(
			[out]MIB_TCPTABLE* pTcpTable,
			[in, out]unsigned long* pdwSize,
			[in]long bOrder);"

	<stdcall: dword GetTcpTable  MIB_TCPTABLE* dword* sdword>
	^self invalidCall!

getUdpStatistics
	"
	self default getUdpStatistics
	"

	| struct err |
	struct := MIB_UDPSTATS new.
	err := self GetUdpStatistics: struct.
	err == 0 ifFalse: [Win32Error signalWith: err].
	^struct!

GetUdpStatistics: pStats
	"Invoke the GetUdpStatistics() function of the module wrapped by the receiver.

		unsigned long __stdcall GetUdpStatistics(
			[out]MIB_UDPSTATS* pStats);"

	<stdcall: dword GetUdpStatistics  MIB_UDPSTATS*>
	^self invalidCall!

GetUdpStatisticsEx: pStats dwFamily: dwFamily
	"Invoke the GetUdpStatisticsEx() function of the module wrapped by the receiver.

		unsigned long __stdcall GetUdpStatisticsEx(
			[out]MIB_UDPSTATS* pStats,
			[in]unsigned long dwFamily);"

	<stdcall: dword GetUdpStatisticsEx  MIB_UDPSTATS* dword>
	^self invalidCall!

getUdpTable
	"
	table := IPHlpApiLibrary default getUdpTable
	table talbe collect: [:each | each port].
	"

	| dwSize error struct |
	dwSize := DWORD new.
	error := self 
				GetUdpTable: nil
				pdwSize: dwSize
				bOrder: TRUE.
	struct := MIB_UDPTABLE new: dwSize asInteger.
	error := self 
				GetUdpTable: struct
				pdwSize: dwSize
				bOrder: TRUE.
	error == 0 ifFalse: [Win32Error signalWith: error].
	^struct!

GetUdpTable: pUdpTable pdwSize: pdwSize bOrder: bOrder
	"Invoke the GetUdpTable() function of the module wrapped by the receiver.

		unsigned long __stdcall GetUdpTable(
			[out]MIB_UDPTABLE* pUdpTable,
			[in, out]unsigned long* pdwSize,
			[in]long bOrder);"

	<stdcall: dword GetUdpTable  MIB_UDPTABLE* dword* sdword>
	^self invalidCall!

getUniDirectionalAdapterInfo
	"
	self default getUniDirectionalAdapterInfo
	"
	| dwSize struct error |
	struct := IP_UNIDIRECTIONAL_ADAPTER_ADDRESS new.
	dwSize := DWORD fromInteger: struct size.
	error := self GetUniDirectionalAdapterInfo: struct dwOutBufLen: dwSize.
	error == 0 ifFalse: [Win32Error signalWith: error].
	^struct!

GetUniDirectionalAdapterInfo: pIPIfInfo dwOutBufLen: dwOutBufLen
	"Invoke the GetUniDirectionalAdapterInfo() function of the module wrapped by the receiver.

		unsigned long __stdcall GetUniDirectionalAdapterInfo(
			[out]IP_UNIDIRECTIONAL_ADAPTER_ADDRESS* pIPIfInfo,
			[out]unsigned long* dwOutBufLen);"

	<stdcall: dword GetUniDirectionalAdapterInfo  IP_UNIDIRECTIONAL_ADAPTER_ADDRESS* dword*>
	^self invalidCall!

IpReleaseAddress: adapterInfo
	"Invoke the IpReleaseAddress() function of the module wrapped by the receiver.

		unsigned long __stdcall IpReleaseAddress(
			IP_ADAPTER_INDEX_MAP* AdapterInfo);"

	<stdcall: dword IpReleaseAddress  IP_ADAPTER_INDEX_MAP*>
	^self invalidCall!

IpRenewAddress: adapterInfo
	"Invoke the IpRenewAddress() function of the module wrapped by the receiver.

		unsigned long __stdcall IpRenewAddress(
			IP_ADAPTER_INDEX_MAP* AdapterInfo);"

	<stdcall: dword IpRenewAddress  IP_ADAPTER_INDEX_MAP*>
	^self invalidCall!

NhpAllocateAndGetInterfaceInfoFromStack: ppTable pdwCount: pdwCount bOrder: bOrder hHeap: hHeap dwFlags: dwFlags
	"Invoke the NhpAllocateAndGetInterfaceInfoFromStack() function of the module wrapped by the receiver.

		unsigned long __stdcall NhpAllocateAndGetInterfaceInfoFromStack(
			[out]ip_interface_name_info** ppTable,
			[out]unsigned long* pdwCount,
			[in]long bOrder,
			[in]long hHeap,
			[in]unsigned long dwFlags);"

	<stdcall: dword NhpAllocateAndGetInterfaceInfoFromStack  void** dword* sdword sdword dword>
	^self invalidCall!

NotifyAddrChange: handle1 overlapped: overlapped
	"Invoke the NotifyAddrChange() function of the module wrapped by the receiver.

		unsigned long __stdcall NotifyAddrChange(
			[out]long* Handle,
			[in]OVERLAPPED* overlapped);"

	<stdcall: dword NotifyAddrChange  sdword* OVERLAPPED*>
	^self invalidCall!

NotifyRouteChange: handle1 overlapped: overlapped
	"Invoke the NotifyRouteChange() function of the module wrapped by the receiver.

		unsigned long __stdcall NotifyRouteChange(
			[out]long* Handle,
			[in]OVERLAPPED* overlapped);"

	<stdcall: dword NotifyRouteChange  sdword* OVERLAPPED*>
	^self invalidCall!

RestoreMediaSense: pOverlapped lpdwEnableCount: lpdwEnableCount
	"Invoke the RestoreMediaSense() function of the module wrapped by the receiver.

		unsigned long __stdcall RestoreMediaSense(
			OVERLAPPED* pOverlapped,
			unsigned long* lpdwEnableCount);"

	<stdcall: dword RestoreMediaSense  OVERLAPPED* dword*>
	^self invalidCall!

SendARP: destIP srcIP: srcIP pMacAddr: pMacAddr phyAddrLen: phyAddrLen
	"Invoke the SendARP() function of the module wrapped by the receiver.

		unsigned long __stdcall SendARP(
			unsigned long DestIP,
			unsigned long SrcIP,
			unsigned long* pMacAddr,
			unsigned long* PhyAddrLen);"

	<stdcall: dword SendARP  dword dword dword* dword*>
	^self invalidCall!

SetIfEntry: pIfRow
	"Invoke the SetIfEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall SetIfEntry(
			[in]MIB_IFROW* pIfRow);"

	<stdcall: dword SetIfEntry  MIB_IFROW*>
	^self invalidCall!

SetIpForwardEntry: pRoute
	"Invoke the SetIpForwardEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall SetIpForwardEntry(
			[in]MIB_IPFORWARDROW* pRoute);"

	<stdcall: dword SetIpForwardEntry  MIB_IPFORWARDROW*>
	^self invalidCall!

SetIpNetEntry: pArpEntry
	"Invoke the SetIpNetEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall SetIpNetEntry(
			[in]MIB_IPNETROW* pArpEntry);"

	<stdcall: dword SetIpNetEntry  MIB_IPNETROW*>
	^self invalidCall!

SetIpStatistics: pIpStats
	"Invoke the SetIpStatistics() function of the module wrapped by the receiver.

		unsigned long __stdcall SetIpStatistics(
			[in]MIB_IPSTATS* pIpStats);"

	<stdcall: dword SetIpStatistics  MIB_IPSTATS*>
	^self invalidCall!

SetIpTTL: nTTL
	"Invoke the SetIpTTL() function of the module wrapped by the receiver.

		unsigned long __stdcall SetIpTTL(
			unsigned int nTTL);"

	<stdcall: dword SetIpTTL  dword>
	^self invalidCall!

SetTcpEntry: pTcpRow
	"Invoke the SetTcpEntry() function of the module wrapped by the receiver.

		unsigned long __stdcall SetTcpEntry(
			[in]MIB_TCPROW* pTcpRow);"

	<stdcall: dword SetTcpEntry  MIB_TCPROW*>
	^self invalidCall!

UnenableRouter: pOverlapped lpdwEnableCount: lpdwEnableCount
	"Invoke the UnenableRouter() function of the module wrapped by the receiver.

		unsigned long __stdcall UnenableRouter(
			OVERLAPPED* pOverlapped,
			unsigned long* lpdwEnableCount);"

	<stdcall: dword UnenableRouter  OVERLAPPED* dword*>
	^self invalidCall! !
!IPHlpApiLibrary categoriesFor: #AddIPAddress:ipMask:ifIndex:nteContext:nteInstance:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #AllocateAndGetTcpExTableFromStack:bOrder:heap:zero:flags:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #AllocateAndGetUdpExTableFromStack:bOrder:heap:zero:flags:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #CancelIPChangeNotify:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #CreateIpForwardEntry:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #CreateIpNetEntry:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #CreateProxyArpEntry:dwMask:dwIfIndex:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #DeleteIPAddress:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #DeleteIpForwardEntry:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #DeleteIpNetEntry:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #DeleteProxyArpEntry:dwMask:dwIfIndex:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #DisableMediaSense:pOverlapped:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #EnableRouter:pOverlapped:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #FlushIpNetTable:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetAdapterIndex:ifIndex:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetAdapterOrderMap!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getAdaptersInfo!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetAdaptersInfo:pOutBufLen:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetBestInterface:pdwBestIfIndex:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetBestRoute:dwSourceAddr:pBestRoute:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetFriendlyIfIndex:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getIcmpStatistics!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetIcmpStatistics:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetIcmpStatisticsEx:dwFamily:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetIfEntry:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getIfTable!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetIfTable:pdwSize:bOrder:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getInterfaceInfo!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetInterfaceInfo:dwOutBufLen:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getIpAddrTable!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetIpAddrTable:pdwSize:bOrder:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetIpErrorString:buffer:size:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getIpForwardTable!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetIpForwardTable:pdwSize:bOrder:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getIpNetTable!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetIpNetTable:pdwSize:bOrder:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getIpStatistics!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetIpStatistics:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetIpStatisticsEx:dwFamily:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetNetworkParams:pOutBufLen:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetNumberOfInterfaces:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getPerAdapterInfo:!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetPerAdapterInfo:pPerAdapterInfo:pOutBufLen:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetRTTAndHopCount:hopCount:maxHops:rtt:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getTcpExTable!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #getTcpStatistics!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetTcpStatistics:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetTcpStatisticsEx:dwFamily:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getTcpTable!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetTcpTable:pdwSize:bOrder:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getUdpStatistics!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetUdpStatistics:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #GetUdpStatisticsEx:dwFamily:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getUdpTable!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetUdpTable:pdwSize:bOrder:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #getUniDirectionalAdapterInfo!enquiries!public! !
!IPHlpApiLibrary categoriesFor: #GetUniDirectionalAdapterInfo:dwOutBufLen:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #IpReleaseAddress:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #IpRenewAddress:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #NhpAllocateAndGetInterfaceInfoFromStack:pdwCount:bOrder:hHeap:dwFlags:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #NotifyAddrChange:overlapped:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #NotifyRouteChange:overlapped:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #RestoreMediaSense:lpdwEnableCount:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #SendARP:srcIP:pMacAddr:phyAddrLen:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #SetIfEntry:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #SetIpForwardEntry:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #SetIpNetEntry:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #SetIpStatistics:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #SetIpTTL:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #SetTcpEntry:!**auto generated**!public! !
!IPHlpApiLibrary categoriesFor: #UnenableRouter:lpdwEnableCount:!**auto generated**!public! !

!IPHlpApiLibrary class methodsFor!

fileName
	"Answer the host system file name for the library."

	^'iphlpapi'
! !
!IPHlpApiLibrary class categoriesFor: #fileName!**auto generated**!constants!public! !

