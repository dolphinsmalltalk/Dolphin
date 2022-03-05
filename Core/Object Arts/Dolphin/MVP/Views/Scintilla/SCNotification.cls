"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #SCNotification
	instanceVariableNames: 'view textString'
	classVariableNames: '_OffsetOf_annotationLinesAdded _OffsetOf_ch _OffsetOf_characterSource _OffsetOf_foldLevelNow _OffsetOf_foldLevelPrev _OffsetOf_length _OffsetOf_linesAdded _OffsetOf_listCompletionMethod _OffsetOf_listType _OffsetOf_lParam _OffsetOf_margin _OffsetOf_message _OffsetOf_modificationType _OffsetOf_modifiers _OffsetOf_scLine _OffsetOf_scPosition _OffsetOf_text _OffsetOf_token _OffsetOf_updated _OffsetOf_wParam _OffsetOf_x _OffsetOf_y'
	poolDictionaries: 'ScintillaConstants'
	classInstanceVariableNames: ''!
SCNotification guid: (GUID fromString: '{b4e498b9-ad7b-4519-86f5-1e6232fbd0bd}')!
SCNotification addClassConstant: '_OffsetOf_annotationLinesAdded' value: 16r54!
SCNotification addClassConstant: '_OffsetOf_ch' value: 16r10!
SCNotification addClassConstant: '_OffsetOf_characterSource' value: 16r60!
SCNotification addClassConstant: '_OffsetOf_foldLevelNow' value: 16r38!
SCNotification addClassConstant: '_OffsetOf_foldLevelPrev' value: 16r3C!
SCNotification addClassConstant: '_OffsetOf_length' value: 16r20!
SCNotification addClassConstant: '_OffsetOf_linesAdded' value: 16r24!
SCNotification addClassConstant: '_OffsetOf_listCompletionMethod' value: 16r5C!
SCNotification addClassConstant: '_OffsetOf_listType' value: 16r44!
SCNotification addClassConstant: '_OffsetOf_lParam' value: 16r30!
SCNotification addClassConstant: '_OffsetOf_margin' value: 16r40!
SCNotification addClassConstant: '_OffsetOf_message' value: 16r28!
SCNotification addClassConstant: '_OffsetOf_modificationType' value: 16r18!
SCNotification addClassConstant: '_OffsetOf_modifiers' value: 16r14!
SCNotification addClassConstant: '_OffsetOf_scLine' value: 16r34!
SCNotification addClassConstant: '_OffsetOf_scPosition' value: 16rC!
SCNotification addClassConstant: '_OffsetOf_text' value: 16r1C!
SCNotification addClassConstant: '_OffsetOf_token' value: 16r50!
SCNotification addClassConstant: '_OffsetOf_updated' value: 16r58!
SCNotification addClassConstant: '_OffsetOf_wParam' value: 16r2C!
SCNotification addClassConstant: '_OffsetOf_x' value: 16r48!
SCNotification addClassConstant: '_OffsetOf_y' value: 16r4C!
SCNotification comment: '<SCNotification> is an <ExternalStructure> class to wrap the struct ''ScintillaLib.SCNotification'' from type information in the ''Scintiall 1.46 Type Library'' library.

Note that the ''text'' field is not null terminated (the number of characters is specified by the ''length'' field), and is only valid for SCN_MODIFIED notifications where the SC_MOD_DELETETEXT or SC_MOD_INSERTTEXT ''modificationType'' is specified.'!
!SCNotification categoriesForClass!ScintillaLib-Structs! !
!SCNotification methodsFor!

annotationLinesAdded
	"Answer the <Integer> value of the receiver's 'annotationLinesAdded' field."

	^bytes intPtrAtOffset: _OffsetOf_annotationLinesAdded!

ch
	"Answer the <Integer> value of the receiver's 'ch' field."

	^bytes sdwordAtOffset: _OffsetOf_ch!

character
	"Answer the receiver's <Character> who's codePoint is stored in the 'ch' field."

	^Character codePoint: self ch!

characterSource
	"Answer the <Integer> value of the receiver's 'characterSource' field."

	^bytes sdwordAtOffset: _OffsetOf_characterSource!

foldLevelNow
	"Answer the <Integer> value of the receiver's 'foldLevelNow' field."

	^bytes sdwordAtOffset: _OffsetOf_foldLevelNow!

