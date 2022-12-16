

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 8.01.0628 */
/* at Tue Jan 19 03:14:07 2038
 */
/* Compiler settings for Gdiplus.idl:
    Oicf, W1, Zp8, env=Win32 (32b run), target_arch=X86 8.01.0628 
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
/* @@MIDL_FILE_HEADING(  ) */



/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 500
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif /* __RPCNDR_H_VERSION__ */


#ifndef __Gdiplus_h_h__
#define __Gdiplus_h_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#ifndef DECLSPEC_XFGVIRT
#if defined(_CONTROL_FLOW_GUARD_XFG)
#define DECLSPEC_XFGVIRT(base, func) __declspec(xfg_virtual(base, func))
#else
#define DECLSPEC_XFGVIRT(base, func)
#endif
#endif

/* Forward Declarations */ 

/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 


/* interface __MIDL_itf_Gdiplus_0000_0000 */
/* [local] */ 

#pragma once

enum MetaRecordType
    {
        META_SETBKCOLOR	= 0x201,
        META_SETBKMODE	= 0x102,
        META_SETMAPMODE	= 0x103,
        META_SETROP2	= 0x104,
        META_SETRELABS	= 0x105,
        META_SETPOLYFILLMODE	= 0x106,
        META_SETSTRETCHBLTMODE	= 0x107,
        META_SETTEXTCHAREXTRA	= 0x108,
        META_SETTEXTCOLOR	= 0x209,
        META_SETTEXTJUSTIFICATION	= 0x20a,
        META_SETWINDOWORG	= 0x20b,
        META_SETWINDOWEXT	= 0x20c,
        META_SETVIEWPORTORG	= 0x20d,
        META_SETVIEWPORTEXT	= 0x20e,
        META_OFFSETWINDOWORG	= 0x20f,
        META_SCALEWINDOWEXT	= 0x410,
        META_OFFSETVIEWPORTORG	= 0x211,
        META_SCALEVIEWPORTEXT	= 0x412,
        META_LINETO	= 0x213,
        META_MOVETO	= 0x214,
        META_EXCLUDECLIPRECT	= 0x415,
        META_INTERSECTCLIPRECT	= 0x416,
        META_ARC	= 0x817,
        META_ELLIPSE	= 0x418,
        META_FLOODFILL	= 0x419,
        META_PIE	= 0x81a,
        META_RECTANGLE	= 0x41b,
        META_ROUNDRECT	= 0x61c,
        META_PATBLT	= 0x61d,
        META_SAVEDC	= 0x1e,
        META_SETPIXEL	= 0x41f,
        META_OFFSETCLIPRGN	= 0x220,
        META_TEXTOUT	= 0x521,
        META_BITBLT	= 0x922,
        META_STRETCHBLT	= 0xb23,
        META_POLYGON	= 0x324,
        META_POLYLINE	= 0x325,
        META_ESCAPE	= 0x626,
        META_RESTOREDC	= 0x127,
        META_FILLREGION	= 0x228,
        META_FRAMEREGION	= 0x429,
        META_INVERTREGION	= 0x12a,
        META_PAINTREGION	= 0x12b,
        META_SELECTCLIPREGION	= 0x12c,
        META_SELECTOBJECT	= 0x12d,
        META_SETTEXTALIGN	= 0x12e,
        META_CHORD	= 0x830,
        META_SETMAPPERFLAGS	= 0x231,
        META_EXTTEXTOUT	= 0xa32,
        META_SETDIBTODEV	= 0xd33,
        META_SELECTPALETTE	= 0x234,
        META_REALIZEPALETTE	= 0x35,
        META_ANIMATEPALETTE	= 0x436,
        META_SETPALENTRIES	= 0x37,
        META_POLYPOLYGON	= 0x538,
        META_RESIZEPALETTE	= 0x139,
        META_DIBBITBLT	= 0x940,
        META_DIBSTRETCHBLT	= 0xb41,
        META_DIBCREATEPATTERNBRUSH	= 0x142,
        META_STRETCHDIB	= 0xf43,
        META_EXTFLOODFILL	= 0x548,
        META_DELETEOBJECT	= 0x1f0,
        META_CREATEPALETTE	= 0xf7,
        META_CREATEPATTERNBRUSH	= 0x1f9,
        META_CREATEPENINDIRECT	= 0x2fa,
        META_CREATEFONTINDIRECT	= 0x2fb,
        META_CREATEBRUSHINDIRECT	= 0x2fc,
        META_CREATEREGION	= 0x6ff
    } ;

enum EnhancedMetaFileRecordType
    {
        EMR_HEADER	= 1,
        EMR_POLYBEZIER	= 2,
        EMR_POLYGON	= 3,
        EMR_POLYLINE	= 4,
        EMR_POLYBEZIERTO	= 5,
        EMR_POLYLINETO	= 6,
        EMR_POLYPOLYLINE	= 7,
        EMR_POLYPOLYGON	= 8,
        EMR_SETWINDOWEXTEX	= 9,
        EMR_SETWINDOWORGEX	= 10,
        EMR_SETVIEWPORTEXTEX	= 11,
        EMR_SETVIEWPORTORGEX	= 12,
        EMR_SETBRUSHORGEX	= 13,
        EMR_EOF	= 14,
        EMR_SETPIXELV	= 15,
        EMR_SETMAPPERFLAGS	= 16,
        EMR_SETMAPMODE	= 17,
        EMR_SETBKMODE	= 18,
        EMR_SETPOLYFILLMODE	= 19,
        EMR_SETROP2	= 20,
        EMR_SETSTRETCHBLTMODE	= 21,
        EMR_SETTEXTALIGN	= 22,
        EMR_SETCOLORADJUSTMENT	= 23,
        EMR_SETTEXTCOLOR	= 24,
        EMR_SETBKCOLOR	= 25,
        EMR_OFFSETCLIPRGN	= 26,
        EMR_MOVETOEX	= 27,
        EMR_SETMETARGN	= 28,
        EMR_EXCLUDECLIPRECT	= 29,
        EMR_INTERSECTCLIPRECT	= 30,
        EMR_SCALEVIEWPORTEXTEX	= 31,
        EMR_SCALEWINDOWEXTEX	= 32,
        EMR_SAVEDC	= 33,
        EMR_RESTOREDC	= 34,
        EMR_SETWORLDTRANSFORM	= 35,
        EMR_MODIFYWORLDTRANSFORM	= 36,
        EMR_SELECTOBJECT	= 37,
        EMR_CREATEPEN	= 38,
        EMR_CREATEBRUSHINDIRECT	= 39,
        EMR_DELETEOBJECT	= 40,
        EMR_ANGLEARC	= 41,
        EMR_ELLIPSE	= 42,
        EMR_RECTANGLE	= 43,
        EMR_ROUNDRECT	= 44,
        EMR_ARC	= 45,
        EMR_CHORD	= 46,
        EMR_PIE	= 47,
        EMR_SELECTPALETTE	= 48,
        EMR_CREATEPALETTE	= 49,
        EMR_SETPALETTEENTRIES	= 50,
        EMR_RESIZEPALETTE	= 51,
        EMR_REALIZEPALETTE	= 52,
        EMR_EXTFLOODFILL	= 53,
        EMR_LINETO	= 54,
        EMR_ARCTO	= 55,
        EMR_POLYDRAW	= 56,
        EMR_SETARCDIRECTION	= 57,
        EMR_SETMITERLIMIT	= 58,
        EMR_BEGINPATH	= 59,
        EMR_ENDPATH	= 60,
        EMR_CLOSEFIGURE	= 61,
        EMR_FILLPATH	= 62,
        EMR_STROKEANDFILLPATH	= 63,
        EMR_STROKEPATH	= 64,
        EMR_FLATTENPATH	= 65,
        EMR_WIDENPATH	= 66,
        EMR_SELECTCLIPPATH	= 67,
        EMR_ABORTPATH	= 68,
        EMR_GDICOMMENT	= 70,
        EMR_FILLRGN	= 71,
        EMR_FRAMERGN	= 72,
        EMR_INVERTRGN	= 73,
        EMR_PAINTRGN	= 74,
        EMR_EXTSELECTCLIPRGN	= 75,
        EMR_BITBLT	= 76,
        EMR_STRETCHBLT	= 77,
        EMR_MASKBLT	= 78,
        EMR_PLGBLT	= 79,
        EMR_SETDIBITSTODEVICE	= 80,
        EMR_STRETCHDIBITS	= 81,
        EMR_EXTCREATEFONTINDIRECTW	= 82,
        EMR_EXTTEXTOUTA	= 83,
        EMR_EXTTEXTOUTW	= 84,
        EMR_POLYBEZIER16	= 85,
        EMR_POLYGON16	= 86,
        EMR_POLYLINE16	= 87,
        EMR_POLYBEZIERTO16	= 88,
        EMR_POLYLINETO16	= 89,
        EMR_POLYPOLYLINE16	= 90,
        EMR_POLYPOLYGON16	= 91,
        EMR_POLYDRAW16	= 92,
        EMR_CREATEMONOBRUSH	= 93,
        EMR_CREATEDIBPATTERNBRUSHPT	= 94,
        EMR_EXTCREATEPEN	= 95,
        EMR_POLYTEXTOUTA	= 96,
        EMR_POLYTEXTOUTW	= 97,
        EMR_SETICMMODE	= 98,
        EMR_CREATECOLORSPACE	= 99,
        EMR_SETCOLORSPACE	= 100,
        EMR_DELETECOLORSPACE	= 101,
        EMR_GLSRECORD	= 102,
        EMR_GLSBOUNDEDRECORD	= 103,
        EMR_PIXELFORMAT	= 104,
        EMR_DRAWESCAPE	= 105,
        EMR_EXTESCAPE	= 106,
        EMR_STARTDOC	= 107,
        EMR_SMALLTEXTOUT	= 108,
        EMR_FORCEUFIMAPPING	= 109,
        EMR_NAMEDESCAPE	= 110,
        EMR_COLORCORRECTPALETTE	= 111,
        EMR_SETICMPROFILEA	= 112,
        EMR_SETICMPROFILEW	= 113,
        EMR_ALPHABLEND	= 114,
        EMR_ALPHADIBBLEND	= 115,
        EMR_TRANSPARENTBLT	= 116,
        EMR_TRANSPARENTDIB	= 117,
        EMR_GRADIENTFILL	= 118,
        EMR_SETLINKEDUFIS	= 119,
        EMR_SETTEXTJUSTIFICATION	= 120,
        EMR_MIN	= 1
    } ;


extern RPC_IF_HANDLE __MIDL_itf_Gdiplus_0000_0000_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_Gdiplus_0000_0000_v0_0_s_ifspec;


#ifndef __Gdiplus_LIBRARY_DEFINED__
#define __Gdiplus_LIBRARY_DEFINED__

/* library Gdiplus */
/* [helpstring][version][uuid] */ 

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("87B4C518-026E-11D3-9FD7-00A0CC3E4A32") struct ExternalHandle
    {
    void *pObj;
    } 	ExternalHandle;

typedef /* [public] */ ExternalHandle HANDLE;

typedef /* [public] */ unsigned char BYTE;

typedef /* [public] */ BYTE BOOLEAN;

typedef /* [public] */ ExternalHandle HINSTANCE;

typedef /* [public] */ ExternalHandle HICON;

typedef /* [public] */ LONG HRESULT_NOTHROW;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("73888634-0C5B-4D09-83DC-C52101C10BA3") struct BOOL
    {
    long value;
    } 	BOOL;

typedef /* [public] */ unsigned short WORD;

typedef /* [public] */ unsigned long DWORD;

typedef long LONG;

typedef float FLOAT;

typedef double DOUBLE;

typedef /* [public] */ void *LPVOID;

typedef const void *LPCVOID;

typedef int *LPINT;

typedef long *LPLONG;

typedef BOOL *LPBOOL;

typedef unsigned char CHAR;

typedef /* [public] */ CHAR *LPSTR;

typedef /* [public] */ const LPSTR LPCSTR;

typedef /* [public] */ wchar_t WCHAR;

typedef /* [public] */ WCHAR *LPWSTR;

typedef /* [public] */ const LPWSTR LPCWSTR;

typedef /* [public] */ LPSTR PSTR;

typedef /* [public] */ LPCSTR PCSTR;

typedef /* [public] */ LPVOID RESOURCEID;

typedef LPSTR LPTSTR;

typedef LPCSTR LPCTSTR;

typedef /* [public] */ CHAR TCHAR;

typedef /* [public] */ LPVOID CALLBACK;

typedef /* [public] */ unsigned char UCHAR;

typedef /* [public] */ CHAR *PCHAR;

typedef UCHAR *PUCHAR;

typedef DWORD *PDWORD;

typedef /* [public] */ WCHAR *PWCHAR;

typedef LPWSTR PWSTR;

typedef LPCWSTR PCWSTR;

typedef DWORD ACCESS_MASK;

typedef PVOID PSECURITY_DESCRIPTOR;

typedef /* [public] */ DWORD ULONG;

typedef ULONG *PULONG;

typedef HANDLE *PHANDLE;

typedef BOOLEAN *PBOOLEAN;

typedef unsigned long ULONG_PTR;

typedef void *PVOID;

typedef /* [public] */ unsigned short USHORT;

typedef /* [public] */ USHORT *PUSHORT;

typedef long FARPROC;

typedef /* [helpstring][uuid] */  DECLSPEC_UUID("301C9A7A-D4B4-42D5-895D-E658D212DF5B") struct OVERLAPPED
    {
    /* [readonly][helpstring] */ ULONG_PTR Internal;
    /* [readonly][helpstring] */ ULONG_PTR InternalHigh;
    union 
        {
        struct 
            {
            /* [helpstring] */ DWORD Offset;
            /* [helpstring] */ DWORD OffsetHigh;
            } 	;
        /* [helpstring] */ PVOID Pointer;
        } 	;
    /* [helpstring] */ HANDLE hEvent;
    } 	OVERLAPPED;

typedef /* [public] */ OVERLAPPED *LPOVERLAPPED;

typedef /* [helpstring][uuid] */  DECLSPEC_UUID("dbeaf6a6-d2f7-4153-a02e-a389955a892f") struct POINTL
    {
    LONG x;
    LONG y;
    } 	POINTL;

typedef /* [public] */ BYTE *LPBYTE;

typedef /* [public] */ HANDLE HDC;

typedef /* [public] */ HANDLE HBITMAP;

typedef /* [public] */ HANDLE HPALETTE;

typedef /* [public] */ HANDLE HENHMETAFILE;

typedef /* [public] */ HANDLE HMETAFILE;

typedef /* [public] */ HANDLE HWND;

typedef /* [custom][v1_enum][helpstring] */ 
enum GpStatus
    {
        Ok	= 0,
        GenericError	= 1,
        InvalidParameter	= 2,
        OutOfMemory	= 3,
        ObjectBusy	= 4,
        InsufficientBuffer	= 5,
        NotImplemented	= 6,
        Win32Error	= 7,
        WrongState	= 8,
        Aborted	= 9,
        FileNotFound	= 10,
        ValueOverflow	= 11,
        AccessDenied	= 12,
        UnknownImageFormat	= 13,
        FontFamilyNotFound	= 14,
        FontStyleNotFound	= 15,
        NotTrueTypeFont	= 16,
        UnsupportedGdiplusVersion	= 17,
        GdiplusNotInitialized	= 18,
        PropertyNotFound	= 19,
        PropertyNotSupported	= 20
    } 	GpStatus;

typedef /* [public] */ long GpStatus_NoThrow;

typedef /* [public][helpstring] */ UINT GraphicsState;

typedef /* [public][helpstring] */ UINT GraphicsContainer;

typedef /* [v1_enum][helpstring] */ 
enum FillMode
    {
        FillModeAlternate	= 0,
        FillModeWinding	= ( FillModeAlternate + 1 ) 
    } 	GpFillMode;

typedef /* [v1_enum][helpstring] */ 
enum QualityMode
    {
        QualityModeInvalid	= -1,
        QualityModeDefault	= 0,
        QualityModeLow	= 1,
        QualityModeHigh	= 2
    } 	GpQualityMode;

typedef /* [v1_enum][helpstring] */ 
enum CompositingMode
    {
        CompositingModeSourceOver	= 0,
        CompositingModeSourceCopy	= ( CompositingModeSourceOver + 1 ) 
    } 	CompositingMode;

typedef /* [v1_enum][helpstring] */ 
enum CompositingQuality
    {
        CompositingQualityInvalid	= QualityModeInvalid,
        CompositingQualityDefault	= QualityModeDefault,
        CompositingQualityHighSpeed	= QualityModeLow,
        CompositingQualityHighQuality	= QualityModeHigh,
        CompositingQualityGammaCorrected	= ( CompositingQualityHighQuality + 1 ) ,
        CompositingQualityAssumeLinear	= ( CompositingQualityGammaCorrected + 1 ) 
    } 	CompositingQuality;

typedef /* [v1_enum][helpstring] */ 
enum Unit
    {
        UnitWorld	= 0,
        UnitDisplay	= ( UnitWorld + 1 ) ,
        UnitPixel	= ( UnitDisplay + 1 ) ,
        UnitPoint	= ( UnitPixel + 1 ) ,
        UnitInch	= ( UnitPoint + 1 ) ,
        UnitDocument	= ( UnitInch + 1 ) ,
        UnitMillimeter	= ( UnitDocument + 1 ) 
    } 	Unit;

typedef /* [helpstring] */ Unit GpUnit;

typedef /* [v1_enum][helpstring] */ 
enum MetafileFrameUnit
    {
        MetafileFrameUnitPixel	= UnitPixel,
        MetafileFrameUnitPoint	= UnitPoint,
        MetafileFrameUnitInch	= UnitInch,
        MetafileFrameUnitDocument	= UnitDocument,
        MetafileFrameUnitMillimeter	= UnitMillimeter,
        MetafileFrameUnitGdi	= ( MetafileFrameUnitMillimeter + 1 ) 
    } 	MetafileFrameUnit;

typedef /* [v1_enum][helpstring] */ 
enum CoordinateSpace
    {
        CoordinateSpaceWorld	= 0,
        CoordinateSpacePage	= ( CoordinateSpaceWorld + 1 ) ,
        CoordinateSpaceDevice	= ( CoordinateSpacePage + 1 ) 
    } 	GpCoordinateSpace;

typedef /* [v1_enum][helpstring] */ 
enum WrapMode
    {
        WrapModeTile	= 0,
        WrapModeTileFlipX	= ( WrapModeTile + 1 ) ,
        WrapModeTileFlipY	= ( WrapModeTileFlipX + 1 ) ,
        WrapModeTileFlipXY	= ( WrapModeTileFlipY + 1 ) ,
        WrapModeClamp	= ( WrapModeTileFlipXY + 1 ) 
    } 	WrapMode;

typedef /* [helpstring] */ WrapMode GpWrapMode;

typedef /* [v1_enum][helpstring] */ 
enum HatchStyle
    {
        HatchStyleHorizontal	= 0,
        HatchStyleVertical	= ( HatchStyleHorizontal + 1 ) ,
        HatchStyleForwardDiagonal	= ( HatchStyleVertical + 1 ) ,
        HatchStyleBackwardDiagonal	= ( HatchStyleForwardDiagonal + 1 ) ,
        HatchStyleCross	= ( HatchStyleBackwardDiagonal + 1 ) ,
        HatchStyleDiagonalCross	= ( HatchStyleCross + 1 ) ,
        HatchStyle05Percent	= ( HatchStyleDiagonalCross + 1 ) ,
        HatchStyle10Percent	= ( HatchStyle05Percent + 1 ) ,
        HatchStyle20Percent	= ( HatchStyle10Percent + 1 ) ,
        HatchStyle25Percent	= ( HatchStyle20Percent + 1 ) ,
        HatchStyle30Percent	= ( HatchStyle25Percent + 1 ) ,
        HatchStyle40Percent	= ( HatchStyle30Percent + 1 ) ,
        HatchStyle50Percent	= ( HatchStyle40Percent + 1 ) ,
        HatchStyle60Percent	= ( HatchStyle50Percent + 1 ) ,
        HatchStyle70Percent	= ( HatchStyle60Percent + 1 ) ,
        HatchStyle75Percent	= ( HatchStyle70Percent + 1 ) ,
        HatchStyle80Percent	= ( HatchStyle75Percent + 1 ) ,
        HatchStyle90Percent	= ( HatchStyle80Percent + 1 ) ,
        HatchStyleLightDownwardDiagonal	= ( HatchStyle90Percent + 1 ) ,
        HatchStyleLightUpwardDiagonal	= ( HatchStyleLightDownwardDiagonal + 1 ) ,
        HatchStyleDarkDownwardDiagonal	= ( HatchStyleLightUpwardDiagonal + 1 ) ,
        HatchStyleDarkUpwardDiagonal	= ( HatchStyleDarkDownwardDiagonal + 1 ) ,
        HatchStyleWideDownwardDiagonal	= ( HatchStyleDarkUpwardDiagonal + 1 ) ,
        HatchStyleWideUpwardDiagonal	= ( HatchStyleWideDownwardDiagonal + 1 ) ,
        HatchStyleLightVertical	= ( HatchStyleWideUpwardDiagonal + 1 ) ,
        HatchStyleLightHorizontal	= ( HatchStyleLightVertical + 1 ) ,
        HatchStyleNarrowVertical	= ( HatchStyleLightHorizontal + 1 ) ,
        HatchStyleNarrowHorizontal	= ( HatchStyleNarrowVertical + 1 ) ,
        HatchStyleDarkVertical	= ( HatchStyleNarrowHorizontal + 1 ) ,
        HatchStyleDarkHorizontal	= ( HatchStyleDarkVertical + 1 ) ,
        HatchStyleDashedDownwardDiagonal	= ( HatchStyleDarkHorizontal + 1 ) ,
        HatchStyleDashedUpwardDiagonal	= ( HatchStyleDashedDownwardDiagonal + 1 ) ,
        HatchStyleDashedHorizontal	= ( HatchStyleDashedUpwardDiagonal + 1 ) ,
        HatchStyleDashedVertical	= ( HatchStyleDashedHorizontal + 1 ) ,
        HatchStyleSmallConfetti	= ( HatchStyleDashedVertical + 1 ) ,
        HatchStyleLargeConfetti	= ( HatchStyleSmallConfetti + 1 ) ,
        HatchStyleZigZag	= ( HatchStyleLargeConfetti + 1 ) ,
        HatchStyleWave	= ( HatchStyleZigZag + 1 ) ,
        HatchStyleDiagonalBrick	= ( HatchStyleWave + 1 ) ,
        HatchStyleHorizontalBrick	= ( HatchStyleDiagonalBrick + 1 ) ,
        HatchStyleWeave	= ( HatchStyleHorizontalBrick + 1 ) ,
        HatchStylePlaid	= ( HatchStyleWeave + 1 ) ,
        HatchStyleDivot	= ( HatchStylePlaid + 1 ) ,
        HatchStyleDottedGrid	= ( HatchStyleDivot + 1 ) ,
        HatchStyleDottedDiamond	= ( HatchStyleDottedGrid + 1 ) ,
        HatchStyleShingle	= ( HatchStyleDottedDiamond + 1 ) ,
        HatchStyleTrellis	= ( HatchStyleShingle + 1 ) ,
        HatchStyleSphere	= ( HatchStyleTrellis + 1 ) ,
        HatchStyleSmallGrid	= ( HatchStyleSphere + 1 ) ,
        HatchStyleSmallCheckerBoard	= ( HatchStyleSmallGrid + 1 ) ,
        HatchStyleLargeCheckerBoard	= ( HatchStyleSmallCheckerBoard + 1 ) ,
        HatchStyleOutlinedDiamond	= ( HatchStyleLargeCheckerBoard + 1 ) ,
        HatchStyleSolidDiamond	= ( HatchStyleOutlinedDiamond + 1 ) ,
        HatchStyleTotal	= ( HatchStyleSolidDiamond + 1 ) ,
        HatchStyleLargeGrid	= HatchStyleCross,
        HatchStyleMin	= HatchStyleHorizontal,
        HatchStyleMax	= ( HatchStyleTotal - 1 ) 
    } 	GpHatchStyle;

