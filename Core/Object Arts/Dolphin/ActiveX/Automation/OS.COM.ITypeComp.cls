"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown subclass: #'OS.COM.ITypeComp'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.ITypeComp guid: (OS.COM.IID fromString: '{00020403-0000-0000-c000-000000000046}')!
OS.COM.ITypeComp comment: ''!
!OS.COM.ITypeComp categoriesForClass!COM-Interfaces! !
!OS.COM.ITypeComp methodsFor!

Bind: bind lHashVal: lHashVal wFlags: wFlags ppTInfo: ppTInfo pDescKind: pDescKind pBindPtr: pBindPtr
	"Callout for the ITypeComp::Bind() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ITypeComp>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 lpwstr uint32 uint16 lppvoid int32* lppvoid>
	^self invalidCall: _failureCode!

BindType: bindType lHashVal: lHashVal ppTInfo: ppTInfo ppTComp: ppTComp
	"Callout for the ITypeComp::BindType() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ITypeComp>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 5 lpwstr uint32 lppvoid lppvoid>
	^self invalidCall: _failureCode! !
!OS.COM.ITypeComp categoriesForMethods!
Bind:lHashVal:wFlags:ppTInfo:pDescKind:pBindPtr:!COM Interfaces-ITypeComp!primitives!public! !
BindType:lHashVal:ppTInfo:ppTComp:!COM Interfaces-ITypeComp!primitives!public! !
!

!OS.COM.ITypeComp class methodsFor!

defineFunctions
	"Declare the virtual functions supported by the receiver.
		ITypeComp compileFunctions

		enum DESCKIND
	    {
			DESCKIND_NONE	= 0,
			DESCKIND_FUNCDESC	= DESCKIND_NONE + 1,
			DESCKIND_VARDESC	= DESCKIND_FUNCDESC + 1,
			DESCKIND_TYPECOMP	= DESCKIND_VARDESC + 1,
			DESCKIND_IMPLICITAPPOBJ	= DESCKIND_TYPECOMP + 1,
			DESCKIND_MAX	= DESCKIND_IMPLICITAPPOBJ + 1
		};

		union BINDPTR
		{
			FUNCDESC __RPC_FAR *lpfuncdesc;
			VARDESC __RPC_FAR *lpvardesc;
			ITypeComp __RPC_FAR *lptcomp;
		};
	"

	self
		defineFunction: #Bind:lHashVal:wFlags:ppTInfo:pDescKind:pBindPtr:
			 argumentTypes: 'lpwstr dword word ITypeInfo** Int32* lppvoid'; "'DESCKIND* BINDPTR*';"
		defineFunction: #BindType:lHashVal:ppTInfo:ppTComp:        
			 argumentTypes: 'lpwstr dword ITypeInfo** ITypeComp**'! !
!OS.COM.ITypeComp class categoriesForMethods!
defineFunctions!initializing!public! !
!

