// InProcPlugHole.cpp : Implementation of CInProcPlugHole
#include "stdafx.h"
#include "ist.h"
#include "InprocStub.h"
#include "InProcPlugHole.h"
#include "..\startVM.h"
#include "..\regkey.h"

#ifdef _DEBUG
	const int SecondsToWait = IsDebuggerPresent() ? 300 : 60;
#else
	const int SecondsToWait = 10;
#endif

CInProcPlugHole::CInProcPlugHole() : m_hDolphinThread(NULL), m_piMarshalledPeer(NULL), m_dwVMStarterId(0), 
	m_pImageData(NULL), m_cImageSize(0)
{
	TRACE(L"%#x: CInProcPlugHole %#x instantiated\n", GetCurrentThreadId(), this);

	achImagePath[0] = 0;
	m_hPeerAvailable = ::CreateEvent(NULL, TRUE, FALSE, NULL);
}

CInProcPlugHole::~CInProcPlugHole()
{
	TRACE(L"%#x: ~CInProcPlugHole(%s)\n", GetCurrentThreadId(), GetImagePath());
	ReleasePeer();
	::CloseHandle(m_hPeerAvailable);
}

// N.B. This expects to be executed within the critical section
void CInProcPlugHole::WaitForPeerToStart() const
{
	_ASSERTE(m_hDolphinThread != NULL);
	_ASSERTE(m_hPeerAvailable != NULL);

	#ifdef _DEBUG
		DWORD dwTicks = GetTickCount();
		TRACE(L"%#x: Waiting for peer to start...\n", GetCurrentThreadId());
	#endif

	// Wait until either the peer is available or the Dolphin thread terminates
	HANDLE aHandles[] = {m_hPeerAvailable, m_hDolphinThread};
	const ULONG numHandles = sizeof(aHandles)/sizeof(HANDLE);

	// New Win2000 CoWaitForMultipleHandles is ideal here...

	DWORD dwIndex;
	HRESULT hr = ::CoWaitForMultipleHandles(0, SecondsToWait*1000, numHandles, aHandles, &dwIndex);

	#ifdef _DEBUG
	{
		if (m_piMarshalledPeer == NULL)
			TRACE(L"%#x: WaitForPeerToStart: Peer failed to connect %d mS (%#x, %d)\n", GetCurrentThreadId(), GetTickCount()-dwTicks, hr, dwIndex);
		else
			TRACE(L"%#x: WaitForPeerToStart: Peer connected after %d mS (%#x, %d)\n", GetCurrentThreadId(), GetTickCount()-dwTicks, hr, dwIndex);
	}
	#endif

//	return m_piPeer;
}


HRESULT CInProcPlugHole::StartVM(CLSCTX ctx)
{
	_ASSERTE(m_dwVMStarterId == 0);
	_ASSERTE(m_hDolphinThread == 0);

	// 2: Start the VM passing it the plug hole to the plug-in

	TRACE(L"%#x: StartVM(%s, %d, %#x)\n", GetCurrentThreadId(), achImagePath, m_pImageData, ctx);

	IUnknown* piPlugHole;
	HRESULT hr = static_cast<CComObject<CInProcPlugHole>*>(this)->QueryInterface(&piPlugHole);
	if (FAILED(hr))
	{
		trace(L"Failed to locate plug hole interface (%#x)\n", hr);
		return hr;
	}

	// Ref. count resulting from above QI is assumed by the image when it retrieves the pointer

	hr = VMEntry(_AtlBaseModule.GetModuleInstance(), m_pImageData, m_cImageSize, achImagePath, 
							piPlugHole, ctx, m_hDolphinThread);
	
	// VMEntry must take a reference to the plug-hole, this just releases the pointer resulting from the QI above
	piPlugHole->Release();

	if (FAILED(hr))
		return hr;

	TRACE(L"%#x: Started Dolphin main thread %#x...\n", GetCurrentThreadId(), m_hDolphinThread);

	return S_OK;
}

