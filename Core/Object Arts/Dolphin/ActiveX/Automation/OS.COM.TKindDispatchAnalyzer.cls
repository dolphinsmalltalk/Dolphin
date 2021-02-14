"Filed out from Dolphin Smalltalk 7"!

OS.COM.InterfaceTypeAnalyzer subclass: #'OS.COM.TKindDispatchAnalyzer'
	instanceVariableNames: ''
	classVariableNames: 'SpecialPropGets'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TKindDispatchAnalyzer guid: (Core.GUID fromString: '{c06f3b72-0868-11d3-93af-00a024ca708a}')!
OS.COM.TKindDispatchAnalyzer comment: 'TKindDispatchAnalyzer is a class which wraps an Active-X Automation <ITypeInfo> interface pointer that describes a ''dispinterface'' (a late-bound Automation interface), i.e. an ITypeInfo of type kind TKIND_DISPATCH. It supports high level behaviours for analyzing the type information associated with dispinterfaces, and for automatically generating a <IDispatch> wrapper subclasses.

Note: Certain dispinterfaces may use combinations of argument types and IDL flags which are not supported by the analyzer''s automatic wrapper method generation capabilities. Where possible generate dual interface wrappers as not only is automated support for these more advanced, but they also offer much better performance. Where not possible it may be necessary to hand craft wrappers for certain methods, perhaps using the auto-generated attempts as a start point. If a previously auto-generated method is moved out of the ''**auto-generated**'' category, then it can be safely modified without fear of it being overwritten.

Class Variables:
	SpecialPropGets		<LookupTable>. Map of special propget ids to associated method text (e.g. DISPID_VALUE)
	SpecialPropPuts		<LookupTable>. Ditto for propputs


'!
!OS.COM.TKindDispatchAnalyzer categoriesForClass!ActiveX Automation! !
!OS.COM.TKindDispatchAnalyzer methodsFor!

asImplType
	"Answer the actual implementing type for the receiver (some 
	dispinterfaces are actually implemented by dual interfaces)."

	^self isDual ifTrue: [self dualInterface] ifFalse: [self]!

baseClass
	"Private - Answer the Dolphin class used to represent the user-defined type, 
	userType."

	| base |
	base := self superInterface.
	^base name = #IDispatch ifTrue: [IDispatch] ifFalse: [base global]!

dualInterface
	"Answer the ITypeInfo for the dual interface (TKIND_INTERFACE) associated with a TKIND_DISPATCH.
	Raise an HRESULTError if the receiver is not describing a dispinterface only.
	Type info for dual interfaces is not directly enumerated so we need to do some hoop jumping..."

	| pi |
	pi := self tlbInterface getImplTypeInfoAt: 0.
	self assert: [pi typekind == TKIND_INTERFACE].
	^self class onTypeInfo: pi!

isAutomationCompatible
	"Answer whether the receiver is describing an interface which is OLE Automation compatible.
	By definition dispinterfaces are automation compatible."

	^true
!

properties
	"Answer <sequencedReadableCollection> of VARDESCs describing the 
	dispatchable properties associated with the receiver.  Note that this list
	is not comprehensive, since it doesn't include those properties accessible
	via propget/propput methods."

	^self variables!

superInterface
	"Answer the a <TKindInterfaceAnalyzer> describing the <COMInterface>
	from which the receiver is derived, or nil if the receiver describes IUnknown."

	^self isDual
		ifTrue: [self dualInterface superInterface]
		ifFalse: [super superInterface]!

vt
	"Answer a variant type code (a member of VARENUM) which describes the type
	of variant which can be used to represent an object of the type described by
	the receiver."

	^VT_DISPATCH! !
!OS.COM.TKindDispatchAnalyzer categoriesFor: #asImplType!accessing!public! !
!OS.COM.TKindDispatchAnalyzer categoriesFor: #baseClass!constants!private! !
!OS.COM.TKindDispatchAnalyzer categoriesFor: #dualInterface!accessing!public! !
!OS.COM.TKindDispatchAnalyzer categoriesFor: #isAutomationCompatible!public!testing! !
!OS.COM.TKindDispatchAnalyzer categoriesFor: #properties!enumerating!public! !
!OS.COM.TKindDispatchAnalyzer categoriesFor: #superInterface!enumerating!public! !
!OS.COM.TKindDispatchAnalyzer categoriesFor: #vt!constants!public! !

!OS.COM.TKindDispatchAnalyzer class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		TKindDispatchAnalyzer initialize
	"

	SpecialPropGets := IdentityDictionary new.
	SpecialPropGets 
		at: DISPID_NEWENUM put: nil.	"Base implementation is sufficient, don't need override"!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_DISPATCH! !
!OS.COM.TKindDispatchAnalyzer class categoriesFor: #initialize!development!initializing!private! !
!OS.COM.TKindDispatchAnalyzer class categoriesFor: #typekind!constants!private! !

