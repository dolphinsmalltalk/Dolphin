"Filed out from Dolphin Smalltalk 7"!

ThemeLibrary subclass: #MockThemeLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MockThemeLibrary guid: (GUID fromString: '{44aa9479-53f3-4ca9-8949-89d3d916b997}')!
MockThemeLibrary comment: 'MockThemeLibrary is a dummy ThemeLibrary used on host systems that do not have UXTHEME.DLL (i.e. anything earlier than Windows XP). Its main purpose is to avoid the need to test for Windows XP in some cases where theme calls are needed on XP, but are not relevant on older platforms. Most of the methods do nothing, but in some cases a sensible implementation is provided, in particular the tests for theming available and active answer false. These tests would typically be used to guard most theme related code, so no other theme library calls would then be made.'!
!MockThemeLibrary categoriesForClass!Win32-Modules! !
!MockThemeLibrary methodsFor!

closeThemeData: htheme
	"Invoke the CloseThemeData() function of the module wrapped by the receiver.
	Helpstring: Closes the theme data handle.

		HRESULT __stdcall CloseThemeData(
			[in]HTHEME HTHEME);"

	^E_NOTIMPL!

drawThemeBackground: htheme hdc: hDC iPartId: iPartId iStateId: iStateId pRect: pRect pClipRect: pClipRect 
	"Invoke the DrawThemeBackground() function of the module wrapped by the receiver.
	Helpstring: Draws the theme-specified border and fill for the 'iPartId' and 'iStateId'.

		HRESULT __stdcall DrawThemeBackground(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECT* pRect,
			[in]RECT* pClipRect);"

	| canvas |
	canvas := Canvas withNonOwnedDC: hDC.
	canvas fillRectangle: pRect.
	^S_OK!

drawThemeBackgroundEx: htheme hdc: hDC iPartId: iPartId iStateId: iStateId pRect: pRect pOptions: pOptions 
	"Invoke the DrawThemeBackgroundEx() function of the module wrapped by the receiver.
	Helpstring: Draws the theme-specified border and fill for the 'iPartId' and 'iStateId'.

		HRESULT __stdcall DrawThemeBackgroundEx(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECT* pRect,
			[in]DTBGOPTS* pOptions);"

	^self 
		drawThemeBackground: htheme
		hdc: hDC
		iPartId: iPartId
		iStateId: iStateId
		pRect: pRect
		pClipRect: pRect!

drawThemeEdge: htheme hdc: hDC iPartId: iPartId iStateId: iStateId pDestRect: pDestRect uEdge: uEdge uFlags: uFlags pContentRect: pContentRect 
	"Invoke the DrawThemeEdge() function of the module wrapped by the receiver.
	Helpstring: Similar to the DrawEdge() API, but uses part colors and is high-DPI aware

		HRESULT __stdcall DrawThemeEdge(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECT* pDestRect,
			[in]unsigned int uEdge,
			[in]unsigned int uFlags,
			[out]RECT* pContentRect);"

	^E_NOTIMPL!

drawThemeIcon: htheme hdc: hDC iPartId: iPartId iStateId: iStateId pRect: pRect himl: himl iImageIndex: iImageIndex 
	"Invoke the DrawThemeIcon() function of the module wrapped by the receiver.
	Helpstring: Draws an image within an imagelist based on a (possible) theme-defined effect. 

		HRESULT __stdcall DrawThemeIcon(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECT* pRect,
			[in]HANDLE himl,
			[in]int iImageIndex);"

	^E_NOTIMPL!

drawThemeParentBackground: hwnd hdc: hDC prc: prc 
	"Invoke the DrawThemeParentBackground() function of the module wrapped by the receiver.
	Helpstring: Used by partially-transparent or alpha-blended child controls to draw the part of their parent that they appear in front of.

		HRESULT __stdcall DrawThemeParentBackground(
			[in]HANDLE hwnd,
			[in]HANDLE hDC,
			[in, optional]RECT* prc);"

	| offset parent lResult oldOrg |
	parent := UserLibrary default getParent: hwnd.
	offset := POINTL new.
	UserLibrary default 
		mapWindowPoints: hwnd
		hWndTo: parent
		lpPoints: offset
		cPoints: 1.
	oldOrg := POINTL new.
	(GDILibrary default 
		offsetWindowOrgEx: hDC
		nXOrg: offset x
		nYOrg: offset y
		lppt: oldOrg) ifFalse: [^HRESULT win32Error: KernelLibrary default getLastError].
	lResult := UserLibrary default 
				sendMessage: parent
				msg: WM_PRINTCLIENT
				wParam: hDC
				lParam: PRF_CLIENT.
	GDILibrary default 
		setWindowOrgEx: hDC
		nXOrg: oldOrg x
		nYOrg: oldOrg y
		lppt: offset.
	^S_OK!

