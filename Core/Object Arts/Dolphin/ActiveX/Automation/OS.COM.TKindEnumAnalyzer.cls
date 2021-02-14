"Filed out from Dolphin Smalltalk 7"!

OS.COM.TypeInfoAnalyzer subclass: #'OS.COM.TKindEnumAnalyzer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TKindEnumAnalyzer guid: (Core.GUID fromString: '{c06f3b68-0868-11d3-93af-00a024ca708a}')!
OS.COM.TKindEnumAnalyzer comment: 'TKindEnumAnalyzer is a class which wraps an OLE Automation <ITypeInfo> interface pointer that describes an enumerated type  (i.e. of type TKIND_ENUM). It adds higher level behaviours for analyzing the type information associated with that coclass, and for automatic generation.

TKindEnumAnalyzer generates constants for each of the members of its enumerated type into a <PoolConstantsDictionary> when sent #generate/#generateAs:. Using this facility one can very quickly and easily define a set of constants needed to use some externally defined object or function library, at least when a typelib is available.

The Active-X Component Wizard will automatically generate a constants pool for any type library that contains enumerated types when any structure or interface is generated from that type library.'!
!OS.COM.TKindEnumAnalyzer categoriesForClass!ActiveX Automation! !
!OS.COM.TKindEnumAnalyzer methodsFor!

baseClass
	"Private - Answer the Dolphin class used to represent superclass of the receiver.
	Implmementation Note. The receiver is not represented by a class of its own."

	^self shouldNotImplement!

constants
	"Answer <sequencedReadableCollection> of VARDESCs describing the 
	member variables of the receiver's structure (assumes it is a structure -
	if it isn't the collection will be empty)."

	^self variables!

name
	"Answer a <readableString> name for the receiver, retrieved from the
	documentation."
	
	^self nameSansTag!

suggestedGlobalName
	"Private - Answer a <readableString> name suggested as the (unprefixed) for a global
	generated to represent the receiver's type.
	Implementation Note: All enums are generated into the same pool, so the global is shared
	and under a name related to the library, not the receiver."

	^self typeLib name, 'Constants'!

vt
	"Answer a variant type code (a member of VARENUM) which describes the type
	of variant which can be used to represent an object of the type described by
	the receiver."

	^VT_I4! !
!OS.COM.TKindEnumAnalyzer categoriesFor: #baseClass!constants!private! !
!OS.COM.TKindEnumAnalyzer categoriesFor: #constants!enumerating!public! !
!OS.COM.TKindEnumAnalyzer categoriesFor: #name!accessing!public! !
!OS.COM.TKindEnumAnalyzer categoriesFor: #suggestedGlobalName!accessing!private! !
!OS.COM.TKindEnumAnalyzer categoriesFor: #vt!constants!public! !

!OS.COM.TKindEnumAnalyzer class methodsFor!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_ENUM! !
!OS.COM.TKindEnumAnalyzer class categoriesFor: #typekind!constants!private! !

