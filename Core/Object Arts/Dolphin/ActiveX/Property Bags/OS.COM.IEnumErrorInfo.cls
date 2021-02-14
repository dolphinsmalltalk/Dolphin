"Filed out from Dolphin Smalltalk 7"!

OS.COM.IEnumUnknown subclass: #'OS.COM.IEnumErrorInfo'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IEnumErrorInfo guid: (OS.COM.IID fromString: '{502052c4-0fe9-4a5f-9a7d-2335d7584ded}')!
OS.COM.IEnumErrorInfo comment: ''!
!OS.COM.IEnumErrorInfo categoriesForClass!Unclassified! !
!OS.COM.IEnumErrorInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the receiver.
		self defineTemplate
	"

	"This method only present to prevent auto-generation from a type library"!

elementClass
	"Answer the class of element enumerated by the receiver."

	^IErrorInfo! !
!OS.COM.IEnumErrorInfo class categoriesFor: #defineFunctions!initializing!public! !
!OS.COM.IEnumErrorInfo class categoriesFor: #elementClass!constants!public! !

