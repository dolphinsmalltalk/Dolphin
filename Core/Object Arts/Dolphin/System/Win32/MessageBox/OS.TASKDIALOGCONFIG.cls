"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.TASKDIALOGCONFIG'
	instanceVariableNames: 'windowTitle mainInstruction content footer verificationText expandedInformation collapsedControlText expandedControlText buttons buttonLabels radioButtons radioButtonLabels'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cButtons' -> 16r24.
		'_OffsetOf_cRadioButtons' -> 16r30.
		'_OffsetOf_cxWidth' -> 16r5C.
		'_OffsetOf_dwCommonButtons' -> 16r10.
		'_OffsetOf_dwFlags' -> 16rC.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_hFooterIcon' -> 16r4C.
		'_OffsetOf_hInstance' -> 16r8.
		'_OffsetOf_hMainIcon' -> 16r18.
		'_OffsetOf_hwndParent' -> 16r4.
		'_OffsetOf_lpCallbackData' -> 16r58.
		'_OffsetOf_nDefaultButton' -> 16r2C.
		'_OffsetOf_nDefaultRadioButton' -> 16r38.
		'_OffsetOf_pButtons' -> 16r28.
		'_OffsetOf_pfCallback' -> 16r54.
		'_OffsetOf_pRadioButtons' -> 16r34.
		'_OffsetOf_pszCollapsedControlText' -> 16r48.
		'_OffsetOf_pszContent' -> 16r20.
		'_OffsetOf_pszExpandedControlText' -> 16r44.
		'_OffsetOf_pszExpandedInformation' -> 16r40.
		'_OffsetOf_pszFooter' -> 16r50.
		'_OffsetOf_pszFooterIcon' -> 16r4C.
		'_OffsetOf_pszMainIcon' -> 16r18.
		'_OffsetOf_pszMainInstruction' -> 16r1C.
		'_OffsetOf_pszVerificationText' -> 16r3C.
		'_OffsetOf_pszWindowTitle' -> 16r14.
		'_TASKDIALOGCONFIG_Size' -> 16r60
	}!
OS.TASKDIALOGCONFIG guid: (Core.GUID fromString: '{948de028-015b-4a2a-818e-db8b5f40aa75}')!
OS.TASKDIALOGCONFIG comment: '`TASKDIALOGCONFIG` is an `External.Structure` class to wrap the Windows common controls [TASKDIALOGCONFIG structure](https://docs.microsoft.com/en-us/windows/win32/api/Commctrl/ns-commctrl-taskdialogconfig) structure.

