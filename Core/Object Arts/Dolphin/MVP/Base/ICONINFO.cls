"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #ICONINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_fIcon _OffsetOf_hbmColor _OffsetOf_hbmMask _OffsetOf_xHotspot _OffsetOf_yHotspot'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICONINFO guid: (GUID fromString: '{87b4c5f5-026e-11d3-9fd7-00a0cc3e4a32}')!
ICONINFO addClassConstant: '_OffsetOf_fIcon' value: 16r0!
ICONINFO addClassConstant: '_OffsetOf_hbmColor' value: 16r10!
ICONINFO addClassConstant: '_OffsetOf_hbmMask' value: 16rC!
ICONINFO addClassConstant: '_OffsetOf_xHotspot' value: 16r4!
ICONINFO addClassConstant: '_OffsetOf_yHotspot' value: 16r8!
ICONINFO comment: ''!
!ICONINFO categoriesForClass!External-Data-Structured-Win32! !
!ICONINFO methodsFor!

extent
	"Answer the extent of the icon descibed by the receiver in pels.
	Implementation Note: This is determined from the extent of the foreground bitmap. 
	In order to avoid a dependency on bitmap (Icons are always used in Dolphin 
	applications, but bitmaps might not be) we open code access to the bitmaps
	extent."

	| bitmapInfo |
	bitmapInfo := BITMAP new.
	GDILibrary default
		getObject: self hbmColor
		cbBuffer: bitmapInfo byteSize
		lpvObject: bitmapInfo.
	^bitmapInfo extent!

free
	"Free any external resources owner by the receiver."

	| hbm |
	self beUnfinalizable.
	hbm := self hbmColor.
	hbm isNull 
		ifFalse: 
			[GDILibrary default deleteObject: hbm.
			self hbmColor: 0].
	hbm := self hbmMask.
	hbm isNull ifTrue: [^self].
	GDILibrary default deleteObject: hbm.
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
!ICONINFO categoriesForMethods!
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

!ICONINFO class methodsFor!

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
		defineField: #hbmColor type: HANDLEField new

!

getFieldNames
	^#(#fIcon #xHotspot #yHotspot #hbmMask #hbmColor)! !
!ICONINFO class categoriesForMethods!
defineFields!development!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

