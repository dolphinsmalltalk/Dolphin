"Filed out from Dolphin Smalltalk 7"!

COMFunctionAbstract subclass: #COMFunction
	instanceVariableNames: 'selector descriptor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
COMFunction guid: (GUID fromString: '{87b4c466-026e-11d3-9fd7-00a0cc3e4a32}')!
COMFunction comment: 'COMFunction is the generic class of <COMFunctionAbstract> used to represent the majority of COM functions which are forwarded to the implementing <Object> (COM server) rather than the <COMObjectStub> or any other object.

Instance Variables:
	selector		<Symbol>. Selector to be forwarded.
	descriptor		<FunctionDescriptor>. Argument type descriptions.
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

descriptor: aFunctionDescriptor
	"Private - Set the receiver's external function descriptor."

	descriptor := aFunctionDescriptor!

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

selector: aSymbol descriptor: aFunctionDescriptor
	"Answer a new instance of the receiver appropriate for dispatching callbacks
	with the specified prototype, using the specified message selector."

	^self new
		selector: aSymbol;
		descriptor: aFunctionDescriptor! !
!COMFunction class categoriesFor: #prototype:!instance creation!public! !
!COMFunction class categoriesFor: #selector:descriptor:!instance creation!public! !

