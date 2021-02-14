"Filed out from Dolphin Smalltalk 7"!

OS.COM.AbstractInterfaceFunction subclass: #'OS.COM.AddRefFunction'
	instanceVariableNames: ''
	classVariableNames: 'Descriptor'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.AddRefFunction guid: (Core.GUID fromString: '{19c5e908-2db4-4e67-8984-b11c9cf2e982}')!
OS.COM.AddRefFunction comment: 'COMAddRefFunction is a specialized class of <COMFunction> intended to represent the IUnknown::AddRef() method.

As IUnknown is implemented entirely by the <COMObjectStub>, a COMAddRefFunction sends a #AddRef message to the relevant stub.'!
!OS.COM.AddRefFunction categoriesForClass!COM-Implementations! !
!OS.COM.AddRefFunction methodsFor!

callback: stub interface: aCOMInterface withArgumentsAt: pArgs
	"Private - Send an IUnknown::AddRef() call as an #AddRef message back to 
	the <COMObjectStub>, stub. Answer the resulting reference count.

	Implementation Note: This method is called very frequently, so we have a special function
	class just to improve performance."

	^stub AddRef!

descriptor
	"Private - Answer the descriptor object which described the external function represented
	by the receiver."

	^Descriptor!

selector
	"Private - Answer the selector sent when the receiver is evaluated."

	^#AddRef! !
!OS.COM.AddRefFunction categoriesFor: #callback:interface:withArgumentsAt:!evaluating!private! !
!OS.COM.AddRefFunction categoriesFor: #descriptor!accessing!private! !
!OS.COM.AddRefFunction categoriesFor: #selector!accessing!private! !

!OS.COM.AddRefFunction class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	Descriptor := IUnknown descriptorClass
				callingConvention: IUnknown stdMethodCallType
				returnType: 'dword'
				argumentTypes: ''!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Descriptor := nil! !
!OS.COM.AddRefFunction class categoriesFor: #initialize!development!initializing!private! !
!OS.COM.AddRefFunction class categoriesFor: #uninitialize!class hierarchy-removing!private! !

