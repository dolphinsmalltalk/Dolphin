"Filed out from Dolphin Smalltalk"!

External.PermanentLibrary subclass: #'OS.GDILibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.GDILibrary guid: (Core.GUID fromString: '{64674044-3a82-101b-8181-00aa003743d3}')!
OS.GDILibrary comment: 'GDILibrary is the <ExternalLibrary> class to represent the Windows system DLL, GDI32.DLL.

The default instance of this class provides access to most of the Win32 graphics API. New functions may be added as required, but the external function naming convention should be followed.

All functions in this library use the stdcall calling convention.'!
!OS.GDILibrary categoriesForClass!External-Data-Structured-Win32! !
!OS.GDILibrary methodsFor!

addFontResource: fontFile
	"Adds the font resource from the specified file to the system font table.
	The font can subsequently be used for text output by any application. 

	int AddFontResource(
		LPCWSTR lpszFilename   // font file name
	);"

	<stdcall: int32 AddFontResourceW lpwstr>
	^self invalidCall: _failureCode!

beginPath: hdc
	"Invoke the BeginPath() function of the module wrapped by the receiver.
	Helpstring: Opens a path bracket in the specified device context

		BOOL __stdcall BeginPath(
			HDC HDC);"

	<stdcall: bool BeginPath handle>
	^self invalidCall: _failureCode!

bitBlt: hdcDest nXDest: nXDest nYDest: nYDest nWidth: nWidth nHeight: nHeight hdcSrc: hdcSrc nXSrc: nXSrc nYSrc: nYSrc dwRop: dwRop
	"Invoke the BitBlt() function of the module wrapped by the receiver.
	Helpstring: Combines source, destination, and pattern of two DCs according to ROP mode

		BOOL __stdcall BitBlt(
			HDC hdcDest,
			int nXDest,
			int nYDest,
			int nWidth,
			int nHeight,
			HDC hdcSrc,
			int nXSrc,
			int nYSrc,
			DWORD dwRop);"

	<stdcall: bool BitBlt handle int32 int32 int32 int32 handle int32 int32 uint32>
	^self invalidCall: _failureCode!

closeFigure: hdc
	"Invoke the CloseFigure() function of the module wrapped by the receiver.
	Helpstring: Closes an open figure in a path

		BOOL __stdcall CloseFigure(
			HDC HDC);"

	<stdcall: bool CloseFigure handle>
	^self invalidCall: _failureCode!

combineRgn: hrgnDst hrgnSrc1: hrgnSrc1 hrgnSrc2: hrgnSrc2 fnCombineMode: fnCombineMode
	"Invoke the CombineRgn() function of the module wrapped by the receiver.
	Helpstring: Combines two regions and stores the result in a third region

		int __stdcall CombineRgn(
			HRGN hrgnDst,
			HRGN hrgnSrc1,
			HRGN hrgnSrc2,
			int fnCombineMode);"

	<stdcall: int32 CombineRgn handle handle handle int32>
	^self invalidCall: _failureCode!

createBitmap: width nHeight: height cPlanes: planes cBitsPerPel: bps lpvBits: bits
	"The CreateBitmap method answers a bitmap of the specified width, height, and
	color format (color planes and bits per pixel).

	HBITMAP CreateBitmap(
		int nWidth			// bitmap width, in pixels 
		int nHeight			// bitmap height, in pixels 
		UINT cPlanes			// number of color planes used by device 
		UINT cBitsPerPel		// number of bits required to identify a color  
		CONST VOID *lpvBits	// pointer to array containing color data 
	);"

	<stdcall: handle CreateBitmap int32 int32 uint32 uint32 lpvoid>
	^self invalidCall: _failureCode!

createBrushIndirect: lplb
	"Invoke the CreateBrushIndirect() function of the module wrapped by the receiver.
	Helpstring: Creates a logical brush that has the specified style, color, and pattern

		HBRUSH __stdcall CreateBrushIndirect(
			LOGBRUSH* lplb);"

	<stdcall: handle CreateBrushIndirect LOGBRUSH*>
	^self invalidCall: _failureCode!

createCompatibleBitmap: hdc nWidth: nWidth nHeight: nHeight
	"Invoke the CreateCompatibleBitmap() function of the module wrapped by the receiver.
	Helpstring: Creates a bitmap of the given size compatible with the given DC

		HBITMAP __stdcall CreateCompatibleBitmap(
			HDC HDC,
			int nWidth,
			int nHeight);"

	<stdcall: handle CreateCompatibleBitmap handle int32 int32>
	^self invalidCall: _failureCode!

createCompatibleDC: hdc
	"Invoke the CreateCompatibleDC() function of the module wrapped by the receiver.
	Helpstring: Creates a memory DC compatible with a given DC

		HDC __stdcall CreateCompatibleDC(
			HDC HDC);"

	<stdcall: handle CreateCompatibleDC handle>
	^self invalidCall: _failureCode!

createDC: lpszDriver lpszDevice: lpszDevice lpszOutput: lpszOutput lpInitData: lpInitData
	"Invoke the CreateDC() function of the module wrapped by the receiver.
	Helpstring: Creates a device context (DC) for a device by using the specified name

		HDC __stdcall CreateDC(
			LPCWSTR lpszDriver,
			LPCWSTR lpszDevice,
			LPCWSTR lpszOutput,
			DEVMODE* lpInitData);"

	<stdcall: handle CreateDCW lpwstr lpwstr lpwstr void*>
	^self invalidCall: _failureCode!

createDIBSection: hdc pbmi: pbmi iUsage: iUsage ppvBits: ppvBits hSection: hSection dwOffset: dwOffset
	"Invoke the CreateDIBSection() function of the module wrapped by the receiver.
	Helpstring: Creates a device-independent bitmap (DIB) that applications can write to directly

		HBITMAP __stdcall CreateDIBSection(
			HDC HDC,
			LPVOID pbmi,
			UINT iUsage,
			void** ppvBits,
			HANDLE hSection,
			DWORD dwOffset);"

	<stdcall: handle CreateDIBSection handle void* uint32 void** handle uint32>
	^self invalidCall: _failureCode!

createEllipticRgnIndirect: lprc
	"Invoke the CreateEllipticRgnIndirect() function of the module wrapped by the receiver.
	Helpstring: Creates an elliptical region

		HRGN __stdcall CreateEllipticRgnIndirect(
			RECTL* lprc);"

	<stdcall: handle CreateEllipticRgnIndirect RECTL*>
	^self invalidCall: _failureCode!

createFontIndirectA: lplf
	"Invoke the CreateFontIndirect() function of the module wrapped by the receiver.
	Helpstring: Creates a logical font that has the characteristics specified in the specified structure

		HFONT __stdcall CreateFontIndirect(
			LOGFONT* lplf);"

	<stdcall: handle CreateFontIndirectA lpvoid>
	^self invalidCall: _failureCode!

createFontIndirectW: lplf
	"Invoke the CreateFontIndirect() function of the module wrapped by the receiver.
	Helpstring: Creates a logical font that has the characteristics specified in the specified structure

		HFONT __stdcall CreateFontIndirect(
			LOGFONTW* lplf);"

	<stdcall: handle CreateFontIndirectW lpvoid>
	^self invalidCall: _failureCode!

