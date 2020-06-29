"Filed out from Dolphin Smalltalk 7"!

AXStructureTypeAnalyzer subclass: #TKindRecordAnalyzer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TKindRecordAnalyzer guid: (GUID fromString: '{c06f3b7e-0868-11d3-93af-00a024ca708a}')!
TKindRecordAnalyzer comment: 'TKindRecordAnalyzer is a class which wraps an Active-X Automation <ITypeInfo> interface pointer that describes a ''struct'' (a C structure). It adds high level behaviours for analyzing the type information associated with structures, and for automatic generation of <ExternalStructure> wrapper classes.

At present TKindRecordAnalyzer is not capable to automatically generating a full #defineFields class method. Support for such will be added in a future release. In the meantime a stub #defineFields is emitted that contains an IDL description of the structure in its comment, and the body of which sets the correct byte size for the structure. '!
!TKindRecordAnalyzer categoriesForClass!ActiveX Automation! !
!TKindRecordAnalyzer class methodsFor!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_RECORD! !
!TKindRecordAnalyzer class categoriesFor: #typekind!constants!private! !

