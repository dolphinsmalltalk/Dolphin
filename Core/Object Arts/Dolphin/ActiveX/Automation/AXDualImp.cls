"Filed out from Dolphin Smalltalk 7"!

AXDispatchImpAbstract subclass: #AXDualImp
	instanceVariableNames: 'interface piTypeInfo locale'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AXDualImp guid: (GUID fromString: '{c06f3b7c-0868-11d3-93af-00a024ca708a}')!
AXDualImp isAbstract: true!
AXDualImp comment: 'AXDualImp provides a generic implementation of IDispatch for dual interfaces with type information (i.e. a type library). It makes use of ITypeInfo''s ability to invoke the dual part of a dispatch interface when called via the late-bound IDispatch methods.

AXDualImp implements IDispatch in a very simple and efficient manner, but cannot be used for dispatch only interfaces (dispinterfaces), such as most connection points, or where no type library is available.
'!
!AXDualImp categoriesForClass!COM-Implementations! !
!AXDualImp methodsFor!

GetIDsOfNames: riid rgszNames: rgszNames 
		cNames: cNames lcid: lcid rgdispid: rgDispid
	"Implement the IDispatch::GetIDsOfNames() interface function.
	Implementation Note: We have to remove a level of indirection from the rgszNames array before
	forwarding, as the VM implicitly indirects void** args."

	^self typeInfo asParameter
		GetIDsOfNames: rgszNames value 
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
	"Answer the value of the receiver's 'interface' instance variable."

	interface isNil ifTrue: [interface := self queryInterface: self interfaceClass].
	^interface!

interface: anObject
	"Private - Set the value of the receiver's ''interface'' instance variable to the argument, anObject."

	interface := anObject!

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

piTypeInfo: anObject
	"Private - Set the value of the receiver's ''piTypeInfo'' instance variable to the argument, anObject."

	piTypeInfo := anObject!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver.
	This is IDispatch plus the IDispatch subclass of the dual interface."

	^{IDispatch. self interfaceClass}!

typeInfo
	"Private - Answer the ITypeInfo we use to actually implement this IDispatch
	interface."

	^self typeInfo: locale ifNone: [HRESULTError signalWith: E_FAIL]!

typeInfo: lcid ifNone: exceptionHandler
	"Private - Answer the ITypeInfo we use to actually implement this IDispatch
	interface, or if none is available the result of evaluating the <niladicValuable>,
	exceptionHandler."

	piTypeInfo isNull 
		ifTrue: [
			locale := lcid.
			#todo "Need to ask for particular type info".
			piTypeInfo := self interfaceClass typeInfoIfNone: [^exceptionHandler value]]
		ifFalse: [
			(lcid isNull or: [lcid asParameter = locale asParameter])
				ifFalse: [^exceptionHandler value]].
	^piTypeInfo! !
!AXDualImp categoriesFor: #GetIDsOfNames:rgszNames:cNames:lcid:rgdispid:!COM Interfaces-IDispatch!public! !
!AXDualImp categoriesFor: #GetTypeInfoCount:!COM Interfaces-IDispatch!public! !
!AXDualImp categoriesFor: #interface!accessing!public! !
!AXDualImp categoriesFor: #interface:!accessing!private! !
!AXDualImp categoriesFor: #interfaceClass!accessing!public! !
!AXDualImp categoriesFor: #Invoke:riid:lcid:wFlags:pdispparams:pvarResult:pexcepinfo:puArgErr:!COM Interfaces-IDispatch!public! !
!AXDualImp categoriesFor: #piTypeInfo:!accessing!private! !
!AXDualImp categoriesFor: #supportedInterfaces!constants!public! !
!AXDualImp categoriesFor: #typeInfo!accessing!private! !
!AXDualImp categoriesFor: #typeInfo:ifNone:!accessing!private! !