typedef /* [v1_enum][helpstring] */ 
enum DashStyle
    {
        DashStyleSolid	= 0,
        DashStyleDash	= ( DashStyleSolid + 1 ) ,
        DashStyleDot	= ( DashStyleDash + 1 ) ,
        DashStyleDashDot	= ( DashStyleDot + 1 ) ,
        DashStyleDashDotDot	= ( DashStyleDashDot + 1 ) ,
        DashStyleCustom	= ( DashStyleDashDotDot + 1 ) 
    } 	GpDashStyle;

typedef /* [v1_enum][helpstring] */ 
enum DashCap
    {
        DashCapFlat	= 0,
        DashCapRound	= 2,
        DashCapTriangle	= 3
    } 	GpDashCap;

typedef /* [v1_enum][helpstring] */ 
enum LineCap
    {
        LineCapFlat	= 0,
        LineCapSquare	= 1,
        LineCapRound	= 2,
        LineCapTriangle	= 3,
        LineCapNoAnchor	= 0x10,
        LineCapSquareAnchor	= 0x11,
        LineCapRoundAnchor	= 0x12,
        LineCapDiamondAnchor	= 0x13,
        LineCapArrowAnchor	= 0x14,
        LineCapCustom	= 0xff,
        LineCapAnchorMask	= 0xf0
    } 	GpLineCap;

typedef /* [v1_enum][helpstring] */ 
enum CustomLineCapType
    {
        CustomLineCapTypeDefault	= 0,
        CustomLineCapTypeAdjustableArrow	= 1
    } 	CustomLineCapType;

typedef /* [public] */ CustomLineCapType GpCustomLineCapType;

typedef /* [v1_enum][helpstring] */ 
enum LineJoin
    {
        LineJoinMiter	= 0,
        LineJoinBevel	= 1,
        LineJoinRound	= 2,
        LineJoinMiterClipped	= 3
    } 	GpLineJoin;

typedef /* [v1_enum][helpstring] */ 
enum PathPointType
    {
        PathPointTypeStart	= 0,
        PathPointTypeLine	= 1,
        PathPointTypeBezier	= 3,
        PathPointTypePathTypeMask	= 0x7,
        PathPointTypeDashMode	= 0x10,
        PathPointTypePathMarker	= 0x20,
        PathPointTypeCloseSubpath	= 0x80,
        PathPointTypeBezier3	= 3
    } 	PathPointType;

typedef /* [v1_enum][helpstring] */ 
enum WarpMode
    {
        WarpModePerspective	= 0,
        WarpModeBilinear	= ( WarpModePerspective + 1 ) 
    } 	WarpMode;

typedef /* [v1_enum][helpstring] */ 
enum LinearGradientMode
    {
        LinearGradientModeHorizontal	= 0,
        LinearGradientModeVertical	= ( LinearGradientModeHorizontal + 1 ) ,
        LinearGradientModeForwardDiagonal	= ( LinearGradientModeVertical + 1 ) ,
        LinearGradientModeBackwardDiagonal	= ( LinearGradientModeForwardDiagonal + 1 ) 
    } 	LinearGradientMode;

typedef /* [v1_enum][helpstring] */ 
enum CombineMode
    {
        CombineModeReplace	= 0,
        CombineModeIntersect	= ( CombineModeReplace + 1 ) ,
        CombineModeUnion	= ( CombineModeIntersect + 1 ) ,
        CombineModeXor	= ( CombineModeUnion + 1 ) ,
        CombineModeExclude	= ( CombineModeXor + 1 ) ,
        CombineModeComplement	= ( CombineModeExclude + 1 ) 
    } 	CombineMode;

typedef /* [v1_enum][helpstring] */ 
enum ImageType
    {
        ImageTypeUnknown	= 0,
        ImageTypeBitmap	= ( ImageTypeUnknown + 1 ) ,
        ImageTypeMetafile	= ( ImageTypeBitmap + 1 ) 
    } 	ImageType;

typedef /* [helpstring] */ ImageType GpImageType;

typedef /* [v1_enum][helpstring] */ 
enum InterpolationMode
    {
        InterpolationModeInvalid	= QualityModeInvalid,
        InterpolationModeDefault	= QualityModeDefault,
        InterpolationModeLowQuality	= QualityModeLow,
        InterpolationModeHighQuality	= QualityModeHigh,
        InterpolationModeBilinear	= ( InterpolationModeHighQuality + 1 ) ,
        InterpolationModeBicubic	= ( InterpolationModeBilinear + 1 ) ,
        InterpolationModeNearestNeighbor	= ( InterpolationModeBicubic + 1 ) ,
        InterpolationModeHighQualityBilinear	= ( InterpolationModeNearestNeighbor + 1 ) ,
        InterpolationModeHighQualityBicubic	= ( InterpolationModeHighQualityBilinear + 1 ) 
    } 	InterpolationMode;

typedef /* [v1_enum][helpstring] */ 
enum PenAlignment
    {
        PenAlignmentCenter	= 0,
        PenAlignmentInset	= 1
    } 	GpPenAlignment;

typedef /* [v1_enum][helpstring] */ 
enum BrushType
    {
        BrushTypeSolidColor	= 0,
        BrushTypeHatchFill	= 1,
        BrushTypeTextureFill	= 2,
        BrushTypePathGradient	= 3,
        BrushTypeLinearGradient	= 4
    } 	GpBrushType;

typedef /* [v1_enum][helpstring] */ 
enum PenType
    {
        PenTypeSolidColor	= BrushTypeSolidColor,
        PenTypeHatchFill	= BrushTypeHatchFill,
        PenTypeTextureFill	= BrushTypeTextureFill,
        PenTypePathGradient	= BrushTypePathGradient,
        PenTypeLinearGradient	= BrushTypeLinearGradient,
        PenTypeUnknown	= -1
    } 	GpPenType;

typedef /* [v1_enum][helpstring] */ 
enum MatrixOrder
    {
        MatrixOrderPrepend	= 0,
        MatrixOrderAppend	= 1
    } 	GpMatrixOrder;

typedef /* [v1_enum][helpstring] */ 
enum GenericFontFamily
    {
        GenericFontFamilySerif	= 0,
        GenericFontFamilySansSerif	= ( GenericFontFamilySerif + 1 ) ,
        GenericFontFamilyMonospace	= ( GenericFontFamilySansSerif + 1 ) 
    } 	GpGenericFontFamily;

typedef /* [v1_enum][helpstring] */ 
enum FontStyle
    {
        FontStyleRegular	= 0,
        FontStyleBold	= 1,
        FontStyleItalic	= 2,
        FontStyleBoldItalic	= 3,
        FontStyleUnderline	= 4,
        FontStyleStrikeout	= 8
    } 	FontStyle;

typedef /* [v1_enum][helpstring] */ 
enum SmoothingMode
    {
        SmoothingModeInvalid	= QualityModeInvalid,
        SmoothingModeDefault	= QualityModeDefault,
        SmoothingModeHighSpeed	= QualityModeLow,
        SmoothingModeHighQuality	= QualityModeHigh,
        SmoothingModeNone	= ( SmoothingModeHighQuality + 1 ) ,
        SmoothingModeAntiAlias	= ( SmoothingModeNone + 1 ) 
    } 	SmoothingMode;

typedef /* [v1_enum][helpstring] */ 
enum PixelOffsetMode
    {
        PixelOffsetModeInvalid	= QualityModeInvalid,
        PixelOffsetModeDefault	= QualityModeDefault,
        PixelOffsetModeHighSpeed	= QualityModeLow,
        PixelOffsetModeHighQuality	= QualityModeHigh,
        PixelOffsetModeNone	= ( PixelOffsetModeHighQuality + 1 ) ,
        PixelOffsetModeHalf	= ( PixelOffsetModeNone + 1 ) 
    } 	PixelOffsetMode;

typedef /* [v1_enum][helpstring] */ 
enum TextRenderingHint
    {
        TextRenderingHintSystemDefault	= 0,
        TextRenderingHintSingleBitPerPixelGridFit	= ( TextRenderingHintSystemDefault + 1 ) ,
        TextRenderingHintSingleBitPerPixel	= ( TextRenderingHintSingleBitPerPixelGridFit + 1 ) ,
        TextRenderingHintAntiAliasGridFit	= ( TextRenderingHintSingleBitPerPixel + 1 ) ,
        TextRenderingHintAntiAlias	= ( TextRenderingHintAntiAliasGridFit + 1 ) ,
        TextRenderingHintClearTypeGridFit	= ( TextRenderingHintAntiAlias + 1 ) 
    } 	TextRenderingHint;

typedef /* [v1_enum][helpstring] */ 
enum MetafileType
    {
        MetafileTypeInvalid	= 0,
        MetafileTypeWmf	= ( MetafileTypeInvalid + 1 ) ,
        MetafileTypeWmfPlaceable	= ( MetafileTypeWmf + 1 ) ,
        MetafileTypeEmf	= ( MetafileTypeWmfPlaceable + 1 ) ,
        MetafileTypeEmfPlusOnly	= ( MetafileTypeEmf + 1 ) ,
        MetafileTypeEmfPlusDual	= ( MetafileTypeEmfPlusOnly + 1 ) 
    } 	MetafileType;

typedef /* [v1_enum][helpstring] */ 
enum EmfType
    {
        EmfTypeEmfOnly	= MetafileTypeEmf,
        EmfTypeEmfPlusOnly	= MetafileTypeEmfPlusOnly,
        EmfTypeEmfPlusDual	= MetafileTypeEmfPlusDual
    } 	EmfType;

typedef /* [v1_enum][helpstring] */ 
enum ObjectType
    {
        ObjectTypeInvalid	= 0,
        ObjectTypeBrush	= ( ObjectTypeInvalid + 1 ) ,
        ObjectTypePen	= ( ObjectTypeBrush + 1 ) ,
        ObjectTypePath	= ( ObjectTypePen + 1 ) ,
        ObjectTypeRegion	= ( ObjectTypePath + 1 ) ,
        ObjectTypeImage	= ( ObjectTypeRegion + 1 ) ,
        ObjectTypeFont	= ( ObjectTypeImage + 1 ) ,
        ObjectTypeStringFormat	= ( ObjectTypeFont + 1 ) ,
        ObjectTypeImageAttributes	= ( ObjectTypeStringFormat + 1 ) ,
        ObjectTypeCustomLineCap	= ( ObjectTypeImageAttributes + 1 ) ,
        ObjectTypeMax	= ObjectTypeCustomLineCap,
        ObjectTypeMin	= ObjectTypeBrush
    } 	GpObjectType;


typedef /* [v1_enum][helpstring] */ 
enum EmfPlusRecordType
    {
        WmfRecordTypeSetBkColor	= ( 0x10000 + META_SETBKCOLOR ) ,
        WmfRecordTypeSetBkMode	= ( 0x10000 + META_SETBKMODE ) ,
        WmfRecordTypeSetMapMode	= ( 0x10000 + META_SETMAPMODE ) ,
        WmfRecordTypeSetROP2	= ( 0x10000 + META_SETROP2 ) ,
        WmfRecordTypeSetRelAbs	= ( 0x10000 + META_SETRELABS ) ,
        WmfRecordTypeSetPolyFillMode	= ( 0x10000 + META_SETPOLYFILLMODE ) ,
        WmfRecordTypeSetStretchBltMode	= ( 0x10000 + META_SETSTRETCHBLTMODE ) ,
        WmfRecordTypeSetTextCharExtra	= ( 0x10000 + META_SETTEXTCHAREXTRA ) ,
        WmfRecordTypeSetTextColor	= ( 0x10000 + META_SETTEXTCOLOR ) ,
        WmfRecordTypeSetTextJustification	= ( 0x10000 + META_SETTEXTJUSTIFICATION ) ,
        WmfRecordTypeSetWindowOrg	= ( 0x10000 + META_SETWINDOWORG ) ,
        WmfRecordTypeSetWindowExt	= ( 0x10000 + META_SETWINDOWEXT ) ,
        WmfRecordTypeSetViewportOrg	= ( 0x10000 + META_SETVIEWPORTORG ) ,
        WmfRecordTypeSetViewportExt	= ( 0x10000 + META_SETVIEWPORTEXT ) ,
        WmfRecordTypeOffsetWindowOrg	= ( 0x10000 + META_OFFSETWINDOWORG ) ,
        WmfRecordTypeScaleWindowExt	= ( 0x10000 + META_SCALEWINDOWEXT ) ,
        WmfRecordTypeOffsetViewportOrg	= ( 0x10000 + META_OFFSETVIEWPORTORG ) ,
        WmfRecordTypeScaleViewportExt	= ( 0x10000 + META_SCALEVIEWPORTEXT ) ,
        WmfRecordTypeLineTo	= ( 0x10000 + META_LINETO ) ,
        WmfRecordTypeMoveTo	= ( 0x10000 + META_MOVETO ) ,
        WmfRecordTypeExcludeClipRect	= ( 0x10000 + META_EXCLUDECLIPRECT ) ,
        WmfRecordTypeIntersectClipRect	= ( 0x10000 + META_INTERSECTCLIPRECT ) ,
        WmfRecordTypeArc	= ( 0x10000 + META_ARC ) ,
        WmfRecordTypeEllipse	= ( 0x10000 + META_ELLIPSE ) ,
        WmfRecordTypeFloodFill	= ( 0x10000 + META_FLOODFILL ) ,
        WmfRecordTypePie	= ( 0x10000 + META_PIE ) ,
        WmfRecordTypeRectangle	= ( 0x10000 + META_RECTANGLE ) ,
        WmfRecordTypeRoundRect	= ( 0x10000 + META_ROUNDRECT ) ,
        WmfRecordTypePatBlt	= ( 0x10000 + META_PATBLT ) ,
        WmfRecordTypeSaveDC	= ( 0x10000 + META_SAVEDC ) ,
        WmfRecordTypeSetPixel	= ( 0x10000 + META_SETPIXEL ) ,
        WmfRecordTypeOffsetClipRgn	= ( 0x10000 + META_OFFSETCLIPRGN ) ,
        WmfRecordTypeTextOut	= ( 0x10000 + META_TEXTOUT ) ,
        WmfRecordTypeBitBlt	= ( 0x10000 + META_BITBLT ) ,
        WmfRecordTypeStretchBlt	= ( 0x10000 + META_STRETCHBLT ) ,
        WmfRecordTypePolygon	= ( 0x10000 + META_POLYGON ) ,
        WmfRecordTypePolyline	= ( 0x10000 + META_POLYLINE ) ,
        WmfRecordTypeEscape	= ( 0x10000 + META_ESCAPE ) ,
        WmfRecordTypeRestoreDC	= ( 0x10000 + META_RESTOREDC ) ,
        WmfRecordTypeFillRegion	= ( 0x10000 + META_FILLREGION ) ,
        WmfRecordTypeFrameRegion	= ( 0x10000 + META_FRAMEREGION ) ,
        WmfRecordTypeInvertRegion	= ( 0x10000 + META_INVERTREGION ) ,
        WmfRecordTypePaintRegion	= ( 0x10000 + META_PAINTREGION ) ,
        WmfRecordTypeSelectClipRegion	= ( 0x10000 + META_SELECTCLIPREGION ) ,
        WmfRecordTypeSelectObject	= ( 0x10000 + META_SELECTOBJECT ) ,
        WmfRecordTypeSetTextAlign	= ( 0x10000 + META_SETTEXTALIGN ) ,
        WmfRecordTypeDrawText	= ( 0x10000 + 0x62f ) ,
        WmfRecordTypeChord	= ( 0x10000 + META_CHORD ) ,
        WmfRecordTypeSetMapperFlags	= ( 0x10000 + META_SETMAPPERFLAGS ) ,
        WmfRecordTypeExtTextOut	= ( 0x10000 + META_EXTTEXTOUT ) ,
        WmfRecordTypeSetDIBToDev	= ( 0x10000 + META_SETDIBTODEV ) ,
        WmfRecordTypeSelectPalette	= ( 0x10000 + META_SELECTPALETTE ) ,
        WmfRecordTypeRealizePalette	= ( 0x10000 + META_REALIZEPALETTE ) ,
        WmfRecordTypeAnimatePalette	= ( 0x10000 + META_ANIMATEPALETTE ) ,
        WmfRecordTypeSetPalEntries	= ( 0x10000 + META_SETPALENTRIES ) ,
        WmfRecordTypePolyPolygon	= ( 0x10000 + META_POLYPOLYGON ) ,
        WmfRecordTypeResizePalette	= ( 0x10000 + META_RESIZEPALETTE ) ,
        WmfRecordTypeDIBBitBlt	= ( 0x10000 + META_DIBBITBLT ) ,
        WmfRecordTypeDIBStretchBlt	= ( 0x10000 + META_DIBSTRETCHBLT ) ,
        WmfRecordTypeDIBCreatePatternBrush	= ( 0x10000 + META_DIBCREATEPATTERNBRUSH ) ,
        WmfRecordTypeStretchDIB	= ( 0x10000 + META_STRETCHDIB ) ,
        WmfRecordTypeExtFloodFill	= ( 0x10000 + META_EXTFLOODFILL ) ,
        WmfRecordTypeSetLayout	= ( 0x10000 + 0x149 ) ,
        WmfRecordTypeResetDC	= ( 0x10000 + 0x14c ) ,
        WmfRecordTypeStartDoc	= ( 0x10000 + 0x14d ) ,
        WmfRecordTypeStartPage	= ( 0x10000 + 0x4f ) ,
        WmfRecordTypeEndPage	= ( 0x10000 + 0x50 ) ,
        WmfRecordTypeAbortDoc	= ( 0x10000 + 0x52 ) ,
        WmfRecordTypeEndDoc	= ( 0x10000 + 0x5e ) ,
        WmfRecordTypeDeleteObject	= ( 0x10000 + META_DELETEOBJECT ) ,
        WmfRecordTypeCreatePalette	= ( 0x10000 + META_CREATEPALETTE ) ,
        WmfRecordTypeCreateBrush	= ( 0x10000 + 0xf8 ) ,
        WmfRecordTypeCreatePatternBrush	= ( 0x10000 + META_CREATEPATTERNBRUSH ) ,
        WmfRecordTypeCreatePenIndirect	= ( 0x10000 + META_CREATEPENINDIRECT ) ,
        WmfRecordTypeCreateFontIndirect	= ( 0x10000 + META_CREATEFONTINDIRECT ) ,
        WmfRecordTypeCreateBrushIndirect	= ( 0x10000 + META_CREATEBRUSHINDIRECT ) ,
        WmfRecordTypeCreateBitmapIndirect	= ( 0x10000 + 0x2fd ) ,
        WmfRecordTypeCreateBitmap	= ( 0x10000 + 0x6fe ) ,
        WmfRecordTypeCreateRegion	= ( 0x10000 + META_CREATEREGION ) ,
        EmfRecordTypeHeader	= EMR_HEADER,
        EmfRecordTypePolyBezier	= EMR_POLYBEZIER,
        EmfRecordTypePolygon	= EMR_POLYGON,
        EmfRecordTypePolyline	= EMR_POLYLINE,
        EmfRecordTypePolyBezierTo	= EMR_POLYBEZIERTO,
        EmfRecordTypePolyLineTo	= EMR_POLYLINETO,
        EmfRecordTypePolyPolyline	= EMR_POLYPOLYLINE,
        EmfRecordTypePolyPolygon	= EMR_POLYPOLYGON,
        EmfRecordTypeSetWindowExtEx	= EMR_SETWINDOWEXTEX,
        EmfRecordTypeSetWindowOrgEx	= EMR_SETWINDOWORGEX,
        EmfRecordTypeSetViewportExtEx	= EMR_SETVIEWPORTEXTEX,
        EmfRecordTypeSetViewportOrgEx	= EMR_SETVIEWPORTORGEX,
        EmfRecordTypeSetBrushOrgEx	= EMR_SETBRUSHORGEX,
        EmfRecordTypeEOF	= EMR_EOF,
        EmfRecordTypeSetPixelV	= EMR_SETPIXELV,
        EmfRecordTypeSetMapperFlags	= EMR_SETMAPPERFLAGS,
        EmfRecordTypeSetMapMode	= EMR_SETMAPMODE,
        EmfRecordTypeSetBkMode	= EMR_SETBKMODE,
        EmfRecordTypeSetPolyFillMode	= EMR_SETPOLYFILLMODE,
        EmfRecordTypeSetROP2	= EMR_SETROP2,
        EmfRecordTypeSetStretchBltMode	= EMR_SETSTRETCHBLTMODE,
        EmfRecordTypeSetTextAlign	= EMR_SETTEXTALIGN,
        EmfRecordTypeSetColorAdjustment	= EMR_SETCOLORADJUSTMENT,
        EmfRecordTypeSetTextColor	= EMR_SETTEXTCOLOR,
        EmfRecordTypeSetBkColor	= EMR_SETBKCOLOR,
        EmfRecordTypeOffsetClipRgn	= EMR_OFFSETCLIPRGN,
        EmfRecordTypeMoveToEx	= EMR_MOVETOEX,
        EmfRecordTypeSetMetaRgn	= EMR_SETMETARGN,
        EmfRecordTypeExcludeClipRect	= EMR_EXCLUDECLIPRECT,
        EmfRecordTypeIntersectClipRect	= EMR_INTERSECTCLIPRECT,
        EmfRecordTypeScaleViewportExtEx	= EMR_SCALEVIEWPORTEXTEX,
        EmfRecordTypeScaleWindowExtEx	= EMR_SCALEWINDOWEXTEX,
        EmfRecordTypeSaveDC	= EMR_SAVEDC,
        EmfRecordTypeRestoreDC	= EMR_RESTOREDC,
        EmfRecordTypeSetWorldTransform	= EMR_SETWORLDTRANSFORM,
        EmfRecordTypeModifyWorldTransform	= EMR_MODIFYWORLDTRANSFORM,
        EmfRecordTypeSelectObject	= EMR_SELECTOBJECT,
        EmfRecordTypeCreatePen	= EMR_CREATEPEN,
        EmfRecordTypeCreateBrushIndirect	= EMR_CREATEBRUSHINDIRECT,
        EmfRecordTypeDeleteObject	= EMR_DELETEOBJECT,
        EmfRecordTypeAngleArc	= EMR_ANGLEARC,
        EmfRecordTypeEllipse	= EMR_ELLIPSE,
        EmfRecordTypeRectangle	= EMR_RECTANGLE,
        EmfRecordTypeRoundRect	= EMR_ROUNDRECT,
        EmfRecordTypeArc	= EMR_ARC,
        EmfRecordTypeChord	= EMR_CHORD,
        EmfRecordTypePie	= EMR_PIE,
        EmfRecordTypeSelectPalette	= EMR_SELECTPALETTE,
        EmfRecordTypeCreatePalette	= EMR_CREATEPALETTE,
        EmfRecordTypeSetPaletteEntries	= EMR_SETPALETTEENTRIES,
        EmfRecordTypeResizePalette	= EMR_RESIZEPALETTE,
        EmfRecordTypeRealizePalette	= EMR_REALIZEPALETTE,
        EmfRecordTypeExtFloodFill	= EMR_EXTFLOODFILL,
        EmfRecordTypeLineTo	= EMR_LINETO,
        EmfRecordTypeArcTo	= EMR_ARCTO,
        EmfRecordTypePolyDraw	= EMR_POLYDRAW,
        EmfRecordTypeSetArcDirection	= EMR_SETARCDIRECTION,
        EmfRecordTypeSetMiterLimit	= EMR_SETMITERLIMIT,
        EmfRecordTypeBeginPath	= EMR_BEGINPATH,
        EmfRecordTypeEndPath	= EMR_ENDPATH,
        EmfRecordTypeCloseFigure	= EMR_CLOSEFIGURE,
        EmfRecordTypeFillPath	= EMR_FILLPATH,
        EmfRecordTypeStrokeAndFillPath	= EMR_STROKEANDFILLPATH,
        EmfRecordTypeStrokePath	= EMR_STROKEPATH,
        EmfRecordTypeFlattenPath	= EMR_FLATTENPATH,
        EmfRecordTypeWidenPath	= EMR_WIDENPATH,
        EmfRecordTypeSelectClipPath	= EMR_SELECTCLIPPATH,
        EmfRecordTypeAbortPath	= EMR_ABORTPATH,
        EmfRecordTypeReserved_069	= 69,
        EmfRecordTypeGdiComment	= EMR_GDICOMMENT,
        EmfRecordTypeFillRgn	= EMR_FILLRGN,
        EmfRecordTypeFrameRgn	= EMR_FRAMERGN,
        EmfRecordTypeInvertRgn	= EMR_INVERTRGN,
        EmfRecordTypePaintRgn	= EMR_PAINTRGN,
        EmfRecordTypeExtSelectClipRgn	= EMR_EXTSELECTCLIPRGN,
        EmfRecordTypeBitBlt	= EMR_BITBLT,
        EmfRecordTypeStretchBlt	= EMR_STRETCHBLT,
        EmfRecordTypeMaskBlt	= EMR_MASKBLT,
        EmfRecordTypePlgBlt	= EMR_PLGBLT,
        EmfRecordTypeSetDIBitsToDevice	= EMR_SETDIBITSTODEVICE,
        EmfRecordTypeStretchDIBits	= EMR_STRETCHDIBITS,
        EmfRecordTypeExtCreateFontIndirect	= EMR_EXTCREATEFONTINDIRECTW,
        EmfRecordTypeExtTextOutA	= EMR_EXTTEXTOUTA,
        EmfRecordTypeExtTextOutW	= EMR_EXTTEXTOUTW,
        EmfRecordTypePolyBezier16	= EMR_POLYBEZIER16,
        EmfRecordTypePolygon16	= EMR_POLYGON16,
        EmfRecordTypePolyline16	= EMR_POLYLINE16,
        EmfRecordTypePolyBezierTo16	= EMR_POLYBEZIERTO16,
        EmfRecordTypePolylineTo16	= EMR_POLYLINETO16,
        EmfRecordTypePolyPolyline16	= EMR_POLYPOLYLINE16,
        EmfRecordTypePolyPolygon16	= EMR_POLYPOLYGON16,
        EmfRecordTypePolyDraw16	= EMR_POLYDRAW16,
        EmfRecordTypeCreateMonoBrush	= EMR_CREATEMONOBRUSH,
        EmfRecordTypeCreateDIBPatternBrushPt	= EMR_CREATEDIBPATTERNBRUSHPT,
        EmfRecordTypeExtCreatePen	= EMR_EXTCREATEPEN,
        EmfRecordTypePolyTextOutA	= EMR_POLYTEXTOUTA,
        EmfRecordTypePolyTextOutW	= EMR_POLYTEXTOUTW,
        EmfRecordTypeSetICMMode	= 98,
        EmfRecordTypeCreateColorSpace	= 99,
        EmfRecordTypeSetColorSpace	= 100,
        EmfRecordTypeDeleteColorSpace	= 101,
        EmfRecordTypeGLSRecord	= 102,
        EmfRecordTypeGLSBoundedRecord	= 103,
        EmfRecordTypePixelFormat	= 104,
        EmfRecordTypeDrawEscape	= 105,
        EmfRecordTypeExtEscape	= 106,
        EmfRecordTypeStartDoc	= 107,
        EmfRecordTypeSmallTextOut	= 108,
        EmfRecordTypeForceUFIMapping	= 109,
        EmfRecordTypeNamedEscape	= 110,
        EmfRecordTypeColorCorrectPalette	= 111,
        EmfRecordTypeSetICMProfileA	= 112,
        EmfRecordTypeSetICMProfileW	= 113,
        EmfRecordTypeAlphaBlend	= 114,
        EmfRecordTypeSetLayout	= 115,
        EmfRecordTypeTransparentBlt	= 116,
        EmfRecordTypeReserved_117	= 117,
        EmfRecordTypeGradientFill	= 118,
        EmfRecordTypeSetLinkedUFIs	= 119,
        EmfRecordTypeSetTextJustification	= 120,
        EmfRecordTypeColorMatchToTargetW	= 121,
        EmfRecordTypeCreateColorSpaceW	= 122,
        EmfRecordTypeMax	= 122,
        EmfRecordTypeMin	= 1,
        EmfPlusRecordTypeInvalid	= 0x4000,
        EmfPlusRecordTypeHeader	= ( EmfPlusRecordTypeInvalid + 1 ) ,
        EmfPlusRecordTypeEndOfFile	= ( EmfPlusRecordTypeHeader + 1 ) ,
        EmfPlusRecordTypeComment	= ( EmfPlusRecordTypeEndOfFile + 1 ) ,
        EmfPlusRecordTypeGetDC	= ( EmfPlusRecordTypeComment + 1 ) ,
        EmfPlusRecordTypeMultiFormatStart	= ( EmfPlusRecordTypeGetDC + 1 ) ,
        EmfPlusRecordTypeMultiFormatSection	= ( EmfPlusRecordTypeMultiFormatStart + 1 ) ,
        EmfPlusRecordTypeMultiFormatEnd	= ( EmfPlusRecordTypeMultiFormatSection + 1 ) ,
        EmfPlusRecordTypeObject	= ( EmfPlusRecordTypeMultiFormatEnd + 1 ) ,
        EmfPlusRecordTypeClear	= ( EmfPlusRecordTypeObject + 1 ) ,
        EmfPlusRecordTypeFillRects	= ( EmfPlusRecordTypeClear + 1 ) ,
        EmfPlusRecordTypeDrawRects	= ( EmfPlusRecordTypeFillRects + 1 ) ,
        EmfPlusRecordTypeFillPolygon	= ( EmfPlusRecordTypeDrawRects + 1 ) ,
        EmfPlusRecordTypeDrawLines	= ( EmfPlusRecordTypeFillPolygon + 1 ) ,
        EmfPlusRecordTypeFillEllipse	= ( EmfPlusRecordTypeDrawLines + 1 ) ,
        EmfPlusRecordTypeDrawEllipse	= ( EmfPlusRecordTypeFillEllipse + 1 ) ,
        EmfPlusRecordTypeFillPie	= ( EmfPlusRecordTypeDrawEllipse + 1 ) ,
        EmfPlusRecordTypeDrawPie	= ( EmfPlusRecordTypeFillPie + 1 ) ,
        EmfPlusRecordTypeDrawArc	= ( EmfPlusRecordTypeDrawPie + 1 ) ,
        EmfPlusRecordTypeFillRegion	= ( EmfPlusRecordTypeDrawArc + 1 ) ,
        EmfPlusRecordTypeFillPath	= ( EmfPlusRecordTypeFillRegion + 1 ) ,
        EmfPlusRecordTypeDrawPath	= ( EmfPlusRecordTypeFillPath + 1 ) ,
        EmfPlusRecordTypeFillClosedCurve	= ( EmfPlusRecordTypeDrawPath + 1 ) ,
        EmfPlusRecordTypeDrawClosedCurve	= ( EmfPlusRecordTypeFillClosedCurve + 1 ) ,
        EmfPlusRecordTypeDrawCurve	= ( EmfPlusRecordTypeDrawClosedCurve + 1 ) ,
        EmfPlusRecordTypeDrawBeziers	= ( EmfPlusRecordTypeDrawCurve + 1 ) ,
        EmfPlusRecordTypeDrawImage	= ( EmfPlusRecordTypeDrawBeziers + 1 ) ,
        EmfPlusRecordTypeDrawImagePoints	= ( EmfPlusRecordTypeDrawImage + 1 ) ,
        EmfPlusRecordTypeDrawString	= ( EmfPlusRecordTypeDrawImagePoints + 1 ) ,
        EmfPlusRecordTypeSetRenderingOrigin	= ( EmfPlusRecordTypeDrawString + 1 ) ,
        EmfPlusRecordTypeSetAntiAliasMode	= ( EmfPlusRecordTypeSetRenderingOrigin + 1 ) ,
        EmfPlusRecordTypeSetTextRenderingHint	= ( EmfPlusRecordTypeSetAntiAliasMode + 1 ) ,
        EmfPlusRecordTypeSetTextContrast	= ( EmfPlusRecordTypeSetTextRenderingHint + 1 ) ,
        EmfPlusRecordTypeSetInterpolationMode	= ( EmfPlusRecordTypeSetTextContrast + 1 ) ,
        EmfPlusRecordTypeSetPixelOffsetMode	= ( EmfPlusRecordTypeSetInterpolationMode + 1 ) ,
        EmfPlusRecordTypeSetCompositingMode	= ( EmfPlusRecordTypeSetPixelOffsetMode + 1 ) ,
        EmfPlusRecordTypeSetCompositingQuality	= ( EmfPlusRecordTypeSetCompositingMode + 1 ) ,
        EmfPlusRecordTypeSave	= ( EmfPlusRecordTypeSetCompositingQuality + 1 ) ,
        EmfPlusRecordTypeRestore	= ( EmfPlusRecordTypeSave + 1 ) ,
        EmfPlusRecordTypeBeginContainer	= ( EmfPlusRecordTypeRestore + 1 ) ,
        EmfPlusRecordTypeBeginContainerNoParams	= ( EmfPlusRecordTypeBeginContainer + 1 ) ,
        EmfPlusRecordTypeEndContainer	= ( EmfPlusRecordTypeBeginContainerNoParams + 1 ) ,
        EmfPlusRecordTypeSetWorldTransform	= ( EmfPlusRecordTypeEndContainer + 1 ) ,
        EmfPlusRecordTypeResetWorldTransform	= ( EmfPlusRecordTypeSetWorldTransform + 1 ) ,
        EmfPlusRecordTypeMultiplyWorldTransform	= ( EmfPlusRecordTypeResetWorldTransform + 1 ) ,
        EmfPlusRecordTypeTranslateWorldTransform	= ( EmfPlusRecordTypeMultiplyWorldTransform + 1 ) ,
        EmfPlusRecordTypeScaleWorldTransform	= ( EmfPlusRecordTypeTranslateWorldTransform + 1 ) ,
        EmfPlusRecordTypeRotateWorldTransform	= ( EmfPlusRecordTypeScaleWorldTransform + 1 ) ,
        EmfPlusRecordTypeSetPageTransform	= ( EmfPlusRecordTypeRotateWorldTransform + 1 ) ,
        EmfPlusRecordTypeResetClip	= ( EmfPlusRecordTypeSetPageTransform + 1 ) ,
        EmfPlusRecordTypeSetClipRect	= ( EmfPlusRecordTypeResetClip + 1 ) ,
        EmfPlusRecordTypeSetClipPath	= ( EmfPlusRecordTypeSetClipRect + 1 ) ,
        EmfPlusRecordTypeSetClipRegion	= ( EmfPlusRecordTypeSetClipPath + 1 ) ,
        EmfPlusRecordTypeOffsetClip	= ( EmfPlusRecordTypeSetClipRegion + 1 ) ,
        EmfPlusRecordTypeDrawDriverString	= ( EmfPlusRecordTypeOffsetClip + 1 ) ,
        EmfPlusRecordTotal	= ( EmfPlusRecordTypeDrawDriverString + 1 ) ,
        EmfPlusRecordTypeMax	= ( EmfPlusRecordTotal - 1 ) ,
        EmfPlusRecordTypeMin	= EmfPlusRecordTypeHeader
    } 	EmfPlusRecordType;

