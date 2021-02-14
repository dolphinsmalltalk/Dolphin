"Filed out from Dolphin Smalltalk 7"!

OS.COM.TypeInfoAnalyzer subclass: #'OS.COM.TKindAliasAnalyzer'
	instanceVariableNames: ''
	classVariableNames: 'BaseTypes'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TKindAliasAnalyzer guid: (Core.GUID fromString: '{c06f3b79-0868-11d3-93af-00a024ca708a}')!
OS.COM.TKindAliasAnalyzer comment: 'TKindAliasAnalyzer is a class which wraps an OLE Automation <ITypeInfo> interface pointer that describes a ''typedef'' (a declaration of a name for a type), i.e. an ITypeInfo of type kind TKIND_ALIAS. It supports high level behaviours for analyzing the type information associated with typedefs, and resolving them down to the fundamental type referenced.'!
!OS.COM.TKindAliasAnalyzer categoriesForClass!ActiveX Automation! !
!OS.COM.TKindAliasAnalyzer methodsFor!

baseClass
	"Private - Answer the Dolphin class used to represent superclass of the receiver.
	Implmementation Note. The receiver is not represented by a class of its own."

	^self shouldNotImplement!

classDesc
	"Private - Answer an <Association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^(BaseTypes lookup: self name) ifNil: [self tdesc classDesc] ifNotNil: [:class | class -> 0]!

isAnonymous
	"Answer whether the receiver describes an anonymous (i.e. unnamed) structure or union."

	^(BaseTypes lookup: self name) isNil and: [self tdesc isAnonymous]!

isStructure
	"Answer whether the receiver describes a structure."

	^self tdesc isStructure!

isUnion
	"Answer whether the receiver describes a union."

	^self tdesc isUnion!

realTypeInfo
	^self tdesc realTypeInfo!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^self tdesc vartype! !
!OS.COM.TKindAliasAnalyzer categoriesFor: #baseClass!constants!private! !
!OS.COM.TKindAliasAnalyzer categoriesFor: #classDesc!accessing!constants!private! !
!OS.COM.TKindAliasAnalyzer categoriesFor: #isAnonymous!public!testing! !
!OS.COM.TKindAliasAnalyzer categoriesFor: #isStructure!public!testing! !
!OS.COM.TKindAliasAnalyzer categoriesFor: #isUnion!public!testing! !
!OS.COM.TKindAliasAnalyzer categoriesFor: #realTypeInfo!accessing!public! !
!OS.COM.TKindAliasAnalyzer categoriesFor: #vt!accessing!constants!public! !

!OS.COM.TKindAliasAnalyzer class methodsFor!

basicTypes
	^{UINT_PTR. INT_PTR. LARGE_INTEGER. ULARGE_INTEGER. BOOLEAN. GUID}!

initialize
	"
	self initialize
	"

	BaseTypes := LookupTable new.
	self basicTypes do: [:each | BaseTypes at: each name asString put: each].
	BaseTypes
		at: 'guid' put: GUID;
		at: 'ULONG_PTR' put: UINT_PTR;
		at: 'LONG_PTR' put: INT_PTR.
	self wireHandleNames do: [:each | BaseTypes at: 'wire' , each put: Handle].
	BaseTypes
		shrink;
		isImmutable: true;
		yourself!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_ALIAS!

wireHandleNames
	^#('HACCEL' 'HWND' 'HINSTANCE' 'HDC' 'HFILE' 'HGDIOBJ' 'HICON' 'HCURSOR' 'HFONT' 'HDWP' 'HKEY' 'HPEN' 'HRGN' 'HMODULE' 'HTASK' 'HRSRC' 'HBITMAP' 'HGLOBAL' 'HPALETTE' 'HMETAFILE' 'HENHMETAFILE' 'HBRUSH' 'HMENU' 'HIMAGELIST')! !
!OS.COM.TKindAliasAnalyzer class categoriesFor: #basicTypes!constants!must not strip!public! !
!OS.COM.TKindAliasAnalyzer class categoriesFor: #initialize!class initialization!development!public! !
!OS.COM.TKindAliasAnalyzer class categoriesFor: #typekind!constants!private! !
!OS.COM.TKindAliasAnalyzer class categoriesFor: #wireHandleNames!constants!private! !

