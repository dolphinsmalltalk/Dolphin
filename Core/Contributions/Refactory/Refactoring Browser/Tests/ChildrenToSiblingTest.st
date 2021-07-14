| model |
(model := Refactory.Browser.RBNamespace
			onEnvironment: ((Refactory.Browser.ClassEnvironment
					onEnvironment: Refactory.Browser.BrowserEnvironment new)
						classes: (#(#ConcreteSubclass #ConcreteSuperclass #NoMoveSubclass) inject: OrderedCollection new
								into: 
									[:sum :each |
									| class |
									class := Refactory.Browser.Tests at: each ifAbsent: [nil].
									class notNil ifTrue: [sum add: class].
									sum])
									, (#(#ConcreteSubclass #ConcreteSuperclass #NoMoveSubclass) inject: OrderedCollection new
											into: 
												[:sum :each |
												| class |
												class := Refactory.Browser.Tests at: each ifAbsent: [nil].
												class notNil ifTrue: [sum add: class class].
												sum]))
						not)
		name: 'Test'.
#('Core.Object subclass: #''Refactory.Browser.Tests.ConcreteSuperclass''
instanceVariableNames: ''instVarName1 instVarName2 ''
classVariableNames: ''ClassVarName1 ClassVarName2 ''
poolDictionaries: ''''
category: ''Testing''' 
'Refactory.Browser.Tests.ConcreteSuperclass subclass: #''Refactory.Browser.Tests.NoMoveSubclass''
instanceVariableNames: ''''
classVariableNames: ''''
poolDictionaries: ''''
category: ''Testing''' 
'Refactory.Browser.Tests.ConcreteSuperclass subclass: #''Refactory.Browser.Tests.ConcreteSubclass''
instanceVariableNames: ''''
classVariableNames: ''''
poolDictionaries: ''''
category: ''Testing''')
	do: [:each | model defineClass: each].
(model metaclassNamed: #'Refactory.Browser.Tests.ConcreteSuperclass')
	addInstanceVariable: 'classInstVarName1'.
#(#(#ConcreteSubclass #(#('initialize
super initialize.
instVarName1 := nil' #everyone) #('different
^0' #everyone))) #(#ConcreteSuperclass #(#('same
^self initialize isKindOf: ConcreteSuperclass' #'one def') #('different
^instVarName1 + instVarName2' #everyone) #('initialize
instVarName1 := instVarName2 := ClassVarName1 := ClassVarName2 := 0' #everyone))) #(#NoMoveSubclass #(#('same
^123' #'one def') #('qualifiedRef
^self initialize isKindOf: Refactory.Browser.Tests.ConcreteSuperclass "Hello"' #'one def'))) #('ConcreteSubclass class' #(#('bar
^self storeString' #testing))) #('ConcreteSuperclass class' #(#('foo
^classInstVarName1 + ClassVarName1 + ClassVarName2' #testing) #('new
^super new initialize' #testing) #('bar
^self printString' #testing))) #('NoMoveSubclass class' #()))
	do: 
		[:each |
		| class |
		class := model classNamed: 'Refactory.Browser.Tests.' , each first.
		each last do: [:meth | class compile: meth first classified: meth last]].
model