##IDL definition:
```
typedef [uuid(948de028-015b-4a2a-818e-db8b5f40aa75)]
struct tagTASKDIALOGCONFIG {
	[restricted, helpstring("The structure size, in bytes.")] unsigned int dwSize;
	[helpstring("The owner window for the dialog (not a parent).")] wireHWND hwndParent;
	[helpstring("Handle of module containing string and icon resources")] HINSTANCE HINSTANCE;
	[helpstring("Flags specifying the behaviour of the task dialog")] TASKDIALOG_FLAGS dwFlags;
	[helpstring("Flags specifying the buttons to be displayed in the class dialog")] TASKDIALOG_COMMON_BUTTON_FLAGS dwCommonButtons;
	[helpstring("The caption for the dialog (either a string, or integer resource id)"), string] LPCWSTR pszWindowTitle;
	union {
		[helpstring("Handle of the Icon to be displayed as the main icon in the dialog.")] HICON hMainIcon;
		[hidden, helpstring("Identifier of icon resource to be displaed as the main icon in the dialog")] LPCWSTR pszMainIcon;
	};
	[helpstring("Main instruction text to be displayed in the dialog (string or integer resource id"), string] LPCWSTR pszMainInstruction;
	[helpstring("Context text to be displayed in the dialog (string or integer resource id"), string] LPCWSTR pszContent;
	[helpstring("The number of entries in the pButtons array")] unsigned int cButtons;
	[helpstring("Array of button descriptions"), size_is("cButtons")] TASKDIALOG_BUTTON* pButtons;
	[helpstring("Identifies the default button: Either the id of a common button, or the nButtonId of one of the buttons in the pButtons array")] int nDefaultButton;
	[helpstring("The number of entries in the pRadioButtons array")] unsigned int cRadioButtons;
	[helpstring("Array of radio button descriptions"), size_is("cRadioButtons")] TASKDIALOG_BUTTON* pRadioButtons;
	[helpstring("Identifies the default button from pRadioButtons by its nButtonId")] int nDefaultRadioButton;
	[helpstring("Label for the verification checkbox (string or integer resource id"), string] LPCWSTR pszVerificationText;
	[helpstring("Expandable information text (string or integer resource id"), string] LPCWSTR pszExpandedInformation;
	[helpstring("Label to be displayed on the expandable information button when expanded (string or integer resource id"), string] LPCWSTR pszExpandedControlText;
	[helpstring("Label to be displayed on the expandable information button when collapsed (string or integer resource id"), string] LPCWSTR pszCollapsedControlText;
	union {
		[helpstring("Handle of the Icon to be displayed as the footer icon in the dialog.")] HICON hFooterIcon;
		[hidden, helpstring("Identifier of icon resource to be displaed as the footer icon in the dialog")] LPCWSTR pszFooterIcon;
	};
	[helpstring("Footer text (string or integer resource id). Can contain hyperlinks "), string] LPCWSTR pszFooter;
	[restricted, helpstring("Pointer to an application-defined callback function.")] LPVOID pfCallback;
	[hidden, helpstring("Data to be passed to callback function.")] LONG_PTR lpCallbackData;
	[helpstring("width of the Task Dialog''s client area in DLU''s. If 0, Task Dialog will calculate the ideal width.")] unsigned int cxWidth;
} TASKDIALOGCONFIG;
```
'!
!OS.TASKDIALOGCONFIG categoriesForClass!Win32-Structs! !
!OS.TASKDIALOGCONFIG methodsFor!

buttons: aSequenceOfPairs
	| count |
	count := aSequenceOfPairs size.
	buttonLabels := Array new: count.
	buttons := StructureArray
				length: count
				elementClass: TASKDIALOG_BUTTON
				initializer: 
					[:button :i |
					| attrs label |
					attrs := aSequenceOfPairs at: i.
					label := attrs second.
					label := label isString
								ifTrue: 
									[label := (attrs size > 2 ifTrue: [(label copyWith: $\n) , (attrs at: 3)] ifFalse: [label])
												asUtf16String].
					button
						nButtonID: attrs first;
						pszButtonText: label.
					buttonLabels at: i put: label].
	self pButtons: buttons!

cButtons
	"Answer the <Integer> value of the receiver's 'cButtons' field."

	^bytes uint32AtOffset: _OffsetOf_cButtons!

cButtons: anInteger
	"Set the receiver's 'cButtons' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cButtons put: anInteger!

collapsedControlText: aString
	self pszCollapsedControlText: (collapsedControlText := aString ifNotNil: [aString asUtf16String])!

content: aString
	self pszContent: (content := aString ifNotNil: [aString asUtf16String])!

cRadioButtons
	"Answer the <Integer> value of the receiver's 'cRadioButtons' field."

	^bytes uint32AtOffset: _OffsetOf_cRadioButtons!

cRadioButtons: anInteger
	"Set the receiver's 'cRadioButtons' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cRadioButtons put: anInteger!

cxWidth
	"Answer the <Integer> value of the receiver's 'cxWidth' field."

	^bytes uint32AtOffset: _OffsetOf_cxWidth!

cxWidth: anInteger
	"Set the receiver's 'cxWidth' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cxWidth put: anInteger!

