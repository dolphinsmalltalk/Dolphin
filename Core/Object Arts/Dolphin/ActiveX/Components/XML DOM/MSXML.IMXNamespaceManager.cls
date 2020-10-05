"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IMXNamespaceManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IMXNamespaceManager guid: (IID fromString: '{c90352f6-643c-4fbc-bb23-e996eb2d51fd}')!
IMXNamespaceManager comment: '<IMXNamespaceManager> is a wrapper class for the COM interface ''MSXML2.IMXNamespaceManager'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IMXNamespaceManager interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(C90352F6-643C-4FBC-BB23-E996EB2D51FD), 
	helpstring("IMXNamespaceManager interface"), 
	hidden
]
interface IMXNamespaceManager : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall putAllowOverride(
		[in]VARIANT_BOOL fOverride);
	[id(0x60010001)]
	HRESULT __stdcall getAllowOverride(
		[out, retval]VARIANT_BOOL* fOverride);
	[id(0x60010002)]
	HRESULT __stdcall reset();
	[id(0x60010003)]
	HRESULT __stdcall pushContext();
	[id(0x60010004)]
	HRESULT __stdcall pushNodeContext(
		[in]IXMLDOMNode* contextNode,
		[in]VARIANT_BOOL fDeep);
	[id(0x60010005)]
	HRESULT __stdcall popContext();
	[id(0x60010006)]
	HRESULT __stdcall declarePrefix(
		[in]unsigned short* prefix,
		[in]unsigned short* namespaceURI);
	[id(0x60010007)]
	HRESULT __stdcall getDeclaredPrefix(
		[in]long nIndex,
		[in, out]unsigned short* pwchPrefix,
		[in, out]int* pcchPrefix);
	[id(0x60010008)]
	HRESULT __stdcall getPrefix(
		[in]unsigned short* pwszNamespaceURI,
		[in]long nIndex,
		[in, out]unsigned short* pwchPrefix,
		[in, out]int* pcchPrefix);
	[id(0x60010009)]
	HRESULT __stdcall getURI(
		[in]unsigned short* pwchPrefix,
		[in]IXMLDOMNode* pContextNode,
		[in, out]unsigned short* pwchUri,
		[in, out]int* pcchUri);
};
'!
!IMXNamespaceManager categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IMXNamespaceManager methodsFor!

DeclarePrefix: prefix namespaceURI: namespaceURI
	"Invoke the declarePrefix() method of the COM object.

		HRESULT __stdcall declarePrefix(
			[in]unsigned short* prefix,
			[in]unsigned short* namespaceURI);"

	<virtual stdcall: hresult 10 word* word*>
	^self invalidCall: _failureCode!

getAllowOverride
	"Answer the <VARIANT_BOOL> result of invoking the getAllowOverride() method of the COM object."

	| answer |
	answer := (VARIANT_BOOL new).
	self GetAllowOverride: answer.
	^answer asObject
!

GetAllowOverride: fOverride
	"Private - Invoke the getAllowOverride() method of the COM object.

		HRESULT __stdcall getAllowOverride(
			[out, retval]VARIANT_BOOL* fOverride);"

	<virtual stdcall: hresult 5 varbool*>
	^self invalidCall: _failureCode!

getDeclaredPrefix: nIndex pwchPrefix: pwchPrefix pcchPrefix: pcchPrefix
	"Invoke the getDeclaredPrefix() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD new value: pwchPrefix; yourself);
				basicAt: 2 put: (SDWORD new value: pcchPrefix; yourself);
				yourself.
	self
		GetDeclaredPrefix: nIndex
		pwchPrefix: (answer basicAt: 1)
		pcchPrefix: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetDeclaredPrefix: nIndex pwchPrefix: pwchPrefix pcchPrefix: pcchPrefix
	"Private - Invoke the getDeclaredPrefix() method of the COM object.

		HRESULT __stdcall getDeclaredPrefix(
			[in]long nIndex,
			[in, out]unsigned short* pwchPrefix,
			[in, out]int* pcchPrefix);"

	<virtual stdcall: hresult 11 sdword word* sdword*>
	^self invalidCall: _failureCode!

getPrefix: pwszNamespaceURI nIndex: nIndex pwchPrefix: pwchPrefix pcchPrefix: pcchPrefix
	"Invoke the getPrefix() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD new value: pwchPrefix; yourself);
				basicAt: 2 put: (SDWORD new value: pcchPrefix; yourself);
				yourself.
	self
		GetPrefix: pwszNamespaceURI
		nIndex: nIndex
		pwchPrefix: (answer basicAt: 1)
		pcchPrefix: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetPrefix: pwszNamespaceURI nIndex: nIndex pwchPrefix: pwchPrefix pcchPrefix: pcchPrefix
	"Private - Invoke the getPrefix() method of the COM object.

		HRESULT __stdcall getPrefix(
			[in]unsigned short* pwszNamespaceURI,
			[in]long nIndex,
			[in, out]unsigned short* pwchPrefix,
			[in, out]int* pcchPrefix);"

	<virtual stdcall: hresult 12 word* sdword word* sdword*>
	^self invalidCall: _failureCode!