drawThemeText: htheme hdc: hDC iPartId: iPartId iStateId: iStateId pszText: pszText iCharCount: iCharCount dwTextFlags: dwTextFlags dwTextFlags2: dwTextFlags2 pRect: pRect 
	"Invoke the DrawThemeText() function of the module wrapped by the receiver.
	Helpstring: Draws the text using the theme-specified color and font for the 'iPartId' and 'iStateId'

		HRESULT __stdcall DrawThemeText(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]LPWSTR pszText,
			[in]int iCharCount,
			[in]unsigned long dwTextFlags,
			[in]unsigned long dwTextFlags2,
			[in]RECT* pRect);"

	^E_NOTIMPL!

enableThemeDialogTexture: hwnd dwFlags: dwFlags
	"Invoke the EnableThemeDialogTexture() function of the module wrapped by the receiver.
	Helpstring: Enables/disables dialog background theme.

		HRESULT __stdcall EnableThemeDialogTexture(
			[in]HANDLE hwnd,
			[in]unsigned long dwFlags);"

	^E_NOTIMPL!

enableTheming: fEnable
	"Invoke the EnableTheming() function of the module wrapped by the receiver.
	Helpstring: Enables or disables themeing for the current user in the current and future sessions.

		HRESULT __stdcall EnableTheming(
			[in]BOOL fEnable);"

	^E_NOTIMPL!

getCurrentThemeName: pszThemeFileName cchMaxNameChars: cchMaxNameChars pszColorBuff: pszColorBuff cchMaxColorChars: cchMaxColorChars pszSizeBuff: pszSizeBuff cchMaxSizeChars: cchMaxSizeChars
	"Invoke the GetCurrentThemeName() function of the module wrapped by the receiver.
	Helpstring: Get the name of the current theme in-use. 

		HRESULT __stdcall GetCurrentThemeName(
			[out]LPWSTR pszThemeFileName,
			[in]int cchMaxNameChars,
			[out]LPWSTR pszColorBuff,
			[in]int cchMaxColorChars,
			[out]LPWSTR pszSizeBuff,
			[in]int cchMaxSizeChars);"

	^E_NOTIMPL!

getThemeAppProperties
	"Invoke the GetThemeAppProperties() function of the module wrapped by the receiver.
	Helpstring: Returns the app property flags that control theming

		unsigned long __stdcall GetThemeAppProperties();"

	^E_NOTIMPL!

getThemeBackgroundContentRect: htheme hdc: hDC iPartId: iPartId iStateId: iStateId pBoundingRect: pBoundingRect pContentRect: pContentRect 
	"Invoke the GetThemeBackgroundContentRect() function of the module wrapped by the receiver.
	Helpstring: Gets the size of the content for the theme-defined background.  This is usually the area inside the borders or Margins.

		HRESULT __stdcall GetThemeBackgroundContentRect(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECT* pBoundingRect,
			[out]RECT* pContentRect);"

	^E_NOTIMPL!

getThemeBackgroundExtent: htheme hdc: hDC iPartId: iPartId iStateId: iStateId pContentRect: pContentRect pExtentRect: pExtentRect 
	"Invoke the GetThemeBackgroundExtent() function of the module wrapped by the receiver.
	Helpstring: Calculates the size/location of the theme-specified background based on the 'pContentRect'.

		HRESULT __stdcall GetThemeBackgroundExtent(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECT* pContentRect,
			[out]RECT* pExtentRect);"

	pExtentRect copyBytes: pContentRect.
	^S_OK!