createHatchBrush: anInteger color: aCOLORREF
	<stdcall: handle CreateHatchBrush int32 uint32>
	^self invalidCall: _failureCode!

createIC: lpszDriver lpszDevice: lpszDevice lpszOutput: lpszOutput lpdvminit: lpdvminit
	"Invoke the CreateIC() function of the module wrapped by the receiver.
	Helpstring: Creates an information context for the specified device

		HDC __stdcall CreateIC(
			LPCWSTR lpszDriver,
			LPCWSTR lpszDevice,
			LPCWSTR lpszOutput,
			DEVMODE* lpdvminit);"

	<stdcall: handle CreateICW lpwstr lpwstr lpwstr DEVMODE*>
	^self invalidCall: _failureCode!

createPalette: lplgpl
	"Invoke the CreatePalette() function of the module wrapped by the receiver.
	Helpstring: Creates a logical color palette

		HPALETTE __stdcall CreatePalette(
			LOGPALETTE* lplgpl);"

	<stdcall: handle CreatePalette LOGPALETTE*>
	^self invalidCall: _failureCode!

createPen: fnPenStyle nWidth: nWidth crColor: crColor
	"Invoke the CreatePen() function of the module wrapped by the receiver.
	Helpstring: Creates a logical pen that has the specified style, width, and color

		HPEN __stdcall CreatePen(
			int fnPenStyle,
			int nWidth,
			COLORREF crColor);"

	<stdcall: handle CreatePen int32 int32 uint32>
	^self invalidCall: _failureCode!

createPenIndirect: lplgpn
	"Invoke the CreatePenIndirect() function of the module wrapped by the receiver.
	Helpstring: Creates a logical cosmetic pen that has the style, width, and color specified in a structure

		HPEN __stdcall CreatePenIndirect(
			LOGPEN* lplgpn);"

	<stdcall: handle CreatePenIndirect LOGPEN*>
	^self invalidCall: _failureCode!

createRectRgnIndirect: lprc
	"Invoke the CreateRectRgnIndirect() function of the module wrapped by the receiver.
	Helpstring: Creates a rectangular region

		HRGN __stdcall CreateRectRgnIndirect(
			RECTL* lprc);"

	<stdcall: handle CreateRectRgnIndirect RECTL*>
	^self invalidCall: _failureCode!

deleteDC: hdc
	"Invoke the DeleteDC() function of the module wrapped by the receiver.
	Helpstring: Deletes a given DC

		BOOL __stdcall DeleteDC(
			HDC HDC);"

	<stdcall: bool DeleteDC handle>
	^self invalidCall: _failureCode!

deleteObject: hgdiobj
	"Invoke the DeleteObject() function of the module wrapped by the receiver.
	Helpstring: Deletes a given GDI object

		BOOL __stdcall DeleteObject(
			HGDIOBJ HGDIOBJ);"

	<stdcall: bool DeleteObject handle>
	^self invalidCall: _failureCode!

ellipse: hdc nLeftRect: l nTopRect: t nRightRect: r nBottomRect: b
	"Draw an ellipse. The center of the ellipse is the center of the specified 
	bounding rectangle. The ellipse is outlined by using the current pen 
	and is filled by using the current brush. 
		BOOL Ellipse(
			HDC hdc,			// handle to device context 
			int nLeftRect,		// x-coord. of bounding rectangle's upper-left corner 
			int nTopRect,		// y-coord. of bounding rectangle's upper-left corner  
			int nRightRect,	// x-coord. of bounding rectangle's lower-right corner  
			int nBottomRect 	// y-coord. bounding rectangle's f lower-right corner  
		);"

	<stdcall: bool Ellipse handle int32 int32 int32 int32>
	^self invalidCall: _failureCode!

endDoc: hdc
	"Invoke the EndDoc() function of the module wrapped by the receiver.
	Helpstring: Ends a print job

		int __stdcall EndDoc(
			HDC HDC);"

	<stdcall: int32 EndDoc handle>
	^self invalidCall: _failureCode!

endPage: hdc
	"Invoke the EndPage() function of the module wrapped by the receiver.
	Helpstring: Notifies the device that the application has finished writing to a page. This function is typically used to direct the device driver to advance to a new page.

		int __stdcall EndPage(
			HDC HDC);"

	<stdcall: int32 EndPage handle>
	^self invalidCall: _failureCode!

endPath: hdc
	"Invoke the EndPath() function of the module wrapped by the receiver.
	Helpstring: Closes a path bracket and selects the path into the specified device context

		BOOL __stdcall EndPath(
			HDC HDC);"

	<stdcall: bool EndPath handle>
	^self invalidCall: _failureCode!

enumFontFamilies: aHandle lpszFamily: aString lpEnumFontFamProc: anExternalCallbackThunk lParam: anInteger
	"Enumerate the fonts in a specified family available on a specified
	device through the specified callback.
		int EnumFontFamilies(
			HDC hdc,	// handle to device control 
			LPCWSTR lpszFamily,	// pointer to family-name string 
			FONTENUMPROC lpEnumFontFamProc,	// pointer to callback function 
			LPARAM lParam 	// address of application-supplied data  
		);"

	<stdcall: int32 EnumFontFamiliesW handle lpwstr lpvoid uintptr>
	^self invalidCall: _failureCode!

excludeClipRect: hdc nLeftRect: nLeftRect nTopRect: nTopRect nRightRect: nRightRect nBottomRect: nBottomRect
	"Invoke the ExcludeClipRect() function of the module wrapped by the receiver.
	Helpstring: Creates a new clipping region that consists of the existing clipping region minus the specified rectangle

		int __stdcall ExcludeClipRect(
			HDC HDC,
			int nLeftRect,
			int nTopRect,
			int nRightRect,
			int nBottomRect);"

	<stdcall: int32 ExcludeClipRect handle int32 int32 int32 int32>
	^self invalidCall: _failureCode!

extTextOut: hdc x: x y: y fuOptions: fuOptions lprc: lprc lpString: lpString cbCount: cbCount lpDx: lpDx
	"Invoke the ExtTextOut() function of the module wrapped by the receiver.
	Helpstring: Draws a character string, optionally using a rectangle to specify clipping, opaquing, or both

		BOOL __stdcall ExtTextOut(
			HDC HDC,
			int x,
			int y,
			UINT fuOptions,
			RECTL* lprc,
			LPCWSTR lpString,
			UINT cbCount,
			int* lpDx);"

	<stdcall: bool ExtTextOutW handle int32 int32 uint32 RECTL* lpwstr uint32 int32*>
	^self invalidCall: _failureCode!

fillRgn: hdc hRgn: hRgn hBr: hBr
	"The FillRgn function fills a region by using the specified brush. 
		BOOL FillRgn(
			HDC  hdc,	// handle of device context 
			HRGN  hrgn,	// handle of region to be filled 
			HBRUSH  hbr 	// handle of brush used to fill the region  
			);"

	<stdcall: bool FillRgn handle handle handle>
	^self invalidCall: _failureCode!

frameRgn: hdc hRgn: hRgn hBr: hBr nWidth: nWidth nHeight: nHeight
	"Draws a border around the specified region by using the specified brush. 
		BOOL FrameRgn(
			HDC  hdc,	// handle of device context 
			HRGN  hrgn,	// handle of region to be framed 
			HBRUSH  hbr,	// handle of brush used to draw border  
			int  nWidth,	// width of region frame 
			int  nHeight 	// height of region frame 
			);"

	<stdcall: bool FrameRgn handle handle handle uint32 uint32>
	^self invalidCall: _failureCode!

