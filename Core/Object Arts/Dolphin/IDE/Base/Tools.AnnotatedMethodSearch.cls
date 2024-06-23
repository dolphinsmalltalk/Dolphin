"Filed out from Dolphin Smalltalk"!

Tools.MethodSearch
	subclass: #'Tools.AnnotatedMethodSearch'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.AnnotatedMethodSearch guid: (Core.GUID fromString: '{ba126645-8637-444f-b92e-121f2559c06e}')!

Tools.AnnotatedMethodSearch comment: ''!

!Tools.AnnotatedMethodSearch methodsFor!

referenceFilter
	"Private - Answer a <monadicValuable> which can be used to discriminate between <CompiledMethod>s that
	match this search and those that do not."

	^[:each | each hasAnnotation: literal]!

referencesLabelTag
	^#annotated! !

!Tools.AnnotatedMethodSearch categoriesForMethods!
referenceFilter!accessing!private! !
referencesLabelTag!constants!public! !
!

