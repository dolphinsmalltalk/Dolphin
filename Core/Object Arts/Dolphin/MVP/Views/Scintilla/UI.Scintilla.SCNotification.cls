"Filed out from Dolphin Smalltalk"!

OS.NMHDR subclass: #'UI.Scintilla.SCNotification'
	instanceVariableNames: 'view textString'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_annotationLinesAdded' -> 16r54.
		'_OffsetOf_ch' -> 16r10.
		'_OffsetOf_characterSource' -> 16r60.
		'_OffsetOf_foldLevelNow' -> 16r38.
		'_OffsetOf_foldLevelPrev' -> 16r3C.
		'_OffsetOf_length' -> 16r20.
		'_OffsetOf_linesAdded' -> 16r24.
		'_OffsetOf_listCompletionMethod' -> 16r5C.
		'_OffsetOf_listType' -> 16r44.
		'_OffsetOf_lParam' -> 16r30.
		'_OffsetOf_margin' -> 16r40.
		'_OffsetOf_message' -> 16r28.
		'_OffsetOf_modificationType' -> 16r18.
		'_OffsetOf_modifiers' -> 16r14.
		'_OffsetOf_scLine' -> 16r34.
		'_OffsetOf_scPosition' -> 16rC.
		'_OffsetOf_text' -> 16r1C.
		'_OffsetOf_token' -> 16r50.
		'_OffsetOf_updated' -> 16r58.
		'_OffsetOf_wParam' -> 16r2C.
		'_OffsetOf_x' -> 16r48.
		'_OffsetOf_y' -> 16r4C.
		'_SCNotification_Size' -> 16r64
	}!
UI.Scintilla.SCNotification guid: (Core.GUID fromString: '{b4e498b9-ad7b-4519-86f5-1e6232fbd0bd}')!
UI.Scintilla.SCNotification comment: '<SCNotification> is an <ExternalStructure> class to wrap the struct ''ScintillaLib.SCNotification'' from type information in the ''Scintiall 1.46 Type Library'' library.

Note that the ''text'' field is not null terminated (the number of characters is specified by the ''length'' field), and is only valid for SCN_MODIFIED notifications where the SC_MOD_DELETETEXT or SC_MOD_INSERTTEXT ''modificationType'' is specified.'!
!UI.Scintilla.SCNotification categoriesForClass!ScintillaLib-Structs! !
!UI.Scintilla.SCNotification methodsFor!

annotationLinesAdded
	"Answer the <Integer> value of the receiver's 'annotationLinesAdded' field."

	^bytes intPtrAtOffset: _OffsetOf_annotationLinesAdded!

ch
	"Answer the <Integer> value of the receiver's 'ch' field."

	^bytes int32AtOffset: _OffsetOf_ch!

character
	"Answer the receiver's <Character> who's codePoint is stored in the 'ch' field."

	^Character codePoint: self ch!

characterSource
	"Answer the <Integer> value of the receiver's 'characterSource' field."

	^bytes int32AtOffset: _OffsetOf_characterSource!

foldLevelNow
	"Answer the <Integer> value of the receiver's 'foldLevelNow' field."

	^bytes int32AtOffset: _OffsetOf_foldLevelNow!

foldLevelPrev
	"Answer the <Integer> value of the receiver's 'foldLevelPrev' field."

	^bytes int32AtOffset: _OffsetOf_foldLevelPrev!

