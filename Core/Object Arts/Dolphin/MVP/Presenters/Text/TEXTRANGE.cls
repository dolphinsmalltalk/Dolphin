"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #TEXTRANGE
	instanceVariableNames: 'text'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TEXTRANGE guid: (GUID fromString: '{87B4C615-026E-11D3-9FD7-00A0CC3E4A32}')!
TEXTRANGE comment: 'TEXTRANGE is the class of <ExternalStructure> which represent the Windows RichEdit control structure of the same name.

TEXTRANGE is used in conjunction with the EM_GETTEXTRANGE message to specify the range of text to retrieve from a Rich Edit control and to provide a buffer to copy the text into.

We also use this structure where a FINDTEXT is needed because it has exactly the same layout. The FINDTEXT structure is used in conjunction with the EM_FINDTEXT message to contain information about a search operation in a Rich Edit control.

Instance Variables:
	text		<String>. Buffer whose address is stored into structure (to prevent premature GC).'!
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

lpstrText: anObject 
	"Set the receiver's lpstrText field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrText) put: anObject yourAddress!

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

	self lpstrText: (text := buffer)! !
!TEXTRANGE categoriesFor: #cpMax!public! !
!TEXTRANGE categoriesFor: #cpMax:!public! !
!TEXTRANGE categoriesFor: #cpMin!public! !
!TEXTRANGE categoriesFor: #cpMin:!public! !
!TEXTRANGE categoriesFor: #lpstrText:!**compiled accessors**!public! !
!TEXTRANGE categoriesFor: #setFrom:to:text:!initializing!private! !
!TEXTRANGE categoriesFor: #size!accessing!public! !
!TEXTRANGE categoriesFor: #start!accessing!public! !
!TEXTRANGE categoriesFor: #stop!accessing!public! !
!TEXTRANGE categoriesFor: #text!accessing!public! !
!TEXTRANGE categoriesFor: #text:!accessing!public! !

!TEXTRANGE class methodsFor!

defineFields
	"Define the fields of the TEXTRANGE structure.
		TEXTRANGE compileDefinition
	
		typedef 
		struct tagTEXTRANGE {
			CHARRANGE chrg;
			LPSTR lpstrText;
		} TEXTRANGE;
"

	self
		defineField: #chrg type: (StructureField type: CHARRANGE) beUncompiled;
		defineField: #lpstrText type: (PointerField type: String) beWriteOnly!

from: startInteger to: stopInteger 
	"Answer a new instance of the receiver to represent the specified 0-based, 
	end-exclusive, interval."

	^self 
		from: startInteger
		to: stopInteger
		text: (String newFixed: stopInteger - startInteger)!

from: startInteger to: stopInteger text: aString 
	"Answer a new instance of the receiver to represent the specified 0-based, 
	end-exclusive, interval, and the text, aString."

	^self new 
		setFrom: startInteger
		to: stopInteger
		text: aString! !
!TEXTRANGE class categoriesFor: #defineFields!initializing!public! !
!TEXTRANGE class categoriesFor: #from:to:!instance creation!public! !
!TEXTRANGE class categoriesFor: #from:to:text:!instance creation!public! !

