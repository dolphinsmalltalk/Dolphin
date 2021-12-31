#(#initialize #defaultCaption:) do: [:each | MessageBoxAbstract class removeSelector: each]!
AbstractBindingReference addClassConstant: 'PathSeparator' value: $.!
!Kernel.BindingReference methodsFor!
displayOn: aPuttableStream
	aPuttableStream nextPutAll: self pathString! !
STBClassConversion instanceVariableString: 'version instSize isBytes isVariable converterBlock filer'!
#(#pathString:scope:flags: #pathString:private:scope: #pathString:private:) do: [:each | 
	AbstractBindingReference class methodDictionary at: each put: (BindingReference class compiledMethodAt: each)]!
VM registryAtIndex: 105 put: AbstractBindingReference!
