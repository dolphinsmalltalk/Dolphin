"Filed out from Dolphin Smalltalk 7"!

OS.ThemeLibrary subclass: #'OS.VistaThemeLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.VistaThemeLibrary guid: (Core.GUID fromString: '{a07fa8a2-68a8-4f59-9459-e71f9bece9ac}')!
OS.VistaThemeLibrary comment: ''!
!OS.VistaThemeLibrary categoriesForClass!Win32-Modules! !
!OS.VistaThemeLibrary methodsFor!

beginBufferedAnimation: hwnd hdcTarget: hdcTarget prcTarget: prcTarget dwFormat: dwFormat pPaintParams: pPaintParams pAnimationParams: pAnimationParams phdcFrom: phdcFrom phdcTo: phdcTo
	"Invoke the BeginBufferedAnimation() function of the module wrapped by the receiver.

		HANDLE __stdcall BeginBufferedAnimation(
			[in]HWND HWND,
			[in]HDC hdcTarget,
			[in]RECTL* prcTarget,
			[in]BP_BUFFERFORMAT dwFormat,
			[in]BP_PAINTPARAMS* pPaintParams,
			[in]BP_ANIMATIONPARAMS* pAnimationParams,
			[out]HDC* phdcFrom,
			[out]HDC* phdcTo);"

	<stdcall: handle BeginBufferedAnimation handle handle RECTL* sdword BP_PAINTPARAMS* BP_ANIMATIONPARAMS* handle* handle*>
	^self invalidCall: _failureCode!

beginBufferedPaint: hdcTarget prcTarget: prcTarget dwFormat: dwFormat pPaintParams: pPaintParams phDC: phDC
	"Invoke the BeginBufferedPaint() function of the module wrapped by the receiver.
	Helpstring: Begins a buffered paint operation.

		HANDLE __stdcall BeginBufferedPaint(
			[in]HDC hdcTarget,
			[in]RECTL* prcTarget,
			[in]BP_BUFFERFORMAT dwFormat,
			[in]BP_PAINTPARAMS* pPaintParams,
			[out]HDC* phDC);"

	<stdcall: handle BeginBufferedPaint handle RECTL* sdword BP_PAINTPARAMS* handle*>
	^self invalidCall: _failureCode!

bufferedPaintClear: hBufferedPaint prc: prc
	"Invoke the BufferedPaintClear() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HRESULT __stdcall BufferedPaintClear(
			[in]HANDLE hBufferedPaint,
			[in, optional]RECTL* prc);"

	<stdcall: hresult BufferedPaintClear handle RECTL*>
	^self invalidCall: _failureCode!

bufferedPaintInit
	"Invoke the BufferedPaintInit() function of the module wrapped by the receiver.
	Helpstring: Initialize the Buffered Paint API.

		HRESULT __stdcall BufferedPaintInit();"

	<stdcall: hresult BufferedPaintInit>
	^self invalidCall: _failureCode!

bufferedPaintRenderAnimation: hwnd hdcTarget: hdcTarget
	"Invoke the BufferedPaintRenderAnimation() function of the module wrapped by the receiver.

		BOOL __stdcall BufferedPaintRenderAnimation(
			[in]HWND HWND,
			[in]HDC hdcTarget);"

	<stdcall: bool BufferedPaintRenderAnimation handle handle>
	^self invalidCall: _failureCode!

bufferedPaintSetAlpha: hBufferedPaint prc: prc alpha: alpha
	"Invoke the BufferedPaintSetAlpha() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HRESULT __stdcall BufferedPaintSetAlpha(
			[in]HANDLE hBufferedPaint,
			[in]RECTL* prc,
			[in]BYTE Alpha);"

	<stdcall: hresult BufferedPaintSetAlpha handle RECTL* byte>
	^self invalidCall: _failureCode!

bufferedPaintStopAllAnimations: hwnd
	"Invoke the BufferedPaintStopAllAnimations() function of the module wrapped by the receiver.

		HRESULT __stdcall BufferedPaintStopAllAnimations(
			[in]HWND HWND);"

	<stdcall: hresult BufferedPaintStopAllAnimations handle>
	^self invalidCall: _failureCode!

