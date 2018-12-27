"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #SCROLLINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SCROLLINFO guid: (GUID fromString: '{87b4c60f-026e-11d3-9fd7-00a0cc3e4a32}')!
SCROLLINFO comment: ''!
!SCROLLINFO categoriesForClass!External-Data-Structured-Win32! !
!SCROLLINFO methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

fMask
	"Answer the <Integer> value of the receiver's 'fMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #fMask)!

fMask: anInteger
	"Set the receiver's 'fMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #fMask) put: anInteger!

maskIn: anInteger
	"OR in to contents' mask member the bit flags represented by anInteger.
	Answer the receiver."

	self fMask: (self fMask bitOr: anInteger)!

nMax
	"Answer the <Integer> value of the receiver's 'nMax' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #nMax)!

nMax: anInteger
	"Set the receiver's 'nMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #nMax) put: anInteger!

nMin
	"Answer the <Integer> value of the receiver's 'nMin' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #nMin)!

nMin: anInteger
	"Set the receiver's 'nMin' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #nMin) put: anInteger!

nPage
	"Answer the <Integer> value of the receiver's 'nPage' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nPage)!

nPage: anInteger
	"Set the receiver's 'nPage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nPage) put: anInteger!

nPos
	"Answer the <Integer> value of the receiver's 'nPos' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #nPos)!

nPos: anInteger
	"Set the receiver's 'nPos' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #nPos) put: anInteger!

nTrackPos
	"Answer the <Integer> value of the receiver's 'nTrackPos' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #nTrackPos)!

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
!SCROLLINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #fMask!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #fMask:!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #maskIn:!accessing!public! !
!SCROLLINFO categoriesFor: #nMax!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #nMax:!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #nMin!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #nMin:!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #nPage!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #nPage:!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #nPos!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #nPos:!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #nTrackPos!**compiled accessors**!public! !
!SCROLLINFO categoriesFor: #page!accessing!public! !
!SCROLLINFO categoriesFor: #page:!accessing!public! !
!SCROLLINFO categoriesFor: #pos!accessing!public! !
!SCROLLINFO categoriesFor: #pos:!accessing!public! !
!SCROLLINFO categoriesFor: #range!accessing!public! !
!SCROLLINFO categoriesFor: #range:!accessing!public! !

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
	^#(#dwSize #fMask #nMin #nMax #nPage #nPos #nTrackPos)! !
!SCROLLINFO class categoriesFor: #defineFields!initializing!public! !
!SCROLLINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