getThemeBackgroundRegion: htheme hdc: hDC iPartId: iPartId iStateId: iStateId pRect: pRect pRegion: pRegion 
	"Invoke the GetThemeBackgroundRegion() function of the module wrapped by the receiver.
	Helpstring: Computes the region for a regular or partially transparent theme-specified background that is bound by the specified 'pRect'.

		HRESULT __stdcall GetThemeBackgroundRegion(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECT* pRect,
			[out]HANDLE* pRegion);"

	^E_NOTIMPL!

getThemeBool: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pfVal: pfVal
	"Invoke the GetThemeBool() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified BOOL property

		HRESULT __stdcall GetThemeBool(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]BOOL* pfVal);"

	^E_NOTIMPL!

getThemeColor: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pColor: pColor
	"Invoke the GetThemeColor() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified COLOR property

		HRESULT __stdcall GetThemeColor(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]unsigned long* pColor);"

	pColor value: CLR_DEFAULT.
	^E_NOTIMPL!

getThemeDocumentationProperty: pszThemeName pszPropertyName: pszPropertyName pszValueBuff: pszValueBuff cchMaxValChars: cchMaxValChars
	"Invoke the GetThemeDocumentationProperty() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified property name from the [documentation] section of the themes.ini file for the specified theme. 

		HRESULT __stdcall GetThemeDocumentationProperty(
			[in]LPWSTR pszThemeName,
			[in]LPWSTR pszPropertyName,
			[out]LPWSTR pszValueBuff,
			[in]int cchMaxValChars);"

	^E_NOTIMPL!

getThemeEnumValue: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId piVal: piVal
	"Invoke the GetThemeEnumValue() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified ENUM property

		HRESULT __stdcall GetThemeEnumValue(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]int* piVal);"

	^E_NOTIMPL!

getThemeFilename: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pszThemeFileName: pszThemeFileName cchMaxBuffChars: cchMaxBuffChars
	"Invoke the GetThemeFilename() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified FILENAME property

		HRESULT __stdcall GetThemeFilename(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]LPWSTR pszThemeFileName,
			[in]int cchMaxBuffChars);"

	^E_NOTIMPL!

getThemeFont: htheme hdc: hDC iPartId: iPartId iStateId: iStateId iPropId: iPropId pFont: pFont 
	"Invoke the GetThemeFont() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified font property

		HRESULT __stdcall GetThemeFont(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]LOGFONT* pFont);"

	^E_NOTIMPL!

getThemeInt: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId piVal: piVal
	"Invoke the GetThemeInt() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified int property

		HRESULT __stdcall GetThemeInt(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]int* piVal);"

	^E_NOTIMPL!

getThemeIntList: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pIntList: pIntList 
	"Invoke the GetThemeIntList() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified INTLIST struct

		HRESULT __stdcall GetThemeIntList(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]INTLIST* pIntList);"

	^E_NOTIMPL!

getThemeMargins: htheme hdc: hDC iPartId: iPartId iStateId: iStateId iPropId: iPropId prc: prc pMargins: pMargins 
	"Invoke the GetThemeMargins() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified MARGINS property

		HRESULT __stdcall GetThemeMargins(
			[in]HTHEME HTHEME,
			[in]HANDLEhDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[in]RECT* prc,
			[out]MARGINS* pMargins);"

	^E_NOTIMPL!

getThemeMetric: htheme hdc: hDC iPartId: iPartId iStateId: iStateId iPropId: iPropId piVal: piVal 
	"Invoke the GetThemeMetric() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified metric/size property

		HRESULT __stdcall GetThemeMetric(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]int* piVal);"

	^E_NOTIMPL!

getThemePartSize: htheme hdc: hDC iPartId: iPartId iStateId: iStateId prc: prc eSize: eSize psz: psz 
	"Invoke the GetThemePartSize() function of the module wrapped by the receiver.
	Helpstring: Returns the specified size of the theme part

		HRESULT __stdcall GetThemePartSize(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECT* prc,
			[in]THEMESIZE eSize,
			[out]SIZE* psz);"

	^E_NOTIMPL!

getThemePosition: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pPoint: pPoint
	"Invoke the GetThemePosition() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified position property

		HRESULT __stdcall GetThemePosition(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]POINT* pPoint);"

	^E_NOTIMPL!

