"Filed out from Dolphin Smalltalk 7"!

External.Library subclass: #'OS.ThemeLibrary'
	instanceVariableNames: ''
	classVariableNames: 'IsAppThemed'
	imports: #(#{OS.ThemeConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.ThemeLibrary guid: (Core.GUID fromString: '{fb91df3f-4cb4-48a2-adee-a75b9a4d30a2}')!
OS.ThemeLibrary comment: 'ThemeLibrary is the <ExternalLibrary> class to represent the dynamic link library, ''UXTHEME.DLL''.It was generated generated from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring for this module
	"Windows Theme Library. Only available in Windows XP and above."

Warning: This comment was automatically generated from the module''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	dllname("UXTHEME.DLL"), 
	uuid(FB91DF3F-4CB4-48A2-ADEE-A75B9A4D30A2), 
	helpstring("Windows Theme Library. Only available in Windows XP and above.")
]
module Theme
{
	[helpstring("Draw a grayed-out string")] const unsigned long DTT_GRAYED = 1;
	[helpstring("Theme background segment hit test flag (default)")] const unsigned long HTTB_BACKGROUNDSEG = 0;
	[helpstring("Fixed border hit test option")] const unsigned long HTTB_FIXEDBORDER = 2;
	[helpstring("Caption hit test option.")] const unsigned long HTTB_CAPTION = 4;
	[helpstring("Hit test left resizing border")] const unsigned long HTTB_RESIZINGBORDER_LEFT = 16;
	[helpstring("Hit test top resizing border")] const unsigned long HTTB_RESIZINGBORDER_TOP = 32;
	[helpstring("Hit test right resizing border")] const unsigned long HTTB_RESIZINGBORDER_RIGHT = 64;
	[helpstring("Hit test bottom resizing border")] const unsigned long HTTB_RESIZINGBORDER_BOTTOM = 128;
	[helpstring("Resizing border hit test flags")] const unsigned long HTTB_RESIZINGBORDER = 240;
	[helpstring("Resizing border is specified as a template, not just window edges.")] const unsigned long HTTB_SIZINGTEMPLATE = 256;
	[helpstring("Use system resizing border width rather than theme content margins.")] const unsigned long HTTB_SYSTEMSIZINGMARGINS = 512;
	[helpstring("disable background texturing")] const unsigned long ETDT_DISABLE = 1;
	[helpstring("enable the theme-defined dialog background texturing")] const unsigned long ETDT_ENABLE = 2;
	[helpstring("use the Tab texture (should be combined with ETDT_ENABLE)")] const unsigned long ETDT_USETABTEXTURE = 4;
	[helpstring("enable the theme-defined background texturing using the Tab texture")] const unsigned long ETDT_ENABLETAB = 6;
	const unsigned long STAP_ALLOW_NONCLIENT = 1;
	const unsigned long STAP_ALLOW_CONTROLS = 2;
	const unsigned long STAP_ALLOW_WEBCONTENT = 4;
	[helpstring("rcClip has been specified")] const unsigned long DTBG_CLIPRECT = 1;
	[helpstring("draw transparent/alpha images as solid")] const unsigned long DTBG_DRAWSOLID = 2;
	[helpstring("don''t draw border of part")] const unsigned long DTBG_OMITBORDER = 4;
	[helpstring("don''t draw content area of part")] const unsigned long DTBG_OMITCONTENT = 8;
	[helpstring("TRUE if calling to compute region")] const unsigned long DTBG_COMPUTINGREGION = 16;
	[helpstring("assume the hdc is mirrorred and flip images as appropriate (currently only supported for bgtype=imagefile)")] const unsigned long DTBG_MIRRORDC = 32;