dwCommonButtons
	"Answer the <Integer> value of the receiver's 'dwCommonButtons' field."

	^bytes int32AtOffset: _OffsetOf_dwCommonButtons!

dwCommonButtons: anInteger
	"Set the receiver's 'dwCommonButtons' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_dwCommonButtons put: anInteger!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes int32AtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_dwFlags put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

expandedControlText: aString
	self pszExpandedControlText: (expandedControlText := aString ifNotNil: [aString asUtf16String])!

expandedInformation: aString
	self pszExpandedInformation: (expandedInformation := aString ifNotNil: [aString asUtf16String])!

footer: aString
	self pszFooter: (footer := aString ifNotNil: [aString asUtf16String])!

hFooterIcon
	"Answer the <Handle> value of the receiver's 'hFooterIcon' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hFooterIcon) asExternalHandle!

hFooterIcon: aHandle
	"Set the receiver's 'hFooterIcon' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hFooterIcon put: aHandle!

hInstance
	"Answer the <Handle> value of the receiver's 'hInstance' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hInstance) asExternalHandle!

hInstance: aHandle
	"Set the receiver's 'hInstance' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hInstance put: aHandle!

hMainIcon
	"Answer the <Handle> value of the receiver's 'hMainIcon' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hMainIcon) asExternalHandle!

hMainIcon: aHandle
	"Set the receiver's 'hMainIcon' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hMainIcon put: aHandle!

hwndParent
	"Answer the <Handle> value of the receiver's 'hwndParent' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hwndParent) asExternalHandle!

hwndParent: aHandle
	"Set the receiver's 'hwndParent' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwndParent put: aHandle!

mainInstruction: aString
	self pszMainInstruction: (mainInstruction := aString ifNotNil: [aString asUtf16String])!

nDefaultButton
	"Answer the <Integer> value of the receiver's 'nDefaultButton' field."

	^bytes int32AtOffset: _OffsetOf_nDefaultButton!

nDefaultButton: anInteger
	"Set the receiver's 'nDefaultButton' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_nDefaultButton put: anInteger!

nDefaultRadioButton
	"Answer the <Integer> value of the receiver's 'nDefaultRadioButton' field."

	^bytes int32AtOffset: _OffsetOf_nDefaultRadioButton!

nDefaultRadioButton: anInteger
	"Set the receiver's 'nDefaultRadioButton' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_nDefaultRadioButton put: anInteger!

pButtons
	"Answer the <StructureArray> value of the receiver's 'pButtons' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_pButtons)
		length: self cButtons
		elementClass: TASKDIALOG_BUTTON!

pButtons: aStructureArray
	"Set the receiver's 'pButtons' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: _OffsetOf_pButtons put: aStructureArray yourAddress.
	self cButtons: aStructureArray size!

pfCallback: anAddress
	"Set the receiver's 'pfCallback' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_pfCallback put: anAddress!

pRadioButtons
	"Answer the <StructureArray> value of the receiver's 'pRadioButtons' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_pRadioButtons)
		length: self cRadioButtons
		elementClass: TASKDIALOG_BUTTON!

pRadioButtons: aStructureArray
	"Set the receiver's 'pRadioButtons' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: _OffsetOf_pRadioButtons put: aStructureArray yourAddress.
	self cRadioButtons: aStructureArray size!

pszCollapsedControlText
	"Answer the <Utf16String> value of the receiver's 'pszCollapsedControlText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszCollapsedControlText)!

pszCollapsedControlText: anUtf16String
	"Set the receiver's 'pszCollapsedControlText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszCollapsedControlText put: anUtf16String yourAddress!

pszContent
	"Answer the <Utf16String> value of the receiver's 'pszContent' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszContent)!

pszContent: anUtf16String
	"Set the receiver's 'pszContent' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszContent put: anUtf16String yourAddress!

