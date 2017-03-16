"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #ICONINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICONINFO guid: (GUID fromString: '{87b4c5f5-026e-11d3-9fd7-00a0cc3e4a32}')!
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
	"Answer the receiver's hbmColor field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hbmColor)) asExternalHandle!

hbmColor: anObject 
	"Set the receiver's hbmColor field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hbmColor) put: anObject!

hbmMask
	"Answer the receiver's hbmMask field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hbmMask)) asExternalHandle!

hbmMask: anObject 
	"Set the receiver's hbmMask field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hbmMask) put: anObject!

initialize
	"Private - Initialize the receiver.
	Mark as finalizable because the GetIconInfo() function creates bitmaps in order to return
	the handles!!"

	self beFinalizable!

xHotspot
	"Answer the receiver's xHotspot field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #xHotspot)!

yHotspot
	"Answer the receiver's yHotspot field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #yHotspot)! !
!ICONINFO categoriesFor: #extent!accessing!public! !
!ICONINFO categoriesFor: #free!public!realizing/unrealizing! !
!ICONINFO categoriesFor: #hbmColor!**compiled accessors**!public! !
!ICONINFO categoriesFor: #hbmColor:!**compiled accessors**!public! !
!ICONINFO categoriesFor: #hbmMask!**compiled accessors**!public! !
!ICONINFO categoriesFor: #hbmMask:!**compiled accessors**!public! !
!ICONINFO categoriesFor: #initialize!initializing!private! !
!ICONINFO categoriesFor: #xHotspot!**compiled accessors**!public! !
!ICONINFO categoriesFor: #yHotspot!**compiled accessors**!public! !

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

! !
!ICONINFO class categoriesFor: #defineFields!development!public! !

