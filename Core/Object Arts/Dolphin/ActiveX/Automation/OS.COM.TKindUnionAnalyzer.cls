"Filed out from Dolphin Smalltalk 7"!

OS.COM.StructureTypeAnalyzer subclass: #'OS.COM.TKindUnionAnalyzer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TKindUnionAnalyzer guid: (Core.GUID fromString: '{c06f3b81-0868-11d3-93af-00a024ca708a}')!
OS.COM.TKindUnionAnalyzer comment: ''!
!OS.COM.TKindUnionAnalyzer categoriesForClass!ActiveX Automation! !
!OS.COM.TKindUnionAnalyzer methodsFor!

isUnion
	"Answer whether the receiver describes a union."

	^true! !
!OS.COM.TKindUnionAnalyzer categoriesFor: #isUnion!public!testing! !

!OS.COM.TKindUnionAnalyzer class methodsFor!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_UNION! !
!OS.COM.TKindUnionAnalyzer class categoriesFor: #typekind!constants!private! !

