"Filed out from Dolphin Smalltalk 7"!

IEnumUnknown subclass: #IEnumErrorInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IEnumErrorInfo guid: (IID fromString: '{502052c4-0fe9-4a5f-9a7d-2335d7584ded}')!
IEnumErrorInfo comment: ''!
!IEnumErrorInfo categoriesForClass!Unclassified! !
!IEnumErrorInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the receiver.
		self defineTemplate
	"

	"This method only present to prevent auto-generation from a type library"!

elementClass
	"Answer the class of element enumerated by the receiver."

	^IErrorInfo! !
!IEnumErrorInfo class categoriesFor: #defineFunctions!initializing!public! !
!IEnumErrorInfo class categoriesFor: #elementClass!constants!public! !

