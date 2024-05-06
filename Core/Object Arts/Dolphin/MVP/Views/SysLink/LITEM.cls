"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #LITEM
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_iLink _OffsetOf_mask _OffsetOf_state _OffsetOf_stateMask _OffsetOf_szID _OffsetOf_szURL'
	poolDictionaries: 'SysLinkConstants'
	classInstanceVariableNames: ''!

LITEM guid: (GUID fromString: '{13cd21fb-f5bf-4908-a96b-3801b787a40e}')!

LITEM addClassConstant: '_OffsetOf_iLink' value: 16r4!
LITEM addClassConstant: '_OffsetOf_mask' value: 16r0!
LITEM addClassConstant: '_OffsetOf_state' value: 16r8!
LITEM addClassConstant: '_OffsetOf_stateMask' value: 16rC!
LITEM addClassConstant: '_OffsetOf_szID' value: 16r10!
LITEM addClassConstant: '_OffsetOf_szURL' value: 16r70!

LITEM comment: 'LITEM is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

LITEMs are used in conjunction with the SysLink control, wrapped in Dolphin by <SysLinkView>.

	typedef struct tagLITEM
	{
	    UINT        mask ;
	    int         iLink ;
	    UINT        state ;
	    UINT        stateMask ;
	    WCHAR       szID[MAX_LINKID_TEXT] ;
	    WCHAR       szUrl[L_MAX_URL_LENGTH] ;
	} LITEM, * PLITEM ;'!

!LITEM categoriesForClass!External-Data-Structured-Win32! !

!LITEM methodsFor!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self iLink + 1!

id
	"Answer the <readableString> link ID held in the receiver."

	^self szID asString!

id: aString
	"Set the <readableString> ID held in the receiver."

	| text |
	text := aString displayString asUtf16String.
	self
		maskIn: LIF_ITEMID;
		szID: text!

iLink
	"Answer the <Integer> value of the receiver's 'iLink' field."

	^bytes sdwordAtOffset: _OffsetOf_iLink!

iLink: anInteger
	"Set the receiver's 'iLink' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iLink put: anInteger!

isEnabled
	^self state allMask: LIS_ENABLED!

isEnabled: aBoolean 
	self state: (self state mask: LIS_ENABLED set: aBoolean).
	self stateMask: (self stateMask bitOr: LIS_ENABLED).
	self maskIn: LIF_STATE!

isFocused
	^self state allMask: LIS_FOCUSED!

isVisited
	^self state allMask: LIS_VISITED!

item
	^self!

itemIndex: anInteger 
	"Set the one-based numeric item index to the <integer> argument."

	self
		maskIn: LIF_ITEMINDEX;
		iLink: anInteger - 1!

mask
	"Answer the <Integer> value of the receiver's 'mask' field."

	^bytes dwordAtOffset: _OffsetOf_mask!

mask: anInteger
	"Set the receiver's 'mask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_mask put: anInteger!

maskIn: anInteger
	"OR in to contents' mask member the bit flags represented by anInteger"

	self mask: (self mask bitOr: anInteger)!

state
	"Answer the <Integer> value of the receiver's 'state' field."

	^bytes dwordAtOffset: _OffsetOf_state!

state: anInteger
	"Set the receiver's 'state' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_state put: anInteger!

stateMask
	"Answer the <Integer> value of the receiver's 'stateMask' field."

	^bytes dwordAtOffset: _OffsetOf_stateMask!

stateMask: anInteger
	"Set the receiver's 'stateMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_stateMask put: anInteger!

szID
	"Answer the <Utf16String> value of the receiver's 'szID' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szID!

szID: anUtf16String
	"Set the receiver's 'szID' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(47 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szID + 1)
		to: _OffsetOf_szID + size
		startingAt: 1.
	bytes wordAtOffset: _OffsetOf_szID + size put: 0!

szURL
	"Answer the <Utf16String> value of the receiver's 'szURL' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szURL!

szURL: anUtf16String
	"Set the receiver's 'szURL' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(2083 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szURL + 1)
		to: _OffsetOf_szURL + size
		startingAt: 1.
	bytes wordAtOffset: _OffsetOf_szURL + size put: 0!

url
	"Answer the <readableString> URL held in the receiver."

	^self szURL asString!

url: aString
	"Set the <readableString> URL held in the receiver."

	| text |
	text := aString asUtf16String.
	self
		maskIn: LIF_URL;
		szURL: text! !

!LITEM categoriesForMethods!
handle!accessing!public! !
id!accessing!public! !
id:!accessing!public! !
iLink!**compiled accessors**!public! !
iLink:!**compiled accessors**!public! !
isEnabled!public!testing! !
isEnabled:!accessing!public! !
isFocused!public!testing! !
isVisited!public!testing! !
item!accessing!public! !
itemIndex:!accessing!public! !
mask!**compiled accessors**!public! !
mask:!**compiled accessors**!public! !
maskIn:!accessing!public! !
state!**compiled accessors**!public! !
state:!**compiled accessors**!public! !
stateMask!**compiled accessors**!public! !
stateMask:!**compiled accessors**!public! !
szID!**compiled accessors**!public! !
szID:!**compiled accessors**!public! !
szURL!**compiled accessors**!public! !
szURL:!**compiled accessors**!public! !
url!accessing!public! !
url:!accessing!public! !
!

!LITEM class methodsFor!

defineFields
	"Define the fields of the Win32 LITEM structure

		LITEM compileDefinition
	"

	self
		defineField: #mask type: DWORDField new;
		defineField: #iLink type: SDWORDField new;
		defineField: #state type: DWORDField new;
		defineField: #stateMask type: DWORDField new;
		defineField: #szID type: (StringField type: Utf16String length: MAX_LINKID_TEXT);
		defineField: #szURL type: (StringField type: Utf16String length: L_MAX_URL_LENGTH)!

getFieldNames
	^#(#mask #iLink #state #stateMask #szID #szURL)! !

!LITEM class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

