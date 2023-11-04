"Filed out from Dolphin Smalltalk"!

External.FinalizableStructure
	subclass: #'OS.ICONINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ICONINFO_Size' -> 16r14.
			'_OffsetOf_fIcon' -> 16r0.
			'_OffsetOf_hbmColor' -> 16r10.
			'_OffsetOf_hbmMask' -> 16rC.
			'_OffsetOf_xHotspot' -> 16r4.
			'_OffsetOf_yHotspot' -> 16r8
		}!
OS.ICONINFO guid: (Core.GUID fromString: '{87b4c5f5-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.ICONINFO comment: ''!
!OS.ICONINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.ICONINFO methodsFor!

extent
	"Answer the extent of the icon described by the receiver in pels."

	"Implementation Note: This is determined from the extent of the foreground bitmap. See [ICONINFO](https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-iconinfo) for details.
	In order to avoid a dependency on Bitmap/BITMAP (Icons are always used in Dolphin applications, but bitmaps might not be) we open code access to the bitmap's extent."

	| bitmapInfo |
	bitmapInfo := ByteArray newFixed: BITMAP._BITMAP_Size.
	^self hbmColor
		ifNotNil: 
			[:hbmColor |
			Gdi32
				getObjectW: hbmColor
				cbBuffer: BITMAP._BITMAP_Size
				lpvObject: bitmapInfo.
			(bitmapInfo int32AtOffset: BITMAP._OffsetOf_bmWidth)
				@ (bitmapInfo int32AtOffset: BITMAP._OffsetOf_bmHeight)]
		ifNil: 
			[Gdi32
				getObjectW: self hbmMask
				cbBuffer: bitmapInfo byteSize
				lpvObject: bitmapInfo.
			(bitmapInfo int32AtOffset: BITMAP._OffsetOf_bmWidth)
				@ ((bitmapInfo int32AtOffset: BITMAP._OffsetOf_bmHeight) bitShift: -1)]!

fIcon
	"Answer the <Boolean> value of the receiver's 'fIcon' field."

	^(bytes uint32AtOffset: _OffsetOf_fIcon) asBoolean!

fIcon: aBoolean
	"Set the receiver's 'fIcon' field to the value of the argument, aBoolean"

	bytes uint32AtOffset: _OffsetOf_fIcon put: aBoolean asParameter!

hbmColor
	"Answer the <Handle> value of the receiver's 'hbmColor' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hbmColor) asExternalHandle!

hbmColor: aHandle
	"Set the receiver's 'hbmColor' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbmColor put: aHandle!

hbmMask
	"Answer the <Handle> value of the receiver's 'hbmMask' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hbmMask) asExternalHandle!

hbmMask: aHandle
	"Set the receiver's 'hbmMask' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbmMask put: aHandle!

hotspot
	^Graphics.Point x: (bytes uint32AtOffset: _OffsetOf_xHotspot)
		y: (bytes uint32AtOffset: _OffsetOf_yHotspot)!

xHotspot
	"Answer the <Integer> value of the receiver's 'xHotspot' field."

	^bytes uint32AtOffset: _OffsetOf_xHotspot!

xHotspot: anInteger
	"Set the receiver's 'xHotspot' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_xHotspot put: anInteger!

yHotspot
	"Answer the <Integer> value of the receiver's 'yHotspot' field."

	^bytes uint32AtOffset: _OffsetOf_yHotspot!

yHotspot: anInteger
	"Set the receiver's 'yHotspot' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_yHotspot put: anInteger! !
!OS.ICONINFO categoriesForMethods!
extent!accessing!public! !
fIcon!**compiled accessors**!public! !
fIcon:!**compiled accessors**!public! !
hbmColor!**compiled accessors**!public! !
hbmColor:!**compiled accessors**!public! !
hbmMask!**compiled accessors**!public! !
hbmMask:!**compiled accessors**!public! !
hotspot!accessing!public! !
xHotspot!**compiled accessors**!public! !
xHotspot:!**compiled accessors**!public! !
yHotspot!**compiled accessors**!public! !
yHotspot:!**compiled accessors**!public! !
!

!OS.ICONINFO class methodsFor!

byteSize
	^_ICONINFO_Size!

clear: bytesOrAddress
	"Free external resources referenced by the structure of the receiver's element type at the specified address."

	##({ _OffsetOf_hbmColor. _OffsetOf_hbmMask }) do: 
			[:offset |
			| hbitmap |
			hbitmap := bytesOrAddress uintPtrAtOffset: offset.
			hbitmap == 0 ifFalse: [Gdi32 deleteObject: hbitmap]]!

defineFields
	"Define the fields of the Win32 ICONINFO structure.

		ICONINFO compileDefinition

		typedef struct _ICONINFO { // ii 
			BOOL    fIcon; 
			DWORD   xHotspot; 
			DWORD   yHotspot; 
			HBITMAP hbmMask; 
			HBITMAP hbmColor; 
		} ICONINFO;"

	self
		defineField: #fIcon type: BOOLField new;
		defineField: #xHotspot type: UInt32Field new;
		defineField: #yHotspot type: UInt32Field new;
		defineField: #hbmMask type: HANDLEField new;
		defineField: #hbmColor type: HANDLEField new!

getFieldNames
	^#(#fIcon #xHotspot #yHotspot #hbmMask #hbmColor)! !
!OS.ICONINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
clear:!public!realizing/unrealizing! !
defineFields!development!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

