"Filed out from Dolphin Smalltalk 7"!

ValuePresenter subclass: #InspectorAbstract
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
InspectorAbstract guid: (GUID fromString: '{a5e858b2-45f7-4ae8-8f14-c11aad5f3ba4}')!
InspectorAbstract isAbstract: true!
InspectorAbstract comment: ''!
!InspectorAbstract categoriesForClass!MVP-Presenters! !
!InspectorAbstract methodsFor!

browseClass
	"Private - Open a new default class browser on the class of the object being inspected."

	self systemModel browseClass: self browseObject class!

browseHierarchy
	"Private - Open a new class browser on the class of the object being inspected."

	self systemModel browseHierarchy: self browseObject class!

browseIt
	"Open a default browser on the current object."

	self browseObject browse!

browseObject
	"Private - Answer the object from the receiver that should be browsed"

	^self inspecteeSelection!

browseSystem
	"Open a new system browser on the class of the object being inspected."
	
	self systemModel browseSystem: self browseObject class!

inspecteeSelection
	"Private - Answer the value associated with the currently selected object"

	^self subclassResponsibility!

inspectIt
	"Open a new Inspector on the variable selected in variablesModel."

	self inspecteeSelection inspect!

object: anObject
	"Set the object which is inspected by the receiver."

	self value: anObject
!

systemModel
	^SmalltalkSystem current! !
!InspectorAbstract categoriesFor: #browseClass!commands!private! !
!InspectorAbstract categoriesFor: #browseHierarchy!commands!private! !
!InspectorAbstract categoriesFor: #browseIt!commands!public! !
!InspectorAbstract categoriesFor: #browseObject!accessing!private! !
!InspectorAbstract categoriesFor: #browseSystem!commands!public! !
!InspectorAbstract categoriesFor: #inspecteeSelection!accessing!private! !
!InspectorAbstract categoriesFor: #inspectIt!commands!public! !
!InspectorAbstract categoriesFor: #object:!accessing!public! !
!InspectorAbstract categoriesFor: #systemModel!accessing!private! !

!InspectorAbstract class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon! !
!InspectorAbstract class categoriesFor: #icon!constants!public! !

