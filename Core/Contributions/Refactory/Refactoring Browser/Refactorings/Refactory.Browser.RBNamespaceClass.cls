"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBClass
	subclass: #'Refactory.Browser.RBNamespaceClass'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBNamespaceClass guid: (Core.GUID fromString: '{35f11892-77d8-41e3-b3b1-679396a71df6}')!
Refactory.Browser.RBNamespaceClass comment: ''!
!Refactory.Browser.RBNamespaceClass categoriesForClass!Refactory-Model! !
!Refactory.Browser.RBNamespaceClass methodsFor!

addClass: aRBClass
	self classPool add: ((RBVariableBinding name: aRBClass unqualifiedName environment: self)
				setFlags: 0;
				value: aRBClass;
				yourself)!

baseEnvironment
	"Answer the default environment for new subclasses of the receiver that the ClassBuilder should use when the provided subclass name is unqualified."

	"Namespaces created with unqualified names should be dropped into Root, not Smalltalk."

	^model rootNamespace!

defaultInstanceSpec
	^##(Behavior._PointersMask | Behavior._NonInstantiableMask)!

fullName: aString
	name = aString ifTrue: [^self].
	super fullName: aString.
	self bindings do: 
			[:each |
			each isClassBinding
				ifTrue: [each value fullName: name , BindingReference.PathSeparatorString , each value unqualifiedName]]!

hierarchyBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, i.e. one of its own class variables or those of its superclasses."

	^self localBindingFor: aString!

removeClass: aRBClass
	self removeBindingFor: aRBClass unqualifiedName! !
!Refactory.Browser.RBNamespaceClass categoriesForMethods!
addClass:!public! !
baseEnvironment!constants!public! !
defaultInstanceSpec!constants!private! !
fullName:!accessing!private! !
hierarchyBindingFor:!bindings!public! !
removeClass:!public! !
!

Refactory.Browser.RBNamespaceClass methodProtocol: #bindingScope attributes: #(#readOnly) selectors: #(#environment #fullBindingFor: #localScope)!

