"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #LITEM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SysLinkConstants'
	classInstanceVariableNames: ''!
LITEM guid: (GUID fromString: '{13cd21fb-f5bf-4908-a96b-3801b787a40e}')!
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
	"Answer the receiver's iLink field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iLink)!

iLink: anObject 
	"Set the receiver's iLink field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iLink) put: anObject!

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
	"Answer the receiver's mask field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

mask: anObject 
	"Set the receiver's mask field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

maskIn: anInteger
	"OR in to contents' mask member the bit flags represented by anInteger"

	self mask: (self mask bitOr: anInteger)!

state
	"Answer the receiver's state field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #state)!

state: anObject 
	"Set the receiver's state field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #state) put: anObject!

stateMask
	"Answer the receiver's stateMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #stateMask)!

stateMask: anObject 
	"Set the receiver's stateMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #stateMask) put: anObject!

szID
	"Answer the receiver's szID field as a Smalltalk object."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #szID)!

szID: anObject 
	"Set the receiver's szID field to the value of anObject."

	| size |
	size := anObject byteSize - 2 min: ##(47 * 2).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szID) + 1)
		to: ##(self offsetOf: #szID) + size
		startingAt: 1.
	bytes wordAtOffset: ##(self offsetOf: #szID) + size put: 0!

szURL
	"Answer the receiver's szURL field as a Smalltalk object."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #szURL)!

szURL: anObject 
	"Set the receiver's szURL field to the value of anObject."

	| size |
	size := anObject byteSize - 2 min: ##(2083 * 2).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szURL) + 1)
		to: ##(self offsetOf: #szURL) + size
		startingAt: 1.
	bytes wordAtOffset: ##(self offsetOf: #szURL) + size put: 0!

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
!LITEM categoriesFor: #handle!accessing!public! !
!LITEM categoriesFor: #id!accessing!public! !
!LITEM categoriesFor: #id:!accessing!public! !
!LITEM categoriesFor: #iLink!**compiled accessors**!public! !
!LITEM categoriesFor: #iLink:!**compiled accessors**!public! !
!LITEM categoriesFor: #isEnabled!public!testing! !
!LITEM categoriesFor: #isEnabled:!accessing!public! !
!LITEM categoriesFor: #isFocused!public!testing! !
!LITEM categoriesFor: #isVisited!public!testing! !
!LITEM categoriesFor: #item!accessing!public! !
!LITEM categoriesFor: #itemIndex:!accessing!public! !
!LITEM categoriesFor: #mask!**compiled accessors**!public! !
!LITEM categoriesFor: #mask:!**compiled accessors**!public! !
!LITEM categoriesFor: #maskIn:!accessing!public! !
!LITEM categoriesFor: #state!**compiled accessors**!public! !
!LITEM categoriesFor: #state:!**compiled accessors**!public! !
!LITEM categoriesFor: #stateMask!**compiled accessors**!public! !
!LITEM categoriesFor: #stateMask:!**compiled accessors**!public! !
!LITEM categoriesFor: #szID!**compiled accessors**!public! !
!LITEM categoriesFor: #szID:!**compiled accessors**!public! !
!LITEM categoriesFor: #szURL!**compiled accessors**!public! !
!LITEM categoriesFor: #szURL:!**compiled accessors**!public! !
!LITEM categoriesFor: #url!accessing!public! !
!LITEM categoriesFor: #url:!accessing!public! !

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
		defineField: #szURL type: (StringField type: Utf16String length: L_MAX_URL_LENGTH)! !
!LITEM class categoriesFor: #defineFields!initializing!public! !

