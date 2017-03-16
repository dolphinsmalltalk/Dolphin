"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IXMLDOMImplementation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLDOMImplementation guid: (IID fromString: '{2933BF8F-7B36-11D2-B20E-00C04F983E60}')!
IXMLDOMImplementation comment: '<IXMLDOMImplementation> is a wrapper class for the COM interface ''MSXML.IXMLDOMImplementation'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This interface provides methods that are independent of any particular instance of the DOM. An instance of this interface can only be aquired using the #implementation method of <IXMLDOMDocument>.'!
!IXMLDOMImplementation categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!IXMLDOMImplementation methodsFor!

hasFeature: feature version: version 
	"Answer the <VARIANT_BOOL> result of invoking the COM Object's hasFeature() method.
	In level 1 valid features are 'XML', 'DOM', and 'MS-DOM' (case-sensitive). The only valid
	version at this level is '1.0'. MSXML of course answers true for all these features."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		HasFeature: feature
		version: version
		hasFeature: answer.
	^answer asObject


!

HasFeature: feature version: version hasFeature: hasFeature
	"Private - Invoke the hasFeature() method of the COM object.

		HRESULT __stdcall hasFeature(
			[in]BSTR feature,
			[in]BSTR version,
			[out, retval]VARIANT_BOOL* hasFeature);"

	<virtual stdcall: hresult 8 bstr bstr varbool*>
	^self invalidCall!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!IXMLDOMImplementation categoriesFor: #hasFeature:version:!methods!public! !
!IXMLDOMImplementation categoriesFor: #HasFeature:version:hasFeature:!**auto generated**!COM Interfaces-IXMLDOMImplementation!private! !
!IXMLDOMImplementation categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IXMLDOMImplementation categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!IXMLDOMImplementation class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMImplementation'
		IXMLDOMImplementation defineTemplate"

	self
		defineFunction: #HasFeature:version:hasFeature:
			argumentTypes: 'bstr bstr varbool*'
! !
!IXMLDOMImplementation class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

