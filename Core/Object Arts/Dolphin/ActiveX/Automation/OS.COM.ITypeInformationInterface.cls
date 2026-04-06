"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.ITypeInformationInterface'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.OLEAutLibrary})
	classInstanceVariableNames: ''
	classConstants: { 'TYPE_E_ELEMENTNOTFOUND' -> -16r7FFD7FD5 }!

OS.COM.ITypeInformationInterface guid: (OS.COM.IID fromString: '{f17bbb49-e4df-4fac-b4f6-fcaaeb00f9f4}')!

OS.COM.ITypeInformationInterface isNonInstantiable: true!

OS.COM.ITypeInformationInterface comment: ''!

!OS.COM.ITypeInformationInterface methodsFor!

allCustData
	^self getAllCustData!

getAllCustData
	"Answer a <CUSTDATA> describing the custom data associated with the type described by this ITypeInfo."

	^self nullCustData!

getDocumentation: anInteger ifAbsent: exceptionHandler
	| hr answer dwHelpContext bstrDocString bstrName bstrHelpFile |
	bstrName := BSTR basicNew.
	bstrDocString := BSTR basicNew.
	bstrHelpFile := BSTR basicNew.
	dwHelpContext := UInt32Bytes new.
	hr := self
				GetDocumentation: anInteger
				pBstrName: bstrName
				pBstrDocString: bstrDocString
				pdwHelpContext: dwHelpContext
				pBstrHelpFile: bstrHelpFile.
	hr < 0
		ifTrue: 
			[hr = TYPE_E_ELEMENTNOTFOUND ifTrue: [^exceptionHandler value].
			^HRESULTError signalWith: hr].
	answer := TypeLibDocumentation new
				name: bstrName asUtf16String
				helpstring: bstrDocString asUtf16String
				helpcontext: dwHelpContext asInteger
				helpfile: bstrHelpFile asUtf16String trimNulls.
	bstrName basicFree.
	bstrDocString basicFree.
	bstrHelpFile basicFree.
	^answer!

GetDocumentation: anInteger pBstrName: pBstrName pBstrDocString: pBstrDocString pdwHelpContext: pdwHelpContext pBstrHelpFile: pBstrHelpFile
	^self subclassResponsibility!

getName: anInteger ifAbsent: exceptionHandler
	| bstrName name hr |
	bstrName := BSTR basicNew.
	"We could use getDocumentation:ifAbsent:, but that involves a lot of extra processing for information we don't need."
	hr := self
				GetDocumentation: anInteger
				pBstrName: bstrName
				pBstrDocString: nil
				pdwHelpContext: nil
				pBstrHelpFile: nil.
	hr < 0
		ifTrue: 
			[^hr = TYPE_E_ELEMENTNOTFOUND ifTrue: [exceptionHandler value] ifFalse: [HRESULTError signalWith: hr]].
	name := bstrName asString.
	bstrName basicFree.
	^name!

getTypeComp
	"Answer the <ITypeComp> result of invoking the COM Object's GetTypeComp() method."

	| answer |
	answer := ITypeComp newPointer.
	self GetTypeComp: answer.
	^answer asObject!

GetTypeComp: anITypeComp
	self subclassResponsibility!

nullCustData
	^CUSTDATA new
		beUnfinalizable;
		yourself!

typeComp
	"Answer an ITypeComp on the receiver."

	| answer |
	answer := ITypeComp newPointer.
	self GetTypeComp: answer.
	^answer! !

!OS.COM.ITypeInformationInterface categoriesForMethods!
allCustData!public! !
getAllCustData!accessing!public! !
getDocumentation:ifAbsent:!accessing!private! !
GetDocumentation:pBstrName:pBstrDocString:pdwHelpContext:pBstrHelpFile:!COM Interfaces-ITypeLib!primitives!private! !
getName:ifAbsent:!accessing!private! !
getTypeComp!**auto generated**!methods!public! !
GetTypeComp:!COM Interfaces-ITypeLib!COM Interfaces-OAIDL.ITypeInfo!primitives!public! !
nullCustData!accessing!public! !
typeComp!accessing!public! !
!

