"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #INPDolphin
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'NPDolphinConstants'
	classInstanceVariableNames: ''!
INPDolphin guid: (IID fromString: '{40B3E63A-71AE-11D3-97BC-0080C8D59432}')!
INPDolphin comment: '<INPDolphin> is a wrapper class for the COM interface ''NPDolphin.INPDolphin'' generated from type information in the ''Dolphin Internet Browser Plugin 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!INPDolphin categoriesForClass!Plugin-Interfaces! !
!INPDolphin methodsFor!

OnDestroyApplet: piInst
	"Invoke the OnDestroyApplet() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnDestroyApplet(
			[in] INPApplet* piInst);
	"

	<virtual stdcall: hresult 7 INPApplet*>
	^self invalidCall
!

OnInitialize 
	"Invoke the OnInitialize() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnInitialize();
	"

	<virtual stdcall: hresult 4>
	^self invalidCall
!

OnNewApplet: szMIMEType Instance: instance mode: mode argc: argc argn: argn argv: argv cSaved: cSaved pbSaved: pbSaved ppiNewInstance: ppiNewInstance
	"Invoke the OnNewApplet() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnNewApplet(
			[in] LPSTR szMIMEType,
			[in] unsigned long Instance,
			[in] unsigned short mode,
			[in] short argc,
			[in] LPSTR* argn,
			[in] LPSTR* argv,
			[in] long cSaved,
			[in] char* pbSaved,
			[out, retval] INPApplet** ppiNewInstance);
	"

	<virtual stdcall: hresult 6 lpstr dword word sword lpstr* lpstr* sdword byte* INPApplet**>
	^self invalidCall
!

OnShutdown 
	"Invoke the OnShutdown() method of the COM object wrapped by the receiver.

		HRESULT __stdcall OnShutdown();
	"

	<virtual stdcall: hresult 5>
	^self invalidCall
! !
!INPDolphin categoriesFor: #OnDestroyApplet:!**auto generated**!COM Interfaces-INPDolphin!public! !
!INPDolphin categoriesFor: #OnInitialize!**auto generated**!COM Interfaces-INPDolphin!public! !
!INPDolphin categoriesFor: #OnNewApplet:Instance:mode:argc:argn:argv:cSaved:pbSaved:ppiNewInstance:!**auto generated**!COM Interfaces-INPDolphin!public! !
!INPDolphin categoriesFor: #OnShutdown!**auto generated**!COM Interfaces-INPDolphin!public! !

INPDolphin methodProtocol: #'NPDolphin.INPDolphin' attributes: #() selectors: #(#OnInitialize #OnNewApplet:Instance:mode:argc:argn:argv:cSaved:pbSaved:ppiNewInstance: #OnShutdown)!

!INPDolphin class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'NPDolphin.INPDolphin'
		INPDolphin defineTemplate
	"

	self
		defineFunction: #OnInitialize;
		defineFunction: #OnShutdown;
		defineFunction: #OnNewApplet:Instance:mode:argc:argn:argv:cSaved:pbSaved:ppiNewInstance:
			argumentTypes: 'lpstr dword word sword lpstr* lpstr* sdword byte* INPApplet**'
! !
!INPDolphin class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

