"Filed out from Dolphin Smalltalk"!

OS.CCITEM subclass: #'OS.LVITEMW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ListViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_LVITEMW_Size' -> 16r3C.
		'_OffsetOf_cchTextMax' -> 16r18.
		'_OffsetOf_cColumns' -> 16r2C.
		'_OffsetOf_dwState' -> 16rC.
		'_OffsetOf_iGroup' -> 16r38.
		'_OffsetOf_iGroupId' -> 16r28.
		'_OffsetOf_iImage' -> 16r1C.
		'_OffsetOf_iIndent' -> 16r24.
		'_OffsetOf_iItem' -> 16r4.
		'_OffsetOf_iSubItem' -> 16r8.
		'_OffsetOf_lParam' -> 16r20.
		'_OffsetOf_piColFmt' -> 16r34.
		'_OffsetOf_pszText' -> 16r14.
		'_OffsetOf_puColumns' -> 16r30.
		'_OffsetOf_stateMask' -> 16r10.
		'CallbackPrototype' -> #[3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 0 0 0 0 255 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
	}!
OS.LVITEMW guid: (Core.GUID fromString: '{87b4c620-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.LVITEMW comment: 'LVITEMW is an <ExternalStructure> class which represents the Windows common control structure of the same name.

LVITEMW is used to communicate information about the items (rows) in a List View control such as the text, icon, state, etc.

typedef [uuid(87b4c620-026e-11d3-9fd7-00a0cc3e4a32)]
struct tagLVITEMW {
	unsigned int mask;
	int iItem;
	int iSubItem;
	unsigned int State;
	unsigned int stateMask;
	[string] LPWSTR pszText;
	int cchTextMax;
	int iImage;
	LONG_PTR lParam;
	int iIndent;
	int iGroupId;
	unsigned int cColumns;
	[size_is(''cColumns'')] unsigned int* puColumns;
	[size_is(''cColumns'')] int* piColFmt;
	[readonly] int iGroup;
} LVITEMW;
'!
!OS.LVITEMW categoriesForClass!Win32-Structs! !
!OS.LVITEMW methodsFor!

allCallbacks
	bytes
		int32AtOffset: _OffsetOf_iImage put: I_IMAGECALLBACK;
		uint32AtOffset: _OffsetOf_pszText put: LPSTR_TEXTCALLBACK.
	self maskIn: ##(LVIF_TEXT | LVIF_IMAGE)!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes int32AtOffset: _OffsetOf_cchTextMax!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cchTextMax put: anInteger!

cchTextMaxOffset
	^_OffsetOf_cchTextMax!

cColumns
	"Answer the <Integer> value of the receiver's 'cColumns' field."

	^bytes uint32AtOffset: _OffsetOf_cColumns!

cColumns: anInteger
	"Set the receiver's 'cColumns' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cColumns put: anInteger!

column: colInteger 
	self iSubItem: colInteger - 1!

dwState
	"Answer the <Integer> value of the receiver's 'dwState' field."

	^bytes uint32AtOffset: _OffsetOf_dwState!

dwState: anInteger
	"Set the receiver's 'dwState' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwState put: anInteger!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self iItem + 1!

iGroup
	"Answer the <Integer> value of the receiver's 'iGroup' field."

	^bytes int32AtOffset: _OffsetOf_iGroup!

iGroupId
	"Answer the <Integer> value of the receiver's 'iGroupId' field."

	^bytes int32AtOffset: _OffsetOf_iGroupId!

iGroupId: anInteger
	"Set the receiver's 'iGroupId' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iGroupId put: anInteger!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes int32AtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iImage put: anInteger!

iIndent
	"Answer the <Integer> value of the receiver's 'iIndent' field."

	^bytes int32AtOffset: _OffsetOf_iIndent!

iIndent: anInteger
	"Set the receiver's 'iIndent' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iIndent put: anInteger!

iItem
	"Answer the <Integer> value of the receiver's 'iItem' field."

	^bytes int32AtOffset: _OffsetOf_iItem!

iItem: anInteger
	"Set the receiver's 'iItem' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iItem put: anInteger!

indent: widths
	"Set the number of image widths to indent the item text."

	self iIndent: widths.
	self maskIn: LVIF_INDENT!

iStateImage
	^self dwState bitShift: -12!

iStateImage: anInteger
	"Set receiver's state image field to anInteger. Any other state is discarded."

	bytes
		uint32AtOffset: _OffsetOf_dwState put: (anInteger bitShift: 12);
		uint32AtOffset: _OffsetOf_stateMask put: LVIS_STATEIMAGEMASK!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes int32AtOffset: _OffsetOf_iSubItem!

iSubItem: anInteger
	"Set the receiver's 'iSubItem' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iSubItem put: anInteger!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes intPtrAtOffset: _OffsetOf_lParam!

lParam: anInteger
	"Set the receiver's 'lParam' field to the value of the argument, anInteger"

	bytes intPtrAtOffset: _OffsetOf_lParam put: anInteger!

piColFmt
	"Answer the <Int32Array> value of the receiver's 'piColFmt' field."

	^Int32Array fromAddress: (bytes intPtrAtOffset: _OffsetOf_piColFmt) length: self cColumns!

piColFmt: anInt32Array
	"Set the receiver's 'piColFmt' field to the value of the argument, anInt32Array"

	bytes uintPtrAtOffset: _OffsetOf_piColFmt put: anInt32Array yourAddress.
	self cColumns: anInt32Array size!

pszText
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszText)!

