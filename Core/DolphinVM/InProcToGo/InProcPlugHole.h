// InProcPlugHole.h : Declaration of the CInProcPlugHole

#ifndef __INPROCPLUGHOLE_H_
#define __INPROCPLUGHOLE_H_

#undef TRACE
#ifdef _DEBUG
	#define TRACE				::trace
#else
	inline void __cdecl traceX(LPCTSTR, ...)  {}
	#define TRACE				1 ? ((void)0) : ::traceX
#endif

#include "..\DolphinSmalltalk.h"
#include <map>

_COM_SMARTPTR_TYPEDEF(IIPDolphin, __uuidof(IIPDolphin));

/////////////////////////////////////////////////////////////////////////////
// CInProcPlugHole
class ATL_NO_VTABLE CInProcPlugHole : 
	public CComObjectRootEx<CComMultiThreadModel>,	// N.B. A free threaded object
	public CComCoClass<CInProcPlugHole, &CLSID_DolphinIPPlugHole>,
	public ISupportErrorInfoImpl<&IID_IIPPlugHole>,
	public IIPPlugHole
{
	HANDLE m_hDolphinThread;

	// The inter-thread marshalled plug-in session object in the image, of which there is 
	// only a single instance
	IStream* m_piMarshalledPeer;

	// The id (returned by CoGetCurrentProcess()) of the thread that started the VM
	DWORD	m_dwVMStarterId;

	// Map of unmarshalled peer pointers, one for each thread
	typedef std::map<DWORD, IIPDolphinPtr> PEERMAP;
	PEERMAP m_mapPeers;

	// Win32 event signalled when the peer has been registered by the image
	HANDLE	m_hPeerAvailable;

	wchar_t	achImagePath[_MAX_PATH+1];
	LPVOID	m_pImageData;
	size_t	m_cImageSize;

private:
	void ReleasePeer();
	IIPDolphinPtr GetPeerForCurrentThread();
	void WaitForPeerToStart() const;
	DWORD WaitForPeerToTerminate();
	void UpdateImagePathForCLSID(REFCLSID clsid);
	HRESULT StartVM(CLSCTX ctx);
	HRESULT StartPeer(IIPDolphin** ppiPeer, REFCLSID rclsid, CLSCTX ctx);
	HRESULT GetPeer(IIPDolphin** ppiPeer, REFCLSID rclsid=CLSID_NULL, CLSCTX ctx=CLSCTX_INPROC_SERVER);
	IIPDolphinPtr GetPeerNoWait();


protected:

	HRESULT FinalConstruct();
	void FinalRelease();

public:
	CInProcPlugHole();
	~CInProcPlugHole();

	LPCWSTR GetImagePath() const
	{
		return achImagePath;
	}

//DECLARE_REGISTRY_RESOURCEID(IDR_NPPLUGHOLE)

DECLARE_PROTECT_FINAL_CONSTRUCT()

BEGIN_COM_MAP(CInProcPlugHole)
	COM_INTERFACE_ENTRY(IIPPlugHole)
	COM_INTERFACE_ENTRY(ISupportErrorInfo)
END_COM_MAP()

public:
	void SetImageInfo(LPCWSTR szImagePath, LPVOID imageData, size_t imageSize);

	// Handle incoming from Windows/COM - mostly these just forward to the peer object
	HRESULT Initialize(REFCLSID rclsid, CLSCTX ctx);
	HRESULT Shutdown();

	// The calling thread is detaching from the Process, so remove any resources associated with it
	void ThreadDetach();

	HRESULT CanUnloadNow();
	HRESULT GetClassObject(REFCLSID rclsid, REFIID riid, LPVOID* ppv);
	HRESULT RegisterServer();
	HRESULT UnregisterServer();

public:

// IIPPlugHole
public:
	STDMETHOD(get_Peer)(/*[out, retval]*/ IUnknown** pVal);
	STDMETHOD(put_Peer)(/*[in]*/ IUnknown* newVal);
};

#endif //__NPPLUGHOLE_H_
