"Filed out from Dolphin Smalltalk"!

Kernel.FullBindingReference
	subclass: #'Kernel.NamespaceImport'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'InvalidImportPath' -> 'NamespaceImports must describe a full path from Root' }!

Kernel.NamespaceImport guid: (Core.GUID fromString: '{fa5ba0c4-b5dc-4eb0-95be-564ca7df61e8}')!

Kernel.NamespaceImport comment: '`NamespaceImport` is a specialised form of `FullBindingReference` that binds only to locally defined variables of each namespace along the binding path. It does not find variables defined in superclasses, environments, or (most importantly) via imports. It is intended for the purpose of representing namespace imports into classes, and so defines a more restricted binding search that avoids infinite recursion if an import into the binding root (Smalltalk) is not found.

The binding root of `NamespaceImports` is `Root`, so imports of namespaces defined in Smalltallk must be of the form #{Smalltalk.Xxx}. The `ClassBuilder` will canonicalize any imports provided to the class definition messages, including converting them into `NamespaceImports`.'!

!Kernel.NamespaceImport methodsFor!

asNamespaceImport
	"Answer a<NamespaceImport> that references the same binding as the receiver, the value of which is assumed to be an <importableNamespace>."

	^self!

bindingScope
	"Answer the <bindingScope> from which the receiver's binding path is traversed to locate the target binding. In the case of namespace imports, these always specify a full path from Root."

	^Root!

resolveIn: aBindingScope
	^aBindingScope localScope resolveLocalBindingPath: self path!

species
	^FullBindingReference! !

!Kernel.NamespaceImport categoriesForMethods!
asNamespaceImport!converting!public! !
bindingScope!accessing!public! !
resolveIn:!operations!private! !
species!accessing!public! !
!

!Kernel.NamespaceImport class methodsFor!

newFull: aString private: aBoolean
	^self
		pathString: aString
		path: nil
		private: aBoolean!

newFullPath: anArrayOfString private: aBoolean 
	^self
		pathString: nil
		path: anArrayOfString
		private: aBoolean! !

!Kernel.NamespaceImport class categoriesForMethods!
newFull:private:!instance creation!private! !
newFullPath:private:!instance creation!private! !
!

