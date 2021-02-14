"Filed out from Dolphin Smalltalk 7"!

OS.COM.TypeInfoAnalyzer subclass: #'OS.COM.TKindCoclassAnalyzer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TKindCoclassAnalyzer guid: (Core.GUID fromString: '{c06f3b70-0868-11d3-93af-00a024ca708a}')!
OS.COM.TKindCoclassAnalyzer comment: 'TKindCoClassAnalyzer is a class which wraps an OLE Automation <ITypeInfo> interface pointer that describes a ''coclass'' (a COM object class). It adds higher level behaviours for analyzing the type information associated with that coclass, and for automatic generation of Smalltalk wrapper information for that coclass (essentially by adding behaviours to the wrappers generated for its interfaces).'!
!OS.COM.TKindCoclassAnalyzer categoriesForClass!ActiveX Automation! !
!OS.COM.TKindCoclassAnalyzer methodsFor!

baseClass
	"Private - Answer the Dolphin class used to represent superclass of the receiver.
	Implmementation Note. The receiver is not represented by a class of its own."

	^self shouldNotImplement!

classDesc
	"Private - Answer an <Association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^self defaultInterface classDesc!

clsid
	"Answer the CLSID of the receiver's coclass."

	^self guid!

defaultInterface
	"Answer a <TKindDispatchAnalyzer>/<TKindInterfaceAnalyzer> on the
	receiver's default interface."

	| defaultFlags piTI |
	defaultFlags := IMPLTYPEFLAG_FDEFAULT.
	piTI := self tlbInterface.
	1 to: self attributes cImplTypes
		do: 
			[:i | 
			((piTI getImplTypeFlags: i - 1) allMask: defaultFlags) 
				ifTrue: [^self getImplTypeInfoAt: i]].
	^nil	"No default source"!

defaultSourceInterface
	"Answer a <TKindDispatchAnalyzer>/<TKindInterfaceAnalyzer> on the
	receiver's default source interface."

	| defaultFlags piTI |
	defaultFlags := IMPLTYPEFLAG_FDEFAULT | IMPLTYPEFLAG_FSOURCE.
	piTI := self tlbInterface.
	1 to: self attributes cImplTypes
		do: 
			[:i | 
			((piTI getImplTypeFlags: i - 1) allMask: defaultFlags) 
				ifTrue: [^self getImplTypeInfoAt: i]].
	^nil	"No default source"!

interfaceFlags
	"Answer a <sequencedReadableCollection> of  the flags associated
	with each of the receiver's interfaces."

	| piTI |
	piTI := self tlbInterface.
	^(0 to: self attributes cImplTypes - 1) collect: [:i | piTI getImplTypeFlags: i]!

interfaces
	"Answer a <sequencedReadableCollection> of all the 
	interfaces in the receiver."

	^(1 to: self attributes cImplTypes) collect: [:i | self getImplTypeInfoAt: i]!

isAggregatable
	"Answer whether the receiver is describing a coclass which
	supports aggregation."

	^self attributes isAggregatable!

isAppObject
	"Answer whether the receiver is describing a coclass which
	is an Application level object."

	^self attributes isAppObject!

isControl
	"Answer whether the receiver is describing a control."

	^self attributes isControl!

isInstantiable
	"Answer whether the receiver is describing a coclass which can be
	instantiated with CoCreateInstance."

	^self attributes isInstantiable!

isLicensed
	"Answer whether the receiver is describing a licensed coclass."

	^self attributes isLicensed!

nonSourceInterfaces
	"Answer a <collection> of <AXInterfaceTypeAnalyzer>s describing 
	the receiver's non-source interfaces (a source interface is an outbound 
	interface used to publish events). This is the set of interfaces we can
	use to get/set properties and invoke methods of the COM object."

	| piTI |
	piTI := self tlbInterface.
	^((1 to: self attributes cImplTypes) 
		select: [:i | (piTI getImplTypeFlags: i - 1) noMask: IMPLTYPEFLAG_FSOURCE]) 
			collect: [:i | self getImplTypeInfoAt: i]!

notInstantiable
	"Answer whether the receiver is describing a coclass which is non-instantiable."

	^self isInstantiable not!

sourceInterfaces
	"Answer a <collection> of <AXInterfaceTypeAnalyzer>s describing 
	the receiver's source interfaces (a source interface is an outbound 
	interface used to publish events).
	Note: Typically source interfaces will be dispinterfaces (as otherwise they
	are not supported by VB), but this is by convention. ADO2, for example,
	has both pure dispinterface and dual source interfaces."

	| piTI |
	piTI := self tlbInterface.
	^((1 to: self attributes cImplTypes) 
		select: [:i | (piTI getImplTypeFlags: i - 1) allMask: IMPLTYPEFLAG_FSOURCE]) 
			collect: [:i | self getImplTypeInfoAt: i]! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #baseClass!constants!private! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #classDesc!accessing!constants!private! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #clsid!accessing!public! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #defaultInterface!enquiries!public! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #defaultSourceInterface!enquiries!public! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #interfaceFlags!enumerating!public! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #interfaces!enumerating!public! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #isAggregatable!public!testing! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #isAppObject!public!testing! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #isControl!public!testing! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #isInstantiable!public!testing! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #isLicensed!public!testing! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #nonSourceInterfaces!enumerating!public! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #notInstantiable!public!testing! !
!OS.COM.TKindCoclassAnalyzer categoriesFor: #sourceInterfaces!enumerating!public! !

!OS.COM.TKindCoclassAnalyzer class methodsFor!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_COCLASS! !
!OS.COM.TKindCoclassAnalyzer class categoriesFor: #typekind!constants!private! !

