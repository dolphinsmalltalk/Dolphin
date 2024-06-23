"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.TASKDIALOG_BUTTON'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_nButtonID' -> 16r0.
			'_OffsetOf_pszButtonText' -> 16r4.
			'_TASKDIALOG_BUTTON_Size' -> 16r8
		}!

OS.TASKDIALOG_BUTTON guid: (Core.GUID fromString: '{19c44fa3-bf97-499c-a411-0252c8b78b31}')!

OS.TASKDIALOG_BUTTON comment: '`TASKDIALOG_BUTTON` is an `External.Structure` class to wrap the struct ''Win32.TASKDIALOG_BUTTON'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(19c44fa3-bf97-499c-a411-0252c8b78b31)]
struct tagTASKDIALOG_BUTTON {
	[helpstring("Value to be returned when this button is selected.")] int nButtonID;
	[helpstring("Button label, either a null-terminated string or an integer resource identifier. When using Command Links, you delineate the command from the note by placing a new line character in the string."), string] LPCWSTR pszButtonText;
} TASKDIALOG_BUTTON;
```
'!

!OS.TASKDIALOG_BUTTON categoriesForClass!Win32-Structs! !

!OS.TASKDIALOG_BUTTON methodsFor!

nButtonID
	"Answer the <Integer> value of the receiver's 'nButtonID' field."

	^bytes int32AtOffset: _OffsetOf_nButtonID!

nButtonID: anInteger
	"Set the receiver's 'nButtonID' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_nButtonID put: anInteger!

pszButtonText
	"Answer the <Utf16String> value of the receiver's 'pszButtonText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszButtonText)!

pszButtonText: anUtf16String
	"Set the receiver's 'pszButtonText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszButtonText put: anUtf16String yourAddress! !

!OS.TASKDIALOG_BUTTON categoriesForMethods!
nButtonID!**compiled accessors**!public! !
nButtonID:!**compiled accessors**!public! !
pszButtonText!**compiled accessors**!public! !
pszButtonText:!**compiled accessors**!public! !
!

!OS.TASKDIALOG_BUTTON class methodsFor!

byteSize
	^_TASKDIALOG_BUTTON_Size!

defineFields
	"Define the fields of the TASKDIALOG_BUTTON structure.

	TASKDIALOG_BUTTON compileDefinition

		typedef [uuid(19c44fa3-bf97-499c-a411-0252c8b78b31)]
		struct tagTASKDIALOG_BUTTON {
			[helpstring('Value to be returned when this button is selected.')] int nButtonID;
			[helpstring('Button label, either a null-terminated string or an integer resource identifier. When using Command Links, you delineate the command from the note by placing a new line character in the string.'), string] LPCWSTR pszButtonText;
		} TASKDIALOG_BUTTON;
"

	self
		defineField: #nButtonID type: Int32Field new offset: 0;
		defineField: #pszButtonText type: (PointerField type: Utf16String) offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#nButtonID #pszButtonText)! !

!OS.TASKDIALOG_BUTTON class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

