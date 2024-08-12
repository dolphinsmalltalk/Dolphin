"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #SCROLLINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_fMask _OffsetOf_nMax _OffsetOf_nMin _OffsetOf_nPage _OffsetOf_nPos _OffsetOf_nTrackPos'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SCROLLINFO guid: (GUID fromString: '{87b4c60f-026e-11d3-9fd7-00a0cc3e4a32}')!

SCROLLINFO addClassConstant: '_OffsetOf_dwSize' value: 16r0!
SCROLLINFO addClassConstant: '_OffsetOf_fMask' value: 16r4!
SCROLLINFO addClassConstant: '_OffsetOf_nMax' value: 16rC!
SCROLLINFO addClassConstant: '_OffsetOf_nMin' value: 16r8!
SCROLLINFO addClassConstant: '_OffsetOf_nPage' value: 16r10!
SCROLLINFO addClassConstant: '_OffsetOf_nPos' value: 16r14!
SCROLLINFO addClassConstant: '_OffsetOf_nTrackPos' value: 16r18!

SCROLLINFO comment: ''!

!SCROLLINFO categoriesForClass!External-Data-Structured-Win32! !

!SCROLLINFO methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

fMask
	"Answer the <Integer> value of the receiver's 'fMask' field."

	^bytes dwordAtOffset: _OffsetOf_fMask!

fMask: anInteger
	"Set the receiver's 'fMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_fMask put: anInteger!

maskIn: anInteger
	"OR in to contents' mask member the bit flags represented by anInteger.
	Answer the receiver."

	self fMask: (self fMask bitOr: anInteger)!

nMax
	"Answer the <Integer> value of the receiver's 'nMax' field."

	^bytes sdwordAtOffset: _OffsetOf_nMax!

nMax: anInteger
	"Set the receiver's 'nMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_nMax put: anInteger!

nMin
	"Answer the <Integer> value of the receiver's 'nMin' field."

	^bytes sdwordAtOffset: _OffsetOf_nMin!

nMin: anInteger
	"Set the receiver's 'nMin' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_nMin put: anInteger!

nPage
	"Answer the <Integer> value of the receiver's 'nPage' field."

	^bytes dwordAtOffset: _OffsetOf_nPage!

nPage: anInteger
	"Set the receiver's 'nPage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nPage put: anInteger!

nPos
	"Answer the <Integer> value of the receiver's 'nPos' field."

	^bytes sdwordAtOffset: _OffsetOf_nPos!

nPos: anInteger
	"Set the receiver's 'nPos' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_nPos put: anInteger!

nTrackPos
	"Answer the <Integer> value of the receiver's 'nTrackPos' field."

	^bytes sdwordAtOffset: _OffsetOf_nTrackPos!

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

!SCROLLINFO categoriesForMethods!
dwSize:!**compiled accessors**!public! !
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

!SCROLLINFO class methodsFor!

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

	self 
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #fMask type: DWORDField new;
		defineField: #nMin type: SDWORDField new;
		defineField: #nMax type: SDWORDField new;
		defineField: #nPage type: DWORDField new;
		defineField: #nPos type: SDWORDField new;
		defineField: #nTrackPos type: SDWORDField readOnly "cannot be set"!

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

!SCROLLINFO class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
range:position:page:!instance creation!public! !
!