	[entry(0x60000000), helpstring("Open the theme data for the specified HWND and semi-colon separated list of class names.")]
	HTHEME __stdcall OpenThemeData(
		[in]HANDLE hwnd,
		[in]LPWSTR pszClassList);
	[entry(0x60000001), helpstring("Closes the theme data handle.")]
	HRESULT __stdcall CloseThemeData(
		[in]HTHEME HTHEME);
	[entry(0x60000002), helpstring("Draws the theme-specified border and fill for the ''iPartId'' and ''iStateId''.")]
	HRESULT __stdcall DrawThemeBackground(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pRect,
		[in]RECT* pClipRect);
	[entry(0x60000003), helpstring("Draws the text using the theme-specified color and font for the ''iPartId'' and ''iStateId''")]
	HRESULT __stdcall DrawThemeText(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]LPWSTR pszText,
		[in]int iCharCount,
		[in]unsigned long dwTextFlags,
		[in]unsigned long dwTextFlags2,
		[in]RECT* pRect);
	[entry(0x60000004), helpstring("Gets the size of the content for the theme-defined background.  This is usually the area inside the borders or Margins.")]
	HRESULT __stdcall GetThemeBackgroundContentRect(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pBoundingRect,
		[out]RECT* pContentRect);
	[entry(0x60000005), helpstring("Calculates the size/location of the theme-specified background based on the ''pContentRect''.")]
	HRESULT __stdcall GetThemeBackgroundExtent(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pContentRect,
		[out]RECT* pExtentRect);
	[entry(0x60000006), helpstring("Returns the specified size of the theme part")]
	HRESULT __stdcall GetThemePartSize(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* prc,
		[in]THEMESIZE eSize,
		[out]SIZE* psz);
	[entry(0x60000007), helpstring("Calculates the size/location of the specified text when rendered in the Theme Font")]
	HRESULT __stdcall GetThemeTextExtent(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]LPWSTR pszText,
		[in]int iCharCount,
		[in]unsigned long dwTextFlags,
		[in]RECT* pBoundingRect,
		[out]RECT* pExtentRect);
	[entry(0x60000008), helpstring("Returns info about the theme-specified font for the part/state passed in.")]
	HRESULT __stdcall GetThemeTextMetrics(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[out]TEXTMETRIC* ptm);
	[entry(0x60000009), helpstring("Computes the region for a regular or partially transparent theme-specified background that is bound by the specified ''pRect''.")]
	HRESULT __stdcall GetThemeBackgroundRegion(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pRect,
		[out]long* pRegion);
	[entry(0x6000000a), helpstring("Returns a HitTestCode (a subset of the values returned by WM_NCHITTEST) for the point ''ptTest'' within the theme-specified background (bound by pRect).")]
	HRESULT __stdcall HitTestThemeBackground(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]unsigned long dwOptions,
		[in]RECT* pRect,
		[in]long hrgn,
		[in]POINT ptTest,
		[out]unsigned short* pwHitTestCode);
	[entry(0x6000000b), helpstring("Similar to the DrawEdge() API, but uses part colors and is high-DPI aware")]
	HRESULT __stdcall DrawThemeEdge(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pDestRect,
		[in]unsigned int uEdge,
		[in]unsigned int uFlags,
		[out]RECT* pContentRect);
	[entry(0x6000000c), helpstring("Draws an image within an imagelist based on a (possible) theme-defined effect. ")]
	HRESULT __stdcall DrawThemeIcon(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pRect,
		[in]HANDLE himl,
		[in]int iImageIndex);
	[entry(0x6000000d), helpstring("Returns TRUE if the theme has defined parameters for the specified ''iPartId'' and ''iStateId''.")]
	BOOL __stdcall IsThemePartDefined(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId);
	[entry(0x6000000e), helpstring("Returns TRUE if the theme specified background for the part/state has transparent pieces or alpha-blended pieces.")]
	BOOL __stdcall IsThemeBackgroundPartiallyTransparent(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId);
	[entry(0x6000000f), helpstring("Get the value for the specified COLOR property")]
	HRESULT __stdcall GetThemeColor(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]COLORREF* pColor);
	[entry(0x60000010), helpstring("Get the value for the specified metric/size property")]
	HRESULT __stdcall GetThemeMetric(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]int* piVal);
	[entry(0x60000011), helpstring("Get the value for the specified string property")]
	HRESULT __stdcall GetThemeString(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]LPWSTR pszBuff,
		[in]int cchMaxBuffChars);
	[entry(0x60000012), helpstring("Get the value for the specified BOOL property")]
	HRESULT __stdcall GetThemeBool(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]long* pfVal);
	[entry(0x60000013), helpstring("Get the value for the specified int property")]
	HRESULT __stdcall GetThemeInt(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]int* piVal);
	[entry(0x60000014), helpstring("Get the value for the specified ENUM property")]
	HRESULT __stdcall GetThemeEnumValue(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]int* piVal);
	[entry(0x60000015), helpstring("Get the value for the specified position property")]
	HRESULT __stdcall GetThemePosition(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]POINT* pPoint);
	[entry(0x60000016), helpstring("Get the value for the specified font property")]
	HRESULT __stdcall GetThemeFont(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]LOGFONT* pFont);
	[entry(0x60000017), helpstring("Get the value for the specified RECT property")]
	HRESULT __stdcall GetThemeRect(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]RECT* pRect);
	[entry(0x60000018), helpstring("Get the value for the specified MARGINS property")]
	HRESULT __stdcall GetThemeMargins(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[in]RECT* prc,
		[out]MARGINS* pMargins);
	[entry(0x60000019), helpstring("Get the value for the specified INTLIST struct")]
	HRESULT __stdcall GetThemeIntList(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]INTLIST* pIntList);
	[entry(0x6000001a), helpstring("Searches for the specified theme property and sets ''pOrigin'' to indicate where it was found (or not found)")]
	HRESULT __stdcall GetThemePropertyOrigin(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]PROPERTYORIGIN* pOrigin);
	[entry(0x6000001b), helpstring("Redirects an existing Window to use a different section of the current theme information than its class normally asks for")]
	HRESULT __stdcall SetWindowTheme(
		[in]HANDLE hwnd,
		[in]LPWSTR pszSubAppName,
		[in]LPWSTR pszSubIdList);
	[entry(0x6000001c), helpstring("Get the value for the specified FILENAME property")]
	HRESULT __stdcall GetThemeFilename(
		[in]HTHEME HTHEME,
		[in]int iPartId,
		[in]int iStateId,
		[in]int iPropId,
		[out]LPWSTR pszThemeFileName,
		[in]int cchMaxBuffChars);
	[entry(0x6000001d), helpstring("Get the value of the specified System color")]
	COLORREF __stdcall GetThemeSysColor(
		[in]HTHEME HTHEME,
		[in]int iColorId);
	[entry(0x6000001e), helpstring("Get the brush for the specified System color")]
	long __stdcall GetThemeSysColorBrush(
		[in]HTHEME HTHEME,
		[in]int iColorId);
	[entry(0x6000001f), helpstring("Get the boolean value of specified System metric")]
	BOOL __stdcall GetThemeSysBool(
		[in]HTHEME HTHEME,
		[in]int iBoolId);
	[entry(0x60000020), helpstring("Get the value of the specified System size metric. (scaled for the current logical screen dpi)")]
	int __stdcall GetThemeSysSize(
		[in]HTHEME HTHEME,
		[in]int iSizeId);
	[entry(0x60000021), helpstring("Get the LOGFONT for the specified System font.")]
	HRESULT __stdcall GetThemeSysFont(
		[in]HTHEME HTHEME,
		[in]int iFontId,
		[out]LOGFONT* plf);
	[entry(0x60000022), helpstring("Get the value of specified System string metric.")]
	HRESULT __stdcall GetThemeSysString(
		[in]HTHEME HTHEME,
		[in]int iStringId,
		[out]LPWSTR pszStringBuff,
		[in]int cchMaxStringChars);
	[entry(0x60000023), helpstring("Get the value of specified System int.")]
	HRESULT __stdcall GetThemeSysInt(
		[in]HTHEME HTHEME,
		[in]int iIntId,
		[out]int* piValue);
	[entry(0x60000024), helpstring("Can be used to test if a system theme is active for the current user session.")]
	BOOL __stdcall IsThemeActive();
	[entry(0x60000025), helpstring("Returns TRUE if a theme is active and available to the current process")]
	BOOL __stdcall IsAppThemed();
	[entry(0x60000026), helpstring("If window is themed, returns its most recent HTHEME from OpenThemeData() - otherwise, returns NULL.")]
	HTHEME __stdcall GetWindowTheme(
		[in]HANDLE hwnd);
	[entry(0x60000027), helpstring("Enables/disables dialog background theme.")]
	HRESULT __stdcall EnableThemeDialogTexture(
		[in]HANDLE hwnd,
		[in]unsigned long dwFlags);
	[entry(0x60000028), helpstring("Reports whether the dialog supports background texturing.")]
	BOOL __stdcall IsThemeDialogTextureEnabled(
		[in]HANDLE hwnd);
	[entry(0x60000029), helpstring("Returns the app property flags that control theming")]
	unsigned long __stdcall GetThemeAppProperties();
	[entry(0x6000002a), helpstring("Sets the flags that control theming within the app")]
	void __stdcall SetThemeAppProperties(
		[in]unsigned long dwFlags);
	[entry(0x6000002b), helpstring("Get the name of the current theme in-use. ")]
	HRESULT __stdcall GetCurrentThemeName(
		[out]LPWSTR pszThemeFileName,
		[in]int cchMaxNameChars,
		[out]LPWSTR pszColorBuff,
		[in]int cchMaxColorChars,
		[out]LPWSTR pszSizeBuff,
		[in]int cchMaxSizeChars);
	[entry(0x6000002c), helpstring("Get the value for the specified property name from the [documentation] section of the themes.ini file for the specified theme. ")]
	HRESULT __stdcall GetThemeDocumentationProperty(
		[in]LPWSTR pszThemeName,
		[in]LPWSTR pszPropertyName,
		[out]LPWSTR pszValueBuff,
		[in]int cchMaxValChars);
	[entry(0x6000002d), helpstring("Used by partially-transparent or alpha-blended child controls to draw the part of their parent that they appear in front of.")]
	HRESULT __stdcall DrawThemeParentBackground(
		[in]HANDLE hwnd,
		[in]HANDLE hDC,
		[in, optional]RECT* prc);
	[entry(0x6000002e), helpstring("Enables or disables themeing for the current user in the current and future sessions.")]
	HRESULT __stdcall EnableTheming(
		[in]BOOL fEnable);
	[entry(0x6000002f), helpstring("Draws the theme-specified border and fill for the ''iPartId'' and ''iStateId''.")]
	HRESULT __stdcall DrawThemeBackgroundEx(
		[in]HTHEME HTHEME,
		[in]HANDLE hDC,
		[in]int iPartId,
		[in]int iStateId,
		[in]RECT* pRect,
		[in]DTBGOPTS* pOptions);
};
'!
!OS.ThemeLibrary categoriesForClass!Win32-Modules! !
!OS.ThemeLibrary methodsFor!

