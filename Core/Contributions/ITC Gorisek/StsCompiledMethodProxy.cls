"Filed out from Dolphin Smalltalk 7"!

StsImportProxy subclass: #StsCompiledMethodProxy
	instanceVariableNames: 'methodSource methodClass selector isPrivate categoriesString'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsCompiledMethodProxy guid: (GUID fromString: '{2313d087-b7c8-4f1f-8981-eabaf5a0d935}')!
StsCompiledMethodProxy comment: ''!
!StsCompiledMethodProxy categoriesForClass!Unclassified! !
!StsCompiledMethodProxy methodsFor!

categoriesString
	^(categoriesString isNil or: [categoriesString isEmpty]) 
		ifTrue: ['*-unclassified!!']
		ifFalse: [categoriesString]!

categoriesString: aString 
	categoriesString := aString!

getSource
	^methodSource!

isPrivate
	^isPrivate == true!

isPrivate: aBoolean 
	isPrivate := aBoolean!

methodClass
	^methodClass!

methodClass: aStsClassProxy 
	methodClass := aStsClassProxy!

methodSource: aString 
	methodSource := aString!

name
	"This method is used in #isLooseMethod: which should always answer false.
		Therefore this name is chosen."

	^Association key: #'___STS@GORISEK.COM___' value: #'___STS@GORISEK.COM___'!

selector
	"TODO Method does not work for patern 'arg1:arg1 arg2:aString arg3:anInteger' , if there is no space beetween parameters."

	selector isNil 
		ifTrue: 
			[| tokens token |
			tokens := ReadStream on: (methodSource upTo: $") subStrings.
			token := tokens next.
			selector := token.
			[tokens atEnd not and: [token first ~= $< and: [token last = $:]]] whileTrue: 
					[tokens next.
					(tokens atEnd not and: [(token := tokens next) first ~= $< and: [token last = $:]]) 
						ifTrue: [selector := selector , token]].
			selector := selector asSymbol].
	^selector! !
!StsCompiledMethodProxy categoriesFor: #categoriesString!public! !
!StsCompiledMethodProxy categoriesFor: #categoriesString:!public! !
!StsCompiledMethodProxy categoriesFor: #getSource!public! !
!StsCompiledMethodProxy categoriesFor: #isPrivate!public! !
!StsCompiledMethodProxy categoriesFor: #isPrivate:!public! !
!StsCompiledMethodProxy categoriesFor: #methodClass!public! !
!StsCompiledMethodProxy categoriesFor: #methodClass:!public! !
!StsCompiledMethodProxy categoriesFor: #methodSource:!public! !
!StsCompiledMethodProxy categoriesFor: #name!public! !
!StsCompiledMethodProxy categoriesFor: #selector!public! !

