"Filed out from Dolphin Smalltalk X6.1"!

AXStructureTypeAnalyzer subclass: #TKindRecordAnalyzer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TKindRecordAnalyzer guid: (GUID fromString: '{C06F3B7E-0868-11D3-93AF-00A024CA708A}')!
TKindRecordAnalyzer comment: 'TKindRecordAnalyzer is a class which wraps an Active-X Automation <ITypeInfo> interface pointer that describes a ''struct'' (a C structure). It adds high level behaviours for analyzing the type information associated with structures, and for automatic generation of <ExternalStructure> wrapper classes.

At present TKindRecordAnalyzer is not capable to automatically generating a full #defineFields class method. Support for such will be added in a future release. In the meantime a stub #defineFields is emitted that contains an IDL description of the structure in its comment, and the body of which sets the correct byte size for the structure. '!
!TKindRecordAnalyzer categoriesForClass!ActiveX Automation! !
!TKindRecordAnalyzer class methodsFor!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_RECORD! !
!TKindRecordAnalyzer class categoriesFor: #typekind!constants!private! !