closeThemeData: htheme
	"Invoke the CloseThemeData() function of the module wrapped by the receiver.
	Helpstring: Closes the theme data handle. Return value is HRESULT error code.

		long __stdcall CloseThemeData(
			[in]HTHEME HTHEME);"

	<stdcall: sdword CloseThemeData handle>
	^self invalidCall: _failureCode!

drawThemeBackground: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pRect: pRect pClipRect: pClipRect
	"Invoke the DrawThemeBackground() function of the module wrapped by the receiver.
	Helpstring: Draws the theme-specified border and fill for the 'iPartId' and 'iStateId'.

		HRESULT __stdcall DrawThemeBackground(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pRect,
			[in]RECTL* pClipRect);"

	<stdcall: hresult DrawThemeBackground handle handle sdword sdword RECTL* RECTL*>
	^self invalidCall: _failureCode!

drawThemeBackgroundEx: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pRect: pRect pOptions: pOptions
	"Invoke the DrawThemeBackgroundEx() function of the module wrapped by the receiver.
	Helpstring: Draws the theme-specified border and fill for the 'iPartId' and 'iStateId'.

		HRESULT __stdcall DrawThemeBackgroundEx(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pRect,
			[in]DTBGOPTS* pOptions);"

	<stdcall: hresult DrawThemeBackgroundEx handle handle sdword sdword RECTL* DTBGOPTS*>
	^self invalidCall: _failureCode!