gdiAlphaBlend: hdcDest xoriginDest: nXOriginDest yoriginDest: nYOriginDest wDest: nWidthDest hDest: nHeightDest hdcSrc: hdcSrc xoriginSrc: nXOriginSrc yoriginSrc: nYOriginSrc wSrc: nWidthSrc hSrc: nHeightSrc ftn: blend
	"Invoke the GdiAlphaBlend() function of the module wrapped by the receiver.
	Helpstring: Displays bitmaps that have transparent or semitransparent pixels

		BOOL __stdcall GdiAlphaBlend(
			[in]HDC hdcDest,
			[in]int xoriginDest,
			[in]int yoriginDest,
			[in]int wDest,
			[in]int hDest,
			[in]HDC hdcSrc,
			[in]int xoriginSrc,
			[in]int yoriginSrc,
			[in]int wSrc,
			[in]int hSrc,
			[in]BLENDFUNCTION ftn);"

	<stdcall: bool GdiAlphaBlend handle int32 int32 int32 int32 handle int32 int32 int32 int32 BLENDFUNCTION>
	^self invalidCall: _failureCode!

gdiGradientFill: hdc pVertex: pVertex nVertex: dwNumVertex pMesh: pMesh nCount: dwNumMesh ulMode: dwMode
	"Invoke the GdiGradientFill() function of the module wrapped by the receiver.
	Helpstring: Gradient fills rectangle and triangle structures

		BOOL __stdcall GdiGradientFill(
			[in]HDC HDC,
			[in]TRIVERTEX* pVertex,
			[in]ULONG nVertex,
			[in]void* pMesh,
			[in]ULONG nCount,
			[in]ULONG ulMode);"

	<stdcall: bool GdiGradientFill handle TRIVERTEX* uint32 void* uint32 uint32>
	^self invalidCall: _failureCode!

gdiTransparentBlt: hdcDest xoriginDest: nXOriginDest yoriginDest: nYOriginDest wDest: nWidthDest hDest: nHeightDest hdcSrc: hdcSrc xoriginSrc: nXOriginSrc yoriginSrc: nYOriginSrc wSrc: nWidthSrc hSrc: nHeightSrc crTransparent: crTransparent
	"Invoke the GdiTransparentBlt() function of the module wrapped by the receiver.
	Helpstring: Performs a bit-block transfer of the color data corresponding to a rectangle of pixels from the specified source device context into a destination device context.

		BOOL __stdcall GdiTransparentBlt(
			[in]HDC hdcDest,
			[in]int xoriginDest,
			[in]int yoriginDest,
			[in]int wDest,
			[in]int hDest,
			[in]HDC hdcSrc,
			[in]int xoriginSrc,
			[in]int yoriginSrc,
			[in]int wSrc,
			[in]int hSrc,
			[in]UINT crTransparent);"

	<stdcall: bool GdiTransparentBlt handle int32 int32 int32 int32 handle int32 int32 int32 int32 uint32>
	^self invalidCall: _failureCode!

getBkColor: hdc
	"Invoke the GetBkColor() function of the module wrapped by the receiver.
	Helpstring: Get the background color of a DC

		COLORREF __stdcall GetBkColor(
			HDC HDC);"

	<stdcall: uint32 GetBkColor handle>
	^self invalidCall: _failureCode!

getBkMode: hdc
	"Invoke the GetBkMode() function of the module wrapped by the receiver.
	Helpstring: Get the background mode of a DC

		int __stdcall GetBkMode(
			HDC HDC);"

	<stdcall: int32 GetBkMode handle>
	^self invalidCall: _failureCode!

getClipBox: hdc lprc: lprc
	"Invoke the GetClipBox() function of the module wrapped by the receiver.
	Helpstring: Retrieves the dimensions of the tightest bounding rectangle that can be drawn around the current visible area on the device

		int __stdcall GetClipBox(
			HDC HDC,
			RECTL* lprc);"

	<stdcall: int32 GetClipBox handle RECTL*>
	^self invalidCall: _failureCode!

getCurrentObject: hdc uObjectType: uObjectType
	"Invoke the GetCurrentObject() function of the module wrapped by the receiver.
	Helpstring: Returns the currently selected object of the specified type

		HGDIOBJ __stdcall GetCurrentObject(
			HDC HDC,
			UINT uObjectType);"

	<stdcall: handle GetCurrentObject handle uint32>
	^self invalidCall: _failureCode!

getDCBrushColor: hdc
	<stdcall: uint32 GetDCBrushColor handle>
	^self invalidCall: _failureCode!

getDCPenColor: hdc
	<stdcall: uint32 GetDCPenColor handle>
	^self invalidCall: _failureCode!

getDeviceCaps: hdc nIndex: nIndex
	"Invoke the GetDeviceCaps() function of the module wrapped by the receiver.
	Helpstring: Gets the capabilities of given DC

		int __stdcall GetDeviceCaps(
			HDC HDC,
			int nIndex);"

	<stdcall: int32 GetDeviceCaps handle int32>
	^self invalidCall: _failureCode!

getDIBColorTable: hdc uStartIndex: uStartIndex cEntries: cEntries pColors: pColors
	"Invoke the GetDIBColorTable() function of the module wrapped by the receiver.
	Helpstring: Retrieves RGB (red, green, blue) color values from a range of entries in the color table of the DIB section bitmap that is currently selected into a specified device context

		UINT __stdcall GetDIBColorTable(
			HDC HDC,
			UINT uStartIndex,
			UINT cEntries,
			RGBQUAD* pColors);"

	<stdcall: uint32 GetDIBColorTable handle uint32 uint32 RGBQUAD*>
	^self invalidCall: _failureCode!

getDIBits: hdc hbm: hbm uStartScan: uStartScan cScanLines: cScanLines lpvBits: lpvBits lpbi: lpbi uUsage: uUsage
	"Invoke the GetDIBits() function of the module wrapped by the receiver.
	Helpstring: Retrieves the bits of the specified bitmap and copies them into a buffer using the specified format

		int __stdcall GetDIBits(
			HDC HDC,
			HBITMAP hbm,
			UINT uStartScan,
			UINT cScanLines,
			LPVOID lpvBits,
			BITMAPINFO* lpbi,
			UINT uUsage);"

	<stdcall: int32 GetDIBits handle handle uint32 uint32 void* BITMAPINFO* uint32>
	^self invalidCall: _failureCode!

getMapMode: hdc
	"Invoke the GetMapMode() function of the module wrapped by the receiver.
	Helpstring: Retrieves the current mapping mode

		int __stdcall GetMapMode(
			HDC HDC);"

	<stdcall: int32 GetMapMode handle>
	^self invalidCall: _failureCode!

getNearestPaletteIndex: hpal crColor: crColor
	"Invoke the GetNearestPaletteIndex() function of the module wrapped by the receiver.
	Helpstring: Retrieves the index for the entry in the specified logical palette most closely matching a specified color value

		UINT __stdcall GetNearestPaletteIndex(
			HPALETTE hpal,
			COLORREF crColor);"

	<stdcall: uint32 GetNearestPaletteIndex handle uint32>
	^self invalidCall: _failureCode!

