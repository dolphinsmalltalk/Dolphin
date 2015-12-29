"Filed out from Dolphin Smalltalk X6"!

IEnumUnknown subclass: #IEnumErrorInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IEnumErrorInfo guid: (IID fromString: '{502052C4-0FE9-4A5F-9A7D-2335D7584DED}')!
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

