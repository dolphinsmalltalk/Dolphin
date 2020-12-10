"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'OS.CommCtrlLibrary'
	instanceVariableNames: ''
	classVariableNames: 'InitFlags'
	imports: #(#{OS.CommCtrlConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.CommCtrlLibrary guid: (Core.GUID fromString: '{64674056-3a82-101b-8181-00aa003743d3}')!
OS.CommCtrlLibrary comment: 'CommCtrlLibrary is an <ExternalLibrary> to represent the Windows Common Controls Library, COMCTL32.DLL. This library implements the "newer" (post-Windows 95) controls such as the ListView and TreeView, with recent additions (known collectively as the IE4 controls) such as the DateTimePicker. A notable exception is the RichEdit control, which is implemented in its own library.

Dolphin requires at least version 4.70 of this library (previous versions were supported by some older versions of Dolphin, but you must now upgrade to the latest DLL, which is available as a free download from Microsoft).'!
!OS.CommCtrlLibrary categoriesForClass!External-Libraries-Win32! !
!OS.CommCtrlLibrary methodsFor!

imageList_AddMasked: himl hbmImage: hbmImage crMask: crMask
	"Invoke the ImageList_AddMasked() function of the module wrapped by the receiver.
	Helpstring: Adds an image or images to an image list, generating a mask from the specified bitmap

		int __stdcall ImageList_AddMasked(
			HIMAGELIST himl,
			HBITMAP hbmImage,
			COLORREF crMask);"

	<stdcall: sdword ImageList_AddMasked handle handle dword>
	^self invalidCall: _failureCode!

imageList_BeginDrag: himlTrack iTrack: iTrack dxHotspot: dxHotspot dyHotspot: dyHotspot
	"Invoke the ImageList_BeginDrag() function of the module wrapped by the receiver.
	Helpstring: Begins dragging an image

		BOOL __stdcall ImageList_BeginDrag(
			HIMAGELIST himlTrack,
			int iTrack,
			int dxHotspot,
			int dyHotspot);"

	<stdcall: bool ImageList_BeginDrag handle sdword sdword sdword>
	^self invalidCall: _failureCode!

imageList_Create: cx cy: cy flags: flags cInitial: cInitial cGrow: cGrow
	"Invoke the ImageList_Create() function of the module wrapped by the receiver.
	Helpstring: Creates a new image list

		HIMAGELIST __stdcall ImageList_Create(
			int cx,
			int cy,
			UINT flags,
			int cInitial,
			int cGrow);"

	<stdcall: handle ImageList_Create sdword sdword dword sdword sdword>
	^self invalidCall: _failureCode!

imageList_Destroy: himl
	"Invoke the ImageList_Destroy() function of the module wrapped by the receiver.
	Helpstring: Destroys an image list

		BOOL __stdcall ImageList_Destroy(
			HIMAGELIST himl);"

	<stdcall: bool ImageList_Destroy handle>
	^self invalidCall: _failureCode!

imageList_DragEnter: hwndLock x: x y: y
	"Invoke the ImageList_DragEnter() function of the module wrapped by the receiver.
	Helpstring: Updates the specified window during a drag operation and displays the drag image at the specified position

		BOOL __stdcall ImageList_DragEnter(
			HWND hwndLock,
			int x,
			int y);"

	<stdcall: bool ImageList_DragEnter handle sdword sdword>
	^self invalidCall: _failureCode!

imageList_DragLeave: hwndLock
	"Invoke the ImageList_DragLeave() function of the module wrapped by the receiver.
	Helpstring: Unlocks the specified window and hides the drag image, allowing the window to be updated

		BOOL __stdcall ImageList_DragLeave(
			HWND hwndLock);"

	<stdcall: bool ImageList_DragLeave handle>
	^self invalidCall: _failureCode!

imageList_DragMove: x y: y
	"Invoke the ImageList_DragMove() function of the module wrapped by the receiver.
	Helpstring: Moves the image that is being dragged during a drag-and-drop operation

		BOOL __stdcall ImageList_DragMove(
			int x,
			int y);"

	<stdcall: bool ImageList_DragMove sdword sdword>
	^self invalidCall: _failureCode!

imageList_DragShowNolock: fShow
	"Invoke the ImageList_DragShowNolock() function of the module wrapped by the receiver.
	Helpstring: Shows or hides the image being dragged

		BOOL __stdcall ImageList_DragShowNolock(
			BOOL fShow);"

	<stdcall: bool ImageList_DragShowNolock bool>
	^self invalidCall: _failureCode!

imageList_Draw: hImageList i: index hdcDst: hdc x: x y: y fStyle: style
	"The ImageList_Draw function draws an image list item in the specified
	device context.

	BOOL WINAPI ImageList_Draw(
		HIMAGELIST himl, 	
		int i, 	
		HDC hdcDst, 	
		int x, 	
		int y, 	
		UINT fStyle);	"

	<stdcall: bool ImageList_Draw handle sdword handle sdword sdword dword>
	^self invalidCall: _failureCode!

