"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.BindingContext'
	instanceVariableNames: 'methodClass environment identifier visited'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.BindingContext guid: (Core.GUID fromString: '{4d343a64-a62f-4214-bca5-ac205fc9ab21}')!
Kernel.BindingContext comment: ''!
!Kernel.BindingContext categoriesForClass!Kernel-Objects! !
!Kernel.BindingContext methodsFor!

environment
	^environment!

identifier
	"The <String> identifier to bind."

	^identifier!

includesNamespace: aNamespace
	^methodClass == aNamespace or: 
			[(methodClass inheritsFrom: aNamespace)
				or: [environment notNil and: [environment includesEnvironment: aNamespace]]]!

methodClass
	"The source <Class> from which the binding search was initiated, e.g. the class into which code is being compiled."

	^methodClass!

setMethodClass: aClass environment: aNamespace identifier: aString
	methodClass := aClass.
	identifier := aString.
	environment := aNamespace.
	^self!

visitImport: aBindingReference from: aNamespace
	(aBindingReference isPrivate and: [(self includesNamespace: aNamespace) not]) ifTrue: [^nil].
	^aBindingReference valueOrNil
		ifNotNil: 
			[:namespace |
			"We delay initializing the visited set until the last possible moment, as mostly is is not required."
			((visited ifNil: [visited := Set with: methodClass]) addNewElement: namespace) ifTrue: [namespace]]! !
!Kernel.BindingContext categoriesFor: #environment!accessing!public! !
!Kernel.BindingContext categoriesFor: #identifier!accessing!public! !
!Kernel.BindingContext categoriesFor: #includesNamespace:!public!testing! !
!Kernel.BindingContext categoriesFor: #methodClass!accessing!public! !
!Kernel.BindingContext categoriesFor: #setMethodClass:environment:identifier:!initializing!private! !
!Kernel.BindingContext categoriesFor: #visitImport:from:!public! !

Kernel.BindingContext methodProtocol: #parseContext attributes: #(#readOnly) selectors: #(#environment #methodClass)!

!Kernel.BindingContext class methodsFor!

methodClass: aClass environment: aNamespace identifier: aString
	<primitive: 157>
	^self new
		setMethodClass: aClass
			environment: aNamespace
			identifier: aString;
		yourself! !
!Kernel.BindingContext class categoriesFor: #methodClass:environment:identifier:!instance creation!public! !

