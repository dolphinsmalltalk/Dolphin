#(#initialize #defaultCaption:) do: [:each | MessageBoxAbstract class removeSelector: each]!
AbstractBindingReference addClassConstant: 'PathSeparator' value: $.!
!Kernel.BindingReference methodsFor!
displayOn: aPuttableStream
	aPuttableStream nextPutAll: self pathString! !
