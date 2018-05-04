"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #Msimg32Library
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Msimg32Library guid: (GUID fromString: '{5a76781d-d74e-48fe-8991-46ae340fcc94}')!
Msimg32Library comment: 'Msimg32Library is the <ExternalLibrary> class to represent the dynamic link library, ''MSIMG32.DLL''.It was generated generated from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring for this module
	"Extension component for Windows GDI that contains new APIs"

Warning: This comment was automatically generated from the module''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	dllname("MSIMG32.DLL"), 
	uuid(5A76781D-D74E-48FE-8991-46AE340FCC94), 
	helpstring("Extension component for Windows GDI that contains new APIs")
]
module Msimg32
{
	[entry(0x60000000), helpstring("Displays bitmaps that have transparent or semitransparent pixels")]
	BOOL __stdcall AlphaBlend(
		[in]HDC hdcDest,
		[in]int nXOriginDest,
		[in]int nYOriginDest,
		[in]int nWidthDest,
		[in]int nHeightDest,
		[in]HDC hdcSrc,
		[in]int nXOriginSrc,
		[in]int nYOriginSrc,
		[in]int nWidthSrc,
		[in]int nHeightSrc,
		[in]BLENDFUNCTION blendFctn);
	[entry(0x60000001), helpstring("Performs a bit-block transfer of the color data corresponding to a rectangle of pixels from the specified source device context into a destination device context.")]
	BOOL __stdcall TransparentBlt(
		[in]HDC hdcDest,
		[in]int nXOriginDest,
		[in]int nYOriginDest,
		[in]int nWidthDest,
		[in]int nHeightDest,
		[in]HDC hdcSrc,
		[in]int nXOriginSrc,
		[in]int nYOriginSrc,
		[in]int nWidthSrc,
		[in]int nHeightSrc,
		[in]UINT crTransparent);
	[entry(0x60000002), helpstring("Gradient fills rectangle and triangle structures")]
	BOOL __stdcall GradientFill(
		[in]HDC HDC,
		[in]TRIVERTEX* pVertex,
		[in]ULONG dwNumVertex,
		[in]void* pMesh,
		[in]ULONG dwNumMesh,
		[in]ULONG dwMode);
};
'!
!Msimg32Library categoriesForClass!Win32-Modules! !
!Msimg32Library methodsFor!

alphaBlend: hdcDest nXOriginDest: nXOriginDest nYOriginDest: nYOriginDest nWidthDest: nWidthDest nHeightDest: nHeightDest hdcSrc: hdcSrc nXOriginSrc: nXOriginSrc nYOriginSrc: nYOriginSrc nWidthSrc: nWidthSrc nHeightSrc: nHeightSrc blend: blend 
	"Invoke the AlphaBlend() function of the module wrapped by the receiver.
	Helpstring: Displays bitmaps that have transparent or semitransparent pixels

		BOOL __stdcall AlphaBlend(
			[in]HDC hdcDest,
			[in]int nXOriginDest,
			[in]int nYOriginDest,
			[in]int nWidthDest,
			[in]int nHeightDest,
			[in]HDC hdcSrc,
			[in]int nXOriginSrc,
			[in]int nYOriginSrc,
			[in]int nWidthSrc,
			[in]int nHeightSrc,
			[in]BLENDFUNCTION blend);"

	<stdcall: bool AlphaBlend handle sdword sdword sdword sdword handle sdword sdword sdword sdword BLENDFUNCTION>
	^self invalidCall!

gradientFill: hdc pVertex: pVertex dwNumVertex: dwNumVertex pMesh: pMesh dwNumMesh: dwNumMesh dwMode: dwMode
	"Invoke the GradientFill() function of the module wrapped by the receiver.
	Helpstring: Gradient fills rectangle and triangle structures

		BOOL __stdcall GradientFill(
			[in]HDC HDC,
			[in]TRIVERTEX* pVertex,
			[in]ULONG dwNumVertex,
			[in]void* pMesh,
			[in]ULONG dwNumMesh,
			[in]ULONG dwMode);"

	<stdcall: bool GradientFill handle TRIVERTEX* dword void* dword dword>
	^self invalidCall!

transparentBlt: hdcDest nXOriginDest: nXOriginDest nYOriginDest: nYOriginDest nWidthDest: nWidthDest nHeightDest: nHeightDest hdcSrc: hdcSrc nXOriginSrc: nXOriginSrc nYOriginSrc: nYOriginSrc nWidthSrc: nWidthSrc nHeightSrc: nHeightSrc crTransparent: crTransparent
	"Invoke the TransparentBlt() function of the module wrapped by the receiver.
	Helpstring: Performs a bit-block transfer of the color data corresponding to a rectangle of pixels from the specified source device context into a destination device context.

		BOOL __stdcall TransparentBlt(
			[in]HDC hdcDest,
			[in]int nXOriginDest,
			[in]int nYOriginDest,
			[in]int nWidthDest,
			[in]int nHeightDest,
			[in]HDC hdcSrc,
			[in]int nXOriginSrc,
			[in]int nYOriginSrc,
			[in]int nWidthSrc,
			[in]int nHeightSrc,
			[in]UINT crTransparent);"

	<stdcall: bool TransparentBlt handle sdword sdword sdword sdword handle sdword sdword sdword sdword dword>
	^self invalidCall! !
!Msimg32Library categoriesFor: #alphaBlend:nXOriginDest:nYOriginDest:nWidthDest:nHeightDest:hdcSrc:nXOriginSrc:nYOriginSrc:nWidthSrc:nHeightSrc:blend:!**auto generated**!public!win32 functions-bitmap! !
!Msimg32Library categoriesFor: #gradientFill:pVertex:dwNumVertex:pMesh:dwNumMesh:dwMode:!**auto generated**!public! !
!Msimg32Library categoriesFor: #transparentBlt:nXOriginDest:nYOriginDest:nWidthDest:nHeightDest:hdcSrc:nXOriginSrc:nYOriginSrc:nWidthSrc:nHeightSrc:crTransparent:!**auto generated**!public! !

!Msimg32Library class methodsFor!

fileName
	"Answer the host system file name of the external library which the 
	receiver represents"

	^'msimg32'! !
!Msimg32Library class categoriesFor: #fileName!constants!public! !

