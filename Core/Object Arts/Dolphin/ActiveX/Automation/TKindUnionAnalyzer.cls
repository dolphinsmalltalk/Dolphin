"Filed out from Dolphin Smalltalk 7"!

AXStructureTypeAnalyzer subclass: #TKindUnionAnalyzer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TKindUnionAnalyzer guid: (GUID fromString: '{c06f3b81-0868-11d3-93af-00a024ca708a}')!
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