drawThemeEdge: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pDestRect: pDestRect uEdge: uEdge uFlags: uFlags pContentRect: pContentRect
	"Invoke the DrawThemeEdge() function of the module wrapped by the receiver.
	Helpstring: Similar to the DrawEdge() API, but uses part colors and is high-DPI aware

		HRESULT __stdcall DrawThemeEdge(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pDestRect,
			[in]UINT uEdge,
			[in]UINT uFlags,
			[out]RECTL* pContentRect);"

	<stdcall: hresult DrawThemeEdge handle handle sdword sdword RECTL* dword dword RECTL*>
	^self invalidCall: _failureCode!

drawThemeIcon: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pRect: pRect himl: himl iImageIndex: iImageIndex
	"Invoke the DrawThemeIcon() function of the module wrapped by the receiver.
	Helpstring: Draws an image within an imagelist based on a (possible) theme-defined effect. 

		HRESULT __stdcall DrawThemeIcon(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pRect,
			[in]HIMAGELIST himl,
			[in]int iImageIndex);"

	<stdcall: hresult DrawThemeIcon handle handle sdword sdword RECTL* handle sdword>
	^self invalidCall: _failureCode!

drawThemeParentBackground: hwnd hdc: hdc prc: prc
	"Invoke the DrawThemeParentBackground() function of the module wrapped by the receiver.
	Helpstring: Used by partially-transparent or alpha-blended child controls to draw the part of their parent that they appear in front of.

		HRESULT __stdcall DrawThemeParentBackground(
			[in]HWND HWND,
			[in]HDC HDC,
			[in, optional]RECTL* prc);"

	<stdcall: hresult DrawThemeParentBackground handle handle RECTL*>
	^self invalidCall: _failureCode!

drawThemeText: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pszText: pszText iCharCount: iCharCount dwTextFlags: dwTextFlags dwTextFlags2: dwTextFlags2 pRect: pRect
	"Invoke the DrawThemeText() function of the module wrapped by the receiver.
	Helpstring: Draws the text using the theme-specified color and font for the 'iPartId' and 'iStateId'

		HRESULT __stdcall DrawThemeText(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]LPWSTR pszText,
			[in]int iCharCount,
			[in]DWORD dwTextFlags,
			[in]DWORD dwTextFlags2,
			[in]RECTL* pRect);"

	<stdcall: hresult DrawThemeText handle handle sdword sdword lpwstr sdword dword dword RECTL*>
	^self invalidCall: _failureCode!

enableThemeDialogTexture: hwnd dwFlags: dwFlags
	"Invoke the EnableThemeDialogTexture() function of the module wrapped by the receiver.
	Helpstring: Enables/disables dialog background theme.

		HRESULT __stdcall EnableThemeDialogTexture(
			[in]HWND HWND,
			[in]DWORD dwFlags);"

	<stdcall: hresult EnableThemeDialogTexture handle dword>
	^self invalidCall: _failureCode!

enableTheming: fEnable
	"Invoke the EnableTheming() function of the module wrapped by the receiver.
	Helpstring: Enables or disables themeing for the current user in the current and future sessions.

		HRESULT __stdcall EnableTheming(
			[in]BOOL fEnable);"

	<stdcall: hresult EnableTheming bool>
	^self invalidCall: _failureCode!

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

	<stdcall: hresult GetCurrentThemeName lpwstr sdword lpwstr sdword lpwstr sdword>
	^self invalidCall: _failureCode!

getThemeAppProperties
	"Invoke the GetThemeAppProperties() function of the module wrapped by the receiver.
	Helpstring: Returns the app property flags that control theming

		DWORD __stdcall GetThemeAppProperties();"

	<stdcall: dword GetThemeAppProperties>
	^self invalidCall: _failureCode!

getThemeBackgroundContentRect: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pBoundingRect: pBoundingRect pContentRect: pContentRect
	"Invoke the GetThemeBackgroundContentRect() function of the module wrapped by the receiver.
	Helpstring: Gets the size of the content for the theme-defined background.  This is usually the area inside the borders or Margins.

		HRESULT __stdcall GetThemeBackgroundContentRect(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pBoundingRect,
			[out]RECTL* pContentRect);"

	<stdcall: hresult GetThemeBackgroundContentRect handle handle sdword sdword RECTL* RECTL*>
	^self invalidCall: _failureCode!

