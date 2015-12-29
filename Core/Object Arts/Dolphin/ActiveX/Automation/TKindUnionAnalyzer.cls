"Filed out from Dolphin Smalltalk X6"!

AXStructureTypeAnalyzer subclass: #TKindUnionAnalyzer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TKindUnionAnalyzer guid: (GUID fromString: '{C06F3B81-0868-11D3-93AF-00A024CA708A}')!
TKindUnionAnalyzer comment: ''!
!TKindUnionAnalyzer categoriesForClass!ActiveX Automation! !
!TKindUnionAnalyzer methodsFor!

isUnion
	"Answer whether the receiver describes a union."

	^true! !
!TKindUnionAnalyzer categoriesFor: #isUnion!public!testing! !

!TKindUnionAnalyzer class methodsFor!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_UNION! !
!TKindUnionAnalyzer class categoriesFor: #typekind!constants!private! !

