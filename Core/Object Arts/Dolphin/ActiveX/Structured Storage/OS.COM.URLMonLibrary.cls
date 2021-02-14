"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'OS.COM.URLMonLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.URLMonLibrary guid: (Core.GUID fromString: '{08630ee6-54c6-11d3-bdd1-004005a6900b}')!
OS.COM.URLMonLibrary comment: ''!
!OS.COM.URLMonLibrary categoriesForClass!External-Libraries-Win32! !
!OS.COM.URLMonLibrary methodsFor!

overlappedURLDownloadToCacheFile: pCaller szURL: szURL szFilename: szFilename dwBufLength: dwBufLegth dwReserved: dwReserved pBSC: pBsc
	"Downloads data into the Internet cache and returns the file name of the cache location for retrieving the bits.

	HRESULT URLDownloadToCacheFile(
		LPUNKNOWN lpUnkcaller,
		LPCSTR szURL,
		LPWSTR szFileName,
		DWORD dwBufLength,
		DWORD dwReserved,
		IBindStatusCallback *pBSC
		);"

	<overlap stdcall: hresult URLDownloadToCacheFileW IUnknown* lpwstr lpwstr dword dword lpvoid>
	^self invalidCall: _failureCode!

overlappedURLDownloadToFile: pCaller szURL: szURL szFilename: szFilename dwReserved: dwReserved pBSC: pBsc
	"Downloads bits from the Internet and saves them to a file.
		HRESULT URLDownloadToFile(
			LPUNKNOWN pCaller,
			LPCTSTR szURL,
			LPCTSTR szFileName,
			DWORD dwReserved,
			LPBINDSTATUSCALLBACK lpfnCB
	);"

	<overlap stdcall: hresult URLDownloadToFileW IUnknown* lpwstr lpwstr dword lpvoid>
	^self invalidCall: _failureCode!

urlDownload: url toFile: aStringFilename 
	"Helper method for downloading bits from the internet to a specified file.
	An HRESULTError is raised if the target does not exist, or some other error occurs. The HRESULT
	codes do not seem to be documented, but 16r800C0006 seems to result if the URL does not exist,
	which is likely to be the most common error.
	Note that the call is overlapped so that only the calling Smalltalk process is blocked (i.e. if a background
	thread is used to perform the download, one can avoid locking up the entire image until the download
	has completed)."

	self 
		overlappedURLDownloadToFile: nil
		szURL: url asUtf16String
		szFilename: aStringFilename asUtf16String
		dwReserved: 0
		pBSC: nil!

urlDownloadToCacheFile: url
	"Helper method for #urlDownloadToCacheFile:szURL:szFilename:dwBufLength:dwReserved:pBSC:.
	Downloads data at url into the local Internet cache and answers the file name of the cache location.
	An HRESULTError is raised if the target does not exist, or some other error occurs. The HRESULT
	codes do not seem to be documented, but 16r800C0006 seems to result if the URL does not exist,
	which is likely to be the most common error.
	Note that the call is overlapped so that only the calling Smalltalk process is blocked (i.e. if a background
	thread is used to perform the download, one can avoid locking up the entire image until the download
	has completed)."

	| filename |
	filename := File pathBuffer.	"String auto allocates extra byte for null terminator"
	self
		overlappedURLDownloadToCacheFile: nil
		szURL: url asUtf16String
		szFilename: filename
		dwBufLength: filename size
		dwReserved: 0
		pBSC: nil.
	^filename trimNulls!

urlDownloadToCacheFile: pCaller szURL: szURL szFilename: szFilename dwBufLength: dwBufLegth dwReserved: dwReserved pBSC: pBsc
	"Downloads data into the Internet cache and returns the file name of the cache location for retrieving the bits.

	HRESULT URLDownloadToCacheFile(
		LPUNKNOWN lpUnkcaller,
		LPCSTR szURL,
		LPTSTR szFileName,
		DWORD dwBufLength,
		DWORD dwReserved,
		IBindStatusCallback *pBSC
		);"

	<stdcall: hresult URLDownloadToCacheFileW IUnknown* lpwstr lpwstr dword dword lpvoid>
	^self invalidCall: _failureCode!