// Must only be called from within critical section
IIPDolphinPtr CInProcPlugHole::GetPeerForCurrentThread()
{
	if (m_piMarshalledPeer == NULL)
		return NULL;

	_ASSERTE(m_dwVMStarterId != 0);
	_ASSERTE(m_hDolphinThread != 0);

	// Note use of reference here so if null, new entry gets updated
	IIPDolphinPtr& piPeer = m_mapPeers[CoGetCurrentProcess()];
	if (piPeer == NULL)
	{
		TRACE(L"%#x: New peer requested for COM thread id %#x\n", GetCurrentThreadId(), CoGetCurrentProcess());

		LARGE_INTEGER pos;
		pos.QuadPart = 0;
		m_piMarshalledPeer->Seek(pos, STREAM_SEEK_SET, NULL);
		HRESULT hr = ::CoUnmarshalInterface(m_piMarshalledPeer, __uuidof(IIPDolphin), reinterpret_cast<void**>(&piPeer));
		_ASSERTE(SUCCEEDED(hr));
	}

	return piPeer;
}

IIPDolphinPtr CInProcPlugHole::GetPeerNoWait()
{
	ObjectLock lock(this);
	return GetPeerForCurrentThread();
}

void CInProcPlugHole::ReleasePeer()
{
	if (m_piMarshalledPeer != NULL)
	{
		IStream* piStream = m_piMarshalledPeer;
		m_piMarshalledPeer = NULL;
		m_dwVMStarterId = 0;

		::ResetEvent(m_hPeerAvailable);
		m_mapPeers.clear();

		// Unmarshall it one last time to release it
		LARGE_INTEGER pos;
		pos.QuadPart = 0;
		piStream->Seek(pos, STREAM_SEEK_SET, NULL);
		IIPDolphinPtr piPeer;
		HRESULT hr = ::CoGetInterfaceAndReleaseStream(piStream, __uuidof(IIPDolphin), reinterpret_cast<void**>(&piPeer));
	}
}

// The calling thread is detaching from the Process, so remove any resources associated with it
void CInProcPlugHole::ThreadDetach()
{
	ObjectLock lock(this);
	size_t cRemoved = m_mapPeers.erase(CoGetCurrentProcess());

#ifdef _DEBUG
	if (cRemoved > 0)
		TRACE(L"%#x: ThreadDetach: %#x was removed from the thread map\n", GetCurrentThreadId(), CoGetCurrentProcess());
	else
		TRACE(L"%#x: ThreadDetach: %#x was not in the thread map\n", GetCurrentThreadId(), CoGetCurrentProcess());
	TRACE(L"%#x: peer map now contains %d entries\n", GetCurrentThreadId(), m_mapPeers.size());
#endif
}

// Wait for the Dolphin thread to finish
DWORD CInProcPlugHole::WaitForPeerToTerminate()
{
	DWORD dwExitCode = -1;
	if (m_hDolphinThread)
	{
		DWORD dwDummy;
		HRESULT hr = ::CoWaitForMultipleHandles(0, SecondsToWait*1000, 1, &m_hDolphinThread, &dwDummy);
		if (SUCCEEDED(hr))
		{
			::GetExitCodeThread(m_hDolphinThread, &dwExitCode);
			TRACE(L"%#x: Dolphin thread %p exited with code %d\n", GetCurrentThreadId(), m_hDolphinThread, dwExitCode);

			// Note that we can't release the last ref to the peer, because it is held
			// by the image, which has now completely shut down
		}
		else
		{
			trace(L"%#x: Dolphin thread %p failed to exit (%#x)\n", GetCurrentThreadId(), m_hDolphinThread, hr);
		}

		::CloseHandle(m_hDolphinThread);
		m_hDolphinThread = NULL;
	}
	return dwExitCode;
}

void CInProcPlugHole::SetImageInfo(LPCWSTR szImagePath, LPVOID imageData, size_t imageSize)
{
	wcscpy(achImagePath, szImagePath);
	m_pImageData = imageData;
	m_cImageSize = imageSize;
}

