"Filed out from Dolphin Smalltalk"!

OS.COM.AbstractInterfaceFunction
	subclass: #'OS.COM.ReleaseFunction'
	instanceVariableNames: ''
	classVariableNames: 'Descriptor'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.ReleaseFunction guid: (Core.GUID fromString: '{8f012e18-24bd-4bc1-85eb-d0dd5497c142}')!

OS.COM.ReleaseFunction comment: 'COMReleaseFunction is a specialized class of <COMFunction> intended to represent the IUnknown::Release() method.

As IUnknown is implemented entirely by the <COMObjectStub>, a COMReleaseFunction sends a #Release message to the relevant stub.'!

!OS.COM.ReleaseFunction categoriesForClass!COM-Implementations! !

!OS.COM.ReleaseFunction methodsFor!

callback: stub interface: aCOMInterface withArgumentsAt: pArgs
	"Private - Send an IUnknown::AddRef() call as an #AddRef message back to 
	the <COMObjectStub>, stub. Answer the resulting reference count.

	Implementation Note: This method is called very frequently, so we have a special function
	class just to improve performance."

	^stub Release!

descriptor
	"Private - Answer the descriptor object which described the external function represented
	by the receiver."

	^Descriptor!

selector
	"Private - Answer the selector sent when the receiver is evaluated."

	^#Release! !

!OS.COM.ReleaseFunction categoriesForMethods!
callback:interface:withArgumentsAt:!evaluating!private! !
descriptor!accessing!private! !
selector!accessing!private! !
!

!OS.COM.ReleaseFunction class methodsFor!

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

!OS.COM.ReleaseFunction class categoriesForMethods!
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

