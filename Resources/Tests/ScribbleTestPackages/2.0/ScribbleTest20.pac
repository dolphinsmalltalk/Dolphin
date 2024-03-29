!STB 0 F    Package    6  String   ScribbleTestr   S   D:\dev\blairmcg\Dolphin\Resources\Tests\ScribbleTestPackages\2.0\ScribbleTest20.pacr   �   Package for testing loading of old packages, this one from Dolphin 2.0.

It contains a class with a view resource, loose methods, a loose view resource, a pre-install script STBCollectionProxy     STBClassProxy    r      IdentitySet&  Array    STBSymbolProxy    r      ScribbleTest�       �       r      Set      Association    *      r      Scribble*      r      looseA�      �  *      r      looseC�      *      r      ScribbleView*      r      model:�       �         �       �        r      Dolphinr      Scribble    STBIdentityDictionaryProxy    �       r      IdentityDictionary     *      r   
   preinstallr   Q   Transcript nextPutAll: 'A blast from the Dolphin 2.0 past is about to arrive'; cr*      r      preuninstallr       *      r      postinstallp  *      r      postuninstallp  �       `       �      �  r      Scribble test        � Presenter subclass: #ScribbleTest
	instanceVariableNames: 'scribblePresenter'
	classVariableNames: ''
	poolDictionaries: ''!

'end-class-definition'! X ResourceIdentifier    �       r      Scribble�  F    ViewResource    $ STBResourceSTBByteArrayAccessorProxy    6 	 ByteArray�  !STB 0 N    STBViewProxy     STBClassProxy    6  String   ContainerView&  Array           �      6  LargeInteger      D  `        RGB    �    �                   BorderLayout                          Z       z       �      ScribbleView�          `   �      �         D   @            �  �                                MessageSequence     STBCollectionProxy    z       �      OrderedCollection�       MessageSend     STBSymbolProxy    �      createAt:extent:�       Point    )   )   �      m  �  @  "      J      �      enable:�         @  "      J      �      contextMenu:�          @  "      J      �      text:�      �       @   WINDOWPLACEMENT    6 	 ByteArray,   ,          ����������������      J  �   �      �  �        STBIdentityDictionaryProxy    z       �      IdentityDictionary�  	 Rectangle    �      )   )   �      )   )   �      �      �  �      "      P  �      �            �      �  �  `   "      �  �         `   "         �          `   "      @  �      �       `   �      �  ,   ,           ����������������
   
   h    �      �  �      @   Icon           r      ContainerView.ico STBExternalResourceLibraryProxy    r      DolphinDevRes          �       r      ScribbleTestr      Default scribble test viewB      j      �  �  !STB 0 N    STBViewProxy     STBClassProxy    6  String   ContainerView&  Array           �      6  LargeInteger      D  `                           BorderLayout                          Z       z       �      ReferenceView�          `   �      �         D                             ResourceIdentifier    z       �      Scribble�      Scribble test     MessageSequence     STBCollectionProxy    z       �      OrderedCollection�       MessageSend     STBSymbolProxy    �      createAt:extent:�       Point          �      �  �     B      j      �      enable:�            B      j      �      contextMenu:�             B      j      �      text:�      �           WINDOWPLACEMENT    6 	 ByteArray,   ,          ����������������        ^  �   �        STBIdentityDictionaryProxy    z       �      IdentityDictionary�           �      �        �      B      p  �      �            �      �  �  `   B      �  �         `   B         �          `   B      `  �      �       `   �      �  ,   ,           ����������������
   
   h    �        �         �             r      ContainerView.ico�      

ScribbleTest class instanceVariableNames: ''!

ScribbleTest comment: ''!

!ScribbleTest categoriesForClass!No category! !

!ScribbleTest methodsFor!

a
	^'A'!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents. 
	scribblePresenter := self add: Scribble new name: 'scribble'.
!

model: aListModel
	"Connects the receiver to aListModel. Since the receiver has the same model as the
	sketch pad (Scribble) component that it holds we pass this down to it."

	super model: aListModel.
	scribblePresenter model: aListModel.! !

!ScribbleTest categoriesFor: #a!private! !
!ScribbleTest categoriesFor: #createComponents!initializing! !
!ScribbleTest categoriesFor: #model:!accessing! !

!ScribbleTest class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel with: OrderedCollection new!

defaultView
	"Answer the resource name of the default view for the receiver."

	^'Default scribble test view'! !

!ScribbleTest class categoriesFor: #defaultModel!no category! !
!ScribbleTest class categoriesFor: #defaultView!constants! !

!Scribble methodsFor!

looseA
	^#A! !

!Scribble categoriesFor: #looseA!no category! !

!Scribble methodsFor!

looseC
	^'C'! !

!Scribble categoriesFor: #looseC!no category! !

!ScribbleView methodsFor!

model: aListModel
	"Connect the receiver to aListModel"

	super model: aListModel.
	aListModel
		when: #item:addedAtIndex: send: #add:atIndex: to: self;
		when: #itemRemovedAtIndex: send: #invalidate to: self;
		when: #itemUpdatedAtIndex: send: #invalidate to: self! !

!ScribbleView categoriesFor: #model:!accessing! !

 