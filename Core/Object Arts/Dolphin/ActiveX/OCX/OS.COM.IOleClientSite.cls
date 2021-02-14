"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.IOleClientSite'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IOleClientSite guid: (OS.COM.IID fromString: '{00000118-0000-0000-c000-000000000046}')!
OS.COM.IOleClientSite comment: '<IOleClientSite> is a wrapper class for the COM interface ''OCIDL.IOleClientSite'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

This interface is implemented by Dolphin for call-in only at present (at least until Dolphin supports control creation as well as hosting), so only the function table is needed, hence the absence of any methods.'!
!OS.COM.IOleClientSite categoriesForClass!COM-Interfaces! !
!OS.COM.IOleClientSite class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IOleClientSite'
		IOleClientSite defineTemplate
	"

	self
		defineFunction: #SaveObject;
		defineFunction: #GetMoniker:dwWhichMoniker:ppmk:
"			argumentTypes: 'dword dword IMoniker**';"
			argumentTypes: 'dword dword void**';
		defineFunction: #GetContainer:
"			argumentTypes: 'IOleContainer**';"
			argumentTypes: 'IUnknown**';
		defineFunction: #ShowObject;
		defineFunction: #OnShowWindow:
			argumentTypes: 'bool';
		defineFunction: #RequestNewObjectLayout
! !
!OS.COM.IOleClientSite class categoriesFor: #defineFunctions!initializing!public! !