pszExpandedControlText
	"Answer the <Utf16String> value of the receiver's 'pszExpandedControlText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszExpandedControlText)!

pszExpandedControlText: anUtf16String
	"Set the receiver's 'pszExpandedControlText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszExpandedControlText put: anUtf16String yourAddress!

pszExpandedInformation
	"Answer the <Utf16String> value of the receiver's 'pszExpandedInformation' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszExpandedInformation)!

pszExpandedInformation: anUtf16String
	"Set the receiver's 'pszExpandedInformation' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszExpandedInformation put: anUtf16String yourAddress!

pszFooter
	"Answer the <Utf16String> value of the receiver's 'pszFooter' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszFooter)!

pszFooter: anUtf16String
	"Set the receiver's 'pszFooter' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszFooter put: anUtf16String yourAddress!

pszMainInstruction
	"Answer the <Utf16String> value of the receiver's 'pszMainInstruction' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszMainInstruction)!

pszMainInstruction: anUtf16String
	"Set the receiver's 'pszMainInstruction' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszMainInstruction put: anUtf16String yourAddress!

pszVerificationText
	"Answer the <Utf16String> value of the receiver's 'pszVerificationText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszVerificationText)!

pszVerificationText: anUtf16String
	"Set the receiver's 'pszVerificationText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszVerificationText put: anUtf16String yourAddress!

pszWindowTitle
	"Answer the <Utf16String> value of the receiver's 'pszWindowTitle' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszWindowTitle)!

pszWindowTitle: anUtf16String
	"Set the receiver's 'pszWindowTitle' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszWindowTitle put: anUtf16String yourAddress!

radioButtons: aSequenceOfPairs
	| count |
	count := aSequenceOfPairs size.
	radioButtonLabels := Array new: count.
	radioButtons := StructureArray
				length: count
				elementClass: TASKDIALOG_BUTTON
				initializer: 
					[:button :i |
					| label |
					label := (aSequenceOfPairs at: i) second.
					label := label isString ifTrue: [label := label asUtf16String].
					button
						nButtonID: i;
						pszButtonText: label.
					radioButtonLabels at: i put: label].
	self pRadioButtons: radioButtons!

verificationText: aString
	self pszVerificationText: (verificationText := aString ifNotNil: [aString asUtf16String])!

windowTitle: aString
	self pszWindowTitle: (windowTitle := aString ifNotNil: [aString asUtf16String])! !
!OS.TASKDIALOGCONFIG categoriesForMethods!
buttons:!accessing!public! !
cButtons!**compiled accessors**!public! !
cButtons:!**compiled accessors**!public! !
collapsedControlText:!accessing!public! !
content:!accessing!public! !
cRadioButtons!**compiled accessors**!public! !
cRadioButtons:!**compiled accessors**!public! !
cxWidth!**compiled accessors**!public! !
cxWidth:!**compiled accessors**!public! !
dwCommonButtons!**compiled accessors**!public! !
dwCommonButtons:!**compiled accessors**!public! !
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
expandedControlText:!accessing!public! !
expandedInformation:!accessing!public! !
footer:!accessing!public! !
hFooterIcon!**compiled accessors**!public! !
hFooterIcon:!**compiled accessors**!public! !
hInstance!**compiled accessors**!public! !
hInstance:!**compiled accessors**!public! !
hMainIcon!**compiled accessors**!public! !
hMainIcon:!**compiled accessors**!public! !
hwndParent!**compiled accessors**!public! !
hwndParent:!**compiled accessors**!public! !
mainInstruction:!accessing!public! !
nDefaultButton!**compiled accessors**!public! !
nDefaultButton:!**compiled accessors**!public! !
nDefaultRadioButton!**compiled accessors**!public! !
nDefaultRadioButton:!**compiled accessors**!public! !
pButtons!**compiled accessors**!public! !
pButtons:!**compiled accessors**!public! !
pfCallback:!**compiled accessors**!public! !
pRadioButtons!**compiled accessors**!public! !
pRadioButtons:!**compiled accessors**!public! !
pszCollapsedControlText!**compiled accessors**!public! !
pszCollapsedControlText:!**compiled accessors**!public! !
pszContent!**compiled accessors**!public! !
pszContent:!**compiled accessors**!public! !
pszExpandedControlText!**compiled accessors**!public! !
pszExpandedControlText:!**compiled accessors**!public! !
pszExpandedInformation!**compiled accessors**!public! !
pszExpandedInformation:!**compiled accessors**!public! !
pszFooter!**compiled accessors**!public! !
pszFooter:!**compiled accessors**!public! !
pszMainInstruction!**compiled accessors**!public! !
pszMainInstruction:!**compiled accessors**!public! !
pszVerificationText!**compiled accessors**!public! !
pszVerificationText:!**compiled accessors**!public! !
pszWindowTitle!**compiled accessors**!public! !
pszWindowTitle:!**compiled accessors**!public! !
radioButtons:!accessing!public! !
verificationText:!accessing!public! !
windowTitle:!accessing!public! !
!