getURI: pwchPrefix pContextNode: pContextNode pwchUri: pwchUri pcchUri: pcchUri
	"Invoke the getURI() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD new value: pwchUri; yourself);
				basicAt: 2 put: (SDWORD new value: pcchUri; yourself);
				yourself.
	self
		GetURI: pwchPrefix
		pContextNode: pContextNode
		pwchUri: (answer basicAt: 1)
		pcchUri: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetURI: pwchPrefix pContextNode: pContextNode pwchUri: pwchUri pcchUri: pcchUri
	"Private - Invoke the getURI() method of the COM object.

		HRESULT __stdcall getURI(
			[in]unsigned short* pwchPrefix,
			[in]IXMLDOMNode* pContextNode,
			[in, out]unsigned short* pwchUri,
			[in, out]int* pcchUri);"

	<virtual stdcall: hresult 13 word* IXMLDOMNode* word* sdword*>
	^self invalidCall: _failureCode!

PopContext
	"Invoke the popContext() method of the COM object.

		HRESULT __stdcall popContext();"

	<virtual stdcall: hresult 9>
	^self invalidCall: _failureCode!

PushContext
	"Invoke the pushContext() method of the COM object.

		HRESULT __stdcall pushContext();"

	<virtual stdcall: hresult 7>
	^self invalidCall: _failureCode!

PushNodeContext: contextNode fDeep: fDeep
	"Invoke the pushNodeContext() method of the COM object.

		HRESULT __stdcall pushNodeContext(
			[in]IXMLDOMNode* contextNode,
			[in]VARIANT_BOOL fDeep);"

	<virtual stdcall: hresult 8 IXMLDOMNode* varbool>
	^self invalidCall: _failureCode!

PutAllowOverride: fOverride
	"Invoke the putAllowOverride() method of the COM object.

		HRESULT __stdcall putAllowOverride(
			[in]VARIANT_BOOL fOverride);"

	<virtual stdcall: hresult 4 varbool>
	^self invalidCall: _failureCode!

Reset
	"Invoke the reset() method of the COM object.

		HRESULT __stdcall reset();"

	<virtual stdcall: hresult 6>
	^self invalidCall: _failureCode! !
!IMXNamespaceManager categoriesFor: #DeclarePrefix:namespaceURI:!**auto generated**!COM Interfaces-IMXNamespaceManager!public! !
!IMXNamespaceManager categoriesFor: #getAllowOverride!**auto generated**!methods!public! !
!IMXNamespaceManager categoriesFor: #GetAllowOverride:!**auto generated**!COM Interfaces-IMXNamespaceManager!private! !
!IMXNamespaceManager categoriesFor: #getDeclaredPrefix:pwchPrefix:pcchPrefix:!**auto generated**!methods!public! !
!IMXNamespaceManager categoriesFor: #GetDeclaredPrefix:pwchPrefix:pcchPrefix:!**auto generated**!COM Interfaces-IMXNamespaceManager!private! !
!IMXNamespaceManager categoriesFor: #getPrefix:nIndex:pwchPrefix:pcchPrefix:!**auto generated**!methods!public! !
!IMXNamespaceManager categoriesFor: #GetPrefix:nIndex:pwchPrefix:pcchPrefix:!**auto generated**!COM Interfaces-IMXNamespaceManager!private! !
!IMXNamespaceManager categoriesFor: #getURI:pContextNode:pwchUri:pcchUri:!**auto generated**!methods!public! !
!IMXNamespaceManager categoriesFor: #GetURI:pContextNode:pwchUri:pcchUri:!**auto generated**!COM Interfaces-IMXNamespaceManager!private! !
!IMXNamespaceManager categoriesFor: #PopContext!**auto generated**!COM Interfaces-IMXNamespaceManager!public! !
!IMXNamespaceManager categoriesFor: #PushContext!**auto generated**!COM Interfaces-IMXNamespaceManager!public! !
!IMXNamespaceManager categoriesFor: #PushNodeContext:fDeep:!**auto generated**!COM Interfaces-IMXNamespaceManager!public! !
!IMXNamespaceManager categoriesFor: #PutAllowOverride:!**auto generated**!COM Interfaces-IMXNamespaceManager!public! !
!IMXNamespaceManager categoriesFor: #Reset!**auto generated**!COM Interfaces-IMXNamespaceManager!public! !

!IMXNamespaceManager class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IMXNamespaceManager'
		IMXNamespaceManager defineTemplate"

	self
		defineFunction: #PutAllowOverride:
			argumentTypes: 'varbool';
		defineFunction: #GetAllowOverride:
			argumentTypes: 'varbool*';
		defineFunction: #Reset;
		defineFunction: #PushContext;
		defineFunction: #PushNodeContext:fDeep:
			argumentTypes: 'IXMLDOMNode* varbool';
		defineFunction: #PopContext;
		defineFunction: #DeclarePrefix:namespaceURI:
			argumentTypes: 'word* word*';
		defineFunction: #GetDeclaredPrefix:pwchPrefix:pcchPrefix:
			argumentTypes: 'sdword word* sdword*';
		defineFunction: #GetPrefix:nIndex:pwchPrefix:pcchPrefix:
			argumentTypes: 'word* sdword word* sdword*';
		defineFunction: #GetURI:pContextNode:pwchUri:pcchUri:
			argumentTypes: 'word* IXMLDOMNode* word* sdword*'
! !
!IMXNamespaceManager class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