getThemeBackgroundExtent: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pContentRect: pContentRect pExtentRect: pExtentRect
	"Invoke the GetThemeBackgroundExtent() function of the module wrapped by the receiver.
	Helpstring: Calculates the size/location of the theme-specified background based on the 'pContentRect'.

		HRESULT __stdcall GetThemeBackgroundExtent(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pContentRect,
			[out]RECTL* pExtentRect);"

	<stdcall: hresult GetThemeBackgroundExtent handle handle sdword sdword RECTL* RECTL*>
	^self invalidCall: _failureCode!

getThemeBackgroundRegion: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pRect: pRect pRegion: pRegion
	"Invoke the GetThemeBackgroundRegion() function of the module wrapped by the receiver.
	Helpstring: Computes the region for a regular or partially transparent theme-specified background that is bound by the specified 'pRect'.

		HRESULT __stdcall GetThemeBackgroundRegion(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* pRect,
			[out]HRGN* pRegion);"

	<stdcall: hresult GetThemeBackgroundRegion handle handle sdword sdword RECTL* handle*>
	^self invalidCall: _failureCode!

getThemeBool: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pfVal: pfVal
	"Invoke the GetThemeBool() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified BOOL property

		HRESULT __stdcall GetThemeBool(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]BOOL* pfVal);"

	<stdcall: hresult GetThemeBool handle sdword sdword sdword bool*>
	^self invalidCall: _failureCode!

getThemeColor: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pColor: pColor
	"Invoke the GetThemeColor() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified COLOR property

		HRESULT __stdcall GetThemeColor(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]COLORREF* pColor);"

	<stdcall: hresult GetThemeColor handle sdword sdword sdword dword*>
	^self invalidCall: _failureCode!

getThemeDocumentationProperty: pszThemeName pszPropertyName: pszPropertyName pszValueBuff: pszValueBuff cchMaxValChars: cchMaxValChars
	"Invoke the GetThemeDocumentationProperty() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified property name from the [documentation] section of the themes.ini file for the specified theme. 

		HRESULT __stdcall GetThemeDocumentationProperty(
			[in]LPWSTR pszThemeName,
			[in]LPWSTR pszPropertyName,
			[out]LPWSTR pszValueBuff,
			[in]int cchMaxValChars);"

	<stdcall: hresult GetThemeDocumentationProperty lpwstr lpwstr lpwstr sdword>
	^self invalidCall: _failureCode!

getThemeEnumValue: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId piVal: piVal
	"Invoke the GetThemeEnumValue() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified ENUM property

		HRESULT __stdcall GetThemeEnumValue(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]int* piVal);"

	<stdcall: hresult GetThemeEnumValue handle sdword sdword sdword sdword*>
	^self invalidCall: _failureCode!

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

	<stdcall: hresult GetThemeFilename handle sdword sdword sdword lpwstr sdword>
	^self invalidCall: _failureCode!

getThemeFont: htheme hdc: hdc iPartId: iPartId iStateId: iStateId iPropId: iPropId pFont: pFont
	"Invoke the GetThemeFont() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified font property

		HRESULT __stdcall GetThemeFont(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]LOGFONTW* pFont);"

	<stdcall: hresult GetThemeFont handle handle sdword sdword sdword LOGFONTW*>
	^self invalidCall: _failureCode!

getThemeInt: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId piVal: piVal
	"Invoke the GetThemeInt() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified int property

		HRESULT __stdcall GetThemeInt(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]int* piVal);"

	<stdcall: hresult GetThemeInt handle sdword sdword sdword sdword*>
	^self invalidCall: _failureCode!

getThemeMargins: htheme hdc: hdc iPartId: iPartId iStateId: iStateId iPropId: iPropId prc: prc pMargins: pMargins
	"Invoke the GetThemeMargins() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified MARGINS property

		HRESULT __stdcall GetThemeMargins(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[in]RECTL* prc,
			[out]MARGINS* pMargins);"

	<stdcall: hresult GetThemeMargins handle handle sdword sdword sdword RECTL* MARGINS*>
	^self invalidCall: _failureCode!

getThemeMetric: htheme hdc: hdc iPartId: iPartId iStateId: iStateId iPropId: iPropId piVal: piVal
	"Invoke the GetThemeMetric() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified metric/size property

		HRESULT __stdcall GetThemeMetric(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]int* piVal);"

	<stdcall: hresult GetThemeMetric handle handle sdword sdword sdword sdword*>
	^self invalidCall: _failureCode!

getThemePartSize: htheme hdc: hdc iPartId: iPartId iStateId: iStateId prc: prc eSize: eSize psz: psz
	"Invoke the GetThemePartSize() function of the module wrapped by the receiver.
	Helpstring: Returns the specified size of the theme part

		HRESULT __stdcall GetThemePartSize(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]RECTL* prc,
			[in]THEMESIZE eSize,
			[out]SIZEL* psz);"

	<stdcall: hresult GetThemePartSize handle handle sdword sdword RECTL* sdword SIZEL*>
	^self invalidCall: _failureCode!

