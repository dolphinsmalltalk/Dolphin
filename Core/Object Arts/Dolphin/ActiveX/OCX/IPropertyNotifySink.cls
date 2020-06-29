"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IPropertyNotifySink
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IPropertyNotifySink guid: (IID fromString: '{9bfbbc02-eff1-101a-84ed-00aa00341d07}')!
IPropertyNotifySink comment: '<IPropertyNotifySink> is a wrapper class for the COM interface ''ActiveXHost.IPropertyNotifySink'' generated from type information in the ''Dolphin Smalltalk Active-X Host Library'' library. It contains methods to invoke the member functions exposed by that interface.

IPropertyNotifySink is a connection point (event) interface implemented on a container to receiver notifications from a COM object when its properties are either changed, or about to be changed. The particular property in question is identified by <integer> DISPID.

As Dolphin is currently only an OCX container (as opposed to an OCX implementor) this interface is only every used for call-in, and therefore only the function table is needed.

IDL definition follows:

[
	object, 
	uuid(9BFBBC02-EFF1-101A-84ED-00AA00341D07)
]
interface IPropertyNotifySink : IUnknown {
	[id(0x60010000)] 
	HRESULT __stdcall OnChanged(
		[in] long dispID);
	[id(0x60010001)] 
	HRESULT __stdcall OnRequestEdit(
		[in] long dispID);
};
'!
!IPropertyNotifySink categoriesForClass!COM-Interfaces! !
!IPropertyNotifySink class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ActiveXHost.IPropertyNotifySink'
		IPropertyNotifySink defineTemplate"

	self
		defineFunction: #OnChanged:
			argumentTypes: 'sdword';
		defineFunction: #OnRequestEdit:
			argumentTypes: 'sdword'
! !
!IPropertyNotifySink class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