imageList_DrawEx: himl i: i hdcDst: hdcDst x: x y: y dx: dx dy: dy rgbBk: rgbBk rgbFg: rgbFg fStyle: fStyle
	"Invoke the ImageList_DrawEx() function of the module wrapped by the receiver.
	Helpstring: Draws an image list item in the specified device context using the given drawing style and color

		long __stdcall ImageList_DrawEx(
			long himl,
			int i,
			long hdcDst,
			int x,
			int y,
			int dx,
			int dy,
			unsigned long rgbBk,
			unsigned long rgbFg,
			unsigned int fStyle);"

	<stdcall: bool ImageList_DrawEx handle sdword handle sdword sdword sdword sdword dword dword dword>
	^self invalidCall: _failureCode!

imageList_Duplicate: himl
	"Invoke the ImageList_Duplicate() function of the module wrapped by the receiver.
	Helpstring: Creates a duplicate of an existing image list

		HIMAGELIST __stdcall ImageList_Duplicate(
			HIMAGELIST himl);"

	<stdcall: handle ImageList_Duplicate handle>
	^self invalidCall: _failureCode!

imageList_EndDrag
	"Invoke the ImageList_EndDrag() function of the module wrapped by the receiver.
	Helpstring: Ends a drag operation

		void __stdcall ImageList_EndDrag();"

	<stdcall: void ImageList_EndDrag>
	^self invalidCall: _failureCode!

imageList_GetBkColor: himl
	"Invoke the ImageList_GetBkColor() function of the module wrapped by the receiver.
	Helpstring: Gets the image list background color

		COLORREF __stdcall ImageList_GetBkColor(
			HIMAGELIST himl);"

	<stdcall: dword ImageList_GetBkColor handle>
	^self invalidCall: _failureCode!

imageList_GetIcon: himl i: i flags: flags
	"Invoke the ImageList_GetIcon() function of the module wrapped by the receiver.
	Helpstring: Creates an icon or cursor based on an image and mask in an image list

		HICON __stdcall ImageList_GetIcon(
			HIMAGELIST himl,
			int i,
			UINT flags);"

	<stdcall: handle ImageList_GetIcon handle sdword dword>
	^self invalidCall: _failureCode!

imageList_GetIconSize: himl cx: cx cy: cy
	"Invoke the ImageList_GetIconSize() function of the module wrapped by the receiver.
	Helpstring: Retrieves the dimensions of images in the image list.

		BOOL __stdcall ImageList_GetIconSize(
			HIMAGELIST himl,
			int* cx,
			int* cy);"

	<stdcall: bool ImageList_GetIconSize handle sdword sdword>
	^self invalidCall: _failureCode!

imageList_GetImageCount: himl
	"Invoke the ImageList_GetImageCount() function of the module wrapped by the receiver.
	Helpstring: Gets the number of images in an image list

		int __stdcall ImageList_GetImageCount(
			HIMAGELIST himl);"

	<stdcall: sdword ImageList_GetImageCount handle>
	^self invalidCall: _failureCode!

imageList_LoadImage: hi lpbmp: lpbmp cx: cx cGrow: cGrow crMask: crMask uType: uType uFlags: uFlags
	"Invoke the ImageList_LoadImage() function of the module wrapped by the receiver.
	Helpstring: Creates an image list from the specified bitmap, cursor, or icon resource

		HIMAGELIST __stdcall ImageList_LoadImage(
			HINSTANCE hi,
			LPCWSTR lpbmp,
			int cx,
			int cGrow,
			COLORREF crMask,
			UINT uType,
			UINT uFlags);"

	<stdcall: handle ImageList_LoadImageW handle lpwstr sdword sdword dword dword dword>
	^self invalidCall: _failureCode!

imageList_ReplaceIcon: himl i: i hicon: hicon
	"Invoke the ImageList_ReplaceIcon() function of the module wrapped by the receiver.
	Helpstring: Replaces an image with an icon or cursor

		int __stdcall ImageList_ReplaceIcon(
			HIMAGELIST himl,
			int i,
			HICON HICON);"

	<stdcall: sdword ImageList_ReplaceIcon handle sdword handle>
	^self invalidCall: _failureCode!

imageList_SetBkColor: himl clrBk: clrBk
	"Invoke the ImageList_SetBkColor() function of the module wrapped by the receiver.
	Helpstring: Sets the image list background color

		COLORREF __stdcall ImageList_SetBkColor(
			HIMAGELIST himl,
			COLORREF clrBk);"

	<stdcall: dword ImageList_SetBkColor handle dword>
	^self invalidCall: _failureCode!

imageList_SetDragCursorImage: himlDrag iDrag: iDrag dxHotspot: dxHotspot dyHotspot: dyHotspot
	"Invoke the ImageList_SetDragCursorImage() function of the module wrapped by the receiver.
	Helpstring: Creates a new drag image by combining the specified image (typically a cursor) with the current drag image

		BOOL __stdcall ImageList_SetDragCursorImage(
			HIMAGELIST himlDrag,
			int iDrag,
			int dxHotspot,
			int dyHotspot);"

	<stdcall: bool ImageList_SetDragCursorImage handle sdword sdword sdword>
	^self invalidCall: _failureCode!