getThemePosition: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pPoint: pPoint
	"Invoke the GetThemePosition() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified position property

		HRESULT __stdcall GetThemePosition(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]POINTL* pPoint);"

	<stdcall: hresult GetThemePosition handle sdword sdword sdword POINTL*>
	^self invalidCall: _failureCode!

getThemePropertyOrigin: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pOrigin: pOrigin
	"Invoke the GetThemePropertyOrigin() function of the module wrapped by the receiver.
	Helpstring: Searches for the specified theme property and sets 'pOrigin' to indicate where it was found (or not found)

		HRESULT __stdcall GetThemePropertyOrigin(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]PROPERTYORIGIN* pOrigin);"

	<stdcall: hresult GetThemePropertyOrigin handle sdword sdword sdword sdword*>
	^self invalidCall: _failureCode!

getThemeRect: htheme iPartId: iPartId iStateId: iStateId iPropId: iPropId pRect: pRect
	"Invoke the GetThemeRect() function of the module wrapped by the receiver.
	Helpstring: Get the value for the specified RECTL property

		HRESULT __stdcall GetThemeRect(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId,
			[in]int iPropId,
			[out]RECTL* pRect);"

	<stdcall: hresult GetThemeRect handle sdword sdword sdword RECTL*>
	^self invalidCall: _failureCode!

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

	<stdcall: hresult GetThemeString handle sdword sdword sdword lpwstr sdword>
	^self invalidCall: _failureCode!

getThemeSysBool: htheme iBoolId: iBoolId
	"Invoke the GetThemeSysBool() function of the module wrapped by the receiver.
	Helpstring: Get the boolean value of specified System metric

		BOOL __stdcall GetThemeSysBool(
			[in]HTHEME HTHEME,
			[in]int iBoolId);"

	<stdcall: bool GetThemeSysBool handle sdword>
	^self invalidCall: _failureCode!

getThemeSysColor: htheme iColorId: iColorId
	"Invoke the GetThemeSysColor() function of the module wrapped by the receiver.
	Helpstring: Get the value of the specified System color

		COLORREF __stdcall GetThemeSysColor(
			[in]HTHEME HTHEME,
			[in]int iColorId);"

	<stdcall: dword GetThemeSysColor handle sdword>
	^self invalidCall: _failureCode!

getThemeSysColorBrush: htheme iColorId: iColorId
	"Invoke the GetThemeSysColorBrush() function of the module wrapped by the receiver.
	Helpstring: Get the brush for the specified System color

		HBRUSH __stdcall GetThemeSysColorBrush(
			[in]HTHEME HTHEME,
			[in]int iColorId);"

	<stdcall: handle GetThemeSysColorBrush handle sdword>
	^self invalidCall: _failureCode!

getThemeSysFont: htheme iFontId: iFontId plf: plf
	"Invoke the GetThemeSysFont() function of the module wrapped by the receiver.
	Helpstring: Get the LOGFONT for the specified System font.

		HRESULT __stdcall GetThemeSysFont(
			[in]HTHEME HTHEME,
			[in]int iFontId,
			[out]LOGFONTW* plf);"

	<stdcall: hresult GetThemeSysFont handle sdword LOGFONTW*>
	^self invalidCall: _failureCode!

getThemeSysInt: htheme iIntId: iIntId piValue: piValue
	"Invoke the GetThemeSysInt() function of the module wrapped by the receiver.
	Helpstring: Get the value of specified System int.

		HRESULT __stdcall GetThemeSysInt(
			[in]HTHEME HTHEME,
			[in]int iIntId,
			[out]int* piValue);"

	<stdcall: hresult GetThemeSysInt handle sdword sdword*>
	^self invalidCall: _failureCode!

getThemeSysSize: htheme iSizeId: iSizeId
	"Invoke the GetThemeSysSize() function of the module wrapped by the receiver.
	Helpstring: Get the value of the specified System size metric. (scaled for the current logical screen dpi)

		int __stdcall GetThemeSysSize(
			[in]HTHEME HTHEME,
			[in]int iSizeId);"

	<stdcall: sdword GetThemeSysSize handle sdword>
	^self invalidCall: _failureCode!

getThemeSysString: htheme iStringId: iStringId pszStringBuff: pszStringBuff cchMaxStringChars: cchMaxStringChars
	"Invoke the GetThemeSysString() function of the module wrapped by the receiver.
	Helpstring: Get the value of specified System string metric.

		HRESULT __stdcall GetThemeSysString(
			[in]HTHEME HTHEME,
			[in]int iStringId,
			[out]LPWSTR pszStringBuff,
			[in]int cchMaxStringChars);"

	<stdcall: hresult GetThemeSysString handle sdword lpwstr sdword>
	^self invalidCall: _failureCode!

getThemeTextExtent: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pszText: pszText iCharCount: iCharCount dwTextFlags: dwTextFlags pBoundingRect: pBoundingRect pExtentRect: pExtentRect
	"Invoke the GetThemeTextExtent() function of the module wrapped by the receiver.
	Helpstring: Calculates the size/location of the specified text when rendered in the Theme Font

		HRESULT __stdcall GetThemeTextExtent(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]LPWSTR pszText,
			[in]int iCharCount,
			[in]DWORD dwTextFlags,
			[in]RECTL* pBoundingRect,
			[out]RECTL* pExtentRect);"

	<stdcall: hresult GetThemeTextExtent handle handle sdword sdword lpwstr sdword dword RECTL* RECTL*>
	^self invalidCall: _failureCode!