pszText: anUtf16String
	"Set the receiver's 'pszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszText put: anUtf16String yourAddress!

puColumns
	"Answer the <UInt32Array> value of the receiver's 'puColumns' field."

	^UInt32Array fromAddress: (bytes intPtrAtOffset: _OffsetOf_puColumns) length: self cColumns!

puColumns: aUInt32Array
	"Set the receiver's 'puColumns' field to the value of the argument, aUInt32Array"

	bytes uintPtrAtOffset: _OffsetOf_puColumns put: aUInt32Array yourAddress.
	self cColumns: aUInt32Array size!

row: rowInteger text: aString imageIndex: imageInteger indent: indentInteger
	| mask iImage |
	self
		iItem: rowInteger - 1;
		pszText: (text := aString asUtf16String).
	mask := LVIF_TEXT.
	iImage := imageInteger.
	indentInteger == 0
		ifFalse:
			[self iIndent: indentInteger.
			mask := mask bitOr: LVIF_INDENT.
			indentInteger < 0 ifTrue: [iImage := UI.ListView.NoImageIndex]].
	iImage
		ifNotNil: 
			[self iImage: iImage - 1.
			mask := mask bitOr: LVIF_IMAGE].
	self mask: mask!

row: rowInteger text: aString imageIndex: imageInteger indent: indentInteger stateImageIndex: stateImageInteger
	| mask iImage |
	self
		iItem: rowInteger - 1;
		pszText: (text := aString asUtf16String).
	mask := LVIF_TEXT.
	iImage := imageInteger.
	indentInteger == 0
		ifFalse: 
			[self iIndent: indentInteger.
			mask := mask bitOr: LVIF_INDENT.
			indentInteger < 0 ifTrue: [iImage := 0]].
	iImage
		ifNotNil: 
			[self iImage: iImage - 1.
			mask := mask bitOr: LVIF_IMAGE].
	self mask: mask!

stateImageIndex: anInteger
	"Set content's state image index to anInteger. Any other state is discarded."

	self
		iStateImage: anInteger;
		maskIn: LVIF_STATE!

stateMask
	"Answer the <Integer> value of the receiver's 'stateMask' field."

	^bytes uint32AtOffset: _OffsetOf_stateMask!

stateMask: anInteger
	"Set the receiver's 'stateMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_stateMask put: anInteger!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^_OffsetOf_pszText! !