getThemePropertyOrigin: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pOrigin: pOrigin
	"Invoke the GetThemePropertyOrigin() function of the module wrapped by the receiver.
	Helpstring: Searches for the specified theme property and sets 'pOrigin' to indicate where it was found (or not found)

		HRESULT __stdcall GetThemePropertyOrigin(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]PROPERTYORIGIN* pOrigin);"

	^E_NOTIMPL!

getThemeRect: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pRect: pRect 
	"Invoke the GetThemeRect() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified RECT property

		HRESULT __stdcall GetThemeRect(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]RECT* pRect);"

	^E_NOTIMPL!

getThemeString: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pszBuff: pszBuff cchMaxBuffChars: cchMaxBuffChars
	"Invoke the GetThemeString() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified string property

		HRESULT __stdcall GetThemeString(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]LPWSTR pszBuff,
			[in]int cchMaxBuffChars);"

	pszBuff basicAt: 1 put: 0.
	^E_NOTIMPL!

getThemeSysBool: htheme iBoolId: iBoolId
	"Invoke the GetThemeSysBool() function of the module wrapped by the receiver.
	Helpstring: Get the boolean value of specified System metric

		BOOL __stdcall GetThemeSysBool(
			[in]HTHEME HTHEME,
			[in]int iBoolId);"

	^false!

getThemeSysColor: htheme iColorId: iColorId 
	"Invoke the GetThemeSysColor() function of the module wrapped by the receiver.
	Helpstring: Get the value of the specified System color

		unsigned long __stdcall GetThemeSysColor(
			[in]HTHEME HTHEME,
			[in]int iColorId);"

	^(SystemColor fromId: iColorId) asCOLORREF!

getThemeSysColorBrush: htheme iColorId: iColorId 
	"Invoke the GetThemeSysColorBrush() function of the module wrapped by the receiver.
	Helpstring: Get the brush for the specified System color

		HANDLE __stdcall GetThemeSysColorBrush(
			[in]HTHEME HTHEME,
			[in]int iColorId);"

	^UserLibrary default getSysColorBrush: iColorId!

getThemeSysFont: htheme iFontId: iFontId plf: plf
	"Invoke the GetThemeSysFont() function of the module wrapped by the receiver.
	Helpstring: Get the LOGFONT for the specified System font.

		HRESULT __stdcall GetThemeSysFont(
			[in]HTHEME HTHEME,
			[in]int iFontId,
			[out]LOGFONT* plf);"

	^E_NOTIMPL!

getThemeSysInt: htheme iIntId: iIntId piValue: piValue
	"Invoke the GetThemeSysInt() function of the module wrapped by the receiver.
	Helpstring: Get the value of specified System int.

		HRESULT __stdcall GetThemeSysInt(
			[in]HTHEME HTHEME,
			[in]int iIntId,
			[out]int* piValue);"

	^E_NOTIMPL!

getThemeSysSize: htheme iSizeId: iSizeId
	"Invoke the GetThemeSysSize() function of the module wrapped by the receiver.
	Helpstring: Get the value of the specified System size metric. (scaled for the current logical screen dpi)

		int __stdcall GetThemeSysSize(
			[in]HTHEME HTHEME,
			[in]int iSizeId);"

	^0!

getThemeSysString: htheme iStringId: iStringId pszStringBuff: pszStringBuff cchMaxStringChars: cchMaxStringChars
	"Invoke the GetThemeSysString() function of the module wrapped by the receiver.
	Helpstring: Get the value of specified System string metric.

		HRESULT __stdcall GetThemeSysString(
			[in]HTHEME HTHEME,
			[in]int iStringId,
			[out]LPWSTR pszStringBuff,
			[in]int cchMaxStringChars);"

	^E_NOTIMPL!

getThemeTextExtent: htheme hdc: hDC iPartId: iPartId iStateId: iStateId pszText: pszText iCharCount: iCharCount dwTextFlags: dwTextFlags pBoundingRect: pBoundingRect pExtentRect: pExtentRect 
	"Invoke the GetThemeTextExtent() function of the module wrapped by the receiver.
	Helpstring: Calculates the size/location of the specified text when rendered in the Theme Font

		HRESULT __stdcall GetThemeTextExtent(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]LPWSTR pszText,
			[in]int iCharCount,
			[in]unsigned long dwTextFlags,
			[in]RECT* pBoundingRect,
			[out]RECT* pExtentRect);"

	#todo.	"Can implement this"
	^E_NOTIMPL!

