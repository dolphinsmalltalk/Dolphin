"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #InspectorAbstract
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!InspectorAbstract categoriesForMethods!
browseClass!commands!private! !
browseHierarchy!commands!private! !
browseIt!commands!public! !
browseObject!accessing!private! !
browseSystem!commands!public! !
inspecteeSelection!accessing!private! !
inspectIt!commands!public! !
object:!accessing!public! !
systemModel!accessing!private! !
!

!InspectorAbstract class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon! !
!InspectorAbstract class categoriesForMethods!
icon!constants!public! !
!

