"Filed out from Dolphin Smalltalk"!

CCITEM subclass: #HDITEMW
	instanceVariableNames: ''
	classVariableNames: '_HDITEMW_Size _OffsetOf_cchTextMax _OffsetOf_cxy _OffsetOf_fmt _OffsetOf_hbm _OffsetOf_iImage _OffsetOf_iOrder _OffsetOf_lParam _OffsetOf_pszText _OffsetOf_pvFilter _OffsetOf_state _OffsetOf_type'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HDITEMW guid: (GUID fromString: '{cff5da39-bb38-4499-9527-66449b212b87}')!
HDITEMW addClassConstant: '_HDITEMW_Size' value: 16r30!
HDITEMW addClassConstant: '_OffsetOf_cchTextMax' value: 16r10!
HDITEMW addClassConstant: '_OffsetOf_cxy' value: 16r4!
HDITEMW addClassConstant: '_OffsetOf_fmt' value: 16r14!
HDITEMW addClassConstant: '_OffsetOf_hbm' value: 16rC!
HDITEMW addClassConstant: '_OffsetOf_iImage' value: 16r1C!
HDITEMW addClassConstant: '_OffsetOf_iOrder' value: 16r20!
HDITEMW addClassConstant: '_OffsetOf_lParam' value: 16r18!
HDITEMW addClassConstant: '_OffsetOf_pszText' value: 16r8!
HDITEMW addClassConstant: '_OffsetOf_pvFilter' value: 16r28!
HDITEMW addClassConstant: '_OffsetOf_state' value: 16r2C!
HDITEMW addClassConstant: '_OffsetOf_type' value: 16r24!
HDITEMW comment: ''!
!HDITEMW categoriesForClass!Unclassified! !
!HDITEMW methodsFor!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes sdwordAtOffset: _OffsetOf_cchTextMax!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cchTextMax put: anInteger!

cxy
	"Answer the <Integer> value of the receiver's 'cxy' field."

	^bytes sdwordAtOffset: _OffsetOf_cxy!

cxy: anInteger
	"Set the receiver's 'cxy' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxy put: anInteger!

dwState
	"Answer the receiver's dwState field as a Smalltalk object."

	^self shouldNotImplement!

dwState: anObject 
	"Set the receiver's dwState field to the value of anObject."

	self shouldNotImplement!

fmt
	"Answer the <Integer> value of the receiver's 'fmt' field."

	^bytes sdwordAtOffset: _OffsetOf_fmt!

fmt: anInteger
	"Set the receiver's 'fmt' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_fmt put: anInteger!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self shouldNotImplement!

hbm
	"Answer the <ExternalHandle> value of the receiver's 'hbm' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hbm) asExternalHandle!

hbm: anExternalHandle
	"Set the receiver's 'hbm' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbm put: anExternalHandle!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes sdwordAtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iImage put: anInteger!

imageValidMask
	"Private - Answer the bit mask the receiver uses to denote that the iImage
	field has valid contents."

	^16r0020 "HDI_IMAGE"!

iOrder
	"Answer the <Integer> value of the receiver's 'iOrder' field."

	^bytes sdwordAtOffset: _OffsetOf_iOrder!

iOrder: anInteger
	"Set the receiver's 'iOrder' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iOrder put: anInteger!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes dwordAtOffset: _OffsetOf_lParam!

lParam: anObject
	"Set the receiver's lParam field to the value of anObject."

	bytes dwordAtOffset: 24 put: anObject!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^16r8 "HDI_LPARAM"!

pszText
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszText)!

pszText: anUtf16String
	"Set the receiver's 'pszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszText put: anUtf16String yourAddress!

pvFilter
	"Answer the <Integer> value of the receiver's 'pvFilter' field."

	^bytes dwordAtOffset: _OffsetOf_pvFilter!

pvFilter: anInteger
	"Set the receiver's 'pvFilter' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_pvFilter put: anInteger!

state
	"Answer the <Integer> value of the receiver's 'state' field."

	^bytes dwordAtOffset: _OffsetOf_state!

state: anInteger
	"Set the receiver's 'state' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_state put: anInteger!

stateMask
	"Answer the receiver's stateMask field as a Smalltalk object."

	^self shouldNotImplement!

stateMask: anObject 
	"Set the receiver's stateMask field to the value of anObject."

	self shouldNotImplement!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^_OffsetOf_pszText!

textValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^16r0002	"HDI_TEXT"!

type
	"Answer the <Integer> value of the receiver's 'type' field."

	^bytes dwordAtOffset: _OffsetOf_type!

type: anInteger
	"Set the receiver's 'type' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_type put: anInteger! !
!HDITEMW categoriesForMethods!
cchTextMax!**compiled accessors**!public! !
cchTextMax:!**compiled accessors**!public! !
cxy!**compiled accessors**!public! !
cxy:!**compiled accessors**!public! !
dwState!accessing!public! !
dwState:!accessing!public! !
fmt!**compiled accessors**!public! !
fmt:!**compiled accessors**!public! !
handle!accessing!public! !
hbm!**compiled accessors**!public! !
hbm:!**compiled accessors**!public! !
iImage!**compiled accessors**!public! !
iImage:!**compiled accessors**!public! !
imageValidMask!constants!private! !
iOrder!**compiled accessors**!public! !
iOrder:!**compiled accessors**!public! !
lParam!**compiled accessors**!public! !
lParam:!accessing!public! !
paramValidMask!constants!private! !
pszText!**compiled accessors**!public! !
pszText:!**compiled accessors**!public! !
pvFilter!**compiled accessors**!public! !
pvFilter:!**compiled accessors**!public! !
state!**compiled accessors**!public! !
state:!**compiled accessors**!public! !
stateMask!accessing!public! !
stateMask:!accessing!public! !
textPointerOffset!constants!private! !
textValidMask!constants!private! !
type!**compiled accessors**!public! !
type:!**compiled accessors**!public! !
!

!HDITEMW class methodsFor!

defineFields
	"Define the fields of the HDITEM structure.
		self compileDefinition
	
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
		defineField: #pszText type: (PointerField type: Utf16String) offset: 8;
		defineField: #hbm type: HANDLEField new offset: 12;
		defineField: #cchTextMax type: SDWORDField new offset: 16;
		defineField: #fmt type: SDWORDField new offset: 20;
		defineField: #lParam type: DWORDField new offset: 24;
		defineField: #iImage type: SDWORDField new offset: 28;
		defineField: #iOrder type: SDWORDField new offset: 32;
		defineField: #type type: DWORDField new offset: 36;
		defineField: #pvFilter type: DWORDField new offset: 40;
		defineField: #state type: DWORDField new offset: 44.

	self byteSize: 48!

getFieldNames
	^#(#mask #cxy #pszText #hbm #cchTextMax #fmt #lParam #iImage #iOrder #type #pvFilter #state)! !
!HDITEMW class categoriesForMethods!
defineFields!initializing!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