!OS.LVITEMW categoriesForMethods!
allCallbacks!accessing!public! !
cchTextMax!**compiled accessors**!public! !
cchTextMax:!**compiled accessors**!public! !
cchTextMaxOffset!constants!private! !
cColumns!**compiled accessors**!public! !
cColumns:!**compiled accessors**!public! !
column:!accessing!public! !
dwState!**compiled accessors**!public! !
dwState:!**compiled accessors**!public! !
handle!accessing!public! !
iGroup!**compiled accessors**!public! !
iGroupId!**compiled accessors**!public! !
iGroupId:!**compiled accessors**!public! !
iImage!**compiled accessors**!public! !
iImage:!**compiled accessors**!public! !
iIndent!**compiled accessors**!public! !
iIndent:!**compiled accessors**!public! !
iItem!**compiled accessors**!public! !
iItem:!**compiled accessors**!public! !
indent:!accessing!public! !
iStateImage!accessing!public! !
iStateImage:!accessing!public! !
iSubItem!**compiled accessors**!public! !
iSubItem:!**compiled accessors**!public! !
lParam!**compiled accessors**!public! !
lParam:!**compiled accessors**!public! !
piColFmt!**compiled accessors**!public! !
piColFmt:!**compiled accessors**!public! !
pszText!**compiled accessors**!public! !
pszText:!**compiled accessors**!public! !
puColumns!**compiled accessors**!public! !
puColumns:!**compiled accessors**!public! !
row:text:imageIndex:indent:!accessing!private! !
row:text:imageIndex:indent:stateImageIndex:!accessing!private! !
stateImageIndex:!accessing!public! !
stateMask!**compiled accessors**!public! !
stateMask:!**compiled accessors**!public! !
textPointerOffset!constants!private! !
!

!OS.LVITEMW class methodsFor!

allCallbacks
	^self basicNew
		bytes: CallbackPrototype shallowCopy;
		yourself!

byteSize
	^_LVITEMW_Size!

defineFields
	"Define the fields of the LVITEMW structure.

	self compileDefinition

		typedef [uuid(87b4c620-026e-11d3-9fd7-00a0cc3e4a32)]
		struct tagLVITEMW {
			unsigned int mask;
			int iItem;
			int iSubItem;
			unsigned int State;
			unsigned int stateMask;
			[string] LPWSTR pszText;
			int cchTextMax;
			int iImage;
			LONG_PTR lParam;
			int iIndent;
			int iGroupId;
			unsigned int cColumns;
			[size_is('cColumns')] unsigned int* puColumns;
			[size_is('cColumns')] int* piColFmt;
			[readonly] int iGroup;
		} LVITEMW;
	"

	super defineFields.
	self
		defineField: #iItem
			type: Int32Field new
			offset: 4;
		defineField: #iSubItem
			type: Int32Field new
			offset: 8;
		defineField: #dwState
			type: UInt32Field new
			offset: 12;
		defineField: #stateMask
			type: UInt32Field new
			offset: 16;
		defineField: #pszText
			type: (PointerField type: Utf16String)
			offset: 20;
		defineField: #cchTextMax
			type: Int32Field new
			offset: 24;
		defineField: #iImage
			type: Int32Field new
			offset: 28;
		defineField: #lParam
			type: IntPtrField new
			offset: 32;
		defineField: #iIndent
			type: Int32Field new
			offset: 36;
		defineField: #iGroupId
			type: Int32Field new
			offset: 40;
		defineField: #cColumns
			type: UInt32Field new
			offset: 44;
		defineField: #puColumns
			type: (ArrayPointerField type: UInt32Array
					arrayLength: (ConformantArrayFieldLength lengthField: #cColumns))
			offset: 48;
		defineField: #piColFmt
			type: (ArrayPointerField type: Int32Array
					arrayLength: (ConformantArrayFieldLength lengthField: #cColumns))
			offset: 52;
		defineField: #iGroup
			type: Int32Field new beReadOnly
			offset: 56.
	self byteSize: 60!

getFieldNames
	^#(#mask #iItem #iSubItem #dwState #stateMask #pszText #cchTextMax #iImage #lParam #iIndent #iGroupId #cColumns #puColumns #piColFmt #iGroup)!

initialize
	self addClassConstant: 'CallbackPrototype'
		value: (self new
				allCallbacks;
				bytes)! !
!OS.LVITEMW class categoriesForMethods!
allCallbacks!public! !
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!development!public! !
!

