"Filed out from Dolphin Smalltalk 7"!

CCITEM subclass: #HDITEM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HDITEM guid: (GUID fromString: '{cff5da39-bb38-4499-9527-66449b212b87}')!
HDITEM comment: ''!
!HDITEM categoriesForClass!Unclassified! !
!HDITEM methodsFor!

cchTextMax
	"Answer the receiver's cchTextMax field as a Smalltalk object."

	^(bytes sdwordAtOffset: 16)!

cchTextMax: anObject
	"Set the receiver's cchTextMax field to the value of anObject."

	bytes sdwordAtOffset: 16 put: anObject!

cxy
	"Answer the receiver's cxy field as a Smalltalk object."

	^(bytes sdwordAtOffset: 4)!

cxy: anObject
	"Set the receiver's cxy field to the value of anObject."

	bytes sdwordAtOffset: 4 put: anObject!

dwState
	"Answer the receiver's dwState field as a Smalltalk object."

	^self shouldNotImplement!

dwState: anObject
	"Set the receiver's dwState field to the value of anObject."

	^self shouldNotImplement!

fmt
	"Answer the receiver's fmt field as a Smalltalk object."

	^(bytes sdwordAtOffset: 20)!

fmt: anObject
	"Set the receiver's fmt field to the value of anObject."

	bytes sdwordAtOffset: 20 put: anObject!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self shouldNotImplement!

hbm
	"Answer the receiver's hbm field as a Smalltalk object."

	^(bytes dwordAtOffset: 12) asExternalHandle!

hbm: anObject
	"Set the receiver's hbm field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

iImage
	"Answer the receiver's iImage field as a Smalltalk object."

	^(bytes sdwordAtOffset: 28)!

iImage: anObject
	"Set the receiver's iImage field to the value of anObject."

	bytes sdwordAtOffset: 28 put: anObject!

imageValidMask
	"Private - Answer the bit mask the receiver uses to denote that the iImage
	field has valid contents."

	^16r0020 "HDI_IMAGE"!

iOrder
	"Answer the receiver's iOrder field as a Smalltalk object."

	^(bytes sdwordAtOffset: 32)!

iOrder: anObject
	"Set the receiver's iOrder field to the value of anObject."

	bytes sdwordAtOffset: 32 put: anObject!

lParam
	"Answer the receiver's lParam field as a Smalltalk object."

	^(bytes dwordAtOffset: 24)!

lParam: anObject
	"Set the receiver's lParam field to the value of anObject."

	bytes dwordAtOffset: 24 put: anObject!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^16r8 "HDI_LPARAM"!

pszText
	"Answer the receiver's pszText field as a Smalltalk object."

	^String fromAddress: (bytes sdwordAtOffset: 8)!

pszText: anObject
	"Set the receiver's pszText field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject yourAddress!

pvFilter
	"Answer the receiver's pvFilter field as a Smalltalk object."

	^(bytes dwordAtOffset: 40)!

pvFilter: anObject
	"Set the receiver's pvFilter field to the value of anObject."

	bytes dwordAtOffset: 40 put: anObject!

stateMask: anObject
	"Set the receiver's stateMask field to the value of anObject."

	^self shouldNotImplement!

stateValidMask
	"Private - Answer the bit mask the receiver uses to denote that the dwState
	field has valid contents."

	^self shouldNotImplement!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^8!

textValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^16r0002	"HDI_TEXT"!

type
	"Answer the receiver's type field as a Smalltalk object."

	^(bytes dwordAtOffset: 36)!

type: anObject
	"Set the receiver's type field to the value of anObject."

	bytes dwordAtOffset: 36 put: anObject! !
!HDITEM categoriesFor: #cchTextMax!**compiled accessors**!public! !
!HDITEM categoriesFor: #cchTextMax:!**compiled accessors**!public! !
!HDITEM categoriesFor: #cxy!**compiled accessors**!public! !
!HDITEM categoriesFor: #cxy:!**compiled accessors**!public! !
!HDITEM categoriesFor: #dwState!**compiled accessors**!public! !
!HDITEM categoriesFor: #dwState:!**compiled accessors**!public! !
!HDITEM categoriesFor: #fmt!**compiled accessors**!public! !
!HDITEM categoriesFor: #fmt:!**compiled accessors**!public! !
!HDITEM categoriesFor: #handle!accessing!public! !
!HDITEM categoriesFor: #hbm!**compiled accessors**!public! !
!HDITEM categoriesFor: #hbm:!**compiled accessors**!public! !
!HDITEM categoriesFor: #iImage!**compiled accessors**!public! !
!HDITEM categoriesFor: #iImage:!**compiled accessors**!public! !
!HDITEM categoriesFor: #imageValidMask!constants!private! !
!HDITEM categoriesFor: #iOrder!**compiled accessors**!public! !
!HDITEM categoriesFor: #iOrder:!**compiled accessors**!public! !
!HDITEM categoriesFor: #lParam!**compiled accessors**!public! !
!HDITEM categoriesFor: #lParam:!accessing!public! !
!HDITEM categoriesFor: #paramValidMask!constants!private! !
!HDITEM categoriesFor: #pszText!**compiled accessors**!public! !
!HDITEM categoriesFor: #pszText:!**compiled accessors**!public! !
!HDITEM categoriesFor: #pvFilter!**compiled accessors**!public! !
!HDITEM categoriesFor: #pvFilter:!**compiled accessors**!public! !
!HDITEM categoriesFor: #stateMask:!**compiled accessors**!public! !
!HDITEM categoriesFor: #stateValidMask!constants!private! !
!HDITEM categoriesFor: #textPointerOffset!constants!private! !
!HDITEM categoriesFor: #textValidMask!constants!private! !
!HDITEM categoriesFor: #type!**compiled accessors**!public! !
!HDITEM categoriesFor: #type:!**compiled accessors**!public! !

!HDITEM class methodsFor!

defineFields
	"Define the fields of the MENUITEMINFOA structure.
		HDITEM compileDefinition
	
		typedef 		struct _HDITEM {
			UINT    mask; 
			int     cxy; 
			LPTSTR  pszText; 
			HBITMAP hbm; 
			int     cchTextMax; 
			int     fmt; 
			LPARAM  lParam; 
			#if (_WIN32_IE >= 0x0300)
				int     iImage;
				int     iOrder;
			#endif
			#if (_WIN32_IE >= 0x0500)
				UINT    type;
				LPVOID  pvFilter;
			#endif
		} HDITEM,  *LPHDITEM;
	"

	self
		defineField: #mask type: DWORDField new offset: 0;	"Rename to override superclass accessor???"
		defineField: #cxy type: SDWORDField new offset: 4;
		defineField: #pszText type: (PointerField type: String) offset: 8;
		defineField: #hbm type: HANDLEField new offset: 12;
		defineField: #cchTextMax type: SDWORDField new offset: 16;
		defineField: #fmt type: SDWORDField new offset: 20;
		defineField: #lParam type: DWORDField new offset: 24;
		defineField: #iImage type: SDWORDField new offset: 28;
		defineField: #iOrder type: SDWORDField new offset: 32;
		defineField: #type type: DWORDField new offset: 36;
		defineField: #pvFilter type: DWORDField new offset: 40.

	self byteSize: 44! !
!HDITEM class categoriesFor: #defineFields!initializing!public! !

