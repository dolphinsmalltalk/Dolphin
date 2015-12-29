"Filed out from Dolphin Smalltalk X6.1"!

AXTypeInfoAnalyzer subclass: #TKindAliasAnalyzer
	instanceVariableNames: ''
	classVariableNames: 'BaseTypes'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TKindAliasAnalyzer guid: (GUID fromString: '{C06F3B79-0868-11D3-93AF-00A024CA708A}')!
TKindAliasAnalyzer comment: 'TKindAliasAnalyzer is a class which wraps an OLE Automation <ITypeInfo> interface pointer that describes a ''typedef'' (a declaration of a name for a type), i.e. an ITypeInfo of type kind TKIND_ALIAS. It supports high level behaviours for analyzing the type information associated with typedefs, and resolving them down to the fundamental type referenced.'!
!TKindAliasAnalyzer categoriesForClass!ActiveX Automation! !
!TKindAliasAnalyzer methodsFor!

baseClass
	"Private - Answer the Dolphin class used to represent superclass of the receiver.
	Implmementation Note. The receiver is not represented by a class of its own."

	^self shouldNotImplement!

classDesc
	"Private - Answer an <Association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^(BaseTypes at: self name ifAbsent: []) 
		ifNil: [self tdesc classDesc]
		ifNotNil: [:class | class -> 0]!

isUnion
	"Answer whether the receiver describes a union."

	^self tdesc isUnion!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^self tdesc vartype! !
!TKindAliasAnalyzer categoriesFor: #baseClass!constants!private! !
!TKindAliasAnalyzer categoriesFor: #classDesc!accessing!constants!private! !
!TKindAliasAnalyzer categoriesFor: #isUnion!public!testing! !
!TKindAliasAnalyzer categoriesFor: #vt!accessing!constants!public! !

!TKindAliasAnalyzer class methodsFor!

initialize
	"
	self initialize
	"

	BaseTypes := (LookupTable new)
				at: 'UINT_PTR' put: UINT_PTR;
				at: 'ULONG_PTR' put: UINT_PTR;
				at: 'INT_PTR' put: INT_PTR;
				at: 'LONG_PTR' put: INT_PTR;
				yourself.
	self wireHandleNames do: [:each | BaseTypes at: 'wire' , each put: ExternalHandle].
	BaseTypes
		shrink;
		isImmutable: true;
		yourself!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_ALIAS!

wireHandleNames
	^#('HACCEL' 'HWND' 'HINSTANCE' 'HDC' 'HFILE' 'HGDIOBJ' 'HICON' 'HCURSOR' 'HFONT' 'HDWP' 'HKEY' 'HPEN' 'HRGN' 'HMODULE' 'HTASK' 'HRSRC' 'HBITMAP' 'HGLOBAL' 'HPALETTE' 'HMETAFILE' 'HENHMETAFILE' 'HBRUSH' 'HMENU' 'HIMAGELIST')! !
!TKindAliasAnalyzer class categoriesFor: #initialize!public! !
!TKindAliasAnalyzer class categoriesFor: #typekind!constants!private! !
!TKindAliasAnalyzer class categoriesFor: #wireHandleNames!constants!private! !

