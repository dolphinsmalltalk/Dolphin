"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.LITEM'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.SysLinkConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_iLink' -> 16r4.
		'_OffsetOf_mask' -> 16r0.
		'_OffsetOf_state' -> 16r8.
		'_OffsetOf_stateMask' -> 16rC.
		'_OffsetOf_szID' -> 16r10.
		'_OffsetOf_szURL' -> 16r70
	}!
OS.LITEM guid: (Core.GUID fromString: '{13cd21fb-f5bf-4908-a96b-3801b787a40e}')!
OS.LITEM comment: 'LITEM is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

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
!OS.LITEM categoriesForClass!External-Data-Structured-Win32! !
!OS.LITEM methodsFor!

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
!OS.LITEM categoriesFor: #handle!accessing!public! !
!OS.LITEM categoriesFor: #id!accessing!public! !
!OS.LITEM categoriesFor: #id:!accessing!public! !
!OS.LITEM categoriesFor: #iLink!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #iLink:!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #isEnabled!public!testing! !
!OS.LITEM categoriesFor: #isEnabled:!accessing!public! !
!OS.LITEM categoriesFor: #isFocused!public!testing! !
!OS.LITEM categoriesFor: #isVisited!public!testing! !
!OS.LITEM categoriesFor: #item!accessing!public! !
!OS.LITEM categoriesFor: #itemIndex:!accessing!public! !
!OS.LITEM categoriesFor: #mask!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #mask:!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #maskIn:!accessing!public! !
!OS.LITEM categoriesFor: #state!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #state:!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #stateMask!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #stateMask:!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #szID!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #szID:!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #szURL!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #szURL:!**compiled accessors**!public! !
!OS.LITEM categoriesFor: #url!accessing!public! !
!OS.LITEM categoriesFor: #url:!accessing!public! !

!OS.LITEM class methodsFor!

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
!OS.LITEM class categoriesFor: #defineFields!public!template definition! !
!OS.LITEM class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

