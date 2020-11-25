"Filed out from Dolphin Smalltalk 7"!

COMInterfaceImp subclass: #AXDispatchImpAbstract
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants AXAutomationErrors Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
AXDispatchImpAbstract guid: (GUID fromString: '{10dee4fb-246c-4582-9a3b-2ca93e0636c2}')!
AXDispatchImpAbstract comment: ''!
!AXDispatchImpAbstract categoriesForClass!Unclassified! !
!AXDispatchImpAbstract methodsFor!

decodeArgs: aDISPPARAMS
	| args argc rgvarg i |
	argc := aDISPPARAMS cArgs.
	argc == 0 ifTrue: [^#()].
	"Optimize single argument"
	argc == 1 ifTrue: [^{aDISPPARAMS singleArg value}].
	rgvarg := aDISPPARAMS rgvarg.
	args := Array new: argc.
	i := argc.
	rgvarg do: 
			[:varg |
			args at: i put: varg value.
			i := i - 1].
	^args!

errorDispatching: dispid exception: anError excepInfo: pExcepInfo
	"Private - An error occcurred dispatching from Invoke(), handle it by updating the
	<EXCEPINFO>, pExcepInfo, and returning the appropriate HRESULT code.
	This is also the point we can produce a walkback in a development session
	(see #notifyDispatchError:invoking:)."

	| hr |
	self notifyDispatchError: anError invoking: dispid.
	hr := anError hresult.
	pExcepInfo notNull ifTrue: [
		pExcepInfo scode: hr asInteger.
		pExcepInfo bstrDescription: (BSTR fromString: anError description) detach].
	^hr!

GetIDsOfNames: getIDsOfNames rgszNames: rgszNames cNames: cNames lcid: lcid rgdispid: rgdispid 
	"Implement the IDispatch::GetIDsOfNames() interface function.

		HRESULT __stdcall GetIDsOfNames(
			[in] GUID* riid,
			[in] char** rgszNames,
			[in] unsigned int cNames,
			[in] unsigned long lcid,
			[out] long* rgdispid);
	"

	| names ids pdispids |
	names := (StructureArray 
				fromAddress: rgszNames yourAddress
				length: cNames
				elementClass: LPWSTR) collect: [:e | e asString].
	ids := self idsOfNames: names whenNotKnown: [:name | ^DISP_E_UNKNOWNNAME].
	pdispids := SDWORDArray fromAddress: rgdispid yourAddress.
	ids keysAndValuesDo: [:i :id | pdispids at: i put: id].
	^S_OK!

GetTypeInfo: itinfo lcid: lcid pptinfo: pptinfo 
	"Implement the IDispatch::GetTypeInfo() interface function.
	We don't need to provide any type information since this is an
	event sink, and the caller knows all about the interface.

	Implementation Note: At present we ignore the locale, which is permitted: 
	'For classes that do not support localized member names, this 
	parameter can be ignored'. (from Win32 help)"

	| piTi |
	pptinfo value: 0.
	itinfo == 0 ifFalse: [^DISP_E_BADINDEX].
	piTi := (self typeInfo: lcid ifNone: [^TYPE_E_ELEMENTNOTFOUND]) asParameter.
	pptinfo value: piTi bytes.
	piTi AddRef.
	^S_OK!

GetTypeInfoCount: count
	"Implement the IDispatch::GetTypeInfoCount() interface function.

		HRESULT __stdcall GetTypeInfoCount(
			[out] unsigned int* pctinfo);"

	count value: self typeInfoCount.
	^S_OK	!

idsOfNames: anArray whenNotKnown: aMonadicValuable 
	"Answer a <sequencedReadableCollection> of <SmallInteger> being the dispatch ids of each of
	the <readableString> names in the argument <Array>, anArray. Evaluate the <monadicValuable>
	argument for each of the names which are not recognised."

	^anArray do: aMonadicValuable!

Invoke: dispid riid: riid lcid: lcid wFlags: wFlags pdispparams: pDispParams pvarResult: pVarResult pexcepinfo: pExcepInfo puArgErr: puArgErr 
	"Implement the raw IDispatch::Invoke() interface function.
	Implementation Note: We don't explicitly support multiple languages, so we ignore the locale id."

	^
	[| answer args |
	args := self decodeArgs: pDispParams.
	answer := self 
				invokeId: dispid
				flags: wFlags
				withArguments: args.
	pVarResult isNull ifFalse: [pVarResult value: answer].
	args do: [:each | each free].
	S_OK] 
			on: Error
			do: 
				[:ex | 
				self 
					errorDispatching: dispid
					exception: ex
					excepInfo: pExcepInfo]!

invokeId: dispid flags: callTypeFlags withArguments: argArray
	"Invoke the receiver's method with <integer> dispatch id, dispid, and the <Array> of
	<variantCompatible> arguments, argArray."

	^E_NOTIMPL!

notifyDispatchError: anError invoking: dispidInteger
	"Private - An error occcurred dispatching from Invoke(), notify the session.
	Can be overridden by subclasses that wish to suppress errors completely so
	that they are only reported back to the caller, however it is useful for debugging
	purposes to be able to hook in a walkback here."

	Notification signal: ('Error dispatching id(%1!!#010x!!):  %3, from %4' 
					formatWith: dispidInteger 
						with: anError hresult 
						with: anError printString 
						with: self printString).
!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^{IDispatch}!

typeInfo: lcid ifNone: exceptionHandler
	"Private - Answer an <ITypeInfo> on the type information for this dispinterface,
	or if none is available the result of evaluating the <niladicValuable>, exceptionHandler."

	^exceptionHandler value!

typeInfoCount
	"Answer 1 if type information is available, else 0."

	^0! !
!AXDispatchImpAbstract categoriesFor: #decodeArgs:!helpers!private! !
!AXDispatchImpAbstract categoriesFor: #errorDispatching:exception:excepInfo:!operations!private! !
!AXDispatchImpAbstract categoriesFor: #GetIDsOfNames:rgszNames:cNames:lcid:rgdispid:!COM Interfaces-IDispatch!public! !
!AXDispatchImpAbstract categoriesFor: #GetTypeInfo:lcid:pptinfo:!COM Interfaces-IDispatch!public! !
!AXDispatchImpAbstract categoriesFor: #GetTypeInfoCount:!COM Interfaces-IDispatch!public! !
!AXDispatchImpAbstract categoriesFor: #idsOfNames:whenNotKnown:!accessing!public! !
!AXDispatchImpAbstract categoriesFor: #Invoke:riid:lcid:wFlags:pdispparams:pvarResult:pexcepinfo:puArgErr:!COM Interfaces-IDispatch!public! !
!AXDispatchImpAbstract categoriesFor: #invokeId:flags:withArguments:!operations!public! !
!AXDispatchImpAbstract categoriesFor: #notifyDispatchError:invoking:!operations!private! !
!AXDispatchImpAbstract categoriesFor: #supportedInterfaces!constants!public! !
!AXDispatchImpAbstract categoriesFor: #typeInfo:ifNone:!accessing!private! !
!AXDispatchImpAbstract categoriesFor: #typeInfoCount!accessing!public! !

AXDispatchImpAbstract methodProtocol: #IDispatch attributes: #(#readOnly) selectors: #(#GetIDsOfNames:rgszNames:cNames:lcid:rgdispid: #GetTypeInfo:lcid:pptinfo: #GetTypeInfoCount: #Invoke:riid:lcid:wFlags:pdispparams:pvarResult:pexcepinfo:puArgErr:)!

