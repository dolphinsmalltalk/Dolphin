"Filed out from Dolphin Smalltalk 7"!

OS.COM.InterfaceFunction subclass: #'OS.COM.DispatchFunction'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Errors})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.DispatchFunction guid: (Core.GUID fromString: '{4596042f-9e7a-4481-8f6c-d71e47fc990c}')!
OS.COM.DispatchFunction comment: ''!
!OS.COM.DispatchFunction categoriesForClass!Unclassified! !
!OS.COM.DispatchFunction methodsFor!

callback: stub interface: aCOMInterface withArgumentsAt: anAddress 
	"Private - Forward a COM virtual function call as a message to the object which implements
	the IDispatch interface functions in the <COMInterface>, aCOMInterface, with arguments 
	instantiated from the machine stack at the <integer> address, anAddress, corresponding to the
	receivers argument types. Answer the result.

	Implementation Note: IDispatch is typically implemented in a separate object than custom
	interfaces (or the custom part of a dual interface), since the implementation is typically 
	generic, dispatching either to the custom end of a dual interface through ITypeInfo, or 
	through some other common mechanism.
	Errors are not trapped at this level because Invoke() has special error reporting arguments
	that must be filled out."

	^aCOMInterface dispatchImplementor 
		ifNotNil: 
			[:dispatcher | 
			dispatcher 
				perform: selector
				withArgumentsAt: anAddress
				descriptor: descriptor]
		ifNil: [E_NOTIMPL]! !
!OS.COM.DispatchFunction categoriesFor: #callback:interface:withArgumentsAt:!evaluating!private! !