getThemeTextMetrics: htheme hdc: hdc iPartId: iPartId iStateId: iStateId pTM: pTM
	"Invoke the GetThemeTextMetrics() function of the module wrapped by the receiver.
	Helpstring: Returns info about the theme-specified font for the part/state passed in.

		HRESULT __stdcall GetThemeTextMetrics(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[out]TEXTMETRICW* pTM);"

	<stdcall: hresult GetThemeTextMetrics handle handle sdword sdword TEXTMETRICW*>
	^self invalidCall: _failureCode!

getWindowTheme: hwnd
	"Invoke the GetWindowTheme() function of the module wrapped by the receiver.
	Helpstring: If window is themed, returns its most recent HTHEME from OpenThemeData() - otherwise, returns NULL.

		HTHEME __stdcall GetWindowTheme(
			[in]HWND HWND);"

	<stdcall: handle GetWindowTheme handle>
	^self invalidCall: _failureCode!

hitTestThemeBackground: htheme hdc: hdc iPartId: iPartId iStateId: iStateId dwOptions: dwOptions pRect: pRect hrgn: hrgn ptTest: ptTest pwHitTestCode: pwHitTestCode
	"Invoke the HitTestThemeBackground() function of the module wrapped by the receiver.
	Helpstring: Returns a HitTestCode (a subset of the values returned by WM_NCHITTEST) for the point 'ptTest' within the theme-specified background (bound by pRect).

		HRESULT __stdcall HitTestThemeBackground(
			[in]HTHEME HTHEME,
			[in]HDC HDC,
			[in]int iPartId,
			[in]int iStateId,
			[in]DWORD dwOptions,
			[in]RECTL* pRect,
			[in]HRGN HRGN,
			[in]POINTL ptTest,
			[out]WORD* pwHitTestCode);"

	<stdcall: hresult HitTestThemeBackground handle handle sdword sdword dword RECTL* handle POINTL word*>
	^self invalidCall: _failureCode!

isAppThemed
	"Invoke the IsAppThemed() function of the module wrapped by the receiver.
	Helpstring: Returns TRUE if a theme is active and available to the current process

		BOOL __stdcall IsAppThemed();"

	<stdcall: bool IsAppThemed>
	^self invalidCall: _failureCode!

isThemeActive
	"Invoke the IsThemeActive() function of the module wrapped by the receiver.
	Helpstring: Can be used to test if a system theme is active for the current user session.

		BOOL __stdcall IsThemeActive();"

	<stdcall: bool IsThemeActive>
	^self invalidCall: _failureCode!

isThemeBackgroundPartiallyTransparent: htheme iPartId: iPartId iStateId: iStateId
	"Invoke the IsThemeBackgroundPartiallyTransparent() function of the module wrapped by the receiver.
	Helpstring: Returns TRUE if the theme specified background for the part/state has transparent pieces or alpha-blended pieces.

		BOOL __stdcall IsThemeBackgroundPartiallyTransparent(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId);"

	<stdcall: bool IsThemeBackgroundPartiallyTransparent handle sdword sdword>
	^self invalidCall: _failureCode!

isThemeDialogTextureEnabled: hwnd
	"Invoke the IsThemeDialogTextureEnabled() function of the module wrapped by the receiver.
	Helpstring: Reports whether the dialog supports background texturing.

		BOOL __stdcall IsThemeDialogTextureEnabled(
			[in]HWND HWND);"

	<stdcall: bool IsThemeDialogTextureEnabled handle>
	^self invalidCall: _failureCode!

isThemePartDefined: htheme iPartId: iPartId iStateId: iStateId
	"Invoke the IsThemePartDefined() function of the module wrapped by the receiver.
	Helpstring: Returns TRUE if the theme has defined parameters for the specified 'iPartId' and 'iStateId'.

		BOOL __stdcall IsThemePartDefined(
			[in]HTHEME HTHEME,
			[in]int iPartId,
			[in]int iStateId);"

	<stdcall: bool IsThemePartDefined handle sdword sdword>
	^self invalidCall: _failureCode!

onExit
	"Private - Perform any uninitialization required at system shutdown time"

	"By default nothing is required"

	!

onStartup
	"Private - Perform any initialization required at system startup time"

	"By default no action is required"!

openThemeData: hwnd pszClassList: pszClassList
	"Invoke the OpenThemeData() function of the module wrapped by the receiver.
	Helpstring: Open the theme data for the specified HWND and semi-colon separated list of class names.

		HTHEME __stdcall OpenThemeData(
			[in]HWND HWND,
			[in]LPWSTR pszClassList);"

	<stdcall: handle OpenThemeData handle lpwstr>
	^self invalidCall: _failureCode!

setThemeAppProperties: dwFlags
	"Invoke the SetThemeAppProperties() function of the module wrapped by the receiver.
	Helpstring: Sets the flags that control theming within the app

		void __stdcall SetThemeAppProperties(
			[in]DWORD dwFlags);"

	<stdcall: void SetThemeAppProperties dword>
	^self invalidCall: _failureCode!

