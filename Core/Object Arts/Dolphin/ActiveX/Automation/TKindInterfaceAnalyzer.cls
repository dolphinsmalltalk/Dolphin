"Filed out from Dolphin Smalltalk 7"!

AXInterfaceTypeAnalyzer subclass: #TKindInterfaceAnalyzer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TKindInterfaceAnalyzer guid: (GUID fromString: '{c06f3b67-0868-11d3-93af-00a024ca708a}')!
TKindInterfaceAnalyzer comment: 'TKindInterfaceAnalyzer is a class which wraps an Active-X Automation <ITypeInfo> interface pointer that describes a ''interface'' (a dual or custom COM interface), i.e. an ITypeInfo of type kind TKIND_INTERFACE. It supports high level behaviours for analyzing the type information associated with interfaces, and for automatically generating a <IUnknown> wrapper subclasses.

Note: This analyzer''s capabilities in auto-generating method wrappers are comprehensive, but certain combinations of argument types and IDL flags may foil it. Please report such generation problems via the normal Object Arts support channels. Where it is not desirable to wait for a patch, one can hand craft wrappers for problem methods, perhaps using the auto-generated attempts as a start point. If a previously auto-generated method is moved out of the ''**auto-generated**'' category, then it can be safely modified without fear of it being overwritten.
'!
!TKindInterfaceAnalyzer categoriesForClass!ActiveX Automation! !
!TKindInterfaceAnalyzer methodsFor!

baseClass
	"Private - Answer the Dolphin class used to represent the superclass of the interface
	described by the receiver."

	| base |
	base := self superInterface.
	^base isNil
		ifTrue: [COMInterface]
		ifFalse: [ | name |
			(name := base name) = 'IUnknown' ifTrue: [IUnknown]
				ifFalse: [name = 'IDispatch' ifTrue: [IDispatch]
				ifFalse: [base global]]]!

vt
	"Answer a variant type code (a member of VARENUM) which describes the type
	of variant which can be used to represent an object of the type described by
	the receiver."

	^VT_UNKNOWN! !
!TKindInterfaceAnalyzer categoriesFor: #baseClass!constants!private! !
!TKindInterfaceAnalyzer categoriesFor: #vt!constants!public! !

!TKindInterfaceAnalyzer class methodsFor!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_INTERFACE! !
!TKindInterfaceAnalyzer class categoriesFor: #typekind!constants!private! !

