"Filed out from Dolphin Smalltalk 7"!

OS.COM.InterfaceImplementation subclass: #'OS.COM.PropertyBagErrorLog'
	instanceVariableNames: 'errors guid'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.PropertyBagErrorLog guid: (Core.GUID fromString: '{9c956c62-af27-11d3-b376-080046056106}')!
OS.COM.PropertyBagErrorLog comment: '`OS.COM.PropertyBagErrrorLog` is a simple implementation of the interface `IErrorLog`. It is used, for example, to record errors occurring during a call to IPersistPropertyBag::Load().

Instance Variables:
	errorLog		<LookupTable> mapping property names to <OrderedCollection> of
			<EXCEPINFO> (i.e. the error sequence ) for that property.
	guid		<GUID> of the object being loaded (e.g. CLSID).

'!
!OS.COM.PropertyBagErrorLog categoriesForClass!Unclassified! !
!OS.COM.PropertyBagErrorLog methodsFor!

AddError: pszPropName pExcepInfo: pExcepInfo 
	"Implement the IErrorLog::Add() method."

	| propLog |
	propLog := errors at: pszPropName ifAbsentPut: [OrderedCollection new].
	propLog addLast: pExcepInfo copy.
	Notification signal: ('Error ''<1s>: <2s>'' for property <3p>' 
				expandMacrosWith: pExcepInfo source
				with: pExcepInfo description
				with: pszPropName).
	^S_OK
!

guid
	"Private - Answer the value of the receiver's ''guid'' instance variable."

	^guid!

guid: anObject
	"Private - Set the value of the receiver's ''guid'' instance variable to the argument, anObject."

	guid := anObject!

initialize
	"Private - Initialize the receiver."

	errors := LookupTable new!

isEmpty
	"Answer whether the error log is empty."

	^errors isEmpty!

notEmpty
	"Answer whether the error log is empty."

	^self isEmpty not!

queryIEnumErrorInfo
	"Create <COMEnumerator> on a collection of <IErrorInfo>s built from the errors recorded in this log
	and answer an <IEnumErrorInfo> on the new enumerator."

	| seq |
	seq := OrderedCollection new.
	errors
		keysAndValuesDo: [:prop :exs | exs do: [:ex | seq addLast: (IErrorInfo fromEXCEPINFO: ex guid: self guid)]].
	^InterfaceEnumerator newEnumerator: IEnumErrorInfo on: seq!

queryInterface: anInterfaceClass ifNone: exceptionHandler
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	^anInterfaceClass == IEnumErrorInfo
		ifTrue: [self queryIEnumErrorInfo]
		ifFalse: [super queryInterface: anInterfaceClass ifNone: exceptionHandler]!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^{IErrorLog. IEnumErrorInfo}! !
!OS.COM.PropertyBagErrorLog categoriesFor: #AddError:pExcepInfo:!COM Interfaces-IErrorLog!public! !
!OS.COM.PropertyBagErrorLog categoriesFor: #guid!accessing!private! !
!OS.COM.PropertyBagErrorLog categoriesFor: #guid:!accessing!private! !
!OS.COM.PropertyBagErrorLog categoriesFor: #initialize!initializing!private! !
!OS.COM.PropertyBagErrorLog categoriesFor: #isEmpty!public!testing! !
!OS.COM.PropertyBagErrorLog categoriesFor: #notEmpty!public!testing! !
!OS.COM.PropertyBagErrorLog categoriesFor: #queryIEnumErrorInfo!accessing-interfaces!public! !
!OS.COM.PropertyBagErrorLog categoriesFor: #queryInterface:ifNone:!accessing-interfaces!public! !
!OS.COM.PropertyBagErrorLog categoriesFor: #supportedInterfaces!constants!public! !

OS.COM.PropertyBagErrorLog methodProtocol: #IErrorLog attributes: #(#readOnly) selectors: #(#AddError:pExcepInfo:)!

