!CompiledExpression methodsFor!
storeSourceString: aString evaluationPools: anArray
	| pools |
	pools := anArray notNil
				ifTrue: 
					[| nonEmptyPools |
					nonEmptyPools := anArray reject: [:each | each isEmpty].
					nonEmptyPools notEmpty ifTrue: [nonEmptyPools]].
	self sourceDescriptor: (pools isNil ifTrue: [aString] ifFalse: [{aString. pools}])! !

!String methodsFor!

asMethodCategory
	^self class methodCategoryClass name: self! !
	
!MethodCategory methodsFor!

asMethodCategory
	^self! !