typedef /* [v1_enum][helpstring] */ 
enum StringFormatFlags
    {
        StringFormatFlagsDirectionRightToLeft	= 0x1,
        StringFormatFlagsDirectionVertical	= 0x2,
        StringFormatFlagsNoFitBlackBox	= 0x4,
        StringFormatFlagsDisplayFormatControl	= 0x20,
        StringFormatFlagsNoFontFallback	= 0x400,
        StringFormatFlagsMeasureTrailingSpaces	= 0x800,
        StringFormatFlagsNoWrap	= 0x1000,
        StringFormatFlagsLineLimit	= 0x2000,
        StringFormatFlagsNoClip	= 0x4000
    } 	GpStringFormatFlags;

typedef /* [v1_enum][helpstring] */ 
enum StringTrimming
    {
        StringTrimmingNone	= 0,
        StringTrimmingCharacter	= 1,
        StringTrimmingWord	= 2,
        StringTrimmingEllipsisCharacter	= 3,
        StringTrimmingEllipsisWord	= 4,
        StringTrimmingEllipsisPath	= 5
    } 	StringTrimming;

typedef /* [v1_enum][helpstring] */ 
enum StringDigitSubstitute
    {
        StringDigitSubstituteUser	= 0,
        StringDigitSubstituteNone	= 1,
        StringDigitSubstituteNational	= 2,
        StringDigitSubstituteTraditional	= 3
    } 	StringDigitSubstitute;

typedef /* [v1_enum][helpstring] */ 
enum HotkeyPrefix
    {
        HotkeyPrefixNone	= 0,
        HotkeyPrefixShow	= 1,
        HotkeyPrefixHide	= 2
    } 	GpHotkeyPrefix;

typedef /* [v1_enum][helpstring] */ 
enum StringAlignment
    {
        StringAlignmentNear	= 0,
        StringAlignmentCenter	= 1,
        StringAlignmentFar	= 2
    } 	StringAlignment;

typedef /* [v1_enum][helpstring] */ 
enum DriverStringOptions
    {
        DriverStringOptionsCmapLookup	= 1,
        DriverStringOptionsVertical	= 2,
        DriverStringOptionsRealizedAdvance	= 4,
        DriverStringOptionsLimitSubpixel	= 8
    } 	GpDriverStringOptions;

typedef /* [v1_enum][helpstring] */ 
enum FlushIntention
    {
        FlushIntentionFlush	= 0,
        FlushIntentionSync	= 1
    } 	GpFlushIntention;

typedef /* [v1_enum][helpstring] */ 
enum EmfToWmfBitsFlags
    {
        EmfToWmfBitsFlagsDefault	= 0,
        EmfToWmfBitsFlagsEmbedEmf	= 0x1,
        EmfToWmfBitsFlagsIncludePlaceable	= 0x2,
        EmfToWmfBitsFlagsNoXORClip	= 0x4
    } 	GpEmfToWmfBitsFlags;

typedef /* [v1_enum][helpstring] */ 
enum GpTestControlEnum
    {
        TestControlForceBilinear	= 0,
        TestControlNoICM	= 1,
        TestControlGetBuildNumber	= 2
    } 	GpTestControlEnum;

typedef /* [helpstring] */ float REAL;

typedef /* [helpstring] */ ExternalHandle PGpBase;

typedef /* [helpstring] */ PGpBase PGpPath;

typedef /* [helpstring] */ PGpBase PGpFontFamily;

typedef /* [helpstring] */ PGpBase PGpStringFormat;

typedef /* [helpstring] */ PGpBase PGpMatrix;

typedef /* [helpstring] */ PGpBase PGpPen;

typedef /* [helpstring] */ PGpBase PGpGraphics;

typedef /* [helpstring] */ PGpBase PGpPathIterator;

typedef /* [helpstring] */ PGpBase PGpRegion;

typedef /* [helpstring] */ PGpBase PGpCustomLineCap;

typedef /* [helpstring] */ PGpCustomLineCap PGpAdjustableArrowCap;

typedef /* [helpstring] */ PGpBase PGpImage;

typedef /* [helpstring] */ PGpImage PGpBitmap;

typedef /* [helpstring] */ PGpBase PGpCachedBitmap;

typedef /* [helpstring] */ PGpImage PGpMetafile;

typedef /* [helpstring] */ PGpBase PGpImageAttributes;

typedef /* [helpstring] */ PGpBase PGpBrush;

typedef /* [helpstring] */ PGpBrush PGpTexture;

typedef /* [helpstring] */ PGpBrush PGpSolidFill;

typedef /* [helpstring] */ PGpBrush PGpLineGradient;

typedef /* [helpstring] */ PGpBrush PGpPathGradient;

typedef /* [helpstring] */ PGpBrush PGpHatch;

typedef /* [helpstring] */ PGpBase PGpFontCollection;

typedef /* [helpstring] */ PGpBase PGpFont;

typedef /* [helpstring] */ PGpBase PCGpEffect;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("c6f719de-eec5-45f6-bd44-71200f76bd34") struct POINTF
    {
    REAL x;
    REAL y;
    } 	POINTF;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("411A9CB7-6ABC-4F55-AA9A-82C7E0D44142") struct PathData
    {
    INT Count;
    /* [custom] */ POINTF *Points;
    /* [custom] */ BYTE *Types;
    } 	PathData;

typedef PathData GpPathData;

typedef POINTL GpPoint;

typedef POINTF GpPointF;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("9A449C4A-8AE9-45D9-B94D-1E1D91FEDCD5") struct RectF
    {
    REAL x;
    REAL y;
    REAL width;
    REAL height;
    } 	RectF;

typedef RectF GpRectF;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("6971c1a9-6a91-4a18-a526-2beac92d4746") struct Rect
    {
    LONG x;
    LONG y;
    LONG width;
    LONG height;
    } 	Rect;

typedef Rect GpRect;

typedef /* [helpstring] */ DWORD ARGB;

typedef /* [helpstring] */ DWORDLONG ARGB64;

typedef /* [v1_enum][helpstring] */ 
enum EncoderParameterValueType
    {
        EncoderParameterValueTypeByte	= 1,
        EncoderParameterValueTypeASCII	= 2,
        EncoderParameterValueTypeShort	= 3,
        EncoderParameterValueTypeLong	= 4,
        EncoderParameterValueTypeRational	= 5,
        EncoderParameterValueTypeLongRange	= 6,
        EncoderParameterValueTypeUndefined	= 7,
        EncoderParameterValueTypeRationalRange	= 8,
        EncoderParameterValueTypePointer	= 9
    } 	EncoderParameterValueType;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("D4CAA392-BA63-47EC-9AE5-093A1081A016") struct GpEncoderParameter
    {
    /* [helpstring] */ GUID Guid;
    /* [helpstring] */ ULONG NumberOfValues;
    /* [helpstring] */ EncoderParameterValueType Type;
    /* [helpstring] */ void *Value;
    } 	GpEncoderParameter;

typedef /* [public] */ GpEncoderParameter EncoderParameter;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("7AA7C3A4-85D9-4298-AD05-11C85D76C885") struct GpEncoderParameters
    {
    /* [helpstring] */ UINT Count;
    /* [helpstring] */ EncoderParameter Parameter[ 1 ];
    } 	GpEncoderParameters;

typedef /* [public] */ GpEncoderParameters EncoderParameters;


enum ItemDataPosition
    {
        ItemDataPositionAfterHeader	= 0,
        ItemDataPositionAfterPalette	= 0x1,
        ItemDataPositionAfterBits	= 0x2
    } ;
typedef /* [uuid][helpstring] */  DECLSPEC_UUID("8F94DA5E-28D8-4A70-93E8-FF94824E22D6") struct GpImageItemData
    {
    /* [helpstring] */ UINT Size;
    /* [helpstring] */ UINT Position;
    /* [helpstring] */ void *Desc;
    /* [helpstring] */ UINT DescSize;
    /* [helpstring] */ void *Data;
    /* [helpstring] */ UINT DataSize;
    /* [helpstring] */ UINT Cookie;
    } 	GpImageItemData;

typedef /* [public] */ GpImageItemData ImageItemData;

typedef /* [public] */ void *ImageAbort;

typedef /* [public] */ ImageAbort DrawImageAbort;

typedef /* [public] */ ImageAbort GetThumbnailImageAbort;

typedef /* [v1_enum][helpstring] */ 
enum PixelFormat
    {
        PixelFormatDontCare	= 0,
        PixelFormatIndexed	= 0x10000,
        PixelFormatGDI	= 0x20000,
        PixelFormatAlpha	= 0x40000,
        PixelFormatPAlpha	= 0x80000,
        PixelFormatExtended	= 0x100000,
        PixelFormatCanonical	= 0x200000,
        PixelFormat1bppIndexed	= 0x30101,
        PixelFormat4bppIndexed	= 0x30402,
        PixelFormat8bppIndexed	= 0x30803,
        PixelFormat16bppGrayScale	= 0x101004,
        PixelFormat16bppRGB555	= 0x21005,
        PixelFormat16bppRGB565	= 0x21006,
        PixelFormat16bppARGB1555	= 0x61007,
        PixelFormat24bppRGB	= 0x21808,
        PixelFormat32bppRGB	= 0x22009,
        PixelFormat32bppARGB	= 0x26200a,
        PixelFormat32bppPARGB	= 0xe200b,
        PixelFormat48bppRGB	= 0x10300c,
        PixelFormat64bppARGB	= 0x34400d,
        PixelFormat64bppPARGB	= 0x1c400e
    } 	PixelFormat;

typedef /* [v1_enum][public] */ 
enum RotateFlipType
    {
        RotateNoneFlipNone	= 0,
        Rotate90FlipNone	= 1,
        Rotate180FlipNone	= 2,
        Rotate270FlipNone	= 3,
        RotateNoneFlipX	= 4,
        Rotate90FlipX	= 5,
        Rotate180FlipX	= 6,
        Rotate270FlipX	= 7,
        RotateNoneFlipY	= Rotate180FlipX,
        Rotate90FlipY	= Rotate270FlipX,
        Rotate180FlipY	= RotateNoneFlipX,
        Rotate270FlipY	= Rotate90FlipX,
        RotateNoneFlipXY	= Rotate180FlipNone,
        Rotate90FlipXY	= Rotate270FlipNone,
        Rotate180FlipXY	= RotateNoneFlipNone,
        Rotate270FlipXY	= Rotate90FlipNone
    } 	RotateFlipType;

typedef /* [public] */ RotateFlipType GpRotateFlipType;

typedef /* [v1_enum][public] */ 
enum GpPaletteType
    {
        PaletteTypeCustom	= 0,
        PaletteTypeOptimal	= 1,
        PaletteTypeFixedBW	= 2,
        PaletteTypeFixedHalftone8	= 3,
        PaletteTypeFixedHalftone27	= 4,
        PaletteTypeFixedHalftone64	= 5,
        PaletteTypeFixedHalftone125	= 6,
        PaletteTypeFixedHalftone216	= 7,
        PaletteTypeFixedHalftone252	= 8,
        PaletteTypeFixedHalftone256	= 9
    } 	GpPaletteType;

typedef /* [public] */ GpPaletteType PaletteType;

typedef /* [v1_enum][public] */ 
enum GpDitherType
    {
        DitherTypeNone	= 0,
        DitherTypeSolid	= 1,
        DitherTypeOrdered4x4	= 2,
        DitherTypeOrdered8x8	= 3,
        DitherTypeOrdered16x16	= 4,
        DitherTypeSpiral4x4	= 5,
        DitherTypeSpiral8x8	= 6,
        DitherTypeDualSpiral4x4	= 7,
        DitherTypeDualSpiral8x8	= 8,
        DitherTypeErrorDiffusion	= 9,
        DitherTypeMax	= 10
    } 	GpDitherType;

typedef /* [public] */ GpDitherType DitherType;

typedef /* [v1_enum][public] */ 
enum PaletteFlags
    {
        PaletteFlagsHasAlpha	= 0x1,
        PaletteFlagsGrayScale	= 0x2,
        PaletteFlagsHalftone	= 0x4
    } 	GpPaletteFlags;

