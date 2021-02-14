"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'OS.COM.AbstractInterfaceFunction'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.AbstractInterfaceFunction guid: (Core.GUID fromString: '{17bd3725-7ec5-48d8-96b7-932dfee404c4}')!
OS.COM.AbstractInterfaceFunction isNonInstantiable: true!
OS.COM.AbstractInterfaceFunction comment: 'COMFunctionAbstract is the class of objects which describe COM functions or methods. A COMFunctionAbstract is a meta-level description that holds the type of the functions arguments, the selector of the implementation of this function. COMFunctionAbstract itself is abstract, with subclasses defined to describe different types of function.

An important behaviour of COMFunctionAbstract is the forwarding of an incoming COM method call to the Smalltalk implementation of that method. Different types of COMFunctionAbstract may forward such calls to different objects, perhaps as different messages. Each <COMInterface> class maintains an <Array> of COMFunctionAbstract subinstances, one for each of the functions defined for the interface, in virtual function table order. When a callback to a COM object implemented in Dolphin arrives from the VM (via the Processor object), the callback gets resolved to the corresponding <COMFunctionXXXX> which is then asked to send an appropriate message to the implementor of that function. The <COMFunctionXXXX> uses argument type information to marshal the arguments from the machine stack into appropriate Smalltalk objects, and then forwards the message as defined by its selector. The implementor might be the generic stub <COMObjectStub> - of which there is an instance for every COM object served up by Dolphin - if the function call is to one of the IUnknown methods, or the <Object> which served up the interface in the first place. The architecture allows the implementor to vary on a per function basis.'!
!OS.COM.AbstractInterfaceFunction categoriesForClass!COM-Implementations! !
!OS.COM.AbstractInterfaceFunction methodsFor!

argumentCount
	"Private - Answer the number of arguments expected by the receiver when 
	evaluated."

	^self descriptor argumentCount!

argumentsSize
	"Private - Answer the total size of the receiver's arguments (when
	pushed on the stack."

	^self descriptor argumentsSize!

argumentTypes
	"Private - Answer a collection of the argument type names used to instantiate arguments as
	Smalltalk objects when the receiver is evaluated."


	^self descriptor argumentTypes!

callback: stub interface: aCOMInterface withArgumentsAt: anAddress
	"Private - Forward a COM virtual function call as a message to the appropriate implementing
	object stored in the interface, aCOMInterface, with arguments instantiated from memory pointed 
	at by anAddress, corresponding to the receivers argument types. Answer the result.
	Implementation Note: This is the normal form of COM dispatch."

	^stub implementor		"Forward to the COM server object"
		perform: self selector 
		withArgumentsAt: anAddress 
		descriptor: self descriptor
!

callingConvention
	"Private - Answer the calling convention of the receiver's function."

	^self descriptor callingConvention!

descriptor
	"Private - Answer the descriptor object which described the external function represented
	by the receiver."

	^self subclassResponsibility!

messageSelectorAndArgumentNames
	"Private - Answer the text to be used for the message selector and argument names
	for automatically generated implementations of the function described by the receiver."

	| aStream |
	aStream := (String new: 256) writeStream.
	self argumentCount > 0 
		ifTrue: 
			[| keywords |
			keywords := self selector keywords.
			keywords do: 
					[:s | 
					aStream
						nextPutAll: s;
						space;
						nextPut: s first asLowercase;
						next: s size - 2
							putAll: s
							startingAt: 2]
				separatedBy: [aStream space]]
		ifFalse: [aStream nextPutAll: self selector].
	^aStream contents!

printOn: aStream
	"Append debug info about the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self selector;
		space;
		print: self descriptor description;
		nextPut: $)!

returnType
	"Private - Answer the return type name of the receiver."

	^self descriptor returnType!

selector
	"Private - Answer the selector sent when the receiver is evaluated."

	^self subclassResponsibility! !
!OS.COM.AbstractInterfaceFunction categoriesFor: #argumentCount!accessing!private! !
!OS.COM.AbstractInterfaceFunction categoriesFor: #argumentsSize!accessing!private! !
!OS.COM.AbstractInterfaceFunction categoriesFor: #argumentTypes!accessing!private! !
!OS.COM.AbstractInterfaceFunction categoriesFor: #callback:interface:withArgumentsAt:!evaluating!private! !
!OS.COM.AbstractInterfaceFunction categoriesFor: #callingConvention!accessing!private! !
!OS.COM.AbstractInterfaceFunction categoriesFor: #descriptor!accessing!private! !
!OS.COM.AbstractInterfaceFunction categoriesFor: #messageSelectorAndArgumentNames!accessing!private! !
!OS.COM.AbstractInterfaceFunction categoriesFor: #printOn:!development!printing!public! !
!OS.COM.AbstractInterfaceFunction categoriesFor: #returnType!accessing!private! !
!OS.COM.AbstractInterfaceFunction categoriesFor: #selector!accessing!private! !

