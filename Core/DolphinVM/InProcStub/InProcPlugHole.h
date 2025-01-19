// InProcPlugHole.h : Declaration of the DolphinIPPlugHole

#ifndef __INPROCPLUGHOLE_H_
#define __INPROCPLUGHOLE_H_

#undef TRACE
#ifdef _DEBUG
	#define TRACE				::trace
#else
	inline void __cdecl traceX(LPCTSTR, ...)  {}
	#define TRACE				1 ? ((void)0) : ::traceX
#endif

#include <map>
#include "ComModule.h"
#include "InProcStub.h"
#include "DolphinSmalltalk_i.h"

_COM_SMARTPTR_TYPEDEF(IIPDolphin, __uuidof(IIPDolphin));

// RegDetails should include
// LIBID_DolphinIP

/////////////////////////////////////////////////////////////////////////////
// DolphinIPPlugHole
// 
// This is an internal object, and we don't want it to prevent the DLL being unloaded so we use "no lock" base.
// There is a circular reference from the plug hole to the image peer, and we want the image side to tell us 
// whether the image should be kept up (except for some cases where we protect the code with a Lock()/Unlock() 
// pair for safety).

class DolphinIPPlugHole : public ComObject<NullComRegistration, ComObjectBaseNoModuleLock, IIPPlugHole, ISupportErrorInfo >
{
	HANDLE m_hDolphinThread = nullptr;

	// The inter-thread marshalled plug-in session object in the image, of which there is 
	// only a single instance
	IStream* m_piMarshalledPeer = nullptr;

	// The id (returned by CoGetCurrentProcess()) of the thread that started the VM
	DWORD	m_dwVMStarterId = 0;

	// Map of unmarshalled peer pointers, one for each thread
	typedef std::map<DWORD, IIPDolphinPtr> PEERMAP;
	PEERMAP m_mapPeers;

	// Win32 event signalled when the peer has been registered by the image
	HANDLE	m_hPeerAvailable;

	wchar_t	achImagePath[_MAX_PATH+1];
	LPVOID	m_pImageData = nullptr;
	size_t	m_cImageSize = 0;

	CMonitor m_critical;

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


public:
	DolphinIPPlugHole();
	~DolphinIPPlugHole();

	LPCWSTR GetImagePath() const
	{
		return achImagePath;
	}

public:
	void Lock();
	void Unlock();

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

	// Inherited via ComObject
	STDMETHODIMP InterfaceSupportsErrorInfo(REFIID riid) override
	{
		return riid == __uuidof(IIPPlugHole) ? S_OK : S_FALSE;
	}
};

inline void DolphinIPPlugHole::Lock()
{
	m_critical.Lock();
}

inline void DolphinIPPlugHole::Unlock()
{
	m_critical.Unlock();
}

#endif //__NPPLUGHOLE_H_