typedef /* [uuid][public] */  DECLSPEC_UUID("585419F2-D5AB-4E85-BF56-56D115CBE7B2") struct ColorPalette
    {
    /* [helpstring] */ UINT Flags;
    /* [helpstring] */ UINT Count;
    /* [custom] */ ARGB Entries[ 1 ];
    } 	ColorPalette;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("DAD9CD42-C61C-4040-BCD2-2F2E8D725FCA") struct GpPropertyItem
    {
    /* [helpstring] */ PROPID id;
    /* [helpstring] */ ULONG length;
    /* [helpstring] */ WORD type;
    /* [helpstring] */ void *value;
    } 	GpPropertyItem;

typedef /* [public] */ GpPropertyItem PropertyItem;

typedef /* [helpstring] */ void *IDirectDrawSurface7;

typedef /* [public] */ void BITMAPINFO;

typedef /* [public] */ unsigned int UINT_PTR;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("8B358D63-CEC7-4AE5-87C2-72D86F11E109") struct BitmapData
    {
    UINT Width;
    UINT Height;
    INT Stride;
    PixelFormat PixelFormat;
    void *Scan0;
    UINT_PTR Reserved;
    } 	BitmapData;

typedef /* [v1_enum][helpstring] */ 
enum HistogramFormat
    {
        HistogramFormatARGB	= 0,
        HistogramFormatPARGB	= ( HistogramFormatARGB + 1 ) ,
        HistogramFormatRGB	= ( HistogramFormatPARGB + 1 ) ,
        HistogramFormatGray	= ( HistogramFormatRGB + 1 ) ,
        HistogramFormatB	= ( HistogramFormatGray + 1 ) ,
        HistogramFormatG	= ( HistogramFormatB + 1 ) ,
        HistogramFormatR	= ( HistogramFormatG + 1 ) ,
        HistogramFormatA	= ( HistogramFormatR + 1 ) 
    } 	HistogramFormat;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("6B5AB37E-5CC3-447E-99EF-9135F516CCC0") struct ColorMatrix
    {
    REAL m[ 5 ][ 5 ];
    } 	ColorMatrix;

typedef /* [v1_enum][helpstring] */ 
enum ColorMatrixFlags
    {
        ColorMatrixFlagsDefault	= 0,
        ColorMatrixFlagsSkipGrays	= 1,
        ColorMatrixFlagsAltGray	= 2
    } 	ColorMatrixFlags;

typedef /* [v1_enum][helpstring] */ 
enum ColorAdjustType
    {
        ColorAdjustTypeDefault	= 0,
        ColorAdjustTypeBitmap	= ( ColorAdjustTypeDefault + 1 ) ,
        ColorAdjustTypeBrush	= ( ColorAdjustTypeBitmap + 1 ) ,
        ColorAdjustTypePen	= ( ColorAdjustTypeBrush + 1 ) ,
        ColorAdjustTypeText	= ( ColorAdjustTypePen + 1 ) ,
        ColorAdjustTypeCount	= ( ColorAdjustTypeText + 1 ) ,
        ColorAdjustTypeAny	= ( ColorAdjustTypeCount + 1 ) 
    } 	ColorAdjustType;

typedef /* [public] */ ARGB Color;

typedef /* [v1_enum][helpstring] */ 
enum ColorMode
    {
        ColorModeARGB32	= 0,
        ColorModeARGB64	= 1
    } 	ColorMode;

typedef /* [v1_enum][helpstring] */ 
enum ColorChannelFlags
    {
        ColorChannelFlagsC	= 0,
        ColorChannelFlagsM	= ( ColorChannelFlagsC + 1 ) ,
        ColorChannelFlagsY	= ( ColorChannelFlagsM + 1 ) ,
        ColorChannelFlagsK	= ( ColorChannelFlagsY + 1 ) ,
        ColorChannelFlagsLast	= ( ColorChannelFlagsK + 1 ) 
    } 	ColorChannelFlags;

typedef /* [uuid] */  DECLSPEC_UUID("16B02CC4-3683-4FDC-8BDC-C450EF3137B2") struct ColorMap
    {
    Color oldColor;
    Color newColor;
    } 	ColorMap;

typedef /* [helpstring] */ void *EnumerateMetafileProc;

typedef /* [helpstring] */ void *GdiplusAbort;

typedef /* [helpstring] */ short INT16;

typedef /* [uuid][public] */  DECLSPEC_UUID("1713CA90-9E3E-465B-9C3D-3C7B201F00EE") struct WMFRect16
    {
    INT16 Left;
    INT16 Top;
    INT16 Right;
    INT16 Bottom;
    } 	WMFRect16;

typedef /* [helpstring] */ DWORD UINT32;

typedef /* [uuid][public] */  DECLSPEC_UUID("E244EDF0-9096-42DD-944D-3BE54248689F") struct WmfPlaceableFileHeader
    {
    /* [helpstring] */ UINT32 Key;
    /* [helpstring] */ INT16 Hmf;
    /* [helpstring] */ WMFRect16 BoundingBox;
    /* [helpstring] */ INT16 Inch;
    /* [helpstring] */ UINT32 Reserved;
    /* [helpstring] */ INT16 Checksum;
    } 	WmfPlaceableFileHeader;

typedef /* [uuid][public] */  DECLSPEC_UUID("0252C31A-1D28-4418-90FA-3243AFF6DE01") struct METAHEADER
    {
    WORD mtType;
    WORD mtHeaderSize;
    WORD mtVersion;
    DWORD mtSize;
    WORD mtNoObjects;
    DWORD mtMaxRecord;
    WORD mtNoParameters;
    } 	METAHEADER;

typedef /* [uuid][public] */  DECLSPEC_UUID("1B5C3DCF-8EA0-47DF-B752-442DD272A353") struct ENHMETAHEADER3
    {
    /* [helpstring] */ DWORD iType;
    /* [helpstring] */ DWORD nSize;
    /* [helpstring] */ RECTL rclBounds;
    /* [helpstring] */ RECTL rclFrame;
    /* [helpstring] */ DWORD dSignature;
    /* [helpstring] */ DWORD nVersion;
    /* [helpstring] */ DWORD nBytes;
    /* [helpstring] */ DWORD nRecords;
    /* [helpstring] */ WORD nHandles;
    /* [helpstring] */ WORD sReserved;
    /* [helpstring] */ DWORD nDescription;
    /* [helpstring] */ DWORD offDescription;
    /* [helpstring] */ DWORD nPalEntries;
    /* [helpstring] */ SIZEL szlDevice;
    /* [helpstring] */ SIZEL szlMillimeters;
    } 	ENHMETAHEADER3;

typedef /* [uuid][public] */  DECLSPEC_UUID("83583420-DBFC-415F-AB1B-93E52A2206EF") struct MetafileHeader
    {
    MetafileType type;
    /* [helpstring] */ UINT size;
    /* [helpstring] */ UINT version;
    UINT EmfPlusFlags;
    REAL DpiX;
    REAL DpiY;
    /* [helpstring] */ INT X;
    INT Y;
    INT Width;
    INT Height;
    union 
        {
        METAHEADER WmfHeader;
        ENHMETAHEADER3 EmfHeader;
        } 	;
    /* [helpstring] */ INT EmfPlusHeaderSize;
    /* [helpstring] */ INT LogicalDpiX;
    /* [helpstring] */ INT LogicalDpiY;
    } 	MetafileHeader;

typedef /* [uuid] */  DECLSPEC_UUID("059E6E3A-2877-4EA7-A11C-7E5C1AC62165") struct ImageCodecInfo
    {
    CLSID Clsid;
    GUID FormatID;
    LPCOLESTR CodecName;
    LPCOLESTR DllName;
    LPCOLESTR FormatDescription;
    LPCOLESTR FilenameExtension;
    LPCOLESTR MimeType;
    DWORD Flags;
    DWORD Version;
    DWORD SigCount;
    DWORD SigSize;
    const BYTE *SigPattern;
    const BYTE *SigMask;
    } 	ImageCodecInfo;

typedef /* [helpstring] */ unsigned short UINT16;

typedef /* [uuid] */  DECLSPEC_UUID("87B4C5F9-026E-11D3-9FD7-00A0CC3E4A32") struct LOGFONT
    {
    LONG lfHeight;
    LONG lfWidth;
    LONG lfEscapement;
    LONG lfOrientation;
    LONG lfWeight;
    BYTE lfItalic;
    BYTE lfUnderline;
    BYTE lfStrikeOut;
    BYTE lfCharSet;
    BYTE lfOutPrecision;
    BYTE lfClipPrecision;
    BYTE lfQuality;
    BYTE lfPitchAndFamily;
    CHAR lfFaceName[ 32 ];
    } 	LOGFONT;

typedef /* [public] */ LOGFONT LOGFONTA;

typedef /* [uuid] */  DECLSPEC_UUID("37140088-772d-4f72-aac2-27311f7805d8") struct LOGFONTW
    {
    LONG lfHeight;
    LONG lfWidth;
    LONG lfEscapement;
    LONG lfOrientation;
    LONG lfWeight;
    BYTE lfItalic;
    BYTE lfUnderline;
    BYTE lfStrikeOut;
    BYTE lfCharSet;
    BYTE lfOutPrecision;
    BYTE lfClipPrecision;
    BYTE lfQuality;
    BYTE lfPitchAndFamily;
    WCHAR lfFaceName[ 32 ];
    } 	LOGFONTW;

typedef /* [helpstring] */ WORD LANGID;

typedef /* [uuid][public] */  DECLSPEC_UUID("01079D38-5861-45B6-8DE5-D2165B5DE26B") struct CharacterRange
    {
    INT First;
    INT Length;
    } 	CharacterRange;

typedef /* [public] */ void *DebugEventProc;

typedef /* [uuid][public] */  DECLSPEC_UUID("0CB202B5-B002-428D-8A31-F44D2919CB02") struct GdiplusStartupInput
    {
    /* [helpstring] */ UINT32 GdiplusVersion;
    /* [helpstring] */ DebugEventProc DebugEventCallback;
    /* [helpstring] */ BOOL SuppressBackgroundThread;
    /* [helpstring] */ BOOL SuppressExternalCodecs;
    } 	GdiplusStartupInput;

typedef /* [public] */ void *NotificationHookProc;

typedef /* [public] */ void *NotificationUnhookProc;

typedef /* [uuid][helpstring] */  DECLSPEC_UUID("40BB7E65-CD3B-49AA-B850-F404C6D944FC") struct GdiplusStartupOutput
    {
    /* [helpstring] */ NotificationHookProc NotificationHook;
    /* [helpstring] */ NotificationUnhookProc NotificationUnhook;
    } 	GdiplusStartupOutput;

typedef /* [v1_enum][helpstring] */ 
enum PropertyTagType
    {
        PropertyTagTypeByte	= 1,
        PropertyTagTypeASCII	= 2,
        PropertyTagTypeShort	= 3,
        PropertyTagTypeLong	= 4,
        PropertyTagTypeRational	= 5,
        PropertyTagTypeUndefined	= 7,
        PropertyTagTypeSLONG	= 9,
        PropertyTagTypeSRational	= 10
    } 	PropertyTagType;

typedef /* [v1_enum][helpstring] */ 
enum PropertyTag
    {
        PropertyTagExifIFD	= 0x8769,
        PropertyTagGpsIFD	= 0x8825,
        PropertyTagNewSubfileType	= 0xfe,
        PropertyTagSubfileType	= 0xff,
        PropertyTagImageWidth	= 0x100,
        PropertyTagImageHeight	= 0x101,
        PropertyTagBitsPerSample	= 0x102,
        PropertyTagCompression	= 0x103,
        PropertyTagPhotometricInterp	= 0x106,
        PropertyTagThreshHolding	= 0x107,
        PropertyTagCellWidth	= 0x108,
        PropertyTagCellHeight	= 0x109,
        PropertyTagFillOrder	= 0x10a,
        PropertyTagDocumentName	= 0x10d,
        PropertyTagImageDescription	= 0x10e,
        PropertyTagEquipMake	= 0x10f,
        PropertyTagEquipModel	= 0x110,
        PropertyTagStripOffsets	= 0x111,
        PropertyTagOrientation	= 0x112,
        PropertyTagSamplesPerPixel	= 0x115,
        PropertyTagRowsPerStrip	= 0x116,
        PropertyTagStripBytesCount	= 0x117,
        PropertyTagMinSampleValue	= 0x118,
        PropertyTagMaxSampleValue	= 0x119,
        PropertyTagXResolution	= 0x11a,
        PropertyTagYResolution	= 0x11b,
        PropertyTagPlanarConfig	= 0x11c,
        PropertyTagPageName	= 0x11d,
        PropertyTagXPosition	= 0x11e,
        PropertyTagYPosition	= 0x11f,
        PropertyTagFreeOffset	= 0x120,
        PropertyTagFreeByteCounts	= 0x121,
        PropertyTagGrayResponseUnit	= 0x122,
        PropertyTagGrayResponseCurve	= 0x123,
        PropertyTagT4Option	= 0x124,
        PropertyTagT6Option	= 0x125,
        PropertyTagResolutionUnit	= 0x128,
        PropertyTagPageNumber	= 0x129,
        PropertyTagTransferFuncition	= 0x12d,
        PropertyTagSoftwareUsed	= 0x131,
        PropertyTagDateTime	= 0x132,
        PropertyTagArtist	= 0x13b,
        PropertyTagHostComputer	= 0x13c,
        PropertyTagPredictor	= 0x13d,
        PropertyTagWhitePoint	= 0x13e,
        PropertyTagPrimaryChromaticities	= 0x13f,
        PropertyTagColorMap	= 0x140,
        PropertyTagHalftoneHints	= 0x141,
        PropertyTagTileWidth	= 0x142,
        PropertyTagTileLength	= 0x143,
        PropertyTagTileOffset	= 0x144,
        PropertyTagTileByteCounts	= 0x145,
        PropertyTagInkSet	= 0x14c,
        PropertyTagInkNames	= 0x14d,
        PropertyTagNumberOfInks	= 0x14e,
        PropertyTagDotRange	= 0x150,
        PropertyTagTargetPrinter	= 0x151,
        PropertyTagExtraSamples	= 0x152,
        PropertyTagSampleFormat	= 0x153,
        PropertyTagSMinSampleValue	= 0x154,
        PropertyTagSMaxSampleValue	= 0x155,
        PropertyTagTransferRange	= 0x156,
        PropertyTagJPEGProc	= 0x200,
        PropertyTagJPEGInterFormat	= 0x201,
        PropertyTagJPEGInterLength	= 0x202,
        PropertyTagJPEGRestartInterval	= 0x203,
        PropertyTagJPEGLosslessPredictors	= 0x205,
        PropertyTagJPEGPointTransforms	= 0x206,
        PropertyTagJPEGQTables	= 0x207,
        PropertyTagJPEGDCTables	= 0x208,
        PropertyTagJPEGACTables	= 0x209,
        PropertyTagYCbCrCoefficients	= 0x211,
        PropertyTagYCbCrSubsampling	= 0x212,
        PropertyTagYCbCrPositioning	= 0x213,
        PropertyTagREFBlackWhite	= 0x214,
        PropertyTagICCProfile	= 0x8773,
        PropertyTagGamma	= 0x301,
        PropertyTagICCProfileDescriptor	= 0x302,
        PropertyTagSRGBRenderingIntent	= 0x303,
        PropertyTagImageTitle	= 0x320,
        PropertyTagCopyright	= 0x8298,
        PropertyTagResolutionXUnit	= 0x5001,
        PropertyTagResolutionYUnit	= 0x5002,
        PropertyTagResolutionXLengthUnit	= 0x5003,
        PropertyTagResolutionYLengthUnit	= 0x5004,
        PropertyTagPrintFlags	= 0x5005,
        PropertyTagPrintFlagsVersion	= 0x5006,
        PropertyTagPrintFlagsCrop	= 0x5007,
        PropertyTagPrintFlagsBleedWidth	= 0x5008,
        PropertyTagPrintFlagsBleedWidthScale	= 0x5009,
        PropertyTagHalftoneLPI	= 0x500a,
        PropertyTagHalftoneLPIUnit	= 0x500b,
        PropertyTagHalftoneDegree	= 0x500c,
        PropertyTagHalftoneShape	= 0x500d,
        PropertyTagHalftoneMisc	= 0x500e,
        PropertyTagHalftoneScreen	= 0x500f,
        PropertyTagJPEGQuality	= 0x5010,
        PropertyTagGridSize	= 0x5011,
        PropertyTagThumbnailFormat	= 0x5012,
        PropertyTagThumbnailWidth	= 0x5013,
        PropertyTagThumbnailHeight	= 0x5014,
        PropertyTagThumbnailColorDepth	= 0x5015,
        PropertyTagThumbnailPlanes	= 0x5016,
        PropertyTagThumbnailRawBytes	= 0x5017,
        PropertyTagThumbnailSize	= 0x5018,
        PropertyTagThumbnailCompressedSize	= 0x5019,
        PropertyTagColorTransferFunction	= 0x501a,
        PropertyTagThumbnailData	= 0x501b,
        PropertyTagThumbnailImageWidth	= 0x5020,
        PropertyTagThumbnailImageHeight	= 0x5021,
        PropertyTagThumbnailBitsPerSample	= 0x5022,
        PropertyTagThumbnailCompression	= 0x5023,
        PropertyTagThumbnailPhotometricInterp	= 0x5024,
        PropertyTagThumbnailImageDescription	= 0x5025,
        PropertyTagThumbnailEquipMake	= 0x5026,
        PropertyTagThumbnailEquipModel	= 0x5027,
        PropertyTagThumbnailStripOffsets	= 0x5028,
        PropertyTagThumbnailOrientation	= 0x5029,
        PropertyTagThumbnailSamplesPerPixel	= 0x502a,
        PropertyTagThumbnailRowsPerStrip	= 0x502b,
        PropertyTagThumbnailStripBytesCount	= 0x502c,
        PropertyTagThumbnailResolutionX	= 0x502d,
        PropertyTagThumbnailResolutionY	= 0x502e,
        PropertyTagThumbnailPlanarConfig	= 0x502f,
        PropertyTagThumbnailResolutionUnit	= 0x5030,
        PropertyTagThumbnailTransferFunction	= 0x5031,
        PropertyTagThumbnailSoftwareUsed	= 0x5032,
        PropertyTagThumbnailDateTime	= 0x5033,
        PropertyTagThumbnailArtist	= 0x5034,
        PropertyTagThumbnailWhitePoint	= 0x5035,
        PropertyTagThumbnailPrimaryChromaticities	= 0x5036,
        PropertyTagThumbnailYCbCrCoefficients	= 0x5037,
        PropertyTagThumbnailYCbCrSubsampling	= 0x5038,
        PropertyTagThumbnailYCbCrPositioning	= 0x5039,
        PropertyTagThumbnailRefBlackWhite	= 0x503a,
        PropertyTagThumbnailCopyRight	= 0x503b,
        PropertyTagLuminanceTable	= 0x5090,
        PropertyTagChrominanceTable	= 0x5091,
        PropertyTagFrameDelay	= 0x5100,
        PropertyTagLoopCount	= 0x5101,
        PropertyTagPixelUnit	= 0x5110,
        PropertyTagPixelPerUnitX	= 0x5111,
        PropertyTagPixelPerUnitY	= 0x5112,
        PropertyTagPaletteHistogram	= 0x5113,
        PropertyTagExifExposureTime	= 0x829a,
        PropertyTagExifFNumber	= 0x829d,
        PropertyTagExifExposureProg	= 0x8822,
        PropertyTagExifSpectralSense	= 0x8824,
        PropertyTagExifISOSpeed	= 0x8827,
        PropertyTagExifOECF	= 0x8828,
        PropertyTagExifVer	= 0x9000,
        PropertyTagExifDTOrig	= 0x9003,
        PropertyTagExifDTDigitized	= 0x9004,
        PropertyTagExifCompConfig	= 0x9101,
        PropertyTagExifCompBPP	= 0x9102,
        PropertyTagExifShutterSpeed	= 0x9201,
        PropertyTagExifAperture	= 0x9202,
        PropertyTagExifBrightness	= 0x9203,
        PropertyTagExifExposureBias	= 0x9204,
        PropertyTagExifMaxAperture	= 0x9205,
        PropertyTagExifSubjectDist	= 0x9206,
        PropertyTagExifMeteringMode	= 0x9207,
        PropertyTagExifLightSource	= 0x9208,
        PropertyTagExifFlash	= 0x9209,
        PropertyTagExifFocalLength	= 0x920a,
        PropertyTagExifMakerNote	= 0x927c,
        PropertyTagExifUserComment	= 0x9286,
        PropertyTagExifDTSubsec	= 0x9290,
        PropertyTagExifDTOrigSS	= 0x9291,
        PropertyTagExifDTDigSS	= 0x9292,
        PropertyTagExifFPXVer	= 0xa000,
        PropertyTagExifColorSpace	= 0xa001,
        PropertyTagExifPixXDim	= 0xa002,
        PropertyTagExifPixYDim	= 0xa003,
        PropertyTagExifRelatedWav	= 0xa004,
        PropertyTagExifInterop	= 0xa005,
        PropertyTagExifFlashEnergy	= 0xa20b,
        PropertyTagExifSpatialFR	= 0xa20c,
        PropertyTagExifFocalXRes	= 0xa20e,
        PropertyTagExifFocalYRes	= 0xa20f,
        PropertyTagExifFocalResUnit	= 0xa210,
        PropertyTagExifSubjectLoc	= 0xa214,
        PropertyTagExifExposureIndex	= 0xa215,
        PropertyTagExifSensingMethod	= 0xa217,
        PropertyTagExifFileSource	= 0xa300,
        PropertyTagExifSceneType	= 0xa301,
        PropertyTagExifCfaPattern	= 0xa302,
        PropertyTagGpsVer	= 0,
        PropertyTagGpsLatitudeRef	= 0x1,
        PropertyTagGpsLatitude	= 0x2,
        PropertyTagGpsLongitudeRef	= 0x3,
        PropertyTagGpsLongitude	= 0x4,
        PropertyTagGpsAltitudeRef	= 0x5,
        PropertyTagGpsAltitude	= 0x6,
        PropertyTagGpsGpsTime	= 0x7,
        PropertyTagGpsGpsSatellites	= 0x8,
        PropertyTagGpsGpsStatus	= 0x9,
        PropertyTagGpsGpsMeasureMode	= 0xa,
        PropertyTagGpsGpsDop	= 0xb,
        PropertyTagGpsSpeedRef	= 0xc,
        PropertyTagGpsSpeed	= 0xd,
        PropertyTagGpsTrackRef	= 0xe,
        PropertyTagGpsTrack	= 0xf,
        PropertyTagGpsImgDirRef	= 0x10,
        PropertyTagGpsImgDir	= 0x11,
        PropertyTagGpsMapDatum	= 0x12,
        PropertyTagGpsDestLatRef	= 0x13,
        PropertyTagGpsDestLat	= 0x14,
        PropertyTagGpsDestLongRef	= 0x15,
        PropertyTagGpsDestLong	= 0x16,
        PropertyTagGpsDestBearRef	= 0x17,
        PropertyTagGpsDestBear	= 0x18,
        PropertyTagGpsDestDistRef	= 0x19,
        PropertyTagGpsDestDist	= 0x1a
    } 	PropertyTag;

