"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #TEXTRANGE
	instanceVariableNames: 'text'
	classVariableNames: '_OffsetOf_chrg _OffsetOf_lpstrText'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TEXTRANGE guid: (GUID fromString: '{87b4c615-026e-11d3-9fd7-00a0cc3e4a32}')!
TEXTRANGE addClassConstant: '_OffsetOf_chrg' value: 16r0!
TEXTRANGE addClassConstant: '_OffsetOf_lpstrText' value: 16r8!
TEXTRANGE comment: 'TEXTRANGE is the class of <ExternalStructure> which represents the Windows TEXTRANGE and TEXTRANGEW structures.

Most of the ExternalStructures in Dolphin are now for wide character APIs only, and indeed TEXTRANGE is used with wide strings for the <RichTextEdit> control. However, it is also used with Scintilla, which only supports byte string encodings (including UTF-8). Scintilla also uses the structure to retrieve styling bytes, which aren''t characters at all.

An example use of TEXTRANGE is with the EM_GETTEXTRANGE message to specify the range of text to retrieve from a Rich Edit control and to provide a buffer to copy the text into.

Instance Variables:
	text		<AnsiString|Utf8String|Utf16String|ByteArray>. Buffer whose address is stored into structure (to prevent premature GC).'!
!TEXTRANGE categoriesForClass!Win-Structs! !
!TEXTRANGE methodsFor!

cpMax
	"Answer the receiver's cpMax field as a Smalltalk object."

	^(bytes sdwordAtOffset: 4)!

cpMax: anObject
	"Set the receiver's cpMax field to the value of anObject."

	bytes sdwordAtOffset: 4 put: anObject!

cpMin
	"Answer the receiver's cpMin field as a Smalltalk object."

	^(bytes sdwordAtOffset: 0)!

cpMin: anObject
	"Set the receiver's cpMin field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

lpstrText: anInteger
	"Set the receiver's 'lpstrText' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_lpstrText put: anInteger!

setFrom: start to: stop text: aString
	"Initialize the receiver with the specified range and text.
	Answer the receiver."

	self cpMin: start; cpMax: stop.
	self text: aString!

size
	^self cpMax - self cpMin!

start
	"Answer the one-based <Integer> index of the first character in the interval."

	^self cpMin + 1!

stop
	"Answer the one-based <integer> index of the end of the last character in the interval."

	^self cpMax
!

text
	"Answer the value of the receiver's 'text' instance variable."

	^text!

text: buffer
	"Set the value of the receiver's 'text' instance variable to <String> argument, buffer.
	Note that buffer should have been allocated from the fixed heap."

	self lpstrText: (text := buffer) yourAddress! !
!TEXTRANGE categoriesForMethods!
cpMax!accessing!public! !
cpMax:!accessing!public! !
cpMin!accessing!public! !
cpMin:!accessing!public! !
lpstrText:!**compiled accessors**!public! !
setFrom:to:text:!initializing!private! !
size!accessing!public! !
start!accessing!public! !
stop!accessing!public! !
text!accessing!public! !
text:!accessing!public! !
!

!TEXTRANGE class methodsFor!

defineFields
	"Define the fields of the TEXTRANGE structure.
		TEXTRANGE compileDefinition
	
		typedef 
		struct tagTEXTRANGE {
			CHARRANGE chrg;
			LPTSTR lpstrText;
		} TEXTRANGE;

	Note that because we use this for byte strings and byte arrays with Scintilla, and UTF-16 strings for RichEdit, the lpstrText field is defined as a generic pointer.
	"

	self
		defineField: #chrg type: (StructureField type: CHARRANGE) beUncompiled;
		defineField: #lpstrText type: UINT_PTRField writeOnly!

from: startInteger to: stopInteger text: aString 
	"Answer a new instance of the receiver to represent the specified 0-based, 
	end-exclusive, interval, and the text, aString."

	^self new 
		setFrom: startInteger
		to: stopInteger
		text: aString!

from: startInteger to: stopInteger type: aStringClass
	"Answer a new instance of the receiver to represent the specified 0-based, 
	end-exclusive, interval."

	^self 
		from: startInteger
		to: stopInteger
		text: (aStringClass newFixed: stopInteger - startInteger)!

getFieldNames
	^#(#chrg #lpstrText)! !
!TEXTRANGE class categoriesForMethods!
defineFields!public!template definition! !
from:to:text:!instance creation!public! !
from:to:type:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

