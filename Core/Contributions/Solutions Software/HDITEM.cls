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
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cchTextMax)!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cchTextMax) put: anInteger!

cxy
	"Answer the <Integer> value of the receiver's 'cxy' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cxy)!

cxy: anInteger
	"Set the receiver's 'cxy' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cxy) put: anInteger!

dwState
	"Answer the receiver's dwState field as a Smalltalk object."

	^self shouldNotImplement!

dwState: anObject 
	"Set the receiver's dwState field to the value of anObject."

	self shouldNotImplement!

fmt
	"Answer the <Integer> value of the receiver's 'fmt' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #fmt)!

fmt: anInteger
	"Set the receiver's 'fmt' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #fmt) put: anInteger!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self shouldNotImplement!

hbm
	"Answer the <ExternalHandle> value of the receiver's 'hbm' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hbm)) asExternalHandle!

hbm: anExternalHandle
	"Set the receiver's 'hbm' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hbm) put: anExternalHandle!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iImage)!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #iImage) put: anInteger!

imageValidMask
	"Private - Answer the bit mask the receiver uses to denote that the iImage
	field has valid contents."

	^16r0020 "HDI_IMAGE"!

iOrder
	"Answer the <Integer> value of the receiver's 'iOrder' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iOrder)!

iOrder: anInteger
	"Set the receiver's 'iOrder' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #iOrder) put: anInteger!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes dwordAtOffset: ##(self offsetOf: #lParam)!

lParam: anObject
	"Set the receiver's lParam field to the value of anObject."

	bytes dwordAtOffset: 24 put: anObject!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^16r8 "HDI_LPARAM"!

pszText
	"Answer the <String> value of the receiver's 'pszText' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszText))!

pszText: aString
	"Set the receiver's 'pszText' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #pszText) put: aString yourAddress!

pvFilter
	"Answer the <Integer> value of the receiver's 'pvFilter' field."

	^bytes dwordAtOffset: ##(self offsetOf: #pvFilter)!

pvFilter: anInteger
	"Set the receiver's 'pvFilter' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #pvFilter) put: anInteger!

stateMask
	"Answer the receiver's stateMask field as a Smalltalk object."

	^self shouldNotImplement!

stateMask: anObject 
	"Set the receiver's stateMask field to the value of anObject."

	self shouldNotImplement!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^##(self offsetOf: #pszText)!

textValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^16r0002	"HDI_TEXT"!

type
	"Answer the <Integer> value of the receiver's 'type' field."

	^bytes dwordAtOffset: ##(self offsetOf: #type)!

type: anInteger
	"Set the receiver's 'type' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #type) put: anInteger! !
!HDITEM categoriesFor: #cchTextMax!**compiled accessors**!public! !
!HDITEM categoriesFor: #cchTextMax:!**compiled accessors**!public! !
!HDITEM categoriesFor: #cxy!**compiled accessors**!public! !
!HDITEM categoriesFor: #cxy:!**compiled accessors**!public! !
!HDITEM categoriesFor: #dwState!accessing!public! !
!HDITEM categoriesFor: #dwState:!accessing!public! !
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
!HDITEM categoriesFor: #stateMask!accessing!public! !
!HDITEM categoriesFor: #stateMask:!accessing!public! !
!HDITEM categoriesFor: #textPointerOffset!constants!private! !
!HDITEM categoriesFor: #textValidMask!constants!private! !
!HDITEM categoriesFor: #type!**compiled accessors**!public! !
!HDITEM categoriesFor: #type:!**compiled accessors**!public! !

!HDITEM class methodsFor!

defineFields
	"Define the fields of the HDITEM structure.
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

	super defineFields.
	self
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

	self byteSize: 44!

textClass
	^String! !
!HDITEM class categoriesFor: #defineFields!initializing!public! !
!HDITEM class categoriesFor: #textClass!constants!private! !

