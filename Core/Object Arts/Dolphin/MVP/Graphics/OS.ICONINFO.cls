"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.ICONINFO'
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
	In order to avoid a dependency on bitmap (Icons are always used in Dolphin applications, but bitmaps might not be) we open code access to the bitmap's extent."

	| bitmapInfo |
	bitmapInfo := BITMAP newBuffer.
	^self hbmColor
		ifNotNil: 
			[:hbmColor |
			Gdi32
				getObject: hbmColor
				cbBuffer: bitmapInfo byteSize
				lpvObject: bitmapInfo.
			bitmapInfo extent]
		ifNil: 
			[Gdi32
				getObject: self hbmMask
				cbBuffer: bitmapInfo byteSize
				lpvObject: bitmapInfo.
			bitmapInfo bmWidth @ (bitmapInfo bmHeight bitShift: -1)]!

free
	"Free any external resources owner by the receiver."

	| hbm |
	self beUnfinalizable.
	hbm := self hbmColor.
	hbm isNull
		ifFalse: 
			[Gdi32 deleteObject: hbm.
			self hbmColor: 0].
	hbm := self hbmMask.
	hbm isNull ifTrue: [^self].
	Gdi32 deleteObject: hbm.
	self hbmMask: 0!

hbmColor
	"Answer the <ExternalHandle> value of the receiver's 'hbmColor' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hbmColor) asExternalHandle!

hbmColor: anExternalHandle
	"Set the receiver's 'hbmColor' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbmColor put: anExternalHandle!

hbmMask
	"Answer the <ExternalHandle> value of the receiver's 'hbmMask' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hbmMask) asExternalHandle!

hbmMask: anExternalHandle
	"Set the receiver's 'hbmMask' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbmMask put: anExternalHandle!

initialize
	"Private - Initialize the receiver.
	Mark as finalizable because the GetIconInfo() function creates bitmaps in order to return
	the handles!!"

	self beFinalizable!

xHotspot
	"Answer the <Integer> value of the receiver's 'xHotspot' field."

	^bytes dwordAtOffset: _OffsetOf_xHotspot!

yHotspot
	"Answer the <Integer> value of the receiver's 'yHotspot' field."

	^bytes dwordAtOffset: _OffsetOf_yHotspot! !
!OS.ICONINFO categoriesForMethods!
extent!accessing!public! !
free!public!realizing/unrealizing! !
hbmColor!**compiled accessors**!public! !
hbmColor:!**compiled accessors**!public! !
hbmMask!**compiled accessors**!public! !
hbmMask:!**compiled accessors**!public! !
initialize!initializing!private! !
xHotspot!**compiled accessors**!public! !
yHotspot!**compiled accessors**!public! !
!

!OS.ICONINFO class methodsFor!

byteSize
	^_ICONINFO_Size!

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
		defineField: #fIcon type: BOOLField readOnly beUncompiled;
		defineField: #xHotspot type: DWORDField readOnly;
		defineField: #yHotspot type: DWORDField readOnly;
		defineField: #hbmMask type: HANDLEField new;
		defineField: #hbmColor type: HANDLEField new!

getFieldNames
	^#(#fIcon #xHotspot #yHotspot #hbmMask #hbmColor)! !
!OS.ICONINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!development!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

