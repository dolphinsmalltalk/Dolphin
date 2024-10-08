!STB 0 F
    Package    6  String   HexdecimalBrowserr   A   C:\PDG\DOLPHIN\Packages\Hexadecimal Browser\HexdecimalBrowser.pacr     This package implements a version of a HexadecimalBrowser application that is compatible with the MVP framework in Dolphin Beta 2. The article "Using Dolphin Smalltalk" by Wilf LaLonde and John Pugh in the JOOP Feb 97 issue contains a description of the application written for Dolphin Beta 1. 

Most of the domain code in class HexadecimalConverter ported without change. The UI in Beta 2 is very different so class HexadecimalBrowser has been rewritten to be a subclass of Shell presenter (rather than Tool). The code in the article installed two lone methods, Integer>>printStringRadix:zeroPadTo: and Character>>isPrintable. The latter is no longer required since it exists in the base Dolphin image.

To bring up a hex file browser evaluate:

HexadecimalBrowser example. STBCollectionProxy     STBClassProxy    r      IdentitySet&  Array    STBSymbolProxy    r      HexadecimalConverter*      r      HexadecimalBrowser�       �       r      Set      Association    *      r      Integer*      r      printStringRadix:zeroPadTo:�       �         �       �        r      Dolphin     STBIdentityDictionaryProxy    �       r      IdentityDictionary     *      r      postinstallr   k   Notification signal: 'Installed HexadecimalBrowser: Please see package comments for notes on this release.'*      r      preuninstallr       *      r   
   preinstall   *      r      postuninstall   �       �     	    ResourceIdentifier    �       r      HexadecimalBrowserr      DefaultView ViewResource    $ STBResourceSTBByteArrayAccessorProxy    6 	 ByteArray�
  !STB 0 N    STBViewProxy     STBClassProxy    6  String	   ShellView&  Array           �       �  `                           BorderLayout          Z       z       �      Toolbar�          `   �      6  LargePositiveInteger   $ D           SystemColor                          R     �!¿ STBIdentityDictionaryProxy    z       �      IdentityDictionary�       �      �  �      C   ToolbarSystemButton                   CommandDescription     STBSymbolProxy    �      fileNew    �      New              E                      2      Z      �      fileOpen    �      Open              I                      2      Z      �      fileSave    �      Save               STBCollectionProxy    z       �      OrderedCollection�         �  �  �      z       �      LookupTable�             Bitmap           �      FINDBAR.BMP STBSingletonProxy    z       �   	   VMLibraryZ      �      default       1   �             �      DOLTBAR.BMP STBExternalResourceLibraryProxy    �      DolphinDevRes                           Point    !      �      -   -        MessageSequence    :      P  �       MessageSend    Z      �      createAt:extent:�      �            �      �  9            Z      �      enable:�                  Z      �      contextMenu:�                   Z      �      text:�      �                Z      �      tbSetBitmapSize:�      �           Z      �      tbSetButtonSize:�      �           Z      �   
   tbAutoSize�           WINDOWPLACEMENT    6 	 ByteArray,   ,          ����������������        �     :      P  �              Z       z       �      MultilineTextEdit�          `   �      R     D!D  `                      Font            LOGFONT    2  <   ����            �      1Courier New &:�MO��
�
&l4 :��      �   �       R     ҥ� NullConverter               �      :      P  �            0  �      �         9   �      �    `        �  �         `        �  �          `          �      �       `        Z      �      selectionRange:�       Interval             `        Z      �   
   setModify:�          `        2  ,   ,          ����������������       �  '  :      P  �  �      �  �      `  �      text                                �      :      P  �            0  �      �            �        �  `         �  �         `         �  �          `           �      �      Hexadecimal Browser`         Z      �      menuBar:�          `         2  ,   ,           ����������������
   
     L  :      P  �      `         !Integer methodsFor!

printStringRadix: base zeroPadTo: minimumSize
	"Answer a String which represents the receiver in the radix, base (an Integer).
	The radix prefix is not included. If the answer is shorter than minimumSize,
	it is padded with zeros."
	| answer |
	answer := self printStringRadix: base showRadix: false.
	answer size >= minimumSize ifTrue: [^answer].
	^(String new: minimumSize - answer size)
		atAllPut: $0;
		, answer! !

!Integer categoriesFor: #printStringRadix:zeroPadTo:!no category! !

 