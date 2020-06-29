"Filed out from Dolphin Smalltalk 7"!

COMInterfaceImp subclass: #AXPropertyBagErrorLog
	instanceVariableNames: 'errors guid'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AXPropertyBagErrorLog guid: (GUID fromString: '{9c956c62-af27-11d3-b376-080046056106}')!
AXPropertyBagErrorLog comment: 'AXErrorLog is a simple implementation of an Active-X error log object which supports the interface <IErrorLog>. It is used, for example, to record errors occurring during a call to IPersistPropertyBag::Load().

Instance Variables:
	errorLog		<LookupTable> mapping property names to <OrderedCollection> of
			<EXCEPINFO> (i.e. the error sequence ) for that property.
	guid		<GUID> of the object being loaded (e.g. CLSID).

'!
!AXPropertyBagErrorLog categoriesForClass!Unclassified! !
!AXPropertyBagErrorLog methodsFor!

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
	errors keysAndValuesDo: [:prop :exs |
		exs do: [:ex | seq addLast: (IErrorInfo fromEXCEPINFO: ex guid: self guid)]].
	^COMInterfaceEnumerator newEnumerator: IEnumErrorInfo on: seq!

queryInterface: anInterfaceClass ifNone: exceptionHandler
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	^anInterfaceClass == IEnumErrorInfo
		ifTrue: [self queryIEnumErrorInfo]
		ifFalse: [super queryInterface: anInterfaceClass ifNone: exceptionHandler].
!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^#(##(IErrorLog) ##(IEnumErrorInfo))! !
!AXPropertyBagErrorLog categoriesFor: #AddError:pExcepInfo:!COM Interfaces-IErrorLog!public! !
!AXPropertyBagErrorLog categoriesFor: #guid!accessing!private! !
!AXPropertyBagErrorLog categoriesFor: #guid:!accessing!private! !
!AXPropertyBagErrorLog categoriesFor: #initialize!initializing!private! !
!AXPropertyBagErrorLog categoriesFor: #isEmpty!public!testing! !
!AXPropertyBagErrorLog categoriesFor: #notEmpty!public!testing! !
!AXPropertyBagErrorLog categoriesFor: #queryIEnumErrorInfo!accessing-interfaces!public! !
!AXPropertyBagErrorLog categoriesFor: #queryInterface:ifNone:!accessing-interfaces!public! !
!AXPropertyBagErrorLog categoriesFor: #supportedInterfaces!constants!public! !

AXPropertyBagErrorLog methodProtocol: #IErrorLog attributes: #(#readOnly) selectors: #(#AddError:pExcepInfo:)!

