"Filed out from Dolphin Smalltalk 7"!

AbstractStringTest subclass: #MultiByteStringTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultiByteStringTest guid: (GUID fromString: '{f3d4f4a7-05b6-445f-8380-d0b838804877}')!
MultiByteStringTest isAbstract: true!
MultiByteStringTest comment: ''!
!MultiByteStringTest categoriesForClass!Unclassified! !
!MultiByteStringTest methodsFor!

caseConversionCases
	"
	Utf8StringTest new caseConversionCases collect: [:each | each collect: [:s | s asUtf8String ]]
	"

	^super caseConversionCases
		, (#(#(#[208 186 209 128 208 176 208 186 208 190 208 183 209 143 208 177 209 128 209 139] #[208 154 208 160 208 144 208 154 208 158 208 151 208 175 208 145 208 160 208 171]) #(#[230 150 135 229 173 151 229 140 150 227 129 145] #[230 150 135 229 173 151 229 140 150 227 129 145]) #(#[208 188 208 176 208 185 208 188 209 131 208 189 208 184 209 134 208 176] #[208 156 208 144 208 153 208 156 208 163 208 157 208 152 208 166 208 144]) #(#[239 189 129 239 189 130 239 189 131] #[239 188 161 239 188 162 239 188 163]))
				collect: [:pair | pair collect: [:each | Utf8String fromByteArray: each]])!

reverseTestCases
	"Private - #reverse doesn't work correctly for multi-byte encodings of UTF8 and UTF16."
	self skip.
	^super reverseTestCases
		, (#(#(#[16rF0 16r9F 16r8D 16rBA 16r20 16r61] #[16r61 16r20 16rF0 16r9F 16r8D 16rBA]) #(#[230 150 135 229 173 151 229 140 150 227 129 145] #[227 129 145 229 140 150 229 173 151 230 150 135]))
				collect: [:pair | pair collect: [:b | Utf8String fromByteArray: b]])! !
!MultiByteStringTest categoriesFor: #caseConversionCases!constants!private! !
!MultiByteStringTest categoriesFor: #reverseTestCases!private! !

