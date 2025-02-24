﻿"Filed out from Dolphin Smalltalk"!

OS.COM.InterfaceTypeAnalyzer
	subclass: #'OS.COM.TKindInterfaceAnalyzer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.TKindInterfaceAnalyzer guid: (Core.GUID fromString: '{c06f3b67-0868-11d3-93af-00a024ca708a}')!

OS.COM.TKindInterfaceAnalyzer comment: 'TKindInterfaceAnalyzer is a class which wraps an Active-X Automation <ITypeInfo> interface pointer that describes a ''interface'' (a dual or custom COM interface), i.e. an ITypeInfo of type kind TKIND_INTERFACE. It supports high level behaviours for analyzing the type information associated with interfaces, and for automatically generating a <IUnknown> wrapper subclasses.

Note: This analyzer''s capabilities in auto-generating method wrappers are comprehensive, but certain combinations of argument types and IDL flags may foil it. Please report such generation problems via the normal Object Arts support channels. Where it is not desirable to wait for a patch, one can hand craft wrappers for problem methods, perhaps using the auto-generated attempts as a start point. If a previously auto-generated method is moved out of the ''**auto-generated**'' category, then it can be safely modified without fear of it being overwritten.
'!

!OS.COM.TKindInterfaceAnalyzer categoriesForClass!ActiveX Automation! !

!OS.COM.TKindInterfaceAnalyzer methodsFor!

baseClass
	"Private - Answer the Dolphin class used to represent the superclass of the interface
	described by the receiver."

	| base |
	base := self superInterface.
	^base isNil
		ifTrue: [Interface]
		ifFalse: 
			[| name |
			(name := base name) == #IUnknown
				ifTrue: [IUnknown]
				ifFalse: [name == #IDispatch ifTrue: [IDispatch] ifFalse: [base programObject]]]!

vt
	"Answer a variant type code (a member of VARENUM) which describes the type
	of variant which can be used to represent an object of the type described by
	the receiver."

	^VT_UNKNOWN! !

!OS.COM.TKindInterfaceAnalyzer categoriesForMethods!
baseClass!constants!private! !
vt!constants!public! !
!

!OS.COM.TKindInterfaceAnalyzer class methodsFor!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_INTERFACE! !

!OS.COM.TKindInterfaceAnalyzer class categoriesForMethods!
typekind!constants!private! !
!