getThemeTextMetrics: htheme hdc: hDC iPartId: iPartId iStateId: iStateId pTM: ptm 
	"Invoke the GetThemeTextMetrics() function of the module wrapped by the receiver.
	Helpstring: Returns info about the theme-specified font for the part/state passed in.

		HRESULT __stdcall GetThemeTextMetrics(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[out]TEXTMETRIC* ptm);"

	^(GDILibrary default getTextMetrics: hDC lptm: ptm) 
		ifTrue: [S_OK]
		ifFalse: [(HRESULT win32Error: 2) asInteger]!

getWindowTheme: hwnd 
	"Invoke the GetWindowTheme() function of the module wrapped by the receiver.
	Helpstring: If window is themed, returns its most recent HTHEME from OpenThemeData() - otherwise, returns NULL.

		HTHEME __stdcall GetWindowTheme(
			[in]HANDLE hwnd);"

	^nil!

hitTestThemeBackground: htheme hdc: hDC iPartId: iPartId iStateId: iStateId dwOptions: dwOptions pRect: pRect hrgn: hrgn ptTest: ptTest pwHitTestCode: pwHitTestCode 
	"Invoke the HitTestThemeBackground() function of the module wrapped by the receiver.
	Helpstring: Returns a HitTestCode (a subset of the values returned by WM_NCHITTEST) for the point 'ptTest' within the theme-specified background (bound by pRect).

		HRESULT __stdcall HitTestThemeBackground(
			[in]HTHEME HTHEME,
			[in]HANDLE hDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]unsigned long dwOptions,
			[in]RECT* pRect,
			[in]HANDLE hrgn,
			[in]POINT ptTest,
			[out]unsigned short* pwHitTestCode);"

	^E_NOTIMPL!

isAppThemed
	"Invoke the IsAppThemed() function of the module wrapped by the receiver.
	Helpstring: Returns TRUE if a theme is active and available to the current process

		BOOL __stdcall IsAppThemed();"

	^false!

isThemeActive
	"Invoke the IsThemeActive() function of the module wrapped by the receiver.
	Helpstring: Can be used to test if a system theme is active for the current user session.

		BOOL __stdcall IsThemeActive();"

	^false!

isThemeBackgroundPartiallyTransparent: htheme iPartId: iPartId iStateId: iStateId 
	"Invoke the IsThemeBackgroundPartiallyTransparent() function of the module wrapped by the receiver.
	Helpstring: Returns TRUE if the theme specified background for the part/state has transparent pieces or alpha-blended pieces.

		BOOL __stdcall IsThemeBackgroundPartiallyTransparent(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId);"

	^false!

isThemeDialogTextureEnabled: hwnd 
	"Invoke the IsThemeDialogTextureEnabled() function of the module wrapped by the receiver.
	Helpstring: Reports whether the dialog supports background texturing.

	BOOL __stdcall IsThemeDialogTextureEnabled(
			[in]long hwnd);"

	^false!

isThemePartDefined: htheme iPartId: iPartId iStateId: iStateId 
	"Invoke the IsThemePartDefined() function of the module wrapped by the receiver.
	Helpstring: Returns TRUE if the theme has defined parameters for the specified 'iPartId' and 'iStateId'.

		BOOL __stdcall IsThemePartDefined(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId);"

	^false!

open: aString
	"Private - Open the external library with the external file name, aString,
	as the library referenced by the receiver. Answer the receiver.
	The library is initialized."

	self initialize!

openThemeData: hwnd pszClassList: pszClassList 
	"Invoke the OpenThemeData() function of the module wrapped by the receiver.
	Helpstring: Open the theme data for the specified HWND and semi-colon separated list of class names.

		HTHEME __stdcall OpenThemeData(
			[in]long hwnd,
			[in]LPWSTR pszClassList);"

	^nil!

