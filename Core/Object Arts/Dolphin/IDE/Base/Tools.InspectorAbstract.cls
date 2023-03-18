"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'Tools.InspectorAbstract'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.InspectorAbstract guid: (Core.GUID fromString: '{a5e858b2-45f7-4ae8-8f14-c11aad5f3ba4}')!
Tools.InspectorAbstract isNonInstantiable: true!
Tools.InspectorAbstract comment: ''!
!Tools.InspectorAbstract categoriesForClass!MVP-Presenters! !
!Tools.InspectorAbstract methodsFor!

browseClass
	"Private - Open a new default class browser on the class of the object being inspected."

	self developmentSystem browseClass: self browseObject class!

browseHierarchy
	"Private - Open a new class browser on the class of the object being inspected."

	self developmentSystem browseHierarchy: self browseObject class!

browseIt
	"Open a default browser on the current object."

	self browseObject browse!

browseObject
	"Private - Answer the object from the receiver that should be browsed"

	^self inspecteeSelection!

browseSystem
	"Open a new system browser on the class of the object being inspected."
	
	self developmentSystem browseSystem: self browseObject class!

developmentSystem
	^SmalltalkSystem current!

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
	^self developmentSystem! !
!Tools.InspectorAbstract categoriesForMethods!
browseClass!commands!private! !
browseHierarchy!commands!private! !
browseIt!commands!public! !
browseObject!accessing!private! !
browseSystem!commands!public! !
developmentSystem!accessing!private! !
inspecteeSelection!accessing!private! !
inspectIt!commands!public! !
object:!accessing!public! !
systemModel!accessing!private! !
!

!Tools.InspectorAbstract class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon! !
!Tools.InspectorAbstract class categoriesForMethods!
icon!constants!public! !
!

