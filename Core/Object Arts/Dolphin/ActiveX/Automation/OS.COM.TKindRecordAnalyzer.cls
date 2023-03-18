"Filed out from Dolphin Smalltalk"!

OS.COM.StructureTypeAnalyzer
	subclass: #'OS.COM.TKindRecordAnalyzer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TKindRecordAnalyzer guid: (Core.GUID fromString: '{c06f3b7e-0868-11d3-93af-00a024ca708a}')!
OS.COM.TKindRecordAnalyzer comment: 'TKindRecordAnalyzer is a class which wraps an Active-X Automation <ITypeInfo> interface pointer that describes a ''struct'' (a C structure). It adds high level behaviours for analyzing the type information associated with structures, and for automatic generation of <ExternalStructure> wrapper classes.'!
!OS.COM.TKindRecordAnalyzer categoriesForClass!ActiveX Automation! !
!OS.COM.TKindRecordAnalyzer class methodsFor!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_RECORD! !
!OS.COM.TKindRecordAnalyzer class categoriesForMethods!
typekind!constants!private! !
!

