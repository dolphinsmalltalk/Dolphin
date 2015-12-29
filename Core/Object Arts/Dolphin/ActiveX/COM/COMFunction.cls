"Filed out from Dolphin Smalltalk X6"!

COMFunctionAbstract subclass: #COMFunction
	instanceVariableNames: 'selector descriptor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COMFunction guid: (GUID fromString: '{87B4C466-026E-11D3-9FD7-00A0CC3E4A32}')!
COMFunction comment: 'COMFunction is the generic class of <COMFunctionAbstract> used to represent the majority of COM functions which are forwarded to the implementing <Object> (COM server) rather than the <COMObjectStub> or any other object.

Instance Variables:
	selector		<Symbol>. Selector to be forwarded.
	descriptor		<ExternalDescriptor>. Argument type descriptions.
'!
!COMFunction categoriesForClass!COM-Implementations! !
!COMFunction methodsFor!

callback: stub interface: aCOMInterface withArgumentsAt: anAddress
	"Private - Forward a COM virtual function call as a message to the appropriate implementing
	object stored in the interface, aCOMInterface, with arguments instantiated from memory pointed 
	at by anAddress, corresponding to the receivers argument types. Answer the result.
	Implementation Note: This is the normal form of COM dispatch. It isn't necessary to override
	this, but we do so purely to avoid two message sends for performance reasons."

	^aCOMInterface implementor
		perform: selector 
		withArgumentsAt: anAddress 
		descriptor: descriptor
!

descriptor
	"Private - Answer the descriptor object which described the external function represented
	by the receiver."

	^descriptor!

descriptor: anExternalDescriptor
	"Private - Set the receiver's external function descriptor."

	descriptor := anExternalDescriptor!

selector
	"Private - Answer the selector sent when the receiver is evaluated."

	^selector!

selector: aSymbol
	"Private - Record the selector which the receiver will send to the object
	implementing the COM virtual function when that function is called."

	selector := aSymbol! !
!COMFunction categoriesFor: #callback:interface:withArgumentsAt:!evaluating!private! !
!COMFunction categoriesFor: #descriptor!accessing!private! !
!COMFunction categoriesFor: #descriptor:!accessing!private! !
!COMFunction categoriesFor: #selector!accessing!private! !
!COMFunction categoriesFor: #selector:!accessing!private! !

!COMFunction class methodsFor!

prototype: anExternalMethod
	"Answer a new instance of the receiver appropriate for dispatching callbacks
	to the argument, aCompiledMethod (which must be a callback method)."

	^self 
		selector: anExternalMethod selector
		descriptor: anExternalMethod descriptor!

selector: aSymbol descriptor: anExternalDescriptor
	"Answer a new instance of the receiver appropriate for dispatching callbacks
	with the specified prototype, using the specified message selector."

	^self new
		selector: aSymbol;
		descriptor: anExternalDescriptor! !
!COMFunction class categoriesFor: #prototype:!instance creation!public! !
!COMFunction class categoriesFor: #selector:descriptor:!instance creation!public! !