setWindowTheme: hwnd pszSubAppName: pszSubAppName pszSubIdList: pszSubIdList
	"Invoke the SetWindowTheme() function of the module wrapped by the receiver.
	Helpstring: Redirects an existing Window to use a different section of the current theme information than its class normally asks for

		HRESULT __stdcall SetWindowTheme(
			[in]HWND HWND,
			[in]LPWSTR pszSubAppName,
			[in]LPWSTR pszSubIdList);"

	<stdcall: hresult SetWindowTheme handle lpwstr lpwstr>
	^self invalidCall: _failureCode! !
!OS.ThemeLibrary categoriesFor: #closeThemeData:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #drawThemeBackground:hdc:iPartId:iStateId:pRect:pClipRect:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #drawThemeBackgroundEx:hdc:iPartId:iStateId:pRect:pOptions:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #drawThemeEdge:hdc:iPartId:iStateId:pDestRect:uEdge:uFlags:pContentRect:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #drawThemeIcon:hdc:iPartId:iStateId:pRect:himl:iImageIndex:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #drawThemeParentBackground:hdc:prc:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #drawThemeText:hdc:iPartId:iStateId:pszText:iCharCount:dwTextFlags:dwTextFlags2:pRect:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #enableThemeDialogTexture:dwFlags:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #enableTheming:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getCurrentThemeName:cchMaxNameChars:pszColorBuff:cchMaxColorChars:pszSizeBuff:cchMaxSizeChars:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeAppProperties!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeBackgroundContentRect:hdc:iPartId:iStateId:pBoundingRect:pContentRect:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeBackgroundExtent:hdc:iPartId:iStateId:pContentRect:pExtentRect:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeBackgroundRegion:hdc:iPartId:iStateId:pRect:pRegion:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeBool:iPartId:iStateId:iPropId:pfVal:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeColor:iPartId:iStateId:iPropId:pColor:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeDocumentationProperty:pszPropertyName:pszValueBuff:cchMaxValChars:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeEnumValue:iPartId:iStateId:iPropId:piVal:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeFilename:iPartId:iStateId:iPropId:pszThemeFileName:cchMaxBuffChars:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeFont:hdc:iPartId:iStateId:iPropId:pFont:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeInt:iPartId:iStateId:iPropId:piVal:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeMargins:hdc:iPartId:iStateId:iPropId:prc:pMargins:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeMetric:hdc:iPartId:iStateId:iPropId:piVal:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemePartSize:hdc:iPartId:iStateId:prc:eSize:psz:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemePosition:iPartId:iStateId:iPropId:pPoint:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemePropertyOrigin:iPartId:iStateId:iPropId:pOrigin:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeRect:iPartId:iStateId:iPropId:pRect:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeString:iPartId:iStateId:iPropId:pszBuff:cchMaxBuffChars:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeSysBool:iBoolId:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeSysColor:iColorId:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeSysColorBrush:iColorId:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeSysFont:iFontId:plf:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeSysInt:iIntId:piValue:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeSysSize:iSizeId:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeSysString:iStringId:pszStringBuff:cchMaxStringChars:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeTextExtent:hdc:iPartId:iStateId:pszText:iCharCount:dwTextFlags:pBoundingRect:pExtentRect:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getThemeTextMetrics:hdc:iPartId:iStateId:pTM:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #getWindowTheme:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #hitTestThemeBackground:hdc:iPartId:iStateId:dwOptions:pRect:hrgn:ptTest:pwHitTestCode:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #isAppThemed!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #isThemeActive!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #isThemeBackgroundPartiallyTransparent:iPartId:iStateId:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #isThemeDialogTextureEnabled:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #isThemePartDefined:iPartId:iStateId:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #onExit!private! !
!OS.ThemeLibrary categoriesFor: #onStartup!private! !
!OS.ThemeLibrary categoriesFor: #openThemeData:pszClassList:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #setThemeAppProperties:!**auto generated**!public! !
!OS.ThemeLibrary categoriesFor: #setWindowTheme:pszSubAppName:pszSubIdList:!**auto generated**!public! !

!OS.ThemeLibrary class methodsFor!

fileName
	"Answer the host system file name for the library."

	^'UXTHEME'
!

isAppThemed
	^IsAppThemed!

new
	^(SystemMetrics current hasThemes
		ifTrue: [SystemMetrics current hasEnhancedThemes ifTrue: [VistaThemeLibrary] ifFalse: [self]]
		ifFalse: [MockThemeLibrary]) basicNew!

onStartup2
	"Private - Perform session startup processing for the receiver and its subclasses."

	default := nil.
	IsAppThemed := self default isThemeActive and: [default isAppThemed]! !
!OS.ThemeLibrary class categoriesFor: #fileName!**auto generated**!constants!public! !
!OS.ThemeLibrary class categoriesFor: #isAppThemed!private!testing! !
!OS.ThemeLibrary class categoriesFor: #new!instance creation!public! !
!OS.ThemeLibrary class categoriesFor: #onStartup2!event handling!private! !