bufferedPaintUnInit
	"Invoke the BufferedPaintUnInit() function of the module wrapped by the receiver.
	Helpstring: Uninitialize the Buffered Paint API.

		HRESULT __stdcall BufferedPaintUnInit();"

	"Ignore any errors from calling this function, as we call it on shutdown."

	<stdcall: sdword BufferedPaintUnInit>
	^self invalidCall: _failureCode!

endBufferedPaint: hBufferedPaint fUpdateTarget: fUpdateTarget
	"Invoke the EndBufferedPaint() function of the module wrapped by the receiver.
	Helpstring: Ends a buffered paint operation.

		HRESULT __stdcall EndBufferedPaint(
			[in]HANDLE hBufferedPaint,
			[in]BOOL fUpdateTarget);"

	<stdcall: hresult EndBufferedPaint handle bool>
	^self invalidCall: _failureCode!

getBufferedPaintBits: hBufferedPaint ppbBuffer: ppbBuffer pcxRow: pcxRow
	"Invoke the GetBufferedPaintBits() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HRESULT __stdcall GetBufferedPaintBits(
			[in]HANDLE hBufferedPaint,
			[out]RGBQUAD** ppbBuffer,
			[out]int* pcxRow);"

	<stdcall: hresult GetBufferedPaintBits handle RGBQUAD** sdword*>
	^self invalidCall: _failureCode!

getBufferedPaintDC: hBufferedPaint
	"Invoke the GetBufferedPaintDC() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HDC __stdcall GetBufferedPaintDC(
			[in]HANDLE hBufferedPaint);"

	<stdcall: handle GetBufferedPaintDC handle>
	^self invalidCall: _failureCode!

getBufferedPaintTargetDC: hBufferedPaint
	"Invoke the GetBufferedPaintTargetDC() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HDC __stdcall GetBufferedPaintTargetDC(
			[in]HANDLE hBufferedPaint);"

	<stdcall: handle GetBufferedPaintTargetDC handle>
	^self invalidCall: _failureCode!

getBufferedPaintTargetRect: hBufferedPaint prc: prc
	"Invoke the GetBufferedPaintTargetRect() function of the module wrapped by the receiver.
	Helpstring: Returns the target rectangle specified during BeginBufferedPaint.

		HRESULT __stdcall GetBufferedPaintTargetRect(
			[in]HANDLE hBufferedPaint,
			[out, retval]RECTL* prc);"

	<stdcall: hresult GetBufferedPaintTargetRect handle RECTL*>
	^self invalidCall: _failureCode!

isCompositionActive
	"Invoke the IsCompositionActive() function of the module wrapped by the receiver.
	Helpstring: Tells if the DWM is running, and composition effects are possible for this process (themes are active).

		BOOL __stdcall IsCompositionActive();"

	<stdcall: bool IsCompositionActive>
	^self invalidCall: _failureCode!

onExit
	"Private - Perform any uninitialization required at system shutdown time"

	self bufferedPaintUnInit!

onStartup
	"Private - Perform any initialization required at system startup time"

	self bufferedPaintInit! !
!OS.VistaThemeLibrary categoriesFor: #beginBufferedAnimation:hdcTarget:prcTarget:dwFormat:pPaintParams:pAnimationParams:phdcFrom:phdcTo:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #beginBufferedPaint:prcTarget:dwFormat:pPaintParams:phDC:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #bufferedPaintClear:prc:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #bufferedPaintInit!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #bufferedPaintRenderAnimation:hdcTarget:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #bufferedPaintSetAlpha:prc:alpha:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #bufferedPaintStopAllAnimations:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #bufferedPaintUnInit!public! !
!OS.VistaThemeLibrary categoriesFor: #endBufferedPaint:fUpdateTarget:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #getBufferedPaintBits:ppbBuffer:pcxRow:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #getBufferedPaintDC:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #getBufferedPaintTargetDC:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #getBufferedPaintTargetRect:prc:!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #isCompositionActive!**auto generated**!public! !
!OS.VistaThemeLibrary categoriesFor: #onExit!private! !
!OS.VistaThemeLibrary categoriesFor: #onStartup!private! !