getValidFields
	"Private - Answer a <sequencedReadableCollection> of the fields defined 
	in the receiver's template, sorted in ascending order of offset from the start of the
	structure, that are valid in this particular instance."

	"From the Scintilla docs:

	struct SCNotification {
		struct Sci_NotifyHeader nmhdr;
		Sci_Position position;
		/* SCN_STYLENEEDED, SCN_DOUBLECLICK, SCN_MODIFIED, SCN_MARGINCLICK, */
		/* SCN_NEEDSHOWN, SCN_DWELLSTART, SCN_DWELLEND, SCN_CALLTIPCLICK, */
		/* SCN_HOTSPOTCLICK, SCN_HOTSPOTDOUBLECLICK, SCN_HOTSPOTRELEASECLICK, */
		/* SCN_INDICATORCLICK, SCN_INDICATORRELEASE, */
		/* SCN_USERLISTSELECTION, SCN_AUTOCSELECTION */

		int ch;
		/* SCN_CHARADDED, SCN_KEY, SCN_AUTOCCOMPLETE, SCN_AUTOCSELECTION, */
		/* SCN_USERLISTSELECTION */
		int modifiers;
		/* SCN_KEY, SCN_DOUBLECLICK, SCN_HOTSPOTCLICK, SCN_HOTSPOTDOUBLECLICK, */
		/* SCN_HOTSPOTRELEASECLICK, SCN_INDICATORCLICK, SCN_INDICATORRELEASE, */

		int modificationType;	/* SCN_MODIFIED */
		const char *text;
		/* SCN_MODIFIED, SCN_USERLISTSELECTION, SCN_AUTOCSELECTION, SCN_URIDROPPED */

		Sci_Position length;		/* SCN_MODIFIED */
		Sci_Position linesAdded;	/* SCN_MODIFIED */
		int message;	/* SCN_MACRORECORD */
		uptr_t wParam;	/* SCN_MACRORECORD */
		sptr_t lParam;	/* SCN_MACRORECORD */
		Sci_Position line;		/* SCN_MODIFIED */
		int foldLevelNow;	/* SCN_MODIFIED */
		int foldLevelPrev;	/* SCN_MODIFIED */
		int margin;		/* SCN_MARGINCLICK */
		int listType;	/* SCN_USERLISTSELECTION */
		int x;			/* SCN_DWELLSTART, SCN_DWELLEND */
		int y;		/* SCN_DWELLSTART, SCN_DWELLEND */
		int token;		/* SCN_MODIFIED with SC_MOD_CONTAINER */
		int annotationLinesAdded;	/* SCN_MODIFIED with SC_MOD_CHANGEANNOTATION */
		int updated;	/* SCN_UPDATEUI */
		int listCompletionMethod;
		/* SCN_AUTOCSELECTION, SCN_AUTOCCOMPLETED, SCN_USERLISTSELECTION */
	};
	"

	^##(| codeOnly positionOnly positionXY positionModifiers listSelection |
	codeOnly := #(#code).
	positionOnly := #(#code #scPosition).
	positionXY := #(#code #scPosition #x #y).
	positionModifiers := #(#code #scPosition #modifiers).
	listSelection := #(#code #scPosition #ch #text #listCompletionMethod).
	IdentityDictionary withAll: {SCN_AUTOCCANCELLED -> codeOnly.
				SCN_AUTOCCHARDELETED -> codeOnly.
				SCN_AUTOCCOMPLETED -> listSelection.
				SCN_AUTOCSELECTION -> listSelection.
				SCN_CALLTIPCLICK -> positionOnly.
				SCN_CHARADDED -> #(#code #ch).
				SCN_DOUBLECLICK -> #(#code #scPosition #modifiers #scLine).
				SCN_DWELLEND -> positionXY.
				SCN_DWELLSTART -> positionXY.
				SCN_FOCUSIN -> codeOnly.
				SCN_FOCUSOUT -> codeOnly.
				SCN_HOTSPOTCLICK -> positionModifiers.
				SCN_HOTSPOTDOUBLECLICK -> positionModifiers.
				SCN_HOTSPOTRELEASECLICK -> positionModifiers.
				SCN_INDICATORCLICK -> positionModifiers.
				SCN_INDICATORRELEASE -> positionModifiers.
				SCN_KEY -> #(#code #ch #modifiers).
				SCN_MACRORECORD -> #(#code #message #wParam #lParam).
				SCN_MARGINCLICK -> #(#code #scPosition #modifiers #margin).
				SCN_MODIFIED
					-> #(#code #scPosition #modificationType #text #length #linesAdded #scLine #foldLevelNow #foldLevelPrev).
				SCN_MODIFYATTEMPTRO -> codeOnly.
				SCN_NEEDSHOWN -> positionOnly.
				SCN_PAINTED -> codeOnly.
				SCN_SAVEPOINTLEFT -> codeOnly.
				SCN_SAVEPOINTREACHED -> codeOnly.
				SCN_STYLENEEDED -> positionOnly.
				SCN_UPDATEUI -> #(#code #updated).
				SCN_URIDROPPED -> #(#code #text).
				SCN_USERLISTSELECTION -> #(#code #scPosition #ch #text #listType #listCompletionMethod)})
			at: self code
			ifAbsent: #(#code)!

isAltKeyDown
	"Answer whether the ALT key was down when the event was raised.
	Only relevant for some notifications such as SCN_KEY, and SCN_HOTSPOT[DOUBLE]CLICK."

	^self modifiers allMask: SCMOD_ALT!

isSelectionUpdate
	"Answer whether an SCN_UPDATEUI event was for a change in selection.
	See http://www.scintilla.org/ScintillaDoc.html#SCN_UPDATEUI"

	^self updated anyMask: SC_UPDATE_SELECTION!

isShiftDown
	"Answer whether the shift key was down when the event was raised.
	Only relevant for some notifications such as SCN_KEY, and SCN_HOTSPOT[DOUBLE]CLICK."

	^self modifiers allMask: SCMOD_SHIFT!

length
	"Answer the <Integer> value of the receiver's 'length' field."

	^bytes intPtrAtOffset: _OffsetOf_length!

line
	"Answer the one-based <integer> line number associated with the notification."

	^self scLine + 1!

linesAdded
	"Answer the <Integer> value of the receiver's 'linesAdded' field."

	^bytes intPtrAtOffset: _OffsetOf_linesAdded!

listCompletionMethod
	"Answer the <Integer> value of the receiver's 'listCompletionMethod' field."

	^bytes int32AtOffset: _OffsetOf_listCompletionMethod!

listType
	"Answer the <Integer> value of the receiver's 'listType' field."

	^bytes int32AtOffset: _OffsetOf_listType!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes intPtrAtOffset: _OffsetOf_lParam!

margin
	"Answer the <Integer> value of the receiver's 'margin' field."

	^bytes int32AtOffset: _OffsetOf_margin!

message
	"Answer the <Integer> value of the receiver's 'message' field."

	^bytes int32AtOffset: _OffsetOf_message!

modificationType
	"Answer the <Integer> value of the receiver's 'modificationType' field."

	^bytes int32AtOffset: _OffsetOf_modificationType!

modifiers
	"Answer the <Integer> value of the receiver's 'modifiers' field."

	^bytes int32AtOffset: _OffsetOf_modifiers!

point
	^self x @ self y!

position
	"Answer the receiver's position field as a Smalltalk object."

	^self scPosition + 1!

scLine
	"Answer the <Integer> value of the receiver's 'scLine' field."

	^bytes intPtrAtOffset: _OffsetOf_scLine!

scPosition
	"Answer the <Integer> value of the receiver's 'scPosition' field."

	^bytes intPtrAtOffset: _OffsetOf_scPosition!

text
	"Answer the <Integer> value of the receiver's 'text' field."

	^bytes uintPtrAtOffset: _OffsetOf_text!

textString
	^textString ifNil: [textString := view stringClass fromAddress: self text]!

token
	"Answer the <Integer> value of the receiver's 'token' field."

	^bytes int32AtOffset: _OffsetOf_token!

updated
	"Answer the <Integer> value of the receiver's 'updated' field."

	^bytes int32AtOffset: _OffsetOf_updated!

view: aScintillaView
	view := aScintillaView!

wParam
	"Answer the <Integer> value of the receiver's 'wParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_wParam!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes int32AtOffset: _OffsetOf_x!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes int32AtOffset: _OffsetOf_y! !
!UI.Scintilla.SCNotification categoriesForMethods!
annotationLinesAdded!**compiled accessors**!public! !
ch!**compiled accessors**!public! !
character!accessing!public! !
characterSource!**compiled accessors**!public! !
foldLevelNow!**compiled accessors**!public! !
foldLevelPrev!**compiled accessors**!public! !
getValidFields!accessing!private! !
isAltKeyDown!public!testing! !
isSelectionUpdate!public!testing! !
isShiftDown!public!testing! !
length!**compiled accessors**!public! !
line!accessing!public! !
linesAdded!**compiled accessors**!public! !
listCompletionMethod!**compiled accessors**!public! !
listType!**compiled accessors**!public! !
lParam!**compiled accessors**!public! !
margin!**compiled accessors**!public! !
message!**compiled accessors**!public! !
modificationType!**compiled accessors**!public! !
modifiers!**compiled accessors**!public! !
point!accessing!public! !
position!accessing!public! !
scLine!**compiled accessors**!public! !
scPosition!**compiled accessors**!public! !
text!**compiled accessors**!public! !
textString!accessing!public! !
token!**compiled accessors**!public! !
updated!**compiled accessors**!public! !
view:!accessing!private! !
wParam!**compiled accessors**!public! !
x!**compiled accessors**!public! !
y!**compiled accessors**!public! !
!

!UI.Scintilla.SCNotification class methodsFor!

byteSize
	^_SCNotification_Size!

defineFields
	"Define the fields of the SCNotification structure.
		SCNotification compileDefinition
	"

	super defineFields.
	self
		defineField: #scPosition type: IntPtrField readOnly;
		defineField: #ch type: Int32Field readOnly;
		defineField: #modifiers type: Int32Field readOnly;
		defineField: #modificationType type: Int32Field readOnly;
		defineField: #text type: UIntPtrField readOnly;
		defineField: #length type: IntPtrField readOnly;
		defineField: #linesAdded type: IntPtrField readOnly;
		defineField: #message type: Int32Field readOnly;
		defineField: #wParam type: UIntPtrField readOnly;
		defineField: #lParam type: IntPtrField readOnly;
		defineField: #scLine type: IntPtrField readOnly;
		defineField: #foldLevelNow type: Int32Field readOnly;
		defineField: #foldLevelPrev type: Int32Field readOnly;
		defineField: #margin type: Int32Field readOnly;
		defineField: #listType type: Int32Field readOnly;
		defineField: #x type: Int32Field readOnly;
		defineField: #y type: Int32Field readOnly;
		defineField: #token type: Int32Field readOnly;
		defineField: #annotationLinesAdded type: IntPtrField readOnly;
		defineField: #updated type: Int32Field readOnly;
		defineField: #listCompletionMethod type: Int32Field readOnly;
		defineField: #characterSource type: Int32Field readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #scPosition #ch #modifiers #modificationType #text #length #linesAdded #message #wParam #lParam #scLine #foldLevelNow #foldLevelPrev #margin #listType #x #y #token #annotationLinesAdded #updated #listCompletionMethod #characterSource)! !
!UI.Scintilla.SCNotification class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

