"Filed out from Dolphin Smalltalk"!

OS.COM.AbstractDispatchImplementation
	subclass: #'OS.COM.DualInterfaceImplementation'
	instanceVariableNames: 'interface piTypeInfo locale'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.DualInterfaceImplementation guid: (Core.GUID fromString: '{c06f3b7c-0868-11d3-93af-00a024ca708a}')!

OS.COM.DualInterfaceImplementation isNonInstantiable: true!

OS.COM.DualInterfaceImplementation comment: '`OS.COM.DualInterfaceImplementation` provides a generic implementation of `IDispatch` for dual interfaces with type information (i.e. a type library). It makes use of `ITypeInfo`''s ability to invoke the dual part of a dispatch interface when called via the late-bound IDispatch methods.

`DualInterfaceImplementation` implements `IDispatch` in a very simple and efficient manner, but cannot be used for dispatch only interfaces (dispinterfaces), such as most connection points, or where no type library is available.
'!

!OS.COM.DualInterfaceImplementation categoriesForClass!COM-Implementations! !

!OS.COM.DualInterfaceImplementation methodsFor!

finalRelease
	"The last reference to the receiver (as a COM object) has been released. This is an opportunity to actively clean up, rather than passively waiting for finalization which might is asynchronous and may never happen if the object doesn't become garbage."

	"The primary dual interface will be invalid now"
	interface := nil!

GetIDsOfNames: riid rgszNames: rgszNames cNames: cNames lcid: lcid rgdispid: rgDispid
	"Implement the IDispatch::GetIDsOfNames() interface function by using the type library implementation"

	^self typeInfo asParameter
		GetIDsOfNames: rgszNames yourAddress
		cNames: cNames
		pMemId: rgDispid!

GetTypeInfoCount: count
	"Implement the IDispatch::GetTypeInfoCount() interface function."

	"If we were are unable to access type info for the interface then we must answer 0."
	count value: ((self typeInfo: locale ifNone: [])
		isNil ifTrue: [0] ifFalse: [1]).

	^S_OK
!

interface
	"Private - Answer the receiver's dual COM interface. For internal use only as does not hold a COM reference."

	^interface ifNil: [interface := self interfaceClass internalOn: self server implementor: self]!

interface: anInterface
	interface := anInterface!

interfaceClass
	"Answer the interface class which is implemented by the receiver."

	^self subclassResponsibility!

Invoke: dispid  riid: riid lcid: lcid wFlags: wFlags pdispparams: pdispparams pvarResult: pVarResult pexcepinfo: pExcepInfo puArgErr: puArgErr
	"Implement the IDispatch::Invoke() interface function.
	Forward to the receiver's ITypeInfo which will do the hard work for us."

	^self typeInfo asParameter
		safeInvoke: self interface
		memid: dispid 
		wFlags: wFlags 
		pDispParams: pdispparams 
		pVarResult: pVarResult 
		pExcepInfo: pExcepInfo 
		puArgErr: puArgErr!

piTypeInfo: anITypeInfo
	piTypeInfo := anITypeInfo!

supportedInterfaces
	"Answer the sequence of interface classes supported by the receiver. This is IDispatch plus the IDispatch subclass of the dual interface."

	^{ IUnknown. IDispatch. self interfaceClass }!

typeInfo
	"Private - Answer the ITypeInfo we use to actually implement this IDispatch interface."

	^self typeInfo: locale ifNone: [HRESULTError signalWith: E_FAIL]!

typeInfo: lcidInteger ifNone: aNiladicValuable
	"Private - Answer the `ITypeInfo` we use to actually implement this `IDispatch` interface, or if none is available the result of evaluating the `<niladicValuable>` 2nd argument."

	piTypeInfo isNull 
		ifTrue: [
			locale := lcidInteger.
			#todo "Need to ask for particular type info".
			piTypeInfo := self interfaceClass typeInfoIfNone: [^aNiladicValuable value]]
		ifFalse: [
			(lcidInteger isNull or: [lcidInteger asParameter = locale asParameter])
				ifFalse: [^aNiladicValuable value]].
	^piTypeInfo! !

!OS.COM.DualInterfaceImplementation categoriesForMethods!
finalRelease!public!realizing/unrealizing! !
GetIDsOfNames:rgszNames:cNames:lcid:rgdispid:!COM Interfaces-IDispatch!public! !
GetTypeInfoCount:!COM Interfaces-IDispatch!public! !
interface!accessing!private! !
interface:!accessing!private! !
interfaceClass!accessing!public! !
Invoke:riid:lcid:wFlags:pdispparams:pvarResult:pexcepinfo:puArgErr:!COM Interfaces-IDispatch!public! !
piTypeInfo:!accessing!private! !
supportedInterfaces!constants!public! !
typeInfo!accessing!private! !
typeInfo:ifNone:!accessing!private! !
!

