"Filed out from Dolphin Smalltalk 7"!

LVITEMW subclass: #LVITEMA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LVITEMA guid: (GUID fromString: '{5612554c-01db-45f7-82bb-c00318c37251}')!
LVITEMA comment: 'LVITEMW is an <ExternalStructure> class which represents the Windows common control structure of the same name.

LVITEMW is a wide string version of LVITEMA.'!
!LVITEMA categoriesForClass!Win32-Structs! !
!LVITEMA methodsFor!

pszText
	"Answer the <String> value of the receiver's 'pszText' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszText))! !
!LVITEMA categoriesFor: #pszText!**compiled accessors**!public! !

!LVITEMA class methodsFor!

defineFields
	"Define the fields of the LVITEMA structure.

	LVITEMA compileDefinition

		typedef [uuid(5612554c-01db-45f7-82bb-c00318c37251)]
		struct tagLVITEMA {
			unsigned int mask;
			int iItem;
			int iSubItem;
			unsigned int State;
			unsigned int stateMask;
			[string] LPSTR pszText;
			int cchTextMax;
			int iImage;
			LONG_PTR lParam;
			int iIndent;
			int iGroupId;
			unsigned int cColumns;
			[size_is('cColumns')] unsigned int* puColumns;
			[size_is('cColumns')] int* piColFmt;
			[readonly] int iGroup;
		} LVITEMA;
"

	super defineFields.
	self
		defineField: #pszText
		type: (PointerField type: String) beOverride
		offset: 20!

textClass
	^String! !
!LVITEMA class categoriesFor: #defineFields!initializing!public! !
!LVITEMA class categoriesFor: #textClass!constants!private! !