!OS.TASKDIALOGCONFIG class methodsFor!

byteSize
	^_TASKDIALOGCONFIG_Size!

defineFields
	"Define the fields of the TASKDIALOGCONFIG structure.

	TASKDIALOGCONFIG compileDefinition

		typedef [uuid(948de028-015b-4a2a-818e-db8b5f40aa75)]
		struct tagTASKDIALOGCONFIG {
			[restricted, helpstring('The structure size, in bytes.')] unsigned int dwSize;
			[helpstring('The owner window for the dialog (not a parent).')] wireHWND hwndParent;
			[helpstring('Handle of module containing string and icon resources')] HINSTANCE HINSTANCE;
			[helpstring('Flags specifying the behaviour of the task dialog')] TASKDIALOG_FLAGS dwFlags;
			[helpstring('Flags specifying the buttons to be displayed in the class dialog')] TASKDIALOG_COMMON_BUTTON_FLAGS dwCommonButtons;
			[helpstring('The caption for the dialog (either a string, or integer resource id)'), string] LPCWSTR pszWindowTitle;
			union {
				[helpstring('Handle of the Icon to be displayed as the main icon in the dialog.')] HICON hMainIcon;
				[hidden, helpstring('Identifier of icon resource to be displaed as the main icon in the dialog')] LPCWSTR pszMainIcon;
			};
			[helpstring('Main instruction text to be displayed in the dialog (string or integer resource id'), string] LPCWSTR pszMainInstruction;
			[helpstring('Context text to be displayed in the dialog (string or integer resource id'), string] LPCWSTR pszContent;
			[helpstring('The number of entries in the pButtons array')] unsigned int cButtons;
			[helpstring('Array of button descriptions'), size_is('cButtons')] TASKDIALOG_BUTTON* pButtons;
			[helpstring('Identifies the default button: Either the id of a common button, or the nButtonId of one of the buttons in the pButtons array')] int nDefaultButton;
			[helpstring('The number of entries in the pRadioButtons array')] unsigned int cRadioButtons;
			[helpstring('Array of radio button descriptions'), size_is('cRadioButtons')] TASKDIALOG_BUTTON* pRadioButtons;
			[helpstring('Identifies the default button from pRadioButtons by its nButtonId')] int nDefaultRadioButton;
			[helpstring('Label for the verification checkbox (string or integer resource id'), string] LPCWSTR pszVerificationText;
			[helpstring('Expandable information text (string or integer resource id'), string] LPCWSTR pszExpandedInformation;
			[helpstring('Label to be displayed on the expandable information button when expanded (string or integer resource id'), string] LPCWSTR pszExpandedControlText;
			[helpstring('Label to be displayed on the expandable information button when collapsed (string or integer resource id'), string] LPCWSTR pszCollapsedControlText;
			union {
				[helpstring('Handle of the Icon to be displayed as the footer icon in the dialog.')] HICON hFooterIcon;
				[hidden, helpstring('Identifier of icon resource to be displaed as the footer icon in the dialog')] LPCWSTR pszFooterIcon;
			};
			[helpstring('Footer text (string or integer resource id). Can contain hyperlinks '), string] LPCWSTR pszFooter;
			[restricted, helpstring('Pointer to an application-defined callback function.')] LPVOID pfCallback;
			[hidden, helpstring('Data to be passed to callback function.')] LONG_PTR lpCallbackData;
			[helpstring('width of the Task Dialog's client area in DLU's. If 0, Task Dialog will calculate the ideal width.')] unsigned int cxWidth;
		} TASKDIALOGCONFIG;
