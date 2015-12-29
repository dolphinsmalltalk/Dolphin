"Filed out from Dolphin Smalltalk X6.1"!

NMHDR subclass: #SCNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ScintillaConstants'
	classInstanceVariableNames: ''!
SCNotification guid: (GUID fromString: '{B4E498B9-AD7B-4519-86F5-1E6232FBD0BD}')!
SCNotification comment: '<SCNotification> is an <ExternalStructure> class to wrap the struct ''ScintillaLib.SCNotification'' from type information in the ''Scintiall 1.46 Type Library'' library.

Note that the ''text'' field is not null terminated (the number of characters is specified by the ''length'' field), and is only valid for SCN_MODIFIED notifications where the SC_MOD_DELETETEXT or SC_MOD_INSERTTEXT ''modificationType'' is specified.'!
!SCNotification categoriesForClass!ScintillaLib-Structs! !
!SCNotification methodsFor!

ch
	"Answer the receiver's ch field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #ch)!

character
	"Answer the receiver's <Character> who's codePoint is stored in the 'ch' field."

	^Character codePoint: self ch!

foldLevelNow
	"Answer the receiver's foldLevelNow field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #foldLevelNow)!

foldLevelPrev
	"Answer the receiver's foldLevelPrev field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #foldLevelPrev)!

