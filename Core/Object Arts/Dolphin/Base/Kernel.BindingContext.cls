"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.BindingContext'
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

owningPackage
	^methodClass owningPackage!

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
			((visited
				ifNil: 
					[visited := (Set new: 8)
								add: methodClass;
								yourself])
					addNewElement: namespace) ifTrue: [namespace]]! !
!Kernel.BindingContext categoriesForMethods!
environment!accessing!public! !
identifier!accessing!public! !
includesNamespace:!public!testing! !
methodClass!accessing!public! !
owningPackage!accessing!public! !
setMethodClass:environment:identifier:!initializing!private! !
visitImport:from:!public! !
!

Kernel.BindingContext methodProtocol: #parseContext attributes: #(#readOnly) selectors: #(#environment #methodClass #owningPackage)!

!Kernel.BindingContext class methodsFor!

methodClass: aClass environment: aNamespace identifier: aString
	<primitive: 157>
	^self new
		setMethodClass: aClass
			environment: aNamespace
			identifier: aString;
		yourself! !
!Kernel.BindingContext class categoriesForMethods!
methodClass:environment:identifier:!instance creation!public! !
!

