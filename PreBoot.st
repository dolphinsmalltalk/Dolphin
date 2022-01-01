#(#initialize #defaultCaption:) do: [:each | MessageBoxAbstract class removeSelector: each]!
AbstractBindingReference addClassConstant: 'PathSeparator' value: $.!
!Kernel.BindingReference methodsFor!
displayOn: aPuttableStream
	aPuttableStream nextPutAll: self pathString! !
STBClassConversion instanceVariableString: 'version instSize isBytes isVariable converterBlock filer'!
#(#pathString:scope:flags: #pathString:private:scope: #pathString:private:) do: [:each | 
	AbstractBindingReference class methodDictionary at: each put: (BindingReference class compiledMethodAt: each)]!
BindingReference class methodDictionary at: #newPathString:private: put: (BindingReference class compiledMethodAt: #pathString:private:)!
RelativeBindingReference class methodDictionary at: #newPathString:private:scope: put: (BindingReference class compiledMethodAt: #pathString:private:scope:)!
VM registryAtIndex: 105 put: AbstractBindingReference!

!Kernel.AbstractBindingReference class methodsFor!

newPath: anArray private: aBoolean scope: aBindingScope
	^(anArray size <= 1
		ifTrue: 
			[aBindingScope
				ifNil: [BindingReference basicNew setPath: anArray private: aBoolean]
				ifNotNil: 
					[RelativeBindingReference
						newPath: anArray
						private: aBoolean
						scope: aBindingScope]]
		ifFalse: 
			[(anArray at: 1) = '_'
				ifTrue: 
					[RelativeBindingReference
						newPath: (anArray copyFrom: 2 to: anArray size)
						private: aBoolean
						scope: aBindingScope]
				ifFalse: [BindingReference basicNew setPath: anArray private: aBoolean]])
		isImmutable: true;
		yourself! !
AbstractBindingReference classPool add: ((BindingReference classPool associationAt: 'Generation') environment: AbstractBindingReference; yourself).
BindingReference classPool removeKey: 'Generation'!