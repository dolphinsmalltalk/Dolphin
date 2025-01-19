"Filed out from Dolphin Smalltalk"!

OS.COM.InterfaceImplementation
	subclass: #'OS.COM.AbstractDispatchImplementation'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants} #{OS.COM.AutomationConstants} #{OS.COM.AutomationErrors})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.AbstractDispatchImplementation guid: (Core.GUID fromString: '{10dee4fb-246c-4582-9a3b-2ca93e0636c2}')!

OS.COM.AbstractDispatchImplementation isNonInstantiable: true!

OS.COM.AbstractDispatchImplementation comment: 'Common implementation of `IDispatch`.'!

!OS.COM.AbstractDispatchImplementation methodsFor!

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

errorDispatching: dispidInteger exception: anError excepInfo: anEXCEPINFO
	"Private - An error occcurred dispatching from Invoke(), handle it by updating the `EXCEPINFO`, anEXCEPINFO, and returning the appropriate `<integer>` HRESULT code.
	This is also the point we can trap the error in a development session (see `#notifyDispatchError:invoking:`)."

	| hr |
	self notifyDispatchError: anError invoking: dispidInteger.
	hr := anError hresult.
	anEXCEPINFO notNull
		ifTrue: 
			[anEXCEPINFO scode: hr asInteger.
			anEXCEPINFO bstrDescription: (BSTR fromString: anError description) detach].
	^hr!

GetIDsOfNames: getIDsOfNames rgszNames: rgszNames cNames: cNames lcid: lcid rgdispid: rgdispid
	"Implement the IDispatch::GetIDsOfNames() interface function.

		HRESULT __stdcall GetIDsOfNames(
			[in] GUID* riid,
			[in] LPOLESTR* rgszNames,
			[in] unsigned int cNames,
			[in] unsigned long lcid,
			[out] long* rgdispid);
	"

	| names ids pdispids |
	names := PointerArray
				fromAddress: rgszNames yourAddress
				length: cNames
				elementClass: Utf16String.
	ids := self idsOfNames: names whenNotKnown: [:name | ^DISP_E_UNKNOWNNAME].
	pdispids := Int32Array fromAddress: rgdispid yourAddress.
	ids keysAndValuesDo: [:i :id | pdispids at: i put: id].
	^S_OK!

GetTypeInfo: itinfo lcid: lcid pptinfo: pptinfo
	"Implement the IDispatch::GetTypeInfo() interface function."

	| piTi |
	pptinfo value: 0.
	itinfo == 0 ifFalse: [^DISP_E_BADINDEX].
	^(self typeInfo: lcid ifNone: nil)
		ifNil: [TYPE_E_ELEMENTNOTFOUND]
		ifNotNil: 
			[:ti |
			piTi := ti asParameter.
			pptinfo value: piTi bytes.
			piTi AddRef.
			S_OK]!

GetTypeInfoCount: count
	"Implement the IDispatch::GetTypeInfoCount() interface function.

		HRESULT __stdcall GetTypeInfoCount(
			[out] unsigned int* pctinfo);"

	count value: self typeInfoCount.
	^S_OK	!

idsOfNames: anArray whenNotKnown: aMonadicValuable 
	"Answer a `<sequencedReadableCollection>` of `SmallInteger` being the dispatch ids of each of the `<readableString>` names in the argument `Array`, anArray. Evaluate the `<monadicValuable>` argument for each of the names which are not recognised."

	"At this abstract level, we don't know the id's of any names. Will need to be overridden by subclasses that want to provide this metadata."

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

invokeId: dispidInteger flags: flagsInteger withArguments: anArray
	"Invoke the receiver's method with `<integer>` dispatch id, dispid, and the contents of the `Array` of `<variantCompatible>`, anArray, as the arguments."

	^E_NOTIMPL!

notifyDispatchError: anError invoking: dispidInteger
	"Private - An error occcurred dispatching from Invoke(), notify the session. Can be overridden by subclasses that wish to suppress errors completely so that they are only reported back to the caller, however it is useful for debugging purposes to be able to hook in a breakpoint here."

	Notification signal: ('Error dispatching id(%1!!#010x!!):  %3, from %4' 
					formatWith: dispidInteger 
						with: anError hresult 
						with: anError printString 
						with: self printString).
!

supportedInterfaces
	"Answer the sequence of interface classes supported by the receiver."

	^##({ IUnknown. IDispatch })!

typeInfo: lcidInteger ifNone: aNiladicValuable
	"Private - Answer an `ITypeInfo` on the type information for this dispinterface, or if none is available the result of evaluating the `<niladicValuable>` 2nd argument."

	^aNiladicValuable value!

typeInfoCount
	"Answer 1 if type information is available, else 0."

	^0! !

!OS.COM.AbstractDispatchImplementation categoriesForMethods!
decodeArgs:!helpers!private! !
errorDispatching:exception:excepInfo:!operations!private! !
GetIDsOfNames:rgszNames:cNames:lcid:rgdispid:!COM Interfaces-IDispatch!public! !
GetTypeInfo:lcid:pptinfo:!COM Interfaces-IDispatch!public! !
GetTypeInfoCount:!COM Interfaces-IDispatch!public! !
idsOfNames:whenNotKnown:!accessing!public! !
Invoke:riid:lcid:wFlags:pdispparams:pvarResult:pexcepinfo:puArgErr:!COM Interfaces-IDispatch!public! !
invokeId:flags:withArguments:!operations!public! !
notifyDispatchError:invoking:!operations!private! !
supportedInterfaces!constants!public! !
typeInfo:ifNone:!accessing!private! !
typeInfoCount!accessing!public! !
!

OS.COM.AbstractDispatchImplementation methodProtocol: #IDispatch attributes: #(#readOnly) selectors: #(#GetIDsOfNames:rgszNames:cNames:lcid:rgdispid: #GetTypeInfo:lcid:pptinfo: #GetTypeInfoCount: #Invoke:riid:lcid:wFlags:pdispparams:pvarResult:pexcepinfo:puArgErr:)!