"

	self
		defineField: #dwSize
			type: UInt32Field new beWriteOnly
			offset: 0;
		defineField: #hwndParent
			type: HANDLEField new
			offset: 4;
		defineField: #hInstance
			type: HANDLEField new
			offset: 8;
		defineField: #dwFlags
			type: Int32Field new
			offset: 12;
		defineField: #dwCommonButtons
			type: Int32Field new
			offset: 16;
		defineField: #pszWindowTitle
			type: (PointerField type: Utf16String)
			offset: 20;
		defineField: #hMainIcon
			type: HANDLEField new
			offset: 24;
		defineField: #pszMainIcon
			type: (PointerField type: Utf16String) beFiller
			offset: 24;
		defineField: #pszMainInstruction
			type: (PointerField type: Utf16String)
			offset: 28;
		defineField: #pszContent
			type: (PointerField type: Utf16String)
			offset: 32;
		defineField: #cButtons
			type: UInt32Field new
			offset: 36;
		defineField: #pButtons
			type: (StructureArrayPointerField type: TASKDIALOG_BUTTON lengthField: #cButtons)
			offset: 40;
		defineField: #nDefaultButton
			type: Int32Field new
			offset: 44;
		defineField: #cRadioButtons
			type: UInt32Field new
			offset: 48;
		defineField: #pRadioButtons
			type: (StructureArrayPointerField type: TASKDIALOG_BUTTON lengthField: #cRadioButtons)
			offset: 52;
		defineField: #nDefaultRadioButton
			type: Int32Field new
			offset: 56;
		defineField: #pszVerificationText
			type: (PointerField type: Utf16String)
			offset: 60;
		defineField: #pszExpandedInformation
			type: (PointerField type: Utf16String)
			offset: 64;
		defineField: #pszExpandedControlText
			type: (PointerField type: Utf16String)
			offset: 68;
		defineField: #pszCollapsedControlText
			type: (PointerField type: Utf16String)
			offset: 72;
		defineField: #hFooterIcon
			type: HANDLEField new
			offset: 76;
		defineField: #pszFooterIcon
			type: (PointerField type: Utf16String) beFiller
			offset: 76;
		defineField: #pszFooter
			type: (PointerField type: Utf16String)
			offset: 80;
		defineField: #pfCallback
			type: LPVOIDField new beWriteOnly
			offset: 84;
		defineField: #lpCallbackData
			type: IntPtrField new beFiller
			offset: 88;
		defineField: #cxWidth
			type: UInt32Field new
			offset: 92.
	self byteSize: 96!

getFieldNames
	^#(#dwSize #hwndParent #hInstance #dwFlags #dwCommonButtons #pszWindowTitle #hMainIcon #pszMainInstruction #pszContent #cButtons #pButtons #nDefaultButton #cRadioButtons #pRadioButtons #nDefaultRadioButton #pszVerificationText #pszExpandedInformation #pszExpandedControlText #pszCollapsedControlText #hFooterIcon #pszFooter #pfCallback #cxWidth)! !
!OS.TASKDIALOGCONFIG class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