void CInProcPlugHole::UpdateImagePathForCLSID(REFCLSID rclsid)
{
	USES_CONVERSION;
	_ASSERTE(rclsid != CLSID_NULL);

	// Find a suitable image if one has not already been specified and a CLSID is available 
	// to look up in the registry for an Image subkey.
	if (wcslen(achImagePath) == 0)
	{
		// The stub is being used to load a standard Dolphin image, rather than one bound 
		// up with the stub, so we have to look up the image to load in the registry
		LPOLESTR wszCLSID;
		HRESULT hr = StringFromCLSID(rclsid, &wszCLSID);
		if (SUCCEEDED(hr))
		{
			CoTaskMemString clsidDeleter(wszCLSID);

			wchar_t szKey[5+1+38+1+5+1] = L"CLSID\\";
			wcscat(szKey, wszCLSID);
			wcscat(szKey, L"\\Image");
			_ASSERTE(wcslen(szKey) < _countof(szKey));
			RegKey rKey;
			if (ERROR_SUCCESS == rKey.Open(HKEY_CLASSES_ROOT, szKey))
			{
				ULONG nChars = _MAX_PATH;
				rKey.QueryStringValue(L"", achImagePath, &nChars);
			}
		}
	}
}

// Start the peer (unless someone has beaten us to it)
HRESULT CInProcPlugHole::StartPeer(IIPDolphin** ppiPeer, REFCLSID rclsid, CLSCTX ctx)
{
	*ppiPeer = NULL;

	// Lock the object while we check whether the VM should be started (another thread may
	// have beat us to it). However we don't hold the lock any longer than necessary, as 
	// otherwise the VM can't call back with its peer interface without a deadlock occurring
	HRESULT hr = CO_E_ERRORINDLL;
	{
		ObjectLock lock(this);

		if (m_piMarshalledPeer == NULL && m_dwVMStarterId == 0)
		{
			if (rclsid != CLSID_NULL)
				UpdateImagePathForCLSID(rclsid);

			hr = StartVM(ctx);

			// Prevent any other threads from attempting to start the VM when
			// we release the lock but before the image calls back with the peer 
			// interface pointer
			if (SUCCEEDED(hr))
				m_dwVMStarterId = CoGetCurrentProcess();
		}
	}

	if (m_dwVMStarterId != 0)
	{
		WaitForPeerToStart();
		IIPDolphinPtr piPeer = GetPeerForCurrentThread();
		if (piPeer)
		{
			// Reacquire the lock for once off initialization if this is the thread that
			// started the VM
			//ObjectLock lock(this);
			if (m_dwVMStarterId == CoGetCurrentProcess())
			{
				// This is the thread that started the VM, so initialize the peer
				hr = piPeer->OnInitialize();
				if (FAILED(hr))
					Shutdown();
				else
					*ppiPeer = piPeer.Detach();
			}

		}
		else
		{
			// Deliberately terminate the VM here, but how?
			// Shutdown();
			hr = CO_E_APPDIDNTREG;
		}
	}

	return hr;
}

HRESULT CInProcPlugHole::GetPeer(IIPDolphin** ppiPeer, REFCLSID rclsid, CLSCTX ctx)
{
	_ASSERTE(!m_hDolphinThread);
	
	TRACE(L"%#x: GetPeer(%s@%d, %#x)\n", GetCurrentThreadId(), achImagePath, m_pImageData, ctx);

	HRESULT hr = S_OK;

	if (m_piMarshalledPeer == NULL)
		hr = StartPeer(ppiPeer, rclsid, ctx);
	else
	{
		IIPDolphinPtr piPeer = GetPeerNoWait();
		if (piPeer != NULL)
		{
			*ppiPeer = piPeer.Detach();
			hr = S_OK;
		}
		else
		{
			*ppiPeer = NULL;
			hr = E_UNEXPECTED;
		}
	}

	return hr;
}


HRESULT CInProcPlugHole::Shutdown()
{
	// Presumably we only receive this once from one of the threads?
	// No we actually seem to get it from each, but only the first will be
	// acted upon.

	TRACE(L"%#x: Shutdown(%s)\n", GetCurrentThreadId(), GetImagePath());
	
	IIPDolphinPtr piPeer;
	{
		ObjectLock lock(this);
		piPeer = GetPeerForCurrentThread();
		if (piPeer != NULL)
			ReleasePeer();
		else
		{
			TRACE(L"%#x: CInProcPlugHole(%s)::Shutdown() thread %#x: No peer available\n", GetCurrentThreadId(), GetImagePath());
			return 0;
		}
	}

	_ASSERTE(piPeer != NULL);

	HRESULT hr = piPeer->OnShutdown();
	TRACE(L"%#x: Shutdown() peer shutdown request returned %#x\n", GetCurrentThreadId(), hr);

	piPeer.Release();

	DWORD dwExitCode = WaitForPeerToTerminate();

	return dwExitCode * -1;
}