typedef /* [v1_enum][helpstring] */ 
enum EncoderValue
    {
        EncoderValueColorTypeCMYK	= 0,
        EncoderValueColorTypeYCCK	= ( EncoderValueColorTypeCMYK + 1 ) ,
        EncoderValueCompressionLZW	= ( EncoderValueColorTypeYCCK + 1 ) ,
        EncoderValueCompressionCCITT3	= ( EncoderValueCompressionLZW + 1 ) ,
        EncoderValueCompressionCCITT4	= ( EncoderValueCompressionCCITT3 + 1 ) ,
        EncoderValueCompressionRle	= ( EncoderValueCompressionCCITT4 + 1 ) ,
        EncoderValueCompressionNone	= ( EncoderValueCompressionRle + 1 ) ,
        EncoderValueScanMethodInterlaced	= ( EncoderValueCompressionNone + 1 ) ,
        EncoderValueScanMethodNonInterlaced	= ( EncoderValueScanMethodInterlaced + 1 ) ,
        EncoderValueVersionGif87	= ( EncoderValueScanMethodNonInterlaced + 1 ) ,
        EncoderValueVersionGif89	= ( EncoderValueVersionGif87 + 1 ) ,
        EncoderValueRenderProgressive	= ( EncoderValueVersionGif89 + 1 ) ,
        EncoderValueRenderNonProgressive	= ( EncoderValueRenderProgressive + 1 ) ,
        EncoderValueTransformRotate90	= ( EncoderValueRenderNonProgressive + 1 ) ,
        EncoderValueTransformRotate180	= ( EncoderValueTransformRotate90 + 1 ) ,
        EncoderValueTransformRotate270	= ( EncoderValueTransformRotate180 + 1 ) ,
        EncoderValueTransformFlipHorizontal	= ( EncoderValueTransformRotate270 + 1 ) ,
        EncoderValueTransformFlipVertical	= ( EncoderValueTransformFlipHorizontal + 1 ) ,
        EncoderValueMultiFrame	= ( EncoderValueTransformFlipVertical + 1 ) ,
        EncoderValueLastFrame	= ( EncoderValueMultiFrame + 1 ) ,
        EncoderValueFlush	= ( EncoderValueLastFrame + 1 ) ,
        EncoderValueFrameDimensionTime	= ( EncoderValueFlush + 1 ) ,
        EncoderValueFrameDimensionResolution	= ( EncoderValueFrameDimensionTime + 1 ) ,
        EncoderValueFrameDimensionPage	= ( EncoderValueFrameDimensionResolution + 1 ) 
    } 	EncoderValue;

typedef /* [v1_enum][helpstring] */ 
enum ImageFlags
    {
        ImageFlagsNone	= 0,
        ImageFlagsScalable	= 0x1,
        ImageFlagsHasAlpha	= 0x2,
        ImageFlagsHasTranslucent	= 0x4,
        ImageFlagsPartiallyScalable	= 0x8,
        ImageFlagsColorSpaceRGB	= 0x10,
        ImageFlagsColorSpaceCMYK	= 0x20,
        ImageFlagsColorSpaceGRAY	= 0x40,
        ImageFlagsColorSpaceYCBCR	= 0x80,
        ImageFlagsColorSpaceYCCK	= 0x100,
        ImageFlagsHasRealDPI	= 0x1000,
        ImageFlagsHasRealPixelSize	= 0x2000,
        ImageFlagsReadOnly	= 0x10000,
        ImageFlagsCaching	= 0x20000
    } 	ImageFlags;


EXTERN_C const IID LIBID_Gdiplus;


#ifndef __Gdiplus_MODULE_DEFINED__
#define __Gdiplus_MODULE_DEFINED__


/* module Gdiplus */
/* [helpstring][uuid][dllname] */ 

const int PixelFormatUndefined	=	0;

const int PixelFormatMax	=	15;

/* [helpstring] */ const float FlatnessDefault	=	( 1 / 4 ) ;

/* [custom][entry] */ GpStatus __stdcall GdipCreatePath( 
    GpFillMode brushMode,
    /* [retval][out] */ PGpPath *path);

/* [custom][entry] */ GpStatus __stdcall GdipCreatePath2( 
    /* [in] */ const GpPointF *points,
    /* [in] */ const BYTE *types,
    INT count,
    GpFillMode fillMode,
    /* [retval][out] */ PGpPath *path);

/* [custom][entry] */ GpStatus __stdcall GdipCreatePath2I( 
    /* [in] */ const GpPoint *points,
    /* [in] */ const BYTE *types,
    INT count,
    GpFillMode fillMode,
    /* [retval][out] */ PGpPath *path);