urlDownloadToFile: pCaller szURL: szURL szFilename: szFilename dwReserved: dwReserved pBSC: pBsc
	"Downloads bits from the Internet and saves them to a file.
		HRESULT URLDownloadToFile(
			LPUNKNOWN pCaller,
			LPCTSTR szURL,
			LPCTSTR szFileName,
			DWORD dwReserved,
			LPBINDSTATUSCALLBACK lpfnCB
		);"

	<stdcall: hresult URLDownloadToFileW IUnknown* lpwstr lpwstr dword lpvoid>
	^self invalidCall: _failureCode!

urlOpenBlockingStream: pCaller szURL: szURL ppStream: ppStream dwReserved: dwReserved lpfnCB: lpfnCB
	"Download data from the specified URL and answer an IStream attached to that.

	Note that this function is synchronous, and does not return until the download
	has completed (i.e. it isn't really openBlockingStream so much as openStreamBlocking).
	Unfortunately the returned IStream is not thread safe (it is presumably an apartment threaded
	object rather than a free-threaded one), and therefore the call cannot be easily overlapped.
	It might be possible to arrange this by explicitly marshalling the COM pointer back to the main
	VM thread using CoMarshalInterThreadInterfaceInStream(), but we have not tried this yet.

		HRESULT URLOpenBlockingStream( 
			LPUNKNOWN pCaller, 
			LPCSTR szURL, 
			LPSTREAM *ppStream, 
			DWORD dwReserved, 
			LPBINDSTATUSCALLBACK lpfnCB 
		);"

	<stdcall: hresult URLOpenBlockingStreamW IUnknown* lpwstr IStream** dword lpvoid>
	^self invalidCall: _failureCode!

urlOpenPullStream: pCaller szURL: szURL ppStream: ppStream dwReserved: dwReserved lpfnCB: lpfnCB
	"Download data from the specified URL and answer an IStream attached to that.

		HRESULT URLOpenPullStream( 
			LPUNKNOWN pCaller, 
			LPCSTR szURL, 
			LPSTREAM *ppStream, 
			DWORD dwReserved, 
			LPBINDSTATUSCALLBACK lpfnCB );"

	<stdcall: hresult URLOpenPullStreamW IUnknown* lpwstr IStream** dword lpvoid>
	^self invalidCall: _failureCode! !
!OS.COM.URLMonLibrary categoriesFor: #overlappedURLDownloadToCacheFile:szURL:szFilename:dwBufLength:dwReserved:pBSC:!public!win32 functions-internet! !
!OS.COM.URLMonLibrary categoriesFor: #overlappedURLDownloadToFile:szURL:szFilename:dwReserved:pBSC:!public!win32 functions-internet! !
!OS.COM.URLMonLibrary categoriesFor: #urlDownload:toFile:!operations!public! !
!OS.COM.URLMonLibrary categoriesFor: #urlDownloadToCacheFile:!operations!public! !
!OS.COM.URLMonLibrary categoriesFor: #urlDownloadToCacheFile:szURL:szFilename:dwBufLength:dwReserved:pBSC:!public!win32 functions-internet! !
!OS.COM.URLMonLibrary categoriesFor: #urlDownloadToFile:szURL:szFilename:dwReserved:pBSC:!public!win32 functions-internet! !
!OS.COM.URLMonLibrary categoriesFor: #urlOpenBlockingStream:szURL:ppStream:dwReserved:lpfnCB:!public!win32 functions-internet! !
!OS.COM.URLMonLibrary categoriesFor: #urlOpenPullStream:szURL:ppStream:dwReserved:lpfnCB:!public!win32 functions-internet! !

!OS.COM.URLMonLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'URLMON'! !
!OS.COM.URLMonLibrary class categoriesFor: #fileName!constants!public! !