HRESULT CInProcPlugHole::RegisterServer()
{
	TRACE(L"%#x: RegisterServer(%s) thread %#x\n", GetCurrentThreadId(), GetImagePath());

	// Only attempt to register the image classes if bound to the stub
	if (m_pImageData == NULL)
		return S_OK;

	IIPDolphinPtr piPeer;
	HRESULT hr = GetPeer(&piPeer);
	if (FAILED(hr))
	{
		trace(L"%#x: CInProcPlugHole(%s)::RegisterServer() No peer available\n", GetCurrentThreadId(), GetImagePath());
		return hr;
	}

	_ASSERTE(piPeer != NULL);

	hr = piPeer->RegisterServer();
	TRACE(L"RegisterServer() request returned %#x\n", hr);

	return hr;
}

HRESULT CInProcPlugHole::UnregisterServer()
{
	TRACE(L"%#x: UnregisterServer(%s)\n", GetCurrentThreadId(), GetImagePath());

	// Only attempt to unregister the image classes if bound to the stub
	if (m_pImageData == NULL)
		return S_OK;

	IIPDolphinPtr piPeer;
	HRESULT hr = GetPeer(&piPeer);
	if (FAILED(hr))
	{
		trace(L"%#x: CInProcPlugHole(%s)::UnregisterServer() No peer available\n", GetCurrentThreadId(), GetImagePath());
		return hr;
	}

	hr = piPeer->UnregisterServer();
	TRACE(L"%#x: UnregisterServer() request returned %#x\n", GetCurrentThreadId(), hr);

	return hr;
}

HRESULT CInProcPlugHole::CanUnloadNow()
{
	TRACE(L"%#x: CanUnloadNow(%s) thread %#x\n", GetCurrentThreadId(), GetImagePath());
	
	IIPDolphinPtr piPeer = GetPeerNoWait();
	if (piPeer == NULL)
	{
		TRACE(L"%#x: CInProcPlugHole(%s)::CanUnloadNow() No peer available\n", GetCurrentThreadId(), GetImagePath());
		return S_OK;
	}

	HRESULT hr = piPeer->CanUnloadNow();
	TRACE(L"%#x: CanUnloadNow() request returned %d\n", GetCurrentThreadId(), hr);

	return hr;
}

HRESULT CInProcPlugHole::GetClassObject(REFCLSID rclsid, REFIID riid, LPVOID* ppv)
{
	TRACE(L"%#x: GetClassObject(%s) thread %#x\n", GetCurrentThreadId(), GetImagePath());
	
	IIPDolphinPtr piPeer;
	HRESULT hr = GetPeer(&piPeer, rclsid);
	if (FAILED(hr))
	{
		trace(L"%#x: CInProcPlugHole(%s)::GetClassObject() thread %#x: No peer available\n", GetCurrentThreadId(), GetImagePath());
		return hr;
	}

	hr = piPeer->GetClassObject(rclsid, riid, ppv);
	TRACE(L"%#x: GetClassObject() request returned %d\n", GetCurrentThreadId(), hr);

	return hr;
}

/////////////////////////////////////////////////////////////////////////////
// IInProcPlugHole

STDMETHODIMP CInProcPlugHole::get_Peer(/*IIPDolphin*/IUnknown **ppiPeer)
{
	IIPDolphinPtr piPeer = GetPeerNoWait();
	*ppiPeer = piPeer.Detach();
	return S_OK;
}

STDMETHODIMP CInProcPlugHole::put_Peer(/*IIPDolphin*/IUnknown* piPeer)
{
	TRACE(L"%#x: CInProcPlugHole(%s)::put_Peer(%#x)\n", GetCurrentThreadId(), GetImagePath(), piPeer);

	ObjectLock lock(this);

	ReleasePeer();
	HRESULT hr = S_OK;
	if (piPeer)
	{
		hr = ::CoMarshalInterThreadInterfaceInStream(__uuidof(IIPDolphin), piPeer, &m_piMarshalledPeer);

		// Signal the event to stop the wait loop, WHETHER OR NOT
		// peer interface is correct.
		SetEvent(m_hPeerAvailable);
	}

	return hr;
}
