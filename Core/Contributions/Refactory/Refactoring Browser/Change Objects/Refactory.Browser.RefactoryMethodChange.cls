"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryClassChange subclass: #'Refactory.Browser.RefactoryMethodChange'
	instanceVariableNames: 'selector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RefactoryMethodChange guid: (Core.GUID fromString: '{3bcbcd05-88cc-4f31-ac20-084fb202cbc6}')!
Refactory.Browser.RefactoryMethodChange isNonInstantiable: true!
Refactory.Browser.RefactoryMethodChange comment: ''!
!Refactory.Browser.RefactoryMethodChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RefactoryMethodChange methodsFor!

afterText
	^self source!

beforeText
	^(self methodSourceFor: selector) !

methodSourceFor: aSymbol
	^self changeClass
		ifNotNil: [:class | (class includesSelector: aSymbol) ifTrue: [class sourceCodeAt: aSymbol]]!

selector
	^selector!

selector: aSymbol 
	selector := aSymbol!

source
	^self subclassResponsibility! !
!Refactory.Browser.RefactoryMethodChange categoriesForMethods!
afterText!printing!public! !
beforeText!printing!public! !
methodSourceFor:!helpers!private! !
selector!accessing!public! !
selector:!initializing!private! !
source!accessing!public! !
!