imageList_SetIconSize: himl cx: cx cy: cy
	"Invoke the ImageList_SetIconSize() function of the module wrapped by the receiver.
	Helpstring: Sets the dimensions of images in an image list

		BOOL __stdcall ImageList_SetIconSize(
			HIMAGELIST himl,
			int cx,
			int cy);"

	<stdcall: bool ImageList_SetIconSize handle sdword sdword>
	^self invalidCall: _failureCode!

initCommonControlsEx: anINITCOMMONCONTROLSEX
	"Initialize the receiver as specified by the init struct argument."

	<stdcall: bool InitCommonControlsEx void*>
	^self invalidCall: _failureCode!

initialize
	"Private - Initialize and answer the receiver.
	Implementation Note: The INITCOMMONCONTROLSEX external structure class has been
	removed from Dolphin 4, as we can hardly justify having a class just for this purpose."

	| struct |
	struct := ByteArray new: 8.
	struct
		dwordAtOffset: 0 put: 8;
		dwordAtOffset: 4 put: self class initFlags.
	self initCommonControlsEx: struct!

loadIconMetric: hInst pszName: pszName lims: lims phico: phico
	"Invoke the LoadIconMetric() function of the module wrapped by the receiver.
	Helpstring: Loads a specified icon resource with a client-specified system metric

		HRESULT_NOTHROW __stdcall LoadIconMetric(
			HINSTANCE hInst,
			RESOURCEID pszName,
			int lims,
			[out, retval]HICON* phico);"

	<stdcall: sdword LoadIconMetric handle void* sdword handle*>
	^self invalidCall: _failureCode!

loadIconWithScaleDown: hInst pszName: pszName cx: cx cy: cy phico: phico
	"Invoke the LoadIconWithScaleDown() function of the module wrapped by the receiver.
	Helpstring: Loads an icon. If the icon is not a standard size, this function scales down a larger image instead of scaling up a smaller image.

		HRESULT __stdcall LoadIconWithScaleDown(
			HINSTANCE hInst,
			LPCWSTR pszName,
			int cx,
			int cy,
			[out, retval]HICON* phico);"

	<stdcall: sdword LoadIconWithScaleDown handle lpvoid sdword sdword handle*>
	^self invalidCall: _failureCode! !
!OS.CommCtrlLibrary categoriesFor: #imageList_AddMasked:hbmImage:crMask:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_BeginDrag:iTrack:dxHotspot:dyHotspot:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_Create:cy:flags:cInitial:cGrow:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_Destroy:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_DragEnter:x:y:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_DragLeave:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_DragMove:y:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_DragShowNolock:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_Draw:i:hdcDst:x:y:fStyle:!primitives!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_DrawEx:i:hdcDst:x:y:dx:dy:rgbBk:rgbFg:fStyle:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_Duplicate:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_EndDrag!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_GetBkColor:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_GetIcon:i:flags:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_GetIconSize:cx:cy:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_GetImageCount:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_LoadImage:lpbmp:cx:cGrow:crMask:uType:uFlags:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_ReplaceIcon:i:hicon:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_SetBkColor:clrBk:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_SetDragCursorImage:iDrag:dxHotspot:dyHotspot:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #imageList_SetIconSize:cx:cy:!**auto generated**!public!win32 functions-image list! !
!OS.CommCtrlLibrary categoriesFor: #initCommonControlsEx:!initializing!primitives!public! !
!OS.CommCtrlLibrary categoriesFor: #initialize!initializing!private! !
!OS.CommCtrlLibrary categoriesFor: #loadIconMetric:pszName:lims:phico:!**auto generated**!public! !
!OS.CommCtrlLibrary categoriesFor: #loadIconWithScaleDown:pszName:cx:cy:phico:!**auto generated**!public! !

!OS.CommCtrlLibrary class methodsFor!

closeDefault
	"Private - Close the default instance of the receiver (if there is one).
	Implementation Note: As a temporary bodge, don't actually unload the library
	when discarding the default instance because to do so causes problems with the
	ImageStripperProgress dialog (which uses one of the common control classes).
	My guess is that unloading the library unregisters the common control window
	classes, which for some reason causes a subsequent GPF in the progress bar."

	default := nil!

defaultInitFlags
	^ICC_WIN95_CLASSES!

fileName
	"Answer the host system file name for the library."

	^'COMCTL32'!

initFlags
	InitFlags isNil ifTrue: [InitFlags := self defaultInitFlags].
	^InitFlags!

initFlags: anInteger 
	InitFlags := anInteger! !
!OS.CommCtrlLibrary class categoriesFor: #closeDefault!private!realizing/unrealizing! !
!OS.CommCtrlLibrary class categoriesFor: #defaultInitFlags!accessing!private! !
!OS.CommCtrlLibrary class categoriesFor: #fileName!constants!public! !
!OS.CommCtrlLibrary class categoriesFor: #initFlags!accessing!public! !
!OS.CommCtrlLibrary class categoriesFor: #initFlags:!accessing!not an aspect!public! !