getObject: objectHandle cbBuffer: count lpvObject: buffer
	"Obtains information about a specified graphics object. Depending on 
	the graphics object, the function places a filled-in BITMAP, DIBSECTION, 
	EXTLOGPEN, LOGBRUSH, LOGFONT, or LOGPEN structure, or a count of table 
	entries (for a logical palette), into a specified buffer. 
		int GetObject(
  			HGDIOBJ hgdiobj,	// handle to graphics object of interest
			int cbBuffer,	// size of buffer for object information 
			LPVOID lpvObject 	// pointer to buffer for object information  
		);"

	<stdcall: int32 GetObjectA handle int32 lpvoid>
	^self invalidCall: _failureCode!

getObjectW: objectHandle cbBuffer: count lpvObject: buffer
	"Obtains information about a specified graphics object. Depending on 
	the graphics object, the function places a filled-in BITMAP, DIBSECTION, 
	EXTLOGPEN, LOGBRUSH, LOGFONT, or LOGPEN structure, or a count of table 
	entries (for a logical palette), into a specified buffer. 
		int GetObject(
  			HGDIOBJ hgdiobj,	// handle to graphics object of interest
			int cbBuffer,	// size of buffer for object information 
			LPVOID lpvObject 	// pointer to buffer for object information  
		);"

	<stdcall: int32 GetObjectW handle int32 lpvoid>
	^self invalidCall: _failureCode!

getOutlineTextMetrics: anExternalHandle cbData: anInteger lpotm: anOUTLINETEXTMETRIC
	<stdcall: uint32 GetOutlineTextMetricsW handle uint32 OUTLINETEXTMETRICW*>
	^self invalidCall: _failureCode!

getPaletteEntries: hpal iStartIndex: iStartIndex nEntries: nEntries lppe: lppe
	"Invoke the GetPaletteEntries() function of the module wrapped by the receiver.
	Helpstring: Retrieves specified range of palette entries from the given logical palette

		UINT __stdcall GetPaletteEntries(
			HPALETTE hpal,
			UINT iStartIndex,
			UINT nEntries,
			PALETTEENTRY* lppe);"

	<stdcall: uint32 GetPaletteEntries handle uint32 uint32 lpvoid>
	^self invalidCall: _failureCode!

getPixel: aHandle xPos: xPos yPos: yPos
	"Answer the value of the pixel at the specified coordinates in the specified DC.

		COLORREF GetPixel(
			HDC hdc,	// handle of device context  
			int XPos,	// x-coordinate of pixel 
			int nYPos 	// y-coordinate of pixel 
		);"

	<stdcall: uint32 GetPixel handle int32 int32>
	^self invalidCall: _failureCode!

getROP2: hdc
	"Invoke the GetROP2() function of the module wrapped by the receiver.
	Helpstring: Retrieves the foreground mix mode (which specifies how the pen or interior color and the color already on the screen are combined to yield a new color) of the specified device context

		int __stdcall GetROP2(
			HDC HDC);"

	<stdcall: int32 GetROP2 handle>
	^self invalidCall: _failureCode!

getStockObject: fnObject
	"Invoke the GetStockObject() function of the module wrapped by the receiver.
	Helpstring: Returns the handle of stock pen, brush or font specified by fnObject constant

		HGDIOBJ __stdcall GetStockObject(
			int fnObject);"

	<stdcall: handle GetStockObject int32>
	^self invalidCall: _failureCode!

getTextColor: hdc
	"The GetTextColor function retrieves the current text color for the specified device context.

	COLORREF GetTextColor(
		HDC hdc			// handle of device context  
	);"

	<stdcall: uint32 GetTextColor handle>
	^self invalidCall: _failureCode!

getTextExtentPoint32: hdc lpString: lpString c: cbString lpSize: lpSize
	"Invoke the GetTextExtentPoint32() function of the module wrapped by the receiver.
	Helpstring: Computes the width and height of the specified string of text

		BOOL __stdcall GetTextExtentPoint32(
			HDC HDC,
			LPWSTR lpString,
			int c,
			SIZEL* lpSize);"

	<stdcall: bool GetTextExtentPoint32W handle lpwstr int32 lpvoid>
	^self invalidCall: _failureCode!

getTextMetrics: hdc lptm: lptm
	"Invoke the GetTextMetrics() GDI call to populate a TEXTMETRICW structure, lptm, with
	metrics for the font currently selected into the device context with handle, hdc."

	<stdcall: bool GetTextMetricsW handle TEXTMETRICW*>
	^self invalidCall: _failureCode!