getValidFields
	"Private - Answer a <sequencedReadableCollection> of the fields defined 
	in the receiver's template, sorted in ascending order of offset from the start of the
	structure, that are valid in this particular instance."

	"From the Scintilla docs:

	struct SCNotification {
		NMHDR	nmhdr;
		int position;	// SCN_STYLENEEDED, SCN_MODIFIED, SCN_DWELLSTART, SCN_DWELLEND
		int ch;		// SCN_CHARADDED, SCN_KEY
		int modifiers;	// SCN_KEY
		int modificationType;// SCN_MODIFIED
		const char *text;	// SCN_MODIFIED
		int length;		// SCN_MODIFIED
		int linesAdded;	// SCN_MODIFIED
		int message;	// SCN_MACRORECORD
		uptr_t wParam;	// SCN_MACRORECORD
		sptr_t lParam;	// SCN_MACRORECORD
		int line;		// SCN_MODIFIED
		int foldLevelNow;	// SCN_MODIFIED
		int foldLevelPrev;	// SCN_MODIFIED
		int margin;	// SCN_MARGINCLICK
		int listType;	// SCN_USERLISTSELECTION
		int x;		// SCN_DWELLSTART, SCN_DWELLEND
		int y;		// SCN_DWELLSTART, SCN_DWELLEND
	};
	"

	^#(#code) 
		, (##((IdentityDictionary new)
				at: SCN_CHARADDED put: #(#ch);
				at: SCN_DWELLEND put: #(#scPosition #x #y);
				at: SCN_DWELLSTART put: #(#scPosition #x #y);
				at: SCN_KEY put: #(#ch #modifiers);
				at: SCN_MACRORECORD put: #(#message #wParam #lParam);
				at: SCN_MARGINCLICK put: #(#margin #scPosition);
				at: SCN_MODIFIED
					put: #(#scPosition #text #length #linesAdded #scLine #foldLevelNow #foldLevelPrev);
				at: SCN_STYLENEEDED put: #(#scPosition);
				at: SCN_USERLISTSELECTION put: #(#listType);
				shrink) at: self code ifAbsent: [#()])!

isAltKeyDown
	"Answer whether the ALT key was down when the event was raised.
	Only relevant for some notifications such as SCN_KEY, and SCN_HOTSPOT[DOUBLE]CLICK."

	^self modifiers allMask: SCMOD_ALT!

isShiftDown
	"Answer whether the shift key was down when the event was raised.
	Only relevant for some notifications such as SCN_KEY, and SCN_HOTSPOT[DOUBLE]CLICK."

	^self modifiers allMask: SCMOD_SHIFT!

length
	"Answer the receiver's length field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #length)!

line
	"Answer the one-based <integer> line number associated with the notification."

	^self scLine + 1!

linesAdded
	"Answer the receiver's linesAdded field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #linesAdded)!

listType
	"Answer the receiver's listType field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #listType)!

lParam
	"Answer the receiver's lParam field as a Smalltalk object."

	^bytes intPtrAtOffset: ##(self offsetOf: #lParam)!

margin
	"Answer the receiver's margin field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #margin)!

message
	"Answer the receiver's message field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #message)!

modificationType
	"Answer the receiver's modificationType field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #modificationType)!

modifiers
	"Answer the receiver's modifiers field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #modifiers)!

point
	^self x @ self y!

position
	"Answer the receiver's position field as a Smalltalk object."

	^self scPosition + 1!

scLine
	"Answer the receiver's scLine field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #scLine)!

scPosition
	"Answer the receiver's scPosition field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #scPosition)!

text
	"Answer the receiver's text field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #text))!

text: anObject 
	"Set the receiver's text field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #text) put: anObject yourAddress!

wParam
	"Answer the receiver's wParam field as a Smalltalk object."

	^bytes uintPtrAtOffset: ##(self offsetOf: #wParam)!

x
	"Answer the receiver's x field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #x)!

y
	"Answer the receiver's y field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #y)! !
!SCNotification categoriesFor: #ch!**compiled accessors**!public! !
!SCNotification categoriesFor: #character!accessing!public! !
!SCNotification categoriesFor: #foldLevelNow!**compiled accessors**!public! !
!SCNotification categoriesFor: #foldLevelPrev!**compiled accessors**!public! !
!SCNotification categoriesFor: #getValidFields!accessing!private! !
!SCNotification categoriesFor: #isAltKeyDown!public!testing! !
!SCNotification categoriesFor: #isShiftDown!public!testing! !
!SCNotification categoriesFor: #length!**compiled accessors**!public! !
!SCNotification categoriesFor: #line!accessing!public! !
!SCNotification categoriesFor: #linesAdded!**compiled accessors**!public! !
!SCNotification categoriesFor: #listType!**compiled accessors**!public! !
!SCNotification categoriesFor: #lParam!**compiled accessors**!public! !
!SCNotification categoriesFor: #margin!**compiled accessors**!public! !
!SCNotification categoriesFor: #message!**compiled accessors**!public! !
!SCNotification categoriesFor: #modificationType!**compiled accessors**!public! !
!SCNotification categoriesFor: #modifiers!**compiled accessors**!public! !
!SCNotification categoriesFor: #point!accessing!public! !
!SCNotification categoriesFor: #position!accessing!public! !
!SCNotification categoriesFor: #scLine!**compiled accessors**!public! !
!SCNotification categoriesFor: #scPosition!**compiled accessors**!public! !
!SCNotification categoriesFor: #text!**compiled accessors**!public! !
!SCNotification categoriesFor: #text:!**compiled accessors**!public! !
!SCNotification categoriesFor: #wParam!**compiled accessors**!public! !
!SCNotification categoriesFor: #x!**compiled accessors**!public! !
!SCNotification categoriesFor: #y!**compiled accessors**!public! !

!SCNotification class methodsFor!

defineFields
	"Define the fields of the SCNotification structure.
		SCNotification compileDefinition
	"

	super defineFields.
	self
		defineField: #scPosition type: SDWORDField readOnly;
		defineField: #ch type: SDWORDField readOnly;
		defineField: #modifiers type: SDWORDField readOnly;
		defineField: #modificationType type: SDWORDField readOnly;
		defineField: #text type: (PointerField type: String);
		defineField: #length type: SDWORDField readOnly;
		defineField: #linesAdded type: SDWORDField readOnly;
		defineField: #message type: SDWORDField readOnly;
		defineField: #wParam type: UINT_PTRField readOnly;
		defineField: #lParam type: INT_PTRField readOnly;
		defineField: #scLine type: SDWORDField readOnly;
		defineField: #foldLevelNow type: SDWORDField readOnly;
		defineField: #foldLevelPrev type: SDWORDField readOnly;
		defineField: #margin type: SDWORDField readOnly;
		defineField: #listType type: SDWORDField readOnly;
		defineField: #x type: SDWORDField readOnly;
		defineField: #y type: SDWORDField readOnly! !
!SCNotification class categoriesFor: #defineFields!initializing!public! !

