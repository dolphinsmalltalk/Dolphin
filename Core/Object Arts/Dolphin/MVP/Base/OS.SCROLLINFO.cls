"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.SCROLLINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_fMask' -> 16r4.
			'_OffsetOf_nMax' -> 16rC.
			'_OffsetOf_nMin' -> 16r8.
			'_OffsetOf_nPage' -> 16r10.
			'_OffsetOf_nPos' -> 16r14.
			'_OffsetOf_nTrackPos' -> 16r18.
			'_SCROLLINFO_Size' -> 16r1C
		}!

OS.SCROLLINFO guid: (Core.GUID fromString: '{87b4c60f-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.SCROLLINFO comment: ''!

!OS.SCROLLINFO categoriesForClass!External-Data-Structured-Win32! !

!OS.SCROLLINFO methodsFor!

fMask
	"Answer the <Integer> value of the receiver's 'fMask' field."

	^bytes uint32AtOffset: _OffsetOf_fMask!

fMask: anInteger
	"Set the receiver's 'fMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_fMask put: anInteger!

maskIn: anInteger
	"OR in to receiver's 'fMask' field the bit flags represented by anInteger.
	Answer the receiver."

	self fMask: (self fMask bitOr: anInteger)!

nMax
	"Answer the <Integer> value of the receiver's 'nMax' field."

	^bytes int32AtOffset: _OffsetOf_nMax!

nMax: anInteger
	"Set the receiver's 'nMax' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_nMax put: anInteger!

nMin
	"Answer the <Integer> value of the receiver's 'nMin' field."

	^bytes int32AtOffset: _OffsetOf_nMin!

nMin: anInteger
	"Set the receiver's 'nMin' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_nMin put: anInteger!

nPage
	"Answer the <Integer> value of the receiver's 'nPage' field."

	^bytes uint32AtOffset: _OffsetOf_nPage!

nPage: anInteger
	"Set the receiver's 'nPage' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nPage put: anInteger!

nPos
	"Answer the <Integer> value of the receiver's 'nPos' field."

	^bytes int32AtOffset: _OffsetOf_nPos!

nPos: anInteger
	"Set the receiver's 'nPos' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_nPos put: anInteger!

nTrackPos
	"Answer the <Integer> value of the receiver's 'nTrackPos' field."

	^bytes int32AtOffset: _OffsetOf_nTrackPos!

page
	"Answer the page size of a proportional scroll bar."

	^self nPage!

page: pageInteger
	"Set the page size of a proportional scroll bar."

	self
		nPage: pageInteger;
		maskIn: SIF_PAGE!

pos
	"Answer the position of the thumb in the scroll bar relative to its range."

	^self nPos!

pos: positionInteger
	"Set the thumb position of the scroll bar to positionInteger. This position
	is relative to the scroll bars range."

	self nPos: positionInteger;
		maskIn: SIF_POS!

range
	"Answer an Interval over which the scroll bars thumb can be set." 

	^self nMin to: self nMax!

range: anInterval
	"Set the range through which the scroll bars thumb can be positioned."

	self
		nMin: anInterval start;
		nMax: anInterval stop;
		maskIn: SIF_RANGE! !

!OS.SCROLLINFO categoriesForMethods!
fMask!**compiled accessors**!public! !
fMask:!**compiled accessors**!public! !
maskIn:!accessing!public! !
nMax!**compiled accessors**!public! !
nMax:!**compiled accessors**!public! !
nMin!**compiled accessors**!public! !
nMin:!**compiled accessors**!public! !
nPage!**compiled accessors**!public! !
nPage:!**compiled accessors**!public! !
nPos!**compiled accessors**!public! !
nPos:!**compiled accessors**!public! !
nTrackPos!**compiled accessors**!public! !
page!accessing!public! !
page:!accessing!public! !
pos!accessing!public! !
pos:!accessing!public! !
range!accessing!public! !
range:!accessing!public! !
!

!OS.SCROLLINFO class methodsFor!

byteSize
	^_SCROLLINFO_Size!

defineFields
	"Define the layout of the Win32 SCROLLINFO structure
  
		SCROLLINFO compileDefinition

	typedef struct tagSCROLLINFO   // si 
		UINT cbSize; 
		UINT fMask; 
		int  nMin; 
		int  nMax; 
		UINT nPage; 
		int  nPos; 
		int  nTrackPos; 
		SCROLLINFO; 
	typedef SCROLLINFO FAR *LPSCROLLINFO;"

	super defineFields.
	self
		defineField: #fMask type: UInt32Field new;
		defineField: #nMin type: Int32Field new;
		defineField: #nMax type: Int32Field new;
		defineField: #nPage type: UInt32Field new;
		defineField: #nPos type: Int32Field new;
		defineField: #nTrackPos type: Int32Field readOnly	"cannot be set"!

getFieldNames
	^#(#dwSize #fMask #nMin #nMax #nPage #nPos #nTrackPos)!

range: anInterval position: posInteger page: pageInteger
	^self newBuffer
		nMin: anInterval start;
		nMax: anInterval stop;
		nPos: posInteger;
		nPage: pageInteger;
		fMask: ##(SIF_RANGE | SIF_POS | SIF_PAGE);
		yourself! !

!OS.SCROLLINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
range:position:page:!instance creation!public! !
!