getViewportExtEx: hdc lpSize: lpSize
	"The GetViewportExtEx function retrieves the x-extent and y-extent of the
	current viewport for the specified device context. 

		BOOL GetViewportExtEx(
			HDC  hdc,	// handle of device context 
			LPPOINT  lpPoint 	// points to retrieved extent origin );"

	<stdcall: bool GetViewportExtEx handle POINTL*>
	^self invalidCall: _failureCode!

getViewportOrgEx: hdc lppt: lppt
	"The GetViewportOrgEx function retrieves the origin of the
	current viewport for the specified device context. 

		BOOL GetViewportOrgEx(
			HDC  hdc,	// handle of device context 
			LPPOINT  lpPoint 	// points to retrieved extent origin );"

	<stdcall: bool GetViewportOrgEx handle POINTL*>
	^self invalidCall: _failureCode!

getWindowExtEx: hdc lpSize: lpSize
	"Invoke the GetWindowExtEx() function of the module wrapped by the receiver.
	Helpstring: Retrieves x-extents and y-extents of the window for the specified device context

		BOOL __stdcall GetWindowExtEx(
			HDC HDC,
			SIZEL* lpSize);"

	<stdcall: bool GetWindowExtEx handle SIZEL*>
	^self invalidCall: _failureCode!

getWindowOrgEx: hdc lppt: lppt
	"The GetWindowOrgExfunction retrieves the origin of the
	current window for the specified device context. 

		BOOL GetWindowOrgEx(
			HDC  hdc,	// handle of device context 
			LPPOINT  lpPoint 	// points to retrieved extent origin );"

	<stdcall: bool GetWindowOrgEx handle POINTL*>
	^self invalidCall: _failureCode!

intersectClipRect: hdc nLeftRect: left nTopRect: top nRightRect: right nBottomRect: bottom
	"The IntersectClipRect function creates a new clipping region from the intersection
	of the current clipping region and the specified rectangle. 

	int IntersectClipRect(
		HDC hdc			// handle of device context 
		int nLeftRect		// x-coordinate of upper-left corner of rectangle 
		int nTopRect		// y-coordinate of upper-left corner of rectangle 
		int nRightRect	// x-coordinate of lower-right corner of rectangle  
		int nBottomRect	// y-coordinate of lower-right corner of rectangle  
	);"

	<stdcall: int32 IntersectClipRect handle int32 int32 int32 int32>
	^self invalidCall: _failureCode!

invertRgn: hdc hRgn: hRgn
	"The InvertRgn function inverts the colors in the specified region. 

	BOOL InvertRgn(
		HDC hdc,    // handle to device context
		HRGN hrgn   // handle to region to be inverted
		);
	"

	<stdcall: bool InvertRgn handle handle>
	^self invalidCall: _failureCode!

lineTo: hdc nXEnd: newX nYEnd: newY
	"The LineTo function draws a line from the current position up to, but not including, the specified point. 
		BOOL LineTo(
  			HDC hdc,	// device context handle 
			int nXEnd,	// x-coordinate of line's ending point  
			int nYEnd 	// y-coordinate of line's ending point  
		);"

	<stdcall: bool LineTo handle int32 int32>
	^self invalidCall: _failureCode!

moveToEx: hdc x: x y: y lpPoint: lpPoint
	"Invoke the MoveToEx() function of the module wrapped by the receiver.
	Helpstring: Moves current position to (x,y) without displaying; return last position in POINTL * lpPoint

		BOOL __stdcall MoveToEx(
			HDC HDC,
			int x,
			int y,
			[defaultvalue(0)]POINTL* lpPoint);"

	<stdcall: bool MoveToEx handle int32 int32 POINTL*>
	^self invalidCall: _failureCode!

offsetWindowOrgEx: hdc nXOrg: x nYOrg: y lppt: aPOINT
	<stdcall: bool OffsetWindowOrgEx handle int32 int32 POINTL*>
	^self invalidCall: _failureCode!

paintRgn: hdc hRgn: hRgn
	"Paints the specified region by using the brush currently selected into the device context. 
	BOOL PaintRgn(
		HDC  hdc,	// handle of device context 
		HRGN  hrgn 	// handle of region to be painted  
		);"

	<stdcall: bool PaintRgn handle handle>
	^self invalidCall: _failureCode!

patBlt: hdc nXLeft: x nYLeft: y nWidth: width nHeight: height dwRop: rop
	"
	BOOL PatBlt(
		HDC hdc		// handle to device context 
		int nXLeft	// x-coord. of upper-left corner of rect. to be filled 
		int nYLeft	// y-coord. of upper-left corner of rect. to be filled 
		int nWidth	// width of rectangle to be filled 
		int nHeight	// height of rectangle to be filled 
		DWORD dwRop	// raster operation code 
	);"

	<stdcall: bool PatBlt handle int32 int32 int32 int32 uint32>
	^self invalidCall: _failureCode!

plgBlt: hdcDest lpPoint: lpPoint hdcSrc: hdcSrc nXSrc: nXSrc nYSrc: nYSrc nWidth: nWidth nHeight: nHeight hbmMask: hbmMask sMask: sMask yMask: yMask
	"Invoke the PlgBlt() function of the module wrapped by the receiver.
	Helpstring: Combines source, destination, and pattern of two DCs according to ROP mode (NT only)

		BOOL __stdcall PlgBlt(
			HDC hdcDest,
			WORD* lpPoint,
			HDC hdcSrc,
			int nXSrc,
			int nYSrc,
			int nWidth,
			int nHeight,
			HBITMAP hbmMask,
			int sMask,
			int yMask);"

	<stdcall: bool PlgBlt handle uint16* handle int32 int32 int32 int32 handle int32 int32>
	^self invalidCall: _failureCode!

polygon: hdc lpPoints: points nCount: count
	"Draw a Polygon consisting of 2 or more straight sides, and then fill in the shape.

	BOOL Polygon(
		HDC hdc				// handle to device context 
		CONST POINTL *lpPoints	// pointer to polygon's vertices 
		int nCount			// count of polygon's vertices 
	);"

	<stdcall: bool Polygon handle POINTL* int32>
	^self invalidCall: _failureCode!

ptInRegion: hdc x: x y: y
	"Determines whether the specified point is inside the specified region. 
		BOOL PtInRegion(
			HRGN  hrgn,	// handle of region 
			int  X,	// x-coordinate of point  
			int  Y 	// y-coordinate of point  
			);"

	<stdcall: bool PtInRegion handle int32 int32>
	^self invalidCall: _failureCode!

realizePalette: hdc
	"Invoke the RealizePalette() function of the module wrapped by the receiver.
	Helpstring: Maps palette entries from the current logical palette to the system palette

		UINT __stdcall RealizePalette(
			HDC HDC);"

	<stdcall: uint32 RealizePalette handle>
	^self invalidCall: _failureCode!

rectangle: hdc nLeftRect: l nTopRect: t nRightRect: r nBottomRect: b
	"Draw a rectangle. The rectangle is outlined by using the current 
	pen and filled by using the current brush. 
		BOOL Rectangle(
			HDC hdc,			// handle of device context 
			int nLeftRect,		// x-coord. of bounding rectangle's upper-left corner 
			int nTopRect,		// y-coord. of bounding rectangle's upper-left corner 
			int nRightRect,	// x-coord. of bounding rectangle's lower-right corner  
			int nBottomRect 	// y-coord. of bounding rectangle's lower-right corner  
		);"

	<stdcall: bool Rectangle handle int32 int32 int32 int32>
	^self invalidCall: _failureCode!

rectVisible: hdc lprc: aRECT
	"The RectVisible function determines whether any part of the specified rectangle
	lies within the clipping region of a device context. 

	BOOL RectVisible(
		HDC hdc			// handle of the device context 
		CONST RECT *lprc 	// address of rectangle structure  
	);"

	<stdcall: bool RectVisible handle RECTL*>
	^self invalidCall: _failureCode!

removeFontResource: fontFile
	"The RemoveFontResource function removes the fonts in the specified file from the system font table. 
	If the font was added using the AddFontResourceEx function, you must use the RemoveFontResourceEx function. 

	BOOL RemoveFontResource(
		LPCWSTR lpFileName   // name of font file
		);
	"

	<stdcall: bool RemoveFontResourceW lpwstr>
	^self invalidCall: _failureCode!

restoreDC: hDC nSavedDC: nSavedDC
	"Restores a device context (DC) to the specified state.
	The DC is restored by popping state information off a stack 
	created by earlier calls to the SaveDC function.
		BOOL RestoreDC(
  			HDC hdc,	// handle of device context 
			int nSavedDC 	// specifies state to be restored  
		);"

	<stdcall: bool RestoreDC handle int32>
	^self invalidCall: _failureCode!

roundRect: hdc nLeftRect: l nTopRect: t nRightRect: r nBottomRect: b nWidth: rx nHeight: ry
	"Draw a rectangle with rounded corners. The rectangle is outlined by using 
	the current pen and filled by using the current brush. 
		BOOL RoundRect(
			HDC hdc,			// handle of device context 
			int nLeftRect,		// x-coord. of bounding rectangle's upper-left corner 
			int nTopRect,		// y-coord. of bounding rectangle's upper-left corner 
			int nRightRect,	// x-coord. of bounding rectangle's lower-right corner 
			int nBottomRect,	// y-coord. of bounding rectangle's lower-right corner 
			int nWidth,		// width of ellipse used to draw rounded corners  
			int nHeight 		// height of ellipse used to draw rounded corners  
		);"

	<stdcall: bool RoundRect handle int32 int32 int32 int32 int32 int32>
	^self invalidCall: _failureCode!

saveDC: hDC
	"The SaveDC function saves the current state of the specified device context 
	(DC) by copying data describing selected objects and graphic modes (such as the bitmap, 
	brush, palette, font, pen, region, drawing mode, and mapping mode) to a context stack.
		int SaveDC(
  			HDC hdc 	// handle of device context 
		);"

	<stdcall: int32 SaveDC handle>
	^self invalidCall: _failureCode!

selectClipPath: hdc iMode: iMode
	"Invoke the SelectClipPath() function of the module wrapped by the receiver.
	Helpstring: Selects the current path as a clipping region, combining the new region with any existing clipping region by using the specified mode

		BOOL __stdcall SelectClipPath(
			HDC HDC,
			int iMode);"

	<stdcall: bool SelectClipPath handle int32>
	^self invalidCall: _failureCode!

selectClipRgn: hdc hrgn: hRegion
	"The SelectClipRgn function selects a region as the current clipping region
	for the specified device context. 

	int SelectClipRgn(
		HDC hdc		// handle of device context 
		HRGN hrgn		// handle of region to be selected  
	);"

	<stdcall: int32 SelectClipRgn handle handle>
	^self invalidCall: _failureCode!

selectObject: hdc hgdiobj: hgdiobj
	"Invoke the SelectObject() function of the module wrapped by the receiver.
	Helpstring: Selects a given GDI object into a DC, returning the previous object

		HGDIOBJ __stdcall SelectObject(
			HDC HDC,
			HGDIOBJ HGDIOBJ);"

	<stdcall: handle SelectObject handle handle>
	^self invalidCall: _failureCode!

selectPalette: hdc hPal: hPal bForceBackground: forceBackground
	"Selects the logical palette hPal into a device context, hdc.
	The forceBackground parameter specifies whether the logical palette 
	is forced to be a background palette. If true, realizing the palette
	causes the logical palette to be mapped to the colors already in the
	physical palette in the best possible way. If false, realizing the
	palette causes it to be copied into the device palette when the 
	application is in the foreground. 

	Answers the previous palette handle or nil if the operation fails.

	HPALETTE SelectPalette( 
		HDC hdc, 
		HPALETTE hpal, 
		BOOL bForceBackground);"

	<stdcall: handle SelectPalette handle handle bool>
	^self invalidCall: _failureCode!

setBkColor: hdc crColor: color
	"The SetBkColor function sets the current background color to the specified 
	color value, or to the nearest physical color if the device cannot represent 
	the specified color value. 

	COLORREF SetBkColor(
		HDC  hdc,	// handle of device context  
		COLORREF  crColor // background color value
		);"

	<stdcall: uint32 SetBkColor handle uint32>
	^self invalidCall: _failureCode!

setBkMode: hdc iBkMode: mode
	"The SetBkMode function sets the background mix mode of the specified device context. 
	The background mix mode is used with text, hatched brushes, and pen styles that are 
	not solid lines. 
		int SetBkMode(
  			HDC hdc,		// handle of device context
			int iBkMode 	// flag specifying background mode
		);"

	<stdcall: int32 SetBkMode handle int32>
	^self invalidCall: _failureCode!

setBrushOrgEx: hdc nXOrg: x nYOrg: y lppt: aPOINT
	"Sets the brush origin that GDI assigns to the next brush an application selects into the specified device context. 
		BOOL SetBrushOrgEx(
			HDC  hdc,	// handle of device context 
			int  nXOrg,	// x-coordinate of new origin 
			int  nYOrg,	// y-coordinate of new origin 
			LPPOINT  lppt 	// points to previous brush origin );"

	<stdcall: bool SetBrushOrgEx handle int32 int32 POINTL*>
	^self invalidCall: _failureCode!

setDIBColorTable: hdc uStartIndex: uStartIndex cEntries: cEntries pColors: pColors
	"Invoke the SetDIBColorTable() function of the module wrapped by the receiver.
	Helpstring: Sets RGB (red, green, blue) color values in a range of entries in the color table of the device-independent bitmap (DIB) that is currently selected into a specified device context

		UINT __stdcall SetDIBColorTable(
			HDC HDC,
			UINT uStartIndex,
			UINT cEntries,
			RGBQUAD* pColors);"

	<stdcall: uint32 SetDIBColorTable handle uint32 uint32 RGBQUAD*>
	^self invalidCall: _failureCode!

setDIBits: hdc hbmp: hbmp uStartScan: uStartScan cScanLines: cScanLines lpvBits: lpvBits lpbmi: lpbmi fuColorUse: fuColorUse
	"Invoke the SetDIBits() function of the module wrapped by the receiver.
	Helpstring: Sets the pixels in a bitmap using the color data found in the specified device-independent bitmap (DIB)

		int __stdcall SetDIBits(
			HDC HDC,
			HBITMAP hbmp,
			UINT uStartScan,
			UINT cScanLines,
			LPVOID lpvBits,
			LPVOID lpbmi,
			UINT fuColorUse);"

	<stdcall: int32 SetDIBits handle handle uint32 uint32 void* void* uint32>
	^self invalidCall: _failureCode!

setMapMode: hdc fnMapMode: fnMapMode
	"Invoke the SetMapMode() function of the module wrapped by the receiver.
	Helpstring: Sets the mapping mode of the specified device context, thus defining the unit of measure used to transform page-space units into device-space units and defining the orientation of the x and y axes

		int __stdcall SetMapMode(
			HDC HDC,
			int fnMapMode);"

	<stdcall: int32 SetMapMode handle int32>
	^self invalidCall: _failureCode!

setPixelV: hdc x: x y: y crColor: pixelColor
	"The SetPixelV function sets the pixel at the specified coordinates to the
	closest approximation of the specified color. The point must be in the
	clipping region and the visible part of the device surface. 

	BOOL SetPixelV(
		HDC hdc			// handle of device context  
		int X			// x-coordinate of pixel 
		int Y			// y-coordinate of pixel 
		COLORREF crColor	// new pixel color 
	);"

	<stdcall: bool SetPixelV handle int32 int32 uint32>
	^self invalidCall: _failureCode!

setROP2: hdc fnDrawMode: fnDrawMode
	"Invoke the SetROP2() function of the module wrapped by the receiver.
	Helpstring: Sets the current foreground mix mode

		int __stdcall SetROP2(
			HDC HDC,
			int fnDrawMode);"

	<stdcall: int32 SetROP2 handle int32>
	^self invalidCall: _failureCode!

setTextAlign: hdc fMode: mode
	"
	UINT SetTextAlign(
		HDC hdc,	// handle of device context 
		UINT fMode 	// text-alignment flag 
	);"

	<stdcall: uint32 SetTextAlign handle uint32>
	^self invalidCall: _failureCode!

setTextColor: hdc crColor: colour
	"The SetTextColor function sets the text color for the specified
	device context to the specified color. 

	COLORREF SetTextColor(
		HDC hdc			// handle of device context  
		COLORREF crColor	// text color 
	);"

	<stdcall: uint32 SetTextColor handle uint32>
	^self invalidCall: _failureCode!

setViewportExtEx: hdc nXExtent: nXExtent nYExtent: nYExtent lpSize: lpSize
	"The SetViewportExtEx function sets the horizontal and vertical extents
	of the viewport for a device context by using the specified values. 

		BOOL SetViewportExtEx(
			HDC  hdc,	// handle of device context 
			int  X,	// x-coordinate of new origin 
			int  Y,	// y-coordinate of new origin 
			LPPOINT  lpPoint 	// points to previous origin );"

	<stdcall: bool SetViewportExtEx handle int32 int32 POINTL*>
	^self invalidCall: _failureCode!

setViewportOrgEx: hdc nXOrg: x nYOrg: y lppt: aPOINT
	"The SetViewportOrgEx function specifies which device point maps to the window origin (0,0). 

		BOOL SetViewportOrgEx(
			HDC  hdc,	// handle of device context 
			int  X,	// x-coordinate of new origin 
			int  Y,	// y-coordinate of new origin 
			LPPOINT  lpPoint 	// points to previous origin );"

	<stdcall: bool SetViewportOrgEx handle int32 int32 POINTL*>
	^self invalidCall: _failureCode!

setWindowExtEx: hdc nXExtent: nXExtent nYExtent: nYExtent lpSize: lpSize
	"Invoke the SetWindowExtEx() function of the module wrapped by the receiver.
	Helpstring: Sets X and Y of the window for a device context using specified values

		BOOL __stdcall SetWindowExtEx(
			HDC HDC,
			int nXExtent,
			int nYExtent,
			SIZEL* lpSize);"

	<stdcall: bool SetWindowExtEx handle int32 int32 SIZEL*>
	^self invalidCall: _failureCode!

setWindowOrgEx: hdc nXOrg: x nYOrg: y lppt: aPOINT
	"The SetWindowOrgEx function specifies which window point maps to the viewport origin (0,0). 

		BOOL SetWindowOrgEx(
			HDC  hdc,	// handle of device context 
			int  X,	// x-coordinate of new origin 
			int  Y,	// y-coordinate of new origin 
			LPPOINT  lpPoint 	// points to previous origin );"

	<stdcall: bool SetWindowOrgEx handle int32 int32 POINTL*>
	^self invalidCall: _failureCode!

startDoc: hdc lpdi: info
	"Start a print job.
		int StartDoc(
  			HDC hdc,				// handle of device context 
			CONST DOCINFOW *lpdi 	// address of structure with file names  
		);"

	<stdcall: int32 StartDocW handle DOCINFOW*>
	^self invalidCall: _failureCode!

startPage: hdc
	"Invoke the StartPage() function of the module wrapped by the receiver.
	Helpstring: Prepares the printer driver to accept data.

		int __stdcall StartPage(
			HDC HDC);"

	<stdcall: int32 StartPage handle>
	^self invalidCall: _failureCode!

stretchBlt: hdc nXOriginDest: x nYOriginDest: y nWidthDest: w nHeightDest: h hdcSrc: hdcSrc nXOriginSrc: sx nYOriginSrc: sy nWidthSrc: sw nHeightSrc: sh dwRop: dwRop
	"Copy a bitmap from a source rectangle into a destination rectangle, stretching or 
	compressing it to fit the dimensions of the destination rectangle, if necessary. Windows 
	stretches or compresses the bitmap according to the stretching mode currently set in 
	the destination device context. 
		BOOL StretchBlt(
  			HDC hdcDest,	// handle of destination device context 
			int nXOriginDest,	// x-coordinate of upper-left corner of dest. rect. 
			int nYOriginDest,	// y-coordinate of upper-left corner of dest. rect. 
			int nWidthDest,	// width of destination rectangle 
			int nHeightDest,	// height of destination rectangle 
			HDC hdcSrc,	// handle of source device context 
			int nXOriginSrc,	// x-coordinate of upper-left corner of source rectangle 
			int nYOriginSrc,	// y-coordinate of upper-left corner of source rectangle 
			int nWidthSrc,	// width of source rectangle 
			int nHeightSrc,	// height of source rectangle 
			DWORD dwRop 	// raster operation code 
		);"

	<stdcall: bool StretchBlt handle int32 int32 int32 int32 handle int32 int32 int32 int32 uint32>
	^self invalidCall: _failureCode!

stretchDIBits: hdc xDest: xDest yDest: yDest nDestWidth: nDestWidth nDestHeight: nDestHeight xSrc: xSrc ySrc: ySrc nSrcWidth: nSrcWidth nSrcHeight: nSrcHeight lpBits: lpBits lpBitsInfo: lpBitsInfo iUsage: iUsage dwRop: dwRop
	"Invoke the StretchDIBits() function of the module wrapped by the receiver.
	Helpstring: Copies the color data for a rectangle of pixels in a device-independent bitmap (DIB) to the specified destination rectangle

		int __stdcall StretchDIBits(
			HDC HDC,
			int xDest,
			int yDest,
			int nDestWidth,
			int nDestHeight,
			int xSrc,
			int ySrc,
			int nSrcWidth,
			int nSrcHeight,
			LPVOID lpBits,
			LPVOID lpBitsInfo,
			UINT iUsage,
			DWORD dwRop);"

	<stdcall: int32 StretchDIBits handle int32 int32 int32 int32 int32 int32 int32 int32 void* void* uint32 uint32>
	^self invalidCall: _failureCode!

textOut: hdc nXStart: nXStart nYStart: nYStart lpString: lpString cbString: cbString
	"Invoke the TextOut() function of the module wrapped by the receiver.
	Helpstring: Writes a character string at the specified location, using the currently selected font

		BOOL __stdcall TextOut(
			HDC HDC,
			int nXStart,
			int nYStart,
			LPCWSTR lpString,
			int cbString);"

	<stdcall: bool TextOutW handle int32 int32 lpwstr int32>
	^self invalidCall: _failureCode! !
!OS.GDILibrary categoriesForMethods!
addFontResource:!public!win32 functions-font and text! !
beginPath:!**auto generated**!public!win32 functions-path! !
bitBlt:nXDest:nYDest:nWidth:nHeight:hdcSrc:nXSrc:nYSrc:dwRop:!**auto generated**!public!win32 functions-bitmap! !
closeFigure:!**auto generated**!public!win32 functions-path! !
combineRgn:hrgnSrc1:hrgnSrc2:fnCombineMode:!**auto generated**!public!win32 functions-region! !
createBitmap:nHeight:cPlanes:cBitsPerPel:lpvBits:!public!win32 functions-bitmap! !
createBrushIndirect:!**auto generated**!public!win32 functions-brush! !
createCompatibleBitmap:nWidth:nHeight:!**auto generated**!public!win32 functions-bitmap! !
createCompatibleDC:!**auto generated**!public!win32 functions-device context! !
createDC:lpszDevice:lpszOutput:lpInitData:!public!win32 functions-device context! !
createDIBSection:pbmi:iUsage:ppvBits:hSection:dwOffset:!**auto generated**!public!win32 functions-bitmap! !
createEllipticRgnIndirect:!**auto generated**!public!win32 functions-region! !
createFontIndirectA:!**auto generated**!public!win32 functions-font and text! !
createFontIndirectW:!**auto generated**!public!win32 functions-font and text! !
createHatchBrush:color:!**auto generated**!public!win32 functions-brush! !
createIC:lpszDevice:lpszOutput:lpdvminit:!**auto generated**!public!win32 functions-device context! !
createPalette:!**auto generated**!public!win32 functions-color! !
createPen:nWidth:crColor:!**auto generated**!public!win32 functions-pen! !
createPenIndirect:!**auto generated**!public!win32 functions-pen! !
createRectRgnIndirect:!**auto generated**!public!win32 functions-region! !
deleteDC:!**auto generated**!public!win32 functions-device context! !
deleteObject:!**auto generated**!public!win32 functions-device context! !
ellipse:nLeftRect:nTopRect:nRightRect:nBottomRect:!public!win32 functions-filled shape! !
endDoc:!**auto generated**!public!win32 functions-printing and printer spooler! !
endPage:!**auto generated**!public!win32 functions-printing and printer spooler! !
endPath:!**auto generated**!public!win32 functions-path! !
enumFontFamilies:lpszFamily:lpEnumFontFamProc:lParam:!public!win32 functions-font and text! !
excludeClipRect:nLeftRect:nTopRect:nRightRect:nBottomRect:!**auto generated**!public!win32 functions-clipping! !
extTextOut:x:y:fuOptions:lprc:lpString:cbCount:lpDx:!**auto generated**!public!win32 functions-font and text! !
fillRgn:hRgn:hBr:!public!win32 functions-region! !
frameRgn:hRgn:hBr:nWidth:nHeight:!public!win32 functions-region! !
gdiAlphaBlend:xoriginDest:yoriginDest:wDest:hDest:hdcSrc:xoriginSrc:yoriginSrc:wSrc:hSrc:ftn:!**auto generated**!public!win32 functions-bitmap! !
gdiGradientFill:pVertex:nVertex:pMesh:nCount:ulMode:!**auto generated**!public! !
gdiTransparentBlt:xoriginDest:yoriginDest:wDest:hDest:hdcSrc:xoriginSrc:yoriginSrc:wSrc:hSrc:crTransparent:!**auto generated**!public! !
getBkColor:!**auto generated**!public!win32 functions-device context! !
getBkMode:!**auto generated**!public!win32 functions-device context! !
getClipBox:lprc:!**auto generated**!public!win32 functions-clipping! !
getCurrentObject:uObjectType:!**auto generated**!public!win32 functions-device context! !
getDCBrushColor:!public!win32 functions-device context! !
getDCPenColor:!public!win32 functions-device context! !
getDeviceCaps:nIndex:!**auto generated**!public!win32 functions-device context! !
getDIBColorTable:uStartIndex:cEntries:pColors:!**auto generated**!public!win32 functions-bitmap! !
getDIBits:hbm:uStartScan:cScanLines:lpvBits:lpbi:uUsage:!**auto generated**!public! !
getMapMode:!**auto generated**!public!win32 functions-transformations! !
getNearestPaletteIndex:crColor:!**auto generated**!public!win32 functions-color! !
getObject:cbBuffer:lpvObject:!public!win32 functions-device context! !
getObjectW:cbBuffer:lpvObject:!public!win32 functions-device context! !
getOutlineTextMetrics:cbData:lpotm:!public!win32 functions-font and text! !
getPaletteEntries:iStartIndex:nEntries:lppe:!**auto generated**!public!win32 functions-color! !
getPixel:xPos:yPos:!public!win32 functions-device context! !
getROP2:!**auto generated**!public!win32 functions-device context! !
getStockObject:!**auto generated**!public!win32 functions-device context! !
getTextColor:!public!win32 functions-font and text! !
getTextExtentPoint32:lpString:c:lpSize:!**auto generated**!public!win32 functions-font and text! !
getTextMetrics:lptm:!public!win32 functions-font and text! !
getViewportExtEx:lpSize:!public!win32 functions-transformations! !
getViewportOrgEx:lppt:!public!win32 functions-transformations! !
getWindowExtEx:lpSize:!**auto generated**!public!win32 functions-transformations! !
getWindowOrgEx:lppt:!public!win32 functions-transformations! !
intersectClipRect:nLeftRect:nTopRect:nRightRect:nBottomRect:!public!win32 functions-clipping! !
invertRgn:hRgn:!public!win32 functions-region! !
lineTo:nXEnd:nYEnd:!public!win32 functions-line and curve! !
moveToEx:x:y:lpPoint:!**auto generated**!public!win32 functions-device context! !
offsetWindowOrgEx:nXOrg:nYOrg:lppt:!public!win32 functions-transformations! !
paintRgn:hRgn:!public!win32 functions-region! !
patBlt:nXLeft:nYLeft:nWidth:nHeight:dwRop:!public!win32 functions-bitmap! !
plgBlt:lpPoint:hdcSrc:nXSrc:nYSrc:nWidth:nHeight:hbmMask:sMask:yMask:!**auto generated**!public! !
polygon:lpPoints:nCount:!public!win32 functions-filled shape! !
ptInRegion:x:y:!public!win32 functions-region! !
realizePalette:!**auto generated**!public!win32 functions-color! !
rectangle:nLeftRect:nTopRect:nRightRect:nBottomRect:!public!win32 functions-filled shape! !
rectVisible:lprc:!public!win32 functions-device context! !
removeFontResource:!public!win32 functions-font and text! !
restoreDC:nSavedDC:!public!win32 functions-device context! !
roundRect:nLeftRect:nTopRect:nRightRect:nBottomRect:nWidth:nHeight:!public!win32 functions-filled shape! !
saveDC:!public!win32 functions-device context! !
selectClipPath:iMode:!**auto generated**!public!win32 functions-clipping! !
selectClipRgn:hrgn:!public!win32 functions-clipping! !
selectObject:hgdiobj:!**auto generated**!public!win32 functions-device context! !
selectPalette:hPal:bForceBackground:!public!win32 functions-color! !
setBkColor:crColor:!public!win32 functions-painting and drawing! !
setBkMode:iBkMode:!public!win32 functions-painting and drawing! !
setBrushOrgEx:nXOrg:nYOrg:lppt:!public!win32 functions-brush!win32 functions-transformations! !
setDIBColorTable:uStartIndex:cEntries:pColors:!**auto generated**!public!win32 functions-bitmap! !
setDIBits:hbmp:uStartScan:cScanLines:lpvBits:lpbmi:fuColorUse:!**auto generated**!public! !
setMapMode:fnMapMode:!**auto generated**!public!win32 functions-transformations! !
setPixelV:x:y:crColor:!public!win32 functions-device context! !
setROP2:fnDrawMode:!**auto generated**!public!win32 functions-device context! !
setTextAlign:fMode:!public!win32 functions-font and text! !
setTextColor:crColor:!public!win32 functions-font and text! !
setViewportExtEx:nXExtent:nYExtent:lpSize:!public!win32 functions-transformations! !
setViewportOrgEx:nXOrg:nYOrg:lppt:!public!win32 functions-transformations! !
setWindowExtEx:nXExtent:nYExtent:lpSize:!**auto generated**!public!win32 functions-transformations! !
setWindowOrgEx:nXOrg:nYOrg:lppt:!public!win32 functions-transformations! !
startDoc:lpdi:!public!win32 functions-printing and printer spooler! !
startPage:!**auto generated**!public!win32 functions-printing and printer spooler! !
stretchBlt:nXOriginDest:nYOriginDest:nWidthDest:nHeightDest:hdcSrc:nXOriginSrc:nYOriginSrc:nWidthSrc:nHeightSrc:dwRop:!public!win32 functions-bitmap! !
stretchDIBits:xDest:yDest:nDestWidth:nDestHeight:xSrc:ySrc:nSrcWidth:nSrcHeight:lpBits:lpBitsInfo:iUsage:dwRop:!**auto generated**!public!win32 functions-bitmap! !
textOut:nXStart:nYStart:lpString:cbString:!**auto generated**!public!win32 functions-font and text! !
!

!OS.GDILibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which the 
	receiver represents"

	^'GDI32'!

sharedVariableName
	^#{Gdi32}! !
!OS.GDILibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

