| model |
(model := Refactory.Browser.RBNamespace 
			onEnvironment: ((Refactory.Browser.ClassEnvironment onEnvironment: Refactory.Browser.BrowserEnvironment new) 
					classes: (#(#Bar #Foo) inject: OrderedCollection new
							into: 
								[:sum :each | 
								| class |
								class := Smalltalk at: each ifAbsent: [nil].
								class notNil ifTrue: [sum add: class].
								sum]) 
								, (#(#Bar #Foo) inject: OrderedCollection new
										into: 
											[:sum :each | 
											| class |
											class := Smalltalk at: each ifAbsent: [nil].
											class notNil ifTrue: [sum add: class class].
											sum])) 
						not) 
		name: 'Test'.

#('Core.Object subclass: #Foo
	instanceVariableNames: ''instVarName1 instVarName2 ''
	classVariableNames: ''ClassVarName1 ClassVarName2 ''
	poolDictionaries: ''''
	category: ''Testing''' 'Foo subclass: #Bar
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''Testing''') 
	do: [:each | model defineClass: each].
#(#(#Bar #(#('instVarName1
	^1242321' #tests) #('foo
	instVarName1 := instVarName1 + instVarName2 + ClassVarName1' #tests))) #(#Foo #(#('foo
	^instVarName2 := 3' #tests) #('bar
	"Add one to instVarName1"

	instVarName1 := instVarName1 + 1' #tests) #('classVarName1
	^ClassVarName1' #tests) #('instVarName1: anObject
	^anObject' #tests) #('asdf
	^self classVarName1: (ClassVarName1 := ClassVarName1 + 1)' #tests) #('instVarName2
	^instVarName2' #tests) #('instVarName2: anObject
	instVarName2 := anObject' #tests) #('classVarName1: anObject
	^ClassVarName1 := anObject' #tests))) #('Bar class' #(#('classVarName2: anObject
	ClassVarName2 := anObject' #tests) #('classVarName2
	^ClassVarName2' #tests))) #('Foo class' #(#('foo
	^ClassVarName1 := ClassVarName1 * ClassVarName1 * ClassVarName1' #tests)))) 
	do: 
		[:each | 
		| class |
		class := model classNamed: each first.
		each last do: [:meth | class compile: meth first classified: meth last]].
model