foldLevelPrev
	"Answer the <Integer> value of the receiver's 'foldLevelPrev' field."

	^bytes sdwordAtOffset: _OffsetOf_foldLevelPrev!

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

	^#(#code)
		, (##(| positionOnly positionXY positionModifiers listSelection |
			positionOnly := #(#scPosition).
			positionXY := #(#scPosition #x #y).
			positionModifiers := #(#scPosition #modifiers).
			listSelection := #(#scPosition #ch #text #listCompletionMethod).
			IdentityDictionary new
				at: SCN_AUTOCCANCELLED put: #();
				at: SCN_AUTOCCHARDELETED put: #();
				at: SCN_AUTOCCOMPLETED put: listSelection;
				at: SCN_AUTOCSELECTION put: listSelection;
				at: SCN_CALLTIPCLICK put: positionOnly;
				at: SCN_CHARADDED put: #(#ch);
				at: SCN_DOUBLECLICK put: #(#scPosition #modifiers #scLine);
				at: SCN_DWELLEND put: positionXY;
				at: SCN_DWELLSTART put: positionXY;
				at: SCN_FOCUSIN put: #();
				at: SCN_FOCUSOUT put: #();
				at: SCN_HOTSPOTCLICK put: positionModifiers;
				at: SCN_HOTSPOTDOUBLECLICK put: positionModifiers;
				at: SCN_HOTSPOTRELEASECLICK put: positionModifiers;
				at: SCN_INDICATORCLICK put: positionModifiers;
				at: SCN_INDICATORRELEASE put: positionModifiers;
				at: SCN_KEY put: #(#ch #modifiers);
				at: SCN_MACRORECORD put: #(#message #wParam #lParam);
				at: SCN_MARGINCLICK put: #(#scPosition #modifiers #margin);
				at: SCN_MODIFIED
					put: #(#scPosition #modificationType #text #length #linesAdded #scLine #foldLevelNow #foldLevelPrev);
				at: SCN_MODIFYATTEMPTRO put: #();
				at: SCN_NEEDSHOWN put: positionOnly;
				at: SCN_PAINTED put: #();
				at: SCN_SAVEPOINTLEFT put: #();
				at: SCN_SAVEPOINTREACHED put: #();
				at: SCN_STYLENEEDED put: positionOnly;
				at: SCN_UPDATEUI put: #(#updated);
				at: SCN_URIDROPPED put: #(#text);
				at: SCN_USERLISTSELECTION put: #(#scPosition #ch #text #listType #listCompletionMethod);
				shrink) at: self code ifAbsent: [#()])!

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

	^bytes sdwordAtOffset: _OffsetOf_listCompletionMethod!

listType
	"Answer the <Integer> value of the receiver's 'listType' field."

	^bytes sdwordAtOffset: _OffsetOf_listType!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes intPtrAtOffset: _OffsetOf_lParam!

margin
	"Answer the <Integer> value of the receiver's 'margin' field."

	^bytes sdwordAtOffset: _OffsetOf_margin!

message
	"Answer the <Integer> value of the receiver's 'message' field."

	^bytes sdwordAtOffset: _OffsetOf_message!

modificationType
	"Answer the <Integer> value of the receiver's 'modificationType' field."

	^bytes sdwordAtOffset: _OffsetOf_modificationType!

modifiers
	"Answer the <Integer> value of the receiver's 'modifiers' field."

	^bytes sdwordAtOffset: _OffsetOf_modifiers!

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

	^bytes sdwordAtOffset: _OffsetOf_token!

updated
	"Answer the <Integer> value of the receiver's 'updated' field."

	^bytes sdwordAtOffset: _OffsetOf_updated!

view: aScintillaView
	view := aScintillaView!

wParam
	"Answer the <Integer> value of the receiver's 'wParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_wParam!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: _OffsetOf_x!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: _OffsetOf_y! !
!SCNotification categoriesForMethods!
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

!SCNotification class methodsFor!

defineFields
	"Define the fields of the SCNotification structure.
		SCNotification compileDefinition
	"

	super defineFields.
	self
		defineField: #scPosition type: INT_PTRField readOnly;
		defineField: #ch type: SDWORDField readOnly;
		defineField: #modifiers type: SDWORDField readOnly;
		defineField: #modificationType type: SDWORDField readOnly;
		defineField: #text type: UINT_PTRField  readOnly;
		defineField: #length type: INT_PTRField readOnly;
		defineField: #linesAdded type: INT_PTRField readOnly;
		defineField: #message type: SDWORDField readOnly;
		defineField: #wParam type: UINT_PTRField readOnly;
		defineField: #lParam type: INT_PTRField readOnly;
		defineField: #scLine type: INT_PTRField readOnly;
		defineField: #foldLevelNow type: SDWORDField readOnly;
		defineField: #foldLevelPrev type: SDWORDField readOnly;
		defineField: #margin type: SDWORDField readOnly;
		defineField: #listType type: SDWORDField readOnly;
		defineField: #x type: SDWORDField readOnly;
		defineField: #y type: SDWORDField readOnly;
		defineField: #token type: SDWORDField readOnly;
		defineField: #annotationLinesAdded type: INT_PTRField readOnly;
		defineField: #updated type: SDWORDField readOnly;
		defineField: #listCompletionMethod type: SDWORDField readOnly;
		defineField: #characterSource type: SDWORDField readOnly.!

getFieldNames
	^#(#hwndFrom #idFrom #code #scPosition #ch #modifiers #modificationType #text #length #linesAdded #message #wParam #lParam #scLine #foldLevelNow #foldLevelPrev #margin #listType #x #y #token #annotationLinesAdded #updated #listCompletionMethod #characterSource)! !
!SCNotification class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

