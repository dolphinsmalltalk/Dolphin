"Filed out from Dolphin Smalltalk 7"!

AXAPIInfoAnalyzer subclass: #AXInterfaceTypeAnalyzer
	instanceVariableNames: 'protocol isSource'
	classVariableNames: 'ReservedDispSelectors ReservedUnkSelectors'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AXInterfaceTypeAnalyzer guid: (GUID fromString: '{c06f3b7d-0868-11d3-93af-00a024ca708a}')!
AXInterfaceTypeAnalyzer isAbstract: true!
AXInterfaceTypeAnalyzer comment: 'AXInterfaceTypeAnalyzer is the abstract superclass of <AXTypeInfoAnalyzer>s describing custom COM interfaces (TKindInterfaceAnalyzer) and dispatch interfaces (TKindDispatchAnalyzer).

AXInterfaceTypeAnalyzers wrap <ITypeInfo> pointers from a type library, providing behaviour which allows one to query information and generate wrapper classes appropriate for COM interfaces.

Instance Variables:
	protocol		<MethodProtocol>. Optional protocol grouping the basic methods of the interface.
	isSource		<boolean>. Flag caching whether the described interface is an event source.

Class Variables:
	ReservedDispSelectors	<IdentitySet> of <Symbol>.Selectors which should not be overridden by dispatch interfaces.
	ReservedUnkSelectors	<IdentitySet> of <Symbol>. Selectors which should not be overridden by custom interfaces.

'!
!AXInterfaceTypeAnalyzer categoriesForClass!ActiveX Automation! !
!AXInterfaceTypeAnalyzer methodsFor!

classDesc
	"Private - Answer an <Association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^self global -> 0!

clsid
	"Answer the CLSID of the receiver's coclass."

	^self guid!

defaultInterface
	"Answer a <TKindDispatchAnalyzer>/<TKindInterfaceAnalyzer> on the
	receiver's default interface."

	^self!

iid
	"Answer the IID (or DIID) of the receiver's interface (or dispinterface)."

	^self guid!

inheritedFunctions
	"Private - Answer a <sequencedReadableCollection> of <FUNCDESC>s describing the 
	inherited methods of the receiver."

	| base |
	base := self superInterface.
	^base isNil ifTrue: [#()] ifFalse: [base functions, base inheritedFunctions]!

isDerived
	"Private - Answer whether the receiver has been derived from another interface."

	^self attributes cImplTypes > 0!

isDual
	"Answer whether the receiver is describing a custom interface
	which derives from IDispatch and which can be early or late
	bound."

	^self tlbInterface isDual!

isExtensible
	"Answer whether the receiver is describing a dynamically extensible interface
	(i.e. one which may add new methods and properties at run-time)."

	^self attributes isExtensible!

isSource
	"Answer whether the receiver is describing a 'source' interface.
	A source interface is an outbound interface through which an object 
	publishes events. It is not implemented by that object, but by its clients.
	This is a very expensive test to calculate, so we cache it for later use.
	Note: Probably due to a limitation of VB, source interfaces are almost 
	always dispinterfaces."

	isSource isNil ifTrue: [
		isSource := self typeLib coclasses anySatisfy: [:c | c sourceInterfaces includes: self]].
	^isSource!

isVBCollection
	"Private - Answer whether the receiver has been derived from another interface."

	^(self idOfName: '_NewEnum' ifAbsent: [0]) = DISPID_NEWENUM!

methods
	"Answer a <sequencedReadableCollection> of <FUNCDESC>s describing the 
	methods of the receiver, excluding any which have been inherited."

	^self functions difference: self inheritedFunctions!

protocol
	"Private - Answer the value of the receiver's 'protocol' instance variable."
	
	protocol isNil ifTrue: [protocol := Object methodProtocolClass name: self fullyQualifiedName].
	^protocol!

suggestedBinding
	"Private - Answer an <Association> for the global binding (or the proposed global binding) 
	for the receiver, on the assumption that it doesn't currently have a binding.
	Implementation Note: Override because there is a global table of interface classes which 
	we can use to look up any existing wrapper class."

	^(COMInterface classForIID: self iid ifNone: []) 
		ifNil: [super suggestedBinding]
		ifNotNil: [:interfaceClass | interfaceClass environment associationAt: interfaceClass name]!

superInterface
	"Answer a <TKindInterfaceAnalyzer> describing the <COMInterface>
	from which the receiver is derived, or nil if the receiver describes IUnknown."

	^self isDerived
		ifTrue: [self getImplTypeInfoAt: 1]! !
!AXInterfaceTypeAnalyzer categoriesFor: #classDesc!accessing!private! !
!AXInterfaceTypeAnalyzer categoriesFor: #clsid!accessing!public! !
!AXInterfaceTypeAnalyzer categoriesFor: #defaultInterface!enquiries!public! !
!AXInterfaceTypeAnalyzer categoriesFor: #iid!accessing!public! !
!AXInterfaceTypeAnalyzer categoriesFor: #inheritedFunctions!enumerating!private! !
!AXInterfaceTypeAnalyzer categoriesFor: #isDerived!private!testing! !
!AXInterfaceTypeAnalyzer categoriesFor: #isDual!public!testing! !
!AXInterfaceTypeAnalyzer categoriesFor: #isExtensible!public!testing! !
!AXInterfaceTypeAnalyzer categoriesFor: #isSource!public!testing! !
!AXInterfaceTypeAnalyzer categoriesFor: #isVBCollection!private!testing! !
!AXInterfaceTypeAnalyzer categoriesFor: #methods!enumerating!public! !
!AXInterfaceTypeAnalyzer categoriesFor: #protocol!accessing!private! !
!AXInterfaceTypeAnalyzer categoriesFor: #suggestedBinding!accessing!private! !
!AXInterfaceTypeAnalyzer categoriesFor: #superInterface!enumerating!public! !

