"Filed out from Dolphin Smalltalk"!

Kernel.StaticVariableBinder
	subclass: #'Refactory.Browser.UndeclaredVariableCollector'
	instanceVariableNames: 'undeclareds'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.UndeclaredVariableCollector guid: (Core.GUID fromString: '{3bf81361-321e-41e8-8df8-31ee26ae4159}')!

Refactory.Browser.UndeclaredVariableCollector comment: '`Refactory.Browser.UndeclaredVariableCollector` is a specialised semantic analyser used by SmallLint in Dolphin to find undeclared static variables.'!

!Refactory.Browser.UndeclaredVariableCollector methodsFor!

undeclareds
	^undeclareds ?? #()!

undeclaredVariable: aVariableNode
	(undeclareds ifNil: [undeclareds := OrderedCollection new]) add: aVariableNode! !

!Refactory.Browser.UndeclaredVariableCollector categoriesForMethods!
undeclareds!accessing!public! !
undeclaredVariable:!error handling!private! !
!