setThemeAppProperties: dwFlags 
	"Invoke the SetThemeAppProperties() function of the module wrapped by the receiver.
	Helpstring: Sets the flags that control theming within the app

		void __stdcall SetThemeAppProperties(
			[in]unsigned long dwFlags);"

	^E_NOTIMPL!

setWindowTheme: hwnd pszSubAppName: pszSubAppName pszSubIdList: pszSubIdList 
	"Invoke the SetWindowTheme() function of the module wrapped by the receiver.
	Helpstring: Redirects an existing Window to use a different section of the current theme information than its class normally asks for

		HRESULT __stdcall SetWindowTheme(
			[in]HANDLE hwnd,
			[in]LPWSTR pszSubAppName,
			[in]LPWSTR pszSubIdList);"

	^E_NOTIMPL! !
!MockThemeLibrary categoriesFor: #closeThemeData:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #drawThemeBackground:hdc:iPartId:iStateId:pRect:pClipRect:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #drawThemeBackgroundEx:hdc:iPartId:iStateId:pRect:pOptions:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #drawThemeEdge:hdc:iPartId:iStateId:pDestRect:uEdge:uFlags:pContentRect:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #drawThemeIcon:hdc:iPartId:iStateId:pRect:himl:iImageIndex:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #drawThemeParentBackground:hdc:prc:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #drawThemeText:hdc:iPartId:iStateId:pszText:iCharCount:dwTextFlags:dwTextFlags2:pRect:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #enableThemeDialogTexture:dwFlags:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #enableTheming:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getCurrentThemeName:cchMaxNameChars:pszColorBuff:cchMaxColorChars:pszSizeBuff:cchMaxSizeChars:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeAppProperties!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeBackgroundContentRect:hdc:iPartId:iStateId:pBoundingRect:pContentRect:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeBackgroundExtent:hdc:iPartId:iStateId:pContentRect:pExtentRect:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeBackgroundRegion:hdc:iPartId:iStateId:pRect:pRegion:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeBool:iPartId:iStateId:iPropId:pfVal:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeColor:iPartId:iStateId:iPropId:pColor:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeDocumentationProperty:pszPropertyName:pszValueBuff:cchMaxValChars:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeEnumValue:iPartId:iStateId:iPropId:piVal:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeFilename:iPartId:iStateId:iPropId:pszThemeFileName:cchMaxBuffChars:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeFont:hdc:iPartId:iStateId:iPropId:pFont:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeInt:iPartId:iStateId:iPropId:piVal:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeIntList:iPartId:iStateId:iPropId:pIntList:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeMargins:hdc:iPartId:iStateId:iPropId:prc:pMargins:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeMetric:hdc:iPartId:iStateId:iPropId:piVal:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemePartSize:hdc:iPartId:iStateId:prc:eSize:psz:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemePosition:iPartId:iStateId:iPropId:pPoint:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemePropertyOrigin:iPartId:iStateId:iPropId:pOrigin:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeRect:iPartId:iStateId:iPropId:pRect:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeString:iPartId:iStateId:iPropId:pszBuff:cchMaxBuffChars:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeSysBool:iBoolId:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeSysColor:iColorId:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeSysColorBrush:iColorId:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeSysFont:iFontId:plf:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeSysInt:iIntId:piValue:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeSysSize:iSizeId:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeSysString:iStringId:pszStringBuff:cchMaxStringChars:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeTextExtent:hdc:iPartId:iStateId:pszText:iCharCount:dwTextFlags:pBoundingRect:pExtentRect:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getThemeTextMetrics:hdc:iPartId:iStateId:pTM:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #getWindowTheme:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #hitTestThemeBackground:hdc:iPartId:iStateId:dwOptions:pRect:hrgn:ptTest:pwHitTestCode:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #isAppThemed!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #isThemeActive!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #isThemeBackgroundPartiallyTransparent:iPartId:iStateId:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #isThemeDialogTextureEnabled:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #isThemePartDefined:iPartId:iStateId:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #open:!private!realizing/unrealizing! !
!MockThemeLibrary categoriesFor: #openThemeData:pszClassList:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #setThemeAppProperties:!public!win32 functions-visual styles! !
!MockThemeLibrary categoriesFor: #setWindowTheme:pszSubAppName:pszSubIdList:!public!win32 functions-visual styles! !