/* [custom][entry] */ GpStatus __stdcall GdipClonePath( 
    PGpPath path,
    /* [retval][out] */ PGpPath *clonePath);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeletePath( 
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipResetPath( 
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipGetPointCount( 
    PGpPath path,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathTypes( 
    PGpPath path,
    BYTE *types,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathPoints( 
    PGpPath path,
    GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathPointsI( 
    PGpPath path,
    GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathFillMode( 
    PGpPath path,
    GpFillMode *fillmode);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathFillMode( 
    PGpPath path,
    GpFillMode fillmode);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathData( 
    PGpPath path,
    GpPathData *pathData);

/* [custom][entry] */ GpStatus __stdcall GdipStartPathFigure( 
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipClosePathFigure( 
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipClosePathFigures( 
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathMarker( 
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipClearPathMarkers( 
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipReversePath( 
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathLastPoint( 
    PGpPath path,
    GpPointF *lastPoint);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathLine( 
    PGpPath path,
    REAL x1,
    REAL y1,
    REAL x2,
    REAL y2);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathLine2( 
    PGpPath path,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathArc( 
    PGpPath path,
    REAL x,
    REAL y,
    REAL width,
    REAL height,
    REAL startAngle,
    REAL sweepAngle);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathBezier( 
    PGpPath path,
    REAL x1,
    REAL y1,
    REAL x2,
    REAL y2,
    REAL x3,
    REAL y3,
    REAL x4,
    REAL y4);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathBeziers( 
    PGpPath path,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathCurve( 
    PGpPath path,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathCurve2( 
    PGpPath path,
    /* [in] */ const GpPointF *points,
    INT count,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathCurve3( 
    PGpPath path,
    /* [in] */ const GpPointF *points,
    INT count,
    INT offset,
    INT numberOfSegments,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathClosedCurve( 
    PGpPath path,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathClosedCurve2( 
    PGpPath path,
    /* [in] */ const GpPointF *points,
    INT count,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathRectangle( 
    PGpPath path,
    REAL x,
    REAL y,
    REAL width,
    REAL height);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathRectangles( 
    PGpPath path,
    /* [in] */ const GpRectF *rects,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathEllipse( 
    PGpPath path,
    REAL x,
    REAL y,
    REAL width,
    REAL height);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathPie( 
    PGpPath path,
    REAL x,
    REAL y,
    REAL width,
    REAL height,
    REAL startAngle,
    REAL sweepAngle);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathPolygon( 
    PGpPath path,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathPath( 
    PGpPath path,
    /* [in] */ const PGpPath addingPath,
    BOOL connect);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathString( 
    PGpPath path,
    /* [in] */ LPCOLESTR string,
    INT length,
    /* [in] */ const PGpFontFamily family,
    INT style,
    REAL emSize,
    /* [in] */ const RectF *layoutRect,
    /* [in] */ const PGpStringFormat format);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathStringI( 
    PGpPath path,
    /* [in] */ LPCOLESTR string,
    INT length,
    /* [in] */ const PGpFontFamily family,
    INT style,
    REAL emSize,
    /* [in] */ const Rect *layoutRect,
    /* [in] */ const PGpStringFormat format);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathLineI( 
    PGpPath path,
    INT x1,
    INT y1,
    INT x2,
    INT y2);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathLine2I( 
    PGpPath path,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathArcI( 
    PGpPath path,
    INT x,
    INT y,
    INT width,
    INT height,
    REAL startAngle,
    REAL sweepAngle);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathBezierI( 
    PGpPath path,
    INT x1,
    INT y1,
    INT x2,
    INT y2,
    INT x3,
    INT y3,
    INT x4,
    INT y4);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathBeziersI( 
    PGpPath path,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathCurveI( 
    PGpPath path,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathCurve2I( 
    PGpPath path,
    /* [in] */ const GpPoint *points,
    INT count,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathCurve3I( 
    PGpPath path,
    /* [in] */ const GpPoint *points,
    INT count,
    INT offset,
    INT numberOfSegments,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathClosedCurveI( 
    PGpPath path,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathClosedCurve2I( 
    PGpPath path,
    /* [in] */ const GpPoint *points,
    INT count,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathRectangleI( 
    PGpPath path,
    INT x,
    INT y,
    INT width,
    INT height);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathRectanglesI( 
    PGpPath path,
    /* [in] */ const GpRect *rects,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathEllipseI( 
    PGpPath path,
    INT x,
    INT y,
    INT width,
    INT height);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathPieI( 
    PGpPath path,
    INT x,
    INT y,
    INT width,
    INT height,
    REAL startAngle,
    REAL sweepAngle);

/* [custom][entry] */ GpStatus __stdcall GdipAddPathPolygonI( 
    PGpPath path,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipFlattenPath( 
    PGpPath path,
    PGpMatrix matrix,
    REAL flatness);

/* [custom][entry] */ GpStatus __stdcall GdipWindingModeOutline( 
    PGpPath path,
    PGpMatrix matrix,
    REAL flatness);

/* [custom][entry] */ GpStatus __stdcall GdipWidenPath( 
    PGpPath nativePath,
    PGpPen pen,
    PGpMatrix matrix,
    REAL flatness);

/* [custom][entry] */ GpStatus __stdcall GdipWarpPath( 
    PGpPath path,
    PGpMatrix matrix,
    /* [in] */ const GpPointF *points,
    INT count,
    REAL srcx,
    REAL srcy,
    REAL srcwidth,
    REAL srcheight,
    WarpMode warpMode,
    REAL flatness);

/* [custom][entry] */ GpStatus __stdcall GdipTransformPath( 
    PGpPath path,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathWorldBounds( 
    PGpPath path,
    GpRectF *bounds,
    /* [in] */ const PGpMatrix matrix,
    /* [in] */ const PGpPen pen);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathWorldBoundsI( 
    PGpPath path,
    GpRect *bounds,
    /* [in] */ const PGpMatrix matrix,
    /* [in] */ const PGpPen pen);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisiblePathPoint( 
    PGpPath path,
    REAL x,
    REAL y,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisiblePathPointI( 
    PGpPath path,
    INT x,
    INT y,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsOutlineVisiblePathPoint( 
    PGpPath path,
    REAL x,
    REAL y,
    PGpPen pen,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsOutlineVisiblePathPointI( 
    PGpPath path,
    INT x,
    INT y,
    PGpPen pen,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipCreatePathIter( 
    /* [out] */ PGpPathIterator *iterator,
    /* [in] */ PGpPath path);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeletePathIter( 
    /* [in] */ PGpPathIterator iterator);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterNextSubpath( 
    PGpPathIterator iterator,
    INT *resultCount,
    INT *startIndex,
    INT *endIndex,
    BOOL *isClosed);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterNextSubpathPath( 
    PGpPathIterator iterator,
    INT *resultCount,
    PGpPath path,
    BOOL *isClosed);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterNextPathType( 
    PGpPathIterator iterator,
    INT *resultCount,
    BYTE *pathType,
    INT *startIndex,
    INT *endIndex);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterNextMarker( 
    PGpPathIterator iterator,
    INT *resultCount,
    INT *startIndex,
    INT *endIndex);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterNextMarkerPath( 
    PGpPathIterator iterator,
    INT *resultCount,
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterGetCount( 
    PGpPathIterator iterator,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterGetSubpathCount( 
    PGpPathIterator iterator,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterIsValid( 
    PGpPathIterator iterator,
    BOOL *valid);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterHasCurve( 
    PGpPathIterator iterator,
    BOOL *hasCurve);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterRewind( 
    PGpPathIterator iterator);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterEnumerate( 
    PGpPathIterator iterator,
    INT *resultCount,
    GpPointF *points,
    BYTE *types,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipPathIterCopyData( 
    PGpPathIterator iterator,
    INT *resultCount,
    GpPointF *points,
    BYTE *types,
    INT startIndex,
    INT endIndex);

/* [custom][entry] */ GpStatus __stdcall GdipCreateMatrix( 
    /* [retval][out] */ PGpMatrix *matrix);

/* [custom][entry] */ GpStatus __stdcall GdipCreateMatrix2( 
    REAL m11,
    REAL m12,
    REAL m21,
    REAL m22,
    REAL dx,
    REAL dy,
    /* [retval][out] */ PGpMatrix *matrix);

/* [custom][entry] */ GpStatus __stdcall GdipCreateMatrix3( 
    /* [in] */ const GpRectF *rect,
    /* [in] */ const GpPointF *dstplg,
    /* [retval][out] */ PGpMatrix *matrix);

/* [custom][entry] */ GpStatus __stdcall GdipCreateMatrix3I( 
    /* [in] */ const GpRect *rect,
    /* [in] */ const GpPoint *dstplg,
    /* [retval][out] */ PGpMatrix *matrix);

/* [custom][entry] */ GpStatus __stdcall GdipCloneMatrix( 
    PGpMatrix matrix,
    /* [retval][out] */ PGpMatrix *cloneMatrix);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeleteMatrix( 
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipSetMatrixElements( 
    PGpMatrix matrix,
    REAL m11,
    REAL m12,
    REAL m21,
    REAL m22,
    REAL dx,
    REAL dy);

/* [custom][entry] */ GpStatus __stdcall GdipMultiplyMatrix( 
    PGpMatrix matrix,
    PGpMatrix matrix2,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipTranslateMatrix( 
    PGpMatrix matrix,
    REAL offsetX,
    REAL offsetY,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipScaleMatrix( 
    PGpMatrix matrix,
    REAL scaleX,
    REAL scaleY,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipRotateMatrix( 
    PGpMatrix matrix,
    REAL angle,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipShearMatrix( 
    PGpMatrix matrix,
    REAL shearX,
    REAL shearY,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipInvertMatrix( 
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipTransformMatrixPoints( 
    PGpMatrix matrix,
    GpPointF *pts,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipTransformMatrixPointsI( 
    PGpMatrix matrix,
    GpPoint *pts,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipVectorTransformMatrixPoints( 
    PGpMatrix matrix,
    GpPointF *pts,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipVectorTransformMatrixPointsI( 
    PGpMatrix matrix,
    GpPoint *pts,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipGetMatrixElements( 
    /* [in] */ const PGpMatrix matrix,
    REAL *matrixOut);

/* [custom][entry] */ GpStatus __stdcall GdipIsMatrixInvertible( 
    /* [in] */ const PGpMatrix matrix,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsMatrixIdentity( 
    /* [in] */ const PGpMatrix matrix,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsMatrixEqual( 
    /* [in] */ const PGpMatrix matrix,
    /* [in] */ const PGpMatrix matrix2,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipCreateRegion( 
    /* [retval][out] */ PGpRegion *region);

/* [custom][entry] */ GpStatus __stdcall GdipCreateRegionRect( 
    /* [in] */ const GpRectF *rect,
    /* [retval][out] */ PGpRegion *region);

/* [custom][entry] */ GpStatus __stdcall GdipCreateRegionRectI( 
    /* [in] */ const GpRect *rect,
    /* [retval][out] */ PGpRegion *region);

/* [custom][entry] */ GpStatus __stdcall GdipCreateRegionPath( 
    PGpPath path,
    /* [retval][out] */ PGpRegion *region);

/* [custom][entry] */ GpStatus __stdcall GdipCreateRegionRgnData( 
    /* [in] */ const BYTE *regionData,
    INT size,
    /* [retval][out] */ PGpRegion *region);

/* [custom][entry] */ GpStatus __stdcall GdipCreateRegionHrgn( 
    HRGN hRgn,
    /* [retval][out] */ PGpRegion *region);

/* [custom][entry] */ GpStatus __stdcall GdipCloneRegion( 
    PGpRegion region,
    /* [retval][out] */ PGpRegion *cloneRegion);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeleteRegion( 
    PGpRegion region);

/* [custom][entry] */ GpStatus __stdcall GdipSetInfinite( 
    PGpRegion region);

/* [custom][entry] */ GpStatus __stdcall GdipSetEmpty( 
    PGpRegion region);

/* [custom][entry] */ GpStatus __stdcall GdipCombineRegionRect( 
    PGpRegion region,
    /* [in] */ const GpRectF *rect,
    CombineMode combineMode);

/* [custom][entry] */ GpStatus __stdcall GdipCombineRegionRectI( 
    PGpRegion region,
    /* [in] */ const GpRect *rect,
    CombineMode combineMode);

/* [custom][entry] */ GpStatus __stdcall GdipCombineRegionPath( 
    PGpRegion region,
    PGpPath path,
    CombineMode combineMode);

/* [custom][entry] */ GpStatus __stdcall GdipCombineRegionRegion( 
    PGpRegion region,
    PGpRegion region2,
    CombineMode combineMode);

/* [custom][entry] */ GpStatus __stdcall GdipTranslateRegion( 
    PGpRegion region,
    REAL dx,
    REAL dy);

/* [custom][entry] */ GpStatus __stdcall GdipTranslateRegionI( 
    PGpRegion region,
    INT dx,
    INT dy);

/* [custom][entry] */ GpStatus __stdcall GdipTransformRegion( 
    PGpRegion region,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipGetRegionBounds( 
    PGpRegion region,
    PGpGraphics graphics,
    GpRectF *rect);

/* [custom][entry] */ GpStatus __stdcall GdipGetRegionBoundsI( 
    PGpRegion region,
    PGpGraphics graphics,
    GpRect *rect);

/* [custom][entry] */ GpStatus __stdcall GdipGetRegionHRgn( 
    PGpRegion region,
    PGpGraphics graphics,
    HRGN *hRgn);

/* [custom][entry] */ GpStatus __stdcall GdipIsEmptyRegion( 
    PGpRegion region,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsInfiniteRegion( 
    PGpRegion region,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsEqualRegion( 
    PGpRegion region,
    PGpRegion region2,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipGetRegionDataSize( 
    PGpRegion region,
    UINT *bufferSize);

/* [custom][entry] */ GpStatus __stdcall GdipGetRegionData( 
    PGpRegion region,
    BYTE *buffer,
    UINT bufferSize,
    UINT *sizeFilled);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisibleRegionPoint( 
    PGpRegion region,
    REAL x,
    REAL y,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisibleRegionPointI( 
    PGpRegion region,
    INT x,
    INT y,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisibleRegionRect( 
    PGpRegion region,
    REAL x,
    REAL y,
    REAL width,
    REAL height,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisibleRegionRectI( 
    PGpRegion region,
    INT x,
    INT y,
    INT width,
    INT height,
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipGetRegionScansCount( 
    PGpRegion region,
    UINT *count,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipGetRegionScans( 
    PGpRegion region,
    GpRectF *rects,
    INT *count,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipGetRegionScansI( 
    PGpRegion region,
    GpRect *rects,
    INT *count,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipCloneBrush( 
    PGpBrush brush,
    /* [retval][out] */ PGpBrush *cloneBrush);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeleteBrush( 
    PGpBrush brush);

/* [custom][entry] */ GpStatus __stdcall GdipGetBrushType( 
    PGpBrush brush,
    GpBrushType *type);

/* [custom][entry] */ GpStatus __stdcall GdipCreateHatchBrush( 
    GpHatchStyle hatchstyle,
    ARGB forecol,
    ARGB backcol,
    /* [retval][out] */ PGpHatch *brush);

/* [custom][entry] */ GpStatus __stdcall GdipGetHatchStyle( 
    PGpHatch brush,
    GpHatchStyle *hatchstyle);

/* [custom][entry] */ GpStatus __stdcall GdipGetHatchForegroundColor( 
    PGpHatch brush,
    ARGB *forecol);

/* [custom][entry] */ GpStatus __stdcall GdipGetHatchBackgroundColor( 
    PGpHatch brush,
    ARGB *backcol);

/* [custom][entry] */ GpStatus __stdcall GdipCreateTexture( 
    /* [in] */ PGpImage image,
    /* [in] */ GpWrapMode wrapmode,
    /* [retval][out] */ PGpTexture *texture);

/* [custom][entry] */ GpStatus __stdcall GdipCreateTexture2( 
    /* [in] */ PGpImage image,
    /* [in] */ GpWrapMode wrapmode,
    /* [in] */ REAL x,
    /* [in] */ REAL y,
    /* [in] */ REAL width,
    /* [in] */ REAL height,
    /* [retval][out] */ PGpTexture *texture);

/* [custom][entry] */ GpStatus __stdcall GdipCreateTextureIA( 
    /* [in] */ PGpImage image,
    /* [in] */ const PGpImageAttributes imageAttributes,
    /* [in] */ REAL x,
    /* [in] */ REAL y,
    /* [in] */ REAL width,
    /* [in] */ REAL height,
    /* [retval][out] */ PGpTexture *texture);

/* [custom][entry] */ GpStatus __stdcall GdipCreateTexture2I( 
    /* [in] */ PGpImage image,
    /* [in] */ GpWrapMode wrapmode,
    /* [in] */ INT x,
    /* [in] */ INT y,
    /* [in] */ INT width,
    /* [in] */ INT height,
    /* [retval][out] */ PGpTexture *texture);

/* [custom][entry] */ GpStatus __stdcall GdipCreateTextureIAI( 
    /* [in] */ PGpImage image,
    /* [in] */ const PGpImageAttributes imageAttributes,
    /* [in] */ INT x,
    /* [in] */ INT y,
    /* [in] */ INT width,
    /* [in] */ INT height,
    /* [retval][out] */ PGpTexture *texture);

/* [custom][entry] */ GpStatus __stdcall GdipGetTextureTransform( 
    /* [in] */ PGpTexture brush,
    /* [in] */ PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipSetTextureTransform( 
    /* [in] */ PGpTexture brush,
    /* [in] */ const PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipResetTextureTransform( 
    /* [in] */ PGpTexture brush);

/* [custom][entry] */ GpStatus __stdcall GdipMultiplyTextureTransform( 
    /* [in] */ PGpTexture brush,
    /* [in] */ const PGpMatrix matrix,
    /* [in] */ GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipTranslateTextureTransform( 
    /* [in] */ PGpTexture brush,
    /* [in] */ REAL dx,
    /* [in] */ REAL dy,
    /* [in] */ GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipScaleTextureTransform( 
    /* [in] */ PGpTexture brush,
    /* [in] */ REAL sx,
    /* [in] */ REAL sy,
    /* [in] */ GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipRotateTextureTransform( 
    /* [in] */ PGpTexture brush,
    /* [in] */ REAL angle,
    /* [in] */ GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipSetTextureWrapMode( 
    /* [in] */ PGpTexture brush,
    /* [in] */ GpWrapMode wrapmode);

/* [custom][entry] */ GpStatus __stdcall GdipGetTextureWrapMode( 
    /* [in] */ PGpTexture brush,
    /* [retval][out] */ GpWrapMode *wrapmode);

/* [custom][entry] */ GpStatus __stdcall GdipGetTextureImage( 
    /* [in] */ PGpTexture brush,
    /* [retval][out] */ PGpImage *image);

/* [custom][entry] */ GpStatus __stdcall GdipCreateSolidFill( 
    /* [in] */ ARGB color,
    /* [retval][out] */ PGpSolidFill *brush);

/* [custom][entry] */ GpStatus __stdcall GdipSetSolidFillColor( 
    /* [in] */ PGpSolidFill brush,
    /* [in] */ ARGB color);

/* [custom][entry] */ GpStatus __stdcall GdipGetSolidFillColor( 
    /* [in] */ PGpSolidFill brush,
    /* [retval][out] */ ARGB *color);

/* [custom][entry] */ GpStatus __stdcall GdipCreateLineBrush( 
    /* [in] */ const GpPointF *point1,
    /* [in] */ const GpPointF *point2,
    /* [in] */ ARGB color1,
    /* [in] */ ARGB color2,
    /* [in] */ GpWrapMode wrapMode,
    /* [retval][out] */ PGpLineGradient *lineGradient);

/* [custom][entry] */ GpStatus __stdcall GdipCreateLineBrushI( 
    /* [in] */ const GpPoint *point1,
    /* [in] */ const GpPoint *point2,
    ARGB color1,
    ARGB color2,
    GpWrapMode wrapMode,
    /* [retval][out] */ PGpLineGradient *lineGradient);

/* [custom][entry] */ GpStatus __stdcall GdipCreateLineBrushFromRect( 
    /* [in] */ const GpRectF *rect,
    ARGB color1,
    ARGB color2,
    LinearGradientMode mode,
    GpWrapMode wrapMode,
    /* [retval][out] */ PGpLineGradient *lineGradient);

/* [custom][entry] */ GpStatus __stdcall GdipCreateLineBrushFromRectI( 
    /* [in] */ const GpRect *rect,
    ARGB color1,
    ARGB color2,
    LinearGradientMode mode,
    GpWrapMode wrapMode,
    /* [retval][out] */ PGpLineGradient *lineGradient);

/* [custom][entry] */ GpStatus __stdcall GdipCreateLineBrushFromRectWithAngle( 
    /* [in] */ const GpRectF *rect,
    ARGB color1,
    ARGB color2,
    REAL angle,
    BOOL isAngleScalable,
    GpWrapMode wrapMode,
    /* [retval][out] */ PGpLineGradient *lineGradient);

/* [custom][entry] */ GpStatus __stdcall GdipCreateLineBrushFromRectWithAngleI( 
    /* [in] */ const GpRect *rect,
    ARGB color1,
    ARGB color2,
    REAL angle,
    BOOL isAngleScalable,
    GpWrapMode wrapMode,
    /* [retval][out] */ PGpLineGradient *lineGradient);

/* [custom][entry] */ GpStatus __stdcall GdipSetLineColors( 
    PGpLineGradient brush,
    ARGB color1,
    ARGB color2);

/* [custom][entry] */ GpStatus __stdcall GdipGetLineColors( 
    PGpLineGradient brush,
    ARGB *colors);

/* [custom][entry] */ GpStatus __stdcall GdipGetLineRect( 
    PGpLineGradient brush,
    GpRectF *rect);

/* [custom][entry] */ GpStatus __stdcall GdipGetLineRectI( 
    PGpLineGradient brush,
    GpRect *rect);

/* [custom][entry] */ GpStatus __stdcall GdipSetLineGammaCorrection( 
    PGpLineGradient brush,
    BOOL useGammaCorrection);

/* [custom][entry] */ GpStatus __stdcall GdipGetLineGammaCorrection( 
    PGpLineGradient brush,
    BOOL *useGammaCorrection);

/* [custom][entry] */ GpStatus __stdcall GdipGetLineBlendCount( 
    PGpLineGradient brush,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipGetLineBlend( 
    PGpLineGradient brush,
    REAL *blend,
    REAL *positions,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipSetLineBlend( 
    PGpLineGradient brush,
    /* [in] */ const REAL *blend,
    /* [in] */ const REAL *positions,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipGetLinePresetBlendCount( 
    PGpLineGradient brush,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipGetLinePresetBlend( 
    PGpLineGradient brush,
    ARGB *blend,
    REAL *positions,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipSetLinePresetBlend( 
    PGpLineGradient brush,
    /* [in] */ const ARGB *blend,
    /* [in] */ const REAL *positions,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipSetLineSigmaBlend( 
    PGpLineGradient brush,
    REAL focus,
    REAL scale);

/* [custom][entry] */ GpStatus __stdcall GdipSetLineLinearBlend( 
    PGpLineGradient brush,
    REAL focus,
    REAL scale);

/* [custom][entry] */ GpStatus __stdcall GdipSetLineWrapMode( 
    PGpLineGradient brush,
    GpWrapMode wrapmode);

/* [custom][entry] */ GpStatus __stdcall GdipGetLineWrapMode( 
    PGpLineGradient brush,
    GpWrapMode *wrapmode);

/* [custom][entry] */ GpStatus __stdcall GdipGetLineTransform( 
    PGpLineGradient brush,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipSetLineTransform( 
    PGpLineGradient brush,
    /* [in] */ const PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipResetLineTransform( 
    PGpLineGradient brush);

/* [custom][entry] */ GpStatus __stdcall GdipMultiplyLineTransform( 
    PGpLineGradient brush,
    /* [in] */ const PGpMatrix matrix,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipTranslateLineTransform( 
    PGpLineGradient brush,
    REAL dx,
    REAL dy,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipScaleLineTransform( 
    PGpLineGradient brush,
    REAL sx,
    REAL sy,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipRotateLineTransform( 
    PGpLineGradient brush,
    REAL angle,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipCreatePathGradient( 
    /* [in] */ const GpPointF *points,
    INT count,
    GpWrapMode wrapMode,
    /* [retval][out] */ PGpPathGradient *polyGradient);

/* [custom][entry] */ GpStatus __stdcall GdipCreatePathGradientI( 
    /* [in] */ const GpPoint *points,
    INT count,
    GpWrapMode wrapMode,
    /* [retval][out] */ PGpPathGradient *polyGradient);

/* [custom][entry] */ GpStatus __stdcall GdipCreatePathGradientFromPath( 
    /* [in] */ const PGpPath path,
    /* [retval][out] */ PGpPathGradient *polyGradient);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientCenterColor( 
    PGpPathGradient brush,
    ARGB *colors);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientCenterColor( 
    PGpPathGradient brush,
    ARGB colors);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientSurroundColorsWithCount( 
    PGpPathGradient brush,
    ARGB *color,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientSurroundColorsWithCount( 
    PGpPathGradient brush,
    /* [in] */ const ARGB *color,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientPath( 
    PGpPathGradient brush,
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientPath( 
    PGpPathGradient brush,
    /* [in] */ const PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientCenterPoint( 
    PGpPathGradient brush,
    GpPointF *points);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientCenterPointI( 
    PGpPathGradient brush,
    GpPoint *points);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientCenterPoint( 
    PGpPathGradient brush,
    /* [in] */ const GpPointF *points);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientCenterPointI( 
    PGpPathGradient brush,
    /* [in] */ const GpPoint *points);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientRect( 
    PGpPathGradient brush,
    GpRectF *rect);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientRectI( 
    PGpPathGradient brush,
    GpRect *rect);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientPointCount( 
    PGpPathGradient brush,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientSurroundColorCount( 
    PGpPathGradient brush,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientGammaCorrection( 
    PGpPathGradient brush,
    BOOL useGammaCorrection);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientGammaCorrection( 
    PGpPathGradient brush,
    BOOL *useGammaCorrection);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientBlendCount( 
    PGpPathGradient brush,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientBlend( 
    PGpPathGradient brush,
    REAL *blend,
    REAL *positions,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientBlend( 
    PGpPathGradient brush,
    /* [in] */ const REAL *blend,
    /* [in] */ const REAL *positions,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientPresetBlendCount( 
    PGpPathGradient brush,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientPresetBlend( 
    PGpPathGradient brush,
    ARGB *blend,
    REAL *positions,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientPresetBlend( 
    PGpPathGradient brush,
    /* [in] */ const ARGB *blend,
    /* [in] */ const REAL *positions,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientSigmaBlend( 
    PGpPathGradient brush,
    REAL focus,
    REAL scale);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientLinearBlend( 
    PGpPathGradient brush,
    REAL focus,
    REAL scale);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientWrapMode( 
    PGpPathGradient brush,
    GpWrapMode *wrapmode);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientWrapMode( 
    PGpPathGradient brush,
    GpWrapMode wrapmode);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientTransform( 
    PGpPathGradient brush,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientTransform( 
    PGpPathGradient brush,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipResetPathGradientTransform( 
    PGpPathGradient brush);

/* [custom][entry] */ GpStatus __stdcall GdipMultiplyPathGradientTransform( 
    PGpPathGradient brush,
    /* [in] */ const PGpMatrix matrix,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipTranslatePathGradientTransform( 
    PGpPathGradient brush,
    REAL dx,
    REAL dy,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipScalePathGradientTransform( 
    PGpPathGradient brush,
    REAL sx,
    REAL sy,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipRotatePathGradientTransform( 
    PGpPathGradient brush,
    REAL angle,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipGetPathGradientFocusScales( 
    PGpPathGradient brush,
    REAL *xScale,
    REAL *yScale);

/* [custom][entry] */ GpStatus __stdcall GdipSetPathGradientFocusScales( 
    PGpPathGradient brush,
    REAL xScale,
    REAL yScale);

/* [custom][entry] */ GpStatus __stdcall GdipCreatePen1( 
    ARGB color,
    REAL width,
    GpUnit unit,
    /* [retval][out] */ PGpPen *pen);

/* [custom][entry] */ GpStatus __stdcall GdipCreatePen2( 
    PGpBrush brush,
    REAL width,
    GpUnit unit,
    /* [retval][out] */ PGpPen *pen);

/* [custom][entry] */ GpStatus __stdcall GdipClonePen( 
    PGpPen pen,
    /* [retval][out] */ PGpPen *clonepen);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeletePen( 
    PGpPen pen);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenWidth( 
    PGpPen pen,
    REAL width);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenWidth( 
    PGpPen pen,
    REAL *width);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenUnit( 
    PGpPen pen,
    GpUnit unit);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenUnit( 
    PGpPen pen,
    GpUnit *unit);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenLineCap197819( 
    PGpPen pen,
    GpLineCap startCap,
    GpLineCap endCap,
    GpDashCap dashCap);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenStartCap( 
    PGpPen pen,
    GpLineCap startCap);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenEndCap( 
    PGpPen pen,
    GpLineCap endCap);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenDashCap197819( 
    PGpPen pen,
    GpDashCap dashCap);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenStartCap( 
    PGpPen pen,
    GpLineCap *startCap);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenEndCap( 
    PGpPen pen,
    GpLineCap *endCap);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenDashCap197819( 
    PGpPen pen,
    GpDashCap *dashCap);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenLineJoin( 
    PGpPen pen,
    GpLineJoin lineJoin);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenLineJoin( 
    PGpPen pen,
    GpLineJoin *lineJoin);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenCustomStartCap( 
    PGpPen pen,
    PGpCustomLineCap customCap);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenCustomStartCap( 
    PGpPen pen,
    /* [retval][out] */ PGpCustomLineCap *customCap);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenCustomEndCap( 
    PGpPen pen,
    PGpCustomLineCap customCap);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenCustomEndCap( 
    PGpPen pen,
    /* [retval][out] */ PGpCustomLineCap *customCap);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenMiterLimit( 
    PGpPen pen,
    REAL miterLimit);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenMiterLimit( 
    PGpPen pen,
    REAL *miterLimit);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenMode( 
    PGpPen pen,
    GpPenAlignment penMode);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenMode( 
    PGpPen pen,
    GpPenAlignment *penMode);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenTransform( 
    PGpPen pen,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenTransform( 
    PGpPen pen,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipResetPenTransform( 
    PGpPen pen);

/* [custom][entry] */ GpStatus __stdcall GdipMultiplyPenTransform( 
    PGpPen pen,
    /* [in] */ const PGpMatrix matrix,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipTranslatePenTransform( 
    PGpPen pen,
    REAL dx,
    REAL dy,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipScalePenTransform( 
    PGpPen pen,
    REAL sx,
    REAL sy,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipRotatePenTransform( 
    PGpPen pen,
    REAL angle,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenColor( 
    PGpPen pen,
    ARGB argb);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenColor( 
    PGpPen pen,
    ARGB *argb);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenBrushFill( 
    PGpPen pen,
    PGpBrush brush);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenBrushFill( 
    PGpPen pen,
    /* [retval][out] */ PGpBrush *brush);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenFillType( 
    PGpPen pen,
    GpPenType *type);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenDashStyle( 
    PGpPen pen,
    GpDashStyle *dashstyle);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenDashStyle( 
    PGpPen pen,
    GpDashStyle dashstyle);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenDashOffset( 
    PGpPen pen,
    REAL *offset);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenDashOffset( 
    PGpPen pen,
    REAL offset);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenDashCount( 
    PGpPen pen,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenDashArray( 
    PGpPen pen,
    /* [in] */ const REAL *dash,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenDashArray( 
    PGpPen pen,
    REAL *dash,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenCompoundCount( 
    PGpPen pen,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipSetPenCompoundArray( 
    PGpPen pen,
    /* [in] */ const REAL *dash,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipGetPenCompoundArray( 
    PGpPen pen,
    REAL *dash,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipCreateCustomLineCap( 
    PGpPath fillPath,
    PGpPath strokePath,
    GpLineCap baseCap,
    REAL baseInset,
    /* [retval][out] */ PGpCustomLineCap *customCap);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeleteCustomLineCap( 
    PGpCustomLineCap customCap);

/* [custom][entry] */ GpStatus __stdcall GdipCloneCustomLineCap( 
    PGpCustomLineCap customCap,
    /* [retval][out] */ PGpCustomLineCap *clonedCap);

/* [custom][entry] */ GpStatus __stdcall GdipGetCustomLineCapType( 
    PGpCustomLineCap customCap,
    CustomLineCapType *capType);

/* [custom][entry] */ GpStatus __stdcall GdipSetCustomLineCapStrokeCaps( 
    PGpCustomLineCap customCap,
    GpLineCap startCap,
    GpLineCap endCap);

/* [custom][entry] */ GpStatus __stdcall GdipGetCustomLineCapStrokeCaps( 
    PGpCustomLineCap customCap,
    GpLineCap *startCap,
    GpLineCap *endCap);

/* [custom][entry] */ GpStatus __stdcall GdipSetCustomLineCapStrokeJoin( 
    PGpCustomLineCap customCap,
    GpLineJoin lineJoin);

/* [custom][entry] */ GpStatus __stdcall GdipGetCustomLineCapStrokeJoin( 
    PGpCustomLineCap customCap,
    GpLineJoin *lineJoin);

/* [custom][entry] */ GpStatus __stdcall GdipSetCustomLineCapBaseCap( 
    PGpCustomLineCap customCap,
    GpLineCap baseCap);

/* [custom][entry] */ GpStatus __stdcall GdipGetCustomLineCapBaseCap( 
    PGpCustomLineCap customCap,
    GpLineCap *baseCap);

/* [custom][entry] */ GpStatus __stdcall GdipSetCustomLineCapBaseInset( 
    PGpCustomLineCap customCap,
    REAL inset);

/* [custom][entry] */ GpStatus __stdcall GdipGetCustomLineCapBaseInset( 
    PGpCustomLineCap customCap,
    REAL *inset);

/* [custom][entry] */ GpStatus __stdcall GdipSetCustomLineCapWidthScale( 
    PGpCustomLineCap customCap,
    REAL widthScale);

/* [custom][entry] */ GpStatus __stdcall GdipGetCustomLineCapWidthScale( 
    PGpCustomLineCap customCap,
    REAL *widthScale);

/* [custom][entry] */ GpStatus __stdcall GdipCreateAdjustableArrowCap( 
    REAL height,
    REAL width,
    BOOL isFilled,
    /* [retval][out] */ PGpAdjustableArrowCap *cap);

/* [custom][entry] */ GpStatus __stdcall GdipSetAdjustableArrowCapHeight( 
    PGpAdjustableArrowCap cap,
    REAL height);

/* [custom][entry] */ GpStatus __stdcall GdipGetAdjustableArrowCapHeight( 
    PGpAdjustableArrowCap cap,
    REAL *height);

/* [custom][entry] */ GpStatus __stdcall GdipSetAdjustableArrowCapWidth( 
    PGpAdjustableArrowCap cap,
    REAL width);

/* [custom][entry] */ GpStatus __stdcall GdipGetAdjustableArrowCapWidth( 
    PGpAdjustableArrowCap cap,
    REAL *width);

/* [custom][entry] */ GpStatus __stdcall GdipSetAdjustableArrowCapMiddleInset( 
    PGpAdjustableArrowCap cap,
    REAL middleInset);

/* [custom][entry] */ GpStatus __stdcall GdipGetAdjustableArrowCapMiddleInset( 
    PGpAdjustableArrowCap cap,
    REAL *middleInset);

/* [custom][entry] */ GpStatus __stdcall GdipSetAdjustableArrowCapFillState( 
    PGpAdjustableArrowCap cap,
    BOOL fillState);

/* [custom][entry] */ GpStatus __stdcall GdipGetAdjustableArrowCapFillState( 
    PGpAdjustableArrowCap cap,
    BOOL *fillState);

/* [custom][entry] */ GpStatus __stdcall GdipLoadImageFromStream( 
    /* [in] */ IStream *stream,
    /* [retval][out] */ PGpImage *image);

/* [custom][entry] */ GpStatus __stdcall GdipLoadImageFromFile( 
    /* [in] */ LPCOLESTR filename,
    /* [retval][out] */ PGpImage *image);

/* [custom][entry] */ GpStatus __stdcall GdipLoadImageFromStreamICM( 
    /* [in] */ IStream *stream,
    /* [retval][out] */ PGpImage *image);

/* [custom][entry] */ GpStatus __stdcall GdipLoadImageFromFileICM( 
    /* [in] */ LPCOLESTR filename,
    /* [retval][out] */ PGpImage *image);

/* [custom][entry] */ GpStatus __stdcall GdipCloneImage( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ PGpImage *cloneImage);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDisposeImage( 
    /* [in] */ PGpImage image);

/* [custom][entry] */ GpStatus __stdcall GdipSaveImageToFile( 
    /* [in] */ PGpImage image,
    /* [in] */ LPCOLESTR filename,
    /* [in] */ const CLSID *clsidEncoder,
    /* [in] */ const EncoderParameters *encoderParams);

/* [custom][entry] */ GpStatus __stdcall GdipSaveImageToStream( 
    /* [in] */ PGpImage image,
    /* [in] */ IStream *stream,
    /* [in] */ const CLSID *clsidEncoder,
    /* [in] */ const EncoderParameters *encoderParams);

/* [custom][entry] */ GpStatus __stdcall GdipSaveAdd( 
    /* [in] */ PGpImage image,
    /* [in] */ const EncoderParameters *encoderParams);

/* [custom][entry] */ GpStatus __stdcall GdipSaveAddImage( 
    /* [in] */ PGpImage image,
    /* [in] */ PGpImage newImage,
    /* [in] */ const EncoderParameters *encoderParams);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageGraphicsContext( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ PGpGraphics *graphics);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageBounds( 
    /* [in] */ PGpImage image,
    GpRectF *srcRect,
    GpUnit *srcUnit);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageDimension( 
    /* [in] */ PGpImage image,
    /* [out] */ REAL *width,
    /* [out] */ REAL *height);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageType( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ ImageType *type);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageWidth( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ UINT *width);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageHeight( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ UINT *height);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageHorizontalResolution( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ REAL *resolution);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageVerticalResolution( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ REAL *resolution);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageFlags( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ UINT *flags);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageRawFormat( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ GUID *format);

/* [custom][entry] */ GpStatus __stdcall GdipGetImagePixelFormat( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ PixelFormat *format);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageThumbnail( 
    /* [in] */ PGpImage image,
    /* [in] */ UINT thumbWidth,
    /* [in] */ UINT thumbHeight,
    /* [out] */ PGpImage *thumbImage,
    /* [in] */ GetThumbnailImageAbort pfnCallback,
    /* [in] */ void *callbackData);

/* [custom][entry] */ GpStatus __stdcall GdipGetEncoderParameterListSize( 
    /* [in] */ PGpImage image,
    /* [in] */ const CLSID *clsidEncoder,
    /* [retval][out] */ UINT *size);

/* [custom][entry] */ GpStatus __stdcall GdipGetEncoderParameterList( 
    /* [in] */ PGpImage image,
    /* [in] */ const CLSID *clsidEncoder,
    /* [in] */ UINT size,
    /* [retval][out] */ EncoderParameters *buffer);

/* [custom][entry] */ GpStatus __stdcall GdipImageGetFrameDimensionsCount( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ UINT *count);

/* [custom][entry] */ GpStatus __stdcall GdipImageGetFrameDimensionsList( 
    /* [in] */ PGpImage image,
    GUID *dimensionIDs,
    UINT count);

/* [custom][entry] */ GpStatus __stdcall GdipImageGetFrameCount( 
    /* [in] */ PGpImage image,
    /* [in] */ const GUID *dimensionID,
    UINT *count);

/* [custom][entry] */ GpStatus __stdcall GdipImageSelectActiveFrame( 
    /* [in] */ PGpImage image,
    /* [in] */ const GUID *dimensionID,
    /* [in] */ UINT frameIndex);

/* [custom][entry] */ GpStatus __stdcall GdipImageRotateFlip( 
    /* [in] */ PGpImage image,
    /* [in] */ RotateFlipType rfType);

/* [custom][entry] */ GpStatus __stdcall GdipGetImagePalette( 
    /* [in] */ PGpImage image,
    ColorPalette *palette,
    INT size);

/* [custom][entry] */ GpStatus __stdcall GdipSetImagePalette( 
    /* [in] */ PGpImage image,
    /* [in] */ const ColorPalette *palette);

/* [custom][entry] */ GpStatus __stdcall GdipGetImagePaletteSize( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ INT *size);

/* [custom][entry] */ GpStatus __stdcall GdipGetPropertyCount( 
    /* [in] */ PGpImage image,
    /* [retval][out] */ UINT *numOfProperty);

/* [custom][entry] */ GpStatus __stdcall GdipGetPropertyIdList( 
    /* [in] */ PGpImage image,
    /* [in] */ UINT numOfProperty,
    PROPID *list);

/* [custom][entry] */ GpStatus __stdcall GdipGetPropertyItemSize( 
    /* [in] */ PGpImage image,
    /* [in] */ PROPID propId,
    UINT *size);

/* [custom][entry] */ GpStatus __stdcall GdipGetPropertyItem( 
    /* [in] */ PGpImage image,
    /* [in] */ PROPID propId,
    /* [in] */ UINT propSize,
    PropertyItem *buffer);

/* [custom][entry] */ GpStatus __stdcall GdipGetPropertySize( 
    /* [in] */ PGpImage image,
    UINT *totalBufferSize,
    UINT *numProperties);

/* [custom][entry] */ GpStatus __stdcall GdipGetAllPropertyItems( 
    /* [in] */ PGpImage image,
    /* [in] */ UINT totalBufferSize,
    /* [in] */ UINT numProperties,
    PropertyItem *allItems);

/* [custom][entry] */ GpStatus __stdcall GdipRemovePropertyItem( 
    /* [in] */ PGpImage image,
    /* [in] */ PROPID propId);

/* [custom][entry] */ GpStatus __stdcall GdipSetPropertyItem( 
    /* [in] */ PGpImage image,
    /* [in] */ const PropertyItem *item);

/* [custom][entry] */ GpStatus __stdcall GdipFindFirstImageItem( 
    /* [in] */ PGpImage image,
    ImageItemData *item);

/* [custom][entry] */ GpStatus __stdcall GdipFindNextImageItem( 
    /* [in] */ PGpImage image,
    ImageItemData *item);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageItemData( 
    /* [in] */ PGpImage image,
    ImageItemData *item);

/* [custom][entry] */ GpStatus __stdcall GdipImageForceValidation( 
    /* [in] */ PGpImage image);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromStream( 
    /* [in] */ IStream *stream,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromFile( 
    /* [in] */ LPCOLESTR filename,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromStreamICM( 
    /* [in] */ IStream *stream,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromFileICM( 
    /* [in] */ LPCOLESTR filename,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromScan0( 
    /* [in] */ INT width,
    /* [in] */ INT height,
    /* [in] */ INT stride,
    /* [in] */ PixelFormat format,
    /* [in] */ BYTE *scan0,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromGraphics( 
    /* [in] */ INT width,
    /* [in] */ INT height,
    /* [in] */ PGpGraphics target,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromDirectDrawSurface( 
    /* [in] */ IDirectDrawSurface7 *surface,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromGdiDib( 
    /* [in] */ const BITMAPINFO *gdiBitmapInfo,
    /* [in] */ void *gdiBitmapData,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromHBITMAP( 
    /* [in] */ HBITMAP hbm,
    /* [in] */ HPALETTE hpal,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCreateHBITMAPFromBitmap( 
    /* [in] */ PGpBitmap bitmap,
    /* [out] */ HBITMAP *hbmReturn,
    /* [in] */ ARGB background);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromHICON( 
    /* [in] */ HICON hicon,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCreateHICONFromBitmap( 
    /* [in] */ PGpBitmap bitmap,
    /* [retval][out] */ HICON *hbmReturn);

/* [custom][entry] */ GpStatus __stdcall GdipCreateBitmapFromResource( 
    /* [in] */ HINSTANCE hInstance,
    /* [in] */ LPCOLESTR lpBitmapName,
    /* [retval][out] */ PGpBitmap *bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCloneBitmapArea( 
    /* [in] */ REAL x,
    /* [in] */ REAL y,
    /* [in] */ REAL width,
    /* [in] */ REAL height,
    /* [in] */ PixelFormat format,
    /* [in] */ PGpBitmap srcBitmap,
    /* [retval][out] */ PGpBitmap *dstBitmap);

/* [custom][entry] */ GpStatus __stdcall GdipCloneBitmapAreaI( 
    /* [in] */ INT x,
    /* [in] */ INT y,
    /* [in] */ INT width,
    /* [in] */ INT height,
    /* [in] */ PixelFormat format,
    /* [in] */ PGpBitmap srcBitmap,
    /* [retval][out] */ PGpBitmap *dstBitmap);

/* [custom][entry] */ GpStatus __stdcall GdipBitmapLockBits( 
    /* [in] */ PGpBitmap bitmap,
    /* [in] */ const GpRect *rect,
    /* [in] */ UINT flags,
    /* [in] */ PixelFormat format,
    /* [retval][out] */ BitmapData *lockedBitmapData);

/* [custom][entry] */ GpStatus __stdcall GdipBitmapUnlockBits( 
    /* [in] */ PGpBitmap bitmap,
    /* [in] */ BitmapData *lockedBitmapData);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipBitmapGetPixel( 
    /* [in] */ PGpBitmap bitmap,
    /* [in] */ INT x,
    /* [in] */ INT y,
    /* [retval][out] */ ARGB *color);

/* [custom][entry] */ GpStatus __stdcall GdipBitmapSetPixel( 
    /* [in] */ PGpBitmap bitmap,
    /* [in] */ INT x,
    /* [in] */ INT y,
    /* [in] */ ARGB color);

/* [custom][entry] */ GpStatus __stdcall GdipImageSetAbort( 
    PGpImage pImage,
    GdiplusAbort *pIAbort);

/* [custom][entry] */ GpStatus __stdcall GdipGraphicsSetAbort( 
    PGpGraphics pGraphics,
    GdiplusAbort *pIAbort);

/* [custom][entry] */ GpStatus __stdcall GdipBitmapConvertFormat( 
    PGpBitmap pInputBitmap,
    PixelFormat format,
    DitherType dithertype,
    PaletteType palettetype,
    ColorPalette *palette,
    REAL alphaThresholdPercent);

/* [custom][entry] */ GpStatus __stdcall GdipInitializePalette( 
    /* [out] */ ColorPalette *palette,
    PaletteType palettetype,
    INT optimalColors,
    BOOL useTransparentColor,
    PGpBitmap bitmap);

/* [custom][entry] */ GpStatus __stdcall GdipBitmapApplyEffect( 
    PGpBitmap bitmap,
    PCGpEffect effect,
    Rect *roi,
    BOOL useAuxData,
    void **auxData,
    INT *auxDataSize);

/* [custom][entry] */ GpStatus __stdcall GdipBitmapCreateApplyEffect( 
    PGpBitmap *inputBitmaps,
    INT numInputs,
    PCGpEffect effect,
    Rect *roi,
    Rect *outputRect,
    PGpBitmap *outputBitmap,
    BOOL useAuxData,
    void **auxData,
    INT *auxDataSize);

/* [custom][entry] */ GpStatus __stdcall GdipBitmapGetHistogram( 
    PGpBitmap bitmap,
    HistogramFormat format,
    UINT NumberOfEntries,
    UINT *channel0,
    UINT *channel1,
    UINT *channel2,
    UINT *channel3);

/* [custom][entry] */ GpStatus __stdcall GdipBitmapGetHistogramSize( 
    HistogramFormat format,
    /* [out] */ UINT *NumberOfEntries);

/* [custom][entry] */ GpStatus __stdcall GdipBitmapSetResolution( 
    /* [in] */ PGpBitmap bitmap,
    /* [in] */ REAL xdpi,
    /* [in] */ REAL ydpi);

/* [custom][entry] */ GpStatus __stdcall GdipCreateImageAttributes( 
    /* [retval][out] */ PGpImageAttributes *imageattr);

/* [custom][entry] */ GpStatus __stdcall GdipCloneImageAttributes( 
    /* [in] */ const PGpImageAttributes imageattr,
    /* [retval][out] */ PGpImageAttributes *cloneImageattr);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDisposeImageAttributes( 
    PGpImageAttributes imageattr);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesToIdentity( 
    PGpImageAttributes imageattr,
    ColorAdjustType type);

/* [custom][entry] */ GpStatus __stdcall GdipResetImageAttributes( 
    PGpImageAttributes imageattr,
    ColorAdjustType type);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesColorMatrix( 
    PGpImageAttributes imageattr,
    ColorAdjustType type,
    BOOL enableFlag,
    /* [in] */ const ColorMatrix *colorMatrix,
    /* [in] */ const ColorMatrix *grayMatrix,
    ColorMatrixFlags flags);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesThreshold( 
    PGpImageAttributes imageattr,
    ColorAdjustType type,
    BOOL enableFlag,
    REAL threshold);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesGamma( 
    PGpImageAttributes imageattr,
    ColorAdjustType type,
    BOOL enableFlag,
    REAL gamma);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesNoOp( 
    PGpImageAttributes imageattr,
    ColorAdjustType type,
    BOOL enableFlag);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesColorKeys( 
    PGpImageAttributes imageattr,
    ColorAdjustType type,
    BOOL enableFlag,
    ARGB colorLow,
    ARGB colorHigh);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesOutputChannel( 
    PGpImageAttributes imageattr,
    ColorAdjustType type,
    BOOL enableFlag,
    ColorChannelFlags channelFlags);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesOutputChannelColorProfile( 
    PGpImageAttributes imageattr,
    ColorAdjustType type,
    BOOL enableFlag,
    /* [in] */ LPCOLESTR colorProfileFilename);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesRemapTable( 
    PGpImageAttributes imageattr,
    ColorAdjustType type,
    BOOL enableFlag,
    UINT mapSize,
    /* [in] */ const ColorMap *map);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesWrapMode( 
    PGpImageAttributes imageAttr,
    WrapMode wrap,
    ARGB argb,
    BOOL clamp);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesICMMode( 
    PGpImageAttributes imageAttr,
    BOOL on);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageAttributesAdjustedPalette( 
    PGpImageAttributes imageAttr,
    ColorPalette *colorPalette,
    ColorAdjustType colorAdjustType);

/* [custom][entry] */ GpStatus __stdcall GdipFlush( 
    PGpGraphics graphics,
    GpFlushIntention intention);

/* [custom][entry] */ GpStatus __stdcall GdipCreateFromHDC( 
    HDC hdc,
    /* [retval][out] */ PGpGraphics *graphics);

/* [custom][entry] */ GpStatus __stdcall GdipCreateFromHDC2( 
    HDC hdc,
    HANDLE hDevice,
    /* [retval][out] */ PGpGraphics *graphics);

/* [custom][entry] */ GpStatus __stdcall GdipCreateFromHWND( 
    HWND hwnd,
    /* [retval][out] */ PGpGraphics *graphics);

/* [custom][entry] */ GpStatus __stdcall GdipCreateFromHWNDICM( 
    HWND hwnd,
    /* [retval][out] */ PGpGraphics *graphics);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeleteGraphics( 
    PGpGraphics graphics);

/* [custom][entry] */ GpStatus __stdcall GdipGetDC( 
    PGpGraphics graphics,
    HDC *hdc);

/* [custom][entry] */ GpStatus __stdcall GdipReleaseDC( 
    PGpGraphics graphics,
    HDC hdc);

/* [custom][entry] */ GpStatus __stdcall GdipSetCompositingMode( 
    PGpGraphics graphics,
    CompositingMode compositingMode);

/* [custom][entry] */ GpStatus __stdcall GdipGetCompositingMode( 
    PGpGraphics graphics,
    CompositingMode *compositingMode);

/* [custom][entry] */ GpStatus __stdcall GdipSetRenderingOrigin( 
    PGpGraphics graphics,
    INT x,
    INT y);

/* [custom][entry] */ GpStatus __stdcall GdipGetRenderingOrigin( 
    PGpGraphics graphics,
    INT *x,
    INT *y);

/* [custom][entry] */ GpStatus __stdcall GdipSetCompositingQuality( 
    PGpGraphics graphics,
    CompositingQuality compositingQuality);

/* [custom][entry] */ GpStatus __stdcall GdipGetCompositingQuality( 
    PGpGraphics graphics,
    CompositingQuality *compositingQuality);

/* [custom][entry] */ GpStatus __stdcall GdipSetSmoothingMode( 
    PGpGraphics graphics,
    SmoothingMode smoothingMode);

/* [custom][entry] */ GpStatus __stdcall GdipGetSmoothingMode( 
    PGpGraphics graphics,
    SmoothingMode *smoothingMode);

/* [custom][entry] */ GpStatus __stdcall GdipSetPixelOffsetMode( 
    PGpGraphics graphics,
    PixelOffsetMode pixelOffsetMode);

/* [custom][entry] */ GpStatus __stdcall GdipGetPixelOffsetMode( 
    PGpGraphics graphics,
    PixelOffsetMode *pixelOffsetMode);

/* [custom][entry] */ GpStatus __stdcall GdipSetTextRenderingHint( 
    PGpGraphics graphics,
    TextRenderingHint mode);

/* [custom][entry] */ GpStatus __stdcall GdipGetTextRenderingHint( 
    PGpGraphics graphics,
    TextRenderingHint *mode);

/* [custom][entry] */ GpStatus __stdcall GdipSetTextContrast( 
    PGpGraphics graphics,
    UINT contrast);

/* [custom][entry] */ GpStatus __stdcall GdipGetTextContrast( 
    PGpGraphics graphics,
    UINT *contrast);

/* [custom][entry] */ GpStatus __stdcall GdipSetInterpolationMode( 
    PGpGraphics graphics,
    InterpolationMode interpolationMode);

/* [custom][entry] */ GpStatus __stdcall GdipGetInterpolationMode( 
    PGpGraphics graphics,
    InterpolationMode *interpolationMode);

/* [custom][entry] */ GpStatus __stdcall GdipSetWorldTransform( 
    PGpGraphics graphics,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipResetWorldTransform( 
    PGpGraphics graphics);

/* [custom][entry] */ GpStatus __stdcall GdipMultiplyWorldTransform( 
    PGpGraphics graphics,
    /* [in] */ const PGpMatrix matrix,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipTranslateWorldTransform( 
    PGpGraphics graphics,
    REAL dx,
    REAL dy,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipScaleWorldTransform( 
    PGpGraphics graphics,
    REAL sx,
    REAL sy,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipRotateWorldTransform( 
    PGpGraphics graphics,
    REAL angle,
    GpMatrixOrder order);

/* [custom][entry] */ GpStatus __stdcall GdipGetWorldTransform( 
    PGpGraphics graphics,
    PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipResetPageTransform( 
    PGpGraphics graphics);

/* [custom][entry] */ GpStatus __stdcall GdipGetPageUnit( 
    PGpGraphics graphics,
    GpUnit *unit);

/* [custom][entry] */ GpStatus __stdcall GdipGetPageScale( 
    PGpGraphics graphics,
    REAL *scale);

/* [custom][entry] */ GpStatus __stdcall GdipSetPageUnit( 
    PGpGraphics graphics,
    GpUnit unit);

/* [custom][entry] */ GpStatus __stdcall GdipSetPageScale( 
    PGpGraphics graphics,
    REAL scale);

/* [custom][entry] */ GpStatus __stdcall GdipGetDpiX( 
    PGpGraphics graphics,
    REAL *dpi);

/* [custom][entry] */ GpStatus __stdcall GdipGetDpiY( 
    PGpGraphics graphics,
    REAL *dpi);

/* [custom][entry] */ GpStatus __stdcall GdipTransformPoints( 
    PGpGraphics graphics,
    GpCoordinateSpace destSpace,
    GpCoordinateSpace srcSpace,
    GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipTransformPointsI( 
    PGpGraphics graphics,
    GpCoordinateSpace destSpace,
    GpCoordinateSpace srcSpace,
    GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipGetNearestColor( 
    PGpGraphics graphics,
    ARGB *argb);

/* [custom][entry][helpstring] */ HPALETTE __stdcall GdipCreateHalftonePalette( void);

/* [custom][entry] */ GpStatus __stdcall GdipDrawLine( 
    PGpGraphics graphics,
    PGpPen pen,
    REAL x1,
    REAL y1,
    REAL x2,
    REAL y2);

/* [custom][entry] */ GpStatus __stdcall GdipDrawLineI( 
    PGpGraphics graphics,
    PGpPen pen,
    INT x1,
    INT y1,
    INT x2,
    INT y2);

/* [custom][entry] */ GpStatus __stdcall GdipDrawLines( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawLinesI( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawArc( 
    PGpGraphics graphics,
    PGpPen pen,
    REAL x,
    REAL y,
    REAL width,
    REAL height,
    REAL startAngle,
    REAL sweepAngle);

/* [custom][entry] */ GpStatus __stdcall GdipDrawArcI( 
    PGpGraphics graphics,
    PGpPen pen,
    INT x,
    INT y,
    INT width,
    INT height,
    REAL startAngle,
    REAL sweepAngle);

/* [custom][entry] */ GpStatus __stdcall GdipDrawBezier( 
    PGpGraphics graphics,
    PGpPen pen,
    REAL x1,
    REAL y1,
    REAL x2,
    REAL y2,
    REAL x3,
    REAL y3,
    REAL x4,
    REAL y4);

/* [custom][entry] */ GpStatus __stdcall GdipDrawBezierI( 
    PGpGraphics graphics,
    PGpPen pen,
    INT x1,
    INT y1,
    INT x2,
    INT y2,
    INT x3,
    INT y3,
    INT x4,
    INT y4);

/* [custom][entry] */ GpStatus __stdcall GdipDrawBeziers( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawBeziersI( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawRectangle( 
    PGpGraphics graphics,
    PGpPen pen,
    REAL x,
    REAL y,
    REAL width,
    REAL height);

/* [custom][entry] */ GpStatus __stdcall GdipDrawRectangleI( 
    PGpGraphics graphics,
    PGpPen pen,
    INT x,
    INT y,
    INT width,
    INT height);

/* [custom][entry] */ GpStatus __stdcall GdipDrawRectangles( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpRectF *rects,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawRectanglesI( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpRect *rects,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawEllipse( 
    PGpGraphics graphics,
    PGpPen pen,
    REAL x,
    REAL y,
    REAL width,
    REAL height);

/* [custom][entry] */ GpStatus __stdcall GdipDrawEllipseI( 
    PGpGraphics graphics,
    PGpPen pen,
    INT x,
    INT y,
    INT width,
    INT height);

/* [custom][entry] */ GpStatus __stdcall GdipDrawPie( 
    PGpGraphics graphics,
    PGpPen pen,
    REAL x,
    REAL y,
    REAL width,
    REAL height,
    REAL startAngle,
    REAL sweepAngle);

/* [custom][entry] */ GpStatus __stdcall GdipDrawPieI( 
    PGpGraphics graphics,
    PGpPen pen,
    INT x,
    INT y,
    INT width,
    INT height,
    REAL startAngle,
    REAL sweepAngle);

/* [custom][entry] */ GpStatus __stdcall GdipDrawPolygon( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawPolygonI( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawPath( 
    PGpGraphics graphics,
    PGpPen pen,
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipDrawCurve( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawCurveI( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawCurve2( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPointF *points,
    INT count,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipDrawCurve2I( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPoint *points,
    INT count,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipDrawCurve3( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPointF *points,
    INT count,
    INT offset,
    INT numberOfSegments,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipDrawCurve3I( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPoint *points,
    INT count,
    INT offset,
    INT numberOfSegments,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipDrawClosedCurve( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawClosedCurveI( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawClosedCurve2( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPointF *points,
    INT count,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipDrawClosedCurve2I( 
    PGpGraphics graphics,
    PGpPen pen,
    /* [in] */ const GpPoint *points,
    INT count,
    REAL tension);

/* [custom][entry] */ GpStatus __stdcall GdipGraphicsClear( 
    PGpGraphics graphics,
    ARGB color);

/* [custom][entry] */ GpStatus __stdcall GdipFillRectangle( 
    PGpGraphics graphics,
    PGpBrush brush,
    REAL x,
    REAL y,
    REAL width,
    REAL height);

/* [custom][entry] */ GpStatus __stdcall GdipFillRectangleI( 
    PGpGraphics graphics,
    PGpBrush brush,
    INT x,
    INT y,
    INT width,
    INT height);

/* [custom][entry] */ GpStatus __stdcall GdipFillRectangles( 
    PGpGraphics graphics,
    PGpBrush brush,
    /* [in] */ const GpRectF *rects,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipFillRectanglesI( 
    PGpGraphics graphics,
    PGpBrush brush,
    /* [in] */ const GpRect *rects,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipFillPolygon( 
    PGpGraphics graphics,
    PGpBrush brush,
    /* [in] */ const GpPointF *points,
    INT count,
    GpFillMode fillMode);

/* [custom][entry] */ GpStatus __stdcall GdipFillPolygonI( 
    PGpGraphics graphics,
    PGpBrush brush,
    /* [in] */ const GpPoint *points,
    INT count,
    GpFillMode fillMode);

/* [custom][entry] */ GpStatus __stdcall GdipFillPolygon2( 
    PGpGraphics graphics,
    PGpBrush brush,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipFillPolygon2I( 
    PGpGraphics graphics,
    PGpBrush brush,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipFillEllipse( 
    PGpGraphics graphics,
    PGpBrush brush,
    REAL x,
    REAL y,
    REAL width,
    REAL height);

/* [custom][entry] */ GpStatus __stdcall GdipFillEllipseI( 
    PGpGraphics graphics,
    PGpBrush brush,
    INT x,
    INT y,
    INT width,
    INT height);

/* [custom][entry] */ GpStatus __stdcall GdipFillPie( 
    PGpGraphics graphics,
    PGpBrush brush,
    REAL x,
    REAL y,
    REAL width,
    REAL height,
    REAL startAngle,
    REAL sweepAngle);

/* [custom][entry] */ GpStatus __stdcall GdipFillPieI( 
    PGpGraphics graphics,
    PGpBrush brush,
    INT x,
    INT y,
    INT width,
    INT height,
    REAL startAngle,
    REAL sweepAngle);

/* [custom][entry] */ GpStatus __stdcall GdipFillPath( 
    PGpGraphics graphics,
    PGpBrush brush,
    PGpPath path);

/* [custom][entry] */ GpStatus __stdcall GdipFillClosedCurve( 
    PGpGraphics graphics,
    PGpBrush brush,
    /* [in] */ const GpPointF *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipFillClosedCurveI( 
    PGpGraphics graphics,
    PGpBrush brush,
    /* [in] */ const GpPoint *points,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipFillClosedCurve2( 
    PGpGraphics graphics,
    PGpBrush brush,
    /* [in] */ const GpPointF *points,
    INT count,
    REAL tension,
    GpFillMode fillMode);

/* [custom][entry] */ GpStatus __stdcall GdipFillClosedCurve2I( 
    PGpGraphics graphics,
    PGpBrush brush,
    /* [in] */ const GpPoint *points,
    INT count,
    REAL tension,
    GpFillMode fillMode);

/* [custom][entry] */ GpStatus __stdcall GdipFillRegion( 
    PGpGraphics graphics,
    PGpBrush brush,
    PGpRegion region);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImageFX( 
    PGpGraphics graphics,
    PGpImage image,
    GpRectF *source,
    PGpMatrix xForm,
    PCGpEffect effect,
    PGpImageAttributes imageAttributes,
    GpUnit srcUnit);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImage( 
    PGpGraphics graphics,
    PGpImage image,
    REAL x,
    REAL y);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImageI( 
    PGpGraphics graphics,
    PGpImage image,
    INT x,
    INT y);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImageRect( 
    PGpGraphics graphics,
    PGpImage image,
    REAL x,
    REAL y,
    REAL width,
    REAL height);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImageRectI( 
    PGpGraphics graphics,
    PGpImage image,
    INT x,
    INT y,
    INT width,
    INT height);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImagePoints( 
    PGpGraphics graphics,
    PGpImage image,
    /* [in] */ const GpPointF *dstpoints,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImagePointsI( 
    PGpGraphics graphics,
    PGpImage image,
    /* [in] */ const GpPoint *dstpoints,
    INT count);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImagePointRect( 
    PGpGraphics graphics,
    PGpImage image,
    REAL x,
    REAL y,
    REAL srcx,
    REAL srcy,
    REAL srcwidth,
    REAL srcheight,
    GpUnit srcUnit);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImagePointRectI( 
    PGpGraphics graphics,
    PGpImage image,
    INT x,
    INT y,
    INT srcx,
    INT srcy,
    INT srcwidth,
    INT srcheight,
    GpUnit srcUnit);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImageRectRect( 
    PGpGraphics graphics,
    PGpImage image,
    REAL dstx,
    REAL dsty,
    REAL dstwidth,
    REAL dstheight,
    REAL srcx,
    REAL srcy,
    REAL srcwidth,
    REAL srcheight,
    GpUnit srcUnit,
    /* [in] */ const PGpImageAttributes imageAttributes,
    DrawImageAbort callback,
    void *callbackData);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImageRectRectI( 
    PGpGraphics graphics,
    PGpImage image,
    INT dstx,
    INT dsty,
    INT dstwidth,
    INT dstheight,
    INT srcx,
    INT srcy,
    INT srcwidth,
    INT srcheight,
    GpUnit srcUnit,
    /* [in] */ const PGpImageAttributes imageAttributes,
    DrawImageAbort callback,
    void *callbackData);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImagePointsRect( 
    PGpGraphics graphics,
    PGpImage image,
    /* [in] */ const GpPointF *points,
    INT count,
    REAL srcx,
    REAL srcy,
    REAL srcwidth,
    REAL srcheight,
    GpUnit srcUnit,
    /* [in] */ const PGpImageAttributes imageAttributes,
    DrawImageAbort callback,
    void *callbackData);

/* [custom][entry] */ GpStatus __stdcall GdipDrawImagePointsRectI( 
    PGpGraphics graphics,
    PGpImage image,
    /* [in] */ const GpPoint *points,
    INT count,
    INT srcx,
    INT srcy,
    INT srcwidth,
    INT srcheight,
    GpUnit srcUnit,
    /* [in] */ const PGpImageAttributes imageAttributes,
    DrawImageAbort callback,
    void *callbackData);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileDestPoint( 
    /* [in] */ PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const POINTF *destPoint,
    /* [in] */ EnumerateMetafileProc fnCallback,
    /* [in] */ void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileDestPointI( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const POINT *destPoint,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileDestRect( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const RectF *destRect,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileDestRectI( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const Rect *destRect,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileDestPoints( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const POINTF *destPoints,
    INT count,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileDestPointsI( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const POINT *destPoints,
    INT count,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPoint( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const POINTF *destPoint,
    /* [in] */ const RectF *srcRect,
    Unit srcUnit,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPointI( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const POINT *destPoint,
    /* [in] */ const Rect *srcRect,
    Unit srcUnit,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileSrcRectDestRect( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const RectF *destRect,
    /* [in] */ const RectF *srcRect,
    Unit srcUnit,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileSrcRectDestRectI( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const Rect *destRect,
    /* [in] */ const Rect *srcRect,
    Unit srcUnit,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPoints( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const POINTF *destPoints,
    INT count,
    /* [in] */ const RectF *srcRect,
    Unit srcUnit,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPointsI( 
    PGpGraphics graphics,
    /* [in] */ const PGpMetafile metafile,
    /* [in] */ const POINT *destPoints,
    INT count,
    /* [in] */ const Rect *srcRect,
    Unit srcUnit,
    EnumerateMetafileProc fnCallback,
    void *callbackData,
    /* [in] */ const PGpImageAttributes imageAttributes);

/* [custom][entry] */ GpStatus __stdcall GdipPlayMetafileRecord( 
    /* [in] */ const PGpMetafile metafile,
    EmfPlusRecordType recordType,
    UINT flags,
    UINT dataSize,
    /* [in] */ const BYTE *data);

/* [custom][entry] */ GpStatus __stdcall GdipSetClipGraphics( 
    PGpGraphics graphics,
    PGpGraphics srcgraphics,
    CombineMode combineMode);

/* [custom][entry] */ GpStatus __stdcall GdipSetClipRect( 
    PGpGraphics graphics,
    REAL x,
    REAL y,
    REAL width,
    REAL height,
    CombineMode combineMode);

/* [custom][entry] */ GpStatus __stdcall GdipSetClipRectI( 
    PGpGraphics graphics,
    INT x,
    INT y,
    INT width,
    INT height,
    CombineMode combineMode);

/* [custom][entry] */ GpStatus __stdcall GdipSetClipPath( 
    PGpGraphics graphics,
    PGpPath path,
    CombineMode combineMode);

/* [custom][entry] */ GpStatus __stdcall GdipSetClipRegion( 
    PGpGraphics graphics,
    PGpRegion region,
    CombineMode combineMode);

/* [custom][entry] */ GpStatus __stdcall GdipSetClipHrgn( 
    PGpGraphics graphics,
    HRGN hRgn,
    CombineMode combineMode);

/* [custom][entry] */ GpStatus __stdcall GdipResetClip( 
    PGpGraphics graphics);

/* [custom][entry] */ GpStatus __stdcall GdipTranslateClip( 
    PGpGraphics graphics,
    REAL dx,
    REAL dy);

/* [custom][entry] */ GpStatus __stdcall GdipTranslateClipI( 
    PGpGraphics graphics,
    INT dx,
    INT dy);

/* [custom][entry] */ GpStatus __stdcall GdipGetClip( 
    PGpGraphics graphics,
    PGpRegion region);

/* [custom][entry] */ GpStatus __stdcall GdipGetClipBounds( 
    PGpGraphics graphics,
    GpRectF *rect);

/* [custom][entry] */ GpStatus __stdcall GdipGetClipBoundsI( 
    PGpGraphics graphics,
    GpRect *rect);

/* [custom][entry] */ GpStatus __stdcall GdipIsClipEmpty( 
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipGetVisibleClipBounds( 
    PGpGraphics graphics,
    GpRectF *rect);

/* [custom][entry] */ GpStatus __stdcall GdipGetVisibleClipBoundsI( 
    PGpGraphics graphics,
    GpRect *rect);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisibleClipEmpty( 
    PGpGraphics graphics,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisiblePoint( 
    PGpGraphics graphics,
    REAL x,
    REAL y,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisiblePointI( 
    PGpGraphics graphics,
    INT x,
    INT y,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisibleRect( 
    PGpGraphics graphics,
    REAL x,
    REAL y,
    REAL width,
    REAL height,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipIsVisibleRectI( 
    PGpGraphics graphics,
    INT x,
    INT y,
    INT width,
    INT height,
    BOOL *result);

/* [custom][entry] */ GpStatus __stdcall GdipSaveGraphics( 
    PGpGraphics graphics,
    GraphicsState *state);

/* [custom][entry] */ GpStatus __stdcall GdipRestoreGraphics( 
    PGpGraphics graphics,
    GraphicsState state);

/* [custom][entry] */ GpStatus __stdcall GdipBeginContainer( 
    PGpGraphics graphics,
    /* [in] */ const GpRectF *dstrect,
    /* [in] */ const GpRectF *srcrect,
    GpUnit unit,
    GraphicsContainer *state);

/* [custom][entry] */ GpStatus __stdcall GdipBeginContainerI( 
    PGpGraphics graphics,
    /* [in] */ const GpRect *dstrect,
    /* [in] */ const GpRect *srcrect,
    GpUnit unit,
    GraphicsContainer *state);

/* [custom][entry] */ GpStatus __stdcall GdipBeginContainer2( 
    PGpGraphics graphics,
    GraphicsContainer *state);

/* [custom][entry] */ GpStatus __stdcall GdipEndContainer( 
    PGpGraphics graphics,
    GraphicsContainer state);

/* [custom][entry] */ GpStatus __stdcall GdipGetMetafileHeaderFromWmf( 
    HMETAFILE hWmf,
    /* [in] */ const WmfPlaceableFileHeader *wmfPlaceableFileHeader,
    MetafileHeader *header);

/* [custom][entry] */ GpStatus __stdcall GdipGetMetafileHeaderFromEmf( 
    HENHMETAFILE hEmf,
    MetafileHeader *header);

/* [custom][entry] */ GpStatus __stdcall GdipGetMetafileHeaderFromFile( 
    /* [in] */ LPCOLESTR filename,
    MetafileHeader *header);

/* [custom][entry] */ GpStatus __stdcall GdipGetMetafileHeaderFromStream( 
    IStream *stream,
    MetafileHeader *header);

/* [custom][entry] */ GpStatus __stdcall GdipGetMetafileHeaderFromMetafile( 
    PGpMetafile metafile,
    MetafileHeader *header);

/* [custom][entry] */ GpStatus __stdcall GdipGetHemfFromMetafile( 
    PGpMetafile metafile,
    HENHMETAFILE *hEmf);

/* [custom][entry] */ GpStatus __stdcall GdipCreateStreamOnFile( 
    /* [in] */ LPCOLESTR filename,
    UINT access,
    /* [retval][out] */ IStream **stream);

/* [custom][entry] */ GpStatus __stdcall GdipCreateMetafileFromWmf( 
    HMETAFILE hWmf,
    BOOL deleteWmf,
    /* [in] */ const WmfPlaceableFileHeader *wmfPlaceableFileHeader,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipCreateMetafileFromEmf( 
    HENHMETAFILE hEmf,
    BOOL deleteEmf,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipCreateMetafileFromFile( 
    /* [in] */ LPCOLESTR file,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipCreateMetafileFromWmfFile( 
    /* [in] */ LPCOLESTR file,
    /* [in] */ const WmfPlaceableFileHeader *wmfPlaceableFileHeader,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipCreateMetafileFromStream( 
    IStream *stream,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipRecordMetafile( 
    HDC referenceHdc,
    EmfType type,
    /* [in] */ const GpRectF *frameRect,
    MetafileFrameUnit frameUnit,
    /* [in] */ LPCOLESTR description,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipRecordMetafileI( 
    HDC referenceHdc,
    EmfType type,
    /* [in] */ const GpRect *frameRect,
    MetafileFrameUnit frameUnit,
    /* [in] */ LPCOLESTR description,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipRecordMetafileFileName( 
    /* [in] */ LPCOLESTR fileName,
    HDC referenceHdc,
    EmfType type,
    /* [in] */ const GpRectF *frameRect,
    MetafileFrameUnit frameUnit,
    /* [in] */ LPCOLESTR description,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipRecordMetafileFileNameI( 
    /* [in] */ LPCOLESTR fileName,
    HDC referenceHdc,
    EmfType type,
    /* [in] */ const GpRect *frameRect,
    MetafileFrameUnit frameUnit,
    /* [in] */ LPCOLESTR description,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipRecordMetafileStream( 
    IStream *stream,
    HDC referenceHdc,
    EmfType type,
    /* [in] */ const GpRectF *frameRect,
    MetafileFrameUnit frameUnit,
    /* [in] */ LPCOLESTR description,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipRecordMetafileStreamI( 
    IStream *stream,
    HDC referenceHdc,
    EmfType type,
    /* [in] */ const GpRect *frameRect,
    MetafileFrameUnit frameUnit,
    /* [in] */ LPCOLESTR description,
    /* [retval][out] */ PGpMetafile *metafile);

/* [custom][entry] */ GpStatus __stdcall GdipSetMetafileDownLevelRasterizationLimit( 
    PGpMetafile metafile,
    UINT metafileRasterizationLimitDpi);

/* [custom][entry] */ GpStatus __stdcall GdipGetMetafileDownLevelRasterizationLimit( 
    /* [in] */ const PGpMetafile metafile,
    UINT *metafileRasterizationLimitDpi);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageDecodersSize( 
    UINT *numDecoders,
    UINT *size);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageDecoders( 
    UINT numDecoders,
    UINT size,
    ImageCodecInfo *decoders);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageEncodersSize( 
    /* [out] */ UINT *numEncoders,
    /* [out] */ UINT *size);

/* [custom][entry] */ GpStatus __stdcall GdipGetImageEncoders( 
    /* [in] */ UINT numEncoders,
    /* [in] */ UINT size,
    /* [out][in] */ ImageCodecInfo *encoders);

/* [custom][entry] */ GpStatus __stdcall GdipComment( 
    PGpGraphics graphics,
    UINT sizeData,
    /* [in] */ const BYTE *data);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipCreateFontFamilyFromName( 
    /* [in] */ LPCOLESTR name,
    /* [in] */ PGpFontCollection fontCollection,
    /* [retval][out] */ PGpFontFamily *FontFamily);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeleteFontFamily( 
    PGpFontFamily FontFamily);

/* [custom][entry] */ GpStatus __stdcall GdipCloneFontFamily( 
    PGpFontFamily FontFamily,
    /* [retval][out] */ PGpFontFamily *clonedFontFamily);

/* [custom][entry] */ GpStatus __stdcall GdipGetGenericFontFamilySansSerif( 
    /* [retval][out] */ PGpFontFamily *nativeFamily);

/* [custom][entry] */ GpStatus __stdcall GdipGetGenericFontFamilySerif( 
    /* [retval][out] */ PGpFontFamily *nativeFamily);

/* [custom][entry] */ GpStatus __stdcall GdipGetGenericFontFamilyMonospace( 
    /* [retval][out] */ PGpFontFamily *nativeFamily);

/* [custom][entry] */ GpStatus __stdcall GdipGetFamilyName( 
    /* [in][in] */ const PGpFontFamily family,
    /* [custom][out] */ WCHAR name[ 32 ],
    /* [in] */ LANGID language);

/* [custom][entry] */ GpStatus __stdcall GdipIsStyleAvailable( 
    /* [in] */ const PGpFontFamily family,
    INT style,
    /* [retval][out] */ BOOL *IsStyleAvailable);

/* [custom][entry] */ GpStatus __stdcall GdipFontCollectionEnumerable( 
    PGpFontCollection fontCollection,
    PGpGraphics graphics,
    /* [out] */ INT *numFound);

/* [custom][entry] */ GpStatus __stdcall GdipFontCollectionEnumerate( 
    PGpFontCollection fontCollection,
    INT numSought,
    PGpFontFamily gpfamilies[  ],
    /* [out] */ INT *numFound,
    PGpGraphics graphics);

/* [custom][entry] */ GpStatus __stdcall GdipGetEmHeight( 
    /* [in] */ const PGpFontFamily family,
    INT style,
    /* [retval][out] */ UINT16 *EmHeight);

/* [custom][entry] */ GpStatus __stdcall GdipGetCellAscent( 
    /* [in] */ const PGpFontFamily family,
    INT style,
    /* [retval][out] */ UINT16 *CellAscent);

/* [custom][entry] */ GpStatus __stdcall GdipGetCellDescent( 
    /* [in] */ const PGpFontFamily family,
    INT style,
    /* [retval][out] */ UINT16 *CellDescent);

/* [custom][entry] */ GpStatus __stdcall GdipGetLineSpacing( 
    /* [in] */ const PGpFontFamily family,
    INT style,
    /* [retval][out] */ UINT16 *LineSpacing);

/* [custom][entry] */ GpStatus __stdcall GdipCreateFontFromDC( 
    HDC hdc,
    /* [retval][out] */ PGpFont *font);

/* [custom][entry] */ GpStatus __stdcall GdipCreateFontFromLogfontA( 
    HDC hdc,
    /* [in] */ const LOGFONTA *logfont,
    /* [retval][out] */ PGpFont *font);

/* [custom][entry] */ GpStatus __stdcall GdipCreateFontFromLogfontW( 
    HDC hdc,
    /* [in] */ const LOGFONTW *logfont,
    /* [retval][out] */ PGpFont *font);

/* [custom][entry] */ GpStatus __stdcall GdipCreateFont( 
    /* [in] */ const PGpFontFamily fontFamily,
    REAL emSize,
    INT style,
    Unit unit,
    /* [retval][out] */ PGpFont *font);

/* [custom][entry] */ GpStatus __stdcall GdipCloneFont( 
    PGpFont font,
    /* [retval][out] */ PGpFont *cloneFont);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeleteFont( 
    PGpFont font);

/* [custom][entry] */ GpStatus __stdcall GdipGetFamily( 
    PGpFont font,
    /* [retval][out] */ PGpFontFamily *family);

/* [custom][entry] */ GpStatus __stdcall GdipGetFontStyle( 
    PGpFont font,
    FontStyle *style);

/* [custom][entry] */ GpStatus __stdcall GdipGetFontSize( 
    PGpFont font,
    REAL *size);

/* [custom][entry] */ GpStatus __stdcall GdipGetFontUnit( 
    PGpFont font,
    Unit *unit);

/* [custom][entry] */ GpStatus __stdcall GdipGetFontHeight( 
    /* [in] */ const PGpFont font,
    /* [in] */ const PGpGraphics graphics,
    REAL *height);

/* [custom][entry] */ GpStatus __stdcall GdipGetFontHeightGivenDPI( 
    /* [in] */ const PGpFont font,
    REAL dpi,
    REAL *height);

/* [custom][entry] */ GpStatus __stdcall GdipGetLogFontA( 
    PGpFont font,
    PGpGraphics graphics,
    LOGFONTA *logfontA);

/* [custom][entry] */ GpStatus __stdcall GdipGetLogFontW( 
    PGpFont font,
    PGpGraphics graphics,
    LOGFONTW *logfontW);

/* [custom][entry] */ GpStatus __stdcall GdipNewInstalledFontCollection( 
    /* [retval][out] */ PGpFontCollection *fontCollection);

/* [custom][entry] */ GpStatus __stdcall GdipNewPrivateFontCollection( 
    /* [retval][out] */ PGpFontCollection *fontCollection);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeletePrivateFontCollection( 
    /* [retval][out] */ PGpFontCollection *fontCollection);

/* [custom][entry] */ GpStatus __stdcall GdipGetFontCollectionFamilyCount( 
    PGpFontCollection fontCollection,
    INT *numFound);

/* [custom][entry] */ GpStatus __stdcall GdipGetFontCollectionFamilyList( 
    PGpFontCollection fontCollection,
    INT numSought,
    PGpFontFamily gpfamilies[  ],
    INT *numFound);

/* [custom][entry] */ GpStatus __stdcall GdipPrivateAddFontFile( 
    PGpFontCollection fontCollection,
    /* [in] */ LPCOLESTR filename);

/* [custom][entry] */ GpStatus __stdcall GdipPrivateAddMemoryFont( 
    PGpFontCollection fontCollection,
    /* [in] */ const void *memory,
    INT length);

/* [custom][entry] */ GpStatus __stdcall GdipDrawString( 
    PGpGraphics graphics,
    /* [in] */ LPCOLESTR str,
    INT length,
    /* [in] */ const PGpFont font,
    /* [in] */ const RectF *layoutRect,
    /* [in] */ const PGpStringFormat stringFormat,
    /* [in] */ const PGpBrush brush);

/* [custom][entry] */ GpStatus __stdcall GdipMeasureString( 
    PGpGraphics graphics,
    /* [in] */ LPCOLESTR str,
    INT length,
    /* [in] */ const PGpFont font,
    /* [in] */ const RectF *layoutRect,
    /* [in] */ const PGpStringFormat stringFormat,
    RectF *boundingBox,
    INT *codepointsFitted,
    INT *linesFilled);

/* [custom][entry] */ GpStatus __stdcall GdipMeasureCharacterRanges( 
    PGpGraphics graphics,
    /* [in] */ LPCOLESTR str,
    INT length,
    /* [in] */ const PGpFont font,
    /* [in] */ const RectF *layoutRect,
    /* [in] */ const PGpStringFormat stringFormat,
    INT regionCount,
    /* [retval][out] */ PGpRegion *regions);

/* [custom][entry] */ GpStatus __stdcall GdipDrawDriverString( 
    PGpGraphics graphics,
    /* [in] */ const UINT16 *text,
    INT length,
    /* [in] */ const PGpFont font,
    /* [in] */ const PGpBrush brush,
    /* [in] */ const POINTF *positions,
    INT flags,
    /* [in] */ const PGpMatrix matrix);

/* [custom][entry] */ GpStatus __stdcall GdipMeasureDriverString( 
    PGpGraphics graphics,
    /* [in] */ const UINT16 *text,
    INT length,
    /* [in] */ const PGpFont font,
    /* [in] */ const POINTF *positions,
    INT flags,
    /* [in] */ const PGpMatrix matrix,
    RectF *boundingBox);

/* [custom][entry] */ GpStatus __stdcall GdipCreateStringFormat( 
    INT formatAttributes,
    LANGID language,
    /* [retval][out] */ PGpStringFormat *format);

/* [custom][entry] */ GpStatus __stdcall GdipStringFormatGetGenericDefault( 
    /* [retval][out] */ PGpStringFormat *format);

/* [custom][entry] */ GpStatus __stdcall GdipStringFormatGetGenericTypographic( 
    /* [retval][out] */ PGpStringFormat *format);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeleteStringFormat( 
    PGpStringFormat format);

/* [custom][entry] */ GpStatus __stdcall GdipCloneStringFormat( 
    /* [in] */ const PGpStringFormat format,
    /* [retval][out] */ PGpStringFormat *newFormat);

/* [custom][entry] */ GpStatus __stdcall GdipSetStringFormatFlags( 
    PGpStringFormat format,
    INT flags);

/* [custom][entry] */ GpStatus __stdcall GdipGetStringFormatFlags( 
    /* [in] */ const PGpStringFormat format,
    INT *flags);

/* [custom][entry] */ GpStatus __stdcall GdipSetStringFormatAlign( 
    PGpStringFormat format,
    StringAlignment align);

/* [custom][entry] */ GpStatus __stdcall GdipGetStringFormatAlign( 
    /* [in] */ const PGpStringFormat format,
    StringAlignment *align);

/* [custom][entry] */ GpStatus __stdcall GdipSetStringFormatLineAlign( 
    PGpStringFormat format,
    StringAlignment align);

/* [custom][entry] */ GpStatus __stdcall GdipGetStringFormatLineAlign( 
    /* [in] */ const PGpStringFormat format,
    StringAlignment *align);

/* [custom][entry] */ GpStatus __stdcall GdipSetStringFormatTrimming( 
    PGpStringFormat format,
    StringTrimming trimming);

/* [custom][entry] */ GpStatus __stdcall GdipGetStringFormatTrimming( 
    /* [in] */ const PGpStringFormat format,
    StringTrimming *trimming);

/* [custom][entry] */ GpStatus __stdcall GdipSetStringFormatHotkeyPrefix( 
    PGpStringFormat format,
    INT hotkeyPrefix);

/* [custom][entry] */ GpStatus __stdcall GdipGetStringFormatHotkeyPrefix( 
    /* [in] */ const PGpStringFormat format,
    INT *hotkeyPrefix);

/* [custom][entry] */ GpStatus __stdcall GdipSetStringFormatTabStops( 
    PGpStringFormat format,
    REAL firstTabOffset,
    INT count,
    /* [in] */ const REAL *tabStops);

/* [custom][entry] */ GpStatus __stdcall GdipGetStringFormatTabStops( 
    /* [in] */ const PGpStringFormat format,
    INT count,
    REAL *firstTabOffset,
    REAL *tabStops);

/* [custom][entry] */ GpStatus __stdcall GdipGetStringFormatTabStopCount( 
    /* [in] */ const PGpStringFormat format,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipSetStringFormatDigitSubstitution( 
    PGpStringFormat format,
    LANGID language,
    StringDigitSubstitute substitute);

/* [custom][entry] */ GpStatus __stdcall GdipGetStringFormatDigitSubstitution( 
    /* [in] */ const PGpStringFormat format,
    LANGID *language,
    StringDigitSubstitute *substitute);

/* [custom][entry] */ GpStatus __stdcall GdipGetStringFormatMeasurableCharacterRangeCount( 
    /* [in] */ const PGpStringFormat format,
    INT *count);

/* [custom][entry] */ GpStatus __stdcall GdipSetStringFormatMeasurableCharacterRanges( 
    PGpStringFormat format,
    INT rangeCount,
    /* [in] */ const CharacterRange *ranges);

/* [custom][entry] */ GpStatus __stdcall GdipCreateCachedBitmap( 
    PGpBitmap bitmap,
    PGpGraphics graphics,
    /* [retval][out] */ PGpCachedBitmap *cachedBitmap);

/* [custom][entry] */ GpStatus_NoThrow __stdcall GdipDeleteCachedBitmap( 
    PGpCachedBitmap cachedBitmap);

/* [custom][entry] */ GpStatus __stdcall GdipDrawCachedBitmap( 
    PGpGraphics graphics,
    PGpCachedBitmap cachedBitmap,
    INT x,
    INT y);

/* [custom][entry] */ UINT __stdcall GdipEmfToWmfBits( 
    HENHMETAFILE hemf,
    UINT cbData16,
    LPBYTE pData16,
    INT iMapMode,
    INT eFlags);

/* [custom][entry] */ GpStatus __stdcall GdipSetImageAttributesCachedBackground( 
    PGpImageAttributes imageattr,
    BOOL enableFlag);

/* [custom][entry] */ GpStatus __stdcall GdipTestControl( 
    GpTestControlEnum cntrl,
    void *param);

/* [custom][entry] */ GpStatus __stdcall GdiplusNotificationHook( 
    ULONG_PTR *token);

/* [custom][entry] */ void __stdcall GdiplusNotificationUnhook( 
    ULONG_PTR token);

/* [custom][entry] */ GpStatus __stdcall GdiplusStartup( 
    /* [out] */ ULONG_PTR *token,
    /* [in] */ const GdiplusStartupInput *input,
    /* [out] */ GdiplusStartupOutput *output);

/* [custom][entry] */ void __stdcall GdiplusShutdown( 
    /* [in] */ ULONG_PTR token);

/* [custom][entry] */ GpStatus __stdcall GdipConvertToEmfPlus( 
    PGpGraphics refGraphics,
    PGpMetafile metafile,
    INT *conversionFailureFlag,
    EmfType emfType,
    WCHAR *description,
    /* [retval][out] */ PGpMetafile *out_metafile);

/* [custom][entry] */ GpStatus __stdcall GdipConvertToEmfPlusToFile( 
    PGpGraphics refGraphics,
    PGpMetafile metafile,
    INT *conversionFailureFlag,
    WCHAR *filename,
    EmfType emfType,
    WCHAR *description,
    /* [retval][out] */ PGpMetafile *out_metafile);

/* [custom][entry] */ GpStatus __stdcall GdipConvertToEmfPlusToStream( 
    PGpGraphics refGraphics,
    PGpMetafile metafile,
    INT *conversionFailureFlag,
    IStream *stream,
    EmfType emfType,
    WCHAR *description,
    /* [retval][out] */ PGpMetafile *out_metafile);

#endif /* __Gdiplus_MODULE_DEFINED__ */
#endif /* __Gdiplus_